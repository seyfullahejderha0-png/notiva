import '../../../shared/models/attachment_model.dart';

/// Notiva not modeli.
class NoteModel {
  final String id;
  final String workspaceId;
  final String title;
  final String content;
  final List<String> tags;
  final String? folderId;
  final bool pinned;
  final bool archived;
  final bool favorite;
  final String createdBy;
  final List<String> sharedWith;
  final List<AttachmentModel> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteModel({
    required this.id,
    required this.workspaceId,
    required this.title,
    required this.content,
    this.tags = const [],
    this.folderId,
    this.pinned = false,
    this.archived = false,
    this.favorite = false,
    required this.createdBy,
    this.sharedWith = const [],
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      folderId: json['folderId'] as String?,
      pinned: json['pinned'] as bool? ?? false,
      archived: json['archived'] as bool? ?? false,
      favorite: json['favorite'] as bool? ?? false,
      createdBy: json['createdBy'] as String,
      sharedWith: List<String>.from(json['sharedWith'] ?? []),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspaceId': workspaceId,
        'title': title,
        'content': content,
        'tags': tags,
        'folderId': folderId,
        'pinned': pinned,
        'archived': archived,
        'favorite': favorite,
        'createdBy': createdBy,
        'sharedWith': sharedWith,
        'attachments': attachments.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  NoteModel copyWith({
    String? id,
    String? workspaceId,
    String? title,
    String? content,
    List<String>? tags,
    String? folderId,
    bool? pinned,
    bool? archived,
    bool? favorite,
    String? createdBy,
    List<String>? sharedWith,
    List<AttachmentModel>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      folderId: folderId ?? this.folderId,
      pinned: pinned ?? this.pinned,
      archived: archived ?? this.archived,
      favorite: favorite ?? this.favorite,
      createdBy: createdBy ?? this.createdBy,
      sharedWith: sharedWith ?? this.sharedWith,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NoteModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Klasör modeli.
class FolderModel {
  final String id;
  final String workspaceId;
  final String name;

  const FolderModel({
    required this.id,
    required this.workspaceId,
    required this.name,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspaceId': workspaceId,
        'name': name,
      };

  FolderModel copyWith({String? id, String? workspaceId, String? name}) {
    return FolderModel(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
    );
  }
}

/// Etiket modeli.
class TagModel {
  final String id;
  final String workspaceId;
  final String title;
  final int color;

  const TagModel({
    required this.id,
    required this.workspaceId,
    required this.title,
    required this.color,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      title: json['title'] as String,
      color: json['color'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspaceId': workspaceId,
        'title': title,
        'color': color,
      };
}
