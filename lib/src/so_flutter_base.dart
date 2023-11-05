import 'dart:ui';

import 'package:intl/intl.dart' as intl;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    Navigator.of(currentContext()).push(MaterialPageRoute(
        builder: (context) => get()._screen(context, screen)));
  }

  /// Get the current [BuildContext] that belongs to the currently visible [Screen].
  static BuildContext currentContext() {
    return _navigatorKey.currentContext ?? get().context;
  }

  /// Go back to the home screen.
  static goHome() {
    if (_wasRunning()) {
      _navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  /// Go back to the previous screen.
  static goBack() {
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
  static message(String content, [MessageAction? action]) {
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
  static alert(String message, [String? title, List<MessageAction>? actions]) {
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
  static okCancel(String message,
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
  /// It should have build method that returns a [Scaffold]. This will be
  /// shown on the screen.
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
/// a [State] and one needs not define a real [StatefulWidget] instance.
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

/// A screen used for data entry. The [Form] to be constructed for data entry
/// should use the [formKey] as the key. You can use various create methods for
/// creating the [FormField]s to be used in the [Form].
abstract class DataScreen extends StatefulScreen {
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];

  /// Constructor.
  DataScreen();

  @override
  dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    controllers.clear();
    for (var f in focusNodes) {
      f.dispose();
    }
    focusNodes.clear();
    super.dispose();
  }

  /// Register a [TextEditingController] so that it will get disposed when this
  /// screen is disposed.
  void registerController(TextEditingController controller) {
    controllers.add(controller);
  }

  /// Register a [FocusNode] so that it will get disposed when this
  /// screen is disposed.
  void registerFocusNode(FocusNode focusNode) {
    focusNodes.add(focusNode);
  }

  /// Check if the form data is valid.
  bool get isValid =>
      formKey.currentState == null ? false : formKey.currentState!.validate();

  /// Create a text field.
  /// The parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<String> textField(
      {Key? key,
      String? initialValue,
      InputDecoration? decoration = const InputDecoration(),
      TextInputType? keyboardType,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextInputAction? textInputAction,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextDirection? textDirection,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      bool autofocus = false,
      bool readOnly = false,
      bool? showCursor,
      String obscuringCharacter = '•',
      bool obscureText = false,
      bool autocorrect = true,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLines = 1,
      int? minLines,
      bool expands = false,
      int? maxLength,
      ValueChanged<String>? onChanged,
      GestureTapCallback? onTap,
      TapRegionCallback? onTapOutside,
      VoidCallback? onEditingComplete,
      ValueChanged<String>? onFieldSubmitted,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      List<TextInputFormatter>? inputFormatters,
      bool? enabled,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool? enableInteractiveSelection,
      TextSelectionControls? selectionControls,
      InputCounterWidgetBuilder? buildCounter,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      AutovalidateMode? autovalidateMode,
      ScrollController? scrollController,
      String? restorationId,
      bool enableIMEPersonalizedLearning = true,
      MouseCursor? mouseCursor,
      EditableTextContextMenuBuilder? contextMenuBuilder =
          _defaultContextMenuBuilder,
      SpellCheckConfiguration? spellCheckConfiguration,
      TextMagnifierConfiguration? magnifierConfiguration,
      UndoHistoryController? undoController,
      AppPrivateCommandCallback? onAppPrivateCommand,
      bool? cursorOpacityAnimates,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      ContentInsertionConfiguration? contentInsertionConfiguration,
      Clip clipBehavior = Clip.hardEdge,
      bool scribbleEnabled = true,
      bool canRequestFocus = true}) {
    _TextValueController controller = _TextValueController(initialValue);
    registerController(controller);
    FocusNode focusNode = FocusNode();
    registerFocusNode(focusNode);
    return _CustomTextField<String>(
      key: key,
      decoration: decoration,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      onChanged: onChanged,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      scrollController: scrollController,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      undoController: undoController,
      onAppPrivateCommand: onAppPrivateCommand,
      cursorOpacityAnimates: cursorOpacityAnimates,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      scribbleEnabled: scribbleEnabled,
      canRequestFocus: canRequestFocus,
      controller: controller,
      focusNode: focusNode,
    );
  }

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  /// Create a date field.
  /// Most of the parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<DateTime> dateField(
      {Key? key,
      DateTime? initialValue,
      intl.DateFormat? dateFormat,
      DateTime? minValue,
      DateTime? maxValue,
      InputDecoration? decoration = const InputDecoration(),
      TextInputType? keyboardType,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextInputAction? textInputAction,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextDirection? textDirection,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      bool autofocus = false,
      bool readOnly = false,
      bool? showCursor,
      bool autocorrect = true,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLength,
      ValueChanged<DateTime?>? onChanged,
      TapRegionCallback? onTapOutside,
      VoidCallback? onEditingComplete,
      ValueChanged<DateTime?>? onFieldSubmitted,
      FormFieldSetter<DateTime?>? onSaved,
      FormFieldValidator<DateTime?>? validator,
      List<TextInputFormatter>? inputFormatters,
      bool? enabled,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool? enableInteractiveSelection,
      TextSelectionControls? selectionControls,
      InputCounterWidgetBuilder? buildCounter,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      AutovalidateMode? autovalidateMode,
      ScrollController? scrollController,
      String? restorationId,
      bool enableIMEPersonalizedLearning = true,
      MouseCursor? mouseCursor,
      EditableTextContextMenuBuilder? contextMenuBuilder =
          _defaultContextMenuBuilder,
      SpellCheckConfiguration? spellCheckConfiguration,
      TextMagnifierConfiguration? magnifierConfiguration,
      UndoHistoryController? undoController,
      AppPrivateCommandCallback? onAppPrivateCommand,
      bool? cursorOpacityAnimates,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      ContentInsertionConfiguration? contentInsertionConfiguration,
      Clip clipBehavior = Clip.hardEdge,
      bool scribbleEnabled = true,
      bool canRequestFocus = true}) {
    initialValue ??= DateTime.now();
    intl.DateFormat df = dateFormat ?? intl.DateFormat.yMMMd();
    toText(DateTime? d) => df.format(d!);
    _TextReplacingController<DateTime> controller =
        _TextReplacingController(toText, initialValue);
    minValue ??= DateTime.utc(
        initialValue.year - 100, initialValue.month, initialValue.day);
    maxValue ??= DateTime.utc(
        initialValue.year + 100, initialValue.month, initialValue.day);
    var tap = readOnly
        ? null
        : () async {
            controller.fieldValue = await showDatePicker(
                context: context,
                initialDate: controller.fieldValue ?? initialValue!,
                firstDate: minValue!,
                lastDate: maxValue!);
          };
    return _replacingTextField<DateTime>(
      key: key,
      controller: controller,
      decoration: decoration,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: true,
      showCursor: showCursor,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLength: maxLength,
      onTap: tap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      scrollController: scrollController,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      undoController: undoController,
      onAppPrivateCommand: onAppPrivateCommand,
      cursorOpacityAnimates: cursorOpacityAnimates,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      scribbleEnabled: scribbleEnabled,
      canRequestFocus: canRequestFocus,
    );
  }

  Field<T> _replacingTextField<T>(
      {Key? key,
      required GestureTapCallback? onTap,
      required _TextReplacingController<T> controller,
      InputDecoration? decoration = const InputDecoration(),
      TextInputType? keyboardType,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextInputAction? textInputAction,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextDirection? textDirection,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      bool autofocus = false,
      bool readOnly = false,
      bool? showCursor,
      bool autocorrect = true,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLength,
      ValueChanged<T?>? onChanged,
      TapRegionCallback? onTapOutside,
      VoidCallback? onEditingComplete,
      ValueChanged<T?>? onFieldSubmitted,
      FormFieldSetter<T?>? onSaved,
      FormFieldValidator<T?>? validator,
      List<TextInputFormatter>? inputFormatters,
      bool? enabled,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool? enableInteractiveSelection,
      TextSelectionControls? selectionControls,
      InputCounterWidgetBuilder? buildCounter,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      AutovalidateMode? autovalidateMode,
      ScrollController? scrollController,
      String? restorationId,
      bool enableIMEPersonalizedLearning = true,
      MouseCursor? mouseCursor,
      EditableTextContextMenuBuilder? contextMenuBuilder =
          _defaultContextMenuBuilder,
      SpellCheckConfiguration? spellCheckConfiguration,
      TextMagnifierConfiguration? magnifierConfiguration,
      UndoHistoryController? undoController,
      AppPrivateCommandCallback? onAppPrivateCommand,
      bool? cursorOpacityAnimates,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      ContentInsertionConfiguration? contentInsertionConfiguration,
      Clip clipBehavior = Clip.hardEdge,
      bool scribbleEnabled = true,
      bool canRequestFocus = true}) {
    registerController(controller);
    FocusNode focusNode = FocusNode();
    registerFocusNode(focusNode);
    return _CustomTextField<T>(
      key: key,
      decoration: decoration,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: true,
      showCursor: showCursor,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLength: maxLength,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted == null
          ? null
          : (s) => onFieldSubmitted.call(controller.fieldValue),
      onSaved:
          onSaved == null ? null : (s) => onSaved.call(controller.fieldValue),
      validator: validator == null
          ? null
          : (s) => validator.call(controller.fieldValue),
      onChanged: onChanged == null
          ? null
          : (s) => onChanged.call(controller.fieldValue),
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      scrollController: scrollController,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      undoController: undoController,
      onAppPrivateCommand: onAppPrivateCommand,
      cursorOpacityAnimates: cursorOpacityAnimates,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      scribbleEnabled: scribbleEnabled,
      canRequestFocus: canRequestFocus,
      controller: controller,
      focusNode: focusNode,
    );
  }

  Field<T> _numField<T extends num>(
      {Key? key,
      required T? Function(String? text) toValue,
      T? initialValue,
      InputDecoration? decoration = const InputDecoration(),
      TextInputAction? textInputAction,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextDirection? textDirection,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      bool autofocus = false,
      bool readOnly = false,
      bool? showCursor,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLength,
      int decimals = 6,
      bool signed = false,
      ValueChanged<T?>? onChanged,
      GestureTapCallback? onTap,
      TapRegionCallback? onTapOutside,
      VoidCallback? onEditingComplete,
      ValueChanged<T?>? onFieldSubmitted,
      FormFieldSetter<T?>? onSaved,
      FormFieldValidator<T?>? validator,
      bool? enabled,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool? enableInteractiveSelection,
      TextSelectionControls? selectionControls,
      InputCounterWidgetBuilder? buildCounter,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      AutovalidateMode? autovalidateMode,
      ScrollController? scrollController,
      String? restorationId,
      bool enableIMEPersonalizedLearning = true,
      MouseCursor? mouseCursor,
      EditableTextContextMenuBuilder? contextMenuBuilder =
          _defaultContextMenuBuilder,
      SpellCheckConfiguration? spellCheckConfiguration,
      TextMagnifierConfiguration? magnifierConfiguration,
      UndoHistoryController? undoController,
      AppPrivateCommandCallback? onAppPrivateCommand,
      bool? cursorOpacityAnimates,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      ContentInsertionConfiguration? contentInsertionConfiguration,
      Clip clipBehavior = Clip.hardEdge,
      bool scribbleEnabled = true,
      bool canRequestFocus = true}) {
    toText(T? numberValue) =>
        numberValue == null ? '' : numberValue.toStringAsFixed(decimals);
    _TextEditingController<T> controller =
        _TextEditingController(toText, toValue, initialValue);
    registerController(controller);
    FocusNode focusNode = FocusNode();
    registerFocusNode(focusNode);
    String pattern = '^';
    if (!signed) {
      pattern += '-{0,1}';
    }
    pattern += r'\d*';
    if (decimals > 0) {
      pattern += r'\.{0,1}\d{0,';
      pattern += '$decimals}';
    }
    pattern += r'$';
    RegExp regPattern = RegExp(pattern);
    return _CustomTextField<T>(
      key: key,
      decoration: decoration,
      keyboardType: TextInputType.numberWithOptions(
          signed: signed, decimal: decimals > 0),
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLength: maxLength,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted == null
          ? null
          : (s) => onFieldSubmitted.call(controller.fieldValue),
      onSaved:
          onSaved == null ? null : (s) => onSaved.call(controller.fieldValue),
      validator: validator == null
          ? null
          : (s) => validator.call(controller.fieldValue),
      onChanged: onChanged == null
          ? null
          : (s) => onChanged.call(controller.fieldValue),
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) =>
            regPattern.hasMatch(newValue.text) ? newValue : oldValue),
      ],
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      scrollController: scrollController,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      undoController: undoController,
      onAppPrivateCommand: onAppPrivateCommand,
      cursorOpacityAnimates: cursorOpacityAnimates,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      scribbleEnabled: scribbleEnabled,
      canRequestFocus: canRequestFocus,
      controller: controller,
      focusNode: focusNode,
    );
  }

  /// Create a  field to accept [double] values.
  /// The parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<double> doubleField(
      {Key? key,
      double? initialValue,
      InputDecoration? decoration = const InputDecoration(),
      TextInputAction? textInputAction,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextDirection? textDirection,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      bool autofocus = false,
      bool readOnly = false,
      bool? showCursor,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLength,
      int decimals = 6,
      bool signed = false,
      ValueChanged<double?>? onChanged,
      GestureTapCallback? onTap,
      TapRegionCallback? onTapOutside,
      VoidCallback? onEditingComplete,
      ValueChanged<double?>? onFieldSubmitted,
      FormFieldSetter<double?>? onSaved,
      FormFieldValidator<double?>? validator,
      bool? enabled,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool? enableInteractiveSelection,
      TextSelectionControls? selectionControls,
      InputCounterWidgetBuilder? buildCounter,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      AutovalidateMode? autovalidateMode,
      ScrollController? scrollController,
      String? restorationId,
      bool enableIMEPersonalizedLearning = true,
      MouseCursor? mouseCursor,
      EditableTextContextMenuBuilder? contextMenuBuilder =
          _defaultContextMenuBuilder,
      SpellCheckConfiguration? spellCheckConfiguration,
      TextMagnifierConfiguration? magnifierConfiguration,
      UndoHistoryController? undoController,
      AppPrivateCommandCallback? onAppPrivateCommand,
      bool? cursorOpacityAnimates,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      ContentInsertionConfiguration? contentInsertionConfiguration,
      Clip clipBehavior = Clip.hardEdge,
      bool scribbleEnabled = true,
      bool canRequestFocus = true}) {
    return _numField<double>(
      key: key,
      toValue: (text) => text == null ? null : double.tryParse(text),
      initialValue: initialValue,
      decoration: decoration,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLength: maxLength,
      decimals: decimals,
      signed: signed,
      onChanged: onChanged,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      scrollController: scrollController,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      undoController: undoController,
      onAppPrivateCommand: onAppPrivateCommand,
      cursorOpacityAnimates: cursorOpacityAnimates,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      scribbleEnabled: scribbleEnabled,
      canRequestFocus: canRequestFocus,
    );
  }

  /// Create a  field to accept [int] values.
  /// The parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<int> intField(
      {Key? key,
      int? initialValue,
      InputDecoration? decoration = const InputDecoration(),
      TextInputAction? textInputAction,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextDirection? textDirection,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      bool autofocus = false,
      bool readOnly = false,
      bool? showCursor,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLength,
      bool signed = false,
      ValueChanged<int?>? onChanged,
      GestureTapCallback? onTap,
      TapRegionCallback? onTapOutside,
      VoidCallback? onEditingComplete,
      ValueChanged<int?>? onFieldSubmitted,
      FormFieldSetter<int?>? onSaved,
      FormFieldValidator<int?>? validator,
      bool? enabled,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool? enableInteractiveSelection,
      TextSelectionControls? selectionControls,
      InputCounterWidgetBuilder? buildCounter,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      AutovalidateMode? autovalidateMode,
      ScrollController? scrollController,
      String? restorationId,
      bool enableIMEPersonalizedLearning = true,
      MouseCursor? mouseCursor,
      EditableTextContextMenuBuilder? contextMenuBuilder =
          _defaultContextMenuBuilder,
      SpellCheckConfiguration? spellCheckConfiguration,
      TextMagnifierConfiguration? magnifierConfiguration,
      UndoHistoryController? undoController,
      AppPrivateCommandCallback? onAppPrivateCommand,
      bool? cursorOpacityAnimates,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      ContentInsertionConfiguration? contentInsertionConfiguration,
      Clip clipBehavior = Clip.hardEdge,
      bool scribbleEnabled = true,
      bool canRequestFocus = true}) {
    return _numField<int>(
      key: key,
      toValue: (text) => text == null ? null : int.tryParse(text),
      initialValue: initialValue,
      decoration: decoration,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLength: maxLength,
      decimals: 0,
      signed: signed,
      onChanged: onChanged,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      scrollController: scrollController,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      undoController: undoController,
      onAppPrivateCommand: onAppPrivateCommand,
      cursorOpacityAnimates: cursorOpacityAnimates,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      scribbleEnabled: scribbleEnabled,
      canRequestFocus: canRequestFocus,
    );
  }

  /// Create a field that keeps a set of items from the given list of [items] as its value. If a set of [initialSelection] to be specified,
  /// it can be passed as part of the parameters. Some of the items could be disabled using [disabledItems].
  /// The item to string function may be specified using the parameter [toText] and if specified, it will be used to map the item value to
  /// the text to be displayed. If the [itemWidgetCreator] is specified, it will be used to generate the widget for rendering the item.
  /// A tapCallback will be passed a parameter to the [itemWidgetCreator] and it should be invoked when the item widget is tapped.
  /// Also, if the [itemsWidgetCreator] parameter is specified, it will be used to layout the children widgets (widgets of the items).
  /// Most of the parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<Set<T>> selections<T>(
      {Key? key,
      required List<T> items,
      Set<T>? initialSelection,
      Set<T>? disabledItems,
      String Function(T item)? toText,
      Widget Function(T item, bool selected, bool dsiabled,
              void Function() tapCallback)?
          itemWidgetCreator,
      Scaffold Function(List<Widget> children)? itemsWidgetCreator,
      InputDecoration? decoration = const InputDecoration(),
      TextInputType? keyboardType,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextInputAction? textInputAction,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextDirection? textDirection,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      bool autofocus = false,
      bool readOnly = false,
      bool? showCursor,
      bool autocorrect = true,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLength,
      ValueChanged<Set<T>?>? onChanged,
      TapRegionCallback? onTapOutside,
      VoidCallback? onEditingComplete,
      ValueChanged<Set<T>?>? onFieldSubmitted,
      FormFieldSetter<Set<T>?>? onSaved,
      FormFieldValidator<Set<T>?>? validator,
      List<TextInputFormatter>? inputFormatters,
      bool? enabled,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool? enableInteractiveSelection,
      TextSelectionControls? selectionControls,
      InputCounterWidgetBuilder? buildCounter,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      AutovalidateMode? autovalidateMode,
      ScrollController? scrollController,
      String? restorationId,
      bool enableIMEPersonalizedLearning = true,
      MouseCursor? mouseCursor,
      EditableTextContextMenuBuilder? contextMenuBuilder =
          _defaultContextMenuBuilder,
      SpellCheckConfiguration? spellCheckConfiguration,
      TextMagnifierConfiguration? magnifierConfiguration,
      UndoHistoryController? undoController,
      AppPrivateCommandCallback? onAppPrivateCommand,
      bool? cursorOpacityAnimates,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      ContentInsertionConfiguration? contentInsertionConfiguration,
      Clip clipBehavior = Clip.hardEdge,
      bool scribbleEnabled = true,
      bool canRequestFocus = true}) {
    toText = toText ?? (item) => item.toString();
    _TextReplacingController<Set<T>> controller =
        _TextReplacingController((list) {
      return list.map((e) => toText!(e)).join(', ');
    }, initialSelection);
    String? labelText;
    if (decoration != null || decoration?.labelText != null) {
      labelText = decoration?.labelText;
    }
    var tap = readOnly
        ? null
        : () => App.goTo(_MultiSelection(
            items,
            disabledItems,
            itemWidgetCreator,
            itemsWidgetCreator,
            controller,
            labelText ?? 'Select',
            toText!));
    return _replacingTextField<Set<T>>(
      key: key,
      controller: controller,
      decoration: decoration,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: true,
      showCursor: showCursor,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLength: maxLength,
      onTap: tap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      scrollController: scrollController,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      undoController: undoController,
      onAppPrivateCommand: onAppPrivateCommand,
      cursorOpacityAnimates: cursorOpacityAnimates,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      scribbleEnabled: scribbleEnabled,
      canRequestFocus: canRequestFocus,
    );
  }

  /// Create a field that keeps a single item from the given list of [items] as its value. If an [initialValue] to be specified,
  /// it can be passed as part of the parameters. Some of the items could be disabled using [disabledItems].
  /// The item to string function may be specified using the parameter [toText] and if specified, it will be used to map the item value to
  /// the text to be displayed. If the [itemWidgetCreator] is specified, it will be used to generate the widget for rendering the item.
  /// A tapCallback will be passed a parameter to the [itemWidgetCreator] and it should be invoked when the item widget is tapped.
  /// Also, if the [itemsWidgetCreator] parameter is specified, it will be used to layout the children widgets (widgets of the items).
  /// Most of the parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<T> selection<T>(
      {Key? key,
      required List<T> items,
      T? initialValue,
      Set<T>? disabledItems,
      String Function(T item)? toText,
      Widget Function(T item, bool selected, bool dsiabled,
              void Function() tapCallback)?
          itemWidgetCreator,
      Scaffold Function(List<Widget> children)? itemsWidgetCreator,
      InputDecoration? decoration = const InputDecoration(),
      TextInputType? keyboardType,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextInputAction? textInputAction,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextDirection? textDirection,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      bool autofocus = false,
      bool readOnly = false,
      bool? showCursor,
      bool autocorrect = true,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      bool enableSuggestions = true,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLength,
      ValueChanged<T?>? onChanged,
      TapRegionCallback? onTapOutside,
      VoidCallback? onEditingComplete,
      ValueChanged<T?>? onFieldSubmitted,
      FormFieldSetter<T?>? onSaved,
      FormFieldValidator<T>? validator,
      List<TextInputFormatter>? inputFormatters,
      bool? enabled,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool? enableInteractiveSelection,
      TextSelectionControls? selectionControls,
      InputCounterWidgetBuilder? buildCounter,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      AutovalidateMode? autovalidateMode,
      ScrollController? scrollController,
      String? restorationId,
      bool enableIMEPersonalizedLearning = true,
      MouseCursor? mouseCursor,
      EditableTextContextMenuBuilder? contextMenuBuilder =
          _defaultContextMenuBuilder,
      SpellCheckConfiguration? spellCheckConfiguration,
      TextMagnifierConfiguration? magnifierConfiguration,
      UndoHistoryController? undoController,
      AppPrivateCommandCallback? onAppPrivateCommand,
      bool? cursorOpacityAnimates,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      ContentInsertionConfiguration? contentInsertionConfiguration,
      Clip clipBehavior = Clip.hardEdge,
      bool scribbleEnabled = true,
      bool canRequestFocus = true}) {
    toText = toText ?? (item) => item.toString();
    _TextReplacingController<T> controller =
        _TextReplacingController((e) => toText!(e), initialValue);
    String? labelText;
    if (decoration != null || decoration?.labelText != null) {
      labelText = decoration?.labelText;
    }
    var tap = readOnly
        ? null
        : () => App.goTo(_SingleSelection(
            items,
            disabledItems,
            itemWidgetCreator,
            itemsWidgetCreator,
            controller,
            labelText ?? 'Select',
            toText!));
    return _replacingTextField<T>(
      key: key,
      controller: controller,
      decoration: decoration,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: true,
      showCursor: showCursor,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLength: maxLength,
      onTap: tap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      scrollController: scrollController,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      undoController: undoController,
      onAppPrivateCommand: onAppPrivateCommand,
      cursorOpacityAnimates: cursorOpacityAnimates,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      scribbleEnabled: scribbleEnabled,
      canRequestFocus: canRequestFocus,
    );
  }
}

