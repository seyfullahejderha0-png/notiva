import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Data Models ─────────────────────────────────────────────────

@immutable
class RecentNote {
  const RecentNote({
    required this.id,
    required this.title,
    required this.preview,
    required this.date,
    this.color,
  });

  final String id;
  final String title;
  final String preview;
  final DateTime date;
  final int? color;
}

@immutable
class PendingTask {
  const PendingTask({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final TaskPriority priority;
  final DateTime? dueDate;
  final bool isCompleted;
}

enum TaskPriority { high, medium, low }

@immutable
class UpcomingReminder {
  const UpcomingReminder({
    required this.id,
    required this.title,
    required this.dateTime,
    this.description,
  });

  final String id;
  final String title;
  final DateTime dateTime;
  final String? description;
}

// ─── Dashboard State ─────────────────────────────────────────────

@immutable
class DashboardState {
  const DashboardState({
    this.recentNotes = const [],
    this.pendingTasks = const [],
    this.upcomingReminders = const [],
    this.isLoading = false,
    this.totalNotes = 0,
    this.completedToday = 0,
    this.workspaceName = 'Kişisel',
    this.userName = 'Kullanıcı',
  });

  final List<RecentNote> recentNotes;
  final List<PendingTask> pendingTasks;
  final List<UpcomingReminder> upcomingReminders;
  final bool isLoading;
  final int totalNotes;
  final int completedToday;
  final String workspaceName;
  final String userName;

  int get pendingTasksCount =>
      pendingTasks.where((t) => !t.isCompleted).length;

  int get upcomingRemindersCount => upcomingReminders.length;

  DashboardState copyWith({
    List<RecentNote>? recentNotes,
    List<PendingTask>? pendingTasks,
    List<UpcomingReminder>? upcomingReminders,
    bool? isLoading,
    int? totalNotes,
    int? completedToday,
    String? workspaceName,
    String? userName,
  }) {
    return DashboardState(
      recentNotes: recentNotes ?? this.recentNotes,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      upcomingReminders: upcomingReminders ?? this.upcomingReminders,
      isLoading: isLoading ?? this.isLoading,
      totalNotes: totalNotes ?? this.totalNotes,
      completedToday: completedToday ?? this.completedToday,
      workspaceName: workspaceName ?? this.workspaceName,
      userName: userName ?? this.userName,
    );
  }
}

// ─── Dashboard Controller ────────────────────────────────────────

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController() : super(const DashboardState()) {
    loadDashboardData('default');
  }

  Future<void> loadDashboardData(String workspaceId) async {
    state = state.copyWith(isLoading: true);

    // Simulate network latency
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();

    state = state.copyWith(
      isLoading: false,
      userName: 'Ahmet',
      workspaceName: 'Kişisel',
      totalNotes: 24,
      completedToday: 3,
      recentNotes: [
        RecentNote(
          id: '1',
          title: 'Flutter Proje Notları',
          preview: 'Riverpod state management kullanarak modüler bir yapı...',
          date: now.subtract(const Duration(hours: 1)),
          color: 0xFF4A90D9,
        ),
        RecentNote(
          id: '2',
          title: 'Toplantı Notları',
          preview: 'Yeni sprint planlama ve görev dağılımı hakkında...',
          date: now.subtract(const Duration(hours: 3)),
          color: 0xFF7C6BC4,
        ),
        RecentNote(
          id: '3',
          title: 'Alışveriş Listesi',
          preview: 'Süt, ekmek, peynir, domates, salatalık...',
          date: now.subtract(const Duration(days: 1)),
          color: 0xFF4CAF7D,
        ),
        RecentNote(
          id: '4',
          title: 'Kitap Özetleri',
          preview: 'Atomic Habits - küçük alışkanlıkların büyük...',
          date: now.subtract(const Duration(days: 1, hours: 5)),
          color: 0xFFEDA63A,
        ),
        RecentNote(
          id: '5',
          title: 'API Dökümantasyonu',
          preview: 'REST endpoint tanımları ve response formatları...',
          date: now.subtract(const Duration(days: 2)),
          color: 0xFF5B9BD5,
        ),
      ],
      pendingTasks: [
        PendingTask(
          id: '1',
          title: 'Dashboard tasarımını tamamla',
          priority: TaskPriority.high,
          dueDate: now.add(const Duration(hours: 4)),
        ),
        PendingTask(
          id: '2',
          title: 'Veritabanı migration yaz',
          priority: TaskPriority.high,
          dueDate: now.add(const Duration(days: 1)),
        ),
        PendingTask(
          id: '3',
          title: 'Haftalık raporu hazırla',
          priority: TaskPriority.medium,
          dueDate: now.add(const Duration(days: 2)),
        ),
        PendingTask(
          id: '4',
          title: 'Test senaryolarını güncelle',
          priority: TaskPriority.low,
          dueDate: now.add(const Duration(days: 3)),
        ),
        PendingTask(
          id: '5',
          title: 'Kod review tamamla',
          priority: TaskPriority.medium,
          dueDate: now.add(const Duration(days: 1, hours: 6)),
        ),
      ],
      upcomingReminders: [
        UpcomingReminder(
          id: '1',
          title: 'Takım toplantısı',
          dateTime: now.add(const Duration(hours: 2)),
          description: 'Sprint retrospektif',
        ),
        UpcomingReminder(
          id: '2',
          title: 'Doktor randevusu',
          dateTime: now.add(const Duration(days: 1, hours: 3)),
          description: 'Göz kontrolü',
        ),
        UpcomingReminder(
          id: '3',
          title: 'Proje teslimi',
          dateTime: now.add(const Duration(days: 3)),
        ),
      ],
    );
  }

  Future<void> refresh() async {
    await loadDashboardData('default');
  }

  void toggleTask(String taskId) {
    final updatedTasks = state.pendingTasks.map((task) {
      if (task.id == taskId) {
        return PendingTask(
          id: task.id,
          title: task.title,
          priority: task.priority,
          dueDate: task.dueDate,
          isCompleted: !task.isCompleted,
        );
      }
      return task;
    }).toList();

    final completedDelta = updatedTasks
            .firstWhere((t) => t.id == taskId)
            .isCompleted
        ? 1
        : -1;

    state = state.copyWith(
      pendingTasks: updatedTasks,
      completedToday: state.completedToday + completedDelta,
    );
  }
}

// ─── Provider ────────────────────────────────────────────────────

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>(
  (ref) => DashboardController(),
);
