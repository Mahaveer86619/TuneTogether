import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tunetogether/core/theme/pallete.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    //* BACKGROUND and SURFACE
    surface: Pallete.lightSurface,
    onSurface: Pallete.lightOnSurface,

    //* PRIMARY
    primary: Pallete.lightPrimary,
    onPrimary: Pallete.lightOnPrimary,
    primaryContainer: Pallete.lightCard,
    onPrimaryContainer: Pallete.lightOnSurface,

    //* SECONDARY
    secondary: Pallete.lightSecondary,
    onSecondary: Pallete.lightSecondary,
    secondaryContainer: Pallete.lightPrimary.withAlpha(70),
    onSecondaryContainer: Pallete.lightOnSurface,

    //* TERTIARY
    tertiary: Pallete.lightTertiary,
    onTertiary: Pallete.lightOnTertiary,
    tertiaryContainer: Pallete.lightTertiary.withAlpha(70),
    onTertiaryContainer: Pallete.lightOnSurface,

    //* ERROR
    error: Pallete.lightError,
    onError: Pallete.lightOnError,
    errorContainer: Pallete.lightError.withAlpha(70), // 30% opacity
    onErrorContainer: Pallete.lightOnError,
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.nunitoSansTextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    enableFeedback: false,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedItemColor: Pallete.lightOnSurface,
    unselectedItemColor: Pallete.greyColor,
    selectedIconTheme: IconThemeData(color: Pallete.lightOnSurface),
    unselectedIconTheme: IconThemeData(color: Pallete.greyColor),
    selectedLabelStyle: TextStyle(color: Pallete.lightOnSurface),
    unselectedLabelStyle: TextStyle(color: Pallete.greyColor),
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    //* BACKGROUND and SURFACE
    surface: Pallete.darkSurface,
    onSurface: Pallete.darkOnSurface,

    //* PRIMARY
    primary: Pallete.darkPrimary,
    onPrimary: Pallete.darkOnPrimary,
    primaryContainer: Pallete.darkCard,
    onPrimaryContainer: Pallete.darkOnSurface,

    //* SECONDARY
    secondary: Pallete.darkSecondary,
    onSecondary: Pallete.darkOnSecondary,
    secondaryContainer: Pallete.darkPrimary.withAlpha(70),
    onSecondaryContainer: Pallete.darkOnSurface,

    //* TERTIARY
    tertiary: Pallete.darkTertiary,
    onTertiary: Pallete.darkOnTertiary,
    tertiaryContainer: Pallete.darkTertiary.withAlpha(70),
    onTertiaryContainer: Pallete.darkOnTertiary,

    //* ERROR
    error: Pallete.darkError,
    onError: Pallete.darkOnError,
    errorContainer: Pallete.darkError.withAlpha(70),
    onErrorContainer: Pallete.darkOnError,
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.nunitoSansTextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.shifting,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedItemColor: Pallete.darkOnSurface,
    unselectedItemColor: Pallete.greyColor,
    selectedIconTheme: IconThemeData(color: Pallete.darkOnSurface),
    unselectedIconTheme: IconThemeData(color: Pallete.greyColor),
    selectedLabelStyle: TextStyle(color: Pallete.darkOnSurface),
    unselectedLabelStyle: TextStyle(color: Pallete.greyColor),
  ),
);
