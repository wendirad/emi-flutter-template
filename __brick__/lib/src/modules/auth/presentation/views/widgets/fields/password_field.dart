import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/widgets.dart';
import '../../../../domain/validators/validators.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final double radius;
  final String hintText;
  final bool showPassword;

  /// When false only checks that a value is present (e.g. sign-in).
  final bool enforceStrength;

  /// When set, this field is a confirmation and must equal this controller's
  /// text.
  final TextEditingController? confirms;

  final VoidCallback? onShowPasswordToggle;

  const PasswordField({
    super.key,
    required this.controller,
    this.radius = 8,
    this.hintText = 'Password',
    this.showPassword = false,
    this.enforceStrength = true,
    this.confirms,
    this.onShowPasswordToggle,
  });

  String? _validate(String? value) {
    final TextEditingController? original = confirms;
    if (original != null) {
      return ConfirmPasswordValidator().call(value, original.text.trim());
    }

    final PasswordValidator validator = PasswordValidator();
    return enforceStrength ? validator(value) : validator.presence(value);
  }

  @override
  Widget build(BuildContext context) {
    return InputField(
      hintText: hintText,
      radius: radius,
      isPasswordField: true,
      obscureText: !showPassword,
      onToggleObscure: onShowPasswordToggle,
      controller: controller,
      validator: _validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
