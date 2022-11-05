import 'package:flutter/material.dart';

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

extension NamedRoutesExt on BuildContext {
  /// Pushes a new route.
  Future<T?> push<T, W extends Widget>(SimpleWidgetBuilder<W> builder) {
    return Navigator.push<T>(
      this,
      _getMaterialRoute(builder),
    );
  }

  /// Pushes a new route (no animation).
  Future<T?> pushImmediately<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return Navigator.push<T>(
      this,
      _getNoAnimationRoute(builder),
    );
  }

  /// Pushes a new route and returns the result of type [T].
  /// [T] is inferred by the pushed widget which needs to specify the type in the [PopsWithResult] mixin.
  /// If somehow the result is not of type [T], then null will be returned.
  /// This behaviour can be overridden or listened to by specifying [onWrongType].
  ///
  /// class NumberPickerPage extends StatelessWidget with PopsWithResult<int> {
  /// ...
  /// }
  ///
  /// final int? result = await context.pushTypedResult(() => NumberPickerPage(), onWrongType: (result) {
  ///   print('Wrong type: $result');
  ///   return null;
  /// });
  Future<T?> pushTypedResult<T, W extends PopsWithResult<T>>(
    SimpleWidgetPopsWithResultBuilder<T, W> builder, {
    T? Function(dynamic result)? onWrongType,
  }) async {
    final Object? result = await Navigator.push(
      this,
      _getMaterialRoute(builder),
    );

    if (result is T?) {
      return result; // got expected result type
    } else {
      return onWrongType?.call(result); // type does not match
    }
  }

  /// Pushes a new route while removing all others.
  Future<T?> pushRoot<T, W extends Widget>(SimpleWidgetBuilder<W> builder) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getMaterialRoute(builder),
      (route) => false,
    );
  }

  /// Pushes a new route while removing all others (no animation).
  Future<T?> pushRootImmediately<T, W extends Widget>(
      SimpleWidgetBuilder<W> builder) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getNoAnimationRoute(builder),
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
      _getMaterialRoute(builder),
      (route) => route.settings.name == removeUntil.toString(),
    );
  }

  /// Pushes a new route and removes until the specified type.
  Future<T?> pushAndRemoveUntilImmediately<T, W extends Widget>({
    required T removeUntilPage,
    required SimpleWidgetBuilder<W> builder,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getNoAnimationRoute(builder),
      (route) => route.settings.name == removeUntilPage.toString(),
    );
  }

  /// Pushes a new route and removes until predicate.
  Future<T?> pushAndRemoveUntilPredicate<T, W extends Widget>({
    required RoutePredicate removeUntil,
    required SimpleWidgetBuilder<W> builder,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      _getMaterialRoute(builder),
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
      _getNoAnimationRoute(builder),
      removeUntil,
    );
  }

  /// Pushes a widget sliding from the bottom.
  /// You can use [NamedRoutesBottomSheet] to quickly bootstrap a widget.
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
  /// context.popUntilPage<LoginPage>();
  void popUntilPage<W extends Widget>() {
    Navigator.popUntil(this, (route) => route.settings.name == W.toString());
  }
}

/// A bottom sheet widget.
/// It is recommended to extend this widget.
class NamedRoutesBottomSheet extends StatelessWidget {
  final String title;
  final Color? textColor;
  final String? description;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double maxWidth;
  final Widget child;

  const NamedRoutesBottomSheet({
    required this.title,
    this.textColor,
    this.description,
    required this.backgroundColor,
    this.padding = const EdgeInsets.all(20),
    this.maxWidth = 550,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: IntrinsicHeight(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom, // handle safe area
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: padding,
              child: Column(
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