/// Field on which some sort value can be set or read out.
abstract class Field<T> implements Widget {
  /// Getter for the value.
  T? get value;

  /// Setter for the value.
  set value(T? value);

  /// Focus on this field.
  focus();
}

abstract class _TextController<T> {
  T? fieldValue;
}

class _TextValueController extends TextEditingController
    implements _TextController<String> {
  _TextValueController(String? initialFieldValue) {
    text = initialFieldValue ?? '';
  }

  @override
  String? get fieldValue => text;

  @override
  set fieldValue(String? fieldValue) {
    text = fieldValue ?? '';
  }
}

class _TextReplacingController<T> extends TextEditingController
    implements _TextController<T> {
  final String Function(T value) toText;
  T? _fieldValue;

  _TextReplacingController(this.toText, T? initialFieldValue) {
    fieldValue = initialFieldValue;
  }

  @override
  set fieldValue(T? value) {
    _fieldValue = value;
    text = value == null ? '' : toText(value);
  }

  @override
  T? get fieldValue => _fieldValue;
}

class _TextEditingController<T> extends TextEditingController
    implements _TextController<T> {
  final String Function(T? value) toText;
  final T? Function(String? text) toValue;
  T? _fieldValue;
  bool _trigger = true;

  _TextEditingController(this.toText, this.toValue, T? initialFieldValue) {
    fieldValue = initialFieldValue;
    addListener(() {
      _trigger = false;
      fieldValue = toValue(text);
      _trigger = true;
    });
  }

  @override
  set fieldValue(T? value) {
    _fieldValue = value;
    if (_trigger) {
      _trigger = false;
      text = value == null ? '' : toText(value);
      _trigger = true;
    }
  }

  @override
  T? get fieldValue => _fieldValue;

  @override
  set text(String textValue) {
    super.text = textValue;
    if (_trigger) {
      _trigger = false;
      _fieldValue = toValue(textValue);
      _trigger = true;
    }
  }
}

