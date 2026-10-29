import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../core/errors/app_exception.dart';
import '../../core/widgets/artwork_image.dart';
import '../../core/widgets/common.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/library_repository.dart';
import '../import_music/url_import_screen.dart';
import '../library/library_providers.dart';

/// Edits local metadata. The audio file itself is never modified.
class EditTrackScreen extends ConsumerWidget {
  const EditTrackScreen({super.key, required this.trackId});

  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(trackProvider(trackId));
    return AsyncView(
      value: track,
      loading: const Scaffold(body: Center(child: CircularProgressIndicator())),
      data: (t) => t == null
          ? Scaffold(
              appBar: AppBar(),
              body: const EmptyState(
                icon: Icons.music_off_rounded,
                title: 'Song not found',
                message: 'It may have been removed.',
              ),
            )
          : _EditForm(track: t),
    );
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const _EditForm({required this.track});

  final Track track;

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.track.title);
  late final _artist = TextEditingController(text: widget.track.artist);
  late final _album = TextEditingController(text: widget.track.album);
  late final _albumArtist = TextEditingController(text: widget.track.albumArtist);
  late final _genre = TextEditingController(text: widget.track.genre);
  late final _year = TextEditingController(text: widget.track.releaseYear?.toString());
  late final _composer = TextEditingController(text: widget.track.composer);
  late final _language = TextEditingController(text: widget.track.language);
  late bool _compilation = widget.track.isCompilation;
  Uint8List? _artwork;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_title, _artist, _album, _albumArtist, _genre, _year, _composer, _language]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final edit = TrackEdit(
        title: _title.text,
        artist: _artist.text,
        album: _album.text,
        albumArtist: _albumArtist.text,
        genre: _genre.text,
        releaseYear: int.tryParse(_year.text.trim()),
        composer: _composer.text,
        language: _language.text,
        isCompilation: _compilation,
        newArtwork: _artwork,
      );
      await ref.read(libraryRepositoryProvider).saveEdits(widget.track, edit);
      await ref.read(playbackControllerProvider).refreshTrack(widget.track.id);
      if (mounted) {
        showMessage(context, 'Saved');
        context.pop();
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickArtwork() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (bytes.length > 15 * 1024 * 1024) {
      if (mounted) showMessage(context, 'That image is too large (15 MB maximum).');
      return;
    }
    setState(() => _artwork = bytes);
  }

  Future<void> _lookup() async {
    final service = ref.read(onlineMetadataProvider);
    try {
      final results = await service.searchRecording(title: _title.text.trim(), artist: _artist.text.trim());
      if (!mounted) return;
      if (results.isEmpty) {
        showMessage(context, 'No matches found online. Your entries are unchanged.');
        return;
      }
      final chosen = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          builder: (context, c) => ListView(
            controller: c,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
                child: Text('Matches from MusicBrainz', style: context.text.titleLarge),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.page, vertical: Spacing.sm),
                child: Text('Choose one to fill in empty or incorrect fields. Nothing changes until you save.'),
              ),
              for (var i = 0; i < results.length; i++)
                ListTile(
                  title: Text(results[i].title),
                  subtitle: Text(
                    [results[i].artist, results[i].album, results[i].year?.toString()].whereType<String>().join(' · '),
                  ),
                  trailing: Text('${results[i].score}%'),
                  onTap: () => Navigator.pop(context, i),
                ),
            ],
          ),
        ),
      );
      if (chosen == null || !mounted) return;
      final c = results[chosen];
      setState(() {
        _title.text = c.title;
        if (c.artist != null) _artist.text = c.artist!;
        if (c.album != null) _album.text = c.album!;
        if (c.year != null) _year.text = '${c.year}';
      });
      if (c.releaseId != null) {
        final art = await service.coverArt(c.releaseId!);
        if (art != null && mounted) setState(() => _artwork = art);
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(settingsProvider.select((s) => s.onlineLookups));
    final edited = widget.track.overriddenFields.isNotEmpty;
    Widget field(
      TextEditingController c,
      String label, {
      String? Function(String?)? validator,
      TextInputType? keyboard,
      String? helper,
    }) => Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        validator: validator,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: label, helperText: helper),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit info'),
        actions: [TextButton(onPressed: _saving ? null : _save, child: const Text('Save'))],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            Spacing.page,
            Spacing.md,
            Spacing.page,
            Spacing.xl + MediaQuery.viewInsetsOf(context).bottom,
          ),
          children: [
            Center(
              child: Stack(
                children: [
                  _artwork != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(Radii.lg),
                          child: Image.memory(_artwork!, width: 160, height: 160, fit: BoxFit.cover, cacheWidth: 480),
                        )
                      : ArtworkImage(
                          artworkKey: widget.track.artworkKey,
                          size: 160,
                          radius: Radii.lg,
                          seed: widget.track.title,
                        ),
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: IconButton.filled(
                      tooltip: 'Change artwork',
                      icon: const Icon(Icons.image_rounded),
                      onPressed: _pickArtwork,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'Changes are saved in Music only. The original audio file and its embedded tags are not modified.',
              textAlign: TextAlign.center,
              style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
            ),
            if (online)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.md),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.travel_explore_rounded),
                  label: const Text('Look up online (MusicBrainz)'),
                  onPressed: _lookup,
                ),
              ),
            const SizedBox(height: Spacing.lg),
            field(_title, 'Title', validator: (v) => (v == null || v.trim().isEmpty) ? 'A title is required' : null),
            field(_artist, 'Artist', helper: 'Separate multiple artists with ";"'),
            field(_album, 'Album'),
            field(_albumArtist, 'Album artist'),
            field(_genre, 'Genre'),
            field(
              _year,
              'Release year',
              keyboard: TextInputType.number,
              helper: 'The year the song was released — not when you imported it',
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final y = int.tryParse(v.trim());
                return y == null || y < 1900 || y > DateTime.now().year + 1
                    ? 'Enter a year between 1900 and ${DateTime.now().year + 1}'
                    : null;
              },
            ),
            field(_composer, 'Composer'),
            field(_language, 'Language', helper: 'For example English or Kannada'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Part of a compilation'),
              subtitle: const Text('Shows the album under Compilations'),
              value: _compilation,
              onChanged: (v) => setState(() => _compilation = v),
            ),
            if (edited) ...[
              const Divider(),
              TextButton.icon(
                icon: const Icon(Icons.restore_rounded),
                label: const Text('Restore info from the file'),
                onPressed: () async {
                  final ok = await confirm(
                    context,
                    title: 'Restore file info?',
                    message: 'Your edits to this song will be replaced with the tags embedded in the file.',
                    confirmLabel: 'Restore',
                  );
                  if (!ok) return;
                  await ref.read(libraryRepositoryProvider).revertToEmbedded(widget.track);
                  await ref.read(playbackControllerProvider).refreshTrack(widget.track.id);
                  if (context.mounted) context.pop();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
