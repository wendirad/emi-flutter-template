import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../app.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Modular.get<ThemeService>().load(),
      builder: (context, _) => AnimatedBuilder(
        animation: Modular.get<ThemeService>(),
        builder: (context, _) {
          return MaterialApp.router(
            locale: Locale('en'),
            title: '{{project_name.titleCase()}}',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: Modular.get<ThemeService>().mode,
            routerConfig: Modular.routerConfig,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
