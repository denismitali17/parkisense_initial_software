class Constants {
  static const String baseUrl = 'https://parkisense-backend.onrender.com';
  static const String predictEndpoint = '$baseUrl/predict';
  static const String healthEndpoint = '$baseUrl/health';

  static const List<String> featureNames = [
    'PPE',
    'spread1',
    'MDVP:Fo(Hz)',
    'spread2',
    'MDVP:Flo(Hz)',
    'MDVP:Fhi(Hz)',
    'Jitter:DDP',
    'NHR',
    'MDVP:Jitter(Abs)',
    'Shimmer:APQ5',
  ];
}