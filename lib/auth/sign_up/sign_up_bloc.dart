import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_cubit.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/auth/form_submission_status.dart';
import 'package:social_media_app_demo/auth/sign_up/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository repository;
  final AuthCubit authCubit;

  SignUpCubit({required this.repository, required this.authCubit})
      : super(Initial());

  onLoginUserNameChange({required String username}) {
    emit(SignUpEditingState(
        username: username, password: state.password, email: state.password));
  }

  onLoginPasswordChange({required String password}) {
    emit(SignUpEditingState(
        username: state.username, password: password, email: state.email));
  }

  onLoginEmailChange({required String email}) {
    emit(SignUpEditingState(
        username: state.username, password: state.password, email: email));
  }

  onLoginSubmitted() async {
    emit(SignUpEditingState(
        username: state.username,
        password: state.password,
        email: state.email,
        formStatus: FormSubmitting()));
    await repository
        .signUp(
            username: state.username,
            password: state.password,
            email: state.email)
        .then((_) {
      emit(SignUpEditingState(
          username: state.username,
          password: state.password,
          email: state.email,
          formStatus: SubmissionSuccess()));

      authCubit.showConfirmSignUp(
          username: state.username,
          email: state.email,
          password: state.password);
    }).catchError(_onError);
  }

  _onError(Object e) {
    e is Exception
        ? emit(SignUpEditingState(
            username: state.username,
            password: state.password,
            email: state.email,
            formStatus: SubmissionFailed(exception: e)))
        : null;
  }
}
