part of 'sign_in_bloc.dart';

// Sentinel so copyWith can tell "keep the error" from an explicit null.
const Object _unset = Object();

enum SignInProcess { idle, inProgress, failed, success }

class SignInState extends Equatable {
  final SignInProcess process;
  final SignInWithEmailAndPasswordFailure? error;

  const SignInState({
    required this.process,
    this.error,
  });

  static SignInState initial() => SignInState(process: SignInProcess.idle);

  SignInState copyWith({
    SignInProcess? process,
    Object? error = _unset,
  }) {
    return SignInState(
      process: process ?? this.process,
      error: identical(error, _unset)
          ? this.error
          : error as SignInWithEmailAndPasswordFailure?,
        );
  }

  @override
  List<Object> get props => [process, ?error];
}
