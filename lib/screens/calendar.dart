import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Календарь с заметками и временем',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Map<String, String>>> _notes = {}; // Храним заметки с временем

  List<Map<String, String>> _getNotesForDay(DateTime day) {
    return _notes[day] ?? [];
  }

  void _addNoteForDay(DateTime day, String note, String time) {
    setState(() {
      if (_notes[day] == null) {
        _notes[day] = [];
      }
      _notes[day]?.add({'note': note, 'time': time});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Календарь с заметками и временем'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
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
                _focusedDay = _focusedDay;
              });
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: Icon(Icons.arrow_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.arrow_right, color: Colors.white),
              headerPadding: EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Вы выбрали: ${_selectedDay.toLocal()}'.split(' ')[0], // Показывает только дату
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _getNotesForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final note = _getNotesForDay(_selectedDay)[index];
                return ListTile(
                  title: Text(note['note']!),
                  subtitle: Text('Время: ${note['time']}'),
                  tileColor: Colors.lightBlueAccent,
                  contentPadding: EdgeInsets.all(8.0),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showAddNoteDialog() async {
    TextEditingController _noteController = TextEditingController();
    String _selectedTime = '12:00 PM'; // По умолчанию время

    // Функция для выбора времени
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      _selectedTime = pickedTime.format(context);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Добавить заметку'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _noteController,
              decoration: InputDecoration(hintText: 'Введите текст заметки'),
            ),
            SizedBox(height: 16),
            Text('Выбранное время: $_selectedTime'),
          ],
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
                _addNoteForDay(_selectedDay, _noteController.text, _selectedTime);
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
