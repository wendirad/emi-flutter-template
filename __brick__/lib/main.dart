import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'src/app/app_module.dart';
import 'src/app/app_widget.dart';
import 'src/core/utils/utils.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> setupFirebase() async {
  final EnvLoader env = EnvLoader.instance;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? AndroidDebugProvider(
            debugToken: env.getOptionalString('androidDebugToken'),
          )
        : AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? AppleDebugProvider(
            debugToken: env.getOptionalString('appleDebugToken'),
          )
        : AppleAppAttestProvider(),
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  FirebaseAuth.instance.setLanguageCode('en');

  if (kDebugMode) {
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
    );
  }

  if (kDebugMode && env.getBool('useEmulators')) {
    String host = env.getString('emulatorDebugHost');

    await FirebaseAuth.instance.useAuthEmulator(
      host,
      env.getInt('authEmulatorPort'),
    );

    FirebaseFirestore.instance.useFirestoreEmulator(
      host,
      env.getInt('firestoreEmulatorPort'),
    );

    await FirebaseStorage.instance.useStorageEmulator(
      host,
      env.getInt('storageEmulatorPort'),
    );

    String? debugToken = await FirebaseAppCheck.instance.getToken();
    debugPrint("Debug Token: ${debugToken?.isNotEmpty}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvLoader.instance.load();

  await setupFirebase();

  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
