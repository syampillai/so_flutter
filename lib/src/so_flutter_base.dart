import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class App extends State<_App> {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  static App? _instance;
  Screen _home;
  Screen get home => _home;
  set home(Screen home) {
    _home = home;
    _stateChanged(() => {});
  }

  bool _debugMode;
  bool get debugMode => _debugMode;
  set debugMode(bool debugShowCheckedModeBanner) {
    _debugMode = debugShowCheckedModeBanner;
    _stateChanged(() => {});
  }

  _App? _app;

  App({Screen home = const _NullScreen(), bool debugMode = kDebugMode})
      : _home = home,
        _debugMode = debugMode {
    _instance = this;
  }

  static App get() {
    return _instance ??= App();
  }

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

  @override
  Widget build(BuildContext context) {
    return buildApp(
        context, _navigatorKey, _screen(context, _home), _debugMode);
  }

  @protected
  MaterialApp buildApp(
      BuildContext context,
      GlobalKey<NavigatorState> navigatorKey,
      Widget home,
      bool debugShowCheckedModeBanner) {
    return MaterialApp(
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      navigatorKey: navigatorKey,
      home: home,
    );
  }

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

abstract class StatelessScreen extends StatelessWidget implements Screen {
  const StatelessScreen({super.key});
}

abstract class StatefulScreen extends State<_AppScreen> implements Screen {
  StatefulScreen();

  repaint() {
    if (mounted) {
      setState(() {});
    }
  }
}
