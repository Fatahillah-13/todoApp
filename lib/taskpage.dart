// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/widget.dart';

// ignore: camel_case_types
class taskpage extends StatefulWidget {
  final Task? task;
  taskpage({@required this.task});

  @override
  State<taskpage> createState() => _taskpageState();
}

// ignore: camel_case_types
class _taskpageState extends State<taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _tasktitle = "";

  @override
  void initState() {
    if (widget.task != null) {
      _tasktitle = widget.task!.title!;
      _taskId = widget.task!.id!;
    } else {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 24.0, bottom: 6.0),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        InkWell(
                          onTap: (() {
                            Navigator.pop(context);
                          }),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/icon_arrowleft.png"),
                              height: 30.0,
                              width: 30.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) async {
                              // check if the field is not empty
                              if (value != "") {
                                // check if the task is not null
                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  await _dbHelper.insertTask(_newTask);
                                } else {
                                  print("Update the existing task");
                                }
                              }
                            },
                            controller: TextEditingController()
                              ..text = _tasktitle,
                            decoration: InputDecoration(
                                hintText: "Enter Task Title",
                                border: InputBorder.none),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Enter the Description for the task",
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 24.0)),
                    ),
                  ),
                  FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTodo(_taskId),
                    builder: ((context, AsyncSnapshot snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: (() {
                                // switch the todo completion state
                              }),
                              child: TodoWidget(
                                text: snapshot.data[index].title,
                                isDone: snapshot.data[index].isDone == 0
                                    ? false
                                    : true,
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24.0,
                          height: 24.0,
                          margin: EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                              color: Color(0xFF868290),
                              width: 1.5,
                            ),
                          ),
                          child: Image(
                            image: AssetImage('assets/images/icon_check.png'),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: ((value) async {
                              // check if the field is not empty
                              if (value != "") {
                                // check if the task is not null
                                if (widget.task != null) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    taskId: widget.task?.id,
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                } else {
                                  print("Task doesn't exist");
                                }
                              }
                            }),
                            decoration: InputDecoration(
                                hintText: "Enter todo item",
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => taskpage()),
                    );
                  }),
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFFE3577),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image(
                      height: 4.0,
                      width: 4.0,
                      image: AssetImage('assets/images/icon_trash.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
