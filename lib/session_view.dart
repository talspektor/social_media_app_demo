import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/session_cubit.dart';

class SessionView extends StatelessWidget {
  final String username;

  const SessionView({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello $username'),
            TextButton(
              child: const Text('sign out'),
              onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
            )
          ],
        ),
      ),
    );
  }
}
