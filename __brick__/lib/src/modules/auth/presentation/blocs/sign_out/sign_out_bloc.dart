import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/blocs/process_state.dart';
import '../../../../../core/use_cases/use_cases.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'sign_out_event.dart';

typedef SignOutState = ProcessState<SignOutFailure>;

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUseCase _signOut;

  SignOutBloc({required SignOutUseCase signOut})
    : _signOut = signOut,
      super(const SignOutState.idle()) {
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<SignOutState> emit,
  ) async {
    emit(const SignOutState.inProgress());

    final result = await _signOut(param: const NoParam());

    emit(
      result.fold(
        SignOutState.failure,
        (_) => const SignOutState.success(),
      ),
    );
  }
}
