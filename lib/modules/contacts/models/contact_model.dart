/// Notiva kişi modeli.
class ContactModel {
  final String id;
  final String workspaceId;
  final String name;
  final String? phone;
  final String? email;
  final String? company;
  final String? role;
  final String? notes;
  final String? avatar;

  const ContactModel({
    required this.id,
    required this.workspaceId,
    required this.name,
    this.phone,
    this.email,
    this.company,
    this.role,
    this.notes,
    this.avatar,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      company: json['company'] as String?,
      role: json['role'] as String?,
      notes: json['notes'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspaceId': workspaceId,
        'name': name,
        'phone': phone,
        'email': email,
        'company': company,
        'role': role,
        'notes': notes,
        'avatar': avatar,
      };

  ContactModel copyWith({
    String? id,
    String? workspaceId,
    String? name,
    String? phone,
    String? email,
    String? company,
    String? role,
    String? notes,
    String? avatar,
  }) {
    return ContactModel(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      company: company ?? this.company,
      role: role ?? this.role,
      notes: notes ?? this.notes,
      avatar: avatar ?? this.avatar,
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ContactModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
