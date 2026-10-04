import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Future.value(Modular.to.canPop()),
      builder: (context, snapshot) {
        final canPop = snapshot.data ?? false;
        if (!canPop) {
          return const SizedBox.shrink();
        }
        return IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: Colors.black.withValues(alpha: .18),
          ),
          onPressed: () async => await Modular.to.maybePop(),
        );
      },
    );
  }
}
