part of 'password_reset_bloc.dart';

class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object> get props => [];
}

class PasswordResetRequested extends PasswordResetEvent {
  final PasswordResetParam param;

  const PasswordResetRequested(this.param);

  @override
  List<Object> get props => [param];
}
