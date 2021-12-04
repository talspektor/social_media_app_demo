import 'package:social_media_app_demo/auth/form_submission_status.dart';

abstract class ConfirmationState {
  final String code;

  bool get isValidCode => code.length == 6;

  final FormSubmissionStatus formStatus;

  ConfirmationState({
    required this.code,
    required this.formStatus,
  });
}

class Initial extends ConfirmationState {
  Initial() : super(code: '', formStatus: const InitialFormStatus());
}

class ConfirmationEditingState extends ConfirmationState {
  @override
  final String code;
  @override
  final FormSubmissionStatus formStatus;

  ConfirmationEditingState({
    required this.code,
    this.formStatus = const InitialFormStatus(),
  }) : super(code: code, formStatus: formStatus);
}
