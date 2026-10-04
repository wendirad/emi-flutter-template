part of 'confirm_password_reset_bloc.dart';

enum ConfirmPasswordResetProcess { idle, inProgress, successful, failed }

class ConfirmPasswordResetState extends Equatable {
  final ConfirmPasswordResetProcess process;
  final bool showPassword;
  final bool showConfirmPassword;
  final PasswordResetConfirmFailure? error;

  const ConfirmPasswordResetState({
    required this.process,
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.error,
  });

  static ConfirmPasswordResetState initial() =>
      ConfirmPasswordResetState(process: ConfirmPasswordResetProcess.idle);

  ConfirmPasswordResetState copyWith({
    ConfirmPasswordResetProcess? process,
    bool? showPassword,
    bool? showConfirmPassword,
    PasswordResetConfirmFailure? error,
  }) => ConfirmPasswordResetState(
    process: process ?? this.process,
    showPassword: showPassword ?? this.showPassword,
    showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    error: error ?? this.error,
  );

  @override
  List<Object> get props => [
    process,
    showPassword,
    showConfirmPassword,
    ?error,
  ];
}
