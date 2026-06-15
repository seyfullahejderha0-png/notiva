/// Notiva hatırlatıcı modeli.
class ReminderModel {
  final String id;
  final String workspaceId;
  final String title;
  final DateTime date;
  final String repeat;
  final bool notificationEnabled;
  final String? assignedTo;
  final bool isArchived;

  const ReminderModel({
    required this.id,
    required this.workspaceId,
    required this.title,
    required this.date,
    this.repeat = 'none',
    this.notificationEnabled = true,
    this.assignedTo,
    this.isArchived = false,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      repeat: json['repeat'] as String? ?? 'none',
      notificationEnabled: json['notificationEnabled'] as bool? ?? true,
      assignedTo: json['assignedTo'] as String?,
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspaceId': workspaceId,
        'title': title,
        'date': date.toIso8601String(),
        'repeat': repeat,
        'notificationEnabled': notificationEnabled,
        'assignedTo': assignedTo,
        'isArchived': isArchived,
      };

  ReminderModel copyWith({
    String? id,
    String? workspaceId,
    String? title,
    DateTime? date,
    String? repeat,
    bool? notificationEnabled,
    String? assignedTo,
    bool? isArchived,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      title: title ?? this.title,
      date: date ?? this.date,
      repeat: repeat ?? this.repeat,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      assignedTo: assignedTo ?? this.assignedTo,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  String get repeatLabel {
    switch (repeat) {
      case 'daily':
        return 'Günlük';
      case 'weekly':
        return 'Haftalık';
      default:
        return '';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ReminderModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
