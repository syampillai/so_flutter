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
          child: Column(children: [
        ElevatedButton(
          onPressed: () => App.goTo(_SecondScreen()), // Jump to another screen
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
          onPressed: () => App.message('Entry deleted!',
              MessageAction('Undo', () => App.message('Undelete successful!'))),
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

// Example of a [DataScreen] used for entering some data.
class _DataEntry extends DataScreen {
  /// Build method. Note: It should return a [Scaffold].
  @override
  Scaffold build(BuildContext context) {
    // Create a text field.
    Field<String> textField = this.textField(
      initialValue: 'Hello',
      decoration: const InputDecoration(hintText: 'Enter your name'),
      autofocus: true,
    );
    // Create a date field.
    Field<DateTime> dateField = this.dateField(
      initialValue: DateTime(1998, 1, 23),
      decoration: const InputDecoration(hintText: 'Enter your date of birth'),
    );
    // Now create the component tree.
    return Scaffold(
      appBar: AppBar(title: const Text('Data Entry Example')),
      body: Form(
          key: formKey, // The built-in key you can use as the form-key
          child: Column(
            children: [
              textField,
              dateField,
              ElevatedButton(
                onPressed: () => {
                  // Notice how rhe field value is accessed
                  App.message("Text field's value is ${textField.value}"),
                  textField.focus(),
                },
                child: const Text('Show Text Value'),
              ),
              ElevatedButton(
                onPressed: () => {
                  // Notice how rhe field value is set
                  textField.value = 'New Text value',
                  textField.focus(),
                },
                child: const Text('Set Text Value'),
              ),
              ElevatedButton(
                onPressed: () => {
                  // Notice how rhe field value is accessed
                  App.message("Text field's value is ${dateField.value}"),
                  textField.focus(),
                },
                child: const Text('Show Date Value'),
              ),
            ],
          )),
    );
  }
}
