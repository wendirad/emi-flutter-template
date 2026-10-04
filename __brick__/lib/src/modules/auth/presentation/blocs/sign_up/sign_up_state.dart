part of 'sign_up_bloc.dart';

// Sentinel so copyWith can tell "keep the error" from an explicit null.
const Object _unset = Object();

enum SignUpProcess { idle, inProgress, successful, failed }

class SignUpState extends Equatable {
  final SignUpProcess process;
  final SignUpWithEmailAndPasswordFailure? error;

  const SignUpState({
    required this.process,
    this.error,
  });

  static SignUpState initial() => SignUpState(process: SignUpProcess.idle);

  SignUpState copyWith({
    SignUpProcess? process,
    Object? error = _unset,
  }) => SignUpState(
    process: process ?? this.process,
    error: identical(error, _unset)
        ? this.error
        : error as SignUpWithEmailAndPasswordFailure?,
  );

  @override
  List<Object> get props => [
    process,
    ?error,
  ];
}
