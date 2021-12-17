import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_cubit.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/auth/form_submission_status.dart';
import 'package:social_media_app_demo/auth/login/login_bloc.dart';
import 'package:social_media_app_demo/main.dart';

import 'login_state.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(
            repository: dependenciesAcempbler.get<AuthRepository>(),
            authCubit: dependenciesAcempbler.get<AuthCubit>()),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _loginForm(),
            _showSignUpButton(context),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnacBar(context, formStatus.exception.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _userNameField(),
              _passwordField(),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
            icon: Icon(Icons.security), hintText: 'Password'),
        validator: (value) =>
            state.isValidPassword ? null : 'Password is too short',
        onChanged: (value) =>
            context.read<LoginCubit>().onLoginPasswordChange(password: value),
      );
    });
  }

  Widget _userNameField() {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: false,
        decoration: const InputDecoration(
            icon: Icon(Icons.person), hintText: 'UserName'),
        validator: (value) =>
            state.isValilUserName ? null : 'User is too short',
        onChanged: (value) =>
            context.read<LoginCubit>().onLoginUserNameChange(username: value),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginCubit>().onLoginSubmitted();
                }
              },
              child: const Text('Login'),
            );
    });
  }

  Widget _showSignUpButton(BuildContext context) {
    return SafeArea(
        child: TextButton(
      child: const Text('Don\'t have an account? Sing up.'),
      onPressed: () => context.read<AuthCubit>().showSignUp(),
    ));
  }

  _showSnacBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
