// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:food/database/data_base.dart';
import 'package:food/util/dialog_box.dart';
import 'package:food/util/todo_tail.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mybox = Hive.box("mybox");
  final _controller = TextEditingController();
  final _searchController = TextEditingController();

  ToDoDataBase db = ToDoDataBase();

  String _filterPriority = 'All';
  bool _sortByDate = false;

  @override
  void initState() {
    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loaddata();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false, "Low", "No Date"]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void cancelTask() {
    _controller.clear();
    Navigator.of(context).pop();
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void _add() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onCancel: () => Navigator.pop(context),
          onSave: (priority, dueDate) {
            setState(() {
              db.toDoList.add([
                _controller.text,
                false,
                priority,
                dueDate,
              ]);
            });
            _controller.clear();
            Navigator.pop(context);
            db.updateDataBase();
          },
        );
      },
    );
  }

  List get _filteredTasks {
    final query = _searchController.text.toLowerCase();

    List tasks = db.toDoList.where((task) {
      final matchesPriority = _filterPriority == 'All' || task[2] == _filterPriority;
      final matchesSearch = task[0].toLowerCase().contains(query);
      return matchesPriority && matchesSearch;
    }).toList();

    if (_sortByDate) {
      tasks.sort((a, b) {
        if (a[3] == 'No Date') return 1;
        if (b[3] == 'No Date') return -1;
        return a[3].compareTo(b[3]);
      });
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Center(
          child: Text(
            "Today's List",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              children: [
                // Search bar
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Search tasks...",
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Sort button
                IconButton(
                  icon: Icon(Icons.sort_by_alpha),
                  tooltip: "Sort by Date",
                  onPressed: () {
                    setState(() {
                      _sortByDate = !_sortByDate;
                    });
                  },
                ),
                // Priority Filter
                DropdownButton<String>(
                  value: _filterPriority,
                  items: ['All', 'Low', 'Medium', 'High']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _filterPriority = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Tasks List
          Expanded(
            child: _filteredTasks.isEmpty
                ? Center(child: Text("No tasks found."))
                : ListView.builder(
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = _filteredTasks[index];
                      return ToDoTail(
                        task: task[0],
                        taskstatus: task[1],
                        priority: task[2],
                        dueDate: task[3],
                        onChanged: (value) => checkBoxChanged(value, db.toDoList.indexOf(task)),
                        deleteFunction: (context) => deleteTask(db.toDoList.indexOf(task)),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        backgroundColor: Colors.grey[600],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
