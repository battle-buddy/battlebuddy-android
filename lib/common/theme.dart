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
      brightness: Brightness.dark,
      primaryColor: primary,
      accentColor: accent,
      indicatorColor: accent,
      scaffoldBackgroundColor: primary,
      dividerColor: Colors.grey[400],
      textSelectionTheme: const TextSelectionThemeData(cursorColor: accent),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: secondary,
        thumbColor: accent,
        overlayColor: accent.withOpacity(0.2),
      ),
      accentIconTheme: const IconThemeData(
        color: accent,
      ),
      buttonColor: accent,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: primary,
        iconTheme: IconThemeData(
          color: accent,
        ),
        actionsIconTheme: IconThemeData(
          color: accent,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: accent,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
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
      bottomAppBarColor: secondary,
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
