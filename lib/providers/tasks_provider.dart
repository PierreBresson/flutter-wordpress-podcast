import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwp/models/models.dart';

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super([]);

  void addTask(Task task) {
    state = [...state, task];
  }

  void removeTask(Task taskToBeRemoved) {
    state = [
      for (final task in state)
        if (task.id != taskToBeRemoved.id) task,
    ];
  }

  void removeTaskById(String id) {
    state = [
      for (final task in state)
        if (task.id != id) task,
    ];
  }

  Task? getTask(String id) {
    return state.firstWhereOrNull(
      (task) => task.id == id,
    );
  }

  void updateTask(Task taskToBeUpdated) {
    final List<Task> newState = [];

    final hasTask = state.firstWhereOrNull(
          (task) => task.id == taskToBeUpdated.id,
        ) !=
        null;

    if (hasTask) {
      for (final task in state) {
        if (task.id == taskToBeUpdated.id) {
          newState.add(taskToBeUpdated);
        } else {
          newState.add(task);
        }
      }
      state = newState;
    } else {
      state = [...state, taskToBeUpdated];
    }
  }
}

final tasksStateProvider =
    StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});
