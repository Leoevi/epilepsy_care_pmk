import 'package:flutter/material.dart';

/// An abstract class that watches lifecycle state. Can be extended by other
/// stateful widget and make it do whatever we want on each lifecycle events by
/// overriding them.
///
/// from: https://stackoverflow.com/a/61427824
abstract class LifecycleWatcherState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      default:
        break;
    }
  }

  void onResumed();
  void onPaused();
  void onInactive();
  void onDetached();
}