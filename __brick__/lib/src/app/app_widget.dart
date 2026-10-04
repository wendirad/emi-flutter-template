import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/theme/theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Modular.get<ThemeService>();

    return ListenableBuilder(
      listenable: themeService,
      builder: (context, _) {
        return MaterialApp.router(
          locale: Locale('en'),
          title: 'Demo App',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeService.mode,
          routerConfig: Modular.routerConfig,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
