import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/service/profile_service.dart';
import '../models/user_model.dart';

final profileServiceProvider =
    Provider<ProfileService>((ref) {
  return ProfileService();
});

final recentSearchesProvider =
    FutureProvider<List<String>>((ref) async {
  final service =
      ref.read(profileServiceProvider);

  return service.getRecentSearches();
});

final userProvider = AsyncNotifierProvider<
    UserNotifier, UserModel?>(
  UserNotifier.new,
);

class UserNotifier
    extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    return null;
  }

  Future<void> searchUser(
    String username,
  ) async {
    if (username.trim().isEmpty) {
      state = AsyncError(
        'Please enter a username.',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    try {
      final service =
          ref.read(profileServiceProvider);

      final user = await service.fetchUser(
        username.trim(),
      );

      await service.saveRecentSearch(
        username.trim(),
      );

      ref.invalidate(recentSearchesProvider);

      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(
        e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
        stackTrace,
      );
    }
  }
}