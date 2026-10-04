part of 'password_reset_bloc.dart';

// Sentinel so copyWith can tell "keep the error" from an explicit null.
const Object _unset = Object();

enum PasswordResetProcess { idle, inProgress, successful, failed }

class PasswordResetState extends Equatable {
  final PasswordResetProcess process;
  final PasswordResetFailure? error;

  const PasswordResetState({required this.process, this.error});

  static PasswordResetState initial() =>
      PasswordResetState(process: PasswordResetProcess.idle);

  PasswordResetState copyWith({
    PasswordResetProcess? process,
    Object? error = _unset,
  }) => PasswordResetState(
    process: process ?? this.process,
    error: identical(error, _unset)
        ? this.error
        : error as PasswordResetFailure?,
  );

  @override
  List<Object> get props => [process, ?error];
}
