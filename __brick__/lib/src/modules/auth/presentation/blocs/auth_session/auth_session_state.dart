part of 'auth_session_bloc.dart';

// Sentinel so copyWith can tell "keep the error" from an explicit null.
const Object _unset = Object();

enum SessionStatus { initial, authenticated, unauthenticated }

class AuthSessionState extends Equatable {
  final SessionStatus status;
  final AuthSessionFailure? error;

  const AuthSessionState({required this.status, this.error});

  static AuthSessionState initial() =>
      AuthSessionState(status: SessionStatus.initial);

  bool get isAuthenticated => status == SessionStatus.authenticated;

  AuthSessionState copyWith({SessionStatus? status, Object? error = _unset}) {
    return AuthSessionState(
      status: status ?? this.status,
      error: identical(error, _unset)
          ? this.error
          : error as AuthSessionFailure?,
    );
  }

  @override
  List<Object> get props => [status, ?error];
}
