part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends SignUpEvent {
  final String email;
  final String password;
  final String businessName;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.businessName,
  });

  @override
  List<Object?> get props => [email, password, businessName];
}
