/// Notiva çalışma alanı modeli.
class WorkspaceModel {
  final String id;
  final String name;
  final String icon;
  final int color;
  final String ownerId;
  final List<String> members;
  final Map<String, Map<String, String>> memberPermissions; // userId -> { 'notes': 'write', 'tasks': 'read' ... }
  final String type; // 'personal' or 'team'
  final String? inviteCode;
  final DateTime createdAt;
  final int storageUsed;
  final int? maxStorage;
  final int? maxMembers;

  const WorkspaceModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.ownerId,
    required this.members,
    this.memberPermissions = const {},
    this.type = 'team',
    this.inviteCode,
    required this.createdAt,
    this.storageUsed = 0,
    this.maxStorage,
    this.maxMembers,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as int,
      ownerId: json['ownerId'] as String,
      members: List<String>.from(json['members'] ?? []),
      memberPermissions: _parsePermissions(json['memberPermissions'] ?? json['memberRoles']),
      type: json['type'] as String? ?? 'team',
      inviteCode: json['inviteCode'] as String?,
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt'] as DateTime
          : DateTime.parse(json['createdAt'] as String),
      storageUsed: json['storageUsed'] as int? ?? 0,
      maxStorage: json['maxStorage'] as int?,
      maxMembers: json['maxMembers'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': color,
        'ownerId': ownerId,
        'members': members,
        'memberPermissions': memberPermissions,
        'type': type,
        'inviteCode': inviteCode,
        'createdAt': createdAt.toIso8601String(),
        'storageUsed': storageUsed,
        'maxStorage': maxStorage,
        'maxMembers': maxMembers,
      };

  WorkspaceModel copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
    String? ownerId,
    List<String>? members,
    Map<String, Map<String, String>>? memberPermissions,
    String? type,
    String? inviteCode,
    DateTime? createdAt,
    int? storageUsed,
    int? maxStorage,
    int? maxMembers,
  }) {
    return WorkspaceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      memberPermissions: memberPermissions ?? this.memberPermissions,
      type: type ?? this.type,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
      storageUsed: storageUsed ?? this.storageUsed,
      maxStorage: maxStorage ?? this.maxStorage,
      maxMembers: maxMembers ?? this.maxMembers,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WorkspaceModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  static Map<String, Map<String, String>> _parsePermissions(dynamic data) {
    if (data == null) return {};
    
    final Map<String, Map<String, String>> result = {};
    if (data is Map) {
      data.forEach((key, value) {
        if (value is Map) {
          result[key.toString()] = Map<String, String>.from(value);
        } else if (value is String) {
          // Backward compatibility for old memberRoles
          result[key.toString()] = {
            'notes': value,
            'tasks': value,
            'todos': value,
            'reminders': value,
          };
        }
      });
    }
    return result;
  }
}
