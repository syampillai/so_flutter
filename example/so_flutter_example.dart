import 'dart:math';

import 'package:flutter/material.dart';
import 'package:so_flutter/so_flutter.dart';

/// Main
main() {
  App app = App(); // New app created.
  // At this point, if you run this, you will get a "Hello World" screen.

  app.home = _FirstScreen(); // Set a home screen other than the default one.
  app.run(); // Now, run the app.
}

/// Example of a "stateless" screen.
class _FirstScreen extends StatelessScreen {
  /// Build method. Note: It should return a [Scaffold].
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
          child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
            ElevatedButton(
              onPressed: () =>
                  App.goTo(_SecondScreen()), // Jump to another screen
              child: const Text(
                'Move to 2nd Screen',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => App.goTo(_DataEntry()), // Jump to another screen
              child: const Text(
                'Sample Data Entry',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                App.get().home =
                    _ThirdScreen() // 3rd screen is set as the home directly!
              },
              child: const Text(
                'Change Home Screen!',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => App.message('Hello world!'),
              child: const Text(
                'Show a message',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => App.message(
                  'Entry deleted!',
                  MessageAction(
                      'Undo', () => App.message('Undelete successful!'))),
              child: const Text(
                'Show an action message',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => App.alert('Sky is going to fall now!'),
              child: const Text(
                'Show an alert',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => App.alert('Sky is going to fall now!', 'Alert', [
                MessageAction('Run', () => App.message('Running')),
                MessageAction('Ignore', () => App.message('Ignored')),
              ]),
              child: const Text(
                'Show an alert with actions',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ])),
    );
  }
}

/// Example of a "stateful" screen.
class _SecondScreen extends StatefulScreen {
  /// Build method. Note: It should return a [Scaffold].
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2nd Screen'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => App.goTo(_ThirdScreen()),
          child: const Text('Go to 3rd Screen'),
        ),
      ),
    );
  }
}

/// This example just implements a [Screen].
class _ThirdScreen implements Screen {
  /// Build method. Note: It should return a [Scaffold].
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('3rd Screen')),
        body: Center(
            child: ElevatedButton(
          onPressed: () => App.goHome(), // Jump back to home
          child: const Text(
            'Go Home',
          ),
        )));
  }
}

bool x = false;

/// Example of a [DataScreen] used for entering some data.
class _DataEntry extends DataScreen {
  /// Build method. Note: It should return a [Scaffold].
  @override
  Scaffold build(BuildContext context) {
    // Create a text field.
    Field<String> textField = this.textField(
      initialValue: 'Hello',
      decoration: const InputDecoration(labelText: 'Enter your name'),
      autofocus: true,
      validator: (v) => v == null || v.isEmpty || v.length > 15
          ? 'Invalid, please enter at least 1 character and at most 15'
          : null,
      autovalidateMode: AutovalidateMode.always,
    );
    // Create a date field.
    Field<DateTime> dateField = this.dateField(
      initialValue: DateTime(1998, 1, 23),
      maxValue: DateTime.now(),
      decoration: const InputDecoration(labelText: 'Enter your date of birth'),
      validator: (v) => v != null && v.isBefore(DateTime.now())
          ? null
          : 'Invalid date of birth',
    );
    // Create a double field.
    Field<double> numericField1 = doubleField(
        initialValue: 123.45,
        decoration: const InputDecoration(
            labelText: 'Enter some decimal number that is less that 3000'),
        validator: (v) {
          return v == null || v >= 3000
              ? 'Out of range! Should be less than 3000'
              : null;
        });
    // Create a int field.
    Field<int> numericField2 = intField(
      initialValue: 273,
      decoration: const InputDecoration(labelText: 'Enter some integer number'),
    );
    List<String> selectionList = [
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten'
    ];
    // Create a multi-select String field.
    Field<Set<String>> multiSelect = selectionsField(
      items: selectionList,
      initialSelection: {'Three', 'Four', 'Five'},
      disabledItems: {"Three", "Seven"},
      decoration: const InputDecoration(labelText: 'Choices'),
    );
    // Create a single select String field.
    Field<String> singleSelect = selectionField(
      items: selectionList,
      initialValue: 'Six',
      disabledItems: {"Three", "Seven"}, // Won't be selectable
      decoration: const InputDecoration(labelText: 'Select One'),
    );
    // Now create the component tree.
    return Scaffold(
      appBar: AppBar(title: const Text('Data Entry Example')),
      body: Form(
          key: formKey, // The built-in key you can use as the form-key
          child: SingleChildScrollView(
              child: Column(children: [
            textField,
            dateField,
            numericField1,
            numericField2,
            comboField<String>(
                items: selectionList,
                initialValue: 'Three',
                decoration: const InputDecoration(labelText: 'A combo field'),
                disabledItems: {'Five'}),
            choiceField(
                items: selectionList,
                initialValue: 2,
                decoration: const InputDecoration(labelText: 'A choice field'),
                disabledItems: {3}),
            multiSelect,
            singleSelect,
            checkboxField(
              decoration:
                  const InputDecoration(labelText: 'Terms & Conditions'),
              validator: (v) =>
                  (v != null && v) ? null : 'Please agree to the T&C',
            ), // A Checkbox field
            switchField(
                decoration: const InputDecoration(
                    labelText: 'Same like a Checkbox Field')),
            const SizedBox(
              height: 10,
            ),
            Wrap(spacing: 10, alignment: WrapAlignment.center, children: [
              ElevatedButton(
                onPressed: () => {
                  // Notice how the field value is accessed
                  App.message(isValid
                      ? "Text field's value is ${textField.value}"
                      : 'Please fix errors'),
                  // Focusing back to the same field
                  textField.focus(),
                },
                child: const Text('Show Text Value'),
              ),
              ElevatedButton(
                onPressed: () => {
                  // Notice how the field value is set
                  textField.value = 'New Text value',
                  // Focusing back to the same field
                  textField.focus(),
                },
                child: const Text('Set Text Value'),
              ),
              ElevatedButton(
                onPressed: () => {
                  // Notice how the field value is accessed
                  App.message(isValid
                      ? "Date field's value is ${dateField.value}"
                      : 'Please fix errors'),
                  // Focusing back to the same field
                  dateField.focus(),
                },
                child: const Text('Show Date Value'),
              ),
              ElevatedButton(
                onPressed: () => {
                  // Notice how the field value is set
                  dateField.value = DateTime.now(),
                  // Focusing back to the same field
                  dateField.focus(),
                },
                child: const Text('Set Current Date'),
              ),
              ElevatedButton(
                onPressed: () => {
                  // Notice how the field value is accessed
                  App.message(isValid
                      ? "Numeric field's values are: Decimal value ${numericField1.value}, Integer value: ${numericField2.value}"
                      : 'Please fix errors'),
                },
                child: const Text('Show Numeric Values'),
              ),
              ElevatedButton(
                onPressed: () => {
                  // Notice how the field value is set
                  numericField1.value = Random().nextDouble() * 10000,
                  numericField2.value = Random().nextInt(1000),
                },
                child: const Text('Set Random Numeric Value'),
              ),
            ]),
          ]))),
    );
  }
}
