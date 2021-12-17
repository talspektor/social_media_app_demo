import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_credentials.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/data_repository.dart';
import 'package:social_media_app_demo/session_state.dart';

import 'models/User.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;
  final DataRepository dataRepository;

  SessionCubit({
    required this.authRepository,
    required this.dataRepository,
  }) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  attemptAutoLogin() async {
    final userId = await authRepository.attemptAutoLogin();
    if (userId == null) {
      emit(Unauthenticated());
      return;
    }
    User? user = await dataRepository.getUserById(userId).catchError((onError) {
      emit(Unauthenticated());
    });
    user ??= await dataRepository
        .createUser(userId: userId, username: 'User-${UUID()}')
        .catchError((onError) {
      emit(Unauthenticated());
    });
    emit(Authenticated(user: user));
  }

  showAuth() => emit(Unauthenticated());

  showSession(AuthCredentials credentials) async {
    User? user = await dataRepository
        .getUserById(credentials.username)
        .catchError((onError) {
      emit(Unauthenticated());
    });

    if (credentials.userId != null || user == null) {
      user = await dataRepository.createUser(
        userId: credentials.userId!,
        username: credentials.username,
        email: credentials.email,
      );
    }
    emit(Authenticated(user: user));
  }

  signOut() {
    authRepository.signOut();
    emit(Unauthenticated());
  }
}
