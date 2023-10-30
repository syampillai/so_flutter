import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Representation of an app.
/// Just create an instance of this class or its descendants to create a running app quickly.
/// Each screen of the app could be an instance of [StatelessScreen], [StatefulScreen] or just an
/// implementation of [Screen].
class App extends State<_App> {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  static App? _instance;

  Screen _home;

  /// Get the home screen.
  Screen get home => _home;

  /// Set the home screen.
  set home(Screen home) {
    _home = home;
    _stateChanged(() => {});
  }

  ThemeData? _themeData;

  /// Get the theme data.
  ThemeData? get themeData {
    return _themeData;
  }

  /// Set the theme data.
  set themeData(ThemeData? themeData) {
    _themeData = themeData;
    _stateChanged(() => {});
  }

  bool _debugMode;

  /// Check if the app is running in debug mode or not.
  bool get debugMode => _debugMode;

  /// Set the debug mode of the app.
  set debugMode(bool debugShowCheckedModeBanner) {
    _debugMode = debugShowCheckedModeBanner;
    _stateChanged(() => {});
  }

  _App? _app;

  /// Constructor. If no home is set, a "Hello" screen is set by default.
  App(
      {Screen home = const _NullScreen(),
      ThemeData? themeData,
      bool debugMode = kDebugMode})
      : _home = home,
        _themeData = themeData,
        _debugMode = debugMode {
    _instance = this;
  }

  /// Get the current app instance. (App is typically a singleton).
  static App get() {
    return _instance ??= App();
  }

  /// Run the app.
  run() {
    if (_app != null) {
      return;
    }
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_outlined,
                  color: Colors.red,
                  size: 100,
                ),
                Text(_debugMode
                    ? errorDetails.exception.toString()
                    : 'Oops... something went wrong'),
              ],
            ),
          ),
        ),
      );
    };
    _app = _App(app: this);
    runApp(_app as Widget);
  }

  _stateChanged(void Function() function) {
    if (_app == null) {
      return;
    }
    if (mounted) {
      setState(function);
      return;
    }
    Future.delayed(
        const Duration(milliseconds: 500), () => _stateChanged(function));
  }

  /// Build the UI.
  @override
  Widget build(BuildContext context) {
    return buildApp(
        context, _navigatorKey, themeData, _screen(context, _home), _debugMode);
  }

  /// Build the app's UI as a [MaterialApp] from the given parameters.
  /// Please make sure that the [MaterialApp] instance uses the given parameter
  /// values for there respective parameters. Any additional parameters can
  /// be set as needed.
  @protected
  MaterialApp buildApp(
      BuildContext context,
      GlobalKey<NavigatorState> navigatorKey,
      ThemeData? themeData,
      Widget home,
      bool debugShowCheckedModeBanner) {
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      navigatorKey: navigatorKey,
      theme: themeData,
      home: home,
    );
  }

  /// Jump to a specific [screen].
  static goTo(Screen screen) {
    _wasRunning();
    if (!_instance!.mounted) {
      _instance!._stateChanged(() => goTo(screen));
      return;
    }
    BuildContext c = _navigatorKey.currentContext ?? get().context;
    Navigator.of(c).push(MaterialPageRoute(
        builder: (context) => get()._screen(context, screen)));
  }

  /// Go back to the home screen.
  static goHome() {
    if (_wasRunning()) {
      _navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  static bool _wasRunning() {
    if (_instance == null) {
      App().run();
      return false;
    }
    App a = _instance ?? App();
    if (a._app == null) {
      a.run();
      return false;
    }
    return true;
  }

  Widget _screen(BuildContext context, Screen screen) {
    if (screen is StatelessScreen) {
      return screen;
    } else if (screen is StatefulScreen) {
      return _AppScreen(screen: screen);
    } else {
      return _AppScreenStateless(screen);
    }
  }
}

class _App extends StatefulWidget {
  final App app;

  const _App({required this.app});

  @override
  App createState() {
    // ignore: no_logic_in_create_state
    return app;
  }
}

class _AppScreen extends StatefulWidget {
  final StatefulScreen screen;

  const _AppScreen({required this.screen});

  @override
  StatefulScreen createState() {
    // ignore: no_logic_in_create_state
    return screen;
  }
}

class _AppScreenStateless extends StatelessScreen {
  final Screen screen;

  const _AppScreenStateless(this.screen);

  @override
  Scaffold build(BuildContext context) {
    return screen.build(context);
  }
}

/// The screen interface.
abstract class Screen {
  Scaffold build(BuildContext context);
}

class _NullScreen implements Screen {
  const _NullScreen();

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello')),
    );
  }
}

/// An abstract [Screen] class developers can extend for creating
/// [StatelessWidget]s.
abstract class StatelessScreen extends StatelessWidget implements Screen {
  /// Constructor.
  const StatelessScreen({super.key});
}

/// An abstract [Screen] class developers can extend for creating
/// [StatefulWidget]s. Please note that this is, in fact, an instance of
/// a [State] and one needs not define a real [StatefulWidget[ instance.
abstract class StatefulScreen extends State<_AppScreen> implements Screen {
  /// Constructor.
  StatefulScreen();

  /// Repaint the screen if required.
  /// Developers may typically invoke this when they feel that they changed
  /// some state data and the changes need to be reflected on the UI. Most, UI
  /// component based changes will automatically get painted with out
  /// invoking this method.
  repaint() {
    if (mounted) {
      setState(() {});
    }
  }
}
