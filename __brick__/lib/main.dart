import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'src/app/app_module.dart';
import 'src/app/app_widget.dart';
import 'src/core/theme/theme.dart';
import 'src/core/constants/constants.dart';
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
            debugToken: env.getOptionalString(EnvKeys.androidDebugToken),
          )
        : AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? AppleDebugProvider(
            debugToken: env.getOptionalString(EnvKeys.appleDebugToken),
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

  if (kDebugMode && env.getBool(EnvKeys.useEmulators)) {
    String host = env.getString(EnvKeys.emulatorDebugHost);

    await FirebaseAuth.instance.useAuthEmulator(
      host,
      env.getInt(EnvKeys.authEmulatorPort),
    );

    FirebaseFirestore.instance.useFirestoreEmulator(
      host,
      env.getInt(EnvKeys.firestoreEmulatorPort),
    );

    await FirebaseStorage.instance.useStorageEmulator(
      host,
      env.getInt(EnvKeys.storageEmulatorPort),
    );

    String? debugToken = await FirebaseAppCheck.instance.getToken();
    debugPrint("Debug Token: ${debugToken?.isNotEmpty}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvLoader.instance.load();

  await setupFirebase();

  final ThemeService themeService = ThemeService();
  await themeService.load();

  runApp(
    ModularApp(
      module: AppModule(themeService: themeService),
      child: AppWidget(),
    ),
  );
}
