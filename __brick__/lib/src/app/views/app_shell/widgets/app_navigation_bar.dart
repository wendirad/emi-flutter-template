import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/extensions/build_context_extensions.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({super.key});

  @override
  State<StatefulWidget> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _indexForCurrentRoute() ?? _selectedIndex;
    Modular.to.addListener(_syncSelectedIndex);
  }

  @override
  void dispose() {
    Modular.to.removeListener(_syncSelectedIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.primaryContainer.withAlpha(150),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: context.cs.shadow.withAlpha(25)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: context.cs.outlineVariant,
            hoverColor: context.cs.outlineVariant,
            gap: 8,
            activeColor: context.cs.inversePrimary,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: (context.isDark
                ? context.cs.inverseSurface
                : context.cs.surface)
                .withAlpha(200),
            color: context.cs.inversePrimary,
            tabs: [
              GButton(icon: Icons.home_outlined, text: 'Home'),
              GButton(icon: Icons.settings_outlined, text: 'Settings'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _navigate,
          ),
        ),
      ),
    );
  }

  void _navigate(int index) {
    if (index == _selectedIndex) return;
    if (mounted) setState(() => _selectedIndex = index);

    Modular.to.navigate(switch (index) {
      0 => AppRoute.home.str,
      1 => AppRoute.settings.str,
      _ => AppRoute.notFound.str,
    });
  }

  int? _indexForCurrentRoute() {
    final current = AppRoute.current;
    if (current.isOrIsChildOf(AppRoute.home)) return 0;
    if (current.isOrIsChildOf(AppRoute.settings) ||
        current.isOrIsChildOf(AppRoute.profile)) {
      return 1;
    }
    return null;
  }

  void _syncSelectedIndex() {
    final int? index = _indexForCurrentRoute();
    if (mounted && index != null && index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
  }
}
