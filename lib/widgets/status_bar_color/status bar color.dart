

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarColor {
  static void apply(BuildContext context) {
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
      theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ));
  }
}
