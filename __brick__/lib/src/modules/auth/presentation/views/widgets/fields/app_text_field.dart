import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/widgets.dart';
import '../../../../domain/validators/validators.dart';

class AppTextField extends StatefulWidget {
  final double radius;
  final String? hintText;
  final Icon? icon;

  const AppTextField({super.key, this.hintText, this.icon, this.radius = 8});

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

  AppTextFieldState _getState() {
    if (key is! GlobalKey<AppTextFieldState>) {
      throw StateError(
        'AppTextField getters require a GlobalKey<AppTextFieldState> as the widget key. '
        'Example: AppTextField(key: GlobalKey<AppTextFieldState>())',
      );
    }
    final state = (key as GlobalKey<AppTextFieldState>).currentState;
    if (state == null) {
      throw StateError(
        'AppTextField state is not available. Make sure the widget is mounted.',
      );
    }
    return state;
  }

  @override
  State<AppTextField> createState() => AppTextFieldState();
}

class AppTextFieldState extends State<AppTextField> {
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
