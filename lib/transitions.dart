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

  /// Fade transition in milliseconds
  static int fadeDuration = 300;

  /// Fade transition
  static get fade =>
      RouterinoFadeTransition(Duration(milliseconds: fadeDuration));

  /// Slide transition in milliseconds
  static int slideDuration = 300;

  /// Slide transition
  static RouterinoTransition slide({
    SlideDirection direction = SlideDirection.rightToLeft,
    Curve curve = Curves.linear,
  }) =>
      RouterinoSlideTransition(
        direction: direction,
        duration: Duration(milliseconds: slideDuration),
        curve: curve,
      );

  /// Slide transition
  /// where the current page slides out and the new page slides in.
  ///
  /// Usage:
  /// context.push(() => LoginPage(), transition: RouterinoTransition.slideJoined(this));
  static RouterinoTransition slideJoined(
    Widget currentPage, {
    SlideDirection direction = SlideDirection.rightToLeft,
    Curve curve = Curves.linear,
  }) =>
      RouterinoSlideJoinedTransition(
        direction: direction,
        duration: Duration(milliseconds: slideDuration),
        curve: curve,
        currentPage: currentPage,
      );
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

enum SlideDirection {
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
}

/// Slide transition
class RouterinoSlideTransition extends RouterinoTransition {
  final SlideDirection direction;
  final Duration duration;
  final Curve curve;

  const RouterinoSlideTransition({
    this.direction = SlideDirection.rightToLeft,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
  });

  @override
  PageRoute<T> getRoute<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return PageRouteBuilder(
      pageBuilder: (context, a1, a2) => builder(),
      transitionsBuilder: (context, a1, a2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: switch (direction) {
              SlideDirection.rightToLeft => const Offset(1.0, 0.0),
              SlideDirection.leftToRight => const Offset(-1.0, 0.0),
              SlideDirection.topToBottom => const Offset(0.0, -1.0),
              SlideDirection.bottomToTop => const Offset(0.0, 1.0),
            },
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: a1,
              curve: curve,
            ),
          ),
          child: child,
        );
      },
      settings: RouteSettings(name: W.toString()),
      transitionDuration: duration,
      reverseTransitionDuration: duration,
    );
  }
}

/// Slide transition
/// where the current page slides out and the new page slides in.
class RouterinoSlideJoinedTransition extends RouterinoTransition {
  final SlideDirection direction;
  final Duration duration;
  final Curve curve;
  final Widget currentPage;

  const RouterinoSlideJoinedTransition({
    this.direction = SlideDirection.rightToLeft,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    required this.currentPage,
  });

  @override
  PageRoute<T> getRoute<T, W extends Widget>(
    SimpleWidgetBuilder<W> builder,
  ) {
    return PageRouteBuilder(
      pageBuilder: (context, a1, a2) => builder(),
      transitionsBuilder: (context, a1, a2, child) {
        return Stack(
          children: [
            SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0.0, 0.0),
                      end: switch (direction) {
                        SlideDirection.rightToLeft => const Offset(-1.0, 0.0),
                        SlideDirection.leftToRight => const Offset(1.0, 0.0),
                        SlideDirection.topToBottom => const Offset(0.0, 1.0),
                        SlideDirection.bottomToTop => const Offset(0.0, -1.0),
                      })
                  .animate(
                CurvedAnimation(
                  parent: a1,
                  curve: curve,
                ),
              ),
              child: currentPage,
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: switch (direction) {
                  SlideDirection.rightToLeft => const Offset(1.0, 0.0),
                  SlideDirection.leftToRight => const Offset(-1.0, 0.0),
                  SlideDirection.topToBottom => const Offset(0.0, -1.0),
                  SlideDirection.bottomToTop => const Offset(0.0, 1.0),
                },
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: a1,
                  curve: curve,
                ),
              ),
              child: child,
            )
          ],
        );
      },
      settings: RouteSettings(name: W.toString()),
      transitionDuration: duration,
      reverseTransitionDuration: duration,
    );
  }
}
