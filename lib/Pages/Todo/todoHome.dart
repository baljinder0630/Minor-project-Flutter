// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minor_project/constants.dart';

class ToDoHomePage extends ConsumerStatefulWidget {
  const ToDoHomePage({super.key});

  @override
  ConsumerState<ToDoHomePage> createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends ConsumerState<ToDoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("To Do"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            // color: Colors.green,
            child: Column(
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: double.infinity,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "There is no task to do",
                      )),
                    ),
                  ),
                )),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: double.infinity,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "There is no completed task yet",
                      )),
                    ),
                  ),
                )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        "Add Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
