class PredictionResult {
  final int prediction;
  final String label;
  final double confidence;
  final List<String> featuresUsed;

  PredictionResult({
    required this.prediction,
    required this.label,
    required this.confidence,
    required this.featuresUsed,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      prediction:   json['prediction'] as int,
      label:        json['label'] as String,
      confidence:   (json['confidence'] as num).toDouble(),
      featuresUsed: List<String>.from(json['features_used']),
    );
  }
}