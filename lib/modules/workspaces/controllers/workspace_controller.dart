import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/controllers/auth_controller.dart';
import '../models/workspace_model.dart';

/// Çalışma alanı durumu.
class WorkspaceState {
  final List<WorkspaceModel> workspaces;
  final WorkspaceModel? activeWorkspace;
  final bool isLoading;

  const WorkspaceState({
    this.workspaces = const [],
    this.activeWorkspace,
    this.isLoading = false,
  });

  WorkspaceState copyWith({
    List<WorkspaceModel>? workspaces,
    WorkspaceModel? activeWorkspace,
    bool? isLoading,
  }) {
    return WorkspaceState(
      workspaces: workspaces ?? this.workspaces,
      activeWorkspace: activeWorkspace ?? this.activeWorkspace,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Çalışma alanı controller'ı.
class WorkspaceController extends StateNotifier<WorkspaceState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  WorkspaceController(this._ref) : super(const WorkspaceState()) {
    _init();
  }

  void _init() {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return;

    state = state.copyWith(isLoading: true);

    // Kullanıcının dahil olduğu tüm workspace'leri (Kişisel + Ekipler) dinle
    _firestore
        .collection('workspaces')
        .where('members', arrayContains: user.id)
        .snapshots()
        .listen((snapshot) async {
      final workspaces = snapshot.docs.map((doc) => WorkspaceModel.fromJson(doc.data())).toList();

      // Eğer hiç workspace yoksa, varsayılan "Kişisel" alanı oluştur
      if (workspaces.isEmpty) {
        await _createPersonalWorkspace(user.id);
      } else {
        // Workspace'leri sırala: Önce Kişisel, sonra oluşturulma tarihi
        workspaces.sort((a, b) {
          if (a.type == 'personal') return -1;
          if (b.type == 'personal') return 1;
          return a.createdAt.compareTo(b.createdAt);
        });

        // Aktif workspace yoksa veya silinmişse ilkini (Kişisel) seç
        final currentActive = state.activeWorkspace;
        final newActive = workspaces.any((w) => w.id == currentActive?.id)
            ? currentActive
            : workspaces.first;

        if (mounted) {
          state = state.copyWith(
            workspaces: workspaces,
            activeWorkspace: newActive,
            isLoading: false,
          );
        }
      }
    });
  }

  Future<void> _createPersonalWorkspace(String userId) async {
    final ws = WorkspaceModel(
      id: 'ws_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}',
      name: 'Kişisel',
      icon: 'person',
      color: 0xFF2563EB,
      ownerId: userId,
      members: [userId],
      memberPermissions: {
        userId: {
          'notes': 'write',
          'tasks': 'write',
          'todos': 'write',
          'reminders': 'write',
        }
      },
      type: 'personal',
      createdAt: DateTime.now(),
    );
    await _firestore.collection('workspaces').doc(ws.id).set(ws.toJson());
  }

  void switchWorkspace(String id) {
    final ws = state.workspaces.firstWhere((w) => w.id == id);
    state = state.copyWith(activeWorkspace: ws);
  }

  Future<WorkspaceModel?> createTeam(String name, int color) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return null;

    final inviteCode = _generateInviteCode();
    final ws = WorkspaceModel(
      id: 'team_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      icon: 'group',
      color: color,
      ownerId: user.id,
      members: [user.id],
      memberPermissions: {
        user.id: {
          'notes': 'write',
          'tasks': 'write',
          'todos': 'write',
          'reminders': 'write',
        }
      },
      type: 'team',
      inviteCode: inviteCode,
      createdAt: DateTime.now(),
    );

    // Önce local state'e ekle (anında UI güncellenir)
    state = state.copyWith(
      workspaces: [...state.workspaces, ws],
      activeWorkspace: ws,
    );

    // Arka planda Firestore'a kaydet
    _firestore.collection('workspaces').doc(ws.id).set(ws.toJson()).then((_) {
      debugPrint('Team saved to Firestore: ${ws.id}, inviteCode: $inviteCode');
    }).catchError((e) {
      debugPrint('Firestore team creation error: $e');
    });

    return ws;
  }

  /// Returns: 'ok' | 'already_member' | 'invalid'
  Future<String> joinTeam(String code) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return 'invalid';

    final cleanCode = code.toUpperCase().trim();

    try {
      // 2 deneme yap (Firestore sync gecikmesine karşı)
      for (int attempt = 0; attempt < 2; attempt++) {
        final snapshot = await _firestore
            .collection('workspaces')
            .where('inviteCode', isEqualTo: cleanCode)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          final ws = WorkspaceModel.fromJson(doc.data());

          if (ws.members.contains(user.id)) return 'already_member';

          await doc.reference.update({
            'members': FieldValue.arrayUnion([user.id]),
            'memberPermissions.${user.id}': {
              'notes': 'write',
              'tasks': 'write',
              'todos': 'write',
              'reminders': 'write',
            }
          });

          return 'ok';
        }

        // İlk denemede bulunamadıysa 2 saniye bekle ve tekrar dene
        if (attempt == 0) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      return 'invalid';
    } catch (e) {
      debugPrint('joinTeam error: $e');
      return 'HATA: $e';
    }
  }

  Future<void> leaveOrDeleteTeam(String id) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return;

    final ws = state.workspaces.firstWhere((w) => w.id == id);
    if (ws.type == 'personal') return; // Kişisel silinemez

    if (ws.ownerId == user.id) {
      // Admin ise tamamen sil
      await _firestore.collection('workspaces').doc(id).delete();
    } else {
      // Üye ise ayrıl
      await _firestore.collection('workspaces').doc(id).update({
        'members': FieldValue.arrayRemove([user.id])
      });
    }
  }

  Future<void> removeMember(String teamId, String memberId) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return;

    final ws = state.workspaces.firstWhere((w) => w.id == teamId);
    if (ws.ownerId != user.id) return; // Sadece admin silebilir

    await _firestore.collection('workspaces').doc(teamId).update({
      'members': FieldValue.arrayRemove([memberId]),
      'memberPermissions.$memberId': FieldValue.delete(),
    });
  }

  Future<void> updateMemberPermissions(String teamId, String memberId, Map<String, String> permissions) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return;

    final ws = state.workspaces.firstWhere((w) => w.id == teamId);
    if (ws.ownerId != user.id) return; // Sadece admin değiştirebilir

    await _firestore.collection('workspaces').doc(teamId).update({
      'memberPermissions.$memberId': permissions,
    });
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  IconData getWorkspaceIcon(String iconName) {
    switch (iconName) {
      case 'person': return Icons.person_rounded;
      case 'group': return Icons.group_rounded;
      default: return Icons.workspaces_rounded;
    }
  }
}

final workspaceControllerProvider =
    StateNotifierProvider.autoDispose<WorkspaceController, WorkspaceState>((ref) {
  return WorkspaceController(ref);
});

final activeWorkspaceProvider = Provider.autoDispose<WorkspaceModel?>((ref) {
  return ref.watch(workspaceControllerProvider).activeWorkspace;
});

final userDetailsProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return doc.data();
});
