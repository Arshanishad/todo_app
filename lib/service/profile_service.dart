import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/repository_model.dart';
import '../models/user_model.dart';

class ProfileService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.github.com',
      headers: {
        'Accept': 'application/vnd.github+json',
      },
    ),
  );

  Future<UserModel> fetchUser(
    String username,
  ) async {
    try {
      final response = await dio.get(
        '/users/$username',
      );

      return UserModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('User not found');
      }

      throw Exception(
        'Network error. Please check your internet connection.',
      );
    }
  }

  Future<List<RepositoryModel>> fetchRepositories(
    String username,
  ) async {
    try {
      final response = await dio.get(
        '/users/$username/repos',
      );

      final List data = response.data;

      return data
          .map(
            (item) => RepositoryModel.fromJson(item),
          )
          .toList();
    } on DioException {
      throw Exception(
        'Unable to load repositories.',
      );
    }
  }

  Future<void> saveRecentSearch(
    String username,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final searches =
        prefs.getStringList('recent_searches') ?? [];

    searches.remove(username);
    searches.insert(0, username);

    if (searches.length > 5) {
      searches.removeRange(
        5,
        searches.length,
      );
    }

    await prefs.setStringList(
      'recent_searches',
      searches,
    );
  }

  Future<List<String>> getRecentSearches() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getStringList(
          'recent_searches',
        ) ??
        [];
  }
}