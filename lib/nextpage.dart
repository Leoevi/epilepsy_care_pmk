import 'dart:developer';

import 'package:flutter/material.dart';


class NextPage extends StatelessWidget {
  const NextPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text("Second Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is another page',
            ),
            Text(
              'bruh',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,
            ),
            TextButton(
                onPressed: () { Navigator.pop(context); },
                child: Text("Hello Second page")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}