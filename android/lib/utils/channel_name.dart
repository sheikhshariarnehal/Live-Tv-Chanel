/// Display-time normalisation for channel names.
///
/// The catalog is operator-curated and much of it originates from scraped M3U
/// playlists, so the same rail can contain `SONY AATH HD`, `Sony aath`,
/// `Gopal Bhar` and `0. Tom and Jerry 2` side by side. Rendering those verbatim
/// makes a carousel of otherwise identical cards look broken, and the shouting
/// all-caps entries dominate their neighbours.
///
/// This is a *display* transform only. [Channel.name] stays untouched so the
/// search index, analytics, and anything the operator dashboard round-trips keep
/// matching the source data.
library;

/// Leading playlist ordinals: `0. `, `12) `, `3 - `.
final RegExp _kIndexPrefix = RegExp(r'^\s*\d{1,4}\s*[.)\-:]\s+');

/// Trailing quality markers. [Channel.quality] already carries this and the
/// grid card renders it as its own badge, so repeating it in the name only
/// forces a second line.
final RegExp _kQualitySuffix = RegExp(
  r'[\s\-_|]+(?:FHD|UHD|HD|SD|4K|8K|2K|1080P?|720P?|576P?|480P?|360P?)$',
  caseSensitive: false,
);

final RegExp _kWhitespace = RegExp(r'\s+');

/// Tokens that must survive title-casing. Anything three characters or shorter
/// is preserved automatically; this list covers the longer acronyms that would
/// otherwise be mangled into `Espn` or `Sony Ten` style errors.
const Set<String> _kAcronyms = {
  'ESPN', 'FIFA', 'UEFA', 'AFC', 'EPL', 'IPL', 'PSL', 'BPL', 'CPL', 'T10',
  'T20', 'ODI', 'WWE', 'UFC', 'NBA', 'NFL', 'MLB', 'NHL', 'PGA', 'ATP', 'WTA',
  'HBO', 'BBC', 'CNN', 'MTV', 'AXN', 'TLC', 'VH1', 'ARY', 'OSN', 'BEIN',
  'NASA', 'RTHK', 'CCTV', 'KBS', 'NHK', 'TRT', 'DW', 'SABC', 'PTV', 'GTV',
  'ATN', 'NTV', 'RTV', 'BTV', 'ETV', 'ITV', 'ABC', 'CBS', 'NBC', 'FOX', 'TNT',
  'AMC', 'SET', 'SAB', 'PIX', 'MAX', 'TV', 'USA', 'UK', 'UAE', 'KSA', 'HD',
  'FHD', 'UHD', 'SD', '4K',
};

/// Lowercase connectives — never capitalised unless they lead the name.
const Set<String> _kMinorWords = {
  'and', 'or', 'of', 'the', 'a', 'an', 'in', 'on', 'at', 'to', 'for', 'vs',
};

/// Normalise [raw] for display.
///
/// * `0. Tom and Jerry 2` → `Tom and Jerry 2`
/// * `SONY AATH HD`       → `Sony Aath`
/// * `Sony aath`          → `Sony Aath`
/// * `Gopal Bhar`         → `Gopal Bhar` (unchanged)
/// * `ESPN 2`             → `ESPN 2` (acronym preserved)
///
/// Returns [raw] trimmed if normalisation would leave nothing behind, so a name
/// that is *only* an ordinal or a quality token never renders as an empty card.
String normalizeChannelName(String raw) {
  var name = raw.trim();
  if (name.isEmpty) return name;

  name = name.replaceFirst(_kIndexPrefix, '');

  // Loop: `Star Sports 1 HD FHD` carries two markers.
  String stripped = name.replaceFirst(_kQualitySuffix, '');
  while (stripped != name) {
    name = stripped;
    stripped = name.replaceFirst(_kQualitySuffix, '');
  }

  name = name.replaceAll(_kWhitespace, ' ').trim();
  if (name.isEmpty) return raw.trim();

  final words = name.split(' ');
  for (var i = 0; i < words.length; i++) {
    words[i] = _caseWord(words[i], isFirst: i == 0);
  }
  return words.join(' ');
}

String _caseWord(String word, {required bool isFirst}) {
  if (word.isEmpty) return word;

  final upper = word.toUpperCase();

  // Preserve genuine acronyms and any short all-caps token (TV, DD, SS, BD).
  if (_kAcronyms.contains(upper) ||
      (word == upper && word.length <= 3 && _hasLetter(word))) {
    return word == upper ? word : upper;
  }

  // Anything with no letters (numerals, `2`, `24/7`) passes through.
  if (!_hasLetter(word)) return word;

  if (!isFirst && _kMinorWords.contains(word.toLowerCase())) {
    return word.toLowerCase();
  }

  // Mixed-case words the operator typed on purpose (`beIN`, `iTunes`, `TNTx`)
  // are left alone: only fully-upper or fully-lower tokens get re-cased.
  final lower = word.toLowerCase();
  if (word != upper && word != lower) return word;

  return _capitalise(lower);
}

String _capitalise(String lower) {
  // Handles hyphenated and slashed compounds: `sky-sports` → `Sky-Sports`.
  final buffer = StringBuffer();
  var capitaliseNext = true;
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    if (ch == '-' || ch == '/' || ch == '.' || ch == "'") {
      buffer.write(ch);
      // Do not re-capitalise after an apostrophe: `today's`, not `Today'S`.
      capitaliseNext = ch != "'";
      continue;
    }
    buffer.write(capitaliseNext ? ch.toUpperCase() : ch);
    capitaliseNext = false;
  }
  return buffer.toString();
}

bool _hasLetter(String s) => s.contains(RegExp(r'[A-Za-z]'));
