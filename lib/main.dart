import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp_am/utils/my_observer.dart';
import 'package:todoapp_am/views/home_view.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(ToDoapp());
}

class ToDoapp extends StatelessWidget {
  const ToDoapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
