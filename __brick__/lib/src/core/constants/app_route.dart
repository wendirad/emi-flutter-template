import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppRoute {
  static final Route root = Route('/');
  static final Route app = Route('/app');
  static final Route splash = Route('/splash');
  static final Route notFound = Route('/not-found');

  static final Route auth = app.child('/auth');
  static final Route signUp = auth.child('/sign-up');
  static final Route signIn = auth.child('/sign-in');
  static final Route resetPassword = auth.child('/reset-password');
  static final Route confirmPasswordReset = auth.child(
    '/confirm-reset-password',
  );

  static final Route appShell = app.child('/shell');
  static final Route appShellInitial = appShell.child('/initial');

  static final Route home = appShell.child('/home', title: 'Home');

  static final Route settings = appShell.child('/settings', title: 'Settings');
  static final Route about = settings.child('/about', title: 'About');
  static final Route updateProfile = settings.child(
    '/update-profile',
    title: 'Edit Profile',
  );

  static Route get current {
    final String currentPath = Modular.to.path;
    String normalize(String s) {
      final cleaned = s.split('?').first.split('#').first;
      return cleaned.length > 1
          ? cleaned.replaceAll(RegExp(r'/$'), '')
          : cleaned;
    }

    final String target = normalize(currentPath);

    Route? search(Route r) {
      if (normalize(r.str) == target) return r;
      for (final c in r.children) {
        final found = search(c);
        if (found != null) return found;
      }
      return null;
    }

    // start from top-level roots
    final roots = [root, app, splash, notFound];
    for (final r in roots) {
      final match = search(r);
      if (match != null) return match;
    }

    return Route(target);
  }
}

class Route extends Equatable {
  final String _path;
  final String _parent;
  final String? _title;

  final List<Route> _childs = [];

  Route(String path, {String parent = '', String? title = ''})
    : _parent = parent,
      _path = path,
      _title = title;

  Route child(String path, {String? title}) {
    _childs.add(Route(path, parent: str, title: title));
    return _childs.last;
  }

  bool isOrIsChildOf(Route route) {
    if (route == this) return true;
    return isChildOf(route);
  }

  bool isChildOf(Route route) {
    if (route.children.any((r) => r == this)) return true;
    for (final child in route.children) {
      if (isChildOf(child)) return true;
    }
    return false;
  }

  String get base => _path;
  String get str => _parent + _path;
  String? get title => _title;
  List<Route> get children => _childs;

  @override
  String toString() =>
      'Route<base: $_path, str: $str, title: $title, children: ${_childs.length}>';

  @override
  List<Object?> get props => [str.replaceAll(RegExp(r'/$'), '')];
}
