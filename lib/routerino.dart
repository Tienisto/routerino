import 'dart:async';

import 'package:flutter/material.dart';
import 'package:routerino/transitions.dart';

export 'package:routerino/routerino_home.dart';
export 'package:routerino/transitions.dart';

/// Opinionated widget builder.
/// The widget should use the implicit context declared in a separate widget.
typedef SimpleWidgetBuilder<W extends Widget> = W Function();

typedef SimpleWidgetPopsWithResultBuilder<T, W extends PopsWithResult<T>> = W
    Function();

mixin PopsWithResult<T> on Widget {
  void popWithResult(BuildContext context, T? result) {
    context.pop(result);
  }
}

/// Utility class to provide global access to [BuildContext].
class Routerino {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentContext!;

  /// Set the transition globally
  ///
  /// Example:
  /// Routerino.transition = RouterinoTransition.fade;
  static RouterinoTransition transition = RouterinoTransition.material;
}

extension RouterinoExt on BuildContext {
  /// Pushes a new route.
  Future<T?> push<T, W extends Widget>(SimpleWidgetBuilder<W> builder,
      {RouterinoTransition? transition}) {
    return Navigator.push<T>(
      this,
      (transition ?? Routerino.transition).getRoute<T, W>(builder),
    );
  }

  /// Pushes a new route (no animation).
  Future<T?> pushImmediately<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return Navigator.push<T>(
      this,
      RouterinoTransition.noTransition.getRoute<T, W>(builder),
    );
  }

  /// Pushes a new route while removing all others.
  Future<T?> pushRoot<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder, {
    RouterinoTransition? transition,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      (transition ?? Routerino.transition).getRoute<T, W>(builder),
      (route) => false,
    );
  }

  /// Pushes a new route while removing all others (no animation).
  Future<T?> pushRootImmediately<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return Navigator.pushAndRemoveUntil(
      this,
      RouterinoTransition.noTransition.getRoute<T, W>(builder),
      (route) => false,
    );
  }

  /// Pushes a new route and removes the current one after the transition.
  Future<T?> pushReplacement<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder, {
    RouterinoTransition? transition,
  }) {
    return Navigator.pushReplacement<T, W>(
      this,
      (transition ?? Routerino.transition).getRoute<T, W>(builder),
    );
  }

  /// Pushes a new route expecting a typed result.
  ///
  /// For type-safety, you need to specify the exact generic type
  /// until https://github.com/dart-lang/language/issues/524 gets resolved.
  ///
  /// The push invocation:
  /// final result = await context.pushWithResult<int, PickNumberPage>(() => PickNumberPage());
  ///
  /// The widget:
  /// class PickNumberPage extends StatelessWidget with PopsWithResult<int> {
  /// // ...
  /// popWithResult(context, 1);
  /// // ...
  /// }
  Future<T?> pushWithResult<T, W extends PopsWithResult<T>>(
    SimpleWidgetPopsWithResultBuilder<T, W> builder, {
    T? Function(dynamic result)? onWrongType,
    RouterinoTransition? transition,
  }) async {
    final Object? result = await Navigator.push<T>(
      this,
      (transition ?? Routerino.transition).getRoute<T, W>(() => builder()),
    );

    if (result is T?) {
      return result; // got expected result type
    } else {
      return onWrongType?.call(result); // type does not match
    }
  }

  /// Pushes a new route and removes until the specified type.
  Future<T?> pushAndRemoveUntil<T, W extends Widget>({
    required Type removeUntil,
    required SimpleWidgetBuilder<W> builder,
    RouterinoTransition? transition,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      (transition ?? Routerino.transition).getRoute<T, W>(builder),
      (route) => route.settings.name == removeUntil.toString(),
    );
  }

  /// Pushes a new route and removes until the specified type.
  Future<T?> pushAndRemoveUntilImmediately<T, W extends Widget>({
    required Type removeUntil,
    required SimpleWidgetBuilder<W> builder,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      RouterinoTransition.noTransition.getRoute<T, W>(builder),
      (route) => route.settings.name == removeUntil.toString(),
    );
  }

  /// Pushes a new route and removes until predicate.
  Future<T?> pushAndRemoveUntilPredicate<T, W extends Widget>({
    required RoutePredicate removeUntil,
    required SimpleWidgetBuilder<W> builder,
    RouterinoTransition? transition,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      (transition ?? Routerino.transition).getRoute<T, W>(builder),
      removeUntil,
    );
  }

  /// Pushes a new route and removes until predicate (no animation).
  Future<T?> pushAndRemoveUntilPredicateImmediately<T, W extends Widget>({
    required RoutePredicate removeUntil,
    required SimpleWidgetBuilder<W> builder,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      RouterinoTransition.noTransition.getRoute<T, W>(builder),
      removeUntil,
    );
  }

  /// Pushes a widget sliding from the bottom.
  /// You can use [RouterinoBottomSheet] to quickly bootstrap a widget.
  Future<T?> pushBottomSheet<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return showModalBottomSheet<T>(
      context: this,
      backgroundColor: Colors.transparent,
      elevation: 0,
      routeSettings: RouteSettings(name: W.toString()),
      builder: (context) => builder(),
    );
  }

  /// Pops the most recent route.
  void pop<T>([T? result]) {
    Navigator.pop(this, result);
  }

  /// Pops all routes until there is only one left.
  void popUntilRoot() {
    Navigator.popUntil(this, (route) => route.isFirst);
  }

  /// Pops all routes until the specified page.
  ///
  /// Usage:
  /// context.popUntil(LoginPage);
  void popUntil(Type pageType) {
    Navigator.popUntil(
      this,
      (route) => route.settings.name == pageType.toString(),
    );
  }

  /// Instantly removes the specified page in the history.
  /// Requires [RouterinoObserver] to be added to [MaterialApp].
  ///
  /// Usage:
  /// context.removeRoute(LoginPage);
  void removeRoute(Type pageType) {
    Navigator.removeRoute(
      this,
      _getObserver().getLastByType(pageType),
    );
  }
}

