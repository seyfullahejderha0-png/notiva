import '../../../shared/models/attachment_model.dart';
import 'package:nexus_app/l10n/app_localizations.dart';

/// Görev durumları.
enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled;

  String displayLabel(context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case TaskStatus.pending:
        return l10n.pending;
      case TaskStatus.inProgress:
        return l10n.inProgress;
      case TaskStatus.completed:
        return l10n.completedItemsTab;
      case TaskStatus.cancelled:
        return l10n.cancel;
    }
  }
}

/// Görev öncelikleri.
enum TaskPriority {
  low,
  medium,
  high,
  critical;

  String displayLabel(context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case TaskPriority.low:
        return l10n.priorityLow;
      case TaskPriority.medium:
        return l10n.priorityMedium;
      case TaskPriority.high:
        return l10n.priorityHigh;
      case TaskPriority.critical:
        return l10n.priorityCritical;
    }
  }
}

/// Tekrarlama türleri.
enum RepeatType {
  none,
  daily,
  weekly,
  monthly;

  String displayLabel(context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case RepeatType.none:
        return l10n.repeatNone;
      case RepeatType.daily:
        return l10n.repeatDaily;
      case RepeatType.weekly:
        return l10n.repeatWeekly;
      case RepeatType.monthly:
        return l10n.repeatMonthly;
    }
  }
}

/// Alt görev modeli.
class SubTask {
  final String title;
  final bool isCompleted;

  const SubTask({required this.title, this.isCompleted = false});

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
      };

  SubTask copyWith({String? title, bool? isCompleted}) {
    return SubTask(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Notiva görev modeli.
class TaskModel {
  final String id;
  final String workspaceId;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final String? assignedTo;
  final String createdBy;
  final bool reminder;
  final RepeatType repeat;
  final List<SubTask> subtasks;
  final List<AttachmentModel> attachments;
  final DateTime createdAt;
  final bool isArchived;
  final bool hasSpawnedNext;

  const TaskModel({
    required this.id,
    required this.workspaceId,
    required this.title,
    this.description = '',
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.assignedTo,
    required this.createdBy,
    this.reminder = false,
    this.repeat = RepeatType.none,
    this.subtasks = const [],
    this.attachments = const [],
    required this.createdAt,
    this.isArchived = false,
    this.hasSpawnedNext = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      assignedTo: json['assignedTo'] as String?,
      createdBy: json['createdBy'] as String,
      reminder: json['reminder'] as bool? ?? false,
      repeat: RepeatType.values.firstWhere(
        (e) => e.name == json['repeat'],
        orElse: () => RepeatType.none,
      ),
      subtasks: (json['subtasks'] as List?)
              ?.map((e) => SubTask.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      attachments: (json['attachments'] as List?)
              ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      isArchived: json['isArchived'] as bool? ?? false,
      hasSpawnedNext: json['hasSpawnedNext'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspaceId': workspaceId,
        'title': title,
        'description': description,
        'status': status.name,
        'priority': priority.name,
        'dueDate': dueDate?.toIso8601String(),
        'assignedTo': assignedTo,
        'createdBy': createdBy,
        'reminder': reminder,
        'repeat': repeat.name,
        'subtasks': subtasks.map((s) => s.toJson()).toList(),
        'attachments': attachments.map((a) => a.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'isArchived': isArchived,
        'hasSpawnedNext': hasSpawnedNext,
      };

  TaskModel copyWith({
    String? id,
    String? workspaceId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    String? assignedTo,
    String? createdBy,
    bool? reminder,
    RepeatType? repeat,
    List<SubTask>? subtasks,
    List<AttachmentModel>? attachments,
    DateTime? createdAt,
    bool? isArchived,
    bool? hasSpawnedNext,
  }) {
    return TaskModel(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      createdBy: createdBy ?? this.createdBy,
      reminder: reminder ?? this.reminder,
      repeat: repeat ?? this.repeat,
      subtasks: subtasks ?? this.subtasks,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
      hasSpawnedNext: hasSpawnedNext ?? this.hasSpawnedNext,
    );
  }

  int get completedSubtasksCount => subtasks.where((s) => s.isCompleted).length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TaskModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
