import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/interfaces/i_auth_repository.dart';
import '../../../domain/failures/auth_failures.dart';

part 'auth_session_event.dart';
part 'auth_session_state.dart';

class AuthSessionBloc extends Bloc<AuthSessionEvent, AuthSessionState> {
  final IAuthRepository _authRepository;
  AuthSessionBloc({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthSessionState.initial()) {
    on<AuthSessionUserSubscriptionRequested>(
      _onSessionUserSubscriptionRequested,
    );
  }

  FutureOr<void> _onSessionUserSubscriptionRequested(
    AuthSessionUserSubscriptionRequested event,
    Emitter<AuthSessionState> emit,
  ) async {
    return emit.onEach(
      _authRepository.authStateChanges.asStream(),
      onData: (authSession) {
        authSession.fold(
          (error) => emit(
            state.copyWith(status: SessionStatus.unauthenticated, error: error),
          ),
          (_) => emit(
            state.copyWith(status: SessionStatus.authenticated, error: null),
          ),
        );
      },
      onError: addError,
    );
  }
}
