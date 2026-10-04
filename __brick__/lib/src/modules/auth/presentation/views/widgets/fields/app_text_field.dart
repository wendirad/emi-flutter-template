import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/widgets.dart';
import '../../../../domain/validators/validators.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final double radius;
  final String? hintText;
  final Icon? icon;

  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.icon,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return InputField(
      radius: radius,
      hintText: hintText,
      prefixIcon: icon,
      controller: controller,
      validator: TextValidator().call,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
