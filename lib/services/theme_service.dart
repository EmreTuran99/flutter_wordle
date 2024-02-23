
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ThemeService {

  static final ThemeService instance = ThemeService._init();
  ThemeService._init();

  late BuildContext serviceContext;

  void setServiceContext(BuildContext ctx){
    serviceContext = ctx;
  }

  void setTheme(AdaptiveThemeMode mode){
    AdaptiveTheme.of(serviceContext).setThemeMode(mode);
  }

  AdaptiveThemeMode get themeMode => AdaptiveTheme.of(serviceContext).mode;
}