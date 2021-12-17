import 'package:amplify_flutter/amplify.dart';

import 'models/User.dart';

class DataRepository {
  Future<User?> getUserById(String userId) async {
    final users = await Amplify.DataStore.query(
      User.classType,
      where: User.ID.eq(userId),
    ).catchError((onError) => throw onError);
    return users.isNotEmpty ? users.first : null;
  }

  Future<User> createUser({
    required String userId,
    required String username,
    String? email,
}

  ) async {
    final User newUser = User(id: userId, username: username, email: email);
    await Amplify.DataStore.save(newUser).catchError((onError) => throw onError);
    return newUser;
  }
}
