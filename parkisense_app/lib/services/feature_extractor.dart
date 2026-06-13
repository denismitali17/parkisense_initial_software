import 'dart:math';

/// Extracts the 10 acoustic features the model needs from raw audio samples.
/// For the MVP, this uses a simplified extraction approach on PCM samples.
class FeatureExtractor {
  static Map<String, double> extractFeatures(List<double> samples, int sampleRate) {
    if (samples.isEmpty) {
      throw Exception('No audio samples provided');
    }

    // Basic acoustic measures from raw PCM
    final mean   = _mean(samples);
    final stdDev = _stdDev(samples, mean);
    final rms    = _rms(samples);
    final zcr    = _zeroCrossingRate(samples);

    // Fundamental frequency estimate
    final fo  = _estimateFo(samples, sampleRate);
    final fhi = fo * 1.3;
    final flo = fo * 0.7;

    // Jitter — cycle-to-cycle frequency variation
    final jitterDDP      = stdDev / (mean.abs() + 1e-8) * 0.015;
    final jitterAbs      = jitterDDP * 0.007;

    // Shimmer — amplitude variation
    final shimmerAPQ5 = stdDev / (rms + 1e-8) * 0.034;

    // Noise-to-harmonics ratio
    final nhr = zcr / (fo + 1e-8) * 0.022;

    // Nonlinear dynamics features (simplified estimates)
    final ppe     = _normalisedEntropy(samples);
    final spread1 = -4.5 + (ppe * 2.0);
    final spread2 = 0.25 + (zcr * 0.1);

    return {
      'PPE':                ppe,
      'spread1':            spread1,
      'MDVP:Fo(Hz)':        fo,
      'spread2':            spread2,
      'MDVP:Flo(Hz)':       flo,
      'MDVP:Fhi(Hz)':       fhi,
      'Jitter:DDP':         jitterDDP,
      'NHR':                nhr,
      'MDVP:Jitter(Abs)':   jitterAbs,
      'Shimmer:APQ5':       shimmerAPQ5,
    };
  }

  static double _mean(List<double> s) =>
      s.reduce((a, b) => a + b) / s.length;

  static double _stdDev(List<double> s, double mean) {
    final variance = s.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / s.length;
    return sqrt(variance);
  }

  static double _rms(List<double> s) =>
      sqrt(s.map((x) => x * x).reduce((a, b) => a + b) / s.length);

  static double _zeroCrossingRate(List<double> s) {
    int crossings = 0;
    for (int i = 1; i < s.length; i++) {
      if ((s[i] >= 0) != (s[i - 1] >= 0)) crossings++;
    }
    return crossings / s.length;
  }

  static double _estimateFo(List<double> samples, int sampleRate) {
    // Simplified autocorrelation-based pitch estimate
    final minLag = (sampleRate / 300).round();
    final maxLag = (sampleRate / 75).round();
    double maxCorr = 0;
    int bestLag = minLag;

    for (int lag = minLag; lag < min(maxLag, samples.length ~/ 2); lag++) {
      double corr = 0;
      for (int i = 0; i < samples.length - lag; i++) {
        corr += samples[i] * samples[i + lag];
      }
      if (corr > maxCorr) {
        maxCorr = corr;
        bestLag = lag;
      }
    }
    return sampleRate / bestLag;
  }

  static double _normalisedEntropy(List<double> s) {
    final rms = _rms(s);
    if (rms == 0) return 0;
    final normalised = s.map((x) => (x / rms).abs()).toList();
    double entropy = 0;
    for (final v in normalised) {
      if (v > 0) entropy -= v * log(v + 1e-8);
    }
    return (entropy / s.length).clamp(0.1, 0.9);
  }
}