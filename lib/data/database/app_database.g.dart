// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TracksTable extends Tracks with TableInfo<$TracksTable, Track> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUriMeta = const VerificationMeta('sourceUri');
  @override
  late final GeneratedColumn<String> sourceUri = GeneratedColumn<String>(
    'source_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TrackSourceType, int> sourceType = GeneratedColumn<int>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<TrackSourceType>($TracksTable.$convertersourceType);
  static const VerificationMeta _originalFileNameMeta = const VerificationMeta('originalFileName');
  @override
  late final GeneratedColumn<String> originalFileName = GeneratedColumn<String>(
    'original_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<String> album = GeneratedColumn<String>(
    'album',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumArtistMeta = const VerificationMeta('albumArtist');
  @override
  late final GeneratedColumn<String> albumArtist = GeneratedColumn<String>(
    'album_artist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _composerMeta = const VerificationMeta('composer');
  @override
  late final GeneratedColumn<String> composer = GeneratedColumn<String>(
    'composer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseYearMeta = const VerificationMeta('releaseYear');
  @override
  late final GeneratedColumn<int> releaseYear = GeneratedColumn<int>(
    'release_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta('durationMs');
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackNumberMeta = const VerificationMeta('trackNumber');
  @override
  late final GeneratedColumn<int> trackNumber = GeneratedColumn<int>(
    'track_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discNumberMeta = const VerificationMeta('discNumber');
  @override
  late final GeneratedColumn<int> discNumber = GeneratedColumn<int>(
    'disc_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artworkKeyMeta = const VerificationMeta('artworkKey');
  @override
  late final GeneratedColumn<String> artworkKey = GeneratedColumn<String>(
    'artwork_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta('fileSizeBytes');
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta('fileHash');
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta('dateAdded');
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta('lastModified');
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta('lastPlayedAt');
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _playCountMeta = const VerificationMeta('playCount');
  @override
  late final GeneratedColumn<int> playCount = GeneratedColumn<int>(
    'play_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _skipCountMeta = const VerificationMeta('skipCount');
  @override
  late final GeneratedColumn<int> skipCount = GeneratedColumn<int>(
    'skip_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataSourceMeta = const VerificationMeta('metadataSource');
  @override
  late final GeneratedColumn<String> metadataSource = GeneratedColumn<String>(
    'metadata_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('embedded'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Availability, int> availability = GeneratedColumn<int>(
    'availability',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  ).withConverter<Availability>($TracksTable.$converteravailability);
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isCompilationMeta = const VerificationMeta('isCompilation');
  @override
  late final GeneratedColumn<bool> isCompilation = GeneratedColumn<bool>(
    'is_compilation',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_compilation" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastPositionMsMeta = const VerificationMeta('lastPositionMs');
  @override
  late final GeneratedColumn<int> lastPositionMs = GeneratedColumn<int>(
    'last_position_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overriddenFieldsMeta = const VerificationMeta('overriddenFields');
  @override
  late final GeneratedColumn<String> overriddenFields = GeneratedColumn<String>(
    'overridden_fields',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _titleKeyMeta = const VerificationMeta('titleKey');
  @override
  late final GeneratedColumn<String> titleKey = GeneratedColumn<String>(
    'title_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistKeyMeta = const VerificationMeta('artistKey');
  @override
  late final GeneratedColumn<String> artistKey = GeneratedColumn<String>(
    'artist_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _albumKeyMeta = const VerificationMeta('albumKey');
  @override
  late final GeneratedColumn<String> albumKey = GeneratedColumn<String>(
    'album_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchTextMeta = const VerificationMeta('searchText');
  @override
  late final GeneratedColumn<String> searchText = GeneratedColumn<String>(
    'search_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceUri,
    sourceType,
    originalFileName,
    title,
    artist,
    album,
    albumArtist,
    genre,
    language,
    composer,
    releaseYear,
    durationMs,
    trackNumber,
    discNumber,
    artworkKey,
    fileSizeBytes,
    fileHash,
    dateAdded,
    lastModified,
    lastPlayedAt,
    playCount,
    skipCount,
    rating,
    metadataSource,
    availability,
    isFavorite,
    isCompilation,
    lastPositionMs,
    overriddenFields,
    titleKey,
    artistKey,
    albumKey,
    searchText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracks';
  @override
  VerificationContext validateIntegrity(Insertable<Track> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_uri')) {
      context.handle(_sourceUriMeta, sourceUri.isAcceptableOrUnknown(data['source_uri']!, _sourceUriMeta));
    } else if (isInserting) {
      context.missing(_sourceUriMeta);
    }
    if (data.containsKey('original_file_name')) {
      context.handle(
        _originalFileNameMeta,
        originalFileName.isAcceptableOrUnknown(data['original_file_name']!, _originalFileNameMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta, artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    }
    if (data.containsKey('album')) {
      context.handle(_albumMeta, album.isAcceptableOrUnknown(data['album']!, _albumMeta));
    }
    if (data.containsKey('album_artist')) {
      context.handle(_albumArtistMeta, albumArtist.isAcceptableOrUnknown(data['album_artist']!, _albumArtistMeta));
    }
    if (data.containsKey('genre')) {
      context.handle(_genreMeta, genre.isAcceptableOrUnknown(data['genre']!, _genreMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta, language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('composer')) {
      context.handle(_composerMeta, composer.isAcceptableOrUnknown(data['composer']!, _composerMeta));
    }
    if (data.containsKey('release_year')) {
      context.handle(_releaseYearMeta, releaseYear.isAcceptableOrUnknown(data['release_year']!, _releaseYearMeta));
    }
    if (data.containsKey('duration_ms')) {
      context.handle(_durationMsMeta, durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta));
    }
    if (data.containsKey('track_number')) {
      context.handle(_trackNumberMeta, trackNumber.isAcceptableOrUnknown(data['track_number']!, _trackNumberMeta));
    }
    if (data.containsKey('disc_number')) {
      context.handle(_discNumberMeta, discNumber.isAcceptableOrUnknown(data['disc_number']!, _discNumberMeta));
    }
    if (data.containsKey('artwork_key')) {
      context.handle(_artworkKeyMeta, artworkKey.isAcceptableOrUnknown(data['artwork_key']!, _artworkKeyMeta));
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(data['file_size_bytes']!, _fileSizeBytesMeta),
      );
    }
    if (data.containsKey('file_hash')) {
      context.handle(_fileHashMeta, fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta));
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('date_added')) {
      context.handle(_dateAddedMeta, dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta));
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(_lastModifiedMeta, lastModified.isAcceptableOrUnknown(data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('last_played_at')) {
      context.handle(_lastPlayedAtMeta, lastPlayedAt.isAcceptableOrUnknown(data['last_played_at']!, _lastPlayedAtMeta));
    }
    if (data.containsKey('play_count')) {
      context.handle(_playCountMeta, playCount.isAcceptableOrUnknown(data['play_count']!, _playCountMeta));
    }
    if (data.containsKey('skip_count')) {
      context.handle(_skipCountMeta, skipCount.isAcceptableOrUnknown(data['skip_count']!, _skipCountMeta));
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta, rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    }
    if (data.containsKey('metadata_source')) {
      context.handle(
        _metadataSourceMeta,
        metadataSource.isAcceptableOrUnknown(data['metadata_source']!, _metadataSourceMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(_isFavoriteMeta, isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('is_compilation')) {
      context.handle(
        _isCompilationMeta,
        isCompilation.isAcceptableOrUnknown(data['is_compilation']!, _isCompilationMeta),
      );
    }
    if (data.containsKey('last_position_ms')) {
      context.handle(
        _lastPositionMsMeta,
        lastPositionMs.isAcceptableOrUnknown(data['last_position_ms']!, _lastPositionMsMeta),
      );
    }
    if (data.containsKey('overridden_fields')) {
      context.handle(
        _overriddenFieldsMeta,
        overriddenFields.isAcceptableOrUnknown(data['overridden_fields']!, _overriddenFieldsMeta),
      );
    }
    if (data.containsKey('title_key')) {
      context.handle(_titleKeyMeta, titleKey.isAcceptableOrUnknown(data['title_key']!, _titleKeyMeta));
    } else if (isInserting) {
      context.missing(_titleKeyMeta);
    }
    if (data.containsKey('artist_key')) {
      context.handle(_artistKeyMeta, artistKey.isAcceptableOrUnknown(data['artist_key']!, _artistKeyMeta));
    } else if (isInserting) {
      context.missing(_artistKeyMeta);
    }
    if (data.containsKey('album_key')) {
      context.handle(_albumKeyMeta, albumKey.isAcceptableOrUnknown(data['album_key']!, _albumKeyMeta));
    } else if (isInserting) {
      context.missing(_albumKeyMeta);
    }
    if (data.containsKey('search_text')) {
      context.handle(_searchTextMeta, searchText.isAcceptableOrUnknown(data['search_text']!, _searchTextMeta));
    } else if (isInserting) {
      context.missing(_searchTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Track map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Track(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceUri: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source_uri'])!,
      sourceType: $TracksTable.$convertersourceType.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}source_type'])!,
      ),
      originalFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_file_name'],
      ),
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      artist: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}artist']),
      album: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}album']),
      albumArtist: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}album_artist']),
      genre: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}genre']),
      language: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}language']),
      composer: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}composer']),
      releaseYear: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}release_year']),
      durationMs: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}duration_ms']),
      trackNumber: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}track_number']),
      discNumber: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}disc_number']),
      artworkKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}artwork_key']),
      fileSizeBytes: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}file_size_bytes']),
      fileHash: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}file_hash'])!,
      dateAdded: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}date_added'])!,
      lastModified: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}last_modified']),
      lastPlayedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}last_played_at']),
      playCount: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}play_count'])!,
      skipCount: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}skip_count'])!,
      rating: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}rating']),
      metadataSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_source'],
      )!,
      availability: $TracksTable.$converteravailability.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}availability'])!,
      ),
      isFavorite: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      isCompilation: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_compilation'])!,
      lastPositionMs: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}last_position_ms']),
      overriddenFields: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overridden_fields'],
      )!,
      titleKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title_key'])!,
      artistKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}artist_key'])!,
      albumKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}album_key'])!,
      searchText: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}search_text'])!,
    );
  }

  @override
  $TracksTable createAlias(String alias) {
    return $TracksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TrackSourceType, int, int> $convertersourceType = const EnumIndexConverter<TrackSourceType>(
    TrackSourceType.values,
  );
  static JsonTypeConverter2<Availability, int, int> $converteravailability = const EnumIndexConverter<Availability>(
    Availability.values,
  );
}

class Track extends DataClass implements Insertable<Track> {
  final String id;
  final String sourceUri;
  final TrackSourceType sourceType;
  final String? originalFileName;
  final String title;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final String? genre;
  final String? language;
  final String? composer;
  final int? releaseYear;
  final int? durationMs;
  final int? trackNumber;
  final int? discNumber;
  final String? artworkKey;
  final int? fileSizeBytes;
  final String fileHash;
  final DateTime dateAdded;
  final DateTime? lastModified;
  final DateTime? lastPlayedAt;
  final int playCount;
  final int skipCount;
  final int? rating;
  final String metadataSource;
  final Availability availability;
  final bool isFavorite;
  final bool isCompilation;
  final int? lastPositionMs;

