import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clicker Game',
      home: const ClickerScreen(),
    );
  }
}

class ClickerScreen extends StatefulWidget {
  const ClickerScreen({Key? key}) : super(key: key);

  @override
  _ClickerScreenState createState() => _ClickerScreenState();
}

class _ClickerScreenState extends State<ClickerScreen> {
  int _counter = 0;

  // Метод для увеличения счетчика
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clicker Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Нажмите на кнопку:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_counter',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _incrementCounter,  // Увеличить счетчик
              child: const Text('Нажми на меня!'),
            ),
          ],
        ),
      ),
    );
  }
}
