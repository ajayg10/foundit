import 'dart:math';

/// Abstract interface for text embedding providers (pluggable).
abstract class EmbeddingProvider {
  Future<List<double>?> getEmbedding(String text);
}

/// Fallback and default text similarity engine.
/// Computes n-gram trigram similarity, token Jaccard similarity,
/// and keyword overlap. Works without any external API or keys.
class SimilarityService {
  final EmbeddingProvider? embeddingProvider;

  SimilarityService({this.embeddingProvider});

  /// Calculates text similarity between two texts (0.0 to 1.0).
  /// Combines title weighting, description weighting, token overlap, and trigrams.
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

    if (cTitle1.isNotEmpty && cTitle1 == cTitle2 && cDesc1 == cDesc2) {
      return 1.0;
    }

    final titleSim = trigramSimilarity(title1, title2);
    final descSim = trigramSimilarity(description1, description2);
    final crossSim1 = trigramSimilarity(title1, description2);
    final crossSim2 = trigramSimilarity(title2, description1);

    final titleTokenSim = tokenJaccardSimilarity(title1, title2);
    final descTokenSim = tokenJaccardSimilarity(
      '$title1 $description1',
      '$title2 $description2',
    );

    // Combine with heavy weight on title and token overlap
    final combined = (titleSim * 0.40) +
        (descSim * 0.30) +
        (max(crossSim1, crossSim2) * 0.10) +
        (titleTokenSim * 0.10) +
        (descTokenSim * 0.10);

    return combined.clamp(0.0, 1.0);
  }

  /// Calculates trigram similarity between two strings.
  static double trigramSimilarity(String s1, String s2) {
    final clean1 = _clean(s1);
    final clean2 = _clean(s2);

    if (clean1.isEmpty && clean2.isEmpty) return 1.0;
    if (clean1.isEmpty || clean2.isEmpty) return 0.0;
    if (clean1 == clean2) return 1.0;

    final tri1 = _getTrigrams(clean1);
    final tri2 = _getTrigrams(clean2);

    if (tri1.isEmpty || tri2.isEmpty) {
      return tokenJaccardSimilarity(clean1, clean2);
    }

    final intersection = tri1.intersection(tri2).length;
    final union = tri1.union(tri2).length;

    if (union == 0) return 0.0;
    return intersection / union;
  }

  /// Calculates Jaccard similarity between tokenized words.
  static double tokenJaccardSimilarity(String s1, String s2) {
    final tokens1 = _tokenize(s1);
    final tokens2 = _tokenize(s2);

    if (tokens1.isEmpty && tokens2.isEmpty) return 1.0;
    if (tokens1.isEmpty || tokens2.isEmpty) return 0.0;

    final intersection = tokens1.intersection(tokens2).length;
    final union = tokens1.union(tokens2).length;

    if (union == 0) return 0.0;
    return intersection / union;
  }

  /// Extracts shared significant keywords between two texts.
  static List<String> extractSharedKeywords(String text1, String text2) {
    final tokens1 = _tokenize(text1);
    final tokens2 = _tokenize(text2);
    final shared = tokens1.intersection(tokens2);

    const stopWords = {
      'the', 'and', 'for', 'with', 'near', 'lost', 'found', 'this', 'that',
      'from', 'some', 'about', 'here', 'there', 'have', 'been', 'into',
      'around', 'just', 'item', 'something', 'where', 'when', 'what', 'which',
    };

    return shared.where((t) => t.length > 2 && !stopWords.contains(t)).toList();
  }

  static String _clean(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), ' ').trim();
  }

  static Set<String> _tokenize(String input) {
    return _clean(input)
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 1)
        .toSet();
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
