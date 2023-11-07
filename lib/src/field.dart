part of 'so_flutter_base.dart';

/// Field on which some sort value can be set or read out.
abstract class Field<T> implements Widget {
  /// Getter for the value.
  T? get value;

  /// Setter for the value.
  set value(T? value);

  /// Focus on this field.
  focus();
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
