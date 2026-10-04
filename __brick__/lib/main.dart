import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'src/core/configs/app_module.dart';
import 'src/core/configs/app_widget.dart';
import 'src/core/utils/utils.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> setupFirebase() async {
  EnvLoader env = EnvLoader.instance;
  final String? demoProjectId = env.getOptionalString('demoProjectId');
  final String? projectName = env.getOptionalString('projectName');

  if (projectName == demoProjectId && projectName == null) {
    throw Exception('You must provide "demoProjectId" or "projectName"');
  }

  if (projectName == demoProjectId) {
    throw Exception('You must provide "demoProjectId" or "projectName"');
  }

  await Firebase.initializeApp(
    // demoProjectId: demoProjectId,
    // name: projectName,
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );

  if (env.getBool('debugDebug', defaultValue: true)) {
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
  await EnvLoader.instance.load();

  WidgetsFlutterBinding.ensureInitialized();

  await setupFirebase();

  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
