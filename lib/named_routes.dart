import 'package:flutter/material.dart';

/// Opinionated widget builder.
/// The widget should use the implicit context declared in a separate widget.
typedef SimpleWidgetBuilder<W extends Widget> = W Function();

extension NamedRoutesExt on BuildContext {
  /// Pushes a new route
  Future<T?> push<T, W extends Widget>(SimpleWidgetBuilder<W> builder) {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(
        builder: (_) => builder(),
        settings: RouteSettings(name: W.toString()),
      ),
    );
  }

  /// Pushes a new route while removing all others
  Future<T?> pushRoot<T, W extends Widget>(SimpleWidgetBuilder<W> builder) {
    return Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(
        builder: (_) => builder(),
        settings: RouteSettings(name: W.toString()),
      ),
      (route) => false,
    );
  }

  /// Pushes a new route while removing all others (no animation)
  Future<T?> pushRootNoAnimation<T, W extends Widget>(
      SimpleWidgetBuilder<W> builder) {
    return Navigator.pushAndRemoveUntil(
      this,
      _NoAnimationRoute(
        builder: (_) => builder(),
        settings: RouteSettings(name: W.toString()),
      ),
      (route) => false,
    );
  }
}

/// Route builder without animation
class _NoAnimationRoute<T> extends MaterialPageRoute<T> {
  _NoAnimationRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          maintainState: maintainState,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
