/// Notiva kullanıcı modeli.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final DateTime createdAt;
  final String subscriptionType; // 'free', 'basic', 'professional', 'enterprise'
  final DateTime? trialEndsAt;
  final bool hasExtraStorage;
  final bool hasExtraWorkspace;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.createdAt,
    this.subscriptionType = 'free',
    this.trialEndsAt,
    this.hasExtraStorage = false,
    this.hasExtraWorkspace = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt'] as DateTime
          : DateTime.parse(json['createdAt'] as String),
      subscriptionType: json['subscriptionType'] as String? ?? 'free',
      trialEndsAt: json['trialEndsAt'] != null
          ? (json['trialEndsAt'] is DateTime
              ? json['trialEndsAt'] as DateTime
              : DateTime.parse(json['trialEndsAt'] as String))
          : null,
      hasExtraStorage: json['hasExtraStorage'] as bool? ?? false,
      hasExtraWorkspace: json['hasExtraWorkspace'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'createdAt': createdAt.toIso8601String(),
        'subscriptionType': subscriptionType,
        if (trialEndsAt != null) 'trialEndsAt': trialEndsAt!.toIso8601String(),
        'hasExtraStorage': hasExtraStorage,
        'hasExtraWorkspace': hasExtraWorkspace,
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    DateTime? createdAt,
    String? subscriptionType,
    DateTime? trialEndsAt,
    bool? hasExtraStorage,
    bool? hasExtraWorkspace,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      hasExtraStorage: hasExtraStorage ?? this.hasExtraStorage,
      hasExtraWorkspace: hasExtraWorkspace ?? this.hasExtraWorkspace,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
