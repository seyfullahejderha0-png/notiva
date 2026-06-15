import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/controllers/activity_controller.dart';
import '../controllers/workspace_controller.dart';
import '../../notes/controllers/notes_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../../../shared/widgets/notiva_empty_state.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:nexus_app/l10n/app_localizations.dart';

class ActivitiesScreen extends ConsumerWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityControllerProvider);

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.activityStreamTitle),
      ),
      body: activities.isEmpty
          ? const NotivaEmptyState(
              icon: Icons.history_rounded,
              title: 'Henüz Aktivite Yok',
              subtitle: 'Çalışma alanında yapılan işlemler burada listelenir.',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                
                return Consumer(
                  builder: (context, ref, child) {
                    final userAsync = ref.watch(userDetailsProvider(activity.userId));
                    
                    String userName = 'Biri';
                    userAsync.whenData((data) {
                      if (data != null) {
                        userName = data['name'] ?? 'Biri';
                      }
                    });

                    // Aksiyon metni
                    String actionText = '';
                    IconData actionIcon = Icons.info_outline;
                    Color actionColor = AppColors.primary;

                    switch (activity.actionType) {
                      case 'created':
                        actionText = 'ekledi';
                        actionIcon = Icons.add_circle_outline;
                        actionColor = AppColors.success;
                        break;
                      case 'updated':
                        actionText = 'güncelledi';
                        actionIcon = Icons.edit_outlined;
                        actionColor = AppColors.primary;
                        break;
                      case 'deleted':
                        actionText = 'sildi';
                        actionIcon = Icons.delete_outline;
                        actionColor = AppColors.error;
                        break;
                      case 'completed':
                        actionText = 'tamamladı';
                        actionIcon = Icons.check_circle_outline;
                        actionColor = AppColors.warning;
                        break;
                    }

                    String resourceText = '';
                    switch (activity.resourceType) {
                      case 'note':
                        resourceText = 'not';
                        break;
                      case 'task':
                        resourceText = 'görev';
                        break;
                      case 'reminder':
                        resourceText = 'hatırlatıcı';
                        break;
                    }
                    String fullActionText = '';
                    if (activity.resourceType == 'task' && activity.actionType == 'updated') {
                       fullActionText = AppLocalizations.of(context)!.taskUpdatedActivity;
                    } else if (activity.resourceType == 'task' && activity.actionType == 'created') {
                       fullActionText = AppLocalizations.of(context)!.taskAddedActivity;
                    } else if (activity.resourceType == 'reminder' && activity.actionType == 'created') {
                       fullActionText = AppLocalizations.of(context)!.reminderAddedActivity;
                    } else if (activity.resourceType == 'note' && activity.actionType == 'created') {
                       fullActionText = AppLocalizations.of(context)!.noteAddedActivity;
                    } else if (activity.resourceType == 'note' && activity.actionType == 'updated') {
                       fullActionText = AppLocalizations.of(context)!.noteUpdatedActivity;
                    } else {
                       fullActionText = '$resourceText $actionText';
                    }

                    final timeFormat = DateFormat('HH:mm').format(activity.createdAt);
                    final dateFormat = DateFormat('dd MMM yyyy').format(activity.createdAt);

                    return ListTile(
                      onTap: () {
                        // Eğer öğe silinmişse gitmeye gerek yok
                        if (activity.actionType == 'deleted') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bu öğe silinmiş.')),
                          );
                          return;
                        }

                        if (activity.resourceType == 'note') {
                          final notes = ref.read(notesControllerProvider).state.notes;
                          final note = notes.where((n) => n.id == activity.resourceId).firstOrNull;
                          if (note != null) {
                            Navigator.pushNamed(context, '/note-editor', arguments: note);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not bulunamadı')));
                          }
                        } else if (activity.resourceType == 'task') {
                          final tasks = ref.read(tasksControllerProvider).tasks;
                          final task = tasks.where((t) => t.id == activity.resourceId).firstOrNull;
                          if (task != null) {
                            Navigator.pushNamed(context, '/task-detail', arguments: task);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Görev bulunamadı')));
                          }
                        }
                      },
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(actionIcon, color: actionColor),
                        ],
                      ),
                      title: RichText(
                        text: TextSpan(
                          style: AppTypography.bodyMedium,
                          children: [
                            TextSpan(text: '$userName ', style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary)),
                            TextSpan(text: fullActionText, style: TextStyle(color: context.textSecondary)),
                          ],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          activity.resourceName.isNotEmpty ? activity.resourceName : 'İsimsiz Öğre',
                          style: AppTypography.bodySmall.copyWith(color: context.textPrimary, fontStyle: FontStyle.italic),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: Text(
                        '$dateFormat\n$timeFormat',
                        style: AppTypography.labelSmall.copyWith(color: context.textTertiary),
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
