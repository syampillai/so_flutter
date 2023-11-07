part of 'so_flutter_base.dart';

class _BoxedBool {
  bool? value;
  _BoolState? state;
  _BoxedBool();
}

class _BoolWidget extends StatefulWidget implements Field<bool> {
  final bool checkBox;
  final _BoxedBool valueBox = _BoxedBool();
  final bool tristate;
  final ValueChanged<bool?>? onChanged;
  final FormFieldSetter<bool?>? onSaved;
  final FormFieldValidator<bool?>? validator;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final bool autofocus = false;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final bool isError = false;
  final String? semanticLabel;
  final InputDecoration? decoration;

  _BoolWidget(
      {super.key,
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
      this.checkBox = true}) {
    valueBox.value = value;
  }

  @override
  _BoolState createState() {
    // ignore: no_logic_in_create_state
    return _createState();
  }

  _BoolState _createState() {
    valueBox.state = _BoolState(checkBox);
    return valueBox.state!;
  }

  @override
  focus() {}

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
  final bool checkBox;

  _BoolState(this.checkBox);

  void changed() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget prefix = checkBox
        ? Checkbox(
            value: widget.value,
            tristate: widget.tristate,
            onChanged: (v) {
              widget.onChanged?.call(v);
              widget.value = v;
            },
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
            onChanged: (v) {
              widget.onChanged?.call(v);
              widget.value = v;
            },
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
}
