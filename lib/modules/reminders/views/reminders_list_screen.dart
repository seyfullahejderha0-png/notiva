import 'package:flutter/material.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../../shared/widgets/notiva_empty_state.dart';
import '../controllers/reminders_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../../auth/controllers/auth_controller.dart';

/// Hatırlatıcılar listesi ekranı.
class RemindersListScreen extends ConsumerWidget {
  const RemindersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(remindersControllerProvider);
    final state = controller.state;
    final reminders = state.reminders.where((r) => !r.isArchived).toList();
    
    final workspaceState = ref.watch(workspaceControllerProvider);
    final activeWs = workspaceState.activeWorkspace;
    final user = ref.watch(authControllerProvider).user;
    
    bool hasWritePerm = true;
    if (activeWs != null && user != null && activeWs.ownerId != user.id) {
      final perms = activeWs.memberPermissions[user.id] ?? {};
      if (perms['reminders'] == 'read') {
        hasWritePerm = false;
      }
    }

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.reminders)),
      body: state.isLoading
          ? Center(child: CircularProgressIndicator())
          : reminders.isEmpty
              ? NotivaEmptyState(
                  icon: Icons.notifications_outlined,
                  title: AppLocalizations.of(context)!.noRemindersYet,
                  subtitle: hasWritePerm ? AppLocalizations.of(context)!.createFirstReminder : null,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: reminders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return Dismissible(
                      key: Key(reminder.id),
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
                        final updated = reminder.copyWith(isArchived: true);
                        ref.read(remindersControllerProvider.notifier).updateReminder(updated);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.reminderArchived)));
                      },
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/reminder-create', arguments: reminder),
                        child: NotivaCard(
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: reminder.notificationEnabled
                                      ? AppColors.warning.withOpacity(0.1)
                                      : context.bgSurfaceVariant,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  reminder.notificationEnabled
                                      ? Icons.notifications_active_rounded
                                      : Icons.notifications_off_outlined,
                                  color: reminder.notificationEnabled
                                      ? AppColors.warning
                                      : context.textTertiary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reminder.title, style: AppTypography.titleSmall),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_rounded, size: 14, color: context.textTertiary),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${reminder.date.day}.${reminder.date.month}.${reminder.date.year} ${reminder.date.hour.toString().padLeft(2, '0')}:${reminder.date.minute.toString().padLeft(2, '0')}',
                                          style: AppTypography.bodySmall.copyWith(color: context.textTertiary),
                                        ),
                                        if (reminder.repeatLabel.isNotEmpty) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryLight,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(reminder.repeatLabel, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    if (reminder.assignedTo != null) ...[
                                      SizedBox(height: 4),
                                      Text(
                                        AppLocalizations.of(context)!.assignedTo,
                                        style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Switch(
                                value: reminder.notificationEnabled,
                                onChanged: (v) {
                                  ref.read(remindersControllerProvider.notifier).toggleNotification(reminder.id);
                                },
                                activeThumbColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: hasWritePerm ? FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/reminder-create'),
        child: const Icon(Icons.add_rounded),
      ) : null,
    );
  }
}
