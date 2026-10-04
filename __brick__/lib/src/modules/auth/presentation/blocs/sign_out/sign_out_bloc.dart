import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/use_cases/use_cases.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';

part 'sign_out_event.dart';
part 'sign_out_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUseCase signOut;

  SignOutBloc(this.signOut) : super(SignOutState.initial()) {
    on<SignOutRequested>(_onSignOutRequested);
  }

  FutureOr<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<SignOutState> emit,
  ) async {
    emit(state.copyWith(process: SignOutProcess.inProgress, error: null));

    final result = await signOut(param: event.param);

    result.fold(
      (error) =>
          emit(state.copyWith(process: SignOutProcess.failed, error: error)),
      (_) => emit(state.copyWith(process: SignOutProcess.success, error: null)),
    );
  }
}
