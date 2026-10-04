part of 'confirm_password_reset_bloc.dart';

// Sentinel so copyWith can tell "keep the error" from an explicit null.
const Object _unset = Object();

enum ConfirmPasswordResetProcess { idle, inProgress, successful, failed }

class ConfirmPasswordResetState extends Equatable {
  final ConfirmPasswordResetProcess process;
  final PasswordResetConfirmFailure? error;

  const ConfirmPasswordResetState({
    required this.process,
    this.error,
  });

  static ConfirmPasswordResetState initial() =>
      ConfirmPasswordResetState(process: ConfirmPasswordResetProcess.idle);

  ConfirmPasswordResetState copyWith({
    ConfirmPasswordResetProcess? process,
    Object? error = _unset,
  }) => ConfirmPasswordResetState(
    process: process ?? this.process,
    error: identical(error, _unset)
        ? this.error
        : error as PasswordResetConfirmFailure?,
  );

  @override
  List<Object> get props => [
    process,
    ?error,
  ];
}
