import 'package:flutter/material.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../../shared/widgets/notiva_empty_state.dart';
import '../models/note_model.dart';
import '../controllers/notes_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../../auth/controllers/auth_controller.dart';

/// Not listesi ekranı.
class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  bool _isGridView = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
  }

  Future<void> _loadViewPreference() async {
    final box = await Hive.openBox('settings_box');
    setState(() {
      _isGridView = box.get('notes_is_grid_view', defaultValue: true);
    });
  }

  Future<void> _toggleView() async {
    setState(() {
      _isGridView = !_isGridView;
    });
    final box = await Hive.openBox('settings_box');
    await box.put('notes_is_grid_view', _isGridView);
  }

  @override
  Widget build(BuildContext context) {
    final allNotes = ref.watch(notesControllerProvider).state.notes;
    final _tabs = [AppLocalizations.of(context)!.all, AppLocalizations.of(context)!.pinned, AppLocalizations.of(context)!.favorites, AppLocalizations.of(context)!.archive];
    
    List<NoteModel> filteredNotes;
    switch (_selectedTab) {
      case 1: filteredNotes = allNotes.where((n) => n.pinned && !n.archived).toList(); break;
      case 2: filteredNotes = allNotes.where((n) => n.favorite && !n.archived).toList(); break;
      case 3: filteredNotes = allNotes.where((n) => n.archived).toList(); break;
      default: filteredNotes = allNotes.where((n) => !n.archived).toList(); break;
    }

    final notes = filteredNotes;

    String emptyTitle;
    String emptySubtitle;
    bool showAction = false;
    
    final workspaceState = ref.watch(workspaceControllerProvider);
    final activeWs = workspaceState.activeWorkspace;
    final user = ref.watch(authControllerProvider).user;
    
    bool hasWritePerm = true;
    if (activeWs != null && user != null && activeWs.ownerId != user.id) {
      final perms = activeWs.memberPermissions[user.id] ?? {};
      if (perms['notes'] == 'read') {
        hasWritePerm = false;
      }
    }
    
    switch (_selectedTab) {
      case 1:
        emptyTitle = AppLocalizations.of(context)!.noPinnedNotes;
        emptySubtitle = AppLocalizations.of(context)!.pinnedNotesDesc;
        break;
      case 2:
        emptyTitle = AppLocalizations.of(context)!.noFavoriteNotes;
        emptySubtitle = AppLocalizations.of(context)!.favoriteNotesDesc;
        break;
      case 3:
        emptyTitle = AppLocalizations.of(context)!.noArchivedNotes;
        emptySubtitle = AppLocalizations.of(context)!.archivedNotesDesc;
        break;
      default:
        emptyTitle = AppLocalizations.of(context)!.noNotesYet;
        emptySubtitle = AppLocalizations.of(context)!.createFirstNote;
        showAction = hasWritePerm;
        break;
    }

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notes),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: _toggleView,
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtre tabları
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedTab == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_tabs[index]),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedTab = index),
                    selectedColor: AppColors.secondary,
                    labelStyle: AppTypography.labelMedium.copyWith(
                      color: isSelected ? AppColors.primary : context.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Not listesi/grid
          Expanded(
            child: notes.isEmpty
                ? NotivaEmptyState(
                    icon: Icons.note_alt_outlined,
                    title: emptyTitle,
                    subtitle: emptySubtitle,
                    actionLabel: showAction ? AppLocalizations.of(context)!.createNote : null,
                    onAction: showAction ? () => Navigator.pushNamed(context, '/note-editor') : null,
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return Dismissible(
                            key: Key(note.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.archive_outlined, color: AppColors.primary),
                            ),
                            onDismissed: (_) {
                              final updated = note.copyWith(archived: true);
                              ref.read(notesControllerProvider).updateNote(updated);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.noteArchived)));
                            },
                            child: _isGridView
                                ? _NoteGridCard(note: note)
                                : _NoteListCard(note: note),
                          );
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: notes.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return Dismissible(
                            key: Key(note.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.archive_outlined, color: AppColors.primary),
                            ),
                            onDismissed: (_) {
                              final updated = note.copyWith(archived: true);
                              ref.read(notesControllerProvider).updateNote(updated);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.noteArchived)));
                            },
                            child: _NoteListCard(note: note),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: hasWritePerm ? FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/note-editor'),
        child: const Icon(Icons.add_rounded),
      ) : null,
    );
  }
}

// ─── Grid Kart ───
class _NoteGridCard extends StatelessWidget {
  final NoteModel note;
  const _NoteGridCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return NotivaCard(
      onTap: () => Navigator.pushNamed(context, '/note-editor', arguments: note),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(note.title, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              if (note.pinned) Icon(Icons.push_pin_rounded, size: 16, color: AppColors.primary),
              if (note.favorite) ...[
                const SizedBox(width: 4),
                Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              note.content,
              style: AppTypography.bodySmall.copyWith(color: context.textSecondary),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          if (note.tags.isNotEmpty)
            Wrap(
              spacing: 4,
              children: note.tags.take(2).map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(tag, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10)),
              )).toList(),
            ),
        ],
      ),
    );
  }
}

// ─── Liste Kart ───
class _NoteListCard extends StatelessWidget {
  final NoteModel note;
  const _NoteListCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return NotivaCard(
      onTap: () => Navigator.pushNamed(context, '/note-editor', arguments: note),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (note.pinned) ...[
                      Icon(Icons.push_pin_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                    ],
                    Expanded(child: Text(note.title, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    if (note.favorite) Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                  ],
                ),
                SizedBox(height: 4),
                Text(note.content, style: AppTypography.bodySmall.copyWith(color: context.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
