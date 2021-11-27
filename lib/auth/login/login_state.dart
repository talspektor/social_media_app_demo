class LoginState {
  final String username;
  final String password;

  LoginState({
    required this.username,
    required this.password,
  });

  LoginState copyWith({
    String? username,
    String? password,
  }) {
    return LoginState(
        username: username ?? this.username,
        password: password ?? this.password);
  }
}
