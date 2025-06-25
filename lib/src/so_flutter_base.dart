import 'dart:math';
import 'dart:ui';

import 'package:intl/intl.dart' as intl;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:so_money/so_money.dart';

part 'selection.dart';
part 'data_screen.dart';
part 'field.dart';
part 'field_bool.dart';
part 'field_combo.dart';
part 'field_money.dart';

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
  void run() {
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

  void _stateChanged(void Function() function) {
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
  /// values for the respective parameters. Any additional parameters can
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
  static void goTo(Screen screen) {
    _wasRunning();
    if (!_instance!.mounted) {
      _instance!._stateChanged(() => goTo(screen));
      return;
    }
    Navigator.of(currentContext()).push(MaterialPageRoute(
        builder: (context) => get()._screen(context, screen)));
  }

  /// Jump to a specific [widget].
  static void goToWidget(Widget widget) {
    _wasRunning();
    if (!_instance!.mounted) {
      _instance!._stateChanged(() => goToWidget(widget));
      return;
    }
    Navigator.of(currentContext())
        .push(MaterialPageRoute(builder: (context) => widget));
  }

  /// Get the current [BuildContext] that belongs to the currently visible [Screen].
  static BuildContext currentContext() {
    return _navigatorKey.currentContext ?? get().context;
  }

  /// Go back to the home screen.
  static void goHome() {
    if (_wasRunning()) {
      _navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  /// Go back to the previous screen.
  static void goBack() {
    if (_wasRunning()) {
      _navigatorKey.currentState!.pop();
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

  /// Show a snack-bar message, optionally with an [action].
  static void message(String content, [MessageAction? action]) {
    _wasRunning();
    if (!_instance!.mounted) {
      _instance!._stateChanged(() => message(content, action));
      return;
    }
    SnackBarAction? snackBarAction;
    if (action != null) {
      snackBarAction =
          SnackBarAction(label: action.label, onPressed: action.action);
    }
    ScaffoldMessenger.of(currentContext()).showSnackBar(
      SnackBar(
        content: Text(content),
        action: snackBarAction,
      ),
    );
  }

  /// Show an alert, optionally with an [action].
  static void alert(String message,
      [String? title, List<MessageAction>? actions]) {
    _wasRunning();
    if (!_instance!.mounted) {
      _instance!._stateChanged(() => alert(message));
      return;
    }
    List<Widget>? alertActions;
    if (actions != null && actions.isNotEmpty) {
      alertActions = [];
      for (var a in actions) {
        alertActions.add(TextButton(
            onPressed: () => {a.action.call(), goBack()},
            child: Text(a.label)));
      }
    }
    showDialog(
        context: currentContext(),
        builder: (context) {
          return AlertDialog(
            title: title == null ? null : Text(title),
            content: Text(message),
            actions: alertActions,
          );
        });
  }

  /// Show an Ok/Cancel alert.
  static void okCancel(String message,
      [String? title,
      String okLabel = 'Ok',
      void Function()? okAction,
      String cancelLabel = 'Cancel',
      void Function()? cancelAction]) {
    List<MessageAction> actions = [];
    if (okLabel != '' && okAction != null) {
      actions.add(MessageAction(okLabel, okAction));
    }
    if (cancelLabel != '' && cancelAction != null) {
      actions.add(MessageAction(cancelLabel, cancelAction));
    }
    alert(message, title, actions);
  }

  static double screenWidth() {
    return _instance != null && _instance!.mounted
        ? MediaQuery.of(currentContext()).size.width
        : 0;
  }

  static double screenHeight() {
    return _instance != null && _instance!.mounted
        ? MediaQuery.of(currentContext()).size.height
        : 0;
  }
}

/// A simple class to represent a alert/message action.
class MessageAction {
  /// Label for the action button.
  String label;

  /// The action.
  void Function() action;

  /// Constructor.
  MessageAction(this.label, this.action);
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

class _NullScreen implements Screen {
  const _NullScreen();

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello')),
    );
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
  /// It should have a build method that returns a [Scaffold]. This will be
  /// shown on the screen.
  Scaffold build(BuildContext context);
}

/// An abstract [Screen] class developers can extend for creating
/// [StatelessWidget]s.
abstract class StatelessScreen extends StatelessWidget implements Screen {
  /// Constructor.
  const StatelessScreen({super.key});
}

/// An abstract [Screen] class developers can extend for creating
/// [StatefulWidget]s. Please note that this is, in fact, an instance of
/// a [State] and one needs not define a real [StatefulWidget] instance.
abstract class StatefulScreen extends State<_AppScreen> implements Screen {
  /// Constructor.
  StatefulScreen();
}
