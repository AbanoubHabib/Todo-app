import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_am/cubit/cubit.dart';
import 'package:todoapp_am/cubit/cubit_state.dart';
import 'package:todoapp_am/views/widgets/no_task_added_yet.dart';

class archivetask_view extends StatelessWidget {
  const archivetask_view({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;
         return NoTaskAddedYet(
          tasks: tasks,
          textPage: 'No tasks archived yet, please add some',
          iconPage: Icons.archive_outlined,
        );
      },
    );
  }
}