RouterinoObserver _getObserver() {
  if (_routerinoObserver == null) {
    throw 'RouterinoObserver is not initialized. Please add to MaterialApp the following line: "navigatorObservers: [RouterinoObserver()]"';
  }

  return _routerinoObserver!;
}

/// A bottom sheet widget.
/// It is recommended to extend this widget.
class RouterinoBottomSheet extends StatelessWidget {
  final String title;
  final Color? textColor;
  final String? description;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final double maxWidth;
  final Widget child;

  const RouterinoBottomSheet({
    required this.title,
    this.textColor,
    this.description,
    required this.backgroundColor,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 10,
    this.maxWidth = 550,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // center it for tablets
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: EdgeInsets.only(
                // handle safe area
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
              ),
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (description != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: Center(
                          child: Text(
                            description!,
                            style: TextStyle(fontSize: 16, color: textColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    Material(
                      // we need this, otherwise inkwells inside child do not work properly
                      type: MaterialType.transparency,
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

RouterinoObserver? _routerinoObserver;

/// A navigator observer that keeps track of the history.
/// It is required for [Routerino.removeRoute].
///
/// Usage:
/// MaterialApp(
///   navigatorObservers: [RouterinoObserver()], <-- add this
///   ...
/// );
class RouterinoObserver extends NavigatorObserver {
  final history = <Route>[];

  RouterinoObserver() {
    _routerinoObserver = this;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.remove(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute == null || newRoute == null) {
      return;
    }

    final index = history.indexOf(oldRoute);
    if (index == -1) {
      return;
    }

    history[index] = newRoute;
  }

  /// Returns the last route of the specified type.
  Route? getLastByTypeOrNull(Type type) {
    return history.cast<Route?>().lastWhere(
          (element) => element!.settings.name == type.toString(),
          orElse: () => null,
        );
  }

  /// Returns the last route of the specified type.
  /// Throws an exception if not found.
  Route getLastByType(Type type) {
    final route = getLastByTypeOrNull(type);
    if (route == null) {
      throw 'Route of type $type not found';
    }

    return route;
  }
}
