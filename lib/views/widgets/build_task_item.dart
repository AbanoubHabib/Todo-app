import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoapp_am/cubit/cubit.dart';

  Widget BuildTaskItem(Map model,context) => Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon:  Icon(Icons.check_box,
              color: Colors.green[500],
              ),
            ),
            IconButton(
              onPressed: () {
                  AppCubit.get(context).updateData(
                  status: 'archive',
                  id: model['id'],
                );
              },
              icon: const Icon(Icons.archive_outlined,
              color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
  
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },);




