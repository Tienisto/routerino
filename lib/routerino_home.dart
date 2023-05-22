import 'package:flutter/material.dart';
import 'package:routerino/routerino.dart';

/// Add this to the "home" parameter of your MaterialApp.
/// It will push the first route immediately.
/// This is needed to avoid having an unnamed first route.
///
/// Usage:
/// MaterialApp(
///   home: RouterinoHome(
///     builder: () => MyHomePage(),
///   ),
/// );
class RouterinoHome<W extends Widget> extends StatefulWidget {
  final SimpleWidgetBuilder<W> builder;
  final Color? backgroundColor;

  const RouterinoHome({
    required this.builder,
    this.backgroundColor,
    super.key,
  });

  @override
  State<RouterinoHome> createState() => _RouterinoHomeState<W>();
}

class _RouterinoHomeState<W extends Widget> extends State<RouterinoHome> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.pushRootImmediately<void, W>(
        widget.builder as SimpleWidgetBuilder<W>,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color:
          widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
