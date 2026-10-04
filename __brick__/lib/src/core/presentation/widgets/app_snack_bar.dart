import 'package:flutter/material.dart';
import '../../extensions/build_context_extensions.dart';

/// Floating snack bars with one look across the app.
class AppSnackBar {
  const AppSnackBar._();

  static void success(BuildContext context, String message) =>
      _show(context, message, Colors.green);

  static void error(BuildContext context, String message) =>
      _show(context, message, context.cs.error);

  static void info(BuildContext context, String message) =>
      _show(context, message, null);

  static void _show(BuildContext context, String message, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
