import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/import_service.dart';

enum ImportItemStatus { waiting, working, done }

class ImportItem {
  const ImportItem(this.name, {this.status = ImportItemStatus.waiting, this.result});

  final String name;
  final ImportItemStatus status;
  final ImportResult? result;
}

class ImportState {
  const ImportState({this.items = const [], this.running = false, this.rescan});

  final List<ImportItem> items;
  final bool running;
  final RescanReport? rescan;

  int get completed => items.where((i) => i.status == ImportItemStatus.done).length;
  double get progress => items.isEmpty ? 0 : completed / items.length;

  int count(ImportOutcome o) => items.where((i) => i.result?.outcome == o).length;
}

/// Runs imports outside any one screen so closing a sheet never cancels them.
class ImportController extends Notifier<ImportState> {
  @override
  ImportState build() => const ImportState();

  /// Opens the system picker (scoped access — no broad storage permission).
  Future<bool> pickAndImport() async {
    final files = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ImportRules.supportedExtensions);
    if (files.isEmpty) return false;
    await importPicked(files);
    return true;
  }

  Future<void> importPicked(List<PlatformFile> files) async {
    if (state.running) return;
    state = ImportState(items: [for (final f in files) ImportItem(f.name)], running: true);
    final service = ref.read(importServiceProvider);
    for (var i = 0; i < files.length; i++) {
      _set(i, ImportItem(files[i].name, status: ImportItemStatus.working));
      final path = files[i].path;
      final ImportResult result;
      if (path == null) {
        result = ImportResult(
          name: files[i].name,
          outcome: ImportOutcome.failed,
          message: 'This file cannot be accessed.',
        );
      } else {
        result = await service.importFile(File(path), displayName: files[i].name);
      }
      _set(i, ImportItem(files[i].name, status: ImportItemStatus.done, result: result));
    }
    await FilePicker.clearTemporaryFiles().catchError((_) {});
    state = ImportState(items: state.items, running: false);
  }

  Future<RescanReport> rescan() async {
    state = const ImportState(running: true);
    final report = await ref.read(importServiceProvider).rescan();
    state = ImportState(running: false, rescan: report);
    return report;
  }

  void _set(int index, ImportItem item) {
    final items = [...state.items]..[index] = item;
    state = ImportState(items: items, running: true);
  }

  void clear() {
    if (!state.running) state = const ImportState();
  }
}

final importControllerProvider = NotifierProvider<ImportController, ImportState>(ImportController.new);
