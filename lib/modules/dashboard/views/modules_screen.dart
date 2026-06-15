import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../../auth/controllers/auth_controller.dart';

import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

class ModulesScreen extends ConsumerWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.modules),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final workspaceState = ref.watch(workspaceControllerProvider);
          final activeWs = workspaceState.activeWorkspace;
          final user = ref.watch(authControllerProvider).user;
          
          String getPerm(String module) {
            if (activeWs == null || user == null) return 'write'; // fallback
            if (activeWs.ownerId == user.id) return 'write';
            final perms = activeWs.memberPermissions[user.id] ?? {};
            return perms[module] ?? 'write'; // default to write if missing
          }

          final notesPerm = getPerm('notes');
          final tasksPerm = getPerm('tasks');
          final remindersPerm = getPerm('reminders');
          final todosPerm = getPerm('todos');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacing24),
            child: Column(
              children: [
                if (notesPerm != 'none') ...[
                  _buildModuleCard(
                    context,
                    title: AppLocalizations.of(context)!.notes,
                    description: '',
                    icon: Icons.note_alt_rounded,
                    color: AppColors.primary,
                    onTap: () => Navigator.pushNamed(context, '/notes'),
                  ),
                  const SizedBox(height: 16),
                ],
                if (tasksPerm != 'none') ...[
                  _buildModuleCard(
                    context,
                    title: AppLocalizations.of(context)!.tasks,
                    description: '',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    onTap: () => Navigator.pushNamed(context, '/tasks'),
                  ),
                  const SizedBox(height: 16),
                ],
                if (remindersPerm != 'none') ...[
                  _buildModuleCard(
                    context,
                    title: AppLocalizations.of(context)!.reminders,
                    description: '',
                    icon: Icons.notifications_rounded,
                    color: AppColors.warning,
                    onTap: () => Navigator.pushNamed(context, '/reminders'),
                  ),
                  const SizedBox(height: 16),
                ],
                if (todosPerm != 'none') ...[
                  _buildModuleCard(
                    context,
                    title: AppLocalizations.of(context)!.todos,
                    description: '',
                    icon: Icons.checklist_rtl_rounded,
                    color: const Color(0xFF14B8A6), // Teal
                    onTap: () => Navigator.pushNamed(context, '/todos'),
                  ),
                  const SizedBox(height: 16),
                ],
                _buildModuleCard(
                  context,
                  title: AppLocalizations.of(context)!.archive,
                  description: '',
                  icon: Icons.archive_rounded,
                  color: context.textSecondary,
                  onTap: () => Navigator.pushNamed(context, '/archive'),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        decoration: BoxDecoration(
          color: context.bgSurface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          border: Border.all(color: context.dividerColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(color: context.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.bodyMedium.copyWith(color: context.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.textTertiary),
          ],
        ),
      ),
    );
  }
}
