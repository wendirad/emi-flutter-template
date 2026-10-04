import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app.dart';

class Motto extends StatelessWidget {
  const Motto({super.key});

  @override
  Widget build(BuildContext context) {
    final emphasis = context.isDark
        ? context.cs.primary.withValues(alpha: 0.6)
        : context.cs.primary;

    final baseStyle = GoogleFonts.inter(
      textStyle: context.tt.headlineLarge?.copyWith(
        color: context.cs.onSurface,
        height: 1.1,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
    );

    return RichText(
      textAlign: TextAlign.center,
      maxLines: 2,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: 'Always ', style: baseStyle.copyWith(fontSize: 25)),
          TextSpan(
            text: 'On',
            style: baseStyle.copyWith(color: emphasis, fontSize: 35),
          ),
          TextSpan(text: '.\nAlways ', style: baseStyle.copyWith(fontSize: 25)),
          TextSpan(
            text: 'Professional',
            style: baseStyle.copyWith(color: emphasis, fontSize: 35),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
