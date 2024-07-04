import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoapp_am/views/widgets/build_task_item.dart';

class NoTaskAddedYet extends StatelessWidget {
  const NoTaskAddedYet({
    super.key,
    required this.tasks,
    required this.iconPage,
    required this.textPage,
  });
  final List<Map> tasks;
  final IconData iconPage;
  final String textPage;
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) {
          return BuildTaskItem(
            tasks[index],
            context,
          );
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              height: 3.0,
              color: Colors.grey[300],
            ),
          );
        },
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconPage,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              textPage,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
