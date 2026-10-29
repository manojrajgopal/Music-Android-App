/// Text normalization used for grouping, duplicate detection and search.
///
/// Normalized keys are lowercase, whitespace-collapsed and stripped of
/// punctuation. Letters and combining marks from every script are preserved,
/// so Kannada and other Indic scripts remain searchable.
library;

final _nonWord = RegExp(r'[^\p{L}\p{M}\p{N}]+', unicode: true);
final _spaces = RegExp(r'\s+');

const _latinFolds = {
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ã': 'a',
  'ä': 'a',
  'å': 'a',
  'ā': 'a',
  'ç': 'c',
  'č': 'c',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ē': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ī': 'i',
  'ñ': 'n',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'õ': 'o',
  'ö': 'o',
  'ø': 'o',
  'ō': 'o',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ü': 'u',
  'ū': 'u',
  'ý': 'y',
  'ÿ': 'y',
  'š': 's',
  'ž': 'z',
  'ß': 'ss',
};

/// Returns a stable key for grouping and matching. Empty for null/blank input.
String normalizeKey(String? input) {
  if (input == null) return '';
  final lower = input.toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(_latinFolds[ch] ?? ch);
  }
  return buffer.toString().replaceAll(_nonWord, ' ').replaceAll(_spaces, ' ').trim();
}

/// Trims a user-visible value and collapses internal whitespace.
/// Returns null when nothing meaningful remains.
String? cleanDisplay(String? input) {
  if (input == null) return null;
  final cleaned = input.replaceAll('\u0000', ' ').replaceAll(_spaces, ' ').trim();
  return cleaned.isEmpty ? null : cleaned;
}

/// Builds the denormalized search column stored on each track.
String buildSearchText(Iterable<String?> fields) => fields.map(normalizeKey).where((f) => f.isNotEmpty).join(' | ');

final _artistSeparators = RegExp(r'\s*(?:;|\u0000|\s+feat\.?\s+|\s+ft\.?\s+|\s+featuring\s+)\s*', caseSensitive: false);

/// Splits a multi-artist credit into individual names. Deliberately
/// conservative: "&", "/" and "," are kept because band names use them.
List<String> splitArtists(String? credit) {
  final cleaned = credit?.trim();
  if (cleaned == null || cleaned.isEmpty) return const [];
  return cleaned.split(_artistSeparators).map(cleanDisplay).whereType<String>().toSet().toList();
}

const _languageNames = {
  'en': 'English',
  'eng': 'English',
  'english': 'English',
  'kn': 'Kannada',
  'kan': 'Kannada',
  'kannada': 'Kannada',
  'hi': 'Hindi',
  'hin': 'Hindi',
  'hindi': 'Hindi',
  'ta': 'Tamil',
  'tam': 'Tamil',
  'tamil': 'Tamil',
  'te': 'Telugu',
  'tel': 'Telugu',
  'telugu': 'Telugu',
  'ml': 'Malayalam',
  'mal': 'Malayalam',
  'malayalam': 'Malayalam',
  'mr': 'Marathi',
  'mar': 'Marathi',
  'bn': 'Bengali',
  'ben': 'Bengali',
  'pa': 'Punjabi',
  'pan': 'Punjabi',
  'gu': 'Gujarati',
  'guj': 'Gujarati',
  'es': 'Spanish',
  'spa': 'Spanish',
  'fr': 'French',
  'fra': 'French',
  'fre': 'French',
  'de': 'German',
  'deu': 'German',
  'ger': 'German',
  'ja': 'Japanese',
  'jpn': 'Japanese',
  'ko': 'Korean',
  'kor': 'Korean',
  'zh': 'Chinese',
  'zho': 'Chinese',
  'chi': 'Chinese',
  'pt': 'Portuguese',
  'por': 'Portuguese',
  'it': 'Italian',
  'ita': 'Italian',
  'ar': 'Arabic',
  'ara': 'Arabic',
  'ur': 'Urdu',
  'urd': 'Urdu',
};

const _unknownLanguages = {'', 'und', 'xxx', 'zxx', 'mul', 'unknown', 'none'};

/// Maps ISO 639 codes or free text to a display language name.
/// Unknown or "undetermined" values return null — never a guess.
String? normalizeLanguage(String? raw) {
  final key = raw?.trim().toLowerCase() ?? '';
  if (_unknownLanguages.contains(key)) return null;
  final known = _languageNames[key];
  if (known != null) return known;
  final cleaned = cleanDisplay(raw);
  if (cleaned == null) return null;
  return cleaned[0].toUpperCase() + cleaned.substring(1);
}

/// Accepts a release year only when it is plausible. Never falls back to
/// the current year or a file timestamp.
int? validReleaseYear(int? year, {DateTime? now}) {
  if (year == null) return null;
  final max = (now ?? DateTime.now()).year + 1;
  return year >= 1900 && year <= max ? year : null;
}
