import 'package:flutter/material.dart';

/// Opinionated widget builder.
/// The widget should use the implicit context declared in a separate widget.
typedef SimpleWidgetBuilder<W extends Widget> = W Function();

/// Utility class to provide global access to [BuildContext].
class Routerino {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get context => navigatorKey.currentContext!;
}

extension RouterinoExt on BuildContext {
  /// Pushes a new route.
  Future<T?> push<T, W extends Widget>(SimpleWidgetBuilder<W> builder) {
    return Navigator.push<T>(
      this,
      _getMaterialRoute<T, W>(builder),
    );
  }

  /// Pushes a new route (no animation).
  Future<T?> pushImmediately<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return Navigator.push<T>(
      this,
      _getNoAnimationRoute<T, W>(builder),
    );
  }

  /// Pushes a new route while removing all others.
  Future<T?> pushRoot<T, W extends Widget>(SimpleWidgetBuilder<W> builder) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getMaterialRoute<T, W>(builder),
      (route) => false,
    );
  }

  /// Pushes a new route while removing all others (no animation).
  Future<T?> pushRootImmediately<T, W extends Widget>(
      SimpleWidgetBuilder<W> builder) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getNoAnimationRoute<T, W>(builder),
      (route) => false,
    );
  }

  /// Pushes a new route and removes until the specified type.
  Future<T?> pushAndRemoveUntil<T, W extends Widget>({
    required Type removeUntil,
    required SimpleWidgetBuilder<W> builder,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getMaterialRoute<T, W>(builder),
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
      _getNoAnimationRoute<T, W>(builder),
      (route) => route.settings.name == removeUntil.toString(),
    );
  }

  /// Pushes a new route and removes until predicate.
  Future<T?> pushAndRemoveUntilPredicate<T, W extends Widget>({
    required RoutePredicate removeUntil,
    required SimpleWidgetBuilder<W> builder,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getMaterialRoute<T, W>(builder),
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
      _getNoAnimationRoute<T, W>(builder),
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
    Navigator.popUntil(this, (route) => route.settings.name == pageType.toString());
  }
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

PageRoute<T> _getMaterialRoute<T, W extends Widget>(
  SimpleWidgetBuilder<W> builder,
) {
  return MaterialPageRoute(
    builder: (_) => builder(),
    settings: RouteSettings(name: W.toString()),
  );
}

PageRoute<T> _getNoAnimationRoute<T, W extends Widget>(
  SimpleWidgetBuilder<W> builder,
) {
  return PageRouteBuilder(
    pageBuilder: (context, a1, a2) => builder(),
    settings: RouteSettings(name: W.toString()),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}
