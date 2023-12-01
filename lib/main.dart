import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'common/theme.dart';
import 'firebase.dart';
import 'global.dart';
import 'screens/items.dart';
import 'screens/learn.dart';
import 'screens/more.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ThemeData _theme;

  bool _initialized = false;

  FirebaseException? _error;

  Future<void> initialize() async {
    try {
      final futures = [initializeSession(), loadAppInfo()];
      await Future.wait(futures);
      await loadMetadata();
      setState(() {
        _initialized = true;
      });
    } on FirebaseException catch (e) {
      setState(() {
        _error = e;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _theme = AppTheme.themeData;
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return InitScreen(
        title: 'Error',
        message: _error!.code,
      );
    }

    if (!_initialized) return const InitScreen();

    final app = MaterialApp(
      title: 'Battle Buddy',
      theme: _theme,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      routes: {
        ...ItemsTab.routes,
        ...LearnTab.routes,
        ...MoreTab.routes,
      },
      home: const MainNavigatorWidget(),
    );

    return app;
  }
}

class MainNavigatorWidget extends StatefulWidget {
  final String? title;

  const MainNavigatorWidget({super.key, this.title});

  @override
  MainNavigatorWidgetState createState() => MainNavigatorWidgetState();
}

class MainNavigatorWidgetState extends State<MainNavigatorWidget> {
  static const EdgeInsetsGeometry _iconMargin = EdgeInsets.only(bottom: 6);
  static const List<Tab> _widgetBottomTabs = <Tab>[
    Tab(
      icon: ItemsTab.icon,
      text: ItemsTab.title,
      iconMargin: _iconMargin,
    ),
    Tab(
      icon: LearnTab.icon,
      text: LearnTab.title,
      iconMargin: _iconMargin,
    ),
    Tab(
      icon: MoreTab.icon,
      text: MoreTab.title,
      iconMargin: _iconMargin,
    ),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _widgetBottomTabs.length,
      initialIndex: _selectedIndex,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(_widgetBottomTabs.elementAt(_selectedIndex).text!),
        ),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: _onItemTapped,
            tabs: _widgetBottomTabs,
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            ItemsTab(),
            LearnTab(),
            MoreTab(),
          ],
        ),
      ),
    );
  }
}

class InitScreen extends StatelessWidget {
  final String title;
  final String? message;

  static const Color _color = AppTheme.text;
  static const Color _backgroundColor = AppTheme.primary;

  const InitScreen({
    super.key,
    this.title = 'Initializing...',
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: _color,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto Mono',
                    ),
                  ),
                ),
                message == null
                    ? const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(_color),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          message!,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: _color,
                            fontSize: 20,
                            fontFamily: 'Roboto Mono',
                          ),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
