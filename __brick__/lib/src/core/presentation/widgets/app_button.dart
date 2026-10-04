import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../extensions/build_context_extensions.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPress;
  final String? title;
  final Widget? child;

  /// Shows a spinner in place of the label and ignores taps.
  final bool isLoading;

  const AppButton({
    super.key,
    required this.onPress,
    this.title,
    this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPreviousRoute = Modular.to.navigateHistory.length > 1;
    return hasPreviousRoute
        ? ElevatedButton(
            onPressed: isLoading ? null : () async => onPress(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: context.cs.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: context.cs.primary,
              disabledForegroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : child ?? Text(title!),
          )
        : SizedBox.shrink();
  }
}