class _CustomTextField<T> extends TextFormField implements Field<T> {
  final FocusNode _focusNode;

  _CustomTextField(
      {super.key,
      super.decoration,
      super.keyboardType,
      super.textCapitalization,
      super.textInputAction,
      super.style,
      super.strutStyle,
      super.textDirection,
      super.textAlign,
      super.textAlignVertical,
      super.autofocus,
      super.readOnly,
      super.showCursor,
      super.obscuringCharacter,
      super.obscureText,
      super.autocorrect,
      super.smartDashesType,
      super.smartQuotesType,
      super.enableSuggestions,
      super.maxLengthEnforcement,
      super.maxLines,
      super.minLines,
      super.expands,
      super.maxLength,
      super.onChanged,
      super.onTap,
      super.onTapOutside,
      super.onEditingComplete,
      super.onFieldSubmitted,
      super.onSaved,
      super.validator,
      super.inputFormatters,
      super.enabled,
      super.cursorWidth,
      super.cursorHeight,
      super.cursorRadius,
      super.cursorColor,
      super.keyboardAppearance,
      super.scrollPadding,
      super.enableInteractiveSelection,
      super.selectionControls,
      super.buildCounter,
      super.scrollPhysics,
      super.autofillHints,
      super.autovalidateMode,
      super.scrollController,
      super.restorationId,
      super.enableIMEPersonalizedLearning,
      super.mouseCursor,
      super.contextMenuBuilder,
      super.spellCheckConfiguration,
      super.magnifierConfiguration,
      super.undoController,
      super.onAppPrivateCommand,
      super.cursorOpacityAnimates,
      super.selectionHeightStyle,
      super.selectionWidthStyle,
      super.dragStartBehavior,
      super.contentInsertionConfiguration,
      super.clipBehavior,
      super.scribbleEnabled,
      super.canRequestFocus,
      super.controller,
      super.focusNode})
      : _focusNode = focusNode!;

