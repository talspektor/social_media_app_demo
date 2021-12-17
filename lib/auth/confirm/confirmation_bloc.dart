import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_cubit.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/auth/confirm/confirmation_state.dart';
import 'package:social_media_app_demo/auth/form_submission_status.dart';

class ConfirmationCubit extends Cubit<ConfirmationState> {
  final AuthRepository repository;
  final AuthCubit authCubit;

  ConfirmationCubit({required this.repository, required this.authCubit})
      : super(Initial());

  onCodeChange({required String code}) {
    emit(ConfirmationEditingState(code: code));
  }

  onLoginUserNameChange({required String username}) {
    emit(ConfirmationEditingState(code: state.code));
  }

  onSubmitted() async {
    emit(ConfirmationEditingState(
        code: state.code, formStatus: FormSubmitting()));
    await repository
        .confirmationSingUp(
            username: authCubit.credentials.username,
            confirmationCode: state.code)
        .catchError(_onError);
    emit(ConfirmationEditingState(
        code: state.code, formStatus: SubmissionSuccess()));

    final credentials = authCubit.credentials;
    final userId = await repository
        .login(
          username: credentials.username,
          password: credentials.password!,
        )
        .catchError(_onError);
    credentials.userId = userId;
    authCubit.launchSession(credentials);
  }

  _onError(Object e) {
    e is Exception
        ? emit(ConfirmationEditingState(
            code: state.code, formStatus: SubmissionFailed(exception: e)))
        : null;
  }
}
