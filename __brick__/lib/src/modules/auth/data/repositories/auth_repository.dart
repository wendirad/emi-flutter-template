import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mime/mime.dart';
import '../../../../core/app.dart';
import '../../../../core/utils/env_loader.dart';
import '../extentions/auth_extentions.dart';
import '../models/auth_models.dart';
import '../../domain/entities/auth_entities.dart';
import '../../domain/failures/auth_failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  const AuthRepository({required this.auth, required this.store});

  @override
  Future<bool> get isAuthenticated async => auth.currentUser != null;

  @override
  Future<Either<AuthSessionFailure, Stream<bool>>> get authStateChanges async {
    try {
      return Right(auth.authStateChanges().map((User? user) => user != null));
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: '$e');
      return Left(AuthSessionFailure.fromCode('internal-error'));
    }
  }

  @override
  Future<Either<SignUpWithEmailAndPasswordFailure, Unit>>
  signUpWithEmailandPassword({
    required String email,
    required String password,
    required String businessName,
  }) async {
    try {
      final UserCredential credential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user == null) {
        throw none();
      }

      AuthUserModel authUser = credential.user!.domain();

      try {
        await store.collection('user').doc(authUser.uid).set({
          'businessName': businessName,
          'lastUpdateTime': FieldValue.serverTimestamp(),
        });
      } catch (err) {
        credential.user?.delete();
        throw none();
      }

      return Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(SignUpWithEmailAndPasswordFailure.fromCode(e.code));
    } catch (_, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return Left(SignUpWithEmailAndPasswordFailure.fromCode('unknow-error'));
    }
  }

  @override
  Future<Either<SignInWithEmailAndPasswordFailure, Unit>>
  signInWithEmailAndPassword({
    required String email,
    required String password,
    required bool saveInfo,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      final prefs = await SharedPreferences.getInstance();

      if (saveInfo) {
        await prefs.setBool('signInInfoSave', true);
        await prefs.setString('email', email);
      } else {
        await prefs.setBool('signInInfoSave', false);
        await prefs.remove('email');
      }

      // Passwords are never persisted. Clear any value stored by older builds.
      await prefs.remove('password');

      return Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(SignInWithEmailAndPasswordFailure.fromCode(e.code));
    } catch (e, stackTrace) {
      debugPrint('Error SignIn: $e');
      debugPrintStack(stackTrace: stackTrace);
      return Left(SignInWithEmailAndPasswordFailure.fromCode('unknown-error'));
    }
  }

  @override
  Future<Either<PasswordResetFailure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: EnvLoader.instance.getString('passwordResetContinueURL'),
          androidPackageName: EnvLoader.instance.getString(
            'androidPackageName',
          ),
          iOSBundleId: EnvLoader.instance.getString('iOSBundleId'),
          androidInstallApp: true,
          handleCodeInApp: true,
        ),
      );

      return Right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return Right(unit);
      return Left(PasswordResetFailure.fromCode(e.code));
    } catch (e, stackTrace) {
      {
        debugPrintStack(stackTrace: stackTrace);
        return Left(PasswordResetFailure.fromCode('unknown-error'));
      }
    }
  }

  @override
  Future<Either<PasswordResetConfirmFailure, bool>> verifyPasswordResetCode({
    required String code,
  }) async {
    try {
      await auth.verifyPasswordResetCode(code);
      return Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(PasswordResetConfirmFailure.fromCode(e.code));
    } catch (_) {
      return Left(PasswordResetConfirmFailure.fromCode('invalid-action-code'));
    }
  }

  @override
  Future<Either<PasswordResetConfirmFailure, Unit>> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await auth.confirmPasswordReset(code: code, newPassword: newPassword);
      return Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(PasswordResetConfirmFailure.fromCode(e.code));
    } catch (_) {
      return Left(PasswordResetConfirmFailure.fromCode('invalid-action-code'));
    }
  }

  @override
  Future<Option<AuthUser>> getSignedInUser() async {
    try {
      // await auth.currentUser?.reload();

      final User? user = auth.currentUser;

      if (user == null) return none();

      final AuthUserModel userDomain = user.domain();

      final DocumentSnapshot<Map<String, dynamic>> userDoc = await store
          .collection(StoreName.user)
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final Map<String, dynamic>? userData = userDoc.data();

        userData?.addAll(userDomain.toJson()..removeWhere((k, v) => v == null));

        final DocumentSnapshot<Map<String, dynamic>> adminDoc = await store
            .collection(StoreName.admin)
            .doc(user.email)
            .get();

        return some(
          (adminDoc.exists
                  ? AdminAuthUserModel.fromJson
                  : BusinessUserModel.fromJson)(userData!)
              .entity(),
        );
      }

      return some(userDomain.entity());
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      throw AuthSessionFailure.fromCode(e.code);
    } catch (e, stackTrace) {
      if (e is FirebaseException) await signOut();

      debugPrintStack(stackTrace: stackTrace);
      throw AuthSessionFailure.fromCode('unknown-error');
    }
  }

  @override
  Future<Either<SignOutFailure, Unit>> signOut() async {
    try {
      await auth.signOut();
      return Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(SignOutFailure.fromCode(e.code));
    } catch (_, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return Left(SignOutFailure.fromCode('internal-error'));
    }
  }

  @override
  Future<Either<ProfileUpdateFailure, Unit>> updateProfile({
    String? businessName,
    String? firstName,
    String? lastName,
    File? profilePicture,
  }) async {
    try {
      await auth.currentUser?.reload();
      final User? user = auth.currentUser;

      if (user == null) throw none();

      if (profilePicture != null) {
        final String format = profilePicture.path.split('.').last;
        final String refName = '${StoreName.profilePicture}${user.uid}.$format';

        await _uploadProfilePhoto(profilePicture, refName);

        final String photoUrl =
            'gs://${Modular.get<FirebaseStorage>().bucket}/$refName';

        await user.updatePhotoURL(photoUrl);
      } else {
        user.updatePhotoURL(null);
      }

      final DocumentSnapshot<Map<String, dynamic>> userDoc = await store
          .collection(StoreName.user)
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final Map<String, dynamic> updateData = {
          'lastUpdateTime': FieldValue.serverTimestamp(),
        };

        if (businessName != null) {
          updateData['businessName'] = businessName;
        }

        if (firstName != null) {
          updateData['firstName'] = firstName;
        }

        if (lastName != null) {
          updateData['lastName'] = lastName;
        }

        await store.collection(StoreName.user).doc(user.uid).update(updateData);
      }

      return Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(ProfileUpdateFailure.fromCode(e.code));
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: '$e');
      return Left(ProfileUpdateFailure.fromCode('unknown-error'));
    }
  }

  Future<void> _uploadProfilePhoto(File profilePicture, String refName) async {
    final profilePictureRef = Modular.get<FirebaseStorage>().ref().child(
      refName,
    );

    try {
      try {
        await profilePictureRef.delete();
      } catch (_) {}

      await profilePictureRef.putFile(
        profilePicture.absolute,
        SettableMetadata(contentType: lookupMimeType(profilePicture.path)),
      );
    } on FirebaseException catch (e, st) {
      debugPrint('Profile Upload Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }
}
