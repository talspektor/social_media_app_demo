import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_demo/auth/auth_repository.dart';
import 'package:social_media_app_demo/auth/form_submission_status.dart';
import 'package:social_media_app_demo/auth/login/login_event.dart';
import 'package:social_media_app_demo/auth/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc({required this.repository}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUserNameChange) {
      yield state.copyWith(username: event.username);
    } else if (event is LoginPasswordChange) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      await repository.login().then((_) async* {
        yield state.copyWith(formStatus: SubmissionSuccess());
      }).catchError(_onError);
    }
  }

  _onError(Object e) async* {
    yield e is Exception
        ? state.copyWith(formStatus: SubmissionFailed(exception: e))
        : null;
  }
}
