import 'package:flutter/material.dart';
import 'package:named_routes/named_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
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
                  context.push(() => RegisterPage());
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

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int? number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Register Page'),
            Text('Number: $number'),
            ElevatedButton(
              onPressed: () async {
                final int? result = await context.pushTypedResult(() => NumberPickerPage(), onWrongType: (result) {
                  print('Wrong type: $result');
                  return null;
                });
                if (result != null) {
                  setState(() => number = result);
                }
              },
              child: Text('Pick Number'),
            ),
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

class NumberPickerPage extends StatelessWidget with PopsWithResult<int> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('NumberPicker'),
            for (final i in [1, 2, 3])
              ElevatedButton(
                onPressed: () {
                  popWithResult(context, i);
                },
                child: Text(i.toString()),
              ),
            ElevatedButton(
              onPressed: () {
                context.pop('A');
              },
              child: Text('A'),
            ),
          ],
        ),
      ),
    );
  }
}

