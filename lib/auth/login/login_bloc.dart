import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_credentials.dart';
import 'package:social_media_app_demo/auth/auth_cubit.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/auth/form_submission_status.dart';
import 'package:social_media_app_demo/auth/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;
  final AuthCubit authCubit;

  LoginCubit({required this.repository, required this.authCubit})
      : super(Initial());

  onLoginUserNameChange({required String username}) {
    emit(LoginEditingState(username: username, password: state.password));
  }

  onLoginPasswordChange({required String password}) {
    emit(LoginEditingState(username: state.username, password: password));
  }

  onLoginSubmitted() async {
    emit(LoginEditingState(
        username: state.username,
        password: state.password,
        formStatus: FormSubmitting()));
    await repository
        .login(username: state.username, password: state.password)
        .then((userId) {
      emit(LoginEditingState(formStatus: SubmissionSuccess()));
      authCubit.launchSession(
          AuthCredentials(username: state.username, userId: userId));
    }).catchError(_onError);
  }

  _onError(Object e) {
    e is Exception
        ? emit(LoginEditingState(
            username: state.username,
            password: state.password,
            formStatus: SubmissionFailed(exception: e)))
        : null;
  }
}
