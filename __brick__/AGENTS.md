# Agent guide

Read this before changing anything. Open only the files the task needs; do not scan `lib/`. Read project state through `tool/status.sh`, never by opening `STATUS.md`.

## Workflow

1. Find your task with `bash tool/status.sh open <area>`, or add it with `status.sh add`. Mark it `doing`.
2. Change only what the task asks. Do not touch unrelated files, reformat untouched code, or add a dependency the task does not need.
3. Run `bash tool/check.sh`. It must pass before you call the task done.
4. Mark the task `done` and update the feature state if it changed (see Status), then commit one category per commit as `type(scope): summary` in lowercase imperative, e.g. `feat(auth): add sign-in cubit`. Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`. Scope is the feature or layer (`auth`, `profile`, `core`, `l10n`, `theme`); omit it only for repo-wide changes.

## Status

`STATUS.md` grows, so read and edit single lines only. Each feature (`F-<name>`) and task (`T<nnn>`) is one line with a stable ID; subtasks are `T<nnn>.<n>` lines under their task. Never open, rewrite or reorder the whole file.

| Need | Command |
|---|---|
| Open tasks, optionally for one area | `bash tool/status.sh open [area]` |
| One task with its subtasks, or one feature | `bash tool/status.sh show T012` / `show F-auth` |
| Feature table | `bash tool/status.sh features` |
| New task or subtask | `bash tool/status.sh add <area> "<title>" [parent-ID]` |
| Change a task (`todo`, `doing`, `done`, `blocked`) | `bash tool/status.sh set T012 doing` |
| Change a feature's state | `bash tool/status.sh feature F-home done` |
| Move finished tasks out of `STATUS.md` | `bash tool/status.sh archive` |

Before a multi-step task, add its steps as subtasks, and `set` each one as it lands. `docs/status/archive.md` holds finished work; search it with `grep`, do not read it.

## Environment

Dart `^3.9.2` and the stable Flutter channel (see `pubspec.yaml`). Keep `pubspec.yaml` dependencies alphabetical. Never edit `*.g.dart` or `lib/src/core/l10n/generated/`.

## Commands

`bash tool/check.sh` runs the whole sequence in this order and stops at the first failure: `flutter gen-l10n` (when `.arb` files changed), `build_runner` (when a `@JsonSerializable` model changed), `dart fix --apply` (sorts imports and fixes lints), `dart format` on changed files, `flutter analyze`, `flutter test`.

A Claude Code hook (`.claude/settings.json`) already runs `dart fix` and `dart format` on each edited Dart file, `gen-l10n` on each edited `.arb`, and `build_runner` on each edited model with a `.g.dart` part, so generated files exist before analysis. Without the hook, run `flutter gen-l10n` or `dart run build_runner build --delete-conflicting-outputs` right after such an edit. Do not sort or format by hand. Do not weaken `analysis_options.yaml` to pass; fix the code.

## Layout and boundaries

```
lib/main.dart            boot
lib/src/app/             composition root, shell screens
lib/src/core/            feature-agnostic code
lib/src/modules/<name>/  one folder per feature (auth is the reference, profile the smallest)
test/src/...             mirrors lib/src/...
```

| Layer | May import | Must not import |
|---|---|---|
| `core` | `core` | `modules`, `app` |
| `modules/<a>` | `core`, `modules/<b>/<b>.dart` | another feature's internals, `app` |
| `app` | everything | |
| `domain/` | `core` (pure Dart) | Flutter, `data`, `presentation` |
| `data/` | `domain`, `core` | `presentation` |
| `presentation/` | `domain`, `core` | `data` |

Feature layout: `<name>.dart` (public barrel), `<name>_module.dart` (routes and binds), `domain/{entities,failures,repositories,use_cases,validators}`, `data/{models,repositories,extensions}`, `presentation/{blocs,cubits,views,extensions,guards}`.

## Imports and files

- Relative imports inside the package. Import a `core` sub-package through its barrel (`constants/`, `presentation/widgets/`, `theme/`, `presentation/errors/`, `utils/`, `l10n/`) from outside it. Files inside a folder import siblings directly (`import 'foo.dart'`), never their own folder's barrel or a parent barrel.
- Every new public file is exported from its folder's barrel and removed from it when deleted. Do not leave a barrel entry or an empty folder behind.
- One public class per file, named `snake_case` after the class. Exceptions: a use case with its `*Param`, bloc `part` files, grouped `*_entities.dart`, `*_models.dart`, `*_failures.dart`.
- Never name a class `Route`, `TextField`, `FormField` or anything else that shadows Flutter. Custom widgets are `AppX` or named for their feature.
- Move or rename with `git mv`, then fix every import, export and `part` line.

## State

| Need | Use | Public API |
|---|---|---|
| Run one use case on demand | `ProcessCubit<F>` | `submit(...)` |
| Load one value | `LoadCubit<T, F>` | `load()` |
| Streams, several events, timers | `Bloc` | events |

- Cubits live in `presentation/cubits/<name>/<name>_cubit.dart`, blocs in `presentation/blocs/<name>/` (`<name>_bloc.dart` + `<name>_event.dart`). Name them `<Verb><Noun>Cubit` / `Bloc`.
- Expose the state with a typedef: `typedef SignInState = ProcessState<SignInWithEmailAndPasswordFailure>;`. `ProcessState` has `idle`, `inProgress`, `success`, `failure(F)`; `LoadState` adds `data`.
- The constructor takes use cases as named required parameters. A cubit or bloc never touches a repository or Firebase.
- Local `State` holds only pure UI state (text controllers, an obscure toggle). No events or cubit methods for it.
- In widgets use `ReadContext(context).read<T>()` and `WatchContext(context).watch<T>()`; plain `context.read` is ambiguous with `flutter_modular`. Await `submit()` in async callbacks (`unawaited_futures` is on).
- Provide the cubit with `BlocProvider(create: ...)` in the view; `Modular.get` is allowed only in module binds, route builders, `create:` callbacks and guards.

## Errors and data

- Repositories and use cases return `Either<Failure, T>` (`fpdart`) and never throw to the caller. Only a repository touches Firebase, `SharedPreferences` or the network (`ThemeService` and `LocaleService` are the exceptions).
- A failure has a `const` constructor and `fromCode(String?)`, resolved through its own message table, then `failureMessageFor`'s shared table in `core/failures`. `Failure.message` is English for logs and tests; never show it.
- Validators return a `ValidationError`, not text.
- Never persist a password. Remember-me stores the email only.
- Changing a Firestore field or collection updates the model, `FirestoreCollections`, `firestore.rules` and the repository together. The same goes for `StoragePaths` and `storage.rules`. After editing a `.rules` file run `npm ci && npm test` in `rules_test/` (needs Node and Java 21); add a test for each rule you change.

## Strings, keys and constants

No inline keys or user-facing text.

| Kind | Where |
|---|---|
| `.env` key | `EnvKeys` (also the README table) |
| `SharedPreferences` key | `PrefKeys` (do not change a value without a migration) |
| Firestore collection / Storage path | `FirestoreCollections` / `StoragePaths` |
| Asset path | `Illustrations` |
| Route | `AppRoute`, plus the owning module's `routes` |
| User-facing text | `lib/src/core/l10n/arb/app_en.arb` and `app_am.arb`, read with `context.l10n.<key>` |
| Failure text | `<feature>/presentation/extensions/*_failure_message.dart`: `failure.localized(context.l10n)` |
| Validation text | `error.message(context.l10n)` |

Add a string to both `.arb` files (a `{placeholder}` and its `@key` entry go in `app_en.arb`), with a camelCase key that starts with its area (`signInTitle`, `failureNetwork`). Developer-facing text (exceptions, `debugPrint`) stays English and unlocalized. `.env` is bundled into the app: configuration only, never secrets.

## UI

- Take colors and text styles from the theme: `context.cs`, `context.tt`, `context.appColors`, `context.isDark`. No `Colors.*` except `Colors.transparent`, and no `Color(0x...)` outside `core/theme/`. A new raw color goes in `AppPalette`, a semantic one in `AppColors`.
- Reuse `core/presentation/widgets/`: `AppButton(isLoading:)`, `AppSnackBar.success/error/info`, `AppAlert`, `InputField`, `UserAvatar`, `AsyncPageLoader.loading()`, `ErrorView`. Auth-style screens use `AuthScaffold` and `AuthFooter`.
- Forms create their `TextEditingController`s in `initState`, dispose them, and read `controller.text`. No `GlobalKey` into widget state.
- Show a failure with `AppAlert` inside the form or `AppSnackBar.error` once; show loading with `AppButton(isLoading:)`.
- Fonts: Poppins is bundled in `google_fonts/` with runtime fetching off. A new weight needs its file there and a line in `test/src/core/theme/bundled_fonts_test.dart`.

## Tests

`test/` mirrors `lib/`. Use `mocktail` and `bloc_test`.

- Mock the use case or repository interface. For a custom `Param` matched with `any(named: 'param')`, add `class FakeXParam extends Fake implements XParam {}` and `setUpAll(() => registerFallbackValue(FakeXParam()))`.
- Stub with `thenAnswer((_) async => const Right(unit))` or `Left(XFailure.fromCode('x'))`. Assert states and results with `Right(...)` / `Left(...)`; failures compare by message and code.
- Cubit and bloc tests use `blocTest` and expect the full state sequence (`inProgress`, then `success` or `failure`). Capture the `Param` with `verify(...).captured` to check the cubit built it correctly.
- Widget tests build a minimal theme: `ThemeData(colorScheme: AppColorSchemes.light, extensions: const [AppColors.light])`. Never `AppTheme.light()` (it loads Google Fonts).
- After changing bundled assets delete `build/unit_test_assets`; `flutter test` caches it.
- Examples: `sign_in_cubit_test.dart`, `connection_shell_bloc_test.dart`, `cubits_test.dart`, `auth_failures_test.dart`, `validators_test.dart`, `app_button_test.dart`.

## Recipes

- **Use case:** `domain/use_cases/<name>_use_case.dart` implementing `UseCase<T, Param>` (or `NoParam`), exported from `use_cases.dart`; add the method to the repository interface and implementation; bind it in the module; add a use case test.
- **Screen:** a cubit (or bloc) under the State rules; `views/<screen>/<screen>_view.dart` exported from `views/views.dart`; the route in `AppRoute` and the module's `routes`; strings in both `.arb` files; a cubit test.
- **Failure:** the class and its English table in `domain/failures/`; the code's text in both `.arb` files and the feature's `*_failure_message.dart`; extend the failure and message tests.
- **Feature module:** copy `modules/profile`; add `<name>.dart` with only the public API; register `<Name>Module` in `app/app_module.dart` and its routes in `AppRoute`; add a row to `STATUS.md`.
- **Delete a feature or file:** remove it from its barrel, module routes and binds, `AppRoute`, other importers and tests; `flutter analyze` must report nothing.
- **Catch blocks:** never swallow an error. Return a `Failure` or let it propagate.
