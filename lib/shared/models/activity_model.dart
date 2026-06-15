import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String id;
  final String workspaceId;
  final String userId;
  final String actionType; // 'created', 'updated', 'deleted', 'completed'
  final String resourceType; // 'note', 'task', 'reminder'
  final String resourceId;
  final String resourceName;
  final DateTime createdAt;

  ActivityModel({
    required this.id,
    required this.workspaceId,
    required this.userId,
    required this.actionType,
    required this.resourceType,
    required this.resourceId,
    required this.resourceName,
    required this.createdAt,
  });

  factory ActivityModel.fromMap(Map<String, dynamic> map, String id) {
    return ActivityModel(
      id: id,
      workspaceId: map['workspaceId'] ?? '',
      userId: map['userId'] ?? '',
      actionType: map['actionType'] ?? '',
      resourceType: map['resourceType'] ?? '',
      resourceId: map['resourceId'] ?? '',
      resourceName: map['resourceName'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workspaceId': workspaceId,
      'userId': userId,
      'actionType': actionType,
      'resourceType': resourceType,
      'resourceId': resourceId,
      'resourceName': resourceName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
