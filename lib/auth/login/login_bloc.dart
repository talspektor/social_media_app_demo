import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/auth/form_submission_status.dart';
import 'package:social_media_app_demo/auth/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;
  String _username = "";
  String _password = "";

  LoginCubit({required this.repository}) : super(Initisl());

  onLoginUserNameChange({required String username}) {
    _username = username;
    emit(LoginEditingState(username: _username, password: _password));
  }

  onLoginPasswordChange({required String password}) {
    _password = password;
    emit(LoginEditingState(username: _username, password: _password));
  }

  onLoginSubmitted() async {
    emit(LoginEditingState(
        username: _username,
        password: _password,
        formStatus: FormSubmitting()));
    await repository.login().then((_) {
      emit(LoginEditingState(formStatus: SubmissionSuccess()));
    }).catchError(_onError);
  }

  _onError(Object e) {
    e is Exception
        ? emit(LoginEditingState(
            username: _username,
            password: _password,
            formStatus: SubmissionFailed(exception: e)))
        : null;
  }
}
