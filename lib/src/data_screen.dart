part of 'so_flutter_base.dart';

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
            var v = await showDatePicker(
                context: context,
                initialDate: controller.fieldValue ?? initialValue!,
                firstDate: minValue!,
                lastDate: maxValue!);
            if (v != null) {
              controller.fieldValue = v;
            }
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

  static double? _toDouble(String text) =>
      double.tryParse(text.replaceAll(',', ''));

  static num? _toNum(String text) => num.tryParse(text.replaceAll(',', ''));

  static int? _toInt(String text) => int.tryParse(text.replaceAll(',', ''));

  static Money? _toMoney(String text, Currency currency) {
    if (text == '') {
      return Money.of(0, currency);
    }
    RegExp digitPattern = RegExp(r"^\d");
    while (!digitPattern.hasMatch(text)) {
      text = text.substring(1);
      if (text == '') {
        return Money.of(0, currency);
      }
    }
    num? v = _toNum(text);
    return Money.of(v ?? 0, currency);
  }

  Field<T> _numField<T extends num>({
    Key? key,
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
    bool canRequestFocus = true,
    String Function(T? numberValue)? toText,
    String Function(T? numberValue)? toFormattedText,
    T? minValue,
    T? maxValue,
  }) {
    if (maxValue != null) {
      String? v1(T? numValue) => numValue == null || numValue > maxValue
          ? 'Maximum is ${_strip(maxValue)}'
          : null;
      if (validator != null) {
        var v2 = validator;
        String? v3(T? numValue) {
          String? m = v1.call(numValue);
          return m ?? v2.call(numValue);
        }

        validator = v3;
      } else {
        validator = v1;
      }
    }
    if (minValue != null) {
      String? v1(T? numValue) => numValue == null || numValue < minValue
          ? 'Minimum is ${_strip(minValue)}'
          : null;
      if (validator != null) {
        var v2 = validator;
        String? v3(T? numValue) {
          String? m = v1.call(numValue);
          return m ?? v2.call(numValue);
        }

        validator = v3;
      } else {
        validator = v1;
      }
    }
    toText ??= (numberValue) =>
        numberValue == null ? '' : numberValue.toStringAsFixed(decimals);
    _TextEditingController<T> controller =
        _TextEditingController(toText, toValue, initialValue, toFormattedText);
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
          : (s) => validator!.call(controller.fieldValue),
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
  Field<double> doubleField({
    Key? key,
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
    bool canRequestFocus = true,
    double? minValue,
    double? maxValue,
    String Function(double? numberValue)? toText,
    String Function(double? numberValue)? toFormattedText,
  }) {
    return _numField<double>(
      key: key,
      toValue: (text) => text == null ? null : _toDouble(text),
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
      minValue: minValue,
      maxValue: maxValue,
      toText: toText,
      toFormattedText: toFormattedText,
    );
  }

  /// Create a  field to accept [num] values.
  /// The parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<num> numField({
    Key? key,
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
    ValueChanged<num?>? onChanged,
    GestureTapCallback? onTap,
    TapRegionCallback? onTapOutside,
    VoidCallback? onEditingComplete,
    ValueChanged<num?>? onFieldSubmitted,
    FormFieldSetter<num?>? onSaved,
    FormFieldValidator<num?>? validator,
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
    bool canRequestFocus = true,
    num? minValue,
    num? maxValue,
    String Function(num? numberValue)? toText,
    String Function(num? numberValue)? toFormattedText,
  }) {
    return _numField<num>(
      key: key,
      toValue: (text) => text == null ? null : _toNum(text),
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
      minValue: minValue,
      maxValue: maxValue,
      toText: toText,
      toFormattedText: toFormattedText,
    );
  }

  /// Create a  field to accept [num] values.
  /// The parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<Money> moneyField({
    Key? key,
    Currency? currency,
    Money? initialValue,
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
    ValueChanged<Money?>? onChanged,
    GestureTapCallback? onTap,
    TapRegionCallback? onTapOutside,
    VoidCallback? onEditingComplete,
    ValueChanged<Money?>? onFieldSubmitted,
    FormFieldSetter<Money?>? onSaved,
    FormFieldValidator<Money?>? validator,
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
    bool canRequestFocus = true,
    num? minValue,
    num? maxValue,
  }) {
    currency ??= initialValue == null ? Currency.local : initialValue.currency;
    if (initialValue != null && currency != initialValue.currency) {
      initialValue = initialValue.to(currency);
    }
    initialValue ??= Money.of(0, currency);
    if (maxValue != null) {
      String? v1(Money? m) => m == null || m.value > maxValue
          ? 'Maximum is ${_strip(maxValue)}'
          : null;
      if (validator != null) {
        var v2 = validator;
        String? v3(Money? numValue) {
          String? m = v1.call(numValue);
          return m ?? v2.call(numValue);
        }

        validator = v3;
      } else {
        validator = v1;
      }
    }
    if (minValue != null) {
      String? v1(Money? m) => m == null || m.value < minValue
          ? 'Minimum is ${_strip(minValue)}'
          : null;
      if (validator != null) {
        var v2 = validator;
        String? v3(Money? numValue) {
          String? m = v1.call(numValue);
          return m ?? v2.call(numValue);
        }

        validator = v3;
      } else {
        validator = v1;
      }
    }
    String toText(Money? m) =>
        m == null ? '' : m.value.toStringAsFixed(currency!.decimals);
    String toFormattedText(Money? m) => m == null ? '' : m.toString();
    Money? toValue(String? text) =>
        text == null ? null : _toMoney(text, currency!);
    _TextEditingController<Money> controller =
        _TextEditingController(toText, toValue, initialValue, toFormattedText);
    registerController(controller);
    FocusNode focusNode = FocusNode();
    registerFocusNode(focusNode);
    String pattern = '^';
    if (!signed) {
      pattern += '-{0,1}';
    }
    pattern += r'\d*';
    if (currency.decimals > 0) {
      pattern += r'\.{0,1}\d{0,';
      pattern += '${currency.decimals}}';
    }
    pattern += r'$';
    RegExp regPattern = RegExp(pattern);
    return _CustomTextField<Money>(
      key: key,
      decoration: decoration,
      keyboardType: TextInputType.numberWithOptions(
          signed: signed, decimal: currency.decimals > 0),
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
          : (s) => validator!.call(controller.fieldValue),
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

  /// Create a  field to accept [int] values.
  /// The parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<int> intField({
    Key? key,
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
    bool canRequestFocus = true,
    int? minValue,
    int? maxValue,
    String Function(int? numberValue)? toText,
    String Function(int? numberValue)? toFormattedText,
  }) {
    return _numField<int>(
      key: key,
      toValue: (text) => text == null ? null : _toInt(text),
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
      minValue: minValue,
      maxValue: maxValue,
      toText: toText,
      toFormattedText: toFormattedText,
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
  Field<Set<T>> selectionsField<T>(
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
    tap() => App.goTo(_MultiSelection(
        items,
        readOnly ? {...items} : disabledItems,
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
  Field<T> selectionField<T>(
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
    tap() => App.goTo(_SingleSelection(
        items,
        readOnly ? {...items} : disabledItems,
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

  /// Create a field that keeps a single item from the given list of [items] as its value. If an [initialValue] to be specified,
  /// it can be passed as part of the parameters. Some of the items could be disabled using [disabledItems].
  /// The item to string function may be specified using the parameter [toText] and if specified, it will be used to map the item value to
  /// the text to be displayed. If the [itemWidgetCreator] is specified, it will be used to generate the widget for rendering the item.
  /// A tapCallback will be passed a parameter to the [itemWidgetCreator] and it should be invoked when the item widget is tapped.
  /// Most of the parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<T> comboField<T>(
      {Key? key,
      required List<T> items,
      T? initialValue,
      Set<T>? disabledItems,
      String Function(T item)? toText,
      Widget Function(T item, bool selected, bool dsiabled)? itemWidgetCreator,
      double? comboWidth,
      double? comboHeight,
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
    _CustomTextField<T> textField = _replacingTextField<T>(
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
      onTap: () => {},
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
    ) as _CustomTextField<T>;
    return _ComboField(
      key: key,
      textField: textField,
      items: items,
      itemWidgetCreator: itemWidgetCreator,
      disabledItems: disabledItems,
      toText: toText,
      comboWidth: comboWidth,
      comboHeight: comboHeight,
    );
  }

  /// Create a field that returns the index of the selection from a string list.
  /// If an [initialValue] to be specified, it can be passed as part of the
  /// parameters. Some of the items could be disabled using [disabledItems].
  /// Most of the parameters are exactly similar to the parameters of
  /// [TextFormField].
  Field<int> choiceField(
      {Key? key,
      required List<String> items,
      int? initialValue,
      Set<int>? disabledItems,
      double? comboWidth,
      double? comboHeight,
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
      ValueChanged<int?>? onChanged,
      TapRegionCallback? onTapOutside,
      VoidCallback? onEditingComplete,
      ValueChanged<int?>? onFieldSubmitted,
      FormFieldSetter<int?>? onSaved,
      FormFieldValidator<int>? validator,
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
    String toText(int i) => items.length > i ? items[i] : '';
    _TextReplacingController<int> controller =
        _TextReplacingController((e) => toText(e), initialValue);
    _CustomTextField<int> textField = _replacingTextField<int>(
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
      onTap: () => {},
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
    ) as _CustomTextField<int>;
    return _ComboField(
      key: key,
      textField: textField,
      items: [for (int i = 0; i < items.length; i++) i],
      disabledItems: disabledItems,
      toText: toText,
      comboWidth: comboWidth,
      comboHeight: comboHeight,
    );
  }

  /// Create a [Checkbox] based field to accept [bool] values.
  /// The parameters match the parameters of the [Checkbox].
  Field<bool> checkboxField(
      {Key? key,
      bool? value = false,
      bool tristate = false,
      ValueChanged<bool?>? onChanged,
      FormFieldSetter<bool?>? onSaved,
      FormFieldValidator<bool?>? validator,
      MouseCursor? mouseCursor,
      Color? activeColor,
      MaterialStateProperty<Color?>? fillColor,
      Color? checkColor,
      Color? focusColor,
      Color? hoverColor,
      MaterialStateProperty<Color?>? overlayColor,
      double? splashRadius,
      MaterialTapTargetSize? materialTapTargetSize,
      VisualDensity? visualDensity,
      OutlinedBorder? shape,
      BorderSide? side,
      String? semanticLabel,
      InputDecoration? decoration}) {
    return _BoolWidget(
      key: key,
      value: value,
      tristate: tristate,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      mouseCursor: mouseCursor,
      activeColor: activeColor,
      fillColor: fillColor,
      checkColor: checkColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      shape: shape,
      side: side,
      semanticLabel: semanticLabel,
      decoration: decoration,
    );
  }

  /// Create a [Switch] based field to accept [bool] values.
  /// The parameters match the parameters of the [Switch].
  Field<bool> switchField(
      {Key? key,
      bool value = false,
      ValueChanged<bool?>? onChanged,
      FormFieldSetter<bool?>? onSaved,
      FormFieldValidator<bool?>? validator,
      MouseCursor? mouseCursor,
      Color? activeColor,
      MaterialStateProperty<Color?>? fillColor,
      Color? checkColor,
      Color? focusColor,
      Color? hoverColor,
      MaterialStateProperty<Color?>? overlayColor,
      double? splashRadius,
      MaterialTapTargetSize? materialTapTargetSize,
      InputDecoration? decoration}) {
    return _BoolWidget(
      key: key,
      value: value,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      mouseCursor: mouseCursor,
      activeColor: activeColor,
      fillColor: fillColor,
      checkColor: checkColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      decoration: decoration,
      checkBox: false,
      tristate: false,
    );
  }
}

_strip(num numberValue) {
  String n = '$numberValue';
  if (!n.contains('.') || !n.endsWith('0')) {
    return n;
  }
  while (n.endsWith('0')) {
    n = n.substring(0, n.length - 1);
  }
  if (n.endsWith('.')) {
    n = n.substring(0, n.length - 1);
  }
  return n == '' ? '0' : n;
}
