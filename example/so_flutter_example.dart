import 'package:flutter/material.dart';
import 'package:so_flutter/so_flutter.dart';

/// Main
main() {
  App app = App(); // New app created.
  // At this point, if you run this, you will get a "Hello World" screen.

  app.home =
      _FirstScreen(); // Set the home screen, instead of the default "Hello World" screen.
  app.run(); // Now, run the app.
}

// Example of a "stateless" screen.
class _FirstScreen extends StatelessScreen {
  // Build method. Note: It should return a [Scaffold].
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Column(children: [
        ElevatedButton(
          onPressed: () => App.goTo(_SecondScreen()), // Jump to another screen
          child: const Text(
            'Move to 2nd Screen',
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
      ]),
    );
  }
}

/// Example of a "stateful" screen.
class _SecondScreen extends StatefulScreen {
  // Build method. Note: It should return a [Scaffold].
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
  // Build method. Note: It should return a [Scaffold].
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
