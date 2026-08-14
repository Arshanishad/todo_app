import 'package:dio/dio.dart';

import '../models/repository_model.dart';
import '../models/user_model.dart';

class UserRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.github.com',
      headers: {
        'Accept': 'application/vnd.github+json',
      },
    ),
  );

  Future<UserModel> getUser(String username) async {
    try {
      final response = await _dio.get('/users/$username');

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('User not found');
      }

      throw Exception('Network error. Please try again.');
    }
  }

  Future<List<RepositoryModel>> getRepositories(
    String username,
  ) async {
    try {
      final response = await _dio.get(
        '/users/$username/repos',
        queryParameters: {
          'per_page': 100,
        },
      );

      final List data = response.data;

      return data
          .map(
            (item) => RepositoryModel.fromJson(item),
          )
          .toList();
    } on DioException {
      throw Exception('Network error. Please try again.');
    }
  }
}