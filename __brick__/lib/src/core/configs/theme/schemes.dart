import 'package:flutter/material.dart';
import 'palette.dart';

class AppColorSchemes {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppPalette.brand,
    onPrimary: Colors.white,
    primaryContainer: AppPalette.lightDeep,
    onPrimaryContainer: AppPalette.darkSurfaceDeepest,

    secondary: AppPalette.brandDeep,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE0C9FF),
    onSecondaryContainer: AppPalette.darkSurfaceDeepest,

    tertiary: AppPalette.brandSoft,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFEAD9FF),
    onTertiaryContainer: AppPalette.darkSurfaceDeepest,

    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    surface: Colors.white,
    onSurface: AppPalette.darkSurfaceDeepest,
    surfaceContainerHighest: Color(0xFFF9F6FF),
    surfaceContainerHigh: Color(0xFFF3EEFF),
    surfaceContainer: AppPalette.lightSoft,
    surfaceContainerLow: Color(0xFFF3EEFF),
    surfaceContainerLowest: Colors.white,
    surfaceBright: Colors.white,
    surfaceDim: Color(0xFFEFEAF7),

    outline: AppPalette.lightTone,
    outlineVariant: Color(0xFFE0C9FF),

    inverseSurface: AppPalette.darkSurfaceDeepest,
    onInverseSurface: AppPalette.lightCloud,
    inversePrimary: AppPalette.brandDeep,

    shadow: Colors.black,
    scrim: Colors.black,

    surfaceTint: AppPalette.brand,
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.brandLight,
    onPrimary: AppPalette.darkSurfaceDeepest,
    primaryContainer: AppPalette.brandMuted,
    onPrimaryContainer: AppPalette.lightCloud,

    secondary: AppPalette.brandMuted,
    onSecondary: AppPalette.lightCloud,
    secondaryContainer: AppPalette.darkSurface,
    onSecondaryContainer: AppPalette.lightCloud,

    tertiary: AppPalette.lightTone,
    onTertiary: AppPalette.darkSurfaceDeepest,
    tertiaryContainer: AppPalette.darkSurface,
    onTertiaryContainer: AppPalette.lightCloud,

    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    surface: AppPalette.darkSurfaceDeep,
    onSurface: AppPalette.lightCloud,
    surfaceContainerHighest: AppPalette.darkSurface,
    surfaceContainerHigh: Color(0xFF241C38),
    surfaceContainer: AppPalette.darkSurfaceDeep,
    surfaceContainerLow: AppPalette.darkSurfaceDeepest,
    surfaceContainerLowest: AppPalette.darkSurfaceDeepest,
    surfaceBright: AppPalette.darkSurfaceDeep,
    surfaceDim: AppPalette.darkSurfaceDeepest,

    outline: AppPalette.darkOutline,
    outlineVariant: Color(0xFF433569),

    inverseSurface: AppPalette.lightCloud,
    onInverseSurface: AppPalette.darkSurfaceDeepest,
    inversePrimary: AppPalette.brand,

    shadow: Colors.black,
    scrim: Colors.black,

    surfaceTint: AppPalette.brandLight,
  );
}
