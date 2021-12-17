import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media_app_demo/amplifyconfiguration.dart';
import 'package:social_media_app_demo/app_navigator.dart';
import 'package:social_media_app_demo/auth/auth_cubit.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/auth/confirm/confirmation_bloc.dart';
import 'package:social_media_app_demo/data_repository.dart';
import 'package:social_media_app_demo/loading_view.dart';
import 'package:social_media_app_demo/models/ModelProvider.dart';
import 'package:social_media_app_demo/session_cubit.dart';

void main() {
  registerDependencyies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isAmplifyConfigured
          ? BlocProvider(
              create: (contex) => SessionCubit(
                authRepository: dependenciesAcempbler.get<AuthRepository>(),
                dataRepository: dependenciesAcempbler.get<DataRepository>(),
              ),
              child: const AppNavigator(),
            )
          : const LoadingView(),
    );
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        AmplifyAPI(),
      ]);

      await Amplify.configure(amplifyconfig);

      setState(() => _isAmplifyConfigured = true);
    } catch (e) {
      print(e);
    }
  }
}

GetIt dependenciesAcempbler = GetIt.I;

registerDependencyies() {
  GetIt.I.registerSingleton<AuthRepository>(AuthRepository());

  GetIt.I.registerSingleton<DataRepository>(DataRepository());
  GetIt.I.registerSingleton(SessionCubit(
      authRepository: GetIt.I.get<AuthRepository>(),
      dataRepository: GetIt.I.get<DataRepository>()));
  GetIt.I.registerSingleton<AuthCubit>(
      AuthCubit(sessionCubit: GetIt.I.get<SessionCubit>()));
  GetIt.I.registerSingleton(ConfirmationCubit(
      repository: GetIt.I.get<AuthRepository>(),
      authCubit: GetIt.I.get<AuthCubit>()));
}
