import 'dart:collection';

abstract class Indexable {
  List<String> get indexData;
}

class InvertedIndex {
  final int tokenLength;

  final HashMap<String, HashMap<int, int>> _index;

  static const List<String> stopWords = <String>[
    'the',
    'for',
    'of',
    'in',
    'and',
    'with',
    'on',
    'with'
  ];

  static final RegExp _tokenSeparators = RegExp('[^a-z0-9.,]');

  factory InvertedIndex.fromList(List<Indexable> items, {int tokenLength = 3}) {
    final index = HashMap<String, HashMap<int, int>>();

    for (final doc in items.asMap().entries) {
      for (final field in doc.value.indexData) {
        final tokens = _tokenizer(field, tokenLength)
            .expand<String>((token) => ngram(token, tokenLength));
        for (final token in tokens) {
          final match = index[token];
          if (match != null) {
            var freq = match[doc.key] ?? 0;
            if (freq > 0) {
              freq++;
            } else {
              match[doc.key] = 1;
            }
          } else {
            final docs = HashMap<int, int>();
            docs[doc.key] = 1;
            index[token] = docs;
          }
        }
      }
    }

    return InvertedIndex._internal(index, tokenLength);
  }

  InvertedIndex._internal(this._index, this.tokenLength);

  static List<String> _tokenizer(String string, int min) => string
      .toLowerCase()
      .split(_tokenSeparators)
      .where((token) =>
          token.length >= min &&
          token.length <= 40 &&
          !stopWords.contains(token))
      .toList(growable: false);

  List<List<int>> search(String term) {
    final tokens = _tokenizer(term, tokenLength)
        .expand<String>((token) => ngram(token, tokenLength));

    final matchedTokens = HashSet<HashMap<int, int>>();
    for (final token in tokens) {
      final result = _index[token];
      if (result != null) matchedTokens.add(result);
    }

    final docs = HashMap<int, int>();
    for (final token in matchedTokens) {
      for (final entry in token.entries) {
        final doc = docs[entry.key];
        if (doc != null) {
          docs[entry.key] = 2 * doc;
        } else {
          docs[entry.key] = entry.value;
        }
      }
    }

    final matchCount = matchedTokens.length;
    final finalDocs = HashSet<List<int>>();
    for (final doc in docs.entries) {
      if (doc.value >= matchCount) finalDocs.add([doc.key, doc.value]);
    }

    final results = List<List<int>>.from(finalDocs);
    results.sort((a, b) => b[1].compareTo(a[1]));

    return results;
  }

  int get size => _index.length;

  void clear() => _index.clear();
}

List<String> ngram(String token, int n) {
  final len = token.length;

  if (len < n) return null;
  if (len == n) return <String>[token];

  final grams = <String>[];
  for (var i = 0; i < len; i++) {
    final start = i;
    final end = i + n;

    grams.add(token.substring(start, end));

    if (end == len) break;
  }

  return grams;
}
