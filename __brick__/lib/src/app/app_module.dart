import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../core/constants/constants.dart';
import '../core/theme/theme.dart';
import '../modules/auth/auth.dart';
import 'views/app_shell/app_shell_view.dart';
import 'views/connection_shell/connection_shell_view.dart';
import 'views/home/home_view.dart';
import 'views/splash/splash_view.dart';
import '../core/presentation/errors/errors.dart';
import '../modules/settings/settings_module.dart';

class AppModule extends Module {
  AppModule() : super() {
    Modular.setInitialRoute(AppRoute.home.str);
  }

  List<ModularRoute> get _routes => [
    ChildRoute(AppRoute.splash.str, child: (_) => SplashView()),
    ChildRoute(
      AppRoute.app.base,
      child: (_) => ConnectionShellView(),
      children: [
        ChildRoute(
          AppRoute.appShell.base,
          child: (_) => AppShellView(),
          guards: [AuthGuard()],
          children: [
            ChildRoute(AppRoute.home.base, child: (_) => HomeView()),
            ModuleRoute(AppRoute.settings.base, module: SettingsModule()),
          ],
        ),
        ModuleRoute(AppRoute.auth.base, module: AuthModule()),
      ],
    ),

    WildcardRoute(child: (_) => ErrorView(errorType: ErrorTypes.pageNotFound)),
  ];

  @override
  void binds(i) {
    i.addSingleton(ThemeService.new);
    i.addLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.addLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    i.addLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  }

  @override
  List<Module> get imports => [AuthModule(), ...super.imports];

  @override
  void routes(r) {
    for (ModularRoute route in _routes) {
      r.add(route);
    }
  }
}
