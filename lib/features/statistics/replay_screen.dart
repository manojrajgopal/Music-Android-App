import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/artwork_image.dart';
import '../../core/widgets/common.dart';
import '../../data/database/app_database.dart';
import '../library/library_providers.dart';
import 'stats_calculator.dart';

enum ReplayPeriod { week, month, year, allTime }

typedef ReplayArgs = ({ReplayPeriod period, int offset});

(DateTime, DateTime) periodRange(ReplayPeriod period, int offset, DateTime now) {
  final today = localDay(now);
  switch (period) {
    case ReplayPeriod.week:
      final start = startOfLocalWeek(now).add(Duration(days: 7 * offset));
      return (start, DateTime(start.year, start.month, start.day + 7));
    case ReplayPeriod.month:
      final start = DateTime(today.year, today.month + offset);
      return (start, DateTime(start.year, start.month + 1));
    case ReplayPeriod.year:
      final start = DateTime(today.year + offset);
      return (start, DateTime(start.year + 1));
    case ReplayPeriod.allTime:
      return (DateTime(2000), DateTime(today.year, today.month, today.day + 1));
  }
}

final allHistoryProvider = StreamProvider<List<PlaybackRecord>>(
  (ref) => ref.watch(databaseProvider).historyDao.watchAllRecords(),
);

final _trackMap = Provider<Map<String, Track>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  return {for (final t in tracks) t.id: t};
});

final replaySummaryProvider = Provider.family<ReplaySummary?, ReplayArgs>((ref, args) {
  final records = ref.watch(allHistoryProvider).value;
  if (records == null) return null;
  final now = DateTime.now();
  var (from, to) = periodRange(args.period, args.offset, now);
  if (args.period == ReplayPeriod.allTime && records.isNotEmpty) from = localDay(records.first.startedAt);
  return const StatsCalculator().summarize(records, ref.watch(_trackMap), from: from, to: to);
});

class ReplayScreen extends ConsumerStatefulWidget {
  const ReplayScreen({super.key});

  @override
  ConsumerState<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends ConsumerState<ReplayScreen> {
  ReplayPeriod _period = ReplayPeriod.month;
  int _offset = 0;

  String _label(DateTime from, DateTime to) => switch (_period) {
    ReplayPeriod.week =>
      '${DateFormat.MMMd().format(from)} – ${DateFormat.MMMd().format(to.subtract(const Duration(days: 1)))}',
    ReplayPeriod.month => DateFormat.yMMMM().format(from),
    ReplayPeriod.year => '${from.year}',
    ReplayPeriod.allTime => 'All time',
  };

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(allHistoryProvider);
    final summary = ref.watch(replaySummaryProvider((period: _period, offset: _offset)));
    final (from, to) = periodRange(_period, _offset, DateTime.now());
    const calc = StatsCalculator();

    return Scaffold(
      body: AsyncView(
        value: records,
        data: (all) {
          if (all.isEmpty) {
            return CustomScrollView(
              slivers: [
                const SliverAppBar(pinned: true, title: Text('Replay')),
                const SliverToBoxAdapter(
                  child: EmptyState(
                    icon: Icons.insights_rounded,
                    title: 'Replay: Your Top Music',
                    message:
                        'Your statistics will appear after you listen. A song counts as played after 30 seconds '
                        '(or half of a shorter song); paused time never counts.',
                  ),
                ),
              ],
            );
          }
          final now = DateTime.now();
          final streak = calc.streaks(all, now: now);
          final allTime = calc.summarize(
            all,
            ref.watch(_trackMap),
            from: localDay(all.first.startedAt),
            to: now.add(const Duration(days: 1)),
          );
          final milestones = calc.milestones(
            totalMs: allTime.totalListenedMs,
            plays: allTime.plays,
            distinctTracks: allTime.distinctTracks,
            streak: streak,
          );
          int sumSince(DateTime d) => all.where((r) => !r.startedAt.isBefore(d)).fold(0, (s, r) => s + r.listenedMs);

          return CustomScrollView(
            slivers: [
              SliverAppBar.large(title: const Text('Replay: Your Top Music')),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
                  child: Wrap(
                    spacing: Spacing.md,
                    runSpacing: Spacing.md,
                    children: [
                      _Stat('Today', formatListening(sumSince(localDay(now)))),
                      _Stat('This week', formatListening(sumSince(startOfLocalWeek(now)))),
                      _Stat('This month', formatListening(sumSince(DateTime(now.year, now.month)))),
                      _Stat('This year', formatListening(sumSince(DateTime(now.year)))),
                      _Stat('Current streak', '${streak.current} day${streak.current == 1 ? '' : 's'}'),
                      _Stat('Longest streak', '${streak.longest} day${streak.longest == 1 ? '' : 's'}'),
                    ],
                  ),
                ),
              ),
              if (milestones.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SectionHeader(title: 'Milestones')),
                SliverToBoxAdapter(
                  child: HorizontalCarousel(
                    height: 96,
                    itemCount: milestones.length,
                    itemBuilder: (context, i) => Container(
                      width: 220,
                      padding: const EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Radii.lg),
                        gradient: LinearGradient(
                          colors: [context.colors.primary.withValues(alpha: 0.35), context.surfaces.raised],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.emoji_events_rounded),
                          Text(milestones[i].title, style: context.text.titleSmall),
                          Text(
                            milestones[i].detail,
                            style: context.text.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Spacing.page, Spacing.xl, Spacing.page, 0),
                  child: SegmentedButton<ReplayPeriod>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: ReplayPeriod.week, label: Text('Week')),
                      ButtonSegment(value: ReplayPeriod.month, label: Text('Month')),
                      ButtonSegment(value: ReplayPeriod.year, label: Text('Year')),
                      ButtonSegment(value: ReplayPeriod.allTime, label: Text('All')),
                    ],
                    selected: {_period},
                    onSelectionChanged: (v) => setState(() => (_period = v.first, _offset = 0)),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Previous period',
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: _period == ReplayPeriod.allTime ? null : () => setState(() => _offset--),
                    ),
                    Expanded(
                      child: Text(_label(from, to), textAlign: TextAlign.center, style: context.text.titleMedium),
                    ),
                    IconButton(
                      tooltip: 'Next period',
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: _period == ReplayPeriod.allTime || _offset >= 0
                          ? null
                          : () => setState(() => _offset++),
                    ),
                  ],
                ),
              ),
              if (summary == null || summary.isEmpty)
                const SliverToBoxAdapter(
                  child: EmptyState(
                    icon: Icons.hourglass_empty_rounded,
                    title: 'No listening in this period',
                    message: 'Choose another period or play some music.',
                    compact: true,
                  ),
                )
              else ...[
                SliverToBoxAdapter(child: _Recap(summary: summary)),
                if (summary.daily.length > 1) SliverToBoxAdapter(child: _DailyChart(daily: summary.daily)),
                ..._ranked(context, 'Top Songs', summary.topTracks, Icons.music_note_rounded),
                ..._ranked(context, 'Top Artists', summary.topArtists, Icons.person_rounded, circle: true),
                ..._ranked(context, 'Top Albums', summary.topAlbums, Icons.album_rounded),
                ..._ranked(context, 'Top Genres', summary.topGenres, Icons.category_rounded),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: Spacing.xxl)),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _ranked(
    BuildContext context,
    String title,
    List<RankedItem> items,
    IconData icon, {
    bool circle = false,
  }) {
    if (items.isEmpty) return const [];
    return [
      SliverToBoxAdapter(
        child: SectionHeader(title: title, subtitle: 'By counted plays, then listening time'),
      ),
      SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 28,
                  child: Text('${i + 1}', style: context.text.titleMedium, textAlign: TextAlign.center),
                ),
                const SizedBox(width: Spacing.sm),
                ArtworkImage(
                  artworkKey: item.artworkKey,
                  size: 44,
                  radius: Radii.sm,
                  circle: circle,
                  icon: icon,
                  seed: item.label,
                ),
              ],
            ),
            title: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              [?item.subtitle, '${item.plays} plays', formatListening(item.listenedMs)].join(' · '),
              maxLines: 1,
            ),
          );
        },
      ),
    ];
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    width: 160,
    padding: const EdgeInsets.all(Spacing.md),
    decoration: BoxDecoration(color: context.surfaces.raised, borderRadius: BorderRadius.circular(Radii.lg)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.bodySmall?.copyWith(color: context.surfaces.muted)),
        Text(value, style: context.text.titleLarge),
      ],
    ),
  );
}

