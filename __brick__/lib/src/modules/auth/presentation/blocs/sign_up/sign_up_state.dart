part of 'sign_up_bloc.dart';

// Sentinel so copyWith can tell "keep the error" from an explicit null.
const Object _unset = Object();

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
    Object? error = _unset,
  }) => SignUpState(
    process: process ?? this.process,
    showPassword: showPassword ?? this.showPassword,
    showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    error: identical(error, _unset)
        ? this.error
        : error as SignUpWithEmailAndPasswordFailure?,
  );

  @override
  List<Object> get props => [
    process,
    showPassword,
    showConfirmPassword,
    ?error,
  ];
}
