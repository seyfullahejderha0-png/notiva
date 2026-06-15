import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../models/reminder_model.dart';
import '../../../shared/controllers/activity_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../shared/services/notification_service.dart';

// ── State ──────────────────────────────────────────────────────────────

class RemindersState {
  final List<ReminderModel> reminders;
  final bool isLoading;

  const RemindersState({
    this.reminders = const [],
    this.isLoading = false,
  });

  RemindersState copyWith({
    List<ReminderModel>? reminders,
    bool? isLoading,
  }) {
    return RemindersState(
      reminders: reminders ?? this.reminders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ── Controller ─────────────────────────────────────────────────────────

class RemindersController extends ChangeNotifier {
  RemindersState _state = const RemindersState();
  RemindersState get state => _state;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;
  String? _workspaceId;

  RemindersController(this._ref);

  Future<void> loadReminders(String workspaceId) async {
    _workspaceId = workspaceId;
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('reminders')
        .snapshots()
        .listen((snapshot) {
      final reminders = snapshot.docs.map((doc) => ReminderModel.fromJson(doc.data())).toList();
      
      // Tarihe göre sırala (yakından uzağa)
      reminders.sort((a, b) => a.date.compareTo(b.date));

      _state = _state.copyWith(
        reminders: reminders,
        isLoading: false,
      );
      notifyListeners();
    }, onError: (error) {
      debugPrint('Reminders listen error: $error');
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    });
  }

  Future<void> createReminder(ReminderModel reminder) async {
    final id = reminder.id.isEmpty || reminder.id.startsWith('mock_') 
        ? 'rem_${DateTime.now().millisecondsSinceEpoch}' 
        : reminder.id;
        
    final newReminder = reminder.copyWith(id: id);
    await _firestore
        .collection('workspaces')
        .doc(newReminder.workspaceId)
        .collection('reminders')
        .doc(id)
        .set(newReminder.toJson());

    _ref.read(activityControllerProvider.notifier).logActivity(
      actionType: 'created',
      resourceType: 'reminder',
      resourceId: id,
      resourceName: newReminder.title,
    );
    
    // Hatırlatıcı için bildirim kur
    final currentUserId = _ref.read(authControllerProvider).user?.id;
    if (currentUserId != null) {
      final notifService = _ref.read(notificationServiceProvider);
      
      // 1 gün önce 09:00
      final oneDayBefore = newReminder.date.subtract(const Duration(days: 1));
      final schedule1 = DateTime(oneDayBefore.year, oneDayBefore.month, oneDayBefore.day, 9, 0);
      if (schedule1.isAfter(DateTime.now())) {
        notifService.scheduleNotification(title: 'Yaklaşan Hatırlatıcı', message: 'Yarına planlanmış bir hatırlatıcın var: ${newReminder.title}', targetUserIds: [currentUserId], sendAfter: schedule1);
      }
      // Aynı gün 09:00
      final sameDay = DateTime(newReminder.date.year, newReminder.date.month, newReminder.date.day, 9, 0);
      if (sameDay.isAfter(DateTime.now())) {
        notifService.scheduleNotification(title: 'Bugün Hatırlatıcı', message: 'Bugün için bir hatırlatıcın var: ${newReminder.title}', targetUserIds: [currentUserId], sendAfter: sameDay);
      }
    }
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    await _firestore
        .collection('workspaces')
        .doc(reminder.workspaceId)
        .collection('reminders')
        .doc(reminder.id)
        .update(reminder.toJson());

    _ref.read(activityControllerProvider.notifier).logActivity(
      actionType: 'updated',
      resourceType: 'reminder',
      resourceId: reminder.id,
      resourceName: reminder.title,
    );
  }

  Future<void> deleteReminder(String id, {String? workspaceId}) async {
    final wsId = workspaceId ?? _workspaceId;
    if (wsId == null) return;
    await _firestore
        .collection('workspaces')
        .doc(wsId)
        .collection('reminders')
        .doc(id)
        .delete();

    _ref.read(activityControllerProvider.notifier).logActivity(
      actionType: 'deleted',
      resourceType: 'reminder',
      resourceId: id,
      resourceName: 'Hatırlatıcı',
    );
  }

  Future<void> toggleNotification(String id) async {
    final reminder = _state.reminders.firstWhere((r) => r.id == id);
    await updateReminder(reminder.copyWith(notificationEnabled: !reminder.notificationEnabled));
  }
}

final remindersControllerProvider = ChangeNotifierProvider.autoDispose<RemindersController>((ref) {
  final controller = RemindersController(ref);
  final activeWorkspace = ref.watch(activeWorkspaceProvider);
  if (activeWorkspace != null) {
    controller.loadReminders(activeWorkspace.id);
  }
  return controller;
});
