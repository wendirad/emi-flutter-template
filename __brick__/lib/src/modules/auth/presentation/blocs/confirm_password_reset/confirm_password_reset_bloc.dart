import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/presentation/blocs/process_state.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'confirm_password_reset_event.dart';

typedef ConfirmPasswordResetState = ProcessState<PasswordResetConfirmFailure>;

class ConfirmPasswordResetBloc
    extends Bloc<ConfirmPasswordResetEvent, ConfirmPasswordResetState> {
  final ConfirmPasswordResetUseCase _confirmPasswordReset;

  ConfirmPasswordResetBloc({
    required ConfirmPasswordResetUseCase confirmPasswordReset,
  }) : _confirmPasswordReset = confirmPasswordReset,
       super(const ConfirmPasswordResetState.idle()) {
    on<ConfirmPasswordResetRequested>(_onConfirmPasswordResetRequested);
  }

  Future<void> _onConfirmPasswordResetRequested(
    ConfirmPasswordResetRequested event,
    Emitter<ConfirmPasswordResetState> emit,
  ) async {
    emit(const ConfirmPasswordResetState.inProgress());

    final result = await _confirmPasswordReset(
      param: ConfirmPasswordResetParam(
        code: event.code,
        newPassword: event.newPassword,
      ),
    );

    emit(
      result.fold(
        (failure) => ConfirmPasswordResetState.failure(failure),
        (_) => const ConfirmPasswordResetState.success(),
      ),
    );
  }
}
