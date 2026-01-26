import 'package:flutter/material.dart';
import 'package:routerino/routerino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      navigatorKey: Routerino.navigatorKey,
      navigatorObservers: [RouterinoObserver()],
      home: RouterinoHome(
        builder: () => const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Home Page'),
            ElevatedButton(
              onPressed: () {
                context.push(() => const LoginPage());
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result =
                    await context.pushWithResult<int, PickNumberPage>(
                        () => const PickNumberPage());
                // ignore: avoid_print
                print('RESULT: $result (${result.runtimeType})');
              },
              child: const Text('Pick a number'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push(() => const RemoveBeneathTest());
              },
              child: const Text('Remove beneath'),
            ),
            ElevatedButton(
              onPressed: () {
                context.pushBottomSheet(() => const RouterinoBottomSheet(
                      title: 'My Title',
                      backgroundColor: Colors.green,
                      child: Column(
                        children: [
                          Text('Hello World 1'),
                          Text('Hello World 2'),
                          Text('Hello World 3'),
                        ],
                      ),
                    ));
              },
              child: const Text('Open Bottom Sheet'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Login Page'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.popUntil(HomePage);
                },
                child: const Text('Back to home page'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.push(() => const RegisterPage(),
                      transition: RouterinoTransition.fade());
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Register Page'),
            ElevatedButton(
              onPressed: () {
                context.popUntilRoot();
              },
              child: const Text('Back to home page'),
            ),
          ],
        ),
      ),
    );
  }
}

class PickNumberPage extends StatelessWidget with PopsWithResult<int> {
  const PickNumberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              popWithResult(context, 1);
            },
            child: const Text('Pick 1'),
          ),
          ElevatedButton(
            onPressed: () {
              popWithResult(context, 2);
            },
            child: const Text('Pick 2'),
          ),
        ],
      ),
    );
  }
}

class RemoveBeneathTest extends StatelessWidget {
  const RemoveBeneathTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Remove Beneath: A'),
          ElevatedButton(
            onPressed: () {
              context.push(() => const RemoveBeneathTest2());
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

class RemoveBeneathTest2 extends StatelessWidget {
  const RemoveBeneathTest2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Remove Beneath: B'),
          ElevatedButton(
            onPressed: () {
              context.removeRoute(RemoveBeneathTest);
            },
            child: const Text('Remove A'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Pop'),
          ),
        ],
      ),
    );
  }
}
