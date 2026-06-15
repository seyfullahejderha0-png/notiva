import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../services/notification_service.dart';
import '../services/notification_translator.dart';

class CommentParams {
  final String workspaceId;
  final String resourceType; // 'note' veya 'task'
  final String resourceId;

  CommentParams({
    required this.workspaceId,
    required this.resourceType,
    required this.resourceId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentParams &&
          runtimeType == other.runtimeType &&
          workspaceId == other.workspaceId &&
          resourceType == other.resourceType &&
          resourceId == other.resourceId;

  @override
  int get hashCode =>
      workspaceId.hashCode ^ resourceType.hashCode ^ resourceId.hashCode;
}

final commentsProvider = StreamProvider.family<List<CommentModel>, CommentParams>((ref, params) {
  final firestore = FirebaseFirestore.instance;
  
  final collectionName = '${params.resourceType}s'; // note -> notes, task -> tasks

  return firestore
      .collection('workspaces')
      .doc(params.workspaceId)
      .collection(collectionName)
      .doc(params.resourceId)
      .collection('comments')
      .orderBy('createdAt', descending: false) // Eskiler üstte, yeniler altta
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CommentModel.fromMap(doc.data(), doc.id))
          .toList());
});

final commentsControllerProvider = Provider((ref) {
  return CommentsController(ref);
});

class CommentsController {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CommentsController(this._ref);

  Future<void> addComment({
    required String workspaceId,
    required String resourceType,
    required String resourceId,
    required String content,
  }) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null || content.trim().isEmpty) return;

    final collectionName = '${resourceType}s';
    
    final commentRef = _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection(collectionName)
        .doc(resourceId)
        .collection('comments')
        .doc();
        
    final comment = CommentModel(
      id: commentRef.id,
      workspaceId: workspaceId,
      resourceId: resourceId,
      resourceType: resourceType,
      userId: user.id,
      content: content.trim(),
      createdAt: DateTime.now(),
    );
    
    await commentRef.set(comment.toMap());
    
    // Bildirim gönderimi
    try {
      if (resourceType == 'task') {
        final taskDoc = await _firestore.collection('workspaces').doc(workspaceId).collection('tasks').doc(resourceId).get();
        if (taskDoc.exists) {
          final data = taskDoc.data()!;
          final assignedTo = data['assignedTo'] as String?;
          final title = data['title'] ?? 'Görev';
          if (assignedTo != null && assignedTo != user.id) {
            _ref.read(notificationServiceProvider).sendInstantNotification(
              headings: NotificationTranslator.getCommentAddedTitle('task'),
              contents: NotificationTranslator.getCommentAddedMessage(user.name ?? 'Biri', 'Göreve yorum yaptı'),
              targetUserIds: [assignedTo],
            );
          }
        }
      } else if (resourceType == 'note') {
        final wsDoc = await _firestore.collection('workspaces').doc(workspaceId).get();
        if (wsDoc.exists) {
          final members = List<String>.from(wsDoc.data()?['members'] ?? []);
          final targetIds = members.where((m) => m != user.id).toList();
          if (targetIds.isNotEmpty) {
            _ref.read(notificationServiceProvider).sendInstantNotification(
              headings: NotificationTranslator.getCommentAddedTitle('note'),
              contents: NotificationTranslator.getCommentAddedMessage(user.name ?? 'Biri', 'Nota yorum yaptı'),
              targetUserIds: targetIds,
            );
          }
        }
      }
    } catch (e) {
      // Bildirim hatası yorumu engellemesin
      print('Comment notification error: $e');
    }
  }

  Future<void> deleteComment({
    required String workspaceId,
    required String resourceType,
    required String resourceId,
    required String commentId,
  }) async {
    final collectionName = '${resourceType}s';
    await _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection(collectionName)
        .doc(resourceId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}
