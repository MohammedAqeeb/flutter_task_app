import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/repository/auth_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthStateInitital());

  final authRepo = AuthRepository();

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
}
