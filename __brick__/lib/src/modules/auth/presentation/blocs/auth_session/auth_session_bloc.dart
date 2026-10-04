import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/i_auth_repository.dart';
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

  Future<void> _onSessionUserSubscriptionRequested(
    AuthSessionUserSubscriptionRequested event,
    Emitter<AuthSessionState> emit,
  ) async {
    final result = await _authRepository.authStateChanges;

    await result.fold(
      (error) async => emit(
        state.copyWith(status: SessionStatus.unauthenticated, error: error),
      ),
      (signedInChanges) => emit.onEach<bool>(
        signedInChanges,
        onData: (signedIn) => emit(
          state.copyWith(
            status: signedIn
                ? SessionStatus.authenticated
                : SessionStatus.unauthenticated,
            error: null,
          ),
        ),
        onError: addError,
      ),
    );
  }
}
