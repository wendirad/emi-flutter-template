part of 'confirm_password_reset_bloc.dart';

sealed class ConfirmPasswordResetEvent extends Equatable {
  const ConfirmPasswordResetEvent();

  @override
  List<Object> get props => [];
}



class ConfirmPasswordResetRequested extends ConfirmPasswordResetEvent {
  final ConfirmPasswordResetParam param;

  const ConfirmPasswordResetRequested(this.param);

  @override
  List<Object> get props => [param];
}
