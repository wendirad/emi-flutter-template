import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/widgets.dart';
import '../../../../domain/validators/validators.dart';

class PasswordField extends StatefulWidget {
  final double radius;
  final String hintText;
  final bool isConfirmPassword;
  final bool showPassword;

  /// When false only checks that a value is present (e.g. sign-in).
  final bool enforceStrength;
  final VoidCallback? onShowPasswordToggle;
  final GlobalKey<PasswordFieldState>? passwordKey;

  PasswordField({
    super.key,
    this.radius = 8,
    this.hintText = 'Password',
    this.isConfirmPassword = false,
    this.showPassword = false,
    this.enforceStrength = true,
    this.onShowPasswordToggle,
    this.passwordKey,
  }) {
    if (isConfirmPassword && passwordKey == null) {
      throw StateError("Confirm Password must have 'passwordKey' parameter");
    }
  }

  List<dynamic> get validator {
    final state = _getState();
    return state._getValidators();
  }

  TextEditingController get controller {
    final state = _getState();
    return state._controller;
  }

  String get password {
    final state = _getState();
    return state._controller.text.trim();
  }

  PasswordFieldState _getState() {
    if (key is! GlobalKey<PasswordFieldState>) {
      throw StateError(
        'PasswordField getters require a GlobalKey<PasswordFieldState> as the widget key. '
        'Example: PasswordField(key: GlobalKey<PasswordFieldState>())',
      );
    }
    final state = (key as GlobalKey<PasswordFieldState>).currentState;
    if (state == null) {
      throw StateError(
        'PasswordField state is not available. Make sure the widget is mounted.',
      );
    }
    return state;
  }

  @override
  State<PasswordField> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  late final PasswordValidator _passwordValidator;
  late final ConfirmPasswordValidator? _confirmPasswordValidator;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _passwordValidator = PasswordValidator();
    _controller = TextEditingController();
    if (widget.isConfirmPassword) {
      _confirmPasswordValidator = ConfirmPasswordValidator();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<dynamic> _getValidators() {
    return [_passwordValidator, _confirmPasswordValidator];
  }

  @override
  Widget build(BuildContext context) {
    return InputField(
      hintText: widget.hintText,
      radius: widget.radius,
      isPasswordField: true,
      obscureText: !widget.showPassword,
      onToggleObscure: widget.onShowPasswordToggle,
      controller: _controller,
      validator: (currentPassword) => widget.isConfirmPassword
          ? _confirmPasswordValidator!.call(
              currentPassword,
              widget.passwordKey!.currentState!.widget.password,
            )
          : widget.enforceStrength
          ? _passwordValidator.call(currentPassword)
          : _passwordValidator.presence(currentPassword),
      kwargs: const {"autovalidateMode": AutovalidateMode.onUserInteraction},
    );
  }
}
