part of 'sign_out_bloc.dart';

// Sentinel so copyWith can tell "keep the error" from an explicit null.
const Object _unset = Object();

enum SignOutProcess { idle, inProgress, failed, success }

class SignOutState extends Equatable {
  final SignOutProcess process;
  final SignOutFailure? error;

  const SignOutState({
    required this.process,
    this.error,
  });

  static SignOutState initial() => SignOutState(process: SignOutProcess.idle);

  SignOutState copyWith({SignOutProcess? process, Object? error = _unset}) {
    return SignOutState(
      process: process ?? this.process,
      error: identical(error, _unset) ? this.error : error as SignOutFailure?,
    );
  }

  @override
  List<Object?> get props => [process, ?error];
}

