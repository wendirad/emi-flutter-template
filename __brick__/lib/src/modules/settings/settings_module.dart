import 'package:flutter_modular/flutter_modular.dart';
import '../../core/app.dart';
import '../auth/presentation/views/views.dart';
import 'presentation/views/views.dart';

class SettingsModule extends Module {
  final List<ModularRoute> _routes = [
    ChildRoute(AppRoute.root.base, child: (_) => SettingsView()),
    ChildRoute(AppRoute.about.base, child: (_) => AboutView()),
    ChildRoute(AppRoute.updateProfile.base, child: (_) => UpdateProfileView()),
  ];

  @override
  void routes(RouteManager r) {
    super.routes(r);
    for (ModularRoute route in _routes) {
      r.add(route);
    }
  }
}
