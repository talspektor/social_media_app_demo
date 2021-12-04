class AuthRepository {
  Future<void> login() async {
    print('attempt login');
    await Future.delayed(const Duration(seconds: 3));
    print('logged in');
    throw Exception('fail log in');
  }
}
