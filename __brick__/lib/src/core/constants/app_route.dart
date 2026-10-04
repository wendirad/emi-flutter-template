import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppRoute {
  static final AppRouteNode root = AppRouteNode('/');
  static final AppRouteNode app = AppRouteNode('/app');
  static final AppRouteNode splash = AppRouteNode('/splash');
  static final AppRouteNode notFound = AppRouteNode('/not-found');

  static final AppRouteNode auth = app.child('/auth');
  static final AppRouteNode signUp = auth.child('/sign-up');
  static final AppRouteNode signIn = auth.child('/sign-in');
  static final AppRouteNode resetPassword = auth.child('/reset-password');
  static final AppRouteNode confirmPasswordReset = auth.child(
    '/confirm-reset-password',
  );

  static final AppRouteNode appShell = app.child('/shell');
  static final AppRouteNode appShellInitial = appShell.child('/initial');

  static final AppRouteNode home = appShell.child('/home', title: 'Home');

  static final AppRouteNode settings = appShell.child('/settings', title: 'Settings');
  static final AppRouteNode about = settings.child('/about', title: 'About');
  static final AppRouteNode updateProfile = settings.child(
    '/update-profile',
    title: 'Edit Profile',
  );

  static AppRouteNode get current {
    final String currentPath = Modular.to.path;
    String normalize(String s) {
      final cleaned = s.split('?').first.split('#').first;
      return cleaned.length > 1
          ? cleaned.replaceAll(RegExp(r'/$'), '')
          : cleaned;
    }

    final String target = normalize(currentPath);

    AppRouteNode? search(AppRouteNode r) {
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

    return AppRouteNode(target);
  }
}

class AppRouteNode extends Equatable {
  final String _path;
  final String _parent;
  final String? _title;

  final List<AppRouteNode> _children = [];

  AppRouteNode(String path, {String parent = '', String? title = ''})
    : _parent = parent,
      _path = path,
      _title = title;

  AppRouteNode child(String path, {String? title}) {
    _children.add(AppRouteNode(path, parent: str, title: title));
    return _children.last;
  }

  bool isOrIsChildOf(AppRouteNode route) {
    if (route == this) return true;
    return isChildOf(route);
  }

  bool isChildOf(AppRouteNode route) {
    if (route.children.any((r) => r == this)) return true;
    for (final child in route.children) {
      if (isChildOf(child)) return true;
    }
    return false;
  }

  String get base => _path;
  String get str => _parent + _path;
  String? get title => _title;
  List<AppRouteNode> get children => _children;

  @override
  String toString() =>
      'AppRouteNode<base: $_path, str: $str, title: $title, children: ${_children.length}>';

  @override
  List<Object?> get props => [str.replaceAll(RegExp(r'/$'), '')];
}
