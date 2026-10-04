import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final useFirebase = context.vars['use_firebase'] as bool? ?? true;

  if (!useFirebase) {
    for (final path in [
      'firestore.rules',
      'firestore.indexes.json',
      'storage.rules',
      'lib/firebase_options.dart',
    ]) {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    }
    context.logger.warn(
      'Firebase files removed. Auth still imports Firebase packages: '
      'replace or remove them before building.',
    );
  }

  final env = File('.env');
  if (!env.existsSync()) env.writeAsStringSync('');

  final progress = context.logger.progress('Running flutter pub get');
  final result = await Process.run('flutter', ['pub', 'get']);
  if (result.exitCode == 0) {
    progress.complete('Dependencies installed');
  } else {
    progress.fail('flutter pub get failed: ${result.stderr}');
  }
}
