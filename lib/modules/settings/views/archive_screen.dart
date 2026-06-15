import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../notes/controllers/notes_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../../todos/controllers/todos_controller.dart';
import '../../reminders/controllers/reminders_controller.dart';
import '../../../shared/widgets/notiva_empty_state.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:nexus_app/l10n/app_localizations.dart';

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.archive),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: context.textTertiary,
          indicatorColor: AppColors.primary,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.searchNotes, icon: const Icon(Icons.note_alt_outlined)),
            Tab(text: AppLocalizations.of(context)!.searchTasks, icon: const Icon(Icons.check_circle_outline)),
            Tab(text: AppLocalizations.of(context)!.searchTodos, icon: const Icon(Icons.checklist_rtl_rounded)),
            Tab(text: AppLocalizations.of(context)!.reminders, icon: const Icon(Icons.notifications_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotesArchive(),
          _buildTasksArchive(),
          _buildTodosArchive(),
          _buildRemindersArchive(),
        ],
      ),
    );
  }

  Widget _buildNotesArchive() {
    final notesState = ref.watch(notesControllerProvider);
    final archivedNotes = notesState.state.notes.where((n) => n.archived == true).toList();

    if (archivedNotes.isEmpty) {
      return NotivaEmptyState(
        icon: Icons.archive_outlined,
        title: AppLocalizations.of(context)!.noArchiveWarning,
        subtitle: AppLocalizations.of(context)!.archiveEmptyWarning,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: archivedNotes.length,
      itemBuilder: (context, index) {
        final note = archivedNotes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: context.dividerColor, width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(note.title, style: AppTypography.titleMedium),
            subtitle: Text(
              DateFormat('dd MMM yyyy').format(note.updatedAt),
              style: AppTypography.labelSmall.copyWith(color: context.textTertiary),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.unarchive_outlined, color: AppColors.primary),
              tooltip: AppLocalizations.of(context)!.unarchiveTooltip,
              onPressed: () {
                final updated = note.copyWith(archived: false);
                ref.read(notesControllerProvider).updateNote(updated);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.itemUnarchived)));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTasksArchive() {
    final tasksState = ref.watch(tasksControllerProvider);
    final archivedTasks = tasksState.tasks.where((t) => t.isArchived == true).toList();

    if (archivedTasks.isEmpty) {
      return NotivaEmptyState(
        icon: Icons.archive_outlined,
        title: AppLocalizations.of(context)!.noArchiveWarning,
        subtitle: AppLocalizations.of(context)!.archiveEmptyWarning,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: archivedTasks.length,
      itemBuilder: (context, index) {
        final task = archivedTasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: context.dividerColor, width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(task.title, style: AppTypography.titleMedium),
            subtitle: Text(
              '${AppLocalizations.of(context)!.statusLabel}: ${task.status.displayLabel(context)}',
              style: AppTypography.labelSmall.copyWith(color: context.textTertiary),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.unarchive_outlined, color: AppColors.warning),
              tooltip: AppLocalizations.of(context)!.unarchiveTooltip,
              onPressed: () {
                final updated = task.copyWith(isArchived: false);
                ref.read(tasksControllerProvider.notifier).updateTask(updated);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.itemUnarchived)));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodosArchive() {
    final state = ref.watch(todosControllerProvider);
    final archivedTodos = state.todos.where((t) => t.isArchived == true).toList();

    if (archivedTodos.isEmpty) {
      return NotivaEmptyState(
        icon: Icons.archive_outlined,
        title: AppLocalizations.of(context)!.noArchiveWarning,
        subtitle: AppLocalizations.of(context)!.archiveEmptyWarning,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: archivedTodos.length,
      itemBuilder: (context, index) {
        final todo = archivedTodos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: context.dividerColor, width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(todo.title, style: AppTypography.titleMedium),
            subtitle: Text(
              '${todo.items.where((i) => i.isCompleted).length} / ${todo.items.length} ${AppLocalizations.of(context)!.completedItemsTab}',
              style: AppTypography.labelSmall.copyWith(color: context.textTertiary),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.unarchive_outlined, color: Color(0xFF14B8A6)),
              tooltip: AppLocalizations.of(context)!.unarchiveTooltip,
              onPressed: () {
                final updated = todo.copyWith(isArchived: false);
                ref.read(todosControllerProvider.notifier).updateTodoList(updated);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.itemUnarchived)));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRemindersArchive() {
    final remindersState = ref.watch(remindersControllerProvider);
    final archivedReminders = remindersState.state.reminders.where((r) => r.isArchived == true).toList();

    if (archivedReminders.isEmpty) {
      return NotivaEmptyState(
        icon: Icons.archive_outlined,
        title: AppLocalizations.of(context)!.noArchiveWarning,
        subtitle: AppLocalizations.of(context)!.archiveEmptyWarning,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: archivedReminders.length,
      itemBuilder: (context, index) {
        final reminder = archivedReminders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: context.dividerColor, width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(reminder.title, style: AppTypography.titleMedium),
            subtitle: Text(
              DateFormat('dd MMM yyyy, HH:mm').format(reminder.date),
              style: AppTypography.labelSmall.copyWith(color: context.textTertiary),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.unarchive_outlined, color: AppColors.secondary),
              tooltip: AppLocalizations.of(context)!.unarchiveTooltip,
              onPressed: () {
                final updated = reminder.copyWith(isArchived: false);
                ref.read(remindersControllerProvider).updateReminder(updated);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.itemUnarchived)));
              },
            ),
          ),
        );
      },
    );
  }
}
