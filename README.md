# named_routes

[![pub package](https://img.shields.io/pub/v/named_routes.svg)](https://pub.dev/packages/named_routes)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Add names to routes without a declarative pattern and without build_runner!

This **opinionated** package provides extension methods for `BuildContext` to push and pop routes.

Route names are especially useful for sentry.

## Philosophy

**NO** to declaration of all routes like in [go_router](https://pub.dev/packages/go_router)

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
context.popUntilPage<LoginPage>();
```

## Sentry

You want it to look like this?

![sentry](https://raw.githubusercontent.com/Tienisto/named_routes/main/resources/sentry.png)

```dart
MaterialApp(
  navigatorObservers: [
    SentryNavigatorObserver(), // add this 
  ],
  home: const InitPage(),
);
```

## Obfuscation

It does not work if you obfuscate the classes.

It is up to you. I don't value obfuscation that much.

Compiled flutter code is already hard to read.