  @override
  T? get value => (controller as _TextController<T>).fieldValue;

  @override
  set value(T? v) => (controller as _TextController<T>).fieldValue = v;

  @override
  focus() {
    if (enabled) {
      _focusNode.requestFocus();
    }
  }
}

abstract class _BasicSelection<T, V> extends StatefulScreen {
  final List<T> items;
  final Set<T>? disabledItems;
  final Widget Function(
          T item, bool selected, bool disabled, void Function() tapCallback)?
      itemWidgetCreator;
  final Scaffold Function(List<Widget> children)? itemsWidgetCreator;
  final _TextReplacingController<V> controller;
  final String labelText;
  final String Function(T item) toText;

  _BasicSelection(this.items, this.disabledItems, this.itemWidgetCreator,
      this.itemsWidgetCreator, this.controller, this.labelText, this.toText);

  @override
  Scaffold build(BuildContext context) {
    return (itemsWidgetCreator ?? defaultWidget).call(selectionWidgets());
  }

  Scaffold defaultWidget(List<Widget> children) {
    return Scaffold(
      appBar: AppBar(
        title: Text(labelText),
        actions: actions(),
      ),
      body: ListView(
        children: children,
      ),
    );
  }

  List<Widget> selectionWidgets() {
    List<Widget> widgets = [];

    for (T item in items) {
      widgets.add(_ItemWidget<T, V>(
        item: item,
        onTap: () => tap(item),
        selection: this,
      ));
    }
    return widgets;
  }

