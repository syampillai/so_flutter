part of 'so_flutter_base.dart';

class _ComboField<T> extends StatefulWidget implements Field<T> {
  final _CustomTextField<T> textField;
  final List<T> items;
  final Set<T>? disabledItems;
  final String Function(T item) toText;
  final double? comboWidth, comboHeight;
  final Widget Function(T item, bool selected, bool dsiabled)?
      itemWidgetCreator;

  const _ComboField(
      {super.key,
      required this.textField,
      required this.items,
      required this.toText,
      this.comboWidth,
      this.comboHeight,
      this.disabledItems,
      this.itemWidgetCreator});

  @override
  _ComboFieldState<T> createState() => _ComboFieldState();

  @override
  T? get value => textField.value;

  @override
  set value(T? newValue) {
    textField.value = newValue;
  }

  @override
  focus() {
    textField.focus();
  }
}

class _ComboFieldState<T> extends State<_ComboField<T>>
    with TickerProviderStateMixin {
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    OverlayState? overlayState = Overlay.of(context);
    widget.textField._focusNode.addListener(() {
      if (widget.textField._focusNode.hasFocus) {
        _overlayEntry = _createOverlay();
        overlayState.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  Widget _widget(T item) {
    bool selected = item == widget.textField.value,
        disabled = _disabledItem(item);
    if (widget.itemWidgetCreator != null) {
      return widget.itemWidgetCreator!.call(item, selected, disabled);
    }
    return ListTile(
      title: Text(widget.toText.call(item)),
      enabled: !disabled,
      selected: false,
      tileColor:
          disabled ? Colors.grey : (selected ? Colors.lightBlue : Colors.white),
    );
  }

  bool _disabledItem(T item) =>
      widget.disabledItems != null && widget.disabledItems!.isNotEmpty
          ? widget.disabledItems!.contains(item)
          : false;

  OverlayEntry _createOverlay() {
    List<Widget> tiles = widget.items
        .map((item) => Listener(
            onPointerUp: (_) {
              if (!_disabledItem(item)) {
                setState(() {
                  widget.textField.value = item;
                });
              }
            },
            child: _widget(item)))
        .toList(growable: false);
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    double dh = App.screenHeight(),
        h = size.height,
        y = renderBox.localToGlobal(Offset.zero).dy;
    if ((dh - y - h) > (y - h - 70)) {
      // Lower portion is more
      y = h + 5.0;
      h = min(dh - y - h, 0.35 * dh);
    } else {
      h = min(y - h - 70, 0.35 * dh);
      y = -h;
    }
    if ((widget.comboHeight ?? dh) < h) {
      dh = widget.comboHeight ?? 200;
      if (dh < h) {
        h = dh;
      }
    }
    return OverlayEntry(
        builder: (context) => Positioned(
              width: widget.comboWidth ?? size.width,
              height: h,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, y),
                child: Material(
                  elevation: 5.0,
                  child: SingleChildScrollView(
                      child: Column(
                    children: tiles,
                  )),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.textField,
    );
  }
}
