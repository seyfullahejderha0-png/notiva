import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../models/task_model.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCardWidget({super.key, required this.task, this.onTap});

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low: return AppColors.priorityLow;
      case TaskPriority.medium: return AppColors.priorityMedium;
      case TaskPriority.high: return AppColors.priorityHigh;
      case TaskPriority.critical: return AppColors.priorityCritical;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending: return AppColors.statusPending;
      case TaskStatus.inProgress: return AppColors.statusInProgress;
      case TaskStatus.completed: return AppColors.statusCompleted;
      case TaskStatus.cancelled: return AppColors.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;
    final priorityColor = _getPriorityColor(task.priority);
    final statusColor = _getStatusColor(task.status);

    return NotivaCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? statusColor : Colors.transparent,
              border: Border.all(color: isCompleted ? statusColor : priorityColor, width: 2),
            ),
            child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTypography.titleSmall.copyWith(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? context.textTertiary : context.textPrimary,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  SizedBox(height: 2),
                  Text(task.description, style: AppTypography.bodySmall.copyWith(color: context.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(task.priority.displayLabel(context), style: AppTypography.labelSmall.copyWith(color: priorityColor, fontSize: 10)),
                    ),
                    if (task.dueDate != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 12, color: context.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            '${task.dueDate!.day}.${task.dueDate!.month}.${task.dueDate!.year}',
                            style: AppTypography.labelSmall.copyWith(color: context.textTertiary, fontSize: 10),
                          ),
                        ],
                      ),
                    if (task.subtasks.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.checklist_rounded, size: 12, color: context.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            '${task.completedSubtasksCount}/${task.subtasks.length}',
                            style: AppTypography.labelSmall.copyWith(color: context.textTertiary, fontSize: 10),
                          ),
                        ],
                      ),
                    if (task.repeat != RepeatType.none)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.repeat_rounded, size: 12, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            task.repeat.displayLabel(context),
                            style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
