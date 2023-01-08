import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routerino/routerino.dart';

/// Extend this class to create your own transition
abstract class RouterinoTransition {
  const RouterinoTransition();

  /// Returns the typed route.
  PageRoute<T> getRoute<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  );

  /// Default flutter transition, it uses cupertino on iOS
  static const material = RouterinoMaterialTransition();

  /// iOS transition (slide to left)
  static const cupertino = RouterinoCupertinoTransition();

  /// No transition
  static const noTransition = RouterinoNoTransition();

  /// Fade transition
  static const fade = RouterinoFadeTransition(Duration(milliseconds: 300));
}

/// Default flutter transition, it uses cupertino on iOS
class RouterinoMaterialTransition extends RouterinoTransition {
  const RouterinoMaterialTransition();

  @override
  PageRoute<T> getRoute<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return MaterialPageRoute(
      builder: (_) => builder(),
      settings: RouteSettings(name: W.toString()),
    );
  }
}

/// iOS transition (slide to left)
class RouterinoCupertinoTransition extends RouterinoTransition {
  const RouterinoCupertinoTransition();

  @override
  PageRoute<T> getRoute<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return CupertinoPageRoute(
      builder: (_) => builder(),
      settings: RouteSettings(name: W.toString()),
    );
  }
}

/// No transition
class RouterinoNoTransition extends RouterinoTransition {
  const RouterinoNoTransition();

  @override
  PageRoute<T> getRoute<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return PageRouteBuilder(
      pageBuilder: (context, a1, a2) => builder(),
      settings: RouteSettings(name: W.toString()),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}

/// Fade transition
class RouterinoFadeTransition extends RouterinoTransition {
  final Duration duration;

  const RouterinoFadeTransition(this.duration);

  @override
  PageRoute<T> getRoute<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return PageRouteBuilder(
      pageBuilder: (context, a1, a2) {
        return FadeTransition(
          opacity: a1,
          child: builder(),
        );
      },
      settings: RouteSettings(name: W.toString()),
      transitionDuration: duration,
      reverseTransitionDuration: duration,
    );
  }
}
