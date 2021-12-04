class AuthCredentials {
  final String username;
  final String? email;
  final String? password;
  String? userId;

  AuthCredentials(
      {this.email = '', this.password = '', this.userId = '', required this.username});
}
