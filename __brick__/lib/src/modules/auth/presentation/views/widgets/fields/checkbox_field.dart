import 'package:flutter/material.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';

class CheckboxField extends StatefulWidget {
  final VoidCallback? onCheckboxToggle;
  final bool isChecked;
  final Widget? suffix;

  const CheckboxField({
    super.key,
    this.onCheckboxToggle,
    this.isChecked = false,
    this.suffix,
  });

  @override
  State<CheckboxField> createState() => CheckboxFieldState();
}

class CheckboxFieldState extends State<CheckboxField> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  void toggle() {
    setState(() {
      _isChecked = !_isChecked;
    });
    widget.onCheckboxToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: Row(
        spacing: 4,
        children: [
          Icon(
            _isChecked ? Icons.check_circle_outline : Icons.circle_outlined,
            color: context.cs.outline,
            size: 20,
          ),
          ?widget.suffix,
        ],
      ),
    );
  }
}
