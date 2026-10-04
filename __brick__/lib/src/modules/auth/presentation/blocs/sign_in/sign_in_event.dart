part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends SignInEvent {
  final String email;
  final String password;
  final bool saveInfo;

  const SignInRequested({
    required this.email,
    required this.password,
    required this.saveInfo,
  });

  @override
  List<Object?> get props => [email, password, saveInfo];
}
