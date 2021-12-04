import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_credentials.dart';
import 'package:social_media_app_demo/session_cubit.dart';

enum AuthState { login, sinUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;

  AuthCubit({required this.sessionCubit}) : super(AuthState.login);

  late AuthCredentials credentials;

  showLogin() => emit(AuthState.login);

  showSignUp() => emit(AuthState.sinUp);

  showConfirmSignUp({
    required String username,
    required String email,
    required String password,
  }) {
    credentials = AuthCredentials(email: email, password: password, username: username);
    emit(AuthState.confirmSignUp);
  }

  launchSession(AuthCredentials credentials) =>
      sessionCubit.showSession(credentials);
}
