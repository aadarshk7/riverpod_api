import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// HTTP client provider
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});
