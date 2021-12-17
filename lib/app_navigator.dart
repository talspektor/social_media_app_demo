import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_cubit.dart';
import 'package:social_media_app_demo/auth/auth_navigator.dart';
import 'package:social_media_app_demo/loading_view.dart';
import 'package:social_media_app_demo/session_cubit.dart';
import 'package:social_media_app_demo/session_state.dart';
import 'package:social_media_app_demo/session_view.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          // Show loading screen
          if (state is UnknownSessionState)
            const MaterialPage(child: LoadingView()),

          // show auth flow
          if (state is Unauthenticated)
            MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    AuthCubit(sessionCubit: context.read<SessionCubit>()),
                child: const AuthNavigator(),
              ),
            ),

          // Show session flow
          if (state is Authenticated)
            MaterialPage(
                child: SessionView(
              username: state.user.username,
            )),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
