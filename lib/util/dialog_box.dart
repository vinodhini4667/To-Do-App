// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:food/util/bottons_page.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String priority, String dueDate) onSave;
  final VoidCallback onCancel;

  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  String _selectedPriority = 'Low';
  DateTime? _selectedDate;

  List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[100],
      content: SizedBox(
        height: 280,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Task input
            TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Add a New Task...',
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // Priority Dropdown
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              items: _priorities.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Priority',
              ),
            ),

            const SizedBox(height: 15),

            // Due Date Picker
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                _selectedDate == null
                    ? 'Select Due Date'
                    : 'Due Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                style: const TextStyle(color: Colors.blue),
              ),
            ),

            const SizedBox(height: 10),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(text: 'Cancel', onPressed: widget.onCancel),
                MyButton(
                  text: 'Save',
                  onPressed: () {
                    final dueDate = _selectedDate == null
                        ? 'No Date'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!);
                    widget.onSave(_selectedPriority, dueDate);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
