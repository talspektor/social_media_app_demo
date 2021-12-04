import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_credentials.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;

  SessionCubit({required this.authRepository}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  attemptAutoLogin() async {
    await authRepository.attemptAutoLogin().then((userId) {
      final user = userId;
      emit(Authenticated(user: user));
    }).catchError((onError) {
      emit(Unauthenticated());
    });
  }

  showAuth() => emit(Unauthenticated());

  showSession(AuthCredentials credentials) {
    // final user = data.repo.getUser(credential.userId)
    final user = credentials.username;
    emit(Authenticated(user: user));
  }

  signOut() {
    authRepository.signOut();
    emit(Unauthenticated());
  }
}
