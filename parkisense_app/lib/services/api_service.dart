import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/prediction_result.dart';

class ApiService {
  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse(Constants.healthEndpoint))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<PredictionResult> predict(Map<String, double> features) async {
    final response = await http
        .post(
          Uri.parse(Constants.predictEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'features': features}),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return PredictionResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Prediction failed: ${response.statusCode}');
    }
  }
}