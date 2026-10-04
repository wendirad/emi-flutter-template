import 'package:flutter/material.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/presentation/widgets/widgets.dart';
import '../../../../domain/validators/email_validator.dart';

class EmailField extends StatefulWidget {
  final double radius;
  final String hintText;

  const EmailField({super.key, this.radius = 8, this.hintText = 'Email'});

  EmailValidator get validator {
    final state = _getState();
    return state._validator;
  }

  TextEditingController get controller {
    final state = _getState();
    return state._controller;
  }

  String get email {
    final state = _getState();
    return state._controller.text.trim();
  }

  EmailFieldState _getState() {
    if (key is! GlobalKey<EmailFieldState>) {
      throw StateError(
        'EmailField getters require a GlobalKey<EmailFieldState> as the widget key. '
        'Example: EmailField(key: GlobalKey<EmailFieldState>())',
      );
    }
    final state = (key as GlobalKey<EmailFieldState>).currentState;
    if (state == null) {
      throw StateError(
        'EmailField state is not available. Make sure the widget is mounted.',
      );
    }
    return state;
  }

  @override
  State<EmailField> createState() => EmailFieldState();
}

class EmailFieldState extends State<EmailField> {
  late final EmailValidator _validator;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _validator = EmailValidator();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputField(
      radius: widget.radius,
      hintText: widget.hintText,
      prefixIcon: Icon(Icons.email, color: context.cs.secondary),
      controller: _controller,
      validator: _validator.call,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
