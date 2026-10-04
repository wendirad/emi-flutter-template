# Working in this project

Read this before you add, change or delete code. It describes the conventions the code already follows so new work looks like the old work.

## Check your work

```sh
flutter analyze   # strict: strict-casts, strict-raw-types, sorted imports
flutter test
```

Both must pass. CI runs both. Run `dart format` on files you create. Do not reformat files you are not otherwise changing.

## Layout and dependency rules

```
lib/
  main.dart            boot: env, Firebase, theme, runApp
  src/
    app/               composition root and shell screens
    core/              feature-agnostic building blocks
    modules/<feature>/ one folder per feature
test/                  mirrors lib/ (test/src/...)
```

Dependencies point one way:

- `core` imports nothing from `modules/` or `app/`. If deleting a feature would break a `core` file, the file is in the wrong place.
- `modules/<feature>` may import `core`. It imports another feature only through that feature's public barrel (`modules/auth/auth.dart`), never its internals. `modules/profile` is the smallest example of a feature that builds on `auth`.
- `app/` may import everything. It is the only place that wires features together (routes, DI, shell screens).
- Inside a feature: `domain` imports no Flutter, no `data`, no `presentation`. `data` implements `domain`. `presentation` uses `domain` through blocs.

A feature looks like this (`modules/auth` is the reference):

```
<feature>.dart                  public barrel, the only file others import
<feature>_module.dart           routes and DI binds
domain/
  entities/                     plain Dart classes
  failures/                     Failure subclasses
  repositories/                 abstract interfaces (IFooRepository)
  use_cases/                    one use case per file, plus a barrel
  validators/
data/
  models/ repositories/ extensions/
presentation/
  blocs/<name>/                 <name>_bloc.dart, <name>_event.dart
  views/<screen>/               <screen>_view.dart
  views/widgets/                widgets used by several screens of this feature
  guards/                       route guards
```

## Imports and files

- Inside the package use relative imports. Order: `dart:`, `package:`, relative, each sorted, then exports. `directives_ordering` enforces it.
- Import a `core` sub-package through its barrel (`core/constants/constants.dart`, `core/presentation/widgets/widgets.dart`, `core/theme/theme.dart`, `core/presentation/errors/errors.dart`, `core/utils/utils.dart`). Files inside that package import their siblings directly, never their own barrel.
- One public class per file, file named after the class in snake_case (`SignInBloc` is `sign_in_bloc.dart`). Allowed exceptions: a use case with its `*Param`, events or states in the bloc's `part` files, and grouped entities, models and failures in `<feature>_entities.dart`, `_models.dart`, `_failures.dart`.
- Add every new public file to its folder's barrel. Remove it from the barrel when you delete it.
- Do not use `Route`, `TextField`, `FormField` or other names that shadow Flutter. Custom widgets are `AppX` or named for their feature.
- Never edit `*.g.dart`. After changing a `@JsonSerializable` model run `dart run build_runner build --delete-conflicting-outputs`.

## State: blocs

Every piece of screen state that comes from doing work is a bloc. Local `State` is only for pure UI state: a text controller, an obscure-password toggle, a checkbox. Do not add events like `ToggleShowPassword`.

A bloc that runs one use case uses `ProcessState<F>` (`core/presentation/blocs/process_state.dart`):

| Status | Meaning | Check with |
|---|---|---|
| `idle` | nothing has happened yet | `state.isIdle` |
| `inProgress` | the use case is running | `state.isInProgress` |
| `success` | it finished | `state.isSuccess` |
| `failure` | it failed; `state.failure` is the typed failure | `state.isFailure` |

A bloc that loads a value uses `LoadState<T, F>` and reads it from `state.data`. Expose the state through a typedef in the bloc file: `typedef SignInState = ProcessState<SignInWithEmailAndPasswordFailure>;`. `AuthSessionBloc` and `ConnectionShellBloc` have their own state classes because they model a status, not a request.

Rules:

- Name them `<Verb><Noun>Bloc`, events `<Verb><Noun>Requested`, in `blocs/<snake_name>/`.
- The constructor takes the use case as a named required parameter: `SignInBloc(signIn: ...)`.
- A bloc depends on use cases, never on a repository or a Firebase class.
- Events carry primitives. The bloc builds the use case's `Param`.
- Emit `inProgress` first, then `success` or `failure`. Never emit a state in which the status and `failure` disagree.
- In widgets use `ReadContext(context).read<T>()` and `WatchContext(context).watch<T>()`. Plain `context.read` is ambiguous because both `flutter_bloc` and `flutter_modular` define it.

## Errors and data access

- Repositories and use cases return `Either<Failure, T>` (`fpdart`). They do not throw to the caller.
- A feature's failures live in `domain/failures/`. Each has a `const` constructor and `fromCode(String?)`, resolved through the failure's own message table, then the shared `_commonMessages`, then a default.
- Only a repository touches Firebase, `SharedPreferences` or the network. Views, blocs and use cases never do. `ThemeService` is the one core service that reads preferences.
- Inject dependencies through constructors. Bind them in the owning module's `exportedBinds`/`binds`. `Modular.get` is allowed in module binds, route builders, `BlocProvider.create` and guards, nowhere else.
- Never persist a password. Remember-me stores the email only.

## Strings and keys

No inline keys. Add them to the matching class in `core/constants/`:

| Kind | Class | Notes |
|---|---|---|
| `.env` key | `EnvKeys` | document it in the README table |
| `SharedPreferences` key | `PrefKeys` | stored values must not change without a migration |
| Firestore collection | `FirestoreCollections` | keep in sync with `firestore.rules` |
| Storage path | `StoragePaths` | keep in sync with `storage.rules` |
| Asset path | `Illustrations` | |
| Route | `AppRoute` | add the route to the right module as well |

