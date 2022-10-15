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

  /// Pushes a new route (no animation)
  Future<T?> pushImmediately<T, W extends Widget>(
      SimpleWidgetBuilder<W> builder) {
    return Navigator.push<T>(
      this,
      _getNoAnimationRoute(builder),
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
  Future<T?> pushRootImmediately<T, W extends Widget>(
      SimpleWidgetBuilder<W> builder) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getNoAnimationRoute(builder),
      (route) => false,
    );
  }

  /// Pushes a new route and removes until predicate
  Future<T?> pushAndRemoveUntil<T, W extends Widget>({
    required RoutePredicate removeUntil,
    required SimpleWidgetBuilder<W> builder,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(
        builder: (_) => builder(),
        settings: RouteSettings(name: W.toString()),
      ),
      removeUntil,
    );
  }

  /// Pushes a new route and removes until predicate (no animation)
  Future<T?> pushAndRemoveUntilImmediately<T, W extends Widget>({
    required RoutePredicate removeUntil,
    required SimpleWidgetBuilder<W> builder,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getNoAnimationRoute(builder),
      removeUntil,
    );
  }

  /// Pops the most recent route
  void pop<T>([T? result]) {
    Navigator.pop(this, result);
  }

  /// Pops all routes until there is only one left
  void popUntilRoot() {
    Navigator.popUntil(this, (route) => route.isFirst);
  }

  /// Pops all routes until the specified page
  ///
  /// Usage:
  /// context.popUntilPage<LoginPage>();
  void popUntilPage<W extends Widget>() {
    Navigator.popUntil(this, (route) => route.settings.name == W.toString());
  }
}

PageRoute<T> _getNoAnimationRoute<T, W extends Widget>(SimpleWidgetBuilder<W> builder) {
  return PageRouteBuilder(
    pageBuilder: (context, a1, a2) => builder(),
    settings: RouteSettings(name: W.toString()),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}
