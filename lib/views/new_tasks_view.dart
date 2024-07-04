import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_am/cubit/cubit.dart';
import 'package:todoapp_am/cubit/cubit_state.dart';
import 'package:todoapp_am/views/widgets/no_task_added_yet.dart';

class NewTasksView extends StatelessWidget {
  const NewTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;

        return NoTaskAddedYet(
          tasks: tasks,
          textPage: 'No tasks added yet, please add some',
          iconPage: Icons.menu,
        );
      },
    );
  }
}
