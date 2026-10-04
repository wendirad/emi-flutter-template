import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInWithEmailAndPasswordUseCase signIn;

  SignInBloc(this.signIn) : super(SignInState.initial()) {
    on<SignInToggleShowPassword>(
      (_, emit) => emit(state.copyWith(showPassword: !state.showPassword)),
    );

    on<SignInToggleSaveInfo>(
      (_, emit) => emit(state.copyWith(saveInfo: !state.saveInfo)),
    );

    on<SignInRequested>(_onSignInRequested);
  }

  FutureOr<void> _onSignInRequested(
    SignInRequested event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(process: SignInProcess.inProgress, error: null));

    final result = await signIn(param: event.param);

    result.fold(
      (error) =>
          emit(state.copyWith(process: SignInProcess.failed, error: error)),
      (_) => emit(state.copyWith(process: SignInProcess.success, error: null)),
    );
  }
}
