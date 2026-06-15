import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String workspaceId;
  final String resourceId; // noteId or taskId
  final String resourceType; // 'note', 'task', etc.
  final String userId;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.workspaceId,
    required this.resourceId,
    required this.resourceType,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String id) {
    return CommentModel(
      id: id,
      workspaceId: map['workspaceId'] ?? '',
      resourceId: map['resourceId'] ?? '',
      resourceType: map['resourceType'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workspaceId': workspaceId,
      'resourceId': resourceId,
      'resourceType': resourceType,
      'userId': userId,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  CommentModel copyWith({
    String? id,
    String? workspaceId,
    String? resourceId,
    String? resourceType,
    String? userId,
    String? content,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      resourceId: resourceId ?? this.resourceId,
      resourceType: resourceType ?? this.resourceType,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
