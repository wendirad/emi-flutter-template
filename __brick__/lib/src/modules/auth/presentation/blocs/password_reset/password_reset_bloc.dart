import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/send_password_reset_use_case.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final SendPasswordResetEmailUseCase sendPasswordResetEmail;

  PasswordResetBloc(this.sendPasswordResetEmail)
    : super(PasswordResetState.initial()) {
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  FutureOr<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<PasswordResetState> emit,
  ) async {
    emit(state.copyWith(process: PasswordResetProcess.inProgress, error: null));

    final result = await sendPasswordResetEmail(param: event.param);

    result.fold(
      (error) => emit(
        state.copyWith(process: PasswordResetProcess.failed, error: error),
      ),
      (_) => emit(
        state.copyWith(process: PasswordResetProcess.successful, error: null),
      ),
    );
  }
}
