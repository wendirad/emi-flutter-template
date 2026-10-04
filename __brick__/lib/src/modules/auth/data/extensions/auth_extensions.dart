import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_models.dart';

extension AuthUserMapperExtensions on User {
  AuthUserModel domain() {
    return AuthUserModel(
      uid: uid,
      email: email,
      creationTime: metadata.creationTime,
      lastSignInTime: metadata.lastSignInTime,
      photoUrl: photoURL,
    );
  }
}
