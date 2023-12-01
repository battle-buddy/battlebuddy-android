import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class AppTheme {
  static const Color primary = Color.fromRGBO(24, 24, 24, 1);
  static const Color secondary = Color.fromRGBO(251, 70, 59, 1);
  static const Color text = Color.fromRGBO(240, 240, 240, 1);

  static ThemeData get themeData {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: text,
        secondary: secondary,
        onSecondary: text,
        background: primary,
        onBackground: text,
      ),
      iconTheme: const IconThemeData(
        color: secondary,
      ),
      dividerTheme: const DividerThemeData(
        thickness: 0.5,
        color: Colors.grey,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: secondary,
        thumbColor: secondary,
        overlayColor: secondary.withOpacity(0.2),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: secondary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primary,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: primary,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      tabBarTheme: TabBarTheme(
        overlayColor:
            MaterialStateProperty.all<Color>(secondary.withOpacity(0.2)),
        labelColor: secondary,
        indicatorColor: secondary,
        indicatorSize: TabBarIndicatorSize.tab,
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