class _Recap extends StatelessWidget {
  const _Recap({required this.summary});

  final ReplaySummary summary;

  @override
  Widget build(BuildContext context) {
    final top = summary.topTracks.firstOrNull;
    final artist = summary.topArtists.firstOrNull;
    final genre = summary.topGenres.firstOrNull;
    return Padding(
      padding: const EdgeInsets.all(Spacing.page),
      child: Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.colors.primary.withValues(alpha: 0.45), context.surfaces.raised],
          ),
        ),
        child: Row(
          children: [
            ArtworkImage(artworkKey: top?.artworkKey, size: 96, radius: Radii.md, seed: top?.label),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatListening(summary.totalListenedMs), style: context.text.headlineMedium),
                  Text(
                    '${summary.plays} plays · ${summary.distinctTracks} different songs',
                    style: context.text.bodySmall,
                  ),
                  const SizedBox(height: Spacing.sm),
                  if (top != null) Text('Top song: ${top.label}', maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (artist != null) Text('Top artist: ${artist.label}', maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (genre != null)
                    Text('Favorite genre: ${genre.label}', maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact bar chart of listening per day.
class _DailyChart extends StatelessWidget {
  const _DailyChart({required this.daily});

  final Map<DateTime, int> daily;

  @override
  Widget build(BuildContext context) {
    final entries = daily.entries.toList();
    final shown = entries.length > 62 ? _weekly(entries) : entries;
    final max = shown.fold<int>(0, (m, e) => math.max(m, e.value));
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.page, 0, Spacing.page, Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entries.length > 62 ? 'Listening per week' : 'Listening per day', style: context.text.titleSmall),
          const SizedBox(height: Spacing.sm),
          Semantics(
            label: 'Chart of listening time. Peak ${formatListening(max)}.',
            child: SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final e in shown)
                    Expanded(
                      child: Tooltip(
                        message: '${DateFormat.MMMd().format(e.key)}: ${formatListening(e.value)}',
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          height: max == 0 ? 2 : math.max(2, 118 * e.value / max),
                          decoration: BoxDecoration(
                            color: e.value == 0 ? context.surfaces.divider : context.colors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<MapEntry<DateTime, int>> _weekly(List<MapEntry<DateTime, int>> days) {
    final weeks = <DateTime, int>{};
    for (final e in days) {
      final w = startOfLocalWeek(e.key);
      weeks[w] = (weeks[w] ?? 0) + e.value;
    }
    return weeks.entries.toList();
  }
}
