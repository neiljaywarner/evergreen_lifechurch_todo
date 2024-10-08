import 'package:evergreen_lifechurch_todo/constants/strings.dart';
import 'package:evergreen_lifechurch_todo/features/tasks/data/tasks_repository.dart';
import 'package:evergreen_lifechurch_todo/features/tasks/domain/task.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/app_router.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.tasks),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.goNamed(AppRoute.addTask.name),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final tasksQuery = ref.watch(tasksQueryProvider);
          return FirestoreListView<Task>(
            query: tasksQuery,
            emptyBuilder: (context) => const Center(child: Text('No tasks, please press "+" to add.')),
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loadingBuilder: (context) =>
            const Center(child: CircularProgressIndicator.adaptive()),
            itemBuilder: (context, doc) {
              final task = doc.data();
              return Dismissible(
                key: Key('task-${task.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  onTap: () => debugPrint('tap'),
                  ),
                );
            },
          );
        },
      ),
    );
  }
}
