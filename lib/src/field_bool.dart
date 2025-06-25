part of 'so_flutter_base.dart';

class _BoxedBool {
  bool? value;
  _BoolState? state;
  FocusNode? focusNode;
  _BoxedBool();
}

class _BoolWidget extends StatefulWidget implements Field<bool> {
  final bool checkbox;
  final _BoxedBool valueBox = _BoxedBool();
  final bool tristate;
  final ValueChanged<bool?>? onChanged;
  final FormFieldSetter<bool?>? onSaved;
  final FormFieldValidator<bool?>? validator;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final bool autofocus = false;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final bool isError = false;
  final String? semanticLabel;
  final InputDecoration? decoration;
  final bool enabled;
  final bool readOnly;

  _BoolWidget({
    super.key,
    required value,
    required this.tristate,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.shape,
    this.side,
    this.semanticLabel,
    this.decoration,
    this.checkbox = true,
    this.enabled = true,
    this.readOnly = false,
  }) {
    valueBox.value = value;
  }

  @override
  _BoolState createState() {
    return _BoolState();
  }

  @override
  focus() {
    if (enabled) {
      valueBox.focusNode?.requestFocus();
    }
  }

  @override
  set value(bool? value) {
    if (value != valueBox.value) {
      valueBox.value = value;
      onChanged?.call(value);
      valueBox.state?.changed();
    }
  }

  @override
  bool? get value => valueBox.value;
}

class _BoolState extends State<_BoolWidget> {
  final FocusNode focusNode = FocusNode();

  _BoolState();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void changed() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.valueBox.state = this;
    widget.valueBox.focusNode = focusNode;
    Widget prefix = widget.checkbox
        ? Checkbox(
            value: widget.value,
            tristate: widget.tristate,
            onChanged: onChanged,
            mouseCursor: widget.mouseCursor,
            activeColor: widget.activeColor,
            fillColor: widget.fillColor,
            checkColor: widget.checkColor,
            focusColor: widget.focusColor,
            hoverColor: widget.hoverColor,
            overlayColor: widget.overlayColor,
            splashRadius: widget.splashRadius,
            materialTapTargetSize: widget.materialTapTargetSize,
            visualDensity: widget.visualDensity,
            shape: widget.shape,
            side: widget.side,
            semanticLabel: widget.semanticLabel)
        : Switch(
            value: widget.value!,
            onChanged: onChanged,
            mouseCursor: widget.mouseCursor,
            activeColor: widget.activeColor,
            focusColor: widget.focusColor,
            hoverColor: widget.hoverColor,
            overlayColor: widget.overlayColor,
            splashRadius: widget.splashRadius,
            materialTapTargetSize: widget.materialTapTargetSize,
          );
    InputDecoration id;
    if (widget.decoration == null) {
      id = InputDecoration(prefix: prefix);
    } else {
      id = widget.decoration!.copyWith(prefix: prefix);
    }
    return TextFormField(
      initialValue: ' ',
      decoration: id,
      readOnly: true,
      focusNode: focusNode,
      onSaved: widget.onSaved == null
          ? null
          : (v) {
              widget.onSaved!.call(widget.valueBox.value);
            },
      validator: widget.validator == null
          ? null
          : (v) {
              return widget.validator!.call(widget.valueBox.value);
            },
    );
  }

  void onChanged(bool? v) {
    if (!widget.enabled || widget.readOnly) {
      return;
    }
    widget.onChanged?.call(v);
    widget.value = v;
  }
}
