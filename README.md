# Routerino

[![pub package](https://img.shields.io/pub/v/routerino.svg)](https://pub.dev/packages/routerino)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Add names to routes without a declarative pattern and without build_runner!

This **opinionated** package provides extension methods for `BuildContext` to push and pop routes.

Route names are especially useful for sentry.

## Philosophy

**NO** to a declarative pattern like in [go_router](https://pub.dev/packages/go_router)

**NO** to build_runner

**YES** to type-safety (we call widget constructors directly)

**YES** to sentry integration (named routes)

I just want to push a widget and that's it!

## Motivation

The problems without using this package:

1) Pushing a new route requires lots of boilerplate.
2) Adding a name to the route requires you to write names twice (redundancy).

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => LoginPage(),
    settings: RouteSettings(name: 'LoginPage'), // so redundant!
  ),
);
```

Now you only need to write:

```dart
context.push(() => LoginPage());
```

## Usage

```dart
// push a route
context.push(() => MyPage());

// push a route (no animation)
context.pushImmediately(() => MyPage());

// push a route while removing all others
context.pushRoot(() => MyPage());

// push a route while removing all others (without animation)
context.pushRootImmediately(() => MyPage());

// push a route and removes all routes until the specified one
context.pushAndRemoveUntil(
  removeUntil: LoginPage,
  builder: () => MyPage(),
);

// push a bottom sheet
context.pushBottomSheet(() => MySheet());

// pop the most recent route
context.pop();

// pop until the specified page
context.popUntil(LoginPage);
```

## Global BuildContext

Sometimes you want to push a route while you don't have access to `BuildContext`. There is a pragmatic way to solve this problem.

Setup:
```dart
MaterialApp(
  title: 'Flutter Example',
  navigatorKey: Routerino.navigatorKey, // <-- add this
  home: HomePage(),
);
```

Access global context:
```dart
Routerino.context.push(() => MyPage());
```

## Transitions

You can configure the transition globally or per invocation.

```dart
// Set globally
Routerino.transition = RouterinoTransition.fade;

// uses "fade" transition
context.push(() => LoginPage());

// uses "noTransition" transition
context.push(() => RegisterPage(), transition: RouterinoTransition.noTransition);
```

Available transitions: `material (default)`, `cupertino`, `noTransition`, `fade`.

## Sentry

You want it to look like this?

![sentry](https://raw.githubusercontent.com/Tienisto/routerino/main/resources/sentry.png)

```dart
MaterialApp(
  navigatorObservers: [
    SentryNavigatorObserver(), // add this 
  ],
  home: const InitPage(),
);
```

## Obfuscation

Routes do not have the correct class name if you obfuscate the classes.

It is up to you. I don't value obfuscation that much.

Compiled flutter code is already hard to read.
