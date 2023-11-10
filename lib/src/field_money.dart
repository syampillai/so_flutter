part of 'so_flutter_base.dart';

class _BoxedMoney {
  late Money value;
  _MoneyState? state;
  FocusNode? focusNode;
  _CustomTextField<Money>? field;
  _BoxedMoney();
  Currency get currency => value.currency;
}

class _MoneyWidget extends StatefulWidget implements Field<Money> {
  final _BoxedMoney valueBox = _BoxedMoney();
  final InputDecoration? decoration;
  final TextInputAction? textInputAction;
  final List<Currency>? selectableCurrencies;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLength;
  final bool signed;
  final ValueChanged<Money?>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<Money?>? onFieldSubmitted;
  final FormFieldSetter<Money?>? onSaved;
  late final FormFieldValidator<Money?>? _validator;
  final bool enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final UndoHistoryController? undoController;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final bool? cursorOpacityAnimates;
  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;
  final DragStartBehavior dragStartBehavior;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final Clip clipBehavior;
  final bool scribbleEnabled;
  final bool canRequestFocus;

  _MoneyWidget({
    super.key,
    Currency? currency,
    this.selectableCurrencies,
    Money? initialValue,
    this.decoration,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLength,
    this.signed = false,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    FormFieldValidator<Money?>? validator,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.undoController,
    this.onAppPrivateCommand,
    this.cursorOpacityAnimates,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.contentInsertionConfiguration,
    this.scribbleEnabled = true,
    this.canRequestFocus = true,
    num? minValue,
    num? maxValue,
    this.clipBehavior = Clip.hardEdge,
  }) {
    currency ??= initialValue == null
        ? (selectableCurrencies != null && selectableCurrencies!.isNotEmpty
            ? selectableCurrencies!.first
            : Currency.local)
        : initialValue.currency;
    if (initialValue != null && currency != initialValue.currency) {
      initialValue = initialValue.to(currency);
    }
    selectableCurrencies?.add(currency);
    if (selectableCurrencies != null && selectableCurrencies!.length == 1) {
      selectableCurrencies!.clear();
    }
    valueBox.value = initialValue ?? Money.of(0, currency);
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
    _validator = validator;
  }

  @override
  _MoneyState createState() {
    return _MoneyState();
  }

  @override
  focus() {
    if (enabled) {
      valueBox.focusNode?.requestFocus();
    }
  }

  @override
  set value(Money? value) {
    if (value != valueBox.value) {
      Currency old = valueBox.currency;
      valueBox.value = value ?? Money.of(0, old);
      onChanged?.call(valueBox.value);
      if (old != valueBox.currency) {
        valueBox.state?.changed();
      } else {
        valueBox.field?.value = value;
      }
    }
  }

  @override
  Money? get value => valueBox.value;
}

class _MoneyState extends State<_MoneyWidget> {
  final FocusNode focusNode = FocusNode();
  _TextEditingController<Money>? controller;

  _MoneyState();

  @override
  void dispose() {
    focusNode.dispose();
    controller?.dispose();
    super.dispose();
  }

  void changed() {
    setState(() {});
  }

  Widget prefix() {
    Text text = Text(widget.valueBox.currency.symbol);
    if (widget.selectableCurrencies == null ||
        widget.selectableCurrencies!.isEmpty) {
      return text;
    }
    return Roller<Currency>(
      items: widget.selectableCurrencies!,
      initialSelection: widget.valueBox.currency,
      toText: (item) => item.symbol,
      onChanged: (item) =>
          widget.value = Money.of(widget.valueBox.value.value, item!),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.valueBox.state = this;
    widget.valueBox.focusNode = focusNode;
    InputDecoration? decoration = widget.decoration;
    if (decoration == null) {
      decoration = InputDecoration(prefix: prefix());
    } else {
      decoration = decoration.copyWith(prefix: prefix());
    }
    String toText(Money? m) => m == null
        ? ''
        : m.value.toStringAsFixed(widget.valueBox.currency.decimals);
    String toFormattedText(Money? m) =>
        m == null ? '' : m.format(withSymbol: false);
    Money? toValue(String? text) => text == null
        ? null
        : DataScreen._toMoney(text, widget.valueBox.currency);
    controller = _TextEditingController(
        toText, toValue, widget.valueBox.value, toFormattedText);
    String pattern = '^';
    if (!widget.signed) {
      pattern += '-{0,1}';
    }
    pattern += r'\d*';
    if (widget.valueBox.currency.decimals > 0) {
      pattern += r'\.{0,1}\d{0,';
      pattern += '${widget.valueBox.currency.decimals}}';
    }
    pattern += r'$';
    RegExp regPattern = RegExp(pattern);
    _CustomTextField<Money> field = _CustomTextField<Money>(
      key: widget.key,
      decoration: decoration,
      keyboardType: TextInputType.numberWithOptions(
          signed: widget.signed,
          decimal: widget.valueBox.currency.decimals > 0),
      textInputAction: widget.textInputAction,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted == null
          ? null
          : (s) => widget.onFieldSubmitted!.call(controller!.fieldValue),
      onSaved: widget.onSaved == null
          ? null
          : (s) => widget.onSaved!.call(controller!.fieldValue),
      validator: widget._validator == null
          ? null
          : (s) => widget._validator!.call(controller!.fieldValue),
      onChanged: widget.onChanged == null
          ? null
          : (s) => widget.onChanged!.call(controller!.fieldValue),
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) =>
            regPattern.hasMatch(newValue.text) ? newValue : oldValue),
      ],
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      buildCounter: widget.buildCounter,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      autovalidateMode: widget.autovalidateMode,
      scrollController: widget.scrollController,
      restorationId: widget.restorationId,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      mouseCursor: widget.mouseCursor,
      contextMenuBuilder: widget.contextMenuBuilder,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration: widget.magnifierConfiguration,
      undoController: widget.undoController,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      cursorOpacityAnimates: widget.cursorOpacityAnimates,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      dragStartBehavior: widget.dragStartBehavior,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      clipBehavior: widget.clipBehavior,
      scribbleEnabled: widget.scribbleEnabled,
      canRequestFocus: widget.canRequestFocus,
      controller: controller,
      focusNode: focusNode,
    );
    widget.valueBox.field = field;
    return field;
  }
}
