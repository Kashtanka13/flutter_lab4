import 'package:flutter/material.dart';

class Note {
  String title;
  String description;

  Note({
    required this.title,
    required this.description,
  });
}

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Note> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addNote() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      setState(() {
        _notes.add(Note(
          title: _titleController.text,
          description: _descriptionController.text,
        ));
        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  void _removeNoteAt(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Заголовок'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
            ),
          ),
          ElevatedButton(
            onPressed: _addNote,
            child: Text('Добавить'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notes[index].title),
                  subtitle: Text(_notes[index].description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeNoteAt(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
