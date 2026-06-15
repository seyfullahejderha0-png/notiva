import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';
import '../../../shared/controllers/activity_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../shared/services/notification_service.dart';
import '../../../shared/utils/subscription_limits.dart';
import '../../../shared/services/notification_translator.dart';

// ─── Enums ──────────────────────────────────────────────────────────────────

/// View mode for the notes list screen.
enum NotesViewMode { grid, list }

/// Filter for which subset of notes to display.
enum NotesFilter { all, pinned, favorites, archived }

// ─── State ──────────────────────────────────────────────────────────────────

/// Immutable state object for the notes module.
class NotesState {
  final List<NoteModel> notes;
  final List<FolderModel> folders;
  final List<TagModel> tags;
  final FolderModel? selectedFolder;
  final String? selectedTagId;
  final NotesFilter filter;
  final String searchQuery;
  final bool isLoading;
  final NotesViewMode viewMode;

  const NotesState({
    this.notes = const [],
    this.folders = const [],
    this.tags = const [],
    this.selectedFolder,
    this.selectedTagId,
    this.filter = NotesFilter.all,
    this.searchQuery = '',
    this.isLoading = false,
    this.viewMode = NotesViewMode.grid,
  });

  /// Returns notes filtered by current folder, tag, filter, and search query.
  List<NoteModel> get filteredNotes {
    var result = List<NoteModel>.from(notes);

    // Filter by archive / pinned / favorites
    switch (filter) {
      case NotesFilter.all:
        result = result.where((n) => !n.archived).toList();
      case NotesFilter.pinned:
        result = result.where((n) => n.pinned && !n.archived).toList();
      case NotesFilter.favorites:
        result = result.where((n) => n.favorite && !n.archived).toList();
      case NotesFilter.archived:
        result = result.where((n) => n.archived).toList();
    }

    // Filter by folder
    if (selectedFolder != null) {
      result =
          result.where((n) => n.folderId == selectedFolder!.id).toList();
    }

    // Filter by tag
    if (selectedTagId != null) {
      result =
          result.where((n) => n.tags.contains(selectedTagId)).toList();
    }

    // Search
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result
          .where((n) =>
              n.title.toLowerCase().contains(q) ||
              n.content.toLowerCase().contains(q))
          .toList();
    }

