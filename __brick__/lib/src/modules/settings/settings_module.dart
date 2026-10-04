import 'package:flutter_modular/flutter_modular.dart';

import '../../core/constants/constants.dart';
import 'presentation/views/views.dart';

class SettingsModule extends Module {
  final List<ModularRoute> _routes = [
    ChildRoute(AppRoute.root.base, child: (_) => SettingsView()),
    ChildRoute(AppRoute.about.base, child: (_) => AboutView()),
  ];

  @override
  void routes(RouteManager r) {
    super.routes(r);
    for (final ModularRoute route in _routes) {
      r.add(route);
    }
  }
}
