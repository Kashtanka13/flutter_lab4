import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

// Модель игры
class ColorGuessingGameModel extends ChangeNotifier {
  final Random _random = Random();
  Color _targetColor = Colors.red;
  String _feedback = 'Угадай цвет!';
  int _guesses = 0;

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.teal,
    Colors.pink,
    Colors.brown,
  ];

  ColorGuessingGameModel() {
    _resetGame();
  }

  Color get targetColor => _targetColor;
  String get feedback => _feedback;
  int get guesses => _guesses;

  void _resetGame() {
    // Сгенерируем случайный цвет из списка
    _targetColor = colors[_random.nextInt(colors.length)];
    _feedback = 'Угадай цвет!';
    _guesses = 0;
    notifyListeners();
  }

  void makeGuess(Color guess) {
    _guesses++;
    if (guess == _targetColor) {
      _feedback = 'Правильно! Это цвет ${_getColorName(_targetColor)}.';
    } else {
      _feedback = 'Неверно! Попробуй снова.';
    }
    notifyListeners();
  }

  String _getColorName(Color color) {
    if (color == Colors.red) {
      return 'красный';
    } else if (color == Colors.green) {
      return 'зеленый';
    } else if (color == Colors.blue) {
      return 'синий';
    } else if (color == Colors.yellow) {
      return 'желтый';
    } else if (color == Colors.orange) {
      return 'оранжевый';
    } else if (color == Colors.purple) {
      return 'пурпурный';
    } else if (color == Colors.cyan) {
      return 'голубой';
    } else if (color == Colors.teal) {
      return 'бирюзовый';
    } else if (color == Colors.pink) {
      return 'розовый';
    } else if (color == Colors.brown) {
      return 'коричневый';
    } else {
      return 'неизвестный';
    }
  }

  void resetGame() {
    _resetGame();
  }
}

// Страница игры
class ColorGuessingGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ColorGuessingGameModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Угадай цвет!'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  model.feedback,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Отображаем правильный цвет как контейнер
                Container(
                  width: 200,
                  height: 200,
                  color: model.targetColor,
                  child: Center(
                    child: Text(
                      '???',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Кнопки для угадывания цвета без фона
                _buildColorButton(context, model, Colors.red, 'Красный'),
                _buildColorButton(context, model, Colors.green, 'Зеленый'),
                _buildColorButton(context, model, Colors.blue, 'Синий'),
                _buildColorButton(context, model, Colors.yellow, 'Желтый'),
                _buildColorButton(context, model, Colors.orange, 'Оранжевый'),
                _buildColorButton(context, model, Colors.purple, 'Пурпурный'),
                _buildColorButton(context, model, Colors.cyan, 'Голубой'),
                _buildColorButton(context, model, Colors.teal, 'Бирюзовый'),
                _buildColorButton(context, model, Colors.pink, 'Розовый'),
                _buildColorButton(context, model, Colors.brown, 'Коричневый'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    model.resetGame();
                  },
                  child: Text('Сбросить игру'),
                ),
                SizedBox(height: 20),
                Text(
                  'Попытки: ${model.guesses}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Функция для создания кнопки без фона
  TextButton _buildColorButton(
      BuildContext context, ColorGuessingGameModel model, Color color, String label) {
    return TextButton(
      onPressed: () {
        model.makeGuess(color);
      },
      child: Text(
        label,
        style: TextStyle(
          color: color, // Цвет текста кнопки будет соответствовать цвету, который нужно угадать
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ColorGuessingGameModel(),
      child: MaterialApp(
        title: 'Color Guessing Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ColorGuessingGamePage(),
      ),
    ),
  );
}
