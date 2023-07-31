# Routerino

[![pub package](https://img.shields.io/pub/v/routerino.svg)](https://pub.dev/packages/routerino)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This **opinionated** package provides extension methods for `BuildContext` to push and pop routes.

## Philosophy

➤ **NO** to a verbose declarative pattern like in [go_router](https://pub.dev/packages/go_router)

> Having all routes in one place is good but this information is already available if you write all routes in `views/` or `pages/`.
> 
> Furthermore, you often find yourself jumping between several files to either find the parameters
> or to find the widget.

➤ **NO** to build_runner

> This is necessary for type-safety, but it slows down development and decreases the developer UX.

➤ **YES** to type-safety

> We call widget constructors directly. Don't pass arbitrary objects via route settings!

➤ **YES** to sentry integration

> Every route will have a name based on its class name. This is useful for sentry.

➤ **TLDR**

> I just want to push a widget and that's it!

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

// push a route and remove the current one
context.pushReplacement(() => MyPage());

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

// pop until the first page
context.popUntilRoot();

// remove a route from the stack
context.removeRoute(MyPage);

// push a route and wait for a result (type-safe)
final result = await context.pushWithResult<int, PickNumberPage>(() => PickNumberPage());
```

## Initial Route

It is recommended to add a `RouterinoHome` widget to your app.

This prevents having an unnamed initial route which causes trouble if you want to use `popUntil`.

```dart
MaterialApp(
  title: 'Flutter Example',
  home: RouterinoHome( // <-- add this
    builder: () => MyHomePage(),
  ),
);

context.popUntil(MyHomePage); // <-- works now
```

## Global BuildContext

Sometimes you want to push a route while you don't have access to `BuildContext`. There is a pragmatic way to solve this problem.

Setup:
```dart
MaterialApp(
  title: 'Flutter Example',
  navigatorKey: Routerino.navigatorKey, // <-- add this
  home: RouterinoHome(
    builder: () => MyHomePage(),
  ),
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

Available transitions: `material (default)`, `cupertino`, `noTransition`, `fade`, `slide`, `slideJoined`.

## Type-safe Results

You can push a route and wait for a result while achieving a high degree of type-safety.

You need to specify the exact generic type until https://github.com/dart-lang/language/issues/524 gets resolved.

Push a route:

```dart
final result = await context.pushWithResult<int, PickNumberPage>(() => PickNumberPage());
```

Specify the widget:

```dart
// add PopsWithResult<int> for type-safety
class PickNumberPage extends StatelessWidget with PopsWithResult<int> {
  const PickNumberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // use the type-safe popWithResult method
            popWithResult(context, 123);
          },
          child: Text('Pick Number'),
        ),
      ),
    );
  }
}
```

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

Routes do not have the correct class names if you enable Flutter obfuscation which makes sentry integration useless.

It is up to you. I don't value obfuscation that much.

Compiled flutter code is already hard to read.
