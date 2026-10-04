import 'package:flutter/material.dart';
import '../../../../../../core/app.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [AppBackButton(), Spacer(), ThemeToggleButton()],
    );
  }
}
