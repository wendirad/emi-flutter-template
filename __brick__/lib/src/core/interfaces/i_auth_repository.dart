import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../modules/auth/domain/entities/auth_entities.dart';
import '../../modules/auth/domain/failures/auth_failures.dart';

abstract class IAuthRepository {
  Future<bool> get isAuthenticated;

  Future<Either<AuthSessionFailure, Stream<bool>>> get authStateChanges;

  Future<Option<AuthUser>> getSignedInUser();

  Future<Either<SignUpWithEmailAndPasswordFailure, Unit>>
  signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String businessName,
  });

  Future<Either<SignInWithEmailAndPasswordFailure, Unit>>
  signInWithEmailAndPassword({
    required String email,
    required String password,
    required bool saveInfo,
  });

  Future<Either<PasswordResetFailure, Unit>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<PasswordResetConfirmFailure, bool>> verifyPasswordResetCode({
    required String code,
  });

  Future<Either<PasswordResetConfirmFailure, Unit>> confirmPasswordReset({
    required String code,
    required String newPassword,
  });

  Future<Either<SignOutFailure, Unit>> signOut();

  Future<Either<ProfileUpdateFailure, Unit>> updateProfile({
    String? businessName,
    String? firstName,
    String? lastName,
    File? profilePicture,
    bool removeProfilePicture,
  });
}
