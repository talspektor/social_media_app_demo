
import 'package:social_media_app_demo/auth/form_submission_status.dart';

abstract class SignUpState {
  final String username;
  final String password;
  final String email;

  bool get isValilUserName => username.length > 3;

  bool get isValidPassword => password.length > 6;

  bool get isValidEmail => email.contains('@');

  final FormSubmissionStatus formStatus;

  SignUpState({
    required this.username,
    required this.password,
    required this.email,
    required this.formStatus,
  });
}

class Initial extends SignUpState {
  Initial()
      : super(
            username: '', password: '', email: '', formStatus: const InitialFormStatus());
}

class SignUpEditingState extends SignUpState {
  @override
  final String username;
  @override
  final String password;
  @override
  @override
  final String email;
  final FormSubmissionStatus formStatus;

  SignUpEditingState({
    required this.username,
    required this.password,
    required this.email,
    this.formStatus = const InitialFormStatus(),
  }) : super(username: username, password: password, email: email, formStatus: formStatus);
}
