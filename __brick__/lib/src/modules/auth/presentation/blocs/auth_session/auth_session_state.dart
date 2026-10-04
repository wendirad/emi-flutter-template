part of 'auth_session_bloc.dart';

enum SessionStatus { initial, authenticated, unauthenticated }

class AuthSessionState extends Equatable {
  final SessionStatus status;
  final AuthSessionFailure? error;

  const AuthSessionState({required this.status, this.error});

  static AuthSessionState initial() =>
      AuthSessionState(status: SessionStatus.initial);

  bool get isAuthenticated => status == SessionStatus.authenticated;

  AuthSessionState copyWith({
    SessionStatus? status,
    AuthSessionFailure? error,
  }) {
    return AuthSessionState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, ?error];
}
