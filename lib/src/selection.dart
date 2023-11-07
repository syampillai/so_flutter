part of 'so_flutter_base.dart';

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
      if (disabledItems != null && (disabledItems!.length != items.length))
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
      if (disabledItems != null && (disabledItems!.length != items.length))
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
