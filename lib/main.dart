import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // Для форматирования дат
import 'screens/notes.dart';  // Экран для заметок
import 'screens/calendar.dart';  // Экран календаря
import 'screens/jump.dart';  // Подключение экрана игры с цветами
import 'screens/contacts.dart';  // Экран для контактов
import 'screens/clicker.dart';  // Экран для кликера (новый экран)

void main() {
  runApp(GameNotesApp());
}

class GameNotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ru', 'RU'), // Русская локализация
      ],
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CalendarScreen(),
    ColorGuessingGameScreen(),  // Экран игры с цветами
    NotesScreen(),
    ContactsScreen(),  // Экран для контактов
    ClickerScreen(),  // Экран кликера
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Календарь'),
          BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset), label: 'Цветовая игра'),
  
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Заметки'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Контакты'),
          BottomNavigationBarItem(
              icon: Icon(Icons.touch_app), label: 'Кликер'),  // Новый пункт для кликера
        ],
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime _currentDay = DateTime.now(); // Текущая дата

  Map<DateTime, List<String>> _notes = {};

  List<String> _getNotesForDay(DateTime day) {
    return _notes[day] ?? [];
  }

  void _addNoteForDay(DateTime day, String note) {
    setState(() {
      if (_notes[day] == null) {
        _notes[day] = [];
      }
      _notes[day]?.add(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рабочий календарь'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Сегодня: ${DateFormat('d MMMM yyyy', 'ru_RU').format(_currentDay)}', // Форматирование сегодняшней даты
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: _getNotesForDay,
            locale: 'ru_RU', // Устанавливаем локализацию на русский
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _getNotesForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_getNotesForDay(_selectedDay)[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddNoteDialog() {
    TextEditingController _noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Добавить заметку'),
        content: TextField(
          controller: _noteController,
          decoration: InputDecoration(hintText: 'Введите текст заметки'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (_noteController.text.isNotEmpty) {
                _addNoteForDay(_selectedDay, _noteController.text);
              }
              Navigator.of(context).pop();
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

class ColorGuessingGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Игра с цветами'),
      ),
      body: ColorGuessingGame(),
    );
  }
}

class ColorGuessingGame extends StatefulWidget {
  @override
  _ColorGuessingGameState createState() => _ColorGuessingGameState();
}

class _ColorGuessingGameState extends State<ColorGuessingGame> {
  Color _targetColor = Colors.red;
  String _feedback = "Угадайте цвет!";
  int _attempts = 0;

  void _makeGuess(Color color) {
    setState(() {
      _attempts++;
      if (color == _targetColor) {
        _feedback = "Правильно!";
      } else {
        _feedback = "Попробуйте снова!";
      }
    });
  }

  void _resetGame() {
    setState(() {
      _targetColor = _generateRandomColor();
      _feedback = "Угадайте цвет!";
      _attempts = 0;
    });
  }

  Color _generateRandomColor() {
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
      Colors.brown
    ];
    colors.shuffle();
    return colors.first;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _feedback,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Container(
            width: 200,
            height: 200,
            color: _targetColor,
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
          ..._buildColorButtons(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Сбросить игру'),
          ),
          SizedBox(height: 20),
          Text(
            'Попытки: $_attempts',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildColorButtons() {
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
      Colors.brown
    ];

    return colors.map((color) {
      return TextButton(
        onPressed: () => _makeGuess(color),
        child: Text(
          _getColorName(color),
          style: TextStyle(color: color),
        ),
      );
    }).toList();
  }

  String _getColorName(Color color) {
    if (color == Colors.red) return "Красный";
    if (color == Colors.green) return "Зеленый";
    if (color == Colors.blue) return "Синий";
    if (color == Colors.yellow) return "Желтый";
    if (color == Colors.orange) return "Оранжевый";
    if (color == Colors.purple) return "Пурпурный";
    if (color == Colors.cyan) return "Голубой";
    if (color == Colors.teal) return "Бирюзовый";
    if (color == Colors.pink) return "Розовый";
    return "Коричневый";
  }
}

class ClickerScreen extends StatefulWidget {
  @override
  _ClickerScreenState createState() => _ClickerScreenState();
}

class _ClickerScreenState extends State<ClickerScreen> {
  int _clickCount = 0;  // Переменная для отслеживания количества кликов

  // Метод для увеличения количества кликов
  void _incrementCounter() {
    setState(() {
      _clickCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кликер'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Количество кликов:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              '$_clickCount',  // Отображение количества кликов
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
            onPressed: _incrementCounter,  // При нажатии увеличиваем счетчик
            child: Text('Нажми меня!'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,  // Используем backgroundColor вместо primary
              foregroundColor: Colors.white,  // Устанавливаем цвет текста кнопки
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: TextStyle(fontSize: 20),
  
            ),

            ),
          ],
        ),
      ),
    );
  }
}
