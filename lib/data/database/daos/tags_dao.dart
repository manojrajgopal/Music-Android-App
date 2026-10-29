import 'package:drift/drift.dart';

import '../app_database.dart';

part 'tags_dao.g.dart';

@DriftAccessor(tables: [Tags, TrackTags, Tracks])
class TagsDao extends DatabaseAccessor<AppDatabase> with _$TagsDaoMixin {
  TagsDao(super.attachedDatabase);

  Stream<List<Tag>> watchTags(TagKind kind) =>
      (select(tags)
            ..where((t) => t.kind.equalsValue(kind))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<List<Tag>> allTags() => select(tags).get();

  Future<Tag> ensureTag(String name, TagKind kind) async {
    await into(tags).insert(
      TagsCompanion.insert(name: name, kind: kind),
      mode: InsertMode.insertOrIgnore,
    );
    return (select(tags)..where((t) => t.name.equals(name) & t.kind.equalsValue(kind))).getSingle();
  }

  Future<void> deleteTag(int id) => (delete(tags)..where((t) => t.id.equals(id))).go();

  /// Tags directly attached to a track (excluding mood exclusions).
  Stream<List<Tag>> watchTagsForTrack(String trackId) {
    final query = select(tags).join([innerJoin(trackTags, trackTags.tagId.equalsExp(tags.id))])
      ..where(trackTags.trackId.equals(trackId) & trackTags.excluded.equals(false))
      ..orderBy([OrderingTerm.asc(tags.name)]);
    return query.map((r) => r.readTable(tags)).watch();
  }

  Future<void> setMembership(String trackId, int tagId, {required bool member}) =>
      into(trackTags)
          .insertOnConflictUpdate(TrackTagsCompanion.insert(trackId: trackId, tagId: tagId, excluded: Value(!member)));

  Future<void> clearMembership(String trackId, int tagId) =>
      (delete(trackTags)..where((t) => t.trackId.equals(trackId) & t.tagId.equals(tagId))).go();

  Stream<List<TrackTag>> watchMemberships() => select(trackTags).watch();

  Future<List<TrackTag>> allMemberships() => select(trackTags).get();

  Stream<List<Track>> watchTracksWithTag(int tagId) {
    final query = select(tracks).join([innerJoin(trackTags, trackTags.trackId.equalsExp(tracks.id))])
      ..where(trackTags.tagId.equals(tagId) & trackTags.excluded.equals(false))
      ..orderBy([OrderingTerm.asc(tracks.titleKey)]);
    return query.map((r) => r.readTable(tracks)).watch();
  }
}
