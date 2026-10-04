import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../extensions/build_context_extensions.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPress;
  final String? title;
  final Widget? child;

  const AppButton({super.key, required this.onPress, this.title, this.child});

  @override
  Widget build(BuildContext context) {
    final bool hasPreviousRoute = Modular.to.navigateHistory.length > 1;
    return hasPreviousRoute
        ? ElevatedButton(
            onPressed: () async => onPress(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: context.cs.primary,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: child ?? Text(title!),
          )
        : SizedBox.shrink();
  }
}
