part of 'sign_out_bloc.dart';

enum SignOutProcess { idle, inProgress, failed, success }

class SignOutState extends Equatable {
  final SignOutProcess process;
  final SignOutFailure? error;

  const SignOutState({
    required this.process,
    this.error,
  });

  static SignOutState initial() => SignOutState(process: SignOutProcess.idle);

  SignOutState copyWith({
    SignOutProcess? process,
    SignOutFailure? error,
  }) {
    return SignOutState(
      process: process ?? this.process,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [process, ?error];
}