  void tap(T item);

  List<Widget>? actions() {
    return null;
  }

  bool selected(T item);

  bool disabled(T item) =>
      disabledItems != null && disabledItems!.contains(item);

  OutlinedBorder? checkBoxShape() {
    return null;
  }
}

class _MultiSelection<T> extends _BasicSelection<T, Set<T>> {
  _MultiSelection(
      super.items,
      super.disabledItems,
      super.itemWidgetCreator,
      super.itemsWidgetCreator,
      super.controller,
      super.labelText,
      super.toText);

  @override
  bool selected(T item) =>
      controller.fieldValue != null && controller.fieldValue!.contains(item);

  @override
  List<Widget>? actions() {
    return [
      TextButton(
          onPressed: () {
            Set<T> v = {...items};
            if (!(disabledItems == null || disabledItems!.isEmpty)) {
              Set<T>? selected = controller.fieldValue;
              if (selected != null && selected.isNotEmpty) {
                for (T i in disabledItems!) {
                  if (!selected.contains(i)) {
                    v.remove(i);
                  }
                }
              } else {
                v.removeWhere((i) => disabledItems!.contains(i));
              }
            }
            setState(() {
              controller.fieldValue = v;
            });
          },
          child: const Text(
            'Select All',
            style: TextStyle(color: Colors.white),
          )),
      TextButton(
          onPressed: () {
            Set<T> v = {};
            if (!(disabledItems == null || disabledItems!.isEmpty)) {
              Set<T>? selected = controller.fieldValue;
              if (selected != null && selected.isNotEmpty) {
                for (T i in selected) {
                  if (disabledItems!.contains(i)) {
                    v.add(i);
                  }
                }
              }
            }
            setState(() {
              controller.fieldValue = v;
            });
          },
          child: const Text(
            'Clear',
            style: TextStyle(color: Colors.white),
          )),
    ];
  }

