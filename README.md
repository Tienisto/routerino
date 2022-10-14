# named_routes

[![pub package](https://img.shields.io/pub/v/named_routes.svg)](https://pub.dev/packages/named_routes)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This opinionated package provides extension methods for `BuildContext` to push routes.

...and automatically add a name to the route so you can track it in sentry!

## Overview

**NO** to declaration of all routes aka [go_router](https://pub.dev/packages/go_router)

**NO** to build_runner

**YES** to type-safety (we call widget constructors directly)

**YES** to sentry integration (named routes)

I just want to push a widget and that's it!

The problems without this package:

1) Pushing a new route requires lots of boilerplate.
2) Adding a name to the route requires you to write things twice (redundancy).

```dart
Navigator.push<T>(
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
// push a new route
context.push(() => MyPage());

// push a route while removing all others
context.pushRoot(() => MyPage());

// push a route while removing all others (without animation)
context.pushRootNoAnimation(() => MyPage());

// pop the most recent route
context.pop();
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
