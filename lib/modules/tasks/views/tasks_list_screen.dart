import 'package:flutter/material.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_empty_state.dart';
import '../models/task_model.dart';
import '../controllers/tasks_controller.dart';
import '../../calendar/views/calendar_screen.dart';
import '../widgets/task_card_widget.dart';
import 'tasks_kanban_view.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../../auth/controllers/auth_controller.dart';

/// Görev listesi ekranı.
class TasksListScreen extends ConsumerStatefulWidget {
  const TasksListScreen({super.key});

  @override
  ConsumerState<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends ConsumerState<TasksListScreen> {
  int _selectedStatus = 0;

  bool _isKanbanView = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasksControllerProvider);
    final allTasks = state.tasks.where((t) => !t.isArchived).toList();
    final _statusTabs = [AppLocalizations.of(context)!.all, AppLocalizations.of(context)!.pending, AppLocalizations.of(context)!.inProgress, AppLocalizations.of(context)!.completedItemsTab, AppLocalizations.of(context)!.cancel];
    
    final workspaceState = ref.watch(workspaceControllerProvider);
    final activeWs = workspaceState.activeWorkspace;
    final user = ref.watch(authControllerProvider).user;
    
    bool hasWritePerm = true;
    if (activeWs != null && user != null && activeWs.ownerId != user.id) {
      final perms = activeWs.memberPermissions[user.id] ?? {};
      if (perms['tasks'] == 'read') {
        hasWritePerm = false;
      }
    }
    
    List<TaskModel> filteredTasks;
    if (_selectedStatus == 0) {
      filteredTasks = allTasks;
    } else {
      final status = TaskStatus.values[_selectedStatus - 1];
      filteredTasks = allTasks.where((t) => t.status == status).toList();
    }
    
    final tasks = filteredTasks;

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tasksLabel),
        actions: [
          IconButton(
            icon: Icon(_isKanbanView ? Icons.view_list_rounded : Icons.view_kanban_rounded),
            onPressed: () => setState(() => _isKanbanView = !_isKanbanView),
            tooltip: _isKanbanView ? AppLocalizations.of(context)!.listView : AppLocalizations.of(context)!.boardView,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined), 
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen()));
            }
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _statusTabs.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedStatus == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_statusTabs[index]),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedStatus = index),
                    selectedColor: AppColors.secondary,
                    labelStyle: AppTypography.labelMedium.copyWith(
                      color: isSelected ? AppColors.primary : context.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: tasks.isEmpty
                ? NotivaEmptyState(icon: Icons.task_alt_rounded, title: AppLocalizations.of(context)!.taskNotFound)
                : _isKanbanView
                    ? TasksKanbanView(tasks: tasks)
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: tasks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: ValueKey(task.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                              ),
                              child: const Icon(Icons.archive_outlined, color: AppColors.primary),
                            ),
                            onDismissed: (direction) {
                              final updated = task.copyWith(isArchived: true);
                              ref.read(tasksControllerProvider.notifier).updateTask(updated);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.taskArchived)));
                            },
                            child: TaskCardWidget(
                              task: task,
                              onTap: () => Navigator.pushNamed(context, '/task-detail', arguments: task),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: hasWritePerm ? FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/task-detail'),
        child: const Icon(Icons.add_rounded),
      ) : null,
    );
  }
}
