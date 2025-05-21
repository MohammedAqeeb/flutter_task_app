import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/sp_services.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/repository/auth_local_repository.dart';
import 'package:frontend/repository/auth_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthStateInitital());

  final authRepo = AuthRepository();
  final localRepo = AuthLocalRepository();
  final prefers = SpServices();

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthStateLoding());
      await authRepo.signUp(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthSignUpSuccess());
    } catch (e) {
      emit(AuthStateFailure(message: e.toString()));
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthStateLoding());
      final userModel = await authRepo.login(
        email: email,
        password: password,
      );

      if (userModel.token.isNotEmpty) {
        await prefers.setToken(userModel.token);
      }

      await localRepo.insertUser(userModel);

      emit(AuthStateSuccess(userModel: userModel));
    } catch (e) {
      emit(AuthStateFailure(message: e.toString()));
    }
  }

  void getData() async {
    try {
      emit(AuthStateLoding());

      final userData = await authRepo.getUserData();

      if (userData != null) {
        emit(AuthStateSuccess(userModel: userData));
      } else {
        emit(AuthStateInitital());
      }
    } catch (e) {
      emit(AuthStateInitital());
    }
  }
}
