part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends SignInEvent {
  final SignInParam param;

  const SignInRequested(this.param);

  @override
  List<Object> get props => [param];
}
