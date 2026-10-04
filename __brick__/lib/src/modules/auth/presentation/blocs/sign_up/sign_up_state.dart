part of 'sign_up_bloc.dart';

enum SignUpProcess { idle, inProgress, successful, failed }

class SignUpState extends Equatable {
  final SignUpProcess process;
  final SignUpWithEmailAndPasswordFailure? error;
  final bool showPassword;
  final bool showConfirmPassword;

  const SignUpState({
    required this.process,
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.error,
  });

  static SignUpState initial() => SignUpState(process: SignUpProcess.idle);

  SignUpState copyWith({
    SignUpProcess? process,
    bool? showPassword,
    bool? showConfirmPassword,
    SignUpWithEmailAndPasswordFailure? error,
  }) => SignUpState(
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
