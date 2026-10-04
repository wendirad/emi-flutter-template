# Flutter Template

A [Mason](https://github.com/felangel/mason) brick for starting a Flutter app with a clean, modular structure.

## What you get

- **app**: composition root and shell screens (`flutter_modular` module, app widget, splash, home, connection and auth shells)
- **core**: feature-agnostic building blocks (theme, shared widgets, error views, constants, env loader, base `UseCase` and `Failure`)
- **auth**: sign up, sign in, sign out, password reset (Firebase Auth, Firestore)
- **profile**: edit profile name and photo (Firestore, Storage)
- Localization in English and Amharic, with a language picker in Settings
- **settings**: settings and about screens
- State management with `flutter_bloc`, a Home placeholder tab, Android and iOS runners
- Reference tests under `test/`, strict analysis options, and a bundled Poppins font
- [`AGENTS.md`](__brick__/AGENTS.md): the conventions for people and coding agents who work on a generated project

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (includes Dart)
- Firebase CLI and FlutterFire CLI if you use Firebase (see [Firebase setup](#firebase-setup))

## 1. Install Mason

```sh
dart pub global activate mason_cli
```

Make sure the pub cache is on your `PATH`. On macOS and Linux add this to your shell profile:

```sh
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Check the install:

```sh
mason --version
```

## 2. Add the brick

Install it globally from GitHub:

```sh
mason add -g flutter_template --git-url https://github.com/wendirad/emi-flutter-template
```

Or add it to a single folder (creates a `mason.yaml` there):

```sh
mason init
mason add flutter_template --git-url https://github.com/wendirad/emi-flutter-template
```

To use a local clone instead, replace the Git options with `--path /path/to/this/repo`.

To pick up a newer version of the brick later:

```sh
mason upgrade -g
```

## 3. Generate a project

```sh
mason make flutter_template
```

Mason asks for these values. You can also pass them as flags, for example `--project_name my_app`.

| Variable | Purpose | Default |
|---|---|---|
| `project_name` | Package name. Becomes the Dart package, the app name and the bundle id suffix. | none |
| `description` | Description in `pubspec.yaml` | `A new Flutter project.` |
| `org_name` | Reverse domain for the Android `applicationId` and iOS bundle id | `com.example` |
| `use_firebase` | Keep the Firebase config files (rules, indexes, `firebase_options.dart` placeholder) | `true` |
| `use_camera` | Add the iOS camera permission (`NSCameraUsageDescription`) | `true` |
| `use_photo_library` | Add the iOS photo library permission (`NSPhotoLibraryUsageDescription`) | `true` |

Answer `false` to a permission prompt and Mason leaves that permission out of the generated project. The Android `INTERNET` permission is always included because Firebase needs it.

The camera and photo library permissions are used by the profile photo picker in the auth module. If you decline them, remove or change that feature.

Choosing `use_firebase: false` only removes the Firebase config files. The auth module still imports Firebase packages, so replace or remove them before you build.

After generation Mason runs `flutter pub get` and creates an empty `.env` file, which `pubspec.yaml` lists as an asset.

## 4. Firebase setup

1. Create a Firebase project in the [console](https://console.firebase.google.com).
2. Enable Authentication (Email/Password), Firestore and Storage.
3. Run, from the generated project:

   ```sh
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   This overwrites the placeholder `lib/firebase_options.dart` and adds `google-services.json` and `GoogleService-Info.plist`.
4. Review and deploy the rules:

   ```sh
   firebase deploy --only firestore:rules,firestore:indexes,storage
   ```

   The shipped rules let a signed-in user read and write only their own `user/{uid}` document and read only their own `admin/{email}` document (clients cannot write `admin`). In Storage a user can read `images/profile_picture/` and write only `<uid>.<ext>` there (images under 5 MB). They have not been run against the emulator, so test them before you rely on them.

## 5. Run

```sh
cd <project_name>
flutter run
```

If you changed the splash settings, regenerate the splash screens:

```sh
dart run flutter_native_splash:create
```

## 6. Configure `.env`

The app reads these keys from `.env` (see `lib/src/core/constants/env_keys.dart`). Every key is optional unless a feature below needs it. `.env` is bundled into the app, so never put server secrets in it.

| Key | Used for |
|---|---|
| `passwordResetContinueURL`, `androidPackageName`, `iOSBundleId` | The link in the password reset email |
| `avatarsPublicProvider` | Default avatar image URL when a user has no photo |
| `privacyPolicyUrl`, `termsOfServiceUrl` | Settings entries; hidden when empty |
| `facebookUrl`, `twitterUrl`, `linkedinUrl` | About screen buttons; hidden when empty |
| `androidDebugToken`, `appleDebugToken` | Firebase App Check debug tokens (debug builds) |
| `useEmulators`, `emulatorDebugHost`, `authEmulatorPort`, `firestoreEmulatorPort`, `storageEmulatorPort` | Use the Firebase emulators (debug builds only, off unless `useEmulators=true`) |

## Check your work

```sh
flutter analyze
flutter test
```

CI runs both on every push. Analysis is strict (`strict-casts`, `strict-raw-types`, sorted imports), so a new file should follow `AGENTS.md` to pass.

## After generating

- Replace `assets/splash/splash_logo.png` and the app icons.
- The Poppins font in `google_fonts/` is licensed under the SIL Open Font License (`google_fonts/OFL.txt`). If you change the font, update `lib/src/core/theme/components.dart` and the bundled files together.
- Add your own modules under `lib/src/modules/` and register their routes in `lib/src/app/app_module.dart` and `lib/src/core/constants/app_route.dart`.
- Android deep links use the host `<project-name>.web.app`. Change it in `AndroidManifest.xml` if you use a different domain.

## License

See [LICENSE](LICENSE).