    // Pinned notes first, then by updatedAt descending
    result.sort((a, b) {
      if (a.pinned && !b.pinned) return -1;
      if (!a.pinned && b.pinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return result;
  }

  /// Pinned notes from the filtered list.
  List<NoteModel> get pinnedNotes =>
      filteredNotes.where((n) => n.pinned).toList();

  /// Unpinned notes from the filtered list.
  List<NoteModel> get unpinnedNotes =>
      filteredNotes.where((n) => !n.pinned).toList();

  /// How many notes belong to a given folder.
  int noteCountForFolder(String folderId) =>
      notes.where((n) => n.folderId == folderId && !n.archived).length;

  NotesState copyWith({
    List<NoteModel>? notes,
    List<FolderModel>? folders,
    List<TagModel>? tags,
    FolderModel? selectedFolder,
    String? selectedTagId,
    NotesFilter? filter,
    String? searchQuery,
    bool? isLoading,
    NotesViewMode? viewMode,
    bool clearSelectedFolder = false,
    bool clearSelectedTag = false,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      folders: folders ?? this.folders,
      tags: tags ?? this.tags,
      selectedFolder:
          clearSelectedFolder ? null : (selectedFolder ?? this.selectedFolder),
      selectedTagId:
          clearSelectedTag ? null : (selectedTagId ?? this.selectedTagId),
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      viewMode: viewMode ?? this.viewMode,
    );
  }
}

// ─── Controller ─────────────────────────────────────────────────────────────

/// Riverpod-style StateNotifier that manages the entire notes module state.
class NotesController extends ChangeNotifier {
  NotesState _state = const NotesState();
  NotesState get state => _state;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;
  
  String? _workspaceId;

  NotesController(this._ref);

  void _emit(NotesState newState) {
    _state = newState;
    notifyListeners();
  }

  // ── Data loading ────────────────────────────────────────────────────────


  Future<void> loadNotes(String workspaceId) async {
    _workspaceId = workspaceId;
    _emit(_state.copyWith(isLoading: true));

    // Notları dinle
    _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('notes')
        .snapshots()
        .listen((snapshot) {
      final notes = snapshot.docs.map((doc) => NoteModel.fromJson(doc.data())).toList();
      _emit(_state.copyWith(notes: notes, isLoading: false));
    });
    
    // TODO: Folders ve Tags için de benzer dinleyiciler eklenebilir. Şimdilik boş bırakıyoruz.
  }

  // ── CRUD — Notes ────────────────────────────────────────────────────────

  void createNote(NoteModel note) {
    final limitChecker = _ref.read(limitCheckProvider);
    if (!limitChecker.canCreateNote(_state.notes.length)) {
      throw LimitExceededException('Not limitine ulaştınız. Daha fazla not oluşturmak için planınızı yükseltin.');
    }
    _firestore.collection('workspaces').doc(note.workspaceId).collection('notes').doc(note.id).set(note.toJson());
    _ref.read(activityControllerProvider.notifier).logActivity(
      actionType: 'created',
      resourceType: 'note',
      resourceId: note.id,
      resourceName: note.title,
    );
    
    // Takım çalışma alanındaysa üyelere bildirim gönder
    final activeWs = _ref.read(workspaceControllerProvider).activeWorkspace;
    if (activeWs != null && activeWs.type == 'team') {
      final currentUserId = _ref.read(authControllerProvider).user?.id;
      final targetIds = activeWs.members.where((m) => m != currentUserId).toList();
      if (targetIds.isNotEmpty) {
        _ref.read(notificationServiceProvider).sendInstantNotification(
          headings: NotificationTranslator.getNoteAddedTitle(),
          contents: NotificationTranslator.getNoteAddedMessage(activeWs.name, note.title),
          targetUserIds: targetIds,
        );
      }
    }
  }

  void updateNote(NoteModel note) {
    _firestore.collection('workspaces').doc(note.workspaceId).collection('notes').doc(note.id).update(note.toJson());
    _ref.read(activityControllerProvider.notifier).logActivity(
      actionType: 'updated',
      resourceType: 'note',
      resourceId: note.id,
      resourceName: note.title,
    );
    
    // Takım çalışma alanındaysa üyelere bildirim gönder
    final activeWs = _ref.read(workspaceControllerProvider).activeWorkspace;
    if (activeWs != null && activeWs.type == 'team') {
      final currentUserId = _ref.read(authControllerProvider).user?.id;
      final targetIds = activeWs.members.where((m) => m != currentUserId).toList();
      if (targetIds.isNotEmpty) {
        _ref.read(notificationServiceProvider).sendInstantNotification(
          headings: NotificationTranslator.getNoteUpdatedTitle(),
          contents: NotificationTranslator.getNoteUpdatedMessage(activeWs.name, note.title),
          targetUserIds: targetIds,
        );
      }
    }
  }

  void deleteNote(String id, {String? workspaceId}) {
    final wsId = workspaceId ?? _workspaceId;
    if (wsId == null) return;
    
    // İsmi almak için (basit bir not diyelim, silinmeden önce ismi elimizde yok burada)
    _firestore.collection('workspaces').doc(wsId).collection('notes').doc(id).delete();
    _ref.read(activityControllerProvider.notifier).logActivity(
      actionType: 'deleted',
      resourceType: 'note',
      resourceId: id,
      resourceName: 'Bir not',
    );
  }

  void togglePin(String id) {
    final note = _state.notes.firstWhere((n) => n.id == id);
    updateNote(note.copyWith(pinned: !note.pinned, updatedAt: DateTime.now()));
  }

  void toggleFavorite(String id) {
    final note = _state.notes.firstWhere((n) => n.id == id);
    updateNote(note.copyWith(favorite: !note.favorite, updatedAt: DateTime.now()));
  }

  void toggleArchive(String id) {
    final note = _state.notes.firstWhere((n) => n.id == id);
    updateNote(note.copyWith(archived: !note.archived, updatedAt: DateTime.now()));
  }

  // ── Search & Filter ─────────────────────────────────────────────────────

  void searchNotes(String query) {
    _emit(_state.copyWith(searchQuery: query));
  }

  void setFilter(NotesFilter filter) {
    _emit(_state.copyWith(filter: filter));
  }

  void filterByFolder(FolderModel? folder) {
    if (folder == null) {
      _emit(_state.copyWith(clearSelectedFolder: true));
    } else {
      _emit(_state.copyWith(selectedFolder: folder));
    }
  }

  void filterByTag(String? tagId) {
    if (tagId == null) {
      _emit(_state.copyWith(clearSelectedTag: true));
    } else {
      _emit(_state.copyWith(selectedTagId: tagId));
    }
  }

  // ── CRUD — Folders ──────────────────────────────────────────────────────

  void createFolder(String name, {String workspaceId = 'ws1'}) {
    final folder = FolderModel(
      id: 'f${DateTime.now().millisecondsSinceEpoch}',
      workspaceId: workspaceId,
      name: name,
    );
    _emit(_state.copyWith(folders: [..._state.folders, folder]));
  }

  void updateFolder(String id, String newName) {
    final updated =
        _state.folders.map((f) => f.id == id ? f.copyWith(name: newName) : f).toList();
    _emit(_state.copyWith(folders: updated));
  }

  void deleteFolder(String id) {
    // Un-assign notes from deleted folder
    final updatedNotes = _state.notes.map((n) {
      if (n.folderId == id) return n.copyWith(folderId: null);
      return n;
    }).toList();

    _emit(_state.copyWith(
      folders: _state.folders.where((f) => f.id != id).toList(),
      notes: updatedNotes,
      clearSelectedFolder: _state.selectedFolder?.id == id,
    ));
  }

  // ── CRUD — Tags ─────────────────────────────────────────────────────────

  void createTag(String title, int color, {String workspaceId = 'ws1'}) {
    final tag = TagModel(
      id: 't${DateTime.now().millisecondsSinceEpoch}',
      workspaceId: workspaceId,
      title: title,
      color: color,
    );
    _emit(_state.copyWith(tags: [..._state.tags, tag]));
  }

  void deleteTag(String id) {
    // Remove tag from all notes
    final updatedNotes = _state.notes.map((n) {
      if (!n.tags.contains(id)) return n;
      return n.copyWith(tags: n.tags.where((t) => t != id).toList());
    }).toList();

    _emit(_state.copyWith(
      tags: _state.tags.where((t) => t.id != id).toList(),
      notes: updatedNotes,
      clearSelectedTag: _state.selectedTagId == id,
    ));
  }

  // ── View Mode ───────────────────────────────────────────────────────────

  void toggleViewMode() {
    _emit(_state.copyWith(
      viewMode: _state.viewMode == NotesViewMode.grid
          ? NotesViewMode.list
          : NotesViewMode.grid,
    ));
  }
}

// ─── Provider ───────────────────────────────────────────────────────────────

final notesControllerProvider = ChangeNotifierProvider.autoDispose<NotesController>((ref) {
  final controller = NotesController(ref);
  final activeWorkspace = ref.watch(activeWorkspaceProvider);
  if (activeWorkspace != null) {
    controller.loadNotes(activeWorkspace.id);
  }
  return controller;
});
