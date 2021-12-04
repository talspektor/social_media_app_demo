import 'package:social_media_app_demo/auth/form_submission_status.dart';

abstract class LoginState {
  final String username;
  final String password;

  bool get isValilUserName => username.length > 3;

  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  LoginState({
    required this.username,
    required this.password,
    required this.formStatus,
  });
}

class Initisl extends LoginState {
  Initisl()
      : super(
            username: '', password: '', formStatus: const InitialFormStatus());
}

class LoginEditingState extends LoginState {
  @override
  final String username;
  @override
  final String password;
  @override
  final FormSubmissionStatus formStatus;

  LoginEditingState({
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  }) : super(username: username, password: password, formStatus: formStatus);
}
