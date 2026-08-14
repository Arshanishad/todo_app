import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/repository_model.dart';
import '../repository/user_repository.dart';
import 'repository_state.dart';

class RepositoryCubit extends Cubit<RepositoryState> {
  final UserRepository repository;

  RepositoryCubit(this.repository) : super(RepositoryInitial());

  Future<void> loadRepositories(String username) async {
    emit(RepositoryLoading());

    try {
      final repositories =
          await repository.getRepositories(username);

      emit(RepositorySuccess(repositories));
    } catch (e) {
      emit(
        RepositoryError(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void sortByStars() {
    if (state is! RepositorySuccess) return;

    final current = state as RepositorySuccess;

    final repositories =
        List<RepositoryModel>.from(current.repositories);

    repositories.sort(
      (a, b) => b.stars.compareTo(a.stars),
    );

    emit(RepositorySuccess(repositories));
  }

  void sortByRecentlyUpdated() {
    if (state is! RepositorySuccess) return;

    final current = state as RepositorySuccess;

    final repositories =
        List<RepositoryModel>.from(current.repositories);

    repositories.sort((a, b) {
      final aDate = a.updatedAt;
      final bDate = b.updatedAt;

      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      return bDate.compareTo(aDate);
    });

    emit(RepositorySuccess(repositories));
  }
}