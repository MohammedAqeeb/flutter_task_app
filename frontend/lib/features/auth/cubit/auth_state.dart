part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthStateInitital extends AuthState {}

final class AuthStateLoding extends AuthState {}

final class AuthSignUpSuccess extends AuthState {}

final class AuthStateSuccess extends AuthState {
  final UserModel userModel;
  AuthStateSuccess({
    required this.userModel,
  });
}

final class AuthStateFailure extends AuthState {
  final String message;
  AuthStateFailure({
    required this.message,
  });
}
