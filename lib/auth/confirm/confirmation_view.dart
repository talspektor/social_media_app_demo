import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_cubit.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/auth/form_submission_status.dart';
import 'package:social_media_app_demo/auth/login/login_bloc.dart';
import 'package:social_media_app_demo/auth/login/login_state.dart';
import 'package:social_media_app_demo/main.dart';

import 'confirmation_bloc.dart';
import 'confirmation_state.dart';

class ConfirmationView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ConfirmationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ConfirmationCubit(
            repository: dependenciesAcempbler.get<AuthRepository>(),
            authCubit: dependenciesAcempbler.get<AuthCubit>()),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _confimationForm(),
            _showSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _confimationForm() {
    return BlocListener<ConfirmationCubit, ConfirmationState>(
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
              // _userNameField(),
              _codeField(),
              _confirmationButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _codeField() {
    return BlocBuilder<ConfirmationCubit, ConfirmationState>(
        builder: (context, state) {
      return TextFormField(
        obscureText: false,
        decoration: const InputDecoration(
            icon: Icon(Icons.person), hintText: 'Confirmation Code'),
        validator: (value) =>
            state.isValidCode ? null : 'Invalid confirmation code',
        onChanged: (value) =>
            context.read<ConfirmationCubit>().onCodeChange(code: value),
      );
    });
  }

  Widget _confirmationButton() {
    return BlocBuilder<ConfirmationCubit, ConfirmationState>(
        builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ConfirmationCubit>().onSubmitted();
                }
              },
              child: const Text('Confirm'),
            );
    });
  }

  Widget _showSignUpButton() {
    return SafeArea(
        child: TextButton(
      child: const Text('Don\'t have an account? Sing up.'),
      onPressed: () {},
    ));
  }

  _showSnacBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
