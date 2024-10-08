import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evergreen_lifechurch_todo/features/authentication/data/firebase_auth_repository.dart';
import 'package:evergreen_lifechurch_todo/features/authentication/domain/app_user.dart';
import 'package:evergreen_lifechurch_todo/features/tasks/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_repository.g.dart';

class TasksRepository {
  const TasksRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String taskPath(String uid, String taskId) => 'users/$uid/tasks/$taskId';
  static String tasksPath(String uid) => 'users/$uid/tasks';
  //static String commentsPath(String uid) => CommentsRepository.commentsPath(uid);

  // create
  Future<void> addTask(
          {required UserID uid,
          required String title,
            required String description,
          required DateTime dueDate,
            required Status status,
          }) =>
      _firestore.collection(tasksPath(uid)).add({
        'title': title,
        'description': description,
        'dueDate': dueDate.millisecondsSinceEpoch,
        'status': status.name,
      });

  // update
  Future<void> updateTask({required UserID uid, required Task task}) =>
      _firestore.doc(taskPath(uid, task.id)).update(task.toMap());

  // delete
  Future<void> deleteTask({required UserID uid, required TaskID taskId}) async {
    // delete where entry.TaskId == Task.TaskId
    /*
    final entriesRef = _firestore.collection(entriesPath(uid));
    final entries = await entriesRef.get();
    for (final snapshot in entries.docs) {
      final entry = Entry.fromMap(snapshot.data(), snapshot.id);
      if (entry.TaskId == TaskId) {
        await snapshot.reference.delete();
      }
    }
    
     */
    // delete Task
    final taskRef = _firestore.doc(taskPath(uid, taskId));
    await taskRef.delete();
  }

  // read
  Stream<Task> watchTask({required UserID uid, required TaskID taskId}) =>
      _firestore
          .doc(taskPath(uid, taskId))
          .withConverter<Task>(
            fromFirestore: (snapshot, _) =>
                Task.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (task, _) => task.toMap(),
          )
          .snapshots()
          .map((snapshot) => snapshot.data()!);

  Stream<List<Task>> watchTasks({required UserID uid}) => queryTasks(uid: uid)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Query<Task> queryTasks({required UserID uid}) =>
      _firestore.collection(tasksPath(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                Task.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (Task, _) => Task.toMap(),
          );

  Future<List<Task>> fetchTasks({required UserID uid}) async {
    final tasks = await queryTasks(uid: uid).get();
    return tasks.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
TasksRepository tasksRepository(TasksRepositoryRef ref) {
  return TasksRepository(FirebaseFirestore.instance);
}

@riverpod
Query<Task> tasksQuery(TasksQueryRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError("User can't be null");
  }
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.queryTasks(uid: user.uid);
}

@riverpod
Stream<Task> taskStream(TaskStreamRef ref, TaskID TaskId) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError("User can't be null");
  }
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.watchTask(uid: user.uid, taskId: TaskId);
}
