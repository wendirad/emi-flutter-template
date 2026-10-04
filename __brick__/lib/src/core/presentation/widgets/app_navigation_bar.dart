import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../constants/app_route.dart';
import '../../extentions/build_context_extentions.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({super.key});

  @override
  State<StatefulWidget> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _selectedIndex = 0;
  _AppNavigationBarState() : super() {
    Modular.to.addListener(_handleBackButton);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.primaryContainer.withAlpha(150),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withAlpha(25)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[300]!,
            gap: 8,
            activeColor: context.cs.inversePrimary,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.white.withAlpha(200),
            color: context.cs.inversePrimary,
            tabs: [
              GButton(icon: Icons.home_outlined, text: 'Home'),
              GButton(icon: Icons.settings_outlined, text: 'Settings'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) => _navigate(index, context),
          ),
        ),
      ),
    );
  }

  void _navigate(int index, BuildContext context) async {
    if (index == _selectedIndex) return;
    if (mounted) setState(() => _selectedIndex = index);

    await Modular.to.pushNamed(switch (index) {
      0 => AppRoute.home.str,
      1 => AppRoute.settings.str,
      _ => AppRoute.notFound.str,
    });
  }

  void _handleBackButton() {
    if (mounted) {
      setState(() {
        if (AppRoute.current.isOrIsChildOf(AppRoute.home)) {
          _selectedIndex = 0;
        } else if (AppRoute.current.isOrIsChildOf(AppRoute.settings)) {
          _selectedIndex = 1;
        }
      });
    }
  }
}