  /// Comma separated [TrackField] names edited by the user.
  final String overriddenFields;
  final String titleKey;
  final String artistKey;
  final String albumKey;
  final String searchText;
  const Track({
    required this.id,
    required this.sourceUri,
    required this.sourceType,
    this.originalFileName,
    required this.title,
    this.artist,
    this.album,
    this.albumArtist,
    this.genre,
    this.language,
    this.composer,
    this.releaseYear,
    this.durationMs,
    this.trackNumber,
    this.discNumber,
    this.artworkKey,
    this.fileSizeBytes,
    required this.fileHash,
    required this.dateAdded,
    this.lastModified,
    this.lastPlayedAt,
    required this.playCount,
    required this.skipCount,
    this.rating,
    required this.metadataSource,
    required this.availability,
    required this.isFavorite,
    required this.isCompilation,
    this.lastPositionMs,
    required this.overriddenFields,
    required this.titleKey,
    required this.artistKey,
    required this.albumKey,
    required this.searchText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_uri'] = Variable<String>(sourceUri);
    {
      map['source_type'] = Variable<int>($TracksTable.$convertersourceType.toSql(sourceType));
    }
    if (!nullToAbsent || originalFileName != null) {
      map['original_file_name'] = Variable<String>(originalFileName);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    if (!nullToAbsent || album != null) {
      map['album'] = Variable<String>(album);
    }
    if (!nullToAbsent || albumArtist != null) {
      map['album_artist'] = Variable<String>(albumArtist);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || composer != null) {
      map['composer'] = Variable<String>(composer);
    }
    if (!nullToAbsent || releaseYear != null) {
      map['release_year'] = Variable<int>(releaseYear);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || trackNumber != null) {
      map['track_number'] = Variable<int>(trackNumber);
    }
    if (!nullToAbsent || discNumber != null) {
      map['disc_number'] = Variable<int>(discNumber);
    }
    if (!nullToAbsent || artworkKey != null) {
      map['artwork_key'] = Variable<String>(artworkKey);
    }
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    map['file_hash'] = Variable<String>(fileHash);
    map['date_added'] = Variable<DateTime>(dateAdded);
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<DateTime>(lastModified);
    }
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    }
    map['play_count'] = Variable<int>(playCount);
    map['skip_count'] = Variable<int>(skipCount);
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    map['metadata_source'] = Variable<String>(metadataSource);
    {
      map['availability'] = Variable<int>($TracksTable.$converteravailability.toSql(availability));
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_compilation'] = Variable<bool>(isCompilation);
    if (!nullToAbsent || lastPositionMs != null) {
      map['last_position_ms'] = Variable<int>(lastPositionMs);
    }
    map['overridden_fields'] = Variable<String>(overriddenFields);
    map['title_key'] = Variable<String>(titleKey);
    map['artist_key'] = Variable<String>(artistKey);
    map['album_key'] = Variable<String>(albumKey);
    map['search_text'] = Variable<String>(searchText);
    return map;
  }

  TracksCompanion toCompanion(bool nullToAbsent) {
    return TracksCompanion(
      id: Value(id),
      sourceUri: Value(sourceUri),
      sourceType: Value(sourceType),
      originalFileName: originalFileName == null && nullToAbsent ? const Value.absent() : Value(originalFileName),
      title: Value(title),
      artist: artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      album: album == null && nullToAbsent ? const Value.absent() : Value(album),
      albumArtist: albumArtist == null && nullToAbsent ? const Value.absent() : Value(albumArtist),
      genre: genre == null && nullToAbsent ? const Value.absent() : Value(genre),
      language: language == null && nullToAbsent ? const Value.absent() : Value(language),
      composer: composer == null && nullToAbsent ? const Value.absent() : Value(composer),
      releaseYear: releaseYear == null && nullToAbsent ? const Value.absent() : Value(releaseYear),
      durationMs: durationMs == null && nullToAbsent ? const Value.absent() : Value(durationMs),
      trackNumber: trackNumber == null && nullToAbsent ? const Value.absent() : Value(trackNumber),
      discNumber: discNumber == null && nullToAbsent ? const Value.absent() : Value(discNumber),
      artworkKey: artworkKey == null && nullToAbsent ? const Value.absent() : Value(artworkKey),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent ? const Value.absent() : Value(fileSizeBytes),
      fileHash: Value(fileHash),
      dateAdded: Value(dateAdded),
      lastModified: lastModified == null && nullToAbsent ? const Value.absent() : Value(lastModified),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent ? const Value.absent() : Value(lastPlayedAt),
      playCount: Value(playCount),
      skipCount: Value(skipCount),
      rating: rating == null && nullToAbsent ? const Value.absent() : Value(rating),
      metadataSource: Value(metadataSource),
      availability: Value(availability),
      isFavorite: Value(isFavorite),
      isCompilation: Value(isCompilation),
      lastPositionMs: lastPositionMs == null && nullToAbsent ? const Value.absent() : Value(lastPositionMs),
      overriddenFields: Value(overriddenFields),
      titleKey: Value(titleKey),
      artistKey: Value(artistKey),
      albumKey: Value(albumKey),
      searchText: Value(searchText),
    );
  }

  factory Track.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Track(
      id: serializer.fromJson<String>(json['id']),
      sourceUri: serializer.fromJson<String>(json['sourceUri']),
      sourceType: $TracksTable.$convertersourceType.fromJson(serializer.fromJson<int>(json['sourceType'])),
      originalFileName: serializer.fromJson<String?>(json['originalFileName']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String?>(json['artist']),
      album: serializer.fromJson<String?>(json['album']),
      albumArtist: serializer.fromJson<String?>(json['albumArtist']),
      genre: serializer.fromJson<String?>(json['genre']),
      language: serializer.fromJson<String?>(json['language']),
      composer: serializer.fromJson<String?>(json['composer']),
      releaseYear: serializer.fromJson<int?>(json['releaseYear']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      trackNumber: serializer.fromJson<int?>(json['trackNumber']),
      discNumber: serializer.fromJson<int?>(json['discNumber']),
      artworkKey: serializer.fromJson<String?>(json['artworkKey']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      lastModified: serializer.fromJson<DateTime?>(json['lastModified']),
      lastPlayedAt: serializer.fromJson<DateTime?>(json['lastPlayedAt']),
      playCount: serializer.fromJson<int>(json['playCount']),
      skipCount: serializer.fromJson<int>(json['skipCount']),
      rating: serializer.fromJson<int?>(json['rating']),
      metadataSource: serializer.fromJson<String>(json['metadataSource']),
      availability: $TracksTable.$converteravailability.fromJson(serializer.fromJson<int>(json['availability'])),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isCompilation: serializer.fromJson<bool>(json['isCompilation']),
      lastPositionMs: serializer.fromJson<int?>(json['lastPositionMs']),
      overriddenFields: serializer.fromJson<String>(json['overriddenFields']),
      titleKey: serializer.fromJson<String>(json['titleKey']),
      artistKey: serializer.fromJson<String>(json['artistKey']),
      albumKey: serializer.fromJson<String>(json['albumKey']),
      searchText: serializer.fromJson<String>(json['searchText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceUri': serializer.toJson<String>(sourceUri),
      'sourceType': serializer.toJson<int>($TracksTable.$convertersourceType.toJson(sourceType)),
      'originalFileName': serializer.toJson<String?>(originalFileName),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String?>(artist),
      'album': serializer.toJson<String?>(album),
      'albumArtist': serializer.toJson<String?>(albumArtist),
      'genre': serializer.toJson<String?>(genre),
      'language': serializer.toJson<String?>(language),
      'composer': serializer.toJson<String?>(composer),
      'releaseYear': serializer.toJson<int?>(releaseYear),
      'durationMs': serializer.toJson<int?>(durationMs),
      'trackNumber': serializer.toJson<int?>(trackNumber),
      'discNumber': serializer.toJson<int?>(discNumber),
      'artworkKey': serializer.toJson<String?>(artworkKey),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'fileHash': serializer.toJson<String>(fileHash),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'lastModified': serializer.toJson<DateTime?>(lastModified),
      'lastPlayedAt': serializer.toJson<DateTime?>(lastPlayedAt),
      'playCount': serializer.toJson<int>(playCount),
      'skipCount': serializer.toJson<int>(skipCount),
      'rating': serializer.toJson<int?>(rating),
      'metadataSource': serializer.toJson<String>(metadataSource),
      'availability': serializer.toJson<int>($TracksTable.$converteravailability.toJson(availability)),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isCompilation': serializer.toJson<bool>(isCompilation),
      'lastPositionMs': serializer.toJson<int?>(lastPositionMs),
      'overriddenFields': serializer.toJson<String>(overriddenFields),
      'titleKey': serializer.toJson<String>(titleKey),
      'artistKey': serializer.toJson<String>(artistKey),
      'albumKey': serializer.toJson<String>(albumKey),
      'searchText': serializer.toJson<String>(searchText),
    };
  }

  Track copyWith({
    String? id,
    String? sourceUri,
    TrackSourceType? sourceType,
    Value<String?> originalFileName = const Value.absent(),
    String? title,
    Value<String?> artist = const Value.absent(),
    Value<String?> album = const Value.absent(),
    Value<String?> albumArtist = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    Value<String?> language = const Value.absent(),
    Value<String?> composer = const Value.absent(),
    Value<int?> releaseYear = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<int?> trackNumber = const Value.absent(),
    Value<int?> discNumber = const Value.absent(),
    Value<String?> artworkKey = const Value.absent(),
    Value<int?> fileSizeBytes = const Value.absent(),
    String? fileHash,
    DateTime? dateAdded,
    Value<DateTime?> lastModified = const Value.absent(),
    Value<DateTime?> lastPlayedAt = const Value.absent(),
    int? playCount,
    int? skipCount,
    Value<int?> rating = const Value.absent(),
    String? metadataSource,
    Availability? availability,
    bool? isFavorite,
    bool? isCompilation,
    Value<int?> lastPositionMs = const Value.absent(),
    String? overriddenFields,
    String? titleKey,
    String? artistKey,
    String? albumKey,
    String? searchText,
  }) => Track(
    id: id ?? this.id,
    sourceUri: sourceUri ?? this.sourceUri,
    sourceType: sourceType ?? this.sourceType,
    originalFileName: originalFileName.present ? originalFileName.value : this.originalFileName,
    title: title ?? this.title,
    artist: artist.present ? artist.value : this.artist,
    album: album.present ? album.value : this.album,
    albumArtist: albumArtist.present ? albumArtist.value : this.albumArtist,
    genre: genre.present ? genre.value : this.genre,
    language: language.present ? language.value : this.language,
    composer: composer.present ? composer.value : this.composer,
    releaseYear: releaseYear.present ? releaseYear.value : this.releaseYear,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    trackNumber: trackNumber.present ? trackNumber.value : this.trackNumber,
    discNumber: discNumber.present ? discNumber.value : this.discNumber,
    artworkKey: artworkKey.present ? artworkKey.value : this.artworkKey,
    fileSizeBytes: fileSizeBytes.present ? fileSizeBytes.value : this.fileSizeBytes,
    fileHash: fileHash ?? this.fileHash,
    dateAdded: dateAdded ?? this.dateAdded,
    lastModified: lastModified.present ? lastModified.value : this.lastModified,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
    playCount: playCount ?? this.playCount,
    skipCount: skipCount ?? this.skipCount,
    rating: rating.present ? rating.value : this.rating,
    metadataSource: metadataSource ?? this.metadataSource,
    availability: availability ?? this.availability,
    isFavorite: isFavorite ?? this.isFavorite,
    isCompilation: isCompilation ?? this.isCompilation,
    lastPositionMs: lastPositionMs.present ? lastPositionMs.value : this.lastPositionMs,
    overriddenFields: overriddenFields ?? this.overriddenFields,
    titleKey: titleKey ?? this.titleKey,
    artistKey: artistKey ?? this.artistKey,
    albumKey: albumKey ?? this.albumKey,
    searchText: searchText ?? this.searchText,
  );
  Track copyWithCompanion(TracksCompanion data) {
    return Track(
      id: data.id.present ? data.id.value : this.id,
      sourceUri: data.sourceUri.present ? data.sourceUri.value : this.sourceUri,
      sourceType: data.sourceType.present ? data.sourceType.value : this.sourceType,
      originalFileName: data.originalFileName.present ? data.originalFileName.value : this.originalFileName,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      album: data.album.present ? data.album.value : this.album,
      albumArtist: data.albumArtist.present ? data.albumArtist.value : this.albumArtist,
      genre: data.genre.present ? data.genre.value : this.genre,
      language: data.language.present ? data.language.value : this.language,
      composer: data.composer.present ? data.composer.value : this.composer,
      releaseYear: data.releaseYear.present ? data.releaseYear.value : this.releaseYear,
      durationMs: data.durationMs.present ? data.durationMs.value : this.durationMs,
      trackNumber: data.trackNumber.present ? data.trackNumber.value : this.trackNumber,
      discNumber: data.discNumber.present ? data.discNumber.value : this.discNumber,
      artworkKey: data.artworkKey.present ? data.artworkKey.value : this.artworkKey,
      fileSizeBytes: data.fileSizeBytes.present ? data.fileSizeBytes.value : this.fileSizeBytes,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      lastModified: data.lastModified.present ? data.lastModified.value : this.lastModified,
      lastPlayedAt: data.lastPlayedAt.present ? data.lastPlayedAt.value : this.lastPlayedAt,
      playCount: data.playCount.present ? data.playCount.value : this.playCount,
      skipCount: data.skipCount.present ? data.skipCount.value : this.skipCount,
      rating: data.rating.present ? data.rating.value : this.rating,
      metadataSource: data.metadataSource.present ? data.metadataSource.value : this.metadataSource,
      availability: data.availability.present ? data.availability.value : this.availability,
      isFavorite: data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      isCompilation: data.isCompilation.present ? data.isCompilation.value : this.isCompilation,
      lastPositionMs: data.lastPositionMs.present ? data.lastPositionMs.value : this.lastPositionMs,
      overriddenFields: data.overriddenFields.present ? data.overriddenFields.value : this.overriddenFields,
      titleKey: data.titleKey.present ? data.titleKey.value : this.titleKey,
      artistKey: data.artistKey.present ? data.artistKey.value : this.artistKey,
      albumKey: data.albumKey.present ? data.albumKey.value : this.albumKey,
      searchText: data.searchText.present ? data.searchText.value : this.searchText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Track(')
          ..write('id: $id, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('sourceType: $sourceType, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('genre: $genre, ')
          ..write('language: $language, ')
          ..write('composer: $composer, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('durationMs: $durationMs, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('discNumber: $discNumber, ')
          ..write('artworkKey: $artworkKey, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('fileHash: $fileHash, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('playCount: $playCount, ')
          ..write('skipCount: $skipCount, ')
          ..write('rating: $rating, ')
          ..write('metadataSource: $metadataSource, ')
          ..write('availability: $availability, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isCompilation: $isCompilation, ')
          ..write('lastPositionMs: $lastPositionMs, ')
          ..write('overriddenFields: $overriddenFields, ')
          ..write('titleKey: $titleKey, ')
          ..write('artistKey: $artistKey, ')
          ..write('albumKey: $albumKey, ')
          ..write('searchText: $searchText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    sourceUri,
    sourceType,
    originalFileName,
    title,
    artist,
    album,
    albumArtist,
    genre,
    language,
    composer,
    releaseYear,
    durationMs,
    trackNumber,
    discNumber,
    artworkKey,
    fileSizeBytes,
    fileHash,
    dateAdded,
    lastModified,
    lastPlayedAt,
    playCount,
    skipCount,
    rating,
    metadataSource,
    availability,
    isFavorite,
    isCompilation,
    lastPositionMs,
    overriddenFields,
    titleKey,
    artistKey,
    albumKey,
    searchText,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Track &&
          other.id == this.id &&
          other.sourceUri == this.sourceUri &&
          other.sourceType == this.sourceType &&
          other.originalFileName == this.originalFileName &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.album == this.album &&
          other.albumArtist == this.albumArtist &&
          other.genre == this.genre &&
          other.language == this.language &&
          other.composer == this.composer &&
          other.releaseYear == this.releaseYear &&
          other.durationMs == this.durationMs &&
          other.trackNumber == this.trackNumber &&
          other.discNumber == this.discNumber &&
          other.artworkKey == this.artworkKey &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.fileHash == this.fileHash &&
          other.dateAdded == this.dateAdded &&
          other.lastModified == this.lastModified &&
          other.lastPlayedAt == this.lastPlayedAt &&
          other.playCount == this.playCount &&
          other.skipCount == this.skipCount &&
          other.rating == this.rating &&
          other.metadataSource == this.metadataSource &&
          other.availability == this.availability &&
          other.isFavorite == this.isFavorite &&
          other.isCompilation == this.isCompilation &&
          other.lastPositionMs == this.lastPositionMs &&
          other.overriddenFields == this.overriddenFields &&
          other.titleKey == this.titleKey &&
          other.artistKey == this.artistKey &&
          other.albumKey == this.albumKey &&
          other.searchText == this.searchText);
}

class TracksCompanion extends UpdateCompanion<Track> {
  final Value<String> id;
  final Value<String> sourceUri;
  final Value<TrackSourceType> sourceType;
  final Value<String?> originalFileName;
  final Value<String> title;
  final Value<String?> artist;
  final Value<String?> album;
  final Value<String?> albumArtist;
  final Value<String?> genre;
  final Value<String?> language;
  final Value<String?> composer;
  final Value<int?> releaseYear;
  final Value<int?> durationMs;
  final Value<int?> trackNumber;
  final Value<int?> discNumber;
  final Value<String?> artworkKey;
  final Value<int?> fileSizeBytes;
  final Value<String> fileHash;
  final Value<DateTime> dateAdded;
  final Value<DateTime?> lastModified;
  final Value<DateTime?> lastPlayedAt;
  final Value<int> playCount;
  final Value<int> skipCount;
  final Value<int?> rating;
  final Value<String> metadataSource;
  final Value<Availability> availability;
  final Value<bool> isFavorite;
  final Value<bool> isCompilation;
  final Value<int?> lastPositionMs;
  final Value<String> overriddenFields;
  final Value<String> titleKey;
  final Value<String> artistKey;
  final Value<String> albumKey;
  final Value<String> searchText;
  final Value<int> rowid;
  const TracksCompanion({
    this.id = const Value.absent(),
    this.sourceUri = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.originalFileName = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.genre = const Value.absent(),
    this.language = const Value.absent(),
    this.composer = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.artworkKey = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.playCount = const Value.absent(),
    this.skipCount = const Value.absent(),
    this.rating = const Value.absent(),
    this.metadataSource = const Value.absent(),
    this.availability = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isCompilation = const Value.absent(),
    this.lastPositionMs = const Value.absent(),
    this.overriddenFields = const Value.absent(),
    this.titleKey = const Value.absent(),
    this.artistKey = const Value.absent(),
    this.albumKey = const Value.absent(),
    this.searchText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TracksCompanion.insert({
    required String id,
    required String sourceUri,
    required TrackSourceType sourceType,
    this.originalFileName = const Value.absent(),
    required String title,
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.genre = const Value.absent(),
    this.language = const Value.absent(),
    this.composer = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.artworkKey = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    required String fileHash,
    required DateTime dateAdded,
    this.lastModified = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.playCount = const Value.absent(),
    this.skipCount = const Value.absent(),
    this.rating = const Value.absent(),
    this.metadataSource = const Value.absent(),
    this.availability = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isCompilation = const Value.absent(),
    this.lastPositionMs = const Value.absent(),
    this.overriddenFields = const Value.absent(),
    required String titleKey,
    required String artistKey,
    required String albumKey,
    required String searchText,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceUri = Value(sourceUri),
       sourceType = Value(sourceType),
       title = Value(title),
       fileHash = Value(fileHash),
       dateAdded = Value(dateAdded),
       titleKey = Value(titleKey),
       artistKey = Value(artistKey),
       albumKey = Value(albumKey),
       searchText = Value(searchText);
  static Insertable<Track> custom({
    Expression<String>? id,
    Expression<String>? sourceUri,
    Expression<int>? sourceType,
    Expression<String>? originalFileName,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? album,
    Expression<String>? albumArtist,
    Expression<String>? genre,
    Expression<String>? language,
    Expression<String>? composer,
    Expression<int>? releaseYear,
    Expression<int>? durationMs,
    Expression<int>? trackNumber,
    Expression<int>? discNumber,
    Expression<String>? artworkKey,
    Expression<int>? fileSizeBytes,
    Expression<String>? fileHash,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? lastModified,
    Expression<DateTime>? lastPlayedAt,
    Expression<int>? playCount,
    Expression<int>? skipCount,
    Expression<int>? rating,
    Expression<String>? metadataSource,
    Expression<int>? availability,
    Expression<bool>? isFavorite,
    Expression<bool>? isCompilation,
    Expression<int>? lastPositionMs,
    Expression<String>? overriddenFields,
    Expression<String>? titleKey,
    Expression<String>? artistKey,
    Expression<String>? albumKey,
    Expression<String>? searchText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceUri != null) 'source_uri': sourceUri,
      if (sourceType != null) 'source_type': sourceType,
      if (originalFileName != null) 'original_file_name': originalFileName,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (album != null) 'album': album,
      if (albumArtist != null) 'album_artist': albumArtist,
      if (genre != null) 'genre': genre,
      if (language != null) 'language': language,
      if (composer != null) 'composer': composer,
      if (releaseYear != null) 'release_year': releaseYear,
      if (durationMs != null) 'duration_ms': durationMs,
      if (trackNumber != null) 'track_number': trackNumber,
      if (discNumber != null) 'disc_number': discNumber,
      if (artworkKey != null) 'artwork_key': artworkKey,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (fileHash != null) 'file_hash': fileHash,
      if (dateAdded != null) 'date_added': dateAdded,
      if (lastModified != null) 'last_modified': lastModified,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (playCount != null) 'play_count': playCount,
      if (skipCount != null) 'skip_count': skipCount,
      if (rating != null) 'rating': rating,
      if (metadataSource != null) 'metadata_source': metadataSource,
      if (availability != null) 'availability': availability,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isCompilation != null) 'is_compilation': isCompilation,
      if (lastPositionMs != null) 'last_position_ms': lastPositionMs,
      if (overriddenFields != null) 'overridden_fields': overriddenFields,
      if (titleKey != null) 'title_key': titleKey,
      if (artistKey != null) 'artist_key': artistKey,
      if (albumKey != null) 'album_key': albumKey,
      if (searchText != null) 'search_text': searchText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TracksCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceUri,
    Value<TrackSourceType>? sourceType,
    Value<String?>? originalFileName,
    Value<String>? title,
    Value<String?>? artist,
    Value<String?>? album,
    Value<String?>? albumArtist,
    Value<String?>? genre,
    Value<String?>? language,
    Value<String?>? composer,
    Value<int?>? releaseYear,
    Value<int?>? durationMs,
    Value<int?>? trackNumber,
    Value<int?>? discNumber,
    Value<String?>? artworkKey,
    Value<int?>? fileSizeBytes,
    Value<String>? fileHash,
    Value<DateTime>? dateAdded,
    Value<DateTime?>? lastModified,
    Value<DateTime?>? lastPlayedAt,
    Value<int>? playCount,
    Value<int>? skipCount,
    Value<int?>? rating,
    Value<String>? metadataSource,
    Value<Availability>? availability,
    Value<bool>? isFavorite,
    Value<bool>? isCompilation,
    Value<int?>? lastPositionMs,
    Value<String>? overriddenFields,
    Value<String>? titleKey,
    Value<String>? artistKey,
    Value<String>? albumKey,
    Value<String>? searchText,
    Value<int>? rowid,
  }) {
    return TracksCompanion(
      id: id ?? this.id,
      sourceUri: sourceUri ?? this.sourceUri,
      sourceType: sourceType ?? this.sourceType,
      originalFileName: originalFileName ?? this.originalFileName,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArtist: albumArtist ?? this.albumArtist,
      genre: genre ?? this.genre,
      language: language ?? this.language,
      composer: composer ?? this.composer,
      releaseYear: releaseYear ?? this.releaseYear,
      durationMs: durationMs ?? this.durationMs,
      trackNumber: trackNumber ?? this.trackNumber,
      discNumber: discNumber ?? this.discNumber,
      artworkKey: artworkKey ?? this.artworkKey,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      fileHash: fileHash ?? this.fileHash,
      dateAdded: dateAdded ?? this.dateAdded,
      lastModified: lastModified ?? this.lastModified,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      playCount: playCount ?? this.playCount,
      skipCount: skipCount ?? this.skipCount,
      rating: rating ?? this.rating,
      metadataSource: metadataSource ?? this.metadataSource,
      availability: availability ?? this.availability,
      isFavorite: isFavorite ?? this.isFavorite,
      isCompilation: isCompilation ?? this.isCompilation,
      lastPositionMs: lastPositionMs ?? this.lastPositionMs,
      overriddenFields: overriddenFields ?? this.overriddenFields,
      titleKey: titleKey ?? this.titleKey,
      artistKey: artistKey ?? this.artistKey,
      albumKey: albumKey ?? this.albumKey,
      searchText: searchText ?? this.searchText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceUri.present) {
      map['source_uri'] = Variable<String>(sourceUri.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<int>($TracksTable.$convertersourceType.toSql(sourceType.value));
    }
    if (originalFileName.present) {
      map['original_file_name'] = Variable<String>(originalFileName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (album.present) {
      map['album'] = Variable<String>(album.value);
    }
    if (albumArtist.present) {
      map['album_artist'] = Variable<String>(albumArtist.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (composer.present) {
      map['composer'] = Variable<String>(composer.value);
    }
    if (releaseYear.present) {
      map['release_year'] = Variable<int>(releaseYear.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (trackNumber.present) {
      map['track_number'] = Variable<int>(trackNumber.value);
    }
    if (discNumber.present) {
      map['disc_number'] = Variable<int>(discNumber.value);
    }
    if (artworkKey.present) {
      map['artwork_key'] = Variable<String>(artworkKey.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    if (playCount.present) {
      map['play_count'] = Variable<int>(playCount.value);
    }
    if (skipCount.present) {
      map['skip_count'] = Variable<int>(skipCount.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (metadataSource.present) {
      map['metadata_source'] = Variable<String>(metadataSource.value);
    }
    if (availability.present) {
      map['availability'] = Variable<int>($TracksTable.$converteravailability.toSql(availability.value));
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isCompilation.present) {
      map['is_compilation'] = Variable<bool>(isCompilation.value);
    }
    if (lastPositionMs.present) {
      map['last_position_ms'] = Variable<int>(lastPositionMs.value);
    }
    if (overriddenFields.present) {
      map['overridden_fields'] = Variable<String>(overriddenFields.value);
    }
    if (titleKey.present) {
      map['title_key'] = Variable<String>(titleKey.value);
    }
    if (artistKey.present) {
      map['artist_key'] = Variable<String>(artistKey.value);
    }
    if (albumKey.present) {
      map['album_key'] = Variable<String>(albumKey.value);
    }
    if (searchText.present) {
      map['search_text'] = Variable<String>(searchText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TracksCompanion(')
          ..write('id: $id, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('sourceType: $sourceType, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('genre: $genre, ')
          ..write('language: $language, ')
          ..write('composer: $composer, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('durationMs: $durationMs, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('discNumber: $discNumber, ')
          ..write('artworkKey: $artworkKey, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('fileHash: $fileHash, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('playCount: $playCount, ')
          ..write('skipCount: $skipCount, ')
          ..write('rating: $rating, ')
          ..write('metadataSource: $metadataSource, ')
          ..write('availability: $availability, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isCompilation: $isCompilation, ')
          ..write('lastPositionMs: $lastPositionMs, ')
          ..write('overriddenFields: $overriddenFields, ')
          ..write('titleKey: $titleKey, ')
          ..write('artistKey: $artistKey, ')
          ..write('albumKey: $albumKey, ')
          ..write('searchText: $searchText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmbeddedTagsTable extends EmbeddedTags with TableInfo<$EmbeddedTagsTable, EmbeddedTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmbeddedTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _trackIdMeta = const VerificationMeta('trackId');
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES tracks (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<String> album = GeneratedColumn<String>(
    'album',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumArtistMeta = const VerificationMeta('albumArtist');
  @override
  late final GeneratedColumn<String> albumArtist = GeneratedColumn<String>(
    'album_artist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseYearMeta = const VerificationMeta('releaseYear');
  @override
  late final GeneratedColumn<int> releaseYear = GeneratedColumn<int>(
    'release_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artworkKeyMeta = const VerificationMeta('artworkKey');
  @override
  late final GeneratedColumn<String> artworkKey = GeneratedColumn<String>(
    'artwork_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    trackId,
    title,
    artist,
    album,
    albumArtist,
    genre,
    language,
    releaseYear,
    artworkKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'embedded_tags';
  @override
  VerificationContext validateIntegrity(Insertable<EmbeddedTag> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('track_id')) {
      context.handle(_trackIdMeta, trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta));
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta, artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    }
    if (data.containsKey('album')) {
      context.handle(_albumMeta, album.isAcceptableOrUnknown(data['album']!, _albumMeta));
    }
    if (data.containsKey('album_artist')) {
      context.handle(_albumArtistMeta, albumArtist.isAcceptableOrUnknown(data['album_artist']!, _albumArtistMeta));
    }
    if (data.containsKey('genre')) {
      context.handle(_genreMeta, genre.isAcceptableOrUnknown(data['genre']!, _genreMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta, language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('release_year')) {
      context.handle(_releaseYearMeta, releaseYear.isAcceptableOrUnknown(data['release_year']!, _releaseYearMeta));
    }
    if (data.containsKey('artwork_key')) {
      context.handle(_artworkKeyMeta, artworkKey.isAcceptableOrUnknown(data['artwork_key']!, _artworkKeyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trackId};
  @override
  EmbeddedTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmbeddedTag(
      trackId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}track_id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title']),
      artist: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}artist']),
      album: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}album']),
      albumArtist: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}album_artist']),
      genre: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}genre']),
      language: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}language']),
      releaseYear: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}release_year']),
      artworkKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}artwork_key']),
    );
  }

  @override
  $EmbeddedTagsTable createAlias(String alias) {
    return $EmbeddedTagsTable(attachedDatabase, alias);
  }
}

class EmbeddedTag extends DataClass implements Insertable<EmbeddedTag> {
  final String trackId;
  final String? title;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final String? genre;
  final String? language;
  final int? releaseYear;
  final String? artworkKey;
  const EmbeddedTag({
    required this.trackId,
    this.title,
    this.artist,
    this.album,
    this.albumArtist,
    this.genre,
    this.language,
    this.releaseYear,
    this.artworkKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['track_id'] = Variable<String>(trackId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    if (!nullToAbsent || album != null) {
      map['album'] = Variable<String>(album);
    }
    if (!nullToAbsent || albumArtist != null) {
      map['album_artist'] = Variable<String>(albumArtist);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || releaseYear != null) {
      map['release_year'] = Variable<int>(releaseYear);
    }
    if (!nullToAbsent || artworkKey != null) {
      map['artwork_key'] = Variable<String>(artworkKey);
    }
    return map;
  }

  EmbeddedTagsCompanion toCompanion(bool nullToAbsent) {
    return EmbeddedTagsCompanion(
      trackId: Value(trackId),
      title: title == null && nullToAbsent ? const Value.absent() : Value(title),
      artist: artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      album: album == null && nullToAbsent ? const Value.absent() : Value(album),
      albumArtist: albumArtist == null && nullToAbsent ? const Value.absent() : Value(albumArtist),
      genre: genre == null && nullToAbsent ? const Value.absent() : Value(genre),
      language: language == null && nullToAbsent ? const Value.absent() : Value(language),
      releaseYear: releaseYear == null && nullToAbsent ? const Value.absent() : Value(releaseYear),
      artworkKey: artworkKey == null && nullToAbsent ? const Value.absent() : Value(artworkKey),
    );
  }

  factory EmbeddedTag.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmbeddedTag(
      trackId: serializer.fromJson<String>(json['trackId']),
      title: serializer.fromJson<String?>(json['title']),
      artist: serializer.fromJson<String?>(json['artist']),
      album: serializer.fromJson<String?>(json['album']),
      albumArtist: serializer.fromJson<String?>(json['albumArtist']),
      genre: serializer.fromJson<String?>(json['genre']),
      language: serializer.fromJson<String?>(json['language']),
      releaseYear: serializer.fromJson<int?>(json['releaseYear']),
      artworkKey: serializer.fromJson<String?>(json['artworkKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trackId': serializer.toJson<String>(trackId),
      'title': serializer.toJson<String?>(title),
      'artist': serializer.toJson<String?>(artist),
      'album': serializer.toJson<String?>(album),
      'albumArtist': serializer.toJson<String?>(albumArtist),
      'genre': serializer.toJson<String?>(genre),
      'language': serializer.toJson<String?>(language),
      'releaseYear': serializer.toJson<int?>(releaseYear),
      'artworkKey': serializer.toJson<String?>(artworkKey),
    };
  }

  EmbeddedTag copyWith({
    String? trackId,
    Value<String?> title = const Value.absent(),
    Value<String?> artist = const Value.absent(),
    Value<String?> album = const Value.absent(),
    Value<String?> albumArtist = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    Value<String?> language = const Value.absent(),
    Value<int?> releaseYear = const Value.absent(),
    Value<String?> artworkKey = const Value.absent(),
  }) => EmbeddedTag(
    trackId: trackId ?? this.trackId,
    title: title.present ? title.value : this.title,
    artist: artist.present ? artist.value : this.artist,
    album: album.present ? album.value : this.album,
    albumArtist: albumArtist.present ? albumArtist.value : this.albumArtist,
    genre: genre.present ? genre.value : this.genre,
    language: language.present ? language.value : this.language,
    releaseYear: releaseYear.present ? releaseYear.value : this.releaseYear,
    artworkKey: artworkKey.present ? artworkKey.value : this.artworkKey,
  );
  EmbeddedTag copyWithCompanion(EmbeddedTagsCompanion data) {
    return EmbeddedTag(
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      album: data.album.present ? data.album.value : this.album,
      albumArtist: data.albumArtist.present ? data.albumArtist.value : this.albumArtist,
      genre: data.genre.present ? data.genre.value : this.genre,
      language: data.language.present ? data.language.value : this.language,
      releaseYear: data.releaseYear.present ? data.releaseYear.value : this.releaseYear,
      artworkKey: data.artworkKey.present ? data.artworkKey.value : this.artworkKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmbeddedTag(')
          ..write('trackId: $trackId, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('genre: $genre, ')
          ..write('language: $language, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('artworkKey: $artworkKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(trackId, title, artist, album, albumArtist, genre, language, releaseYear, artworkKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmbeddedTag &&
          other.trackId == this.trackId &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.album == this.album &&
          other.albumArtist == this.albumArtist &&
          other.genre == this.genre &&
          other.language == this.language &&
          other.releaseYear == this.releaseYear &&
          other.artworkKey == this.artworkKey);
}

class EmbeddedTagsCompanion extends UpdateCompanion<EmbeddedTag> {
  final Value<String> trackId;
  final Value<String?> title;
  final Value<String?> artist;
  final Value<String?> album;
  final Value<String?> albumArtist;
  final Value<String?> genre;
  final Value<String?> language;
  final Value<int?> releaseYear;
  final Value<String?> artworkKey;
  final Value<int> rowid;
  const EmbeddedTagsCompanion({
    this.trackId = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.genre = const Value.absent(),
    this.language = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.artworkKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmbeddedTagsCompanion.insert({
    required String trackId,
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.genre = const Value.absent(),
    this.language = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.artworkKey = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : trackId = Value(trackId);
  static Insertable<EmbeddedTag> custom({
    Expression<String>? trackId,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? album,
    Expression<String>? albumArtist,
    Expression<String>? genre,
    Expression<String>? language,
    Expression<int>? releaseYear,
    Expression<String>? artworkKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (trackId != null) 'track_id': trackId,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (album != null) 'album': album,
      if (albumArtist != null) 'album_artist': albumArtist,
      if (genre != null) 'genre': genre,
      if (language != null) 'language': language,
      if (releaseYear != null) 'release_year': releaseYear,
      if (artworkKey != null) 'artwork_key': artworkKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmbeddedTagsCompanion copyWith({
    Value<String>? trackId,
    Value<String?>? title,
    Value<String?>? artist,
    Value<String?>? album,
    Value<String?>? albumArtist,
    Value<String?>? genre,
    Value<String?>? language,
    Value<int?>? releaseYear,
    Value<String?>? artworkKey,
    Value<int>? rowid,
  }) {
    return EmbeddedTagsCompanion(
      trackId: trackId ?? this.trackId,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArtist: albumArtist ?? this.albumArtist,
      genre: genre ?? this.genre,
      language: language ?? this.language,
      releaseYear: releaseYear ?? this.releaseYear,
      artworkKey: artworkKey ?? this.artworkKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (album.present) {
      map['album'] = Variable<String>(album.value);
    }
    if (albumArtist.present) {
      map['album_artist'] = Variable<String>(albumArtist.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (releaseYear.present) {
      map['release_year'] = Variable<int>(releaseYear.value);
    }
    if (artworkKey.present) {
      map['artwork_key'] = Variable<String>(artworkKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmbeddedTagsCompanion(')
          ..write('trackId: $trackId, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('genre: $genre, ')
          ..write('language: $language, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('artworkKey: $artworkKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackArtistsTable extends TrackArtists with TableInfo<$TrackArtistsTable, TrackArtist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _trackIdMeta = const VerificationMeta('trackId');
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES tracks (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _artistKeyMeta = const VerificationMeta('artistKey');
  @override
  late final GeneratedColumn<String> artistKey = GeneratedColumn<String>(
    'artist_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [trackId, artistKey, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_artists';
  @override
  VerificationContext validateIntegrity(Insertable<TrackArtist> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('track_id')) {
      context.handle(_trackIdMeta, trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta));
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('artist_key')) {
      context.handle(_artistKeyMeta, artistKey.isAcceptableOrUnknown(data['artist_key']!, _artistKeyMeta));
    } else if (isInserting) {
      context.missing(_artistKeyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trackId, artistKey};
  @override
  TrackArtist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackArtist(
      trackId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}track_id'])!,
      artistKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}artist_key'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $TrackArtistsTable createAlias(String alias) {
    return $TrackArtistsTable(attachedDatabase, alias);
  }
}

class TrackArtist extends DataClass implements Insertable<TrackArtist> {
  final String trackId;
  final String artistKey;
  final String name;
  const TrackArtist({required this.trackId, required this.artistKey, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['track_id'] = Variable<String>(trackId);
    map['artist_key'] = Variable<String>(artistKey);
    map['name'] = Variable<String>(name);
    return map;
  }

  TrackArtistsCompanion toCompanion(bool nullToAbsent) {
    return TrackArtistsCompanion(trackId: Value(trackId), artistKey: Value(artistKey), name: Value(name));
  }

  factory TrackArtist.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackArtist(
      trackId: serializer.fromJson<String>(json['trackId']),
      artistKey: serializer.fromJson<String>(json['artistKey']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trackId': serializer.toJson<String>(trackId),
      'artistKey': serializer.toJson<String>(artistKey),
      'name': serializer.toJson<String>(name),
    };
  }

  TrackArtist copyWith({String? trackId, String? artistKey, String? name}) =>
      TrackArtist(trackId: trackId ?? this.trackId, artistKey: artistKey ?? this.artistKey, name: name ?? this.name);
  TrackArtist copyWithCompanion(TrackArtistsCompanion data) {
    return TrackArtist(
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      artistKey: data.artistKey.present ? data.artistKey.value : this.artistKey,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackArtist(')
          ..write('trackId: $trackId, ')
          ..write('artistKey: $artistKey, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(trackId, artistKey, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackArtist &&
          other.trackId == this.trackId &&
          other.artistKey == this.artistKey &&
          other.name == this.name);
}

class TrackArtistsCompanion extends UpdateCompanion<TrackArtist> {
  final Value<String> trackId;
  final Value<String> artistKey;
  final Value<String> name;
  final Value<int> rowid;
  const TrackArtistsCompanion({
    this.trackId = const Value.absent(),
    this.artistKey = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackArtistsCompanion.insert({
    required String trackId,
    required String artistKey,
    required String name,
    this.rowid = const Value.absent(),
  }) : trackId = Value(trackId),
       artistKey = Value(artistKey),
       name = Value(name);
  static Insertable<TrackArtist> custom({
    Expression<String>? trackId,
    Expression<String>? artistKey,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (trackId != null) 'track_id': trackId,
      if (artistKey != null) 'artist_key': artistKey,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackArtistsCompanion copyWith({
    Value<String>? trackId,
    Value<String>? artistKey,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return TrackArtistsCompanion(
      trackId: trackId ?? this.trackId,
      artistKey: artistKey ?? this.artistKey,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (artistKey.present) {
      map['artist_key'] = Variable<String>(artistKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackArtistsCompanion(')
          ..write('trackId: $trackId, ')
          ..write('artistKey: $artistKey, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoriteAlbumsTable extends FavoriteAlbums with TableInfo<$FavoriteAlbumsTable, FavoriteAlbum> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteAlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _albumKeyMeta = const VerificationMeta('albumKey');
  @override
  late final GeneratedColumn<String> albumKey = GeneratedColumn<String>(
    'album_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistKeyMeta = const VerificationMeta('artistKey');
  @override
  late final GeneratedColumn<String> artistKey = GeneratedColumn<String>(
    'artist_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [albumKey, artistKey, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_albums';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteAlbum> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('album_key')) {
      context.handle(_albumKeyMeta, albumKey.isAcceptableOrUnknown(data['album_key']!, _albumKeyMeta));
    } else if (isInserting) {
      context.missing(_albumKeyMeta);
    }
    if (data.containsKey('artist_key')) {
      context.handle(_artistKeyMeta, artistKey.isAcceptableOrUnknown(data['artist_key']!, _artistKeyMeta));
    } else if (isInserting) {
      context.missing(_artistKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {albumKey, artistKey};
  @override
  FavoriteAlbum map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteAlbum(
      albumKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}album_key'])!,
      artistKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}artist_key'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FavoriteAlbumsTable createAlias(String alias) {
    return $FavoriteAlbumsTable(attachedDatabase, alias);
  }
}

class FavoriteAlbum extends DataClass implements Insertable<FavoriteAlbum> {
  final String albumKey;
  final String artistKey;
  final DateTime createdAt;
  const FavoriteAlbum({required this.albumKey, required this.artistKey, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['album_key'] = Variable<String>(albumKey);
    map['artist_key'] = Variable<String>(artistKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoriteAlbumsCompanion toCompanion(bool nullToAbsent) {
    return FavoriteAlbumsCompanion(albumKey: Value(albumKey), artistKey: Value(artistKey), createdAt: Value(createdAt));
  }

  factory FavoriteAlbum.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteAlbum(
      albumKey: serializer.fromJson<String>(json['albumKey']),
      artistKey: serializer.fromJson<String>(json['artistKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'albumKey': serializer.toJson<String>(albumKey),
      'artistKey': serializer.toJson<String>(artistKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoriteAlbum copyWith({String? albumKey, String? artistKey, DateTime? createdAt}) => FavoriteAlbum(
    albumKey: albumKey ?? this.albumKey,
    artistKey: artistKey ?? this.artistKey,
    createdAt: createdAt ?? this.createdAt,
  );
  FavoriteAlbum copyWithCompanion(FavoriteAlbumsCompanion data) {
    return FavoriteAlbum(
      albumKey: data.albumKey.present ? data.albumKey.value : this.albumKey,
      artistKey: data.artistKey.present ? data.artistKey.value : this.artistKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteAlbum(')
          ..write('albumKey: $albumKey, ')
          ..write('artistKey: $artistKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(albumKey, artistKey, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteAlbum &&
          other.albumKey == this.albumKey &&
          other.artistKey == this.artistKey &&
          other.createdAt == this.createdAt);
}

class FavoriteAlbumsCompanion extends UpdateCompanion<FavoriteAlbum> {
  final Value<String> albumKey;
  final Value<String> artistKey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FavoriteAlbumsCompanion({
    this.albumKey = const Value.absent(),
    this.artistKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteAlbumsCompanion.insert({
    required String albumKey,
    required String artistKey,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : albumKey = Value(albumKey),
       artistKey = Value(artistKey),
       createdAt = Value(createdAt);
  static Insertable<FavoriteAlbum> custom({
    Expression<String>? albumKey,
    Expression<String>? artistKey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (albumKey != null) 'album_key': albumKey,
      if (artistKey != null) 'artist_key': artistKey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteAlbumsCompanion copyWith({
    Value<String>? albumKey,
    Value<String>? artistKey,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FavoriteAlbumsCompanion(
      albumKey: albumKey ?? this.albumKey,
      artistKey: artistKey ?? this.artistKey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (albumKey.present) {
      map['album_key'] = Variable<String>(albumKey.value);
    }
    if (artistKey.present) {
      map['artist_key'] = Variable<String>(artistKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteAlbumsCompanion(')
          ..write('albumKey: $albumKey, ')
          ..write('artistKey: $artistKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artworkKeyMeta = const VerificationMeta('artworkKey');
  @override
  late final GeneratedColumn<String> artworkKey = GeneratedColumn<String>(
    'artwork_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, artworkKey, createdAt, updatedAt, sortOrder, isSystem];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(Insertable<Playlist> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    }
    if (data.containsKey('artwork_key')) {
      context.handle(_artworkKeyMeta, artworkKey.isAcceptableOrUnknown(data['artwork_key']!, _artworkKeyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta, isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description']),
      artworkKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}artwork_key']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isSystem: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final int id;
  final String name;
  final String? description;
  final String? artworkKey;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sortOrder;
  final bool isSystem;
  const Playlist({
    required this.id,
    required this.name,
    this.description,
    this.artworkKey,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.isSystem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || artworkKey != null) {
      map['artwork_key'] = Variable<String>(artworkKey);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_system'] = Variable<bool>(isSystem);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent ? const Value.absent() : Value(description),
      artworkKey: artworkKey == null && nullToAbsent ? const Value.absent() : Value(artworkKey),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sortOrder: Value(sortOrder),
      isSystem: Value(isSystem),
    );
  }

  factory Playlist.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      artworkKey: serializer.fromJson<String?>(json['artworkKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'artworkKey': serializer.toJson<String?>(artworkKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isSystem': serializer.toJson<bool>(isSystem),
    };
  }

  Playlist copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> artworkKey = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sortOrder,
    bool? isSystem,
  }) => Playlist(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    artworkKey: artworkKey.present ? artworkKey.value : this.artworkKey,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    isSystem: isSystem ?? this.isSystem,
  );
  Playlist copyWithCompanion(PlaylistsCompanion data) {
    return Playlist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present ? data.description.value : this.description,
      artworkKey: data.artworkKey.present ? data.artworkKey.value : this.artworkKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('artworkKey: $artworkKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isSystem: $isSystem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, artworkKey, createdAt, updatedAt, sortOrder, isSystem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.artworkKey == this.artworkKey &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sortOrder == this.sortOrder &&
          other.isSystem == this.isSystem);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> artworkKey;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> sortOrder;
  final Value<bool> isSystem;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.artworkKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isSystem = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.artworkKey = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sortOrder = const Value.absent(),
    this.isSystem = const Value.absent(),
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Playlist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? artworkKey,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? sortOrder,
    Expression<bool>? isSystem,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (artworkKey != null) 'artwork_key': artworkKey,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isSystem != null) 'is_system': isSystem,
    });
  }

  PlaylistsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? artworkKey,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? sortOrder,
    Value<bool>? isSystem,
  }) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      artworkKey: artworkKey ?? this.artworkKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      isSystem: isSystem ?? this.isSystem,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (artworkKey.present) {
      map['artwork_key'] = Variable<String>(artworkKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('artworkKey: $artworkKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isSystem: $isSystem')
          ..write(')'))
        .toString();
  }
}

class $PlaylistTracksTable extends PlaylistTracks with TableInfo<$PlaylistTracksTable, PlaylistEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _playlistIdMeta = const VerificationMeta('playlistId');
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES playlists (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta('trackId');
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES tracks (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, playlistId, trackId, position, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_tracks';
  @override
  VerificationContext validateIntegrity(Insertable<PlaylistEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_id')) {
      context.handle(_playlistIdMeta, playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta));
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(_trackIdMeta, trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta));
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta, addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      playlistId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}playlist_id'])!,
      trackId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}track_id'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      addedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
    );
  }

  @override
  $PlaylistTracksTable createAlias(String alias) {
    return $PlaylistTracksTable(attachedDatabase, alias);
  }
}

class PlaylistEntry extends DataClass implements Insertable<PlaylistEntry> {
  final int id;
  final int playlistId;
  final String trackId;
  final int position;
  final DateTime addedAt;
  const PlaylistEntry({
    required this.id,
    required this.playlistId,
    required this.trackId,
    required this.position,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<int>(playlistId);
    map['track_id'] = Variable<String>(trackId);
    map['position'] = Variable<int>(position);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  PlaylistTracksCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTracksCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      trackId: Value(trackId),
      position: Value(position),
      addedAt: Value(addedAt),
    );
  }

  factory PlaylistEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistEntry(
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<int>(json['playlistId']),
      trackId: serializer.fromJson<String>(json['trackId']),
      position: serializer.fromJson<int>(json['position']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<int>(playlistId),
      'trackId': serializer.toJson<String>(trackId),
      'position': serializer.toJson<int>(position),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  PlaylistEntry copyWith({int? id, int? playlistId, String? trackId, int? position, DateTime? addedAt}) =>
      PlaylistEntry(
        id: id ?? this.id,
        playlistId: playlistId ?? this.playlistId,
        trackId: trackId ?? this.trackId,
        position: position ?? this.position,
        addedAt: addedAt ?? this.addedAt,
      );
  PlaylistEntry copyWithCompanion(PlaylistTracksCompanion data) {
    return PlaylistEntry(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present ? data.playlistId.value : this.playlistId,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      position: data.position.present ? data.position.value : this.position,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistEntry(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playlistId, trackId, position, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistEntry &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.trackId == this.trackId &&
          other.position == this.position &&
          other.addedAt == this.addedAt);
}

class PlaylistTracksCompanion extends UpdateCompanion<PlaylistEntry> {
  final Value<int> id;
  final Value<int> playlistId;
  final Value<String> trackId;
  final Value<int> position;
  final Value<DateTime> addedAt;
  const PlaylistTracksCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.trackId = const Value.absent(),
    this.position = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  PlaylistTracksCompanion.insert({
    this.id = const Value.absent(),
    required int playlistId,
    required String trackId,
    required int position,
    required DateTime addedAt,
  }) : playlistId = Value(playlistId),
       trackId = Value(trackId),
       position = Value(position),
       addedAt = Value(addedAt);
  static Insertable<PlaylistEntry> custom({
    Expression<int>? id,
    Expression<int>? playlistId,
    Expression<String>? trackId,
    Expression<int>? position,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (trackId != null) 'track_id': trackId,
      if (position != null) 'position': position,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  PlaylistTracksCompanion copyWith({
    Value<int>? id,
    Value<int>? playlistId,
    Value<String>? trackId,
    Value<int>? position,
    Value<DateTime>? addedAt,
  }) {
    return PlaylistTracksCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      trackId: trackId ?? this.trackId,
      position: position ?? this.position,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTracksCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId, ')
          ..write('position: $position, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $PlaybackHistoryTable extends PlaybackHistory with TableInfo<$PlaybackHistoryTable, PlaybackRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaybackHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta('trackId');
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES tracks (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _listenedMsMeta = const VerificationMeta('listenedMs');
  @override
  late final GeneratedColumn<int> listenedMs = GeneratedColumn<int>(
    'listened_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _countedMeta = const VerificationMeta('counted');
  @override
  late final GeneratedColumn<bool> counted = GeneratedColumn<bool>(
    'counted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("counted" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta('skipped');
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("skipped" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _contextMeta = const VerificationMeta('context');
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
    'context',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackId,
    startedAt,
    endedAt,
    listenedMs,
    counted,
    completed,
    skipped,
    context,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playback_history';
  @override
  VerificationContext validateIntegrity(Insertable<PlaybackRecord> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_id')) {
      context.handle(_trackIdMeta, trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta));
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta, startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta, endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    if (data.containsKey('listened_ms')) {
      context.handle(_listenedMsMeta, listenedMs.isAcceptableOrUnknown(data['listened_ms']!, _listenedMsMeta));
    }
    if (data.containsKey('counted')) {
      context.handle(_countedMeta, counted.isAcceptableOrUnknown(data['counted']!, _countedMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta, completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('skipped')) {
      context.handle(_skippedMeta, skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta));
    }
    if (data.containsKey('context')) {
      context.handle(_contextMeta, this.context.isAcceptableOrUnknown(data['context']!, _contextMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaybackRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaybackRecord(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      trackId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}track_id'])!,
      startedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
      listenedMs: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}listened_ms'])!,
      counted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}counted'])!,
      completed: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      skipped: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}skipped'])!,
      context: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}context']),
    );
  }

  @override
  $PlaybackHistoryTable createAlias(String alias) {
    return $PlaybackHistoryTable(attachedDatabase, alias);
  }
}

class PlaybackRecord extends DataClass implements Insertable<PlaybackRecord> {
  final int id;
  final String trackId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int listenedMs;

  /// Listening passed [ListeningRules.meaningfulPlayMs]; counts as a play.
  final bool counted;
  final bool completed;
  final bool skipped;
  final String? context;
  const PlaybackRecord({
    required this.id,
    required this.trackId,
    required this.startedAt,
    this.endedAt,
    required this.listenedMs,
    required this.counted,
    required this.completed,
    required this.skipped,
    this.context,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<String>(trackId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['listened_ms'] = Variable<int>(listenedMs);
    map['counted'] = Variable<bool>(counted);
    map['completed'] = Variable<bool>(completed);
    map['skipped'] = Variable<bool>(skipped);
    if (!nullToAbsent || context != null) {
      map['context'] = Variable<String>(context);
    }
    return map;
  }

  PlaybackHistoryCompanion toCompanion(bool nullToAbsent) {
    return PlaybackHistoryCompanion(
      id: Value(id),
      trackId: Value(trackId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent ? const Value.absent() : Value(endedAt),
      listenedMs: Value(listenedMs),
      counted: Value(counted),
      completed: Value(completed),
      skipped: Value(skipped),
      context: context == null && nullToAbsent ? const Value.absent() : Value(context),
    );
  }

  factory PlaybackRecord.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaybackRecord(
      id: serializer.fromJson<int>(json['id']),
      trackId: serializer.fromJson<String>(json['trackId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      listenedMs: serializer.fromJson<int>(json['listenedMs']),
      counted: serializer.fromJson<bool>(json['counted']),
      completed: serializer.fromJson<bool>(json['completed']),
      skipped: serializer.fromJson<bool>(json['skipped']),
      context: serializer.fromJson<String?>(json['context']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<String>(trackId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'listenedMs': serializer.toJson<int>(listenedMs),
      'counted': serializer.toJson<bool>(counted),
      'completed': serializer.toJson<bool>(completed),
      'skipped': serializer.toJson<bool>(skipped),
      'context': serializer.toJson<String?>(context),
    };
  }

  PlaybackRecord copyWith({
    int? id,
    String? trackId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? listenedMs,
    bool? counted,
    bool? completed,
    bool? skipped,
    Value<String?> context = const Value.absent(),
  }) => PlaybackRecord(
    id: id ?? this.id,
    trackId: trackId ?? this.trackId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    listenedMs: listenedMs ?? this.listenedMs,
    counted: counted ?? this.counted,
    completed: completed ?? this.completed,
    skipped: skipped ?? this.skipped,
    context: context.present ? context.value : this.context,
  );
  PlaybackRecord copyWithCompanion(PlaybackHistoryCompanion data) {
    return PlaybackRecord(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      listenedMs: data.listenedMs.present ? data.listenedMs.value : this.listenedMs,
      counted: data.counted.present ? data.counted.value : this.counted,
      completed: data.completed.present ? data.completed.value : this.completed,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
      context: data.context.present ? data.context.value : this.context,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackRecord(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('listenedMs: $listenedMs, ')
          ..write('counted: $counted, ')
          ..write('completed: $completed, ')
          ..write('skipped: $skipped, ')
          ..write('context: $context')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackId, startedAt, endedAt, listenedMs, counted, completed, skipped, context);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaybackRecord &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.listenedMs == this.listenedMs &&
          other.counted == this.counted &&
          other.completed == this.completed &&
          other.skipped == this.skipped &&
          other.context == this.context);
}

class PlaybackHistoryCompanion extends UpdateCompanion<PlaybackRecord> {
  final Value<int> id;
  final Value<String> trackId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> listenedMs;
  final Value<bool> counted;
  final Value<bool> completed;
  final Value<bool> skipped;
  final Value<String?> context;
  const PlaybackHistoryCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.listenedMs = const Value.absent(),
    this.counted = const Value.absent(),
    this.completed = const Value.absent(),
    this.skipped = const Value.absent(),
    this.context = const Value.absent(),
  });
  PlaybackHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String trackId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.listenedMs = const Value.absent(),
    this.counted = const Value.absent(),
    this.completed = const Value.absent(),
    this.skipped = const Value.absent(),
    this.context = const Value.absent(),
  }) : trackId = Value(trackId),
       startedAt = Value(startedAt);
  static Insertable<PlaybackRecord> custom({
    Expression<int>? id,
    Expression<String>? trackId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? listenedMs,
    Expression<bool>? counted,
    Expression<bool>? completed,
    Expression<bool>? skipped,
    Expression<String>? context,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (listenedMs != null) 'listened_ms': listenedMs,
      if (counted != null) 'counted': counted,
      if (completed != null) 'completed': completed,
      if (skipped != null) 'skipped': skipped,
      if (context != null) 'context': context,
    });
  }

  PlaybackHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? trackId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? listenedMs,
    Value<bool>? counted,
    Value<bool>? completed,
    Value<bool>? skipped,
    Value<String?>? context,
  }) {
    return PlaybackHistoryCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      listenedMs: listenedMs ?? this.listenedMs,
      counted: counted ?? this.counted,
      completed: completed ?? this.completed,
      skipped: skipped ?? this.skipped,
      context: context ?? this.context,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (listenedMs.present) {
      map['listened_ms'] = Variable<int>(listenedMs.value);
    }
    if (counted.present) {
      map['counted'] = Variable<bool>(counted.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackHistoryCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('listenedMs: $listenedMs, ')
          ..write('counted: $counted, ')
          ..write('completed: $completed, ')
          ..write('skipped: $skipped, ')
          ..write('context: $context')
          ..write(')'))
        .toString();
  }
}

class $ListeningSessionsTable extends ListeningSessions with TableInfo<$ListeningSessionsTable, ListeningSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListeningSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalListeningMsMeta = const VerificationMeta('totalListeningMs');
  @override
  late final GeneratedColumn<int> totalListeningMs = GeneratedColumn<int>(
    'total_listening_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, startedAt, endedAt, totalListeningMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listening_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<ListeningSession> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta, startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta, endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('total_listening_ms')) {
      context.handle(
        _totalListeningMsMeta,
        totalListeningMs.isAcceptableOrUnknown(data['total_listening_ms']!, _totalListeningMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListeningSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListeningSession(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at'])!,
      totalListeningMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_listening_ms'],
      )!,
    );
  }

  @override
  $ListeningSessionsTable createAlias(String alias) {
    return $ListeningSessionsTable(attachedDatabase, alias);
  }
}

class ListeningSession extends DataClass implements Insertable<ListeningSession> {
  final int id;
  final DateTime startedAt;
  final DateTime endedAt;
  final int totalListeningMs;
  const ListeningSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.totalListeningMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['total_listening_ms'] = Variable<int>(totalListeningMs);
    return map;
  }

  ListeningSessionsCompanion toCompanion(bool nullToAbsent) {
    return ListeningSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      totalListeningMs: Value(totalListeningMs),
    );
  }

  factory ListeningSession.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListeningSession(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      totalListeningMs: serializer.fromJson<int>(json['totalListeningMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'totalListeningMs': serializer.toJson<int>(totalListeningMs),
    };
  }

  ListeningSession copyWith({int? id, DateTime? startedAt, DateTime? endedAt, int? totalListeningMs}) =>
      ListeningSession(
        id: id ?? this.id,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt ?? this.endedAt,
        totalListeningMs: totalListeningMs ?? this.totalListeningMs,
      );
  ListeningSession copyWithCompanion(ListeningSessionsCompanion data) {
    return ListeningSession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      totalListeningMs: data.totalListeningMs.present ? data.totalListeningMs.value : this.totalListeningMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListeningSession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('totalListeningMs: $totalListeningMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, totalListeningMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListeningSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.totalListeningMs == this.totalListeningMs);
}

class ListeningSessionsCompanion extends UpdateCompanion<ListeningSession> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> totalListeningMs;
  const ListeningSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.totalListeningMs = const Value.absent(),
  });
  ListeningSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    required DateTime endedAt,
    this.totalListeningMs = const Value.absent(),
  }) : startedAt = Value(startedAt),
       endedAt = Value(endedAt);
  static Insertable<ListeningSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? totalListeningMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (totalListeningMs != null) 'total_listening_ms': totalListeningMs,
    });
  }

  ListeningSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? totalListeningMs,
  }) {
    return ListeningSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      totalListeningMs: totalListeningMs ?? this.totalListeningMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (totalListeningMs.present) {
      map['total_listening_ms'] = Variable<int>(totalListeningMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListeningSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('totalListeningMs: $totalListeningMs')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TagKind, int> kind = GeneratedColumn<int>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<TagKind>($TagsTable.$converterkind);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, kind, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(_colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {name, kind},
  ];
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      kind: $TagsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}kind'])!,
      ),
      color: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}color']),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TagKind, int, int> $converterkind = const EnumIndexConverter<TagKind>(TagKind.values);
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final TagKind kind;
  final int? color;
  const Tag({required this.id, required this.name, required this.kind, this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<int>($TagsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      color: color == null && nullToAbsent ? const Value.absent() : Value(color),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $TagsTable.$converterkind.fromJson(serializer.fromJson<int>(json['kind'])),
      color: serializer.fromJson<int?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<int>($TagsTable.$converterkind.toJson(kind)),
      'color': serializer.toJson<int?>(color),
    };
  }

  Tag copyWith({int? id, String? name, TagKind? kind, Value<int?> color = const Value.absent()}) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    color: color.present ? color.value : this.color,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, kind, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<TagKind> kind;
  final Value<int?> color;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.color = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required TagKind kind,
    this.color = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? kind,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (color != null) 'color': color,
    });
  }

  TagsCompanion copyWith({Value<int>? id, Value<String>? name, Value<TagKind>? kind, Value<int?>? color}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>($TagsTable.$converterkind.toSql(kind.value));
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $TrackTagsTable extends TrackTags with TableInfo<$TrackTagsTable, TrackTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _trackIdMeta = const VerificationMeta('trackId');
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES tracks (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES tags (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _excludedMeta = const VerificationMeta('excluded');
  @override
  late final GeneratedColumn<bool> excluded = GeneratedColumn<bool>(
    'excluded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("excluded" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [trackId, tagId, excluded];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_tags';
  @override
  VerificationContext validateIntegrity(Insertable<TrackTag> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('track_id')) {
      context.handle(_trackIdMeta, trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta));
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(_tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('excluded')) {
      context.handle(_excludedMeta, excluded.isAcceptableOrUnknown(data['excluded']!, _excludedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trackId, tagId};
  @override
  TrackTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackTag(
      trackId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}track_id'])!,
      tagId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
      excluded: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}excluded'])!,
    );
  }

  @override
  $TrackTagsTable createAlias(String alias) {
    return $TrackTagsTable(attachedDatabase, alias);
  }
}

class TrackTag extends DataClass implements Insertable<TrackTag> {
  final String trackId;
  final int tagId;
  final bool excluded;
  const TrackTag({required this.trackId, required this.tagId, required this.excluded});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['track_id'] = Variable<String>(trackId);
    map['tag_id'] = Variable<int>(tagId);
    map['excluded'] = Variable<bool>(excluded);
    return map;
  }

  TrackTagsCompanion toCompanion(bool nullToAbsent) {
    return TrackTagsCompanion(trackId: Value(trackId), tagId: Value(tagId), excluded: Value(excluded));
  }

  factory TrackTag.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackTag(
      trackId: serializer.fromJson<String>(json['trackId']),
      tagId: serializer.fromJson<int>(json['tagId']),
      excluded: serializer.fromJson<bool>(json['excluded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trackId': serializer.toJson<String>(trackId),
      'tagId': serializer.toJson<int>(tagId),
      'excluded': serializer.toJson<bool>(excluded),
    };
  }

  TrackTag copyWith({String? trackId, int? tagId, bool? excluded}) =>
      TrackTag(trackId: trackId ?? this.trackId, tagId: tagId ?? this.tagId, excluded: excluded ?? this.excluded);
  TrackTag copyWithCompanion(TrackTagsCompanion data) {
    return TrackTag(
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      excluded: data.excluded.present ? data.excluded.value : this.excluded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackTag(')
          ..write('trackId: $trackId, ')
          ..write('tagId: $tagId, ')
          ..write('excluded: $excluded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(trackId, tagId, excluded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackTag &&
          other.trackId == this.trackId &&
          other.tagId == this.tagId &&
          other.excluded == this.excluded);
}

class TrackTagsCompanion extends UpdateCompanion<TrackTag> {
  final Value<String> trackId;
  final Value<int> tagId;
  final Value<bool> excluded;
  final Value<int> rowid;
  const TrackTagsCompanion({
    this.trackId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.excluded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackTagsCompanion.insert({
    required String trackId,
    required int tagId,
    this.excluded = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : trackId = Value(trackId),
       tagId = Value(tagId);
  static Insertable<TrackTag> custom({
    Expression<String>? trackId,
    Expression<int>? tagId,
    Expression<bool>? excluded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (trackId != null) 'track_id': trackId,
      if (tagId != null) 'tag_id': tagId,
      if (excluded != null) 'excluded': excluded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackTagsCompanion copyWith({Value<String>? trackId, Value<int>? tagId, Value<bool>? excluded, Value<int>? rowid}) {
    return TrackTagsCompanion(
      trackId: trackId ?? this.trackId,
      tagId: tagId ?? this.tagId,
      excluded: excluded ?? this.excluded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (excluded.present) {
      map['excluded'] = Variable<bool>(excluded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackTagsCompanion(')
          ..write('trackId: $trackId, ')
          ..write('tagId: $tagId, ')
          ..write('excluded: $excluded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTable extends SearchHistory with TableInfo<$SearchHistoryTable, SearchEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
    'query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _searchedAtMeta = const VerificationMeta('searchedAt');
  @override
  late final GeneratedColumn<DateTime> searchedAt = GeneratedColumn<DateTime>(
    'searched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, query, searchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history';
  @override
  VerificationContext validateIntegrity(Insertable<SearchEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('query')) {
      context.handle(_queryMeta, query.isAcceptableOrUnknown(data['query']!, _queryMeta));
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('searched_at')) {
      context.handle(_searchedAtMeta, searchedAt.isAcceptableOrUnknown(data['searched_at']!, _searchedAtMeta));
    } else if (isInserting) {
      context.missing(_searchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      query: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}query'])!,
      searchedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}searched_at'])!,
    );
  }

  @override
  $SearchHistoryTable createAlias(String alias) {
    return $SearchHistoryTable(attachedDatabase, alias);
  }
}

class SearchEntry extends DataClass implements Insertable<SearchEntry> {
  final int id;
  final String query;
  final DateTime searchedAt;
  const SearchEntry({required this.id, required this.query, required this.searchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['query'] = Variable<String>(query);
    map['searched_at'] = Variable<DateTime>(searchedAt);
    return map;
  }

  SearchHistoryCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryCompanion(id: Value(id), query: Value(query), searchedAt: Value(searchedAt));
  }

  factory SearchEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchEntry(
      id: serializer.fromJson<int>(json['id']),
      query: serializer.fromJson<String>(json['query']),
      searchedAt: serializer.fromJson<DateTime>(json['searchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'query': serializer.toJson<String>(query),
      'searchedAt': serializer.toJson<DateTime>(searchedAt),
    };
  }

  SearchEntry copyWith({int? id, String? query, DateTime? searchedAt}) =>
      SearchEntry(id: id ?? this.id, query: query ?? this.query, searchedAt: searchedAt ?? this.searchedAt);
  SearchEntry copyWithCompanion(SearchHistoryCompanion data) {
    return SearchEntry(
      id: data.id.present ? data.id.value : this.id,
      query: data.query.present ? data.query.value : this.query,
      searchedAt: data.searchedAt.present ? data.searchedAt.value : this.searchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchEntry(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, query, searchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchEntry && other.id == this.id && other.query == this.query && other.searchedAt == this.searchedAt);
}

class SearchHistoryCompanion extends UpdateCompanion<SearchEntry> {
  final Value<int> id;
  final Value<String> query;
  final Value<DateTime> searchedAt;
  const SearchHistoryCompanion({
    this.id = const Value.absent(),
    this.query = const Value.absent(),
    this.searchedAt = const Value.absent(),
  });
  SearchHistoryCompanion.insert({this.id = const Value.absent(), required String query, required DateTime searchedAt})
    : query = Value(query),
      searchedAt = Value(searchedAt);
  static Insertable<SearchEntry> custom({
    Expression<int>? id,
    Expression<String>? query,
    Expression<DateTime>? searchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (query != null) 'query': query,
      if (searchedAt != null) 'searched_at': searchedAt,
    });
  }

  SearchHistoryCompanion copyWith({Value<int>? id, Value<String>? query, Value<DateTime>? searchedAt}) {
    return SearchHistoryCompanion(
      id: id ?? this.id,
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (searchedAt.present) {
      map['searched_at'] = Variable<DateTime>(searchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryCompanion(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }
}

class $ArtworkCacheTable extends ArtworkCache with TableInfo<$ArtworkCacheTable, ArtworkEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtworkCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryColorMeta = const VerificationMeta('primaryColor');
  @override
  late final GeneratedColumn<int> primaryColor = GeneratedColumn<int>(
    'primary_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _secondaryColorMeta = const VerificationMeta('secondaryColor');
  @override
  late final GeneratedColumn<int> secondaryColor = GeneratedColumn<int>(
    'secondary_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, path, primaryColor, secondaryColor, width, height, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artwork_cache';
  @override
  VerificationContext validateIntegrity(Insertable<ArtworkEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('path')) {
      context.handle(_pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('primary_color')) {
      context.handle(_primaryColorMeta, primaryColor.isAcceptableOrUnknown(data['primary_color']!, _primaryColorMeta));
    }
    if (data.containsKey('secondary_color')) {
      context.handle(
        _secondaryColorMeta,
        secondaryColor.isAcceptableOrUnknown(data['secondary_color']!, _secondaryColorMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(_widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta, height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  ArtworkEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArtworkEntry(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      path: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      primaryColor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}primary_color']),
      secondaryColor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}secondary_color']),
      width: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}width']),
      height: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}height']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ArtworkCacheTable createAlias(String alias) {
    return $ArtworkCacheTable(attachedDatabase, alias);
  }
}

class ArtworkEntry extends DataClass implements Insertable<ArtworkEntry> {
  final String key;
  final String path;
  final int? primaryColor;
  final int? secondaryColor;
  final int? width;
  final int? height;
  final DateTime createdAt;
  const ArtworkEntry({
    required this.key,
    required this.path,
    this.primaryColor,
    this.secondaryColor,
    this.width,
    this.height,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || primaryColor != null) {
      map['primary_color'] = Variable<int>(primaryColor);
    }
    if (!nullToAbsent || secondaryColor != null) {
      map['secondary_color'] = Variable<int>(secondaryColor);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ArtworkCacheCompanion toCompanion(bool nullToAbsent) {
    return ArtworkCacheCompanion(
      key: Value(key),
      path: Value(path),
      primaryColor: primaryColor == null && nullToAbsent ? const Value.absent() : Value(primaryColor),
      secondaryColor: secondaryColor == null && nullToAbsent ? const Value.absent() : Value(secondaryColor),
      width: width == null && nullToAbsent ? const Value.absent() : Value(width),
      height: height == null && nullToAbsent ? const Value.absent() : Value(height),
      createdAt: Value(createdAt),
    );
  }

  factory ArtworkEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArtworkEntry(
      key: serializer.fromJson<String>(json['key']),
      path: serializer.fromJson<String>(json['path']),
      primaryColor: serializer.fromJson<int?>(json['primaryColor']),
      secondaryColor: serializer.fromJson<int?>(json['secondaryColor']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'path': serializer.toJson<String>(path),
      'primaryColor': serializer.toJson<int?>(primaryColor),
      'secondaryColor': serializer.toJson<int?>(secondaryColor),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ArtworkEntry copyWith({
    String? key,
    String? path,
    Value<int?> primaryColor = const Value.absent(),
    Value<int?> secondaryColor = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    DateTime? createdAt,
  }) => ArtworkEntry(
    key: key ?? this.key,
    path: path ?? this.path,
    primaryColor: primaryColor.present ? primaryColor.value : this.primaryColor,
    secondaryColor: secondaryColor.present ? secondaryColor.value : this.secondaryColor,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    createdAt: createdAt ?? this.createdAt,
  );
  ArtworkEntry copyWithCompanion(ArtworkCacheCompanion data) {
    return ArtworkEntry(
      key: data.key.present ? data.key.value : this.key,
      path: data.path.present ? data.path.value : this.path,
      primaryColor: data.primaryColor.present ? data.primaryColor.value : this.primaryColor,
      secondaryColor: data.secondaryColor.present ? data.secondaryColor.value : this.secondaryColor,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArtworkEntry(')
          ..write('key: $key, ')
          ..write('path: $path, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('secondaryColor: $secondaryColor, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, path, primaryColor, secondaryColor, width, height, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArtworkEntry &&
          other.key == this.key &&
          other.path == this.path &&
          other.primaryColor == this.primaryColor &&
          other.secondaryColor == this.secondaryColor &&
          other.width == this.width &&
          other.height == this.height &&
          other.createdAt == this.createdAt);
}

class ArtworkCacheCompanion extends UpdateCompanion<ArtworkEntry> {
  final Value<String> key;
  final Value<String> path;
  final Value<int?> primaryColor;
  final Value<int?> secondaryColor;
  final Value<int?> width;
  final Value<int?> height;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ArtworkCacheCompanion({
    this.key = const Value.absent(),
    this.path = const Value.absent(),
    this.primaryColor = const Value.absent(),
    this.secondaryColor = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtworkCacheCompanion.insert({
    required String key,
    required String path,
    this.primaryColor = const Value.absent(),
    this.secondaryColor = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       path = Value(path),
       createdAt = Value(createdAt);
  static Insertable<ArtworkEntry> custom({
    Expression<String>? key,
    Expression<String>? path,
    Expression<int>? primaryColor,
    Expression<int>? secondaryColor,
    Expression<int>? width,
    Expression<int>? height,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (path != null) 'path': path,
      if (primaryColor != null) 'primary_color': primaryColor,
      if (secondaryColor != null) 'secondary_color': secondaryColor,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtworkCacheCompanion copyWith({
    Value<String>? key,
    Value<String>? path,
    Value<int?>? primaryColor,
    Value<int?>? secondaryColor,
    Value<int?>? width,
    Value<int?>? height,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ArtworkCacheCompanion(
      key: key ?? this.key,
      path: path ?? this.path,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (primaryColor.present) {
      map['primary_color'] = Variable<int>(primaryColor.value);
    }
    if (secondaryColor.present) {
      map['secondary_color'] = Variable<int>(secondaryColor.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtworkCacheCompanion(')
          ..write('key: $key, ')
          ..write('path: $path, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('secondaryColor: $secondaryColor, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportJobsTable extends ImportJobs with TableInfo<$ImportJobsTable, ImportJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ImportJobType, int> jobType = GeneratedColumn<int>(
    'job_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<ImportJobType>($ImportJobsTable.$converterjobType);
  @override
  late final GeneratedColumnWithTypeConverter<ImportJobStatus, int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<ImportJobStatus>($ImportJobsTable.$converterstatus);
  static const VerificationMeta _progressMeta = const VerificationMeta('progress');
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta('trackId');
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, source, jobType, status, progress, startedAt, completedAt, error, trackId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_jobs';
  @override
  VerificationContext validateIntegrity(Insertable<ImportJob> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta, source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta, progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta, startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(_completedAtMeta, completedAt.isAcceptableOrUnknown(data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('error')) {
      context.handle(_errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    }
    if (data.containsKey('track_id')) {
      context.handle(_trackIdMeta, trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportJob(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      source: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      jobType: $ImportJobsTable.$converterjobType.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}job_type'])!,
      ),
      status: $ImportJobsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      ),
      progress: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}progress'])!,
      startedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      error: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}error']),
      trackId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}track_id']),
    );
  }

  @override
  $ImportJobsTable createAlias(String alias) {
    return $ImportJobsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ImportJobType, int, int> $converterjobType = const EnumIndexConverter<ImportJobType>(
    ImportJobType.values,
  );
  static JsonTypeConverter2<ImportJobStatus, int, int> $converterstatus = const EnumIndexConverter<ImportJobStatus>(
    ImportJobStatus.values,
  );
}

class ImportJob extends DataClass implements Insertable<ImportJob> {
  final int id;
  final String source;
  final ImportJobType jobType;
  final ImportJobStatus status;
  final double progress;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? error;
  final String? trackId;
  const ImportJob({
    required this.id,
    required this.source,
    required this.jobType,
    required this.status,
    required this.progress,
    required this.startedAt,
    this.completedAt,
    this.error,
    this.trackId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source'] = Variable<String>(source);
    {
      map['job_type'] = Variable<int>($ImportJobsTable.$converterjobType.toSql(jobType));
    }
    {
      map['status'] = Variable<int>($ImportJobsTable.$converterstatus.toSql(status));
    }
    map['progress'] = Variable<double>(progress);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    if (!nullToAbsent || trackId != null) {
      map['track_id'] = Variable<String>(trackId);
    }
    return map;
  }

  ImportJobsCompanion toCompanion(bool nullToAbsent) {
    return ImportJobsCompanion(
      id: Value(id),
      source: Value(source),
      jobType: Value(jobType),
      status: Value(status),
      progress: Value(progress),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent ? const Value.absent() : Value(completedAt),
      error: error == null && nullToAbsent ? const Value.absent() : Value(error),
      trackId: trackId == null && nullToAbsent ? const Value.absent() : Value(trackId),
    );
  }

  factory ImportJob.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportJob(
      id: serializer.fromJson<int>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      jobType: $ImportJobsTable.$converterjobType.fromJson(serializer.fromJson<int>(json['jobType'])),
      status: $ImportJobsTable.$converterstatus.fromJson(serializer.fromJson<int>(json['status'])),
      progress: serializer.fromJson<double>(json['progress']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      error: serializer.fromJson<String?>(json['error']),
      trackId: serializer.fromJson<String?>(json['trackId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'source': serializer.toJson<String>(source),
      'jobType': serializer.toJson<int>($ImportJobsTable.$converterjobType.toJson(jobType)),
      'status': serializer.toJson<int>($ImportJobsTable.$converterstatus.toJson(status)),
      'progress': serializer.toJson<double>(progress),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'error': serializer.toJson<String?>(error),
      'trackId': serializer.toJson<String?>(trackId),
    };
  }

  ImportJob copyWith({
    int? id,
    String? source,
    ImportJobType? jobType,
    ImportJobStatus? status,
    double? progress,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> error = const Value.absent(),
    Value<String?> trackId = const Value.absent(),
  }) => ImportJob(
    id: id ?? this.id,
    source: source ?? this.source,
    jobType: jobType ?? this.jobType,
    status: status ?? this.status,
    progress: progress ?? this.progress,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    error: error.present ? error.value : this.error,
    trackId: trackId.present ? trackId.value : this.trackId,
  );
  ImportJob copyWithCompanion(ImportJobsCompanion data) {
    return ImportJob(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      jobType: data.jobType.present ? data.jobType.value : this.jobType,
      status: data.status.present ? data.status.value : this.status,
      progress: data.progress.present ? data.progress.value : this.progress,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present ? data.completedAt.value : this.completedAt,
      error: data.error.present ? data.error.value : this.error,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportJob(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('jobType: $jobType, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('error: $error, ')
          ..write('trackId: $trackId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, source, jobType, status, progress, startedAt, completedAt, error, trackId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportJob &&
          other.id == this.id &&
          other.source == this.source &&
          other.jobType == this.jobType &&
          other.status == this.status &&
          other.progress == this.progress &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.error == this.error &&
          other.trackId == this.trackId);
}

class ImportJobsCompanion extends UpdateCompanion<ImportJob> {
  final Value<int> id;
  final Value<String> source;
  final Value<ImportJobType> jobType;
  final Value<ImportJobStatus> status;
  final Value<double> progress;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String?> error;
  final Value<String?> trackId;
  const ImportJobsCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.jobType = const Value.absent(),
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.error = const Value.absent(),
    this.trackId = const Value.absent(),
  });
  ImportJobsCompanion.insert({
    this.id = const Value.absent(),
    required String source,
    required ImportJobType jobType,
    required ImportJobStatus status,
    this.progress = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.error = const Value.absent(),
    this.trackId = const Value.absent(),
  }) : source = Value(source),
       jobType = Value(jobType),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<ImportJob> custom({
    Expression<int>? id,
    Expression<String>? source,
    Expression<int>? jobType,
    Expression<int>? status,
    Expression<double>? progress,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? error,
    Expression<String>? trackId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (jobType != null) 'job_type': jobType,
      if (status != null) 'status': status,
      if (progress != null) 'progress': progress,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (error != null) 'error': error,
      if (trackId != null) 'track_id': trackId,
    });
  }

  ImportJobsCompanion copyWith({
    Value<int>? id,
    Value<String>? source,
    Value<ImportJobType>? jobType,
    Value<ImportJobStatus>? status,
    Value<double>? progress,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String?>? error,
    Value<String?>? trackId,
  }) {
    return ImportJobsCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      jobType: jobType ?? this.jobType,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      error: error ?? this.error,
      trackId: trackId ?? this.trackId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (jobType.present) {
      map['job_type'] = Variable<int>($ImportJobsTable.$converterjobType.toSql(jobType.value));
    }
    if (status.present) {
      map['status'] = Variable<int>($ImportJobsTable.$converterstatus.toSql(status.value));
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportJobsCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('jobType: $jobType, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('error: $error, ')
          ..write('trackId: $trackId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TracksTable tracks = $TracksTable(this);
  late final $EmbeddedTagsTable embeddedTags = $EmbeddedTagsTable(this);
  late final $TrackArtistsTable trackArtists = $TrackArtistsTable(this);
  late final $FavoriteAlbumsTable favoriteAlbums = $FavoriteAlbumsTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistTracksTable playlistTracks = $PlaylistTracksTable(this);
  late final $PlaybackHistoryTable playbackHistory = $PlaybackHistoryTable(this);
  late final $ListeningSessionsTable listeningSessions = $ListeningSessionsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $TrackTagsTable trackTags = $TrackTagsTable(this);
  late final $SearchHistoryTable searchHistory = $SearchHistoryTable(this);
  late final $ArtworkCacheTable artworkCache = $ArtworkCacheTable(this);
  late final $ImportJobsTable importJobs = $ImportJobsTable(this);
  late final Index idxTracksTitle = Index('idx_tracks_title', 'CREATE INDEX idx_tracks_title ON tracks (title_key)');
  late final Index idxTracksArtist = Index(
    'idx_tracks_artist',
    'CREATE INDEX idx_tracks_artist ON tracks (artist_key)',
  );
  late final Index idxTracksAlbum = Index('idx_tracks_album', 'CREATE INDEX idx_tracks_album ON tracks (album_key)');
  late final Index idxTracksGenre = Index('idx_tracks_genre', 'CREATE INDEX idx_tracks_genre ON tracks (genre)');
  late final Index idxTracksLanguage = Index(
    'idx_tracks_language',
    'CREATE INDEX idx_tracks_language ON tracks (language)',
  );
  late final Index idxTracksDateAdded = Index(
    'idx_tracks_date_added',
    'CREATE INDEX idx_tracks_date_added ON tracks (date_added)',
  );
  late final Index idxTracksPlayCount = Index(
    'idx_tracks_play_count',
    'CREATE INDEX idx_tracks_play_count ON tracks (play_count)',
  );
  late final Index idxTracksHash = Index('idx_tracks_hash', 'CREATE INDEX idx_tracks_hash ON tracks (file_hash)');
  late final Index idxTrackArtistsKey = Index(
    'idx_track_artists_key',
    'CREATE INDEX idx_track_artists_key ON track_artists (artist_key)',
  );
  late final Index idxPlaylistTracksOrder = Index(
    'idx_playlist_tracks_order',
    'CREATE INDEX idx_playlist_tracks_order ON playlist_tracks (playlist_id, position)',
  );
  late final Index idxHistoryStarted = Index(
    'idx_history_started',
    'CREATE INDEX idx_history_started ON playback_history (started_at)',
  );
  late final Index idxHistoryTrack = Index(
    'idx_history_track',
    'CREATE INDEX idx_history_track ON playback_history (track_id)',
  );
  late final TracksDao tracksDao = TracksDao(this as AppDatabase);
  late final PlaylistsDao playlistsDao = PlaylistsDao(this as AppDatabase);
  late final HistoryDao historyDao = HistoryDao(this as AppDatabase);
  late final TagsDao tagsDao = TagsDao(this as AppDatabase);
  late final MiscDao miscDao = MiscDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tracks,
    embeddedTags,
    trackArtists,
    favoriteAlbums,
    playlists,
    playlistTracks,
    playbackHistory,
    listeningSessions,
    tags,
    trackTags,
    searchHistory,
    artworkCache,
    importJobs,
    idxTracksTitle,
    idxTracksArtist,
    idxTracksAlbum,
    idxTracksGenre,
    idxTracksLanguage,
    idxTracksDateAdded,
    idxTracksPlayCount,
    idxTracksHash,
    idxTrackArtistsKey,
    idxPlaylistTracksOrder,
    idxHistoryStarted,
    idxHistoryTrack,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName('tracks', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('embedded_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('tracks', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('track_artists', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('playlists', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('playlist_tracks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('tracks', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('playlist_tracks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('tracks', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('playback_history', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('tracks', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('track_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('tags', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('track_tags', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$TracksTableCreateCompanionBuilder = TracksCompanion Function({
  required String id,
  required String sourceUri,
  required TrackSourceType sourceType,
  Value<String?> originalFileName,
  required String title,
  Value<String?> artist,
  Value<String?> album,
  Value<String?> albumArtist,
  Value<String?> genre,
  Value<String?> language,
  Value<String?> composer,
  Value<int?> releaseYear,
  Value<int?> durationMs,
  Value<int?> trackNumber,
  Value<int?> discNumber,
  Value<String?> artworkKey,
  Value<int?> fileSizeBytes,
  required String fileHash,
  required DateTime dateAdded,
  Value<DateTime?> lastModified,
  Value<DateTime?> lastPlayedAt,
  Value<int> playCount,
  Value<int> skipCount,
  Value<int?> rating,
  Value<String> metadataSource,
  Value<Availability> availability,
  Value<bool> isFavorite,
  Value<bool> isCompilation,
  Value<int?> lastPositionMs,
  Value<String> overriddenFields,
  required String titleKey,
  required String artistKey,
  required String albumKey,
  required String searchText,
  Value<int> rowid,
});
typedef $$TracksTableUpdateCompanionBuilder = TracksCompanion Function({
  Value<String> id,
  Value<String> sourceUri,
  Value<TrackSourceType> sourceType,
  Value<String?> originalFileName,
  Value<String> title,
  Value<String?> artist,
  Value<String?> album,
  Value<String?> albumArtist,
  Value<String?> genre,
  Value<String?> language,
  Value<String?> composer,
  Value<int?> releaseYear,
  Value<int?> durationMs,
  Value<int?> trackNumber,
  Value<int?> discNumber,
  Value<String?> artworkKey,
  Value<int?> fileSizeBytes,
  Value<String> fileHash,
  Value<DateTime> dateAdded,
  Value<DateTime?> lastModified,
  Value<DateTime?> lastPlayedAt,
  Value<int> playCount,
  Value<int> skipCount,
  Value<int?> rating,
  Value<String> metadataSource,
  Value<Availability> availability,
  Value<bool> isFavorite,
  Value<bool> isCompilation,
  Value<int?> lastPositionMs,
  Value<String> overriddenFields,
  Value<String> titleKey,
  Value<String> artistKey,
  Value<String> albumKey,
  Value<String> searchText,
  Value<int> rowid,
});

final class $$TracksTableReferences extends BaseReferences<_$AppDatabase, $TracksTable, Track> {
  $$TracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EmbeddedTagsTable, List<EmbeddedTag>> _embeddedTagsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.embeddedTags, aliasName: 'tracks__id__embedded_tags__track_id');

  $$EmbeddedTagsTableProcessedTableManager get embeddedTagsRefs {
    final manager = $$EmbeddedTagsTableTableManager(
      $_db,
      $_db.embeddedTags,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_embeddedTagsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TrackArtistsTable, List<TrackArtist>> _trackArtistsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.trackArtists, aliasName: 'tracks__id__track_artists__track_id');

  $$TrackArtistsTableProcessedTableManager get trackArtistsRefs {
    final manager = $$TrackArtistsTableTableManager(
      $_db,
      $_db.trackArtists,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackArtistsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlaylistTracksTable, List<PlaylistEntry>> _playlistTracksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.playlistTracks, aliasName: 'tracks__id__playlist_tracks__track_id');

  $$PlaylistTracksTableProcessedTableManager get playlistTracksRefs {
    final manager = $$PlaylistTracksTableTableManager(
      $_db,
      $_db.playlistTracks,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistTracksRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlaybackHistoryTable, List<PlaybackRecord>> _playbackHistoryRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.playbackHistory, aliasName: 'tracks__id__playback_history__track_id');

  $$PlaybackHistoryTableProcessedTableManager get playbackHistoryRefs {
    final manager = $$PlaybackHistoryTableTableManager(
      $_db,
      $_db.playbackHistory,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playbackHistoryRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TrackTagsTable, List<TrackTag>> _trackTagsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.trackTags, aliasName: 'tracks__id__track_tags__track_id');

  $$TrackTagsTableProcessedTableManager get trackTagsRefs {
    final manager = $$TrackTagsTableTableManager(
      $_db,
      $_db.trackTags,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackTagsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TracksTableFilterComposer extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceUri =>
      $composableBuilder(column: $table.sourceUri, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TrackSourceType, TrackSourceType, int> get sourceType =>
      $composableBuilder(column: $table.sourceType, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get originalFileName =>
      $composableBuilder(column: $table.originalFileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get album =>
      $composableBuilder(column: $table.album, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get albumArtist =>
      $composableBuilder(column: $table.albumArtist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get composer =>
      $composableBuilder(column: $table.composer, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get releaseYear =>
      $composableBuilder(column: $table.releaseYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMs =>
      $composableBuilder(column: $table.durationMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get trackNumber =>
      $composableBuilder(column: $table.trackNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discNumber =>
      $composableBuilder(column: $table.discNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artworkKey =>
      $composableBuilder(column: $table.artworkKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSizeBytes =>
      $composableBuilder(column: $table.fileSizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastModified =>
      $composableBuilder(column: $table.lastModified, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPlayedAt =>
      $composableBuilder(column: $table.lastPlayedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playCount =>
      $composableBuilder(column: $table.playCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get skipCount =>
      $composableBuilder(column: $table.skipCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataSource =>
      $composableBuilder(column: $table.metadataSource, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Availability, Availability, int> get availability =>
      $composableBuilder(column: $table.availability, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isFavorite =>
      $composableBuilder(column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompilation =>
      $composableBuilder(column: $table.isCompilation, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastPositionMs =>
      $composableBuilder(column: $table.lastPositionMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overriddenFields =>
      $composableBuilder(column: $table.overriddenFields, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistKey =>
      $composableBuilder(column: $table.artistKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get albumKey =>
      $composableBuilder(column: $table.albumKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get searchText =>
      $composableBuilder(column: $table.searchText, builder: (column) => ColumnFilters(column));

  Expression<bool> embeddedTagsRefs(Expression<bool> Function($$EmbeddedTagsTableFilterComposer f) f) {
    final $$EmbeddedTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.embeddedTags,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$EmbeddedTagsTableFilterComposer(
            $db: $db,
            $table: $db.embeddedTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trackArtistsRefs(Expression<bool> Function($$TrackArtistsTableFilterComposer f) f) {
    final $$TrackArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackArtists,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TrackArtistsTableFilterComposer(
            $db: $db,
            $table: $db.trackArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playlistTracksRefs(Expression<bool> Function($$PlaylistTracksTableFilterComposer f) f) {
    final $$PlaylistTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTracks,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlaylistTracksTableFilterComposer(
            $db: $db,
            $table: $db.playlistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playbackHistoryRefs(Expression<bool> Function($$PlaybackHistoryTableFilterComposer f) f) {
    final $$PlaybackHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playbackHistory,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlaybackHistoryTableFilterComposer(
            $db: $db,
            $table: $db.playbackHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trackTagsRefs(Expression<bool> Function($$TrackTagsTableFilterComposer f) f) {
    final $$TrackTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackTags,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TrackTagsTableFilterComposer(
            $db: $db,
            $table: $db.trackTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TracksTableOrderingComposer extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceUri =>
      $composableBuilder(column: $table.sourceUri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceType =>
      $composableBuilder(column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalFileName =>
      $composableBuilder(column: $table.originalFileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get album =>
      $composableBuilder(column: $table.album, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get albumArtist =>
      $composableBuilder(column: $table.albumArtist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get composer =>
      $composableBuilder(column: $table.composer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get releaseYear =>
      $composableBuilder(column: $table.releaseYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMs =>
      $composableBuilder(column: $table.durationMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get trackNumber =>
      $composableBuilder(column: $table.trackNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discNumber =>
      $composableBuilder(column: $table.discNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artworkKey =>
      $composableBuilder(column: $table.artworkKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSizeBytes =>
      $composableBuilder(column: $table.fileSizeBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastModified =>
      $composableBuilder(column: $table.lastModified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPlayedAt =>
      $composableBuilder(column: $table.lastPlayedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playCount =>
      $composableBuilder(column: $table.playCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get skipCount =>
      $composableBuilder(column: $table.skipCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataSource =>
      $composableBuilder(column: $table.metadataSource, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get availability =>
      $composableBuilder(column: $table.availability, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite =>
      $composableBuilder(column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompilation =>
      $composableBuilder(column: $table.isCompilation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastPositionMs =>
      $composableBuilder(column: $table.lastPositionMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overriddenFields =>
      $composableBuilder(column: $table.overriddenFields, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistKey =>
      $composableBuilder(column: $table.artistKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get albumKey =>
      $composableBuilder(column: $table.albumKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchText =>
      $composableBuilder(column: $table.searchText, builder: (column) => ColumnOrderings(column));
}

class $$TracksTableAnnotationComposer extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceUri => $composableBuilder(column: $table.sourceUri, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TrackSourceType, int> get sourceType =>
      $composableBuilder(column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<String> get originalFileName =>
      $composableBuilder(column: $table.originalFileName, builder: (column) => column);

  GeneratedColumn<String> get title => $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist => $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get album => $composableBuilder(column: $table.album, builder: (column) => column);

  GeneratedColumn<String> get albumArtist =>
      $composableBuilder(column: $table.albumArtist, builder: (column) => column);

  GeneratedColumn<String> get genre => $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get language => $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get composer => $composableBuilder(column: $table.composer, builder: (column) => column);

  GeneratedColumn<int> get releaseYear => $composableBuilder(column: $table.releaseYear, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(column: $table.durationMs, builder: (column) => column);

  GeneratedColumn<int> get trackNumber => $composableBuilder(column: $table.trackNumber, builder: (column) => column);

  GeneratedColumn<int> get discNumber => $composableBuilder(column: $table.discNumber, builder: (column) => column);

  GeneratedColumn<String> get artworkKey => $composableBuilder(column: $table.artworkKey, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes =>
      $composableBuilder(column: $table.fileSizeBytes, builder: (column) => column);

  GeneratedColumn<String> get fileHash => $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded => $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified =>
      $composableBuilder(column: $table.lastModified, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPlayedAt =>
      $composableBuilder(column: $table.lastPlayedAt, builder: (column) => column);

  GeneratedColumn<int> get playCount => $composableBuilder(column: $table.playCount, builder: (column) => column);

  GeneratedColumn<int> get skipCount => $composableBuilder(column: $table.skipCount, builder: (column) => column);

  GeneratedColumn<int> get rating => $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get metadataSource =>
      $composableBuilder(column: $table.metadataSource, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Availability, int> get availability =>
      $composableBuilder(column: $table.availability, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<bool> get isCompilation =>
      $composableBuilder(column: $table.isCompilation, builder: (column) => column);

  GeneratedColumn<int> get lastPositionMs =>
      $composableBuilder(column: $table.lastPositionMs, builder: (column) => column);

  GeneratedColumn<String> get overriddenFields =>
      $composableBuilder(column: $table.overriddenFields, builder: (column) => column);

  GeneratedColumn<String> get titleKey => $composableBuilder(column: $table.titleKey, builder: (column) => column);

  GeneratedColumn<String> get artistKey => $composableBuilder(column: $table.artistKey, builder: (column) => column);

  GeneratedColumn<String> get albumKey => $composableBuilder(column: $table.albumKey, builder: (column) => column);

  GeneratedColumn<String> get searchText => $composableBuilder(column: $table.searchText, builder: (column) => column);

  Expression<T> embeddedTagsRefs<T extends Object>(Expression<T> Function($$EmbeddedTagsTableAnnotationComposer a) f) {
    final $$EmbeddedTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.embeddedTags,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$EmbeddedTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.embeddedTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trackArtistsRefs<T extends Object>(Expression<T> Function($$TrackArtistsTableAnnotationComposer a) f) {
    final $$TrackArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackArtists,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TrackArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playlistTracksRefs<T extends Object>(
    Expression<T> Function($$PlaylistTracksTableAnnotationComposer a) f,
  ) {
    final $$PlaylistTracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTracks,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlaylistTracksTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playbackHistoryRefs<T extends Object>(
    Expression<T> Function($$PlaybackHistoryTableAnnotationComposer a) f,
  ) {
    final $$PlaybackHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playbackHistory,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlaybackHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.playbackHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trackTagsRefs<T extends Object>(Expression<T> Function($$TrackTagsTableAnnotationComposer a) f) {
    final $$TrackTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackTags,
      getReferencedColumn: (t) => t.trackId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TrackTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TracksTable,
          Track,
          $$TracksTableFilterComposer,
          $$TracksTableOrderingComposer,
          $$TracksTableAnnotationComposer,
          $$TracksTableCreateCompanionBuilder,
          $$TracksTableUpdateCompanionBuilder,
          (Track, $$TracksTableReferences),
          Track,
          PrefetchHooks Function({
            bool embeddedTagsRefs,
            bool trackArtistsRefs,
            bool playlistTracksRefs,
            bool playbackHistoryRefs,
            bool trackTagsRefs,
          })
        > {
  $$TracksTableTableManager(_$AppDatabase db, $TracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$TracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$TracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$TracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceUri = const Value.absent(),
                Value<TrackSourceType> sourceType = const Value.absent(),
                Value<String?> originalFileName = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> artist = const Value.absent(),
                Value<String?> album = const Value.absent(),
                Value<String?> albumArtist = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> composer = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                Value<String?> artworkKey = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<String> fileHash = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<DateTime?> lastModified = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<int> skipCount = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String> metadataSource = const Value.absent(),
                Value<Availability> availability = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isCompilation = const Value.absent(),
                Value<int?> lastPositionMs = const Value.absent(),
                Value<String> overriddenFields = const Value.absent(),
                Value<String> titleKey = const Value.absent(),
                Value<String> artistKey = const Value.absent(),
                Value<String> albumKey = const Value.absent(),
                Value<String> searchText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TracksCompanion(
                id: id,
                sourceUri: sourceUri,
                sourceType: sourceType,
                originalFileName: originalFileName,
                title: title,
                artist: artist,
                album: album,
                albumArtist: albumArtist,
                genre: genre,
                language: language,
                composer: composer,
                releaseYear: releaseYear,
                durationMs: durationMs,
                trackNumber: trackNumber,
                discNumber: discNumber,
                artworkKey: artworkKey,
                fileSizeBytes: fileSizeBytes,
                fileHash: fileHash,
                dateAdded: dateAdded,
                lastModified: lastModified,
                lastPlayedAt: lastPlayedAt,
                playCount: playCount,
                skipCount: skipCount,
                rating: rating,
                metadataSource: metadataSource,
                availability: availability,
                isFavorite: isFavorite,
                isCompilation: isCompilation,
                lastPositionMs: lastPositionMs,
                overriddenFields: overriddenFields,
                titleKey: titleKey,
                artistKey: artistKey,
                albumKey: albumKey,
                searchText: searchText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceUri,
                required TrackSourceType sourceType,
                Value<String?> originalFileName = const Value.absent(),
                required String title,
                Value<String?> artist = const Value.absent(),
                Value<String?> album = const Value.absent(),
                Value<String?> albumArtist = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> composer = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                Value<String?> artworkKey = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                required String fileHash,
                required DateTime dateAdded,
                Value<DateTime?> lastModified = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<int> skipCount = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String> metadataSource = const Value.absent(),
                Value<Availability> availability = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isCompilation = const Value.absent(),
                Value<int?> lastPositionMs = const Value.absent(),
                Value<String> overriddenFields = const Value.absent(),
                required String titleKey,
                required String artistKey,
                required String albumKey,
                required String searchText,
                Value<int> rowid = const Value.absent(),
              }) => TracksCompanion.insert(
                id: id,
                sourceUri: sourceUri,
                sourceType: sourceType,
                originalFileName: originalFileName,
                title: title,
                artist: artist,
                album: album,
                albumArtist: albumArtist,
                genre: genre,
                language: language,
                composer: composer,
                releaseYear: releaseYear,
                durationMs: durationMs,
                trackNumber: trackNumber,
                discNumber: discNumber,
                artworkKey: artworkKey,
                fileSizeBytes: fileSizeBytes,
                fileHash: fileHash,
                dateAdded: dateAdded,
                lastModified: lastModified,
                lastPlayedAt: lastPlayedAt,
                playCount: playCount,
                skipCount: skipCount,
                rating: rating,
                metadataSource: metadataSource,
                availability: availability,
                isFavorite: isFavorite,
                isCompilation: isCompilation,
                lastPositionMs: lastPositionMs,
                overriddenFields: overriddenFields,
                titleKey: titleKey,
                artistKey: artistKey,
                albumKey: albumKey,
                searchText: searchText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable<$TracksTable, Track>(table), $$TracksTableReferences(db, table, e))).toList(),
          prefetchHooksCallback:
              ({
                embeddedTagsRefs = false,
                trackArtistsRefs = false,
                playlistTracksRefs = false,
                playbackHistoryRefs = false,
                trackTagsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (embeddedTagsRefs) db.embeddedTags,
                    if (trackArtistsRefs) db.trackArtists,
                    if (playlistTracksRefs) db.playlistTracks,
                    if (playbackHistoryRefs) db.playbackHistory,
                    if (trackTagsRefs) db.trackTags,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (embeddedTagsRefs)
                        await $_getPrefetchedDataByColumns<Track, $TracksTable, EmbeddedTag, $EmbeddedTagsTable>(
                          currentTable: table,
                          referencedTable: $$TracksTableReferences._embeddedTagsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TracksTableReferences(db, table, p0).embeddedTagsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'track_id',
                          typedResults: items,
                        ),
                      if (trackArtistsRefs)
                        await $_getPrefetchedDataByColumns<Track, $TracksTable, TrackArtist, $TrackArtistsTable>(
                          currentTable: table,
                          referencedTable: $$TracksTableReferences._trackArtistsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TracksTableReferences(db, table, p0).trackArtistsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'track_id',
                          typedResults: items,
                        ),
                      if (playlistTracksRefs)
                        await $_getPrefetchedDataByColumns<Track, $TracksTable, PlaylistEntry, $PlaylistTracksTable>(
                          currentTable: table,
                          referencedTable: $$TracksTableReferences._playlistTracksRefsTable(db),
                          managerFromTypedResult: (p0) => $$TracksTableReferences(db, table, p0).playlistTracksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'track_id',
                          typedResults: items,
                        ),
                      if (playbackHistoryRefs)
                        await $_getPrefetchedDataByColumns<Track, $TracksTable, PlaybackRecord, $PlaybackHistoryTable>(
                          currentTable: table,
                          referencedTable: $$TracksTableReferences._playbackHistoryRefsTable(db),
                          managerFromTypedResult: (p0) => $$TracksTableReferences(db, table, p0).playbackHistoryRefs,
                          currentColumn: 'id',
                          referencedColumn: 'track_id',
                          typedResults: items,
                        ),
                      if (trackTagsRefs)
                        await $_getPrefetchedDataByColumns<Track, $TracksTable, TrackTag, $TrackTagsTable>(
                          currentTable: table,
                          referencedTable: $$TracksTableReferences._trackTagsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TracksTableReferences(db, table, p0).trackTagsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'track_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TracksTable,
      Track,
      $$TracksTableFilterComposer,
      $$TracksTableOrderingComposer,
      $$TracksTableAnnotationComposer,
      $$TracksTableCreateCompanionBuilder,
      $$TracksTableUpdateCompanionBuilder,
      (Track, $$TracksTableReferences),
      Track,
      PrefetchHooks Function({
        bool embeddedTagsRefs,
        bool trackArtistsRefs,
        bool playlistTracksRefs,
        bool playbackHistoryRefs,
        bool trackTagsRefs,
      })
    >;
typedef $$EmbeddedTagsTableCreateCompanionBuilder = EmbeddedTagsCompanion Function({
  required String trackId,
  Value<String?> title,
  Value<String?> artist,
  Value<String?> album,
  Value<String?> albumArtist,
  Value<String?> genre,
  Value<String?> language,
  Value<int?> releaseYear,
  Value<String?> artworkKey,
  Value<int> rowid,
});
typedef $$EmbeddedTagsTableUpdateCompanionBuilder = EmbeddedTagsCompanion Function({
  Value<String> trackId,
  Value<String?> title,
  Value<String?> artist,
  Value<String?> album,
  Value<String?> albumArtist,
  Value<String?> genre,
  Value<String?> language,
  Value<int?> releaseYear,
  Value<String?> artworkKey,
  Value<int> rowid,
});

final class $$EmbeddedTagsTableReferences extends BaseReferences<_$AppDatabase, $EmbeddedTagsTable, EmbeddedTag> {
  $$EmbeddedTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TracksTable _trackIdTable(_$AppDatabase db) => db.tracks.createAlias('embedded_tags__track_id__tracks__id');

  $$TracksTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<String>('track_id')!;

    final manager = $$TracksTableTableManager($_db, $_db.tracks).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EmbeddedTagsTableFilterComposer extends Composer<_$AppDatabase, $EmbeddedTagsTable> {
  $$EmbeddedTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get album =>
      $composableBuilder(column: $table.album, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get albumArtist =>
      $composableBuilder(column: $table.albumArtist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get releaseYear =>
      $composableBuilder(column: $table.releaseYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artworkKey =>
      $composableBuilder(column: $table.artworkKey, builder: (column) => ColumnFilters(column));

  $$TracksTableFilterComposer get trackId {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmbeddedTagsTableOrderingComposer extends Composer<_$AppDatabase, $EmbeddedTagsTable> {
  $$EmbeddedTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get album =>
      $composableBuilder(column: $table.album, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get albumArtist =>
      $composableBuilder(column: $table.albumArtist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get releaseYear =>
      $composableBuilder(column: $table.releaseYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artworkKey =>
      $composableBuilder(column: $table.artworkKey, builder: (column) => ColumnOrderings(column));

  $$TracksTableOrderingComposer get trackId {
    final $$TracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableOrderingComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmbeddedTagsTableAnnotationComposer extends Composer<_$AppDatabase, $EmbeddedTagsTable> {
  $$EmbeddedTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get title => $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist => $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get album => $composableBuilder(column: $table.album, builder: (column) => column);

  GeneratedColumn<String> get albumArtist =>
      $composableBuilder(column: $table.albumArtist, builder: (column) => column);

  GeneratedColumn<String> get genre => $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get language => $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get releaseYear => $composableBuilder(column: $table.releaseYear, builder: (column) => column);

  GeneratedColumn<String> get artworkKey => $composableBuilder(column: $table.artworkKey, builder: (column) => column);

  $$TracksTableAnnotationComposer get trackId {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmbeddedTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmbeddedTagsTable,
          EmbeddedTag,
          $$EmbeddedTagsTableFilterComposer,
          $$EmbeddedTagsTableOrderingComposer,
          $$EmbeddedTagsTableAnnotationComposer,
          $$EmbeddedTagsTableCreateCompanionBuilder,
          $$EmbeddedTagsTableUpdateCompanionBuilder,
          (EmbeddedTag, $$EmbeddedTagsTableReferences),
          EmbeddedTag,
          PrefetchHooks Function({bool trackId})
        > {
  $$EmbeddedTagsTableTableManager(_$AppDatabase db, $EmbeddedTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$EmbeddedTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$EmbeddedTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$EmbeddedTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> trackId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> artist = const Value.absent(),
                Value<String?> album = const Value.absent(),
                Value<String?> albumArtist = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<String?> artworkKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmbeddedTagsCompanion(
                trackId: trackId,
                title: title,
                artist: artist,
                album: album,
                albumArtist: albumArtist,
                genre: genre,
                language: language,
                releaseYear: releaseYear,
                artworkKey: artworkKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String trackId,
                Value<String?> title = const Value.absent(),
                Value<String?> artist = const Value.absent(),
                Value<String?> album = const Value.absent(),
                Value<String?> albumArtist = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<String?> artworkKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmbeddedTagsCompanion.insert(
                trackId: trackId,
                title: title,
                artist: artist,
                album: album,
                albumArtist: albumArtist,
                genre: genre,
                language: language,
                releaseYear: releaseYear,
                artworkKey: artworkKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable<$EmbeddedTagsTable, EmbeddedTag>(table), $$EmbeddedTagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trackId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.trackId,
                        referencedTable: $$EmbeddedTagsTableReferences._trackIdTable(db),
                        referencedColumn: $$EmbeddedTagsTableReferences._trackIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmbeddedTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmbeddedTagsTable,
      EmbeddedTag,
      $$EmbeddedTagsTableFilterComposer,
      $$EmbeddedTagsTableOrderingComposer,
      $$EmbeddedTagsTableAnnotationComposer,
      $$EmbeddedTagsTableCreateCompanionBuilder,
      $$EmbeddedTagsTableUpdateCompanionBuilder,
      (EmbeddedTag, $$EmbeddedTagsTableReferences),
      EmbeddedTag,
      PrefetchHooks Function({bool trackId})
    >;
typedef $$TrackArtistsTableCreateCompanionBuilder = TrackArtistsCompanion Function({
  required String trackId,
  required String artistKey,
  required String name,
  Value<int> rowid,
});
typedef $$TrackArtistsTableUpdateCompanionBuilder = TrackArtistsCompanion Function({
  Value<String> trackId,
  Value<String> artistKey,
  Value<String> name,
  Value<int> rowid,
});

final class $$TrackArtistsTableReferences extends BaseReferences<_$AppDatabase, $TrackArtistsTable, TrackArtist> {
  $$TrackArtistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TracksTable _trackIdTable(_$AppDatabase db) => db.tracks.createAlias('track_artists__track_id__tracks__id');

  $$TracksTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<String>('track_id')!;

    final manager = $$TracksTableTableManager($_db, $_db.tracks).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TrackArtistsTableFilterComposer extends Composer<_$AppDatabase, $TrackArtistsTable> {
  $$TrackArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get artistKey =>
      $composableBuilder(column: $table.artistKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  $$TracksTableFilterComposer get trackId {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackArtistsTableOrderingComposer extends Composer<_$AppDatabase, $TrackArtistsTable> {
  $$TrackArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get artistKey =>
      $composableBuilder(column: $table.artistKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  $$TracksTableOrderingComposer get trackId {
    final $$TracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableOrderingComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackArtistsTableAnnotationComposer extends Composer<_$AppDatabase, $TrackArtistsTable> {
  $$TrackArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get artistKey => $composableBuilder(column: $table.artistKey, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  $$TracksTableAnnotationComposer get trackId {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackArtistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackArtistsTable,
          TrackArtist,
          $$TrackArtistsTableFilterComposer,
          $$TrackArtistsTableOrderingComposer,
          $$TrackArtistsTableAnnotationComposer,
          $$TrackArtistsTableCreateCompanionBuilder,
          $$TrackArtistsTableUpdateCompanionBuilder,
          (TrackArtist, $$TrackArtistsTableReferences),
          TrackArtist,
          PrefetchHooks Function({bool trackId})
        > {
  $$TrackArtistsTableTableManager(_$AppDatabase db, $TrackArtistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$TrackArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$TrackArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$TrackArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> trackId = const Value.absent(),
            Value<String> artistKey = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => TrackArtistsCompanion(trackId: trackId, artistKey: artistKey, name: name, rowid: rowid),
          createCompanionCallback: ({
            required String trackId,
            required String artistKey,
            required String name,
            Value<int> rowid = const Value.absent(),
          }) => TrackArtistsCompanion.insert(trackId: trackId, artistKey: artistKey, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable<$TrackArtistsTable, TrackArtist>(table), $$TrackArtistsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trackId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.trackId,
                        referencedTable: $$TrackArtistsTableReferences._trackIdTable(db),
                        referencedColumn: $$TrackArtistsTableReferences._trackIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackArtistsTable,
      TrackArtist,
      $$TrackArtistsTableFilterComposer,
      $$TrackArtistsTableOrderingComposer,
      $$TrackArtistsTableAnnotationComposer,
      $$TrackArtistsTableCreateCompanionBuilder,
      $$TrackArtistsTableUpdateCompanionBuilder,
      (TrackArtist, $$TrackArtistsTableReferences),
      TrackArtist,
      PrefetchHooks Function({bool trackId})
    >;
typedef $$FavoriteAlbumsTableCreateCompanionBuilder = FavoriteAlbumsCompanion Function({
  required String albumKey,
  required String artistKey,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FavoriteAlbumsTableUpdateCompanionBuilder = FavoriteAlbumsCompanion Function({
  Value<String> albumKey,
  Value<String> artistKey,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FavoriteAlbumsTableFilterComposer extends Composer<_$AppDatabase, $FavoriteAlbumsTable> {
  $$FavoriteAlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get albumKey =>
      $composableBuilder(column: $table.albumKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistKey =>
      $composableBuilder(column: $table.artistKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FavoriteAlbumsTableOrderingComposer extends Composer<_$AppDatabase, $FavoriteAlbumsTable> {
  $$FavoriteAlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get albumKey =>
      $composableBuilder(column: $table.albumKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistKey =>
      $composableBuilder(column: $table.artistKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoriteAlbumsTableAnnotationComposer extends Composer<_$AppDatabase, $FavoriteAlbumsTable> {
  $$FavoriteAlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get albumKey => $composableBuilder(column: $table.albumKey, builder: (column) => column);

  GeneratedColumn<String> get artistKey => $composableBuilder(column: $table.artistKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoriteAlbumsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteAlbumsTable,
          FavoriteAlbum,
          $$FavoriteAlbumsTableFilterComposer,
          $$FavoriteAlbumsTableOrderingComposer,
          $$FavoriteAlbumsTableAnnotationComposer,
          $$FavoriteAlbumsTableCreateCompanionBuilder,
          $$FavoriteAlbumsTableUpdateCompanionBuilder,
          (FavoriteAlbum, BaseReferences<_$AppDatabase, $FavoriteAlbumsTable, FavoriteAlbum>),
          FavoriteAlbum,
          PrefetchHooks Function()
        > {
  $$FavoriteAlbumsTableTableManager(_$AppDatabase db, $FavoriteAlbumsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$FavoriteAlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$FavoriteAlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$FavoriteAlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> albumKey = const Value.absent(),
            Value<String> artistKey = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => FavoriteAlbumsCompanion(albumKey: albumKey, artistKey: artistKey, createdAt: createdAt, rowid: rowid),
          createCompanionCallback:
              ({
                required String albumKey,
                required String artistKey,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FavoriteAlbumsCompanion.insert(
                albumKey: albumKey,
                artistKey: artistKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FavoriteAlbumsTable, FavoriteAlbum>(table),
                  BaseReferences<_$AppDatabase, $FavoriteAlbumsTable, FavoriteAlbum>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoriteAlbumsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteAlbumsTable,
      FavoriteAlbum,
      $$FavoriteAlbumsTableFilterComposer,
      $$FavoriteAlbumsTableOrderingComposer,
      $$FavoriteAlbumsTableAnnotationComposer,
      $$FavoriteAlbumsTableCreateCompanionBuilder,
      $$FavoriteAlbumsTableUpdateCompanionBuilder,
      (FavoriteAlbum, BaseReferences<_$AppDatabase, $FavoriteAlbumsTable, FavoriteAlbum>),
      FavoriteAlbum,
      PrefetchHooks Function()
    >;
typedef $$PlaylistsTableCreateCompanionBuilder = PlaylistsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  Value<String?> artworkKey,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> sortOrder,
  Value<bool> isSystem,
});
typedef $$PlaylistsTableUpdateCompanionBuilder = PlaylistsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> artworkKey,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> sortOrder,
  Value<bool> isSystem,
});

final class $$PlaylistsTableReferences extends BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist> {
  $$PlaylistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistTracksTable, List<PlaylistEntry>> _playlistTracksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.playlistTracks, aliasName: 'playlists__id__playlist_tracks__playlist_id');

  $$PlaylistTracksTableProcessedTableManager get playlistTracksRefs {
    final manager = $$PlaylistTracksTableTableManager(
      $_db,
      $_db.playlistTracks,
    ).filter((f) => f.playlistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistTracksRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlaylistsTableFilterComposer extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artworkKey =>
      $composableBuilder(column: $table.artworkKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => ColumnFilters(column));

  Expression<bool> playlistTracksRefs(Expression<bool> Function($$PlaylistTracksTableFilterComposer f) f) {
    final $$PlaylistTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTracks,
      getReferencedColumn: (t) => t.playlistId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlaylistTracksTableFilterComposer(
            $db: $db,
            $table: $db.playlistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableOrderingComposer extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artworkKey =>
      $composableBuilder(column: $table.artworkKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => ColumnOrderings(column));
}

class $$PlaylistsTableAnnotationComposer extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get artworkKey => $composableBuilder(column: $table.artworkKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder => $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isSystem => $composableBuilder(column: $table.isSystem, builder: (column) => column);

  Expression<T> playlistTracksRefs<T extends Object>(
    Expression<T> Function($$PlaylistTracksTableAnnotationComposer a) f,
  ) {
    final $$PlaylistTracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistTracks,
      getReferencedColumn: (t) => t.playlistId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlaylistTracksTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistsTable,
          Playlist,
          $$PlaylistsTableFilterComposer,
          $$PlaylistsTableOrderingComposer,
          $$PlaylistsTableAnnotationComposer,
          $$PlaylistsTableCreateCompanionBuilder,
          $$PlaylistsTableUpdateCompanionBuilder,
          (Playlist, $$PlaylistsTableReferences),
          Playlist,
          PrefetchHooks Function({bool playlistTracksRefs})
        > {
  $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> artworkKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
              }) => PlaylistsCompanion(
                id: id,
                name: name,
                description: description,
                artworkKey: artworkKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isSystem: isSystem,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> artworkKey = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
              }) => PlaylistsCompanion.insert(
                id: id,
                name: name,
                description: description,
                artworkKey: artworkKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                isSystem: isSystem,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable<$PlaylistsTable, Playlist>(table), $$PlaylistsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({playlistTracksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (playlistTracksRefs) db.playlistTracks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistTracksRefs)
                    await $_getPrefetchedDataByColumns<Playlist, $PlaylistsTable, PlaylistEntry, $PlaylistTracksTable>(
                      currentTable: table,
                      referencedTable: $$PlaylistsTableReferences._playlistTracksRefsTable(db),
                      managerFromTypedResult: (p0) => $$PlaylistsTableReferences(db, table, p0).playlistTracksRefs,
                      currentColumn: 'id',
                      referencedColumn: 'playlist_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistsTable,
      Playlist,
      $$PlaylistsTableFilterComposer,
      $$PlaylistsTableOrderingComposer,
      $$PlaylistsTableAnnotationComposer,
      $$PlaylistsTableCreateCompanionBuilder,
      $$PlaylistsTableUpdateCompanionBuilder,
      (Playlist, $$PlaylistsTableReferences),
      Playlist,
      PrefetchHooks Function({bool playlistTracksRefs})
    >;
typedef $$PlaylistTracksTableCreateCompanionBuilder = PlaylistTracksCompanion Function({
  Value<int> id,
  required int playlistId,
  required String trackId,
  required int position,
  required DateTime addedAt,
});
typedef $$PlaylistTracksTableUpdateCompanionBuilder = PlaylistTracksCompanion Function({
  Value<int> id,
  Value<int> playlistId,
  Value<String> trackId,
  Value<int> position,
  Value<DateTime> addedAt,
});

final class $$PlaylistTracksTableReferences extends BaseReferences<_$AppDatabase, $PlaylistTracksTable, PlaylistEntry> {
  $$PlaylistTracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlaylistsTable _playlistIdTable(_$AppDatabase db) =>
      db.playlists.createAlias('playlist_tracks__playlist_id__playlists__id');

  $$PlaylistsTableProcessedTableManager get playlistId {
    final $_column = $_itemColumn<int>('playlist_id')!;

    final manager = $$PlaylistsTableTableManager($_db, $_db.playlists).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TracksTable _trackIdTable(_$AppDatabase db) => db.tracks.createAlias('playlist_tracks__track_id__tracks__id');

  $$TracksTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<String>('track_id')!;

    final manager = $$TracksTableTableManager($_db, $_db.tracks).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlaylistTracksTableFilterComposer extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => ColumnFilters(column));

  $$PlaylistsTableFilterComposer get playlistId {
    final $$PlaylistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlaylistsTableFilterComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TracksTableFilterComposer get trackId {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistTracksTableOrderingComposer extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  $$PlaylistsTableOrderingComposer get playlistId {
    final $$PlaylistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlaylistsTableOrderingComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TracksTableOrderingComposer get trackId {
    final $$TracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableOrderingComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistTracksTableAnnotationComposer extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt => $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$PlaylistsTableAnnotationComposer get playlistId {
    final $$PlaylistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PlaylistsTableAnnotationComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TracksTableAnnotationComposer get trackId {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistTracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistTracksTable,
          PlaylistEntry,
          $$PlaylistTracksTableFilterComposer,
          $$PlaylistTracksTableOrderingComposer,
          $$PlaylistTracksTableAnnotationComposer,
          $$PlaylistTracksTableCreateCompanionBuilder,
          $$PlaylistTracksTableUpdateCompanionBuilder,
          (PlaylistEntry, $$PlaylistTracksTableReferences),
          PlaylistEntry,
          PrefetchHooks Function({bool playlistId, bool trackId})
        > {
  $$PlaylistTracksTableTableManager(_$AppDatabase db, $PlaylistTracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlaylistTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlaylistTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlaylistTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playlistId = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => PlaylistTracksCompanion(
                id: id,
                playlistId: playlistId,
                trackId: trackId,
                position: position,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int playlistId,
                required String trackId,
                required int position,
                required DateTime addedAt,
              }) => PlaylistTracksCompanion.insert(
                id: id,
                playlistId: playlistId,
                trackId: trackId,
                position: position,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaylistTracksTable, PlaylistEntry>(table),
                  $$PlaylistTracksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistId = false, trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (playlistId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.playlistId,
                        referencedTable: $$PlaylistTracksTableReferences._playlistIdTable(db),
                        referencedColumn: $$PlaylistTracksTableReferences._playlistIdTable(db).id,
                      ) as T;
                    }
                    if (trackId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.trackId,
                        referencedTable: $$PlaylistTracksTableReferences._trackIdTable(db),
                        referencedColumn: $$PlaylistTracksTableReferences._trackIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistTracksTable,
      PlaylistEntry,
      $$PlaylistTracksTableFilterComposer,
      $$PlaylistTracksTableOrderingComposer,
      $$PlaylistTracksTableAnnotationComposer,
      $$PlaylistTracksTableCreateCompanionBuilder,
      $$PlaylistTracksTableUpdateCompanionBuilder,
      (PlaylistEntry, $$PlaylistTracksTableReferences),
      PlaylistEntry,
      PrefetchHooks Function({bool playlistId, bool trackId})
    >;
typedef $$PlaybackHistoryTableCreateCompanionBuilder = PlaybackHistoryCompanion Function({
  Value<int> id,
  required String trackId,
  required DateTime startedAt,
  Value<DateTime?> endedAt,
  Value<int> listenedMs,
  Value<bool> counted,
  Value<bool> completed,
  Value<bool> skipped,
  Value<String?> context,
});
typedef $$PlaybackHistoryTableUpdateCompanionBuilder = PlaybackHistoryCompanion Function({
  Value<int> id,
  Value<String> trackId,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> listenedMs,
  Value<bool> counted,
  Value<bool> completed,
  Value<bool> skipped,
  Value<String?> context,
});

final class $$PlaybackHistoryTableReferences
    extends BaseReferences<_$AppDatabase, $PlaybackHistoryTable, PlaybackRecord> {
  $$PlaybackHistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TracksTable _trackIdTable(_$AppDatabase db) =>
      db.tracks.createAlias('playback_history__track_id__tracks__id');

  $$TracksTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<String>('track_id')!;

    final manager = $$TracksTableTableManager($_db, $_db.tracks).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlaybackHistoryTableFilterComposer extends Composer<_$AppDatabase, $PlaybackHistoryTable> {
  $$PlaybackHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get listenedMs =>
      $composableBuilder(column: $table.listenedMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get counted =>
      $composableBuilder(column: $table.counted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => ColumnFilters(column));

  $$TracksTableFilterComposer get trackId {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackHistoryTableOrderingComposer extends Composer<_$AppDatabase, $PlaybackHistoryTable> {
  $$PlaybackHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get listenedMs =>
      $composableBuilder(column: $table.listenedMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get counted =>
      $composableBuilder(column: $table.counted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => ColumnOrderings(column));

  $$TracksTableOrderingComposer get trackId {
    final $$TracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableOrderingComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackHistoryTableAnnotationComposer extends Composer<_$AppDatabase, $PlaybackHistoryTable> {
  $$PlaybackHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt => $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt => $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get listenedMs => $composableBuilder(column: $table.listenedMs, builder: (column) => column);

  GeneratedColumn<bool> get counted => $composableBuilder(column: $table.counted, builder: (column) => column);

  GeneratedColumn<bool> get completed => $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<bool> get skipped => $composableBuilder(column: $table.skipped, builder: (column) => column);

  GeneratedColumn<String> get context => $composableBuilder(column: $table.context, builder: (column) => column);

  $$TracksTableAnnotationComposer get trackId {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaybackHistoryTable,
          PlaybackRecord,
          $$PlaybackHistoryTableFilterComposer,
          $$PlaybackHistoryTableOrderingComposer,
          $$PlaybackHistoryTableAnnotationComposer,
          $$PlaybackHistoryTableCreateCompanionBuilder,
          $$PlaybackHistoryTableUpdateCompanionBuilder,
          (PlaybackRecord, $$PlaybackHistoryTableReferences),
          PlaybackRecord,
          PrefetchHooks Function({bool trackId})
        > {
  $$PlaybackHistoryTableTableManager(_$AppDatabase db, $PlaybackHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlaybackHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlaybackHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlaybackHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> listenedMs = const Value.absent(),
                Value<bool> counted = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<String?> context = const Value.absent(),
              }) => PlaybackHistoryCompanion(
                id: id,
                trackId: trackId,
                startedAt: startedAt,
                endedAt: endedAt,
                listenedMs: listenedMs,
                counted: counted,
                completed: completed,
                skipped: skipped,
                context: context,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String trackId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> listenedMs = const Value.absent(),
                Value<bool> counted = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<String?> context = const Value.absent(),
              }) => PlaybackHistoryCompanion.insert(
                id: id,
                trackId: trackId,
                startedAt: startedAt,
                endedAt: endedAt,
                listenedMs: listenedMs,
                counted: counted,
                completed: completed,
                skipped: skipped,
                context: context,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaybackHistoryTable, PlaybackRecord>(table),
                  $$PlaybackHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trackId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.trackId,
                        referencedTable: $$PlaybackHistoryTableReferences._trackIdTable(db),
                        referencedColumn: $$PlaybackHistoryTableReferences._trackIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaybackHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaybackHistoryTable,
      PlaybackRecord,
      $$PlaybackHistoryTableFilterComposer,
      $$PlaybackHistoryTableOrderingComposer,
      $$PlaybackHistoryTableAnnotationComposer,
      $$PlaybackHistoryTableCreateCompanionBuilder,
      $$PlaybackHistoryTableUpdateCompanionBuilder,
      (PlaybackRecord, $$PlaybackHistoryTableReferences),
      PlaybackRecord,
      PrefetchHooks Function({bool trackId})
    >;
typedef $$ListeningSessionsTableCreateCompanionBuilder = ListeningSessionsCompanion Function({
  Value<int> id,
  required DateTime startedAt,
  required DateTime endedAt,
  Value<int> totalListeningMs,
});
typedef $$ListeningSessionsTableUpdateCompanionBuilder = ListeningSessionsCompanion Function({
  Value<int> id,
  Value<DateTime> startedAt,
  Value<DateTime> endedAt,
  Value<int> totalListeningMs,
});

class $$ListeningSessionsTableFilterComposer extends Composer<_$AppDatabase, $ListeningSessionsTable> {
  $$ListeningSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalListeningMs =>
      $composableBuilder(column: $table.totalListeningMs, builder: (column) => ColumnFilters(column));
}

class $$ListeningSessionsTableOrderingComposer extends Composer<_$AppDatabase, $ListeningSessionsTable> {
  $$ListeningSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalListeningMs =>
      $composableBuilder(column: $table.totalListeningMs, builder: (column) => ColumnOrderings(column));
}

class $$ListeningSessionsTableAnnotationComposer extends Composer<_$AppDatabase, $ListeningSessionsTable> {
  $$ListeningSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt => $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt => $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get totalListeningMs =>
      $composableBuilder(column: $table.totalListeningMs, builder: (column) => column);
}

class $$ListeningSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListeningSessionsTable,
          ListeningSession,
          $$ListeningSessionsTableFilterComposer,
          $$ListeningSessionsTableOrderingComposer,
          $$ListeningSessionsTableAnnotationComposer,
          $$ListeningSessionsTableCreateCompanionBuilder,
          $$ListeningSessionsTableUpdateCompanionBuilder,
          (ListeningSession, BaseReferences<_$AppDatabase, $ListeningSessionsTable, ListeningSession>),
          ListeningSession,
          PrefetchHooks Function()
        > {
  $$ListeningSessionsTableTableManager(_$AppDatabase db, $ListeningSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ListeningSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ListeningSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ListeningSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> totalListeningMs = const Value.absent(),
              }) => ListeningSessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                totalListeningMs: totalListeningMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                required DateTime endedAt,
                Value<int> totalListeningMs = const Value.absent(),
              }) => ListeningSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                totalListeningMs: totalListeningMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ListeningSessionsTable, ListeningSession>(table),
                  BaseReferences<_$AppDatabase, $ListeningSessionsTable, ListeningSession>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ListeningSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListeningSessionsTable,
      ListeningSession,
      $$ListeningSessionsTableFilterComposer,
      $$ListeningSessionsTableOrderingComposer,
      $$ListeningSessionsTableAnnotationComposer,
      $$ListeningSessionsTableCreateCompanionBuilder,
      $$ListeningSessionsTableUpdateCompanionBuilder,
      (ListeningSession, BaseReferences<_$AppDatabase, $ListeningSessionsTable, ListeningSession>),
      ListeningSession,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
  required TagKind kind,
  Value<int?> color,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<TagKind> kind,
  Value<int?> color,
});

final class $$TagsTableReferences extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TrackTagsTable, List<TrackTag>> _trackTagsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.trackTags, aliasName: 'tags__id__track_tags__tag_id');

  $$TrackTagsTableProcessedTableManager get trackTagsRefs {
    final manager = $$TrackTagsTableTableManager(
      $_db,
      $_db.trackTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackTagsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TagKind, TagKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get color => $composableBuilder(column: $table.color, builder: (column) => ColumnFilters(column));

  Expression<bool> trackTagsRefs(Expression<bool> Function($$TrackTagsTableFilterComposer f) f) {
    final $$TrackTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackTags,
      getReferencedColumn: (t) => t.tagId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TrackTagsTableFilterComposer(
            $db: $db,
            $table: $db.trackTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableAnnotationComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TagKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get color => $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> trackTagsRefs<T extends Object>(Expression<T> Function($$TrackTagsTableAnnotationComposer a) f) {
    final $$TrackTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackTags,
      getReferencedColumn: (t) => t.tagId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TrackTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool trackTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<TagKind> kind = const Value.absent(),
            Value<int?> color = const Value.absent(),
          }) => TagsCompanion(id: id, name: name, kind: kind, color: color),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required TagKind kind,
            Value<int?> color = const Value.absent(),
          }) => TagsCompanion.insert(id: id, name: name, kind: kind, color: color),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable<$TagsTable, Tag>(table), $$TagsTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({trackTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (trackTagsRefs) db.trackTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (trackTagsRefs)
                    await $_getPrefetchedDataByColumns<Tag, $TagsTable, TrackTag, $TrackTagsTable>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._trackTagsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TagsTableReferences(db, table, p0).trackTagsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'tag_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool trackTagsRefs})
    >;
typedef $$TrackTagsTableCreateCompanionBuilder = TrackTagsCompanion Function({
  required String trackId,
  required int tagId,
  Value<bool> excluded,
  Value<int> rowid,
});
typedef $$TrackTagsTableUpdateCompanionBuilder = TrackTagsCompanion Function({
  Value<String> trackId,
  Value<int> tagId,
  Value<bool> excluded,
  Value<int> rowid,
});

final class $$TrackTagsTableReferences extends BaseReferences<_$AppDatabase, $TrackTagsTable, TrackTag> {
  $$TrackTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TracksTable _trackIdTable(_$AppDatabase db) => db.tracks.createAlias('track_tags__track_id__tracks__id');

  $$TracksTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<String>('track_id')!;

    final manager = $$TracksTableTableManager($_db, $_db.tracks).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags.createAlias('track_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager($_db, $_db.tags).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TrackTagsTableFilterComposer extends Composer<_$AppDatabase, $TrackTagsTable> {
  $$TrackTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get excluded =>
      $composableBuilder(column: $table.excluded, builder: (column) => ColumnFilters(column));

  $$TracksTableFilterComposer get trackId {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackTagsTableOrderingComposer extends Composer<_$AppDatabase, $TrackTagsTable> {
  $$TrackTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get excluded =>
      $composableBuilder(column: $table.excluded, builder: (column) => ColumnOrderings(column));

  $$TracksTableOrderingComposer get trackId {
    final $$TracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableOrderingComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackTagsTableAnnotationComposer extends Composer<_$AppDatabase, $TrackTagsTable> {
  $$TrackTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get excluded => $composableBuilder(column: $table.excluded, builder: (column) => column);

  $$TracksTableAnnotationComposer get trackId {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackTagsTable,
          TrackTag,
          $$TrackTagsTableFilterComposer,
          $$TrackTagsTableOrderingComposer,
          $$TrackTagsTableAnnotationComposer,
          $$TrackTagsTableCreateCompanionBuilder,
          $$TrackTagsTableUpdateCompanionBuilder,
          (TrackTag, $$TrackTagsTableReferences),
          TrackTag,
          PrefetchHooks Function({bool trackId, bool tagId})
        > {
  $$TrackTagsTableTableManager(_$AppDatabase db, $TrackTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$TrackTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$TrackTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$TrackTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> trackId = const Value.absent(),
            Value<int> tagId = const Value.absent(),
            Value<bool> excluded = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => TrackTagsCompanion(trackId: trackId, tagId: tagId, excluded: excluded, rowid: rowid),
          createCompanionCallback: ({
            required String trackId,
            required int tagId,
            Value<bool> excluded = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => TrackTagsCompanion.insert(trackId: trackId, tagId: tagId, excluded: excluded, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable<$TrackTagsTable, TrackTag>(table), $$TrackTagsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({trackId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trackId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.trackId,
                        referencedTable: $$TrackTagsTableReferences._trackIdTable(db),
                        referencedColumn: $$TrackTagsTableReferences._trackIdTable(db).id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$TrackTagsTableReferences._tagIdTable(db),
                        referencedColumn: $$TrackTagsTableReferences._tagIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackTagsTable,
      TrackTag,
      $$TrackTagsTableFilterComposer,
      $$TrackTagsTableOrderingComposer,
      $$TrackTagsTableAnnotationComposer,
      $$TrackTagsTableCreateCompanionBuilder,
      $$TrackTagsTableUpdateCompanionBuilder,
      (TrackTag, $$TrackTagsTableReferences),
      TrackTag,
      PrefetchHooks Function({bool trackId, bool tagId})
    >;
typedef $$SearchHistoryTableCreateCompanionBuilder = SearchHistoryCompanion Function({
  Value<int> id,
  required String query,
  required DateTime searchedAt,
});
typedef $$SearchHistoryTableUpdateCompanionBuilder = SearchHistoryCompanion Function({
  Value<int> id,
  Value<String> query,
  Value<DateTime> searchedAt,
});

class $$SearchHistoryTableFilterComposer extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get searchedAt =>
      $composableBuilder(column: $table.searchedAt, builder: (column) => ColumnFilters(column));
}

class $$SearchHistoryTableOrderingComposer extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get searchedAt =>
      $composableBuilder(column: $table.searchedAt, builder: (column) => ColumnOrderings(column));
}

class $$SearchHistoryTableAnnotationComposer extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get query => $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get searchedAt =>
      $composableBuilder(column: $table.searchedAt, builder: (column) => column);
}

class $$SearchHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SearchHistoryTable,
          SearchEntry,
          $$SearchHistoryTableFilterComposer,
          $$SearchHistoryTableOrderingComposer,
          $$SearchHistoryTableAnnotationComposer,
          $$SearchHistoryTableCreateCompanionBuilder,
          $$SearchHistoryTableUpdateCompanionBuilder,
          (SearchEntry, BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchEntry>),
          SearchEntry,
          PrefetchHooks Function()
        > {
  $$SearchHistoryTableTableManager(_$AppDatabase db, $SearchHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SearchHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SearchHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SearchHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> query = const Value.absent(),
            Value<DateTime> searchedAt = const Value.absent(),
          }) => SearchHistoryCompanion(id: id, query: query, searchedAt: searchedAt),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String query,
            required DateTime searchedAt,
          }) => SearchHistoryCompanion.insert(id: id, query: query, searchedAt: searchedAt),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SearchHistoryTable, SearchEntry>(table),
                  BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchEntry>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SearchHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SearchHistoryTable,
      SearchEntry,
      $$SearchHistoryTableFilterComposer,
      $$SearchHistoryTableOrderingComposer,
      $$SearchHistoryTableAnnotationComposer,
      $$SearchHistoryTableCreateCompanionBuilder,
      $$SearchHistoryTableUpdateCompanionBuilder,
      (SearchEntry, BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchEntry>),
      SearchEntry,
      PrefetchHooks Function()
    >;
typedef $$ArtworkCacheTableCreateCompanionBuilder = ArtworkCacheCompanion Function({
  required String key,
  required String path,
  Value<int?> primaryColor,
  Value<int?> secondaryColor,
  Value<int?> width,
  Value<int?> height,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ArtworkCacheTableUpdateCompanionBuilder = ArtworkCacheCompanion Function({
  Value<String> key,
  Value<String> path,
  Value<int?> primaryColor,
  Value<int?> secondaryColor,
  Value<int?> width,
  Value<int?> height,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ArtworkCacheTableFilterComposer extends Composer<_$AppDatabase, $ArtworkCacheTable> {
  $$ArtworkCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get primaryColor =>
      $composableBuilder(column: $table.primaryColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get secondaryColor =>
      $composableBuilder(column: $table.secondaryColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get width => $composableBuilder(column: $table.width, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ArtworkCacheTableOrderingComposer extends Composer<_$AppDatabase, $ArtworkCacheTable> {
  $$ArtworkCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get primaryColor =>
      $composableBuilder(column: $table.primaryColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get secondaryColor =>
      $composableBuilder(column: $table.secondaryColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ArtworkCacheTableAnnotationComposer extends Composer<_$AppDatabase, $ArtworkCacheTable> {
  $$ArtworkCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key => $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get path => $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get primaryColor => $composableBuilder(column: $table.primaryColor, builder: (column) => column);

  GeneratedColumn<int> get secondaryColor =>
      $composableBuilder(column: $table.secondaryColor, builder: (column) => column);

  GeneratedColumn<int> get width => $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height => $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ArtworkCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArtworkCacheTable,
          ArtworkEntry,
          $$ArtworkCacheTableFilterComposer,
          $$ArtworkCacheTableOrderingComposer,
          $$ArtworkCacheTableAnnotationComposer,
          $$ArtworkCacheTableCreateCompanionBuilder,
          $$ArtworkCacheTableUpdateCompanionBuilder,
          (ArtworkEntry, BaseReferences<_$AppDatabase, $ArtworkCacheTable, ArtworkEntry>),
          ArtworkEntry,
          PrefetchHooks Function()
        > {
  $$ArtworkCacheTableTableManager(_$AppDatabase db, $ArtworkCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ArtworkCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ArtworkCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ArtworkCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int?> primaryColor = const Value.absent(),
                Value<int?> secondaryColor = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtworkCacheCompanion(
                key: key,
                path: path,
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                width: width,
                height: height,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String path,
                Value<int?> primaryColor = const Value.absent(),
                Value<int?> secondaryColor = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ArtworkCacheCompanion.insert(
                key: key,
                path: path,
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                width: width,
                height: height,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ArtworkCacheTable, ArtworkEntry>(table),
                  BaseReferences<_$AppDatabase, $ArtworkCacheTable, ArtworkEntry>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArtworkCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArtworkCacheTable,
      ArtworkEntry,
      $$ArtworkCacheTableFilterComposer,
      $$ArtworkCacheTableOrderingComposer,
      $$ArtworkCacheTableAnnotationComposer,
      $$ArtworkCacheTableCreateCompanionBuilder,
      $$ArtworkCacheTableUpdateCompanionBuilder,
      (ArtworkEntry, BaseReferences<_$AppDatabase, $ArtworkCacheTable, ArtworkEntry>),
      ArtworkEntry,
      PrefetchHooks Function()
    >;
typedef $$ImportJobsTableCreateCompanionBuilder = ImportJobsCompanion Function({
  Value<int> id,
  required String source,
  required ImportJobType jobType,
  required ImportJobStatus status,
  Value<double> progress,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  Value<String?> error,
  Value<String?> trackId,
});
typedef $$ImportJobsTableUpdateCompanionBuilder = ImportJobsCompanion Function({
  Value<int> id,
  Value<String> source,
  Value<ImportJobType> jobType,
  Value<ImportJobStatus> status,
  Value<double> progress,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<String?> error,
  Value<String?> trackId,
});

class $$ImportJobsTableFilterComposer extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ImportJobType, ImportJobType, int> get jobType =>
      $composableBuilder(column: $table.jobType, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<ImportJobStatus, ImportJobStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => ColumnFilters(column));
}

class $$ImportJobsTableOrderingComposer extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jobType =>
      $composableBuilder(column: $table.jobType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => ColumnOrderings(column));
}

class $$ImportJobsTableAnnotationComposer extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source => $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ImportJobType, int> get jobType =>
      $composableBuilder(column: $table.jobType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ImportJobStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get progress => $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt => $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get error => $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<String> get trackId => $composableBuilder(column: $table.trackId, builder: (column) => column);
}

class $$ImportJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportJobsTable,
          ImportJob,
          $$ImportJobsTableFilterComposer,
          $$ImportJobsTableOrderingComposer,
          $$ImportJobsTableAnnotationComposer,
          $$ImportJobsTableCreateCompanionBuilder,
          $$ImportJobsTableUpdateCompanionBuilder,
          (ImportJob, BaseReferences<_$AppDatabase, $ImportJobsTable, ImportJob>),
          ImportJob,
          PrefetchHooks Function()
        > {
  $$ImportJobsTableTableManager(_$AppDatabase db, $ImportJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ImportJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ImportJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ImportJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<ImportJobType> jobType = const Value.absent(),
                Value<ImportJobStatus> status = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> trackId = const Value.absent(),
              }) => ImportJobsCompanion(
                id: id,
                source: source,
                jobType: jobType,
                status: status,
                progress: progress,
                startedAt: startedAt,
                completedAt: completedAt,
                error: error,
                trackId: trackId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String source,
                required ImportJobType jobType,
                required ImportJobStatus status,
                Value<double> progress = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> trackId = const Value.absent(),
              }) => ImportJobsCompanion.insert(
                id: id,
                source: source,
                jobType: jobType,
                status: status,
                progress: progress,
                startedAt: startedAt,
                completedAt: completedAt,
                error: error,
                trackId: trackId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportJobsTable, ImportJob>(table),
                  BaseReferences<_$AppDatabase, $ImportJobsTable, ImportJob>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImportJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportJobsTable,
      ImportJob,
      $$ImportJobsTableFilterComposer,
      $$ImportJobsTableOrderingComposer,
      $$ImportJobsTableAnnotationComposer,
      $$ImportJobsTableCreateCompanionBuilder,
      $$ImportJobsTableUpdateCompanionBuilder,
      (ImportJob, BaseReferences<_$AppDatabase, $ImportJobsTable, ImportJob>),
      ImportJob,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TracksTableTableManager get tracks => $$TracksTableTableManager(_db, _db.tracks);
  $$EmbeddedTagsTableTableManager get embeddedTags => $$EmbeddedTagsTableTableManager(_db, _db.embeddedTags);
  $$TrackArtistsTableTableManager get trackArtists => $$TrackArtistsTableTableManager(_db, _db.trackArtists);
  $$FavoriteAlbumsTableTableManager get favoriteAlbums => $$FavoriteAlbumsTableTableManager(_db, _db.favoriteAlbums);
  $$PlaylistsTableTableManager get playlists => $$PlaylistsTableTableManager(_db, _db.playlists);
  $$PlaylistTracksTableTableManager get playlistTracks => $$PlaylistTracksTableTableManager(_db, _db.playlistTracks);
  $$PlaybackHistoryTableTableManager get playbackHistory =>
      $$PlaybackHistoryTableTableManager(_db, _db.playbackHistory);
  $$ListeningSessionsTableTableManager get listeningSessions =>
      $$ListeningSessionsTableTableManager(_db, _db.listeningSessions);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$TrackTagsTableTableManager get trackTags => $$TrackTagsTableTableManager(_db, _db.trackTags);
  $$SearchHistoryTableTableManager get searchHistory => $$SearchHistoryTableTableManager(_db, _db.searchHistory);
  $$ArtworkCacheTableTableManager get artworkCache => $$ArtworkCacheTableTableManager(_db, _db.artworkCache);
  $$ImportJobsTableTableManager get importJobs => $$ImportJobsTableTableManager(_db, _db.importJobs);
}
