import 'package:flutter/material.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/presentation/widgets/widgets.dart';
import '../../../../domain/validators/email_validator.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final double radius;
  final String hintText;

  const EmailField({
    super.key,
    required this.controller,
    this.radius = 8,
    this.hintText = 'Email',
  });

  @override
  Widget build(BuildContext context) {
    return InputField(
      radius: radius,
      hintText: hintText,
      prefixIcon: Icon(Icons.email, color: context.cs.secondary),
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: EmailValidator().call,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
