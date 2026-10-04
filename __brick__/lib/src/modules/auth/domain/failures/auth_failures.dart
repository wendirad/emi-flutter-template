import '../../../../core/failures/failure.dart';

class AuthSessionFailure extends Failure {
  const AuthSessionFailure({required super.message, super.code});

  factory AuthSessionFailure.fromCode(String? code) {
    return AuthSessionFailure(
      code: code,
      message: switch (code) {
        'session-expired' => 'Your session has expired. Please sign in again.',
        'no-current-user' => 'No user is currently signed in.',
        'invalid-session-cookie' => 'The session cookie is invalid.',
        'token-revoked' =>
          'The session has been revoked. Please sign in again.',
        'requires-recent-login' =>
          'This operation requires recent authentication. Please sign in again.',
        'network-request-failed' =>
          'Network error. Please check your internet connection.',
        'internal-error' =>
          'An internal error occurred. Please try again later.',
        'user-disabled' =>
          'This user has been disabled. Please contact support for help.',
        _ => 'An unknown exception occurred.',
      },
    );
  }
}

class SignUpWithEmailAndPasswordFailure extends Failure {
  const SignUpWithEmailAndPasswordFailure({required super.message, super.code});

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    return SignUpWithEmailAndPasswordFailure(
      code: code,
      message: switch (code) {
        'invalid-email' => 'Email is not valid or badly formatted.',
        'user-disabled' =>
          'This user has been disabled. Please contact support for help.',
        'email-already-in-use' => 'An account already exists for that email.',
        'operation-not-allowed' =>
          'Operation is not allowed. Please contact support.',
        'weak-password' => 'Please enter a stronger password.',
        'too-many-requests' => 'Too many requests. Please try again later.',
        'network-request-failed' =>
          'Network error. Please check your internet connection.',
        'invalid-credential' =>
          'The supplied credential is invalid or has expired.',
        'account-exists-with-different-credential' =>
          'An account already exists with a different sign-in method.',
        'credential-already-in-use' =>
          'This credential is already associated with a different user account.',
        'internal-error' =>
          'An internal error occurred. Please try again later.',
        _ => 'An unknown exception occurred.',
      },
    );
  }
}

class SignInWithEmailAndPasswordFailure extends Failure {
  SignInWithEmailAndPasswordFailure({required super.message, super.code});

  factory SignInWithEmailAndPasswordFailure.fromCode(String? code) {
    return SignInWithEmailAndPasswordFailure(
      code: code,
      message: switch (code) {
        'invalid-email' => 'Email is not valid or badly formatted.',
        'user-disabled' =>
          'This user has been disabled. Please contact support for help.',
        'operation-not-allowed' =>
          'Operation is not allowed. Please contact support.',
        _ => 'Please make sure your email and password are correct.',
      },
    );
  }
}

class PasswordResetFailure extends Failure {
  const PasswordResetFailure({required super.message, super.code});
  factory PasswordResetFailure.fromCode(String code) {
    return PasswordResetFailure(
      code: code,
      message: switch (code) {
        'internal-error' =>
          'An internal error occurred. Please try again later.',
        _ => 'An unknown exception occurred.',
      },
    );
  }
}

class PasswordResetConfirmFailure extends Failure {
  PasswordResetConfirmFailure({required super.message, super.code});

  factory PasswordResetConfirmFailure.fromCode(String code) {
    return PasswordResetConfirmFailure(
      code: code,
      message: switch (code) {
        'expired-action-code' => 'The action code has expired.',
        'invalid-action-code' =>
          'The action code is invalid or has already been used.',
        'user-disabled' =>
          'This user has been disabled. Please contact support for help.',
        'user-not-found' =>
          'No user corresponding to the action code was found.',
        'weak-password' => 'The new password is not strong enough.',
        _ => 'An unknown exception occurred.',
      },
    );
  }
}

class SignOutFailure extends Failure {
  const SignOutFailure({required super.message, super.code});

  factory SignOutFailure.fromCode(String? code) {
    return SignOutFailure(
      code: code,
      message: switch (code) {
        'network-request-failed' =>
          'Network error. Please check your internet connection.',
        'internal-error' =>
          'An internal error occurred. Please try again later.',
        _ => 'An unknown error occurred while signing out.',
      },
    );
  }
}

class ProfileUpdateFailure extends Failure {
  const ProfileUpdateFailure({required super.message, super.code});

  factory ProfileUpdateFailure.fromCode(code) {
    return ProfileUpdateFailure(
      code: code,
      message: switch (code) {
        _ => 'An unknown error occurred while while updating profile.',
      },
    );
  }
}
