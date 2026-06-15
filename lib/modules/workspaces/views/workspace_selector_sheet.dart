import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/workspace_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:nexus_app/l10n/app_localizations.dart';

/// Çalışma alanı seçici bottom sheet.
class WorkspaceSelectorSheet extends ConsumerWidget {
  const WorkspaceSelectorSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const WorkspaceSelectorSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsState = ref.watch(workspaceControllerProvider);
    final wsController = ref.read(workspaceControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: context.bgSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tutma çubuğu
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing20),
            child: Row(
              children: [
                Text(AppLocalizations.of(context)!.workspacesTitle, style: AppTypography.titleLarge),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: wsState.workspaces.length,
              itemBuilder: (context, index) {
                final ws = wsState.workspaces[index];
                final isActive = ws.id == wsState.activeWorkspace?.id;
                return ListTile(
                  onTap: () {
                    wsController.switchWorkspace(ws.id);
                    Navigator.pop(context);
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(ws.color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      wsController.getWorkspaceIcon(ws.icon),
                      color: Color(ws.color),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    ws.type == 'personal' ? AppLocalizations.of(context)!.personalWorkspace : ws.name,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.membersCount(ws.members.length),
                    style: AppTypography.bodySmall.copyWith(
                      color: context.textTertiary,
                    ),
                  ),
                  trailing: isActive
                      ? IconButton(
                          icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
                          onPressed: () {
                            Navigator.pop(context);
                            if (ws.type == 'team') {
                              Navigator.pushNamed(context, '/team-manage', arguments: ws);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.personalWorkspaceCannotBeManaged)));
                            }
                          },
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: AppConstants.spacing20),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
