import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

extension ThemeUtils on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cardColor =>
      isDark ? AppTheme.darkCard : Colors.white;

  Color get borderColor =>
      isDark ? AppTheme.darkBorder : AppTheme.lightGrey;

  Color get primaryText =>
      isDark ? AppTheme.darkTextPrimary : AppTheme.textDark;

  Color get mutedText =>
      isDark ? AppTheme.darkTextMuted : AppTheme.textMuted;

  Color get pageBackground =>
      isDark ? AppTheme.darkSurface : AppTheme.offWhite;
}