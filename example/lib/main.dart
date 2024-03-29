import 'package:flutter/material.dart';
import 'package:routerino/routerino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      navigatorKey: Routerino.navigatorKey,
      navigatorObservers: [RouterinoObserver()],
      home: RouterinoHome(
        builder: () => HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
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
                context.push(() => LoginPage());
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await context.pushWithResult<int, PickNumberPage>(() => PickNumberPage());
                print('RESULT: $result (${result.runtimeType})');
              },
              child: Text('Pick a number'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push(() => RemoveBeneathTest());
              },
              child: Text('Remove beneath'),
            ),
            ElevatedButton(
              onPressed: () {
                context.pushBottomSheet(() => RouterinoBottomSheet(
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
              child: Text('Open Bottom Sheet'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
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
                child: Text('Back to home page'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.push(() => RegisterPage(), transition: RouterinoTransition.fade());
                },
                child: Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
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
              child: Text('Back to home page'),
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
            child: Text('Pick 1'),
          ),
          ElevatedButton(
            onPressed: () {
              popWithResult(context, 2);
            },
            child: Text('Pick 2'),
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
              context.push(() => RemoveBeneathTest2());
            },
            child: Text('Next'),
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
            child: Text('Remove A'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
            },
            child: Text('Pop'),
          ),
        ],
      ),
    );
  }
}
