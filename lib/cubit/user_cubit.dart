import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit(this.repository) : super(UserInitial());

  Future<void> searchUser(String username) async {
    final trimmedUsername = username.trim();

    if (trimmedUsername.isEmpty) {
      emit(UserError('Please enter a username'));
      return;
    }

    emit(UserLoading());

    try {
      final user = await repository.getUser(trimmedUsername);

      await _saveRecentSearch(trimmedUsername);

      emit(UserSuccess(user));
    } catch (e) {
      emit(
        UserError(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<List<String>> getRecentSearches() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getStringList('recent_searches') ?? [];
  }

  Future<void> _saveRecentSearch(String username) async {
    final preferences = await SharedPreferences.getInstance();

    final searches =
        preferences.getStringList('recent_searches') ?? [];

    searches.remove(username);
    searches.insert(0, username);

    if (searches.length > 5) {
      searches.removeLast();
    }

    await preferences.setStringList(
      'recent_searches',
      searches,
    );
  }
}