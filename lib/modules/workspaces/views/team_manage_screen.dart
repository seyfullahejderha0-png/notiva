import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/controllers/auth_controller.dart';
import '../models/workspace_model.dart';
import '../controllers/workspace_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:nexus_app/l10n/app_localizations.dart';

class TeamManageScreen extends ConsumerStatefulWidget {
  const TeamManageScreen({super.key});

  @override
  ConsumerState<TeamManageScreen> createState() => _TeamManageScreenState();
}

class _TeamManageScreenState extends ConsumerState<TeamManageScreen> {
  final Set<String> _deleteModeMembers = {};

  @override
  Widget build(BuildContext context) {
    try {
      final l10n = AppLocalizations.of(context)!;
      final argsWs = ModalRoute.of(context)!.settings.arguments as WorkspaceModel;
      
      // Get latest workspace
      final workspaces = ref.watch(workspaceControllerProvider).workspaces;
      final ws = workspaces.firstWhere((w) => w.id == argsWs.id, orElse: () => argsWs);

      final currentUser = ref.watch(authControllerProvider).user;
      final isAdmin = ws.ownerId == currentUser?.id;

      return Scaffold(
        backgroundColor: context.bgBackground,
        appBar: AppBar(title: Text(l10n.teamManagement)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Section: Icon, Name and Invite Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.bgSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Color(ws.color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        ref.read(workspaceControllerProvider.notifier).getWorkspaceIcon(ws.icon),
                        color: Color(ws.color),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ws.name,
                            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${l10n.inviteCodeLabel}:',
                                style: AppTypography.bodySmall.copyWith(color: context.textSecondary),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ws.inviteCode ?? '-',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Copy & Share
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (ws.inviteCode != null) {
                              Clipboard.setData(ClipboardData(text: ws.inviteCode!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.inviteCodeCopied)),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 22),
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          onPressed: () {
                            if (ws.inviteCode != null) {
                              Share.share('Notiva ${ws.inviteCode}');
                            }
                          },
                          icon: Icon(Icons.share_rounded, color: context.textSecondary, size: 22),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Members Title
              Text(l10n.teamMembersCount(ws.members.length), style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              
              // Members List
              Container(
                decoration: BoxDecoration(
                  color: context.bgSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.dividerColor),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ws.members.length,
                  separatorBuilder: (context, index) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final memberId = ws.members[index];
                    final isMe = memberId == currentUser?.id;
                    final isMemberAdmin = memberId == ws.ownerId;
                    final permissions = ws.memberPermissions[memberId] ?? {};
                    
                    return Consumer(
                      builder: (context, ref, child) {
                        final userAsync = ref.watch(userDetailsProvider(memberId));
                        
                        return InkWell(
                          onTap: (isAdmin && !isMemberAdmin) ? () {
                            _showPermissionsBottomSheet(context, ref, ws, memberId, permissions);
                          } : null,
                          onLongPress: (isAdmin && !isMemberAdmin)
                              ? () {
                                  setState(() {
                                    if (_deleteModeMembers.contains(memberId)) {
                                      _deleteModeMembers.remove(memberId);
                                    } else {
                                      _deleteModeMembers.add(memberId);
                                    }
                                  });
                                  HapticFeedback.heavyImpact();
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                if (_deleteModeMembers.contains(memberId)) ...[
                                  GestureDetector(
                                    onTap: () {
                                      _showRemoveDialog(context, ref, ws.id, memberId, l10n);
                                      setState(() => _deleteModeMembers.remove(memberId));
                                    },
                                    child: const Icon(Icons.remove_circle, color: AppColors.error, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.primary.withOpacity(0.1),
                                  child: Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userAsync.when(
                                          data: (data) => data?['name'] ?? l10n.unknownUser,
                                          loading: () => l10n.loading,
                                          error: (_, _) => l10n.errorMsg,
                                        ),
                                        style: AppTypography.bodyLarge.copyWith(
                                          fontWeight: isMe ? FontWeight.w700 : FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (isMemberAdmin)
                                        Text(
                                          l10n.adminRole,
                                          style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                                        )
                                      else if (isAdmin)
                                        Text(
                                          l10n.managePermissions,
                                          style: AppTypography.labelSmall.copyWith(color: context.textSecondary),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isAdmin && !isMemberAdmin)
                                  Icon(Icons.chevron_right_rounded, color: context.textTertiary),
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Leave / Delete Button
              OutlinedButton.icon(
                onPressed: () {
                  _showLeaveDialog(context, ref, ws, isAdmin, l10n);
                },
                icon: Icon(
                  isAdmin ? Icons.delete_forever_rounded : Icons.exit_to_app_rounded,
                  color: AppColors.error,
                ),
                label: Text(
                  isAdmin ? l10n.deleteAndDisbandTeam : l10n.leaveTeam,
                  style: const TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e, stackTrace) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hata!')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text('Ekran yüklenirken hata oluştu: $e\n\n$stackTrace'),
        ),
      );
    }
  }

  void _showPermissionsBottomSheet(BuildContext context, WidgetRef ref, WorkspaceModel ws, String memberId, Map<String, String> currentPermissions) {
    final l10n = AppLocalizations.of(context)!;
    
    // Default write if empty
    final Map<String, String> localPerms = {
      'notes': currentPermissions['notes'] ?? 'write',
      'tasks': currentPermissions['tasks'] ?? 'write',
      'todos': currentPermissions['todos'] ?? 'write',
      'reminders': currentPermissions['reminders'] ?? 'write',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.bgSurface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.permissions, style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    
                    _buildPermissionRow(
                      context, 
                      title: l10n.notes, 
                      icon: Icons.note_alt_rounded,
                      value: localPerms['notes']!,
                      onChanged: (val) => setModalState(() => localPerms['notes'] = val),
                      l10n: l10n,
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionRow(
                      context, 
                      title: l10n.tasks, 
                      icon: Icons.check_circle_rounded,
                      value: localPerms['tasks']!,
                      onChanged: (val) => setModalState(() => localPerms['tasks'] = val),
                      l10n: l10n,
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionRow(
                      context, 
                      title: l10n.todos, 
                      icon: Icons.checklist_rtl_rounded,
                      value: localPerms['todos']!,
                      onChanged: (val) => setModalState(() => localPerms['todos'] = val),
                      l10n: l10n,
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionRow(
                      context, 
                      title: l10n.reminders, 
                      icon: Icons.notifications_rounded,
                      value: localPerms['reminders']!,
                      onChanged: (val) => setModalState(() => localPerms['reminders'] = val),
                      l10n: l10n,
                    ),
                    
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () {
                        ref.read(workspaceControllerProvider.notifier).updateMemberPermissions(ws.id, memberId, localPerms);
                        Navigator.pop(context);
                      },
                      child: Text(l10n.savePermissions),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  Widget _buildPermissionRow(BuildContext context, {
    required String title, 
    required IconData icon, 
    required String value, 
    required Function(String) onChanged,
    required AppLocalizations l10n,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: context.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: AppTypography.titleMedium),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: [
                DropdownMenuItem(value: 'none', child: Text(l10n.nonePermission)),
                DropdownMenuItem(value: 'read', child: Text(l10n.readPermission)),
                DropdownMenuItem(value: 'write', child: Text(l10n.writePermission)),
              ],
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, WidgetRef ref, String teamId, String memberId, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeMemberTitle),
        content: Text(l10n.removeMemberDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              ref.read(workspaceControllerProvider.notifier).removeMember(teamId, memberId);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
  }

  void _showLeaveDialog(BuildContext context, WidgetRef ref, WorkspaceModel ws, bool isAdmin, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAdmin ? l10n.deleteTeamTitle : l10n.leaveTeamTitle),
        content: Text(isAdmin ? l10n.deleteTeamDesc : l10n.leaveTeamDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              ref.read(workspaceControllerProvider.notifier).leaveOrDeleteTeam(ws.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(isAdmin ? l10n.deleteAction : l10n.leaveTeam),
          ),
        ],
      ),
    );
  }
}