  @override
  void tap(T item) {
    if (disabled(item)) {
      return;
    }
    if (controller.fieldValue == null) {
      controller.fieldValue = {item};
      return;
    }
    Set<T> v = {...controller.fieldValue!};
    if (v.contains(item)) {
      v.remove(item);
    } else {
      v.add(item);
    }
    controller.fieldValue = v;
  }
}

class _SingleSelection<T> extends _BasicSelection<T, T> {
  _SingleSelection(
      super.items,
      super.disabledItems,
      super.itemWidgetCreator,
      super.itemsWidgetCreator,
      super.controller,
      super.labelText,
      super.toText);

  @override
  bool selected(T item) => item == controller.fieldValue;

  @override
  void tap(T item) {
    T? current = controller.fieldValue;
    if (item == current) {
      App.goBack();
      return;
    }
    if (disabled(item)) {
      return;
    }
    if (current != null && disabled(current)) {
      return;
    }
    if (!selected(item)) {
      controller.fieldValue = item;
    }
    App.goBack();
  }

  @override
  OutlinedBorder? checkBoxShape() {
    return const CircleBorder();
  }
}

class _ItemWidget<T, V> extends StatefulWidget {
  final T item;
  final _BasicSelection<T, V> selection;
  final void Function() onTap;

  const _ItemWidget(
      {super.key,
      required this.item,
      required this.onTap,
      required this.selection});

  @override
  _ItemState<T, V> createState() {
    return _ItemState();
  }
}

class _ItemState<T, V> extends State<_ItemWidget<T, V>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: _createWidget(),
    );
  }

  Widget _createWidget() {
    bool selected = widget.selection.selected(widget.item),
        disabled = widget.selection.disabled(widget.item);
    if (widget.selection.itemWidgetCreator != null) {
      return widget.selection.itemWidgetCreator!
          .call(widget.item, selected, disabled, tap);
    }
    return ListTile(
      title: Text(widget.selection.toText.call(widget.item)),
      enabled: !disabled,
      selected: false,
      mouseCursor: SystemMouseCursors.click,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white.withBlue(230))),
      tileColor:
          disabled ? Colors.grey : (selected ? Colors.lightBlue : Colors.white),
      leading: Checkbox(
        value: selected,
        shape: widget.selection.checkBoxShape(),
        onChanged: disabled ? null : (v) => tap(),
      ),
    );
  }

  void tap() {
    widget.onTap.call();
    setState(() {});
  }
}
