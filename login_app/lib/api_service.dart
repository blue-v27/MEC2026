import 'dart:math';
import 'package:dio/dio.dart';
import 'models/user.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<User>> fetchUsersWithRetry({
    int maxRetries = 5,
    Duration baseDelay = const Duration(milliseconds: 500),
  }) async {
    int attempt = 0;

    while (true) {
      try {
        print("Attempt #$attempt");

        final response = await _dio.get(
          'https://jsonplaceholder.typicode.com/invalid_endpoint',
        );

        final data = response.data as List;
        return data.map((json) => User.fromJson(json)).toList();

      } catch (e) {
        if (attempt >= maxRetries) {
          print("Max retries reached. Throwing error.");
          rethrow;
        }

        // Exponential backoff
        final delay = baseDelay * pow(2, attempt);

        // Add jitter (random 0–300ms)
        final jitter = Duration(milliseconds: Random().nextInt(300));

        final totalDelay = delay + jitter;

        print(
          "Retrying in ${totalDelay.inMilliseconds} ms (attempt $attempt)",
        );

        await Future.delayed(totalDelay);

        attempt++;
      }
    }
  }
}