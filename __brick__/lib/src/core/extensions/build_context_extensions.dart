import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

extension ThemeBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  Brightness get brightness => theme.brightness;
  ColorScheme get cs => theme.colorScheme;
  TextTheme get tt => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;
  AppColors get appColors =>
      theme.extension<AppColors>() ??
      (isDark ? AppColors.dark : AppColors.light);
}
