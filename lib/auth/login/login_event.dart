abstract class LoginEvent {}

class LoginUserNameChange extends LoginEvent {
  final String username;

  LoginUserNameChange({required this.username});
}

class LoginPasswordChange extends LoginEvent {
  final String password;

  LoginPasswordChange({required this.password});
}

class LoginSubmitted extends LoginEvent {}
