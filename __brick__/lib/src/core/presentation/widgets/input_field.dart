import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.autofillHints,
    this.inputFormatters,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    this.radius = 16,
    this.isPasswordField = false,
    this.onToggleObscure,
    this.validator,
    this.args,
    this.kwargs,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// For password fields, pass the current value here from the parent.
  final bool obscureText;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  final bool enabled;
  final bool readOnly;

  final int maxLines;
  final int? minLines;

  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  final EdgeInsetsGeometry contentPadding;
  final double radius;

  /// When true, shows a lock prefix and an eye/eye-off toggle.
  final bool isPasswordField;

  /// Called when the eye icon is tapped. Parent should flip [obscureText].
  final VoidCallback? onToggleObscure;
  final Function(String? value)? validator;

  final List<dynamic>? args;
  final Map<String, dynamic>? kwargs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fill = theme.colorScheme.secondaryContainer;

    final effectivePrefix = isPasswordField
        ? Icon(Icons.lock, color: theme.colorScheme.secondary)
        : prefixIcon;

    final effectiveSuffix = isPasswordField
        ? IconButton(
            onPressed: onToggleObscure,
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          )
        : suffixIcon;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide.none,
    );

    final params = {
      'controller': controller,
      'focusNode': focusNode,
      'keyboardType': keyboardType,
      'textInputAction': textInputAction,
      'obscureText': isPasswordField ? obscureText : false,
      'onChanged': onChanged,
      'onTap': onTap,
      'enabled': enabled,
      'readOnly': readOnly,
      'maxLines': isPasswordField ? 1 : maxLines,
      'minLines': minLines,
      'autofillHints': autofillHints,
      'inputFormatters': inputFormatters,
      'style': theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSecondaryContainer,
      ),
      'decoration': InputDecoration(
        filled: true,
        fillColor: fill,
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: effectivePrefix,
        suffixIcon: effectiveSuffix,
        contentPadding: contentPadding,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
      ),
      'validator': validator?.call,
      ...?kwargs,
    };

    final symbolMap = {for (var e in params.entries) Symbol(e.key): e.value};

    return Function.apply(TextFormField.new, [], symbolMap);
  }
}
