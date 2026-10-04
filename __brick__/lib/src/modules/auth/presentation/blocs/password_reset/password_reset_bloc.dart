import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/blocs/process_state.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'password_reset_event.dart';

typedef PasswordResetState = ProcessState<PasswordResetFailure>;

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final SendPasswordResetEmailUseCase _sendPasswordResetEmail;

  PasswordResetBloc({
    required SendPasswordResetEmailUseCase sendPasswordResetEmail,
  }) : _sendPasswordResetEmail = sendPasswordResetEmail,
       super(const PasswordResetState.idle()) {
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<PasswordResetState> emit,
  ) async {
    emit(const PasswordResetState.inProgress());

    final result = await _sendPasswordResetEmail(
      param: SendPasswordResetEmailParam(email: event.email),
    );

    emit(
      result.fold(
        PasswordResetState.failure,
        (_) => const PasswordResetState.success(),
      ),
    );
  }
}
