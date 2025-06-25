part of 'so_flutter_base.dart';

/// Field on which some sort value can be set or read out.
abstract class Field<T> implements Widget {
  /// Getter for the value.
  T? get value;

  /// Setter for the value.
  set value(T? value);

  /// Focus on this field.
  void focus();
}

/// Wrap a [Field] with this class to handle non-null value for the field.
class FieldValue<T> {
  final Field<T> field;
  final T defaultValue;

  /// Constructor.
  /// Set the [field] to be wrapped with the [defaultValue] to use when the
  /// internal value is [null].
  FieldValue(this.field, this.defaultValue);

  /// Get the current field-value. Always return non-null. If null, the default value is returned.
  T get value => field.value ?? defaultValue;

  /// Set the current field-value. If null is passed, the default value will be set.
  set value(T? newValue) {
    field.value = newValue ?? defaultValue;
  }
}

abstract class _TextController<T> {
  T? fieldValue;
  set hasFocus(bool has);
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

  @override
  set hasFocus(bool has) => {};
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

  @override
  set hasFocus(bool has) => {};
}

class _TextEditingController<T> extends TextEditingController
    implements _TextController<T> {
  final String Function(T? value) toText;
  final T? Function(String? text) toValue;
  final String Function(T? value)? toFormattedText;
  T? _fieldValue;
  bool _trigger = true;
  bool _hasFocus = false;

  _TextEditingController(
      this.toText, this.toValue, T? initialFieldValue, this.toFormattedText) {
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
      text = value == null
          ? ''
          : (_hasFocus || toFormattedText == null
              ? toText(value)
              : toFormattedText!(value));
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

  @override
  set hasFocus(bool has) {
    if (has != _hasFocus && toFormattedText != null && _fieldValue != null) {
      _hasFocus = has;
      _trigger = false;
      text = has ? toText(_fieldValue) : toFormattedText!(_fieldValue);
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
      super.scrollPadding = const EdgeInsets.all(20.0),
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
      super.contextMenuBuilder = _defaultContextMenuBuilder,
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
      : _focusNode = focusNode! {
    _focusNode.addListener(() {
      (controller as _TextController<T>).hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  T? get value => (controller as _TextController<T>).fieldValue;

  @override
  set value(T? v) => (controller as _TextController<T>).fieldValue = v;

  @override
  void focus() {
    if (enabled) {
      _focusNode.requestFocus();
    }
  }

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
}

class _ValueBox<T> {
  T? value;
  _RollerState<T>? state;
}

/// Roller that displays a clickable-text from a list of items. When clicked
/// the value is rolled forward inline and eventually wrap around to the first
/// one. If [toText] is specified, it will be used to convert the item into text
/// to display, otherwise the toString() method of the item is used.
class Roller<T> extends StatefulWidget implements Field<T> {
  final List<T> items;
  final _ValueBox<T> _value = _ValueBox();
  final String Function(T item)? toText;
  final ValueChanged<T?>? onChanged;

  /// Constructor.
  Roller(
      {super.key,
      required this.items,
      T? initialSelection,
      this.toText,
      this.onChanged}) {
    _value.value = initialSelection;
  }

  @override
  State<Roller<T>> createState() {
    return _RollerState();
  }

  @override
  T? get value => _value.value;

  @override
  set value(T? value) {
    if (value == _value.value) {
      return;
    }
    if (_value.state == null) {
      _value.value = value;
      onChanged?.call(value);
      return;
    }
    _value.state?.changeTo(value ?? items.first);
  }

  @override
  void focus() {}
}

class _RollerState<T> extends State<Roller<T>> {
  void changeTo(T item) {
    setState(() {
      widget._value.value = item;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    widget.onChanged?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    widget._value.state = this;
    if (widget.items.isEmpty) {
      return const Text('None');
    }
    widget._value.value ??= widget.items.first;
    T item = widget._value.value as T;
    Text text = Text(
        widget.toText == null ? item.toString() : widget.toText!.call(item));
    int index = widget.items.indexOf(item) + 1;
    if (index == widget.items.length) {
      index = 0;
    }
    item = widget.items.elementAt(index);
    return InkWell(
      onTap: () => changeTo(item),
      child: Tooltip(
        message: 'Tap to change',
        child: text,
      ),
    );
  }
}
