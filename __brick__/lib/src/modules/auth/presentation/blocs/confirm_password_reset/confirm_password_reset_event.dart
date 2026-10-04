part of 'confirm_password_reset_bloc.dart';

sealed class ConfirmPasswordResetEvent extends Equatable {
  const ConfirmPasswordResetEvent();

  @override
  List<Object> get props => [];
}

class ConfirmPasswordResetToggleShowPassword extends ConfirmPasswordResetEvent {
  const ConfirmPasswordResetToggleShowPassword();
}

class ConfirmPasswordResetToggleShowConfirmPassword
    extends ConfirmPasswordResetEvent {
  const ConfirmPasswordResetToggleShowConfirmPassword();
}

class ConfirmPasswordResetRequested extends ConfirmPasswordResetEvent {
  final ConfirmPasswordResetParam param;

  const ConfirmPasswordResetRequested(this.param);

  @override
  List<Object> get props => [param];
}
