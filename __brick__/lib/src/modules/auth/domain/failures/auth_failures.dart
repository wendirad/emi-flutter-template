import '../../../../core/failures/failure.dart';

const String _unknownMessage = 'An unknown exception occurred.';

/// Messages shared by every auth failure. A failure's own table wins over
/// these; unmatched codes fall back to the failure's default message.
const Map<String, String> _commonMessages = {
  'network-request-failed':
      'Network error. Please check your internet connection.',
  'internal-error': 'An internal error occurred. Please try again later.',
  'user-disabled':
      'This user has been disabled. Please contact support for help.',
  'operation-not-allowed': 'Operation is not allowed. Please contact support.',
  'too-many-requests': 'Too many requests. Please try again later.',
  'no-current-user': 'No user is currently signed in.',
  'requires-recent-login':
      'This operation requires recent authentication. Please sign in again.',
};

String _messageFor(
  String? code,
  Map<String, String> own, {
  String fallback = _unknownMessage,
}) => own[code] ?? _commonMessages[code] ?? fallback;

class AuthSessionFailure extends Failure {
  const AuthSessionFailure({required super.message, super.code});

  static const Map<String, String> _messages = {
    'session-expired': 'Your session has expired. Please sign in again.',
    'invalid-session-cookie': 'The session cookie is invalid.',
    'token-revoked': 'The session has been revoked. Please sign in again.',
  };

  factory AuthSessionFailure.fromCode(String? code) =>
      AuthSessionFailure(code: code, message: _messageFor(code, _messages));
}

class SignUpWithEmailAndPasswordFailure extends Failure {
  const SignUpWithEmailAndPasswordFailure({required super.message, super.code});

  static const Map<String, String> _messages = {
    'invalid-email': 'Email is not valid or badly formatted.',
    'email-already-in-use': 'An account already exists for that email.',
    'weak-password': 'Please enter a stronger password.',
    'invalid-credential': 'The supplied credential is invalid or has expired.',
    'account-exists-with-different-credential':
        'An account already exists with a different sign-in method.',
    'credential-already-in-use':
        'This credential is already associated with a different user account.',
  };

  factory SignUpWithEmailAndPasswordFailure.fromCode(String? code) =>
      SignUpWithEmailAndPasswordFailure(
        code: code,
        message: _messageFor(code, _messages),
      );
}

class SignInWithEmailAndPasswordFailure extends Failure {
  const SignInWithEmailAndPasswordFailure({required super.message, super.code});

  static const Map<String, String> _messages = {
    'invalid-email': 'Email is not valid or badly formatted.',
  };

  // Wrong password and unknown email share one message so the screen does not
  // reveal which accounts exist.
  factory SignInWithEmailAndPasswordFailure.fromCode(String? code) =>
      SignInWithEmailAndPasswordFailure(
        code: code,
        message: _messageFor(
          code,
          _messages,
          fallback: 'Please make sure your email and password are correct.',
        ),
      );
}

class PasswordResetFailure extends Failure {
  const PasswordResetFailure({required super.message, super.code});

  factory PasswordResetFailure.fromCode(String? code) => PasswordResetFailure(
    code: code,
    message: _messageFor(code, const {}),
  );
}

class PasswordResetConfirmFailure extends Failure {
  const PasswordResetConfirmFailure({required super.message, super.code});

  static const Map<String, String> _messages = {
    'expired-action-code': 'The action code has expired.',
    'invalid-action-code':
        'The action code is invalid or has already been used.',
    'user-not-found': 'No user corresponding to the action code was found.',
    'weak-password': 'The new password is not strong enough.',
  };

  factory PasswordResetConfirmFailure.fromCode(String? code) =>
      PasswordResetConfirmFailure(
        code: code,
        message: _messageFor(code, _messages),
      );
}

class SignOutFailure extends Failure {
  const SignOutFailure({required super.message, super.code});

  factory SignOutFailure.fromCode(String? code) => SignOutFailure(
    code: code,
    message: _messageFor(
      code,
      const {},
      fallback: 'An unknown error occurred while signing out.',
    ),
  );
}

class ProfileUpdateFailure extends Failure {
  const ProfileUpdateFailure({required super.message, super.code});

  factory ProfileUpdateFailure.fromCode(String? code) => ProfileUpdateFailure(
    code: code,
    message: _messageFor(
      code,
      const {},
      fallback: 'An unknown error occurred while updating profile.',
    ),
  );
}
