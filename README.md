# Flutter Template

A [Mason](https://github.com/felangel/mason) brick for starting a Flutter app with a clean, modular structure.

## What you get

- **core**: app shell, routing (`flutter_modular`), theming, splash, shared widgets, connection handling
- **auth**: sign up, sign in, sign out, password reset, profile update (Firebase Auth, Firestore, Storage)
- **errors**: error views and failure types
- **settings**: settings and about screens
- State management with `flutter_bloc`, a Home placeholder tab, Android and iOS runners

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
4. Deploy the rules if you want them:

   ```sh
   firebase deploy --only firestore:rules,firestore:indexes,storage
   ```

## 5. Run

```sh
cd <project_name>
flutter run
```

If you changed the splash settings, regenerate the splash screens:

```sh
dart run flutter_native_splash:create
```

## After generating

- Replace the placeholder links (`https://example.com/`) in the settings About screen.
- Replace `assets/splash/splash_logo.png` and the app icons.
- Add your own modules under `lib/src/modules/` and register their routes in `lib/src/app/app_module.dart` and `lib/src/core/constants/app_route.dart`.
- Android deep links use the host `<project-name>.web.app`. Change it in `AndroidManifest.xml` if you use a different domain.

## License

See [LICENSE](LICENSE).
