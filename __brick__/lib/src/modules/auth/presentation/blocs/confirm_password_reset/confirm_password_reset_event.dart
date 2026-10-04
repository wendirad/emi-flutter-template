part of 'confirm_password_reset_bloc.dart';

sealed class ConfirmPasswordResetEvent extends Equatable {
  const ConfirmPasswordResetEvent();

  @override
  List<Object?> get props => [];
}

class ConfirmPasswordResetRequested extends ConfirmPasswordResetEvent {
  final String code;
  final String newPassword;

  const ConfirmPasswordResetRequested({
    required this.code,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [code, newPassword];
}
