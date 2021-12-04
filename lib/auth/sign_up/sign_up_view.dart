import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_cubit.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/auth/form_submission_status.dart';
import 'package:social_media_app_demo/auth/sign_up/sign_up_state.dart';

import 'sign_up_bloc.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            SignUpCubit(repository: context.read<AuthRepository>(), authCubit: context.read<AuthCubit>()),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _signUpForm(),
            _showLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return BlocListener<SignUpCubit, SignUpState>(
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
              _emailField(),
              _passwordField(),
              _signUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpCubit, SignUpState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
            icon: Icon(Icons.security), hintText: 'Password'),
        validator: (value) =>
            state.isValidPassword ? null : 'Password is too short',
        onChanged: (value) =>
            context.read<SignUpCubit>().onLoginPasswordChange(password: value),
      );
    });
  }

  Widget _emailField() {
    return BlocBuilder<SignUpCubit, SignUpState>(builder: (context, state) {
      return TextFormField(
        obscureText: false,
        decoration:
            const InputDecoration(icon: Icon(Icons.email), hintText: 'Email'),
        validator: (value) => state.isValidPassword ? null : 'Invalid email',
        onChanged: (value) =>
            context.read<SignUpCubit>().onLoginEmailChange(email: value),
      );
    });
  }

  Widget _userNameField() {
    return BlocBuilder<SignUpCubit, SignUpState>(builder: (context, state) {
      return TextFormField(
        obscureText: false,
        decoration: const InputDecoration(
            icon: Icon(Icons.person), hintText: 'UserName'),
        validator: (value) =>
            state.isValilUserName ? null : 'User is too short',
        onChanged: (value) =>
            context.read<SignUpCubit>().onLoginUserNameChange(username: value),
      );
    });
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpCubit, SignUpState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<SignUpCubit>().onLoginSubmitted();
                }
              },
              child: const Text('Sign Up'),
            );
    });
  }

  Widget _showLoginButton(BuildContext context) {
    return SafeArea(
        child: TextButton(
      child: const Text('Already have an account? Sing in.'),
      onPressed: () => context.read<AuthCubit>().showLogin(),
    ));
  }

  _showSnacBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
