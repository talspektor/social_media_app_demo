import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

class AuthRepository {
  Future<String> _getUserIdFromAttributes() async {
    final attributes =
        await Amplify.Auth.fetchUserAttributes().catchError((e) => throw e);
    final userId = attributes
        .firstWhere((element) => element.userAttributeKey == 'sub')
        .value;
    return userId;
  }

  Future<String?> attemptAutoLogin() async {
    final session = await Amplify.Auth.fetchAuthSession().catchError((e) {
      throw e;
    });
    return session.isSignedIn ? await _getUserIdFromAttributes() : null;
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    final result = await Amplify.Auth.signIn(
      username: username.trim(),
      password: password.trim(),
    ).catchError((onError) => throw onError);
    return result.isSignedIn ? _getUserIdFromAttributes() : null;
  }

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final options =
        CognitoSignUpOptions(userAttributes: {'email': email.trim()});
    final result = await Amplify.Auth.signUp(
      username: username.trim(),
      password: password.trim(),
      options: options,
    ).catchError((onError) => throw onError);
    return result.isSignUpComplete;
  }

  Future<bool> confirmationSingUp({
    required String username,
    required String confirmationCode,
  }) async {
    final result = await Amplify.Auth.confirmSignUp(
      username: username.trim(),
      confirmationCode: confirmationCode.trim(),
    ).catchError((onError) => throw onError);
    return result.isSignUpComplete;
  }

  Future<void> signOut() async => await Amplify.Auth.signOut();
}
