import 'dart:async';

import 'package:evergreen_lifechurch_todo/features/authentication/data/firebase_auth_repository.dart';
import 'package:evergreen_lifechurch_todo/features/tasks/data/tasks_repository.dart';
import 'package:evergreen_lifechurch_todo/features/tasks/domain/task.dart';
import 'package:evergreen_lifechurch_todo/features/tasks/presentation/edit_task_screen/task_submit_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_task_screen_controller.g.dart';

@riverpod
class EditTaskScreenController extends _$EditTaskScreenController {
  @override
  FutureOr<void> build() {
    //
  }

  Future<bool> submit(
      {required String title,
        required String description,
        required DateTime  dueDate,
        TaskID? taskId,
      Task? oldTask,
        Status status = Status.inProgress }) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError("User can't be null");
    }
    // set loading state
    state = const AsyncLoading<dynamic>().copyWithPrevious(state);
    // check if name is already in use
    final repository = ref.read(tasksRepositoryProvider);
    final tasks = await repository.fetchTasks(uid: currentUser.uid);
    final allLowerCaseNames = tasks.map((task) => task.title.toLowerCase()).toList();
    // it's ok to use the same title as the old task when editing it.
    if (oldTask != null) {
      allLowerCaseNames.remove(oldTask.title.toLowerCase());
    }
    // check if title is already used
    if (allLowerCaseNames.contains(title.toLowerCase())) {
      state = AsyncError(TaskSubmitException(), StackTrace.current);
      return false;
    } else {
      // task previously existed
      if (taskId != null) {
        final task = Task(
          id: taskId,
          title: title,
          description: description,
          dueDate: dueDate,
          status: status
        );
        state = await AsyncValue.guard(
          () => repository.updateTask(uid: currentUser.uid, task: task),
        );
      } else {
        state = await AsyncValue.guard(
          () => repository.addTask(
              uid: currentUser.uid, title: title, dueDate: dueDate,
              description: description, status: status),
        );
      }
      return state.hasError == false;
    }
  }
}
