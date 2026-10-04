part of 'password_reset_bloc.dart';

enum PasswordResetProcess { idle, inProgress, successful, failed }

class PasswordResetState extends Equatable {
  final PasswordResetProcess process;
  final PasswordResetFailure? error;

  const PasswordResetState({required this.process, this.error});

  static PasswordResetState initial() =>
      PasswordResetState(process: PasswordResetProcess.idle);

  PasswordResetState copyWith({
    PasswordResetProcess? process,
    PasswordResetFailure? error,
  }) => PasswordResetState(
    process: process ?? this.process,
    error: error ?? this.error,
  );

  @override
  List<Object> get props => [process, ?error];
}