`.env` is bundled into the app. It is configuration, not a place for secrets.

User-facing text is localized (English and Amharic). Never write it inline in a widget:

- Add the key to both `lib/src/core/l10n/arb/app_en.arb` and `app_am.arb`, with a `{placeholder}` and an `@key` entry for each parameter in `app_en.arb`. Then run `flutter gen-l10n` and commit the output in `lib/src/core/l10n/generated/`. `arb_files_test.dart` fails when a key is missing from either file.
- Read it with `context.l10n.<key>` (`core/extensions/build_context_extensions.dart`). Keys are camelCase and start with the area: `signInTitle`, `settingsGeneral`, `failureNetwork`.
- Domain code has no `BuildContext` and no Flutter, so it returns data, not text. Validators return a `ValidationError`; failures carry a `code`. The screen turns them into text: `error.message(context.l10n)` and `failure.localized(context.l10n)` (`presentation/extensions/`). `Failure.message` is English for logs and tests; do not show it.
- Developer-facing text (exceptions, `debugPrint`) stays English and unlocalized.
- The Amharic strings were written without a native review. Have a speaker check them before release.
- To add a language, add `app_<code>.arb` next to the others and run `flutter gen-l10n`. The picker in Settings lists every supported locale. Poppins has no Ethiopic glyphs, so Amharic text uses the platform fallback font.

## UI

- Colors and text styles come from the theme: `context.cs`, `context.tt`, `context.appColors`, `context.isDark`. No `Colors.*` (except `Colors.transparent`) and no `Color(0x...)` outside `core/theme/`. A new raw color goes in `AppPalette`; a new semantic color goes in `AppColors`.
- Reuse the shared widgets in `core/presentation/widgets/`: `AppButton` (`isLoading` shows the spinner and blocks taps), `AppSnackBar.success/error/info`, `AppAlert`, `InputField`, `UserAvatar`, `AsyncPageLoader`, and `ErrorView` for failure screens.
- Auth screens use `AuthScaffold` and `AuthFooter`. A new screen that looks like them should too.
- Forms own their `TextEditingController`s: create them in `initState`, dispose them in `dispose`, pass them to the field widgets, and read `controller.text`. Do not expose widget state through `GlobalKey`.
- Show a failure with `AppAlert` inside the form, or `AppSnackBar.error` for a one-off. Show a loading state with `AppButton(isLoading:)`.
- Fonts: Poppins is bundled in `google_fonts/` and runtime fetching is off. A new weight needs its file added there and a line in `test/src/core/theme/bundled_fonts_test.dart`.

## How to

**Add a use case.** Add `domain/use_cases/<name>_use_case.dart` implementing `UseCase<T, Param>` with its `Param` (or `NoParam`), export it from `use_cases.dart`, add the repository method to the interface and implement it in `data/repositories/`, bind it in `<feature>_module.dart`, and add a use case test.

**Add a bloc and screen.** Create `blocs/<name>/` with the bloc and event files, using `ProcessState` or `LoadState`. Create `views/<screen>/<screen>_view.dart`, provide the bloc with `BlocProvider(create: ...)` in the view, export the view from `views/views.dart`, add the route to `AppRoute` and to the module's `routes`, and add a bloc test.

**Add a feature module.** Copy the `modules/auth` shape (`modules/profile` is the smallest example), add `<feature>.dart` with only what others may use, register `<Feature>Module` in `app/app_module.dart` (`ModuleRoute` and `imports`), and add its routes to `AppRoute`.

**Add a failure.** Add the class to `domain/failures/<feature>_failures.dart` following the existing ones and add any new code to its English message table. Add the text for the code to both `.arb` files and map it in the feature's `presentation/extensions/<feature>_failure_message.dart`, then extend `auth_failures_test.dart` and `auth_failure_message_test.dart`-style tests.

**Rename or move a file.** Use `git mv`. Update every relative import and export, the folder barrel, and any `part` / `part of` line. Run `flutter analyze`; an unresolved import is an error, an unused one is a warning.

**Delete a file or feature.** Remove it from its barrel, its module's routes and binds, `AppRoute`, and any other module that imported it. Delete its tests. Then `flutter analyze` must report nothing.

**Change a Firestore field or collection.** Update the model, `FirestoreCollections`, `firestore.rules`, and the repository together.

## Tests

`test/` mirrors `lib/`: `test/src/modules/auth/domain/...` tests `lib/src/modules/auth/domain/...`. Use `mocktail` for mocks and `bloc_test` for blocs. The existing tests are the pattern:

| Layer | Example |
|---|---|
| validators, failures | `validators_test.dart`, `auth_failures_test.dart` |
| use case | `sign_in_with_email_and_password_use_case_test.dart` |
| bloc | `sign_in_bloc_test.dart`, `connection_shell_bloc_test.dart` |
| widget | `app_button_test.dart`, `auth_footer_test.dart` |

In widget tests build a minimal theme (`ThemeData(colorScheme: AppColorSchemes.light, extensions: const [AppColors.light])`). Do not use `AppTheme.light()`; it loads Google Fonts. After changing bundled assets delete `build/unit_test_assets`, because `flutter test` reuses it and can pass against files that are gone.

## Do not

- Add a dependency without a reason that `core` or a feature actually needs. Keep `pubspec.yaml` dependencies alphabetical.
- Catch an error to silence it. Return a `Failure` or let it propagate.
- Call a repository from a widget, or build a `Param` in a widget.
- Weaken the lints in `analysis_options.yaml` to make a change pass. Fix the code.
