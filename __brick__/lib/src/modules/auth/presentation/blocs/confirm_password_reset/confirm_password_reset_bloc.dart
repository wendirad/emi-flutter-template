import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/confirm_password_reset_use_case.dart';

part 'confirm_password_reset_event.dart';
part 'confirm_password_reset_state.dart';

class ConfirmPasswordResetBloc
    extends Bloc<ConfirmPasswordResetEvent, ConfirmPasswordResetState> {
  final ConfirmPasswordResetUseCase confirmPasswordReset;

  ConfirmPasswordResetBloc(this.confirmPasswordReset)
    : super(ConfirmPasswordResetState.initial()) {
    on<ConfirmPasswordResetToggleShowPassword>(
      (_, emit) => emit(state.copyWith(showPassword: !state.showPassword)),
    );
    on<ConfirmPasswordResetToggleShowConfirmPassword>(
      (_, emit) =>
          emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword)),
    );
    on<ConfirmPasswordResetRequested>(_onConfirmPasswordResetRequested);
  }

  FutureOr<void> _onConfirmPasswordResetRequested(
    ConfirmPasswordResetRequested event,
    Emitter<ConfirmPasswordResetState> emit,
  ) async {
    emit(
      state.copyWith(
        process: ConfirmPasswordResetProcess.inProgress,
        error: null,
      ),
    );

    final result = await confirmPasswordReset(param: event.param);

    result.fold(
      (error) => emit(
        state.copyWith(
          process: ConfirmPasswordResetProcess.failed,
          error: error,
        ),
      ),
      (_) => emit(
        state.copyWith(
          process: ConfirmPasswordResetProcess.successful,
          error: null,
        ),
      ),
    );
  }
}
