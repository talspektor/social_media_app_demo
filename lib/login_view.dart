import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loginForm(),
    );
  }

  Widget _loginForm() {
    return Form(
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
    );
  }

  Widget _passwordField() {
    return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
            icon: Icon(Icons.security), hintText: 'Password'),
        validator: (value) => null);
  }

  Widget _userNameField() {
    return TextFormField(
      obscureText: false,
      decoration: const InputDecoration(
          icon: Icon(Icons.security), hintText: 'UserName'),
      validator: (value) => null,
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Login'),
    );
  }
}
