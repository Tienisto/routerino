# named_routes

This opinionated package provides extension methods for `BuildContext` to push routes.

...and automatically add a name to the route so you can track it in sentry!

## Motivation

I don't like to manually declare all routes.

I don't want to use `build_runner` to have type-safe routes.

I want to be able to track routes in sentry: Every route has to have a name!

I just want to push a widget and that's it!

The problems:

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

## Solution

Let's keep it minimal: `context.push(() => MyWidget())`

The name will be obtained by implicit generics.

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
