import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class AppTheme {
  static const Color primary = Color.fromRGBO(24, 24, 24, 1);
  static const Color secondary = Color.fromRGBO(28, 28, 28, 1);
  static const Color accent = Color.fromRGBO(251, 70, 59, 1);
  static const Color text = Color.fromRGBO(240, 240, 240, 1);

  static ThemeData get themeData {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        background: primary,
      ),
      primaryColor: primary,
      scaffoldBackgroundColor: primary,
      dividerTheme: const DividerThemeData(
        thickness: 0.5,
        color: Colors.grey,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: secondary,
        thumbColor: accent,
        overlayColor: accent.withOpacity(0.2),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: primary,
        iconTheme: IconThemeData(
          color: accent,
        ),
        actionsIconTheme: IconThemeData(
          color: accent,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primary,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: primary,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      iconTheme: const IconThemeData(
        color: accent,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: accent,
        unselectedLabelColor: text.withOpacity(0.8),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: primary,
        indicatorColor: accent,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

void setNavigationBarColor(Color navBar) =>
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: navBar,
      ),
    );
