import '../models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final UserModel user;

  UserSuccess(this.user);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}