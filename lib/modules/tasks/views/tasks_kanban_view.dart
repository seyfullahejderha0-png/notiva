import 'package:flutter/material.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/task_model.dart';
import '../controllers/tasks_controller.dart';
import '../widgets/task_card_widget.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

class TasksKanbanView extends ConsumerWidget {
  final List<TaskModel> tasks;

  const TasksKanbanView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kanban Sütunları
    final columns = [
      _KanbanColumnData(title: AppLocalizations.of(context)!.pending, status: TaskStatus.pending),
      _KanbanColumnData(title: AppLocalizations.of(context)!.inProgress, status: TaskStatus.inProgress),
      _KanbanColumnData(title: 'Tamamlanan', status: TaskStatus.completed),
      _KanbanColumnData(title: AppLocalizations.of(context)!.cancel, status: TaskStatus.cancelled),
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: columns.length,
      itemBuilder: (context, index) {
        final column = columns[index];
        final columnTasks = tasks.where((t) => t.status == column.status).toList();

        return _KanbanColumn(
          data: column,
          tasks: columnTasks,
          onTaskDropped: (taskId) {
            ref.read(tasksControllerProvider.notifier).updateStatus(taskId, column.status);
          },
        );
      },
    );
  }
}

class _KanbanColumnData {
  final String title;
  final TaskStatus status;

  _KanbanColumnData({required this.title, required this.status});
}

class _KanbanColumn extends StatelessWidget {
  final _KanbanColumnData data;
  final List<TaskModel> tasks;
  final Function(String taskId) onTaskDropped;

  const _KanbanColumn({
    required this.data,
    required this.tasks,
    required this.onTaskDropped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280, // Sütun genişliği
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: context.bgSurfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sütun Başlığı
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.bgSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tasks.length.toString(),
                    style: AppTypography.labelMedium,
                  ),
                ),
              ],
            ),
          ),
          
          // Sürükle-Bırak Alanı ve Liste
          Expanded(
            child: DragTarget<String>(
              onAcceptWithDetails: (details) {
                onTaskDropped(details.data);
              },
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;

                return Container(
                  color: isHovering ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: tasks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return LongPressDraggable<String>(
                        data: task.id,
                        feedback: SizedBox(
                          width: 260, // Gölgeli sürüklenen öğe genişliği
                          child: Material(
                            color: Colors.transparent,
                            child: Opacity(
                              opacity: 0.8,
                              child: TaskCardWidget(task: task),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: TaskCardWidget(task: task),
                        ),
                        child: TaskCardWidget(
                          task: task,
                          onTap: () => Navigator.pushNamed(context, '/task-detail', arguments: task),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
