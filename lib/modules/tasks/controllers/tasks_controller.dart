import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../models/task_model.dart';
import '../../../shared/controllers/activity_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../shared/services/subscription_service.dart';
import '../../../shared/services/notification_translator.dart';
import '../../../shared/services/notification_service.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class TasksState {
  final List<TaskModel> tasks;
  final List<TaskModel> filteredTasks;
  final TaskStatus? selectedStatus;
  final TaskPriority? selectedPriority;
  final bool isLoading;

  const TasksState({
    this.tasks = const [],
    this.filteredTasks = const [],
    this.selectedStatus,
    this.selectedPriority,
    this.isLoading = false,
  });

  TasksState copyWith({
    List<TaskModel>? tasks,
    List<TaskModel>? filteredTasks,
    TaskStatus? selectedStatus,
    TaskPriority? selectedPriority,
    bool? isLoading,
    bool clearStatus = false,
    bool clearPriority = false,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      selectedPriority: clearPriority ? null : (selectedPriority ?? this.selectedPriority),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ─── Controller ───────────────────────────────────────────────────────────────

class TasksController extends StateNotifier<TasksState> {
  TasksController(this._ref) : super(const TasksState());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;
  String? _workspaceId;

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadTasks(String workspaceId) async {
    _workspaceId = workspaceId;
    state = state.copyWith(isLoading: true);

    _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {
      final tasks = snapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();
      state = state.copyWith(
        tasks: tasks,
        isLoading: false,
      );
      _applyFilters();
      _handleRecurringTasks(tasks);
    });
  }

  void _handleRecurringTasks(List<TaskModel> tasks) {
    final now = DateTime.now();
    for (final task in tasks) {
      if (task.repeat != RepeatType.none && task.dueDate != null && !task.hasSpawnedNext && !task.isArchived) {
        final isSameDay = task.dueDate!.year == now.year && task.dueDate!.month == now.month && task.dueDate!.day == now.day;
        if (task.dueDate!.isBefore(now) || isSameDay) {
          
          DateTime nextDate = task.dueDate!;
          if (task.repeat == RepeatType.daily) {
            nextDate = nextDate.add(const Duration(days: 1));
          } else if (task.repeat == RepeatType.weekly) {
            nextDate = nextDate.add(const Duration(days: 7));
          } else if (task.repeat == RepeatType.monthly) {
            nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
          }
          
          final newTask = task.copyWith(
            id: 't${DateTime.now().millisecondsSinceEpoch}',
            dueDate: nextDate,
            status: TaskStatus.pending,
            createdAt: DateTime.now(),
            hasSpawnedNext: false,
            isArchived: false,
            subtasks: task.subtasks.map((s) => s.copyWith(isCompleted: false)).toList(),
          );
          
          final batch = _firestore.batch();
          final wsRef = _firestore.collection('workspaces').doc(task.workspaceId).collection('tasks');
          
          batch.update(wsRef.doc(task.id), {'hasSpawnedNext': true});
          batch.set(wsRef.doc(newTask.id), newTask.toJson());
          
          batch.commit().then((_) {
            // Yeni oluşan tekrar eden görev için bildirim kur
            final target = newTask.assignedTo ?? _ref.read(authControllerProvider).user?.id;
            if (target != null) {
              final notifService = _ref.read(notificationServiceProvider);
              // 1 gün önce 09:00
              final oneDayBefore = newTask.dueDate!.subtract(const Duration(days: 1));
              final schedule1 = DateTime(oneDayBefore.year, oneDayBefore.month, oneDayBefore.day, 9, 0);
              if (schedule1.isAfter(now)) {
                notifService.scheduleNotification(
                  headings: NotificationTranslator.getUpcomingTaskTitle(),
                  contents: NotificationTranslator.getUpcomingTaskMessage(newTask.title),
                  targetUserIds: [target],
                  sendAfter: schedule1,
                );
              }
              // Aynı gün 09:00
              final sameDay = DateTime(newTask.dueDate!.year, newTask.dueDate!.month, newTask.dueDate!.day, 9, 0);
              if (sameDay.isAfter(now)) {
                notifService.scheduleNotification(
                  headings: NotificationTranslator.getDueTodayTaskTitle(),
                  contents: NotificationTranslator.getDueTodayTaskMessage(newTask.title),
                  targetUserIds: [target],
                  sendAfter: sameDay,
                );
              }
            }
          }).catchError((e) {
            print('Error spawning recurring task: $e');
          });
        }
      }
    }
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  void createTask(TaskModel task) {
    _firestore.collection('workspaces').doc(task.workspaceId).collection('tasks').doc(task.id).set(task.toJson());
    _ref.read(activityControllerProvider.notifier).logActivity(
      actionType: 'created',
      resourceType: 'task',
      resourceId: task.id,
      resourceName: task.title,
    );
    
    final currentUserId = _ref.read(authControllerProvider).user?.id;
    final notifService = _ref.read(notificationServiceProvider);
    
    if (task.assignedTo != null && task.assignedTo != currentUserId) {
      notifService.sendInstantNotification(
        headings: NotificationTranslator.getTaskAddedTitle(task.title),
        contents: NotificationTranslator.getTaskAddedMessage(task.title),
        targetUserIds: [task.assignedTo!],
      );
    }
    
    if (task.dueDate != null) {
      final target = task.assignedTo ?? currentUserId;
      if (target != null) {
        final oneDayBefore = task.dueDate!.subtract(const Duration(days: 1));
        final schedule1 = DateTime(oneDayBefore.year, oneDayBefore.month, oneDayBefore.day, 9, 0);
        if (schedule1.isAfter(DateTime.now())) {
          notifService.scheduleNotification(
            headings: NotificationTranslator.getUpcomingTaskTitle(),
            contents: NotificationTranslator.getUpcomingTaskMessage(task.title),
            targetUserIds: [target],
            sendAfter: schedule1,
          );
        }
        final sameDay = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day, 9, 0);
        if (sameDay.isAfter(DateTime.now())) {
          notifService.scheduleNotification(
            headings: NotificationTranslator.getDueTodayTaskTitle(),
            contents: NotificationTranslator.getDueTodayTaskMessage(task.title),
            targetUserIds: [target],
            sendAfter: sameDay,
          );
        }
      }
    }
  }

  void updateTask(TaskModel task) {
    _firestore.collection('workspaces').doc(task.workspaceId).collection('tasks').doc(task.id).update(task.toJson());
    _ref.read(activityControllerProvider.notifier).logActivity(
      actionType: 'updated',
      resourceType: 'task',
      resourceId: task.id,
      resourceName: task.title,
    );
  }

  void deleteTask(String id, {String? workspaceId}) {
    final wsId = workspaceId ?? _workspaceId;
    if (wsId == null) return;
    _firestore.collection('workspaces').doc(wsId).collection('tasks').doc(id).delete();
    _ref.read(activityControllerProvider.notifier).logActivity(
      actionType: 'deleted',
      resourceType: 'task',
      resourceId: id,
      resourceName: 'Bir görev',
    );
  }

  void updateStatus(String id, TaskStatus status) {
    final task = state.tasks.firstWhere((t) => t.id == id);
    updateTask(task.copyWith(status: status));
    if (status == TaskStatus.completed) {
      _ref.read(activityControllerProvider.notifier).logActivity(
        actionType: 'completed',
        resourceType: 'task',
        resourceId: task.id,
        resourceName: task.title,
      );
    }
  }

  void assignTask(String taskId, String userId) {
    final task = state.tasks.firstWhere((t) => t.id == taskId);
    updateTask(task.copyWith(assignedTo: userId));
    
    final currentUserId = _ref.read(authControllerProvider).user?.id;
    if (userId != currentUserId) {
      _ref.read(notificationServiceProvider).sendInstantNotification(
        headings: NotificationTranslator.getTaskUpdatedTitle(task.title),
        contents: NotificationTranslator.getTaskUpdatedMessage(task.title),
        targetUserIds: [userId],
      );
    }
  }

  // ── Subtasks ──────────────────────────────────────────────────────────────

  void addSubTask(String taskId, SubTask subtask) {
    final task = state.tasks.firstWhere((t) => t.id == taskId);
    updateTask(task.copyWith(subtasks: [...task.subtasks, subtask]));
  }

  void toggleSubTask(String taskId, int index) {
    final task = state.tasks.firstWhere((t) => t.id == taskId);
    final subs = List<SubTask>.from(task.subtasks);
    subs[index] = subs[index].copyWith(isCompleted: !subs[index].isCompleted);
    updateTask(task.copyWith(subtasks: subs));
  }

  // ── Filters ───────────────────────────────────────────────────────────────

  void filterByStatus(TaskStatus? status) {
    if (status == state.selectedStatus) {
      state = state.copyWith(clearStatus: true);
    } else {
      state = state.copyWith(selectedStatus: status);
    }
    _applyFilters();
  }

  void filterByPriority(TaskPriority? priority) {
    if (priority == state.selectedPriority) {
      state = state.copyWith(clearPriority: true);
    } else {
      state = state.copyWith(selectedPriority: priority);
    }
    _applyFilters();
  }

  void _applyFilters() {
    var result = List<TaskModel>.from(state.tasks);

    final status = state.selectedStatus;
    if (status != null) {
      result = result.where((t) => t.status == status).toList();
    }

    final priority = state.selectedPriority;
    if (priority != null) {
      result = result.where((t) => t.priority == priority).toList();
    }

    state = state.copyWith(filteredTasks: result);
  }


}

// ─── Provider ─────────────────────────────────────────────────────────────────

final tasksControllerProvider = StateNotifierProvider.autoDispose<TasksController, TasksState>((ref) {
  final controller = TasksController(ref);
  final activeWorkspace = ref.watch(activeWorkspaceProvider);
  if (activeWorkspace != null) {
    controller.loadTasks(activeWorkspace.id);
  }
  return controller;
});
