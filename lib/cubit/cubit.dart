import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp_am/cubit/cubit_state.dart';
import 'package:todoapp_am/views/archivetasks_view.dart';
import 'package:todoapp_am/views/donetasks_view.dart';
import '../views/new_tasks_view.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> pages = [
    NewTasksView(),
    donetasks_view(),
    archivetask_view(),
  ];
  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarStates());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];

  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, int version) {
      print('database created');

      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,  title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        {
          print('error when created table ${error.toString()}');
        }
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database opend');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseStates());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title , date ,time , status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        emit(AppInsertDatabaseStates());
        print('$value inserted successfully');

        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when inserting new record  ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingStates());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseStates());
    });
  }

  void updateData({
    required String status,
    required int id,
  })
  async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
    
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseStates());
    });
  }
    void deleteData({
    
    required int id,
  })
  async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
    
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseStates());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetStates());
  }
}
