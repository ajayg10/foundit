import 'dart:math';

/// Abstract interface for text embedding providers (pluggable for future AI upgrades).
abstract class EmbeddingProvider {
  Future<List<double>?> getEmbedding(String text);
}

/// Text similarity engine — works without any external API or keys.
///
/// Combines:
/// 1. Trigram similarity (character n-grams)
/// 2. Token Jaccard similarity (word overlap)
/// 3. Synonym expansion (color, size, type aliases)
/// 4. Keyword containment boost (partial title match)
class SimilarityService {
  final EmbeddingProvider? embeddingProvider;

  SimilarityService({this.embeddingProvider});

  // ── Synonym groups: any two words in the same group are treated as equivalent ──
  static const List<Set<String>> _synonymGroups = [
    {'bag', 'backpack', 'rucksack', 'sack', 'pack', 'haversack'},
    {'wallet', 'purse', 'billfold', 'cardholder', 'card holder'},
    {
      'phone',
      'mobile',
      'smartphone',
      'iphone',
      'android',
      'handset',
      'cellphone',
    },
    {'laptop', 'notebook', 'computer', 'macbook', 'chromebook'},
    {'airpods', 'earbuds', 'earphones', 'headphones', 'headset', 'buds'},
    {'keys', 'key', 'keychain', 'key ring', 'keyring'},
    {'id', 'card', 'aadhar', 'identity', 'license', 'licence', 'pass', 'badge'},
    {'black', 'dark', 'charcoal', 'ebony'},
    {'blue', 'navy', 'indigo', 'cobalt'},
    {'red', 'crimson', 'maroon', 'scarlet'},
    {'white', 'cream', 'ivory', 'off-white'},
    {'small', 'tiny', 'mini', 'compact'},
    {'large', 'big', 'xl', 'huge'},
  ];

  /// Calculates text similarity between two reports (0.0 to 1.0).
  double calculateTextSimilarity({
    required String title1,
    required String description1,
    required String title2,
    required String description2,
  }) {
    final cTitle1 = _clean(title1);
    final cTitle2 = _clean(title2);
    final cDesc1 = _clean(description1);
    final cDesc2 = _clean(description2);

    // Exact match shortcut
    if (cTitle1.isNotEmpty && cTitle1 == cTitle2 && cDesc1 == cDesc2) {
      return 1.0;
    }

    // Synonym-expanded tokens
    final tokens1 = _expandSynonyms(_tokenize(title1));
    final tokens2 = _expandSynonyms(_tokenize(title2));
    final fullTokens1 = _expandSynonyms(_tokenize('$title1 $description1'));
    final fullTokens2 = _expandSynonyms(_tokenize('$title2 $description2'));

    final titleSim = trigramSimilarity(title1, title2);
    final descSim = trigramSimilarity(description1, description2);
    final titleTokenSim = _jaccardOf(tokens1, tokens2);
    final descTokenSim = _jaccardOf(fullTokens1, fullTokens2);

    // Keyword containment boost (e.g. "Backpack" in "Black Wildcraft Backpack")
    final isContained =
        tokens1.isNotEmpty &&
        tokens2.isNotEmpty &&
        (tokens1.every(tokens2.contains) || tokens2.every(tokens1.contains));

    final effectiveTitleSim = isContained ? max(0.92, titleSim) : titleSim;
    final effectiveTitleTokenSim = isContained ? 1.0 : titleTokenSim;

    // Weighted combination (title-heavy)
    final combined =
        (effectiveTitleSim * 0.40) +
        (effectiveTitleTokenSim * 0.35) +
        (descTokenSim * 0.15) +
        (descSim * 0.10);

    return combined.clamp(0.0, 1.0);
  }

  /// Trigram similarity between two strings (character n-gram Jaccard).
  static double trigramSimilarity(String s1, String s2) {
    final clean1 = _clean(s1);
    final clean2 = _clean(s2);

    if (clean1.isEmpty && clean2.isEmpty) return 1.0;
    if (clean1.isEmpty || clean2.isEmpty) return 0.0;
    if (clean1 == clean2) return 1.0;

    final tri1 = _getTrigrams(clean1);
    final tri2 = _getTrigrams(clean2);

    if (tri1.isEmpty || tri2.isEmpty) {
      return _jaccardOf(_tokenize(clean1), _tokenize(clean2));
    }

    final intersection = tri1.intersection(tri2).length;
    final union = tri1.union(tri2).length;
    return union == 0 ? 0.0 : intersection / union;
  }

  /// Jaccard similarity between tokenized word sets.
  static double tokenJaccardSimilarity(String s1, String s2) {
    return _jaccardOf(_tokenize(s1), _tokenize(s2));
  }

  /// Shared significant keywords between two texts (for explanations).
  static List<String> extractSharedKeywords(String text1, String text2) {
    final tokens1 = _expandSynonyms(_tokenize(text1));
    final tokens2 = _expandSynonyms(_tokenize(text2));
    final shared = tokens1.intersection(tokens2);

    const stopWords = {
      'the',
      'and',
      'for',
      'with',
      'near',
      'lost',
      'found',
      'this',
      'that',
      'from',
      'some',
      'about',
      'here',
      'there',
      'have',
      'been',
      'into',
      'around',
      'just',
      'item',
      'something',
      'where',
      'when',
      'what',
      'which',
      'was',
      'were',
      'has',
      'had',
      'not',
      'but',
      'its',
      'my',
      'their',
    };

    return shared.where((t) => t.length > 2 && !stopWords.contains(t)).toList();
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  static String _clean(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), ' ').trim();
  }

  static Set<String> _tokenize(String input) {
    return _clean(
      input,
    ).split(RegExp(r'\s+')).where((w) => w.length > 1).toSet();
  }

  /// Expand tokens by adding synonym group representatives.
  /// E.g. 'backpack' → adds 'bag'; 'iphone' → adds 'phone'
  static Set<String> _expandSynonyms(Set<String> tokens) {
    final expanded = Set<String>.from(tokens);
    for (final token in tokens) {
      for (final group in _synonymGroups) {
        if (group.contains(token)) {
          expanded.addAll(group); // add all synonyms as equivalent tokens
          break;
        }
      }
    }
    return expanded;
  }

  static double _jaccardOf(Set<String> a, Set<String> b) {
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;
    final intersection = a.intersection(b).length;
    final union = a.union(b).length;
    return union == 0 ? 0.0 : intersection / union;
  }

  static Set<String> _getTrigrams(String input) {
    final padded = '  $input ';
    final trigrams = <String>{};
    for (var i = 0; i <= padded.length - 3; i++) {
      trigrams.add(padded.substring(i, i + 3));
    }
    return trigrams;
  }
}
