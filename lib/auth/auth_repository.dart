import 'package:amplify_flutter/amplify.dart';

class AuthRepository {
  Future<String> getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
      .firstWhere((element) => element.userAttributeKey)
    }
  }

  Future<String> attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      return session.isSignedIn ? '' : null;
    } catch (e) {
      throw e;
    }
  }

  Future<String> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 3));
    return 'abc';
    // throw Exception('fail log in');
  }

  Future<void> signUp(
      {required String username,
      required String email,
      required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<String> confirmationSingUp({
    required String username,
    required String confirmationCode,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'abc';
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
