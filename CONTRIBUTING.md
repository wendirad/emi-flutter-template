# Maintaining the brick

This repository is a Mason brick. The app code lives in `__brick__/` and is copied into every generated project, so a change here reaches all of them. [`__brick__/AGENTS.md`](__brick__/AGENTS.md) holds the conventions for the generated code; follow it here too.

## Verify a change

Generate a project from your working copy and check that one:

```sh
mason make flutter_template --on-conflict overwrite -o /tmp/brick_check --project_name demo_app \
  --description "A demo app" --org_name com.example \
  --use_firebase true --use_camera true --use_photo_library true
cd /tmp/brick_check/demo_app
flutter analyze
flutter test
```

Both must pass. `__brick__/` itself is not a buildable Flutter project, because `pubspec.yaml`, tests and a few strings contain placeholders.

## Placeholders

Mason fills these when it renders a file, so keep them intact:

| Placeholder | Where |
|---|---|
| `{{project_name.snakeCase()}}` | `pubspec.yaml` name, `package:` imports in `test/` |
| `{{project_name.titleCase()}}` | the app title in `app_widget.dart` and `about_view.dart` |
| `{{{description}}}` | the About description (raw string, so quotes in the text are safe) |
| `{{org_name...}}` | Android and iOS identifiers |

Do not write a literal `{{` in new files; Mason will try to render it.

## Notes

- Add new Dart files in the layout `AGENTS.md` describes, with their tests.
- Bundled binary assets (images, fonts) are copied unchanged. Keep font licenses next to the fonts.
- `hooks/post_gen.dart` runs after generation: it removes Firebase files when `use_firebase` is false, creates an empty `.env`, and runs `flutter pub get`. Keep it in step with `brick.yaml`.
- `dart format` from a newer SDK can reformat a whole file differently from how it is committed. Format only files you create or substantially change.
