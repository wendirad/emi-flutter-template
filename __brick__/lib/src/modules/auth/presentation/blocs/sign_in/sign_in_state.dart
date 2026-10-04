part of 'sign_in_bloc.dart';

enum SignInProcess { idle, inProgress, failed, success }

class SignInState extends Equatable {
  final SignInProcess process;
  final SignInWithEmailAndPasswordFailure? error;
  final bool showPassword;
  final bool saveInfo;

  const SignInState({
    required this.process,
    this.error,
    this.showPassword = false,
    this.saveInfo = false,
  });

  static SignInState initial() => SignInState(process: SignInProcess.idle);

  SignInState copyWith({
    SignInProcess? process,
    SignInWithEmailAndPasswordFailure? error,
    bool? showPassword,
    bool? saveInfo,
  }) {
    return SignInState(
      process: process ?? this.process,
      error: error ?? this.error,
      showPassword: showPassword ?? this.showPassword,
      saveInfo: saveInfo ?? this.saveInfo,
    );
  }

  @override
  List<Object> get props => [process, ?error, showPassword, saveInfo];
}
