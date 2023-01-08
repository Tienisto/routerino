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
      home: HomePage(),
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
                  context.popUntilRoot();
                },
                child: Text('Back to home page'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.push(() => RegisterPage(), transition: RouterinoTransition.fade);
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
