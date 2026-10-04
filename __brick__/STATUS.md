# Status

The current state of the project. Agents read this first and update it last (see `AGENTS.md`).

## How to use this file

- **Start of a task:** find it under Backlog, or add it. Set it to `[~]` and put your name or session in parentheses. Keep one `[~]` task per agent.
- **Subtasks:** break a task into indented `- [ ]` lines before starting. Tick each as it lands.
- **End of a task:** set `[x]`, move the line under Done with a one-line outcome, and update the Features table if a feature changed state. Then commit.
- **Blocked or deferred:** set `[!]` and say why on the same line.
- Add new work to the end of Backlog. Do not reorder or delete other people's lines.
- States: `[ ]` todo, `[~]` in progress, `[x]` done, `[!]` blocked.

## Features

| Feature | State | Notes |
|---|---|---|
| App shell (splash, nav bar, connection banner, error views) | done | `lib/src/app`, `core/presentation/errors` |
| Auth: sign up, sign in, sign out, password reset, session guard, remembered email | done | `modules/auth`, Firebase Auth + Firestore |
| Profile: edit name and photo | done | `modules/profile` |
| Settings: theme, language, privacy and terms links, About | done | `modules/settings`, links come from `.env` |
| Theme: light, dark, system | done | `core/theme` |
| Localization: English, Amharic | done | Amharic text awaits native review |
| Home tab | placeholder | shows the word "Home" |
| Firestore and Storage rules | written, untested | `firestore.rules`, `storage.rules` |
| Screen tests | partial | `AppButton` and `AuthFooter` only |

## Backlog

- [ ] Native-speaker review of `app_am.arb`
- [ ] Test `firestore.rules` and `storage.rules` against the Firebase emulator
- [ ] Build the Home tab
- [ ] Widget tests for the sign-in, sign-up, settings and profile screens
- [ ] Repository tests for `AuthRepository` and `ProfileRepository` with fakes

## Done

- Localization with English and Amharic and a language picker
- `profile` module split out of auth and settings
- Single-use-case blocs replaced by `ProcessCubit` and `LoadCubit`
- Hard-coded colors replaced by theme tokens
