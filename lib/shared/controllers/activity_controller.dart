import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/workspaces/controllers/workspace_controller.dart';
import '../models/activity_model.dart';

final activityControllerProvider = StateNotifierProvider<ActivityController, List<ActivityModel>>((ref) {
  final activeWs = ref.watch(workspaceControllerProvider).activeWorkspace;
  final controller = ActivityController(ref);
  if (activeWs != null) {
    controller.listenToActivities(activeWs.id);
  }
  return controller;
});

class ActivityController extends StateNotifier<List<ActivityModel>> {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  ActivityController(this._ref) : super([]);

  void listenToActivities(String workspaceId) {
    _subscription?.cancel();
    _subscription = _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('activities')
        .orderBy('createdAt', descending: true)
        .limit(50) // Son 50 aktiviteyi getir
        .snapshots()
        .listen((snapshot) {
      final activities = snapshot.docs.map((doc) => ActivityModel.fromMap(doc.data(), doc.id)).toList();
      state = activities;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> logActivity({
    required String actionType,
    required String resourceType,
    required String resourceId,
    required String resourceName,
  }) async {
    final activeWs = _ref.read(workspaceControllerProvider).activeWorkspace;
    final currentUser = _ref.read(authControllerProvider).user;
    
    if (activeWs == null || currentUser == null) return;
    
    // Yalnızca ekip alanlarındaki aktiviteleri loglayalım, kişisel alanları isteğe bağlı olarak ekleyebiliriz.
    // Ancak ekip için yapıldı dendiğine göre her workspace'de de kaydedebiliriz.
    final activityRef = _firestore
        .collection('workspaces')
        .doc(activeWs.id)
        .collection('activities')
        .doc();
        
    final activity = ActivityModel(
      id: activityRef.id,
      workspaceId: activeWs.id,
      userId: currentUser.id,
      actionType: actionType,
      resourceType: resourceType,
      resourceId: resourceId,
      resourceName: resourceName,
      createdAt: DateTime.now(),
    );
    
    await activityRef.set(activity.toMap());
  }
}
