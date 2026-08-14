import '../models/repository_model.dart';

abstract class RepositoryState {}

class RepositoryInitial extends RepositoryState {}

class RepositoryLoading extends RepositoryState {}

class RepositorySuccess extends RepositoryState {
  final List<RepositoryModel> repositories;

  RepositorySuccess(this.repositories);
}

class RepositoryError extends RepositoryState {
  final String message;

  RepositoryError(this.message);
}