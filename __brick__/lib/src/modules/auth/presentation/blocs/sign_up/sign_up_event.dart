part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends SignUpEvent {
  final SignUpParam param;

  const SignUpRequested(this.param);

  @override
  List<Object> get props => [param];
}
