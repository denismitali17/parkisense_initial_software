import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import 'record_screen.dart';

class ResultScreen extends StatelessWidget {
  final PredictionResult    result;
  final Map<String, double> features;

  const ResultScreen({
    super.key,
    required this.result,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final isPD       = result.prediction == 1;
    final mainColor  = isPD ? const Color(0xFFC00000) : const Color(0xFF375623);
    final bgColor    = isPD ? const Color(0xFFFFF0F0) : const Color(0xFFF0FFF0);
    final icon       = isPD ? Icons.warning_amber_rounded : Icons.check_circle_outline;
    final headline   = isPD ? 'Potential Risk Detected' : 'No Risk Detected';
    final subtext    = isPD
        ? 'Your voice sample shows patterns associated with Parkinson\'s disease. Please consult a medical professional.'
        : 'Your voice sample does not show significant signs of Parkinson\'s disease. Continue monitoring regularly.';

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(
        title: const Text('Screening Result',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F3864),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Result card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: mainColor.withOpacity(0.4), width: 1.5),
              ),
              child: Column(
                children: [
                  Icon(icon, color: mainColor, size: 64),
                  const SizedBox(height: 14),
                  Text(
                    headline,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtext,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF444444),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Confidence
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Model Confidence',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F3864),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: result.confidence / 100,
                      minHeight: 16,
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${result.confidence.toStringAsFixed(1)}% confident',
                    style: TextStyle(
                      fontSize: 14,
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Features used
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Features Analysed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F3864),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...features.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key,
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF555555))),
                          Text(e.value.toStringAsFixed(5),
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F3864))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFCA2C)),
              ),
              child: const Text(
                '⚠ This result is generated by a research prototype and is not a medical diagnosis. Always consult a qualified healthcare professional.',
                style: TextStyle(fontSize: 13, color: Color(0xFF664D03)),
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RecordScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E75B6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Record Again',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1F3864),
                  side: const BorderSide(color: Color(0xFF1F3864)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Back to Home',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}