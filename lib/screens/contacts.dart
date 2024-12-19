import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Map<String, String>> contacts = [];  // Список контактов

  // Контроллеры для ввода имени и телефона
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  // Функция для добавления контакта в список
  void _addContact() {
    final name = _nameController.text;
    final phone = _phoneController.text;

    if (name.isNotEmpty && phone.isNotEmpty) {
      setState(() {
        contacts.add({'name': name, 'phone': phone});
      });

      // Очистить поля ввода после добавления
      _nameController.clear();
      _phoneController.clear();

      // Закрыть клавиатуру
      FocusScope.of(context).unfocus();
    } else {
      // Показать ошибку, если не все поля заполнены
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, заполните все поля!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Контакты"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Поле для ввода имени
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Имя",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                // Поле для ввода телефона
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Телефон",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                // Кнопка для добавления контакта
                ElevatedButton(
                  onPressed: _addContact,
                  child: Text('Добавить контакт'),
                ),
              ],
            ),
          ),
          Expanded(
            child: contacts.isEmpty
                ? Center(child: Text("Здесь будет список ваших контактов"))
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ListTile(
                        leading: Icon(Icons.contact_phone),
                        title: Text(contact['name'] ?? ''),
                        subtitle: Text(contact['phone'] ?? ''),
                        onTap: () {
                          // Логика для обработки нажатия на контакт
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Вы выбрали ${contact['name']}')),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
