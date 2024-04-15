import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/repositories/firebase_repo.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<LoginEvent>(_loginEvent);
    on<SignUpEvent>(_signUpEvent);
    on<ResetPasswordEvent>(_resetPasswordEvent);
    on<LogoutEvent>(_logout);
  }

  Future<void> _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.login(email: event.email, password: event.password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(errorText: e.toString()));
    }
  }

  Future<void> _signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.signUp(email: event.email, password: event.password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(errorText: e.toString()));
    }
  }

  Future<void> _resetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.resetPassword(email: event.email);
      emit(AuthResetPassword());
    } catch (e) {
      emit(AuthError(errorText: e.toString()));
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await repository.logout();
      emit(AuthLogout());
    } catch (e) {
      emit(AuthError(errorText: e.toString()));
    }
  }

  final FirebaseRepository repository;
}
