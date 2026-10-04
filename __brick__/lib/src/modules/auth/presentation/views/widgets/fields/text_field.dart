import 'package:flutter/material.dart';
import '../../../../../../core/app.dart';
import '../../../../domain/validators/validators.dart';

class TextField extends StatefulWidget {
  final double radius;
  final String? hintText;
  final Icon? icon;

  const TextField({super.key, this.hintText, this.icon, this.radius = 8});

  TextValidator get validator {
    final state = _getState();
    return state._validator;
  }

  TextEditingController get controller {
    final state = _getState();
    return state._controller;
  }

  String get text {
    final state = _getState();
    return state._controller.text.trim();
  }

  TextFieldState _getState() {
    if (key is! GlobalKey<TextFieldState>) {
      throw StateError(
        'TextField getters require a GlobalKey<TextFieldState> as the widget key. '
        'Example: TextField(key: GlobalKey<TextFieldState>())',
      );
    }
    final state = (key as GlobalKey<TextFieldState>).currentState;
    if (state == null) {
      throw StateError(
        'TextField state is not available. Make sure the widget is mounted.',
      );
    }
    return state;
  }

  @override
  State<TextField> createState() => TextFieldState();
}

class TextFieldState extends State<TextField> {
  late final TextValidator _validator;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _validator = TextValidator();
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
      prefixIcon: widget.icon,
      controller: _controller,
      validator: _validator.call,
      kwargs: const {"autovalidateMode": AutovalidateMode.onUserInteraction},
    );
  }
}
