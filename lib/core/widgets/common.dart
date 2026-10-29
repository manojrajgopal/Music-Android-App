import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../errors/app_exception.dart';

/// Section title with an optional "See All" action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle, this.onSeeAll, this.trailing});

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.page, Spacing.xl, Spacing.sm, Spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(header: true, child: Text(title, style: context.text.titleLarge)),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(subtitle!, style: context.text.bodySmall?.copyWith(color: context.surfaces.muted)),
                  ),
              ],
            ),
          ),
          ?trailing,
          if (onSeeAll != null) TextButton(onPressed: onSeeAll, child: const Text('See All')),
        ],
      ),
    );
  }
}

/// A horizontally scrolling row. Its own scroll view prevents the page from
/// scrolling sideways.
class HorizontalCarousel extends StatelessWidget {
  const HorizontalCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.height,
    this.spacing = Spacing.md,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double height;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(width: spacing),
        itemBuilder: itemBuilder,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.xl, vertical: compact ? Spacing.lg : Spacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(compact ? Spacing.md : Spacing.lg),
            decoration: BoxDecoration(color: context.colors.primary.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, size: compact ? 28 : 40, color: context.colors.primary),
          ),
          const SizedBox(height: Spacing.lg),
          Text(title, style: context.text.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: Spacing.sm),
          Text(
            message,
            style: context.text.bodyMedium?.copyWith(color: context.surfaces.muted),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[const SizedBox(height: Spacing.lg), action!],
        ],
      ),
    );
  }
}

/// Renders an [AsyncValue] with consistent loading and error states.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.data, this.loading, this.sliver = false});

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final widget = switch (value) {
      AsyncValue(:final value?, hasValue: true) => data(value),
      AsyncValue(:final error?) => EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Could not load',
        message: friendlyError(error),
        compact: true,
      ),
      _ =>
        loading ??
            const Padding(
              padding: EdgeInsets.all(Spacing.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
    };
    return sliver ? SliverToBoxAdapter(child: widget) : widget;
  }
}

/// Shimmer-free skeleton block for loading rows.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, required this.width, required this.height, this.radius = Radii.md});

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(color: context.surfaces.overlay, borderRadius: BorderRadius.circular(radius)),
  );
}

Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: context.colors.error, foregroundColor: context.colors.onError)
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<String?> promptText(
  BuildContext context, {
  required String title,
  String? initial,
  String hint = '',
  String confirmLabel = 'Save',
  int maxLength = 120,
}) => showDialog<String>(
  context: context,
  builder: (_) =>
      _TextPrompt(title: title, initial: initial, hint: hint, confirmLabel: confirmLabel, maxLength: maxLength),
);

class _TextPrompt extends StatefulWidget {
  const _TextPrompt({
    required this.title,
    required this.initial,
    required this.hint,
    required this.confirmLabel,
    required this.maxLength,
  });

  final String title;
  final String? initial;
  final String hint;
  final String confirmLabel;
  final int maxLength;

  @override
  State<_TextPrompt> createState() => _TextPromptState();
}

class _TextPromptState extends State<_TextPrompt> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    Navigator.pop(context, value.isEmpty ? null : value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      controller: _controller,
      autofocus: true,
      maxLength: widget.maxLength,
      decoration: InputDecoration(hintText: widget.hint),
      onSubmitted: (_) => _submit(),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
    ],
  );
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
