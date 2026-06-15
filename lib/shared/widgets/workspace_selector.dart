import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../modules/workspaces/controllers/workspace_controller.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

class WorkspaceSelector extends ConsumerWidget {
  final String? selectedWorkspaceId;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const WorkspaceSelector({
    super.key,
    required this.selectedWorkspaceId,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceState = ref.watch(workspaceControllerProvider);
    final workspaces = workspaceState.workspaces;

    if (workspaces.isEmpty) return const SizedBox.shrink();

    // Seçili ID listede yoksa, aktif olanı veya ilkini göster
    final activeWorkspace = ref.read(activeWorkspaceProvider);
    String? validId = selectedWorkspaceId;
    if (validId == null || !workspaces.any((w) => w.id == validId)) {
      validId = activeWorkspace?.id ?? workspaces.first.id;
      // Hemen üst widget'a bildir (build sonrası)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (selectedWorkspaceId != validId) {
          onChanged(validId);
        }
      });
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: validId,
            isExpanded: false,
            isDense: true,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 20),
            dropdownColor: context.bgSurface,
            borderRadius: BorderRadius.circular(16),
            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
            items: workspaces.map((ws) {
            return DropdownMenuItem<String>(
              value: ws.id,
              child: Row(
                children: [
                    Icon(
                      ref.read(workspaceControllerProvider.notifier).getWorkspaceIcon(ws.icon),
                      size: 16,
                      color: Color(ws.color),
                    ),
                  const SizedBox(width: 8),
                  Text(ws.type == 'personal' ? AppLocalizations.of(context)!.personalWorkspace : ws.name),
                  if (ws.type == 'personal') ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.textSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(AppLocalizations.of(context)!.personalWorkspace, style: AppTypography.labelSmall.copyWith(color: context.textSecondary)),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          ),
        ),
      ),
    );
  }
}
