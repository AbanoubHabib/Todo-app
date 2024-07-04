import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp_am/cubit/cubit.dart';
import 'package:todoapp_am/cubit/cubit_state.dart';
import 'package:todoapp_am/views/widgets/custom_text_form_filed.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseStates) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.blue,
              title: Text(
                //'${BlocProvider.of<AppCubit>(context).titles}',
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            //*to toggle between multiple pages must use list

            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 25.0, right: 10),
              child: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      );
                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet(
                          (context) => Container(
                            color: Colors.white24,
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextFormFiled(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    label: 'Task tittle',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    prefixIcon: Icons.title,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  CustomTextFormFiled(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    label: 'Task Time',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    prefixIcon: Icons.watch_later_outlined,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  CustomTextFormFiled(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    label: 'Task Date',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },
                                    prefixIcon: Icons.calendar_today,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2025),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          elevation: 25.0,
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    });
                    cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                    );
                  }
                },
                backgroundColor: Colors.blue[400],
                elevation: 3.5,
                child: Icon(
                  cubit.fabIcon,
                  color: Colors.white,
                  size: 35.0,
                ),
              ),
            ),

            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingStates,
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
              builder: (context) => cubit.pages[cubit.currentIndex],
            ),

            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.blueAccent,
              iconSize: 30.0,
              elevation: 0,
              backgroundColor: const Color(0xffeaddff),
              showSelectedLabels: true,
              enableFeedback: true,
              selectedFontSize: 18,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
