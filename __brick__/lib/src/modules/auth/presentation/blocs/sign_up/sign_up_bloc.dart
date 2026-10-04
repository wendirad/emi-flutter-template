import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/sign_up_with_email_and_password_use_case.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpWithEmailAndPasswordUseCase signUp;

  SignUpBloc(this.signUp) : super(SignUpState.initial()) {
    on<SignUpToggleShowPassword>(
      (_, emit) => emit(state.copyWith(showPassword: !state.showPassword)),
    );
    on<SignUpToggleShowConfirmPassword>(
      (_, emit) =>
          emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword)),
    );
    on<SignUpRequested>(_onSignUpRequested);
  }

  FutureOr<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(process: SignUpProcess.inProgress, error: null));

    final result = await signUp(param: event.param);

    result.fold(
      (error) =>
          emit(state.copyWith(process: SignUpProcess.failed, error: error)),
      (_) =>
          emit(state.copyWith(process: SignUpProcess.successful, error: null)),
    );
  }
}
