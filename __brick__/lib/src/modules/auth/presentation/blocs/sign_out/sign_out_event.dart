part of 'sign_out_bloc.dart';

sealed class SignOutEvent extends Equatable {
  const SignOutEvent();

  @override
  List<Object> get props => [];
}

class SignOutRequested extends SignOutEvent {
  final NoParam param;

  const SignOutRequested(this.param);
}
