import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/workspace_controller.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../../shared/providers/navigation_provider.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:nexus_app/l10n/app_localizations.dart';

class SharedWorkspaceScreen extends ConsumerWidget {
  const SharedWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.workspace),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.teamWork,
              style: AppTypography.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.teamWorkDesc,
              style: AppTypography.bodyMedium.copyWith(color: context.textSecondary),
            ),
            const SizedBox(height: 32),
            NotivaCard(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/workspace-create');
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.dividerColor),
                      ),
                      child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.createNewTeam,
                      style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: context.textTertiary),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    onTap: () {
                      _showJoinTeamDialog(context, ref);
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.dividerColor),
                      ),
                      child: const Icon(Icons.login_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.joinWithInviteCode,
                      style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: context.textTertiary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.myTeams,
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final wsState = ref.watch(workspaceControllerProvider);
                final teams = wsState.workspaces.where((ws) => ws.type == 'team').toList();

                if (teams.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        AppLocalizations.of(context)!.notInAnyTeam,
                        style: AppTypography.bodyMedium.copyWith(color: context.textTertiary),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NotivaCard(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () {
                            ref.read(workspaceControllerProvider.notifier).switchWorkspace(team.id);
                            Navigator.popUntil(context, (route) => route.isFirst);
                            ref.read(mainTabProvider.notifier).state = 0; // Switch to Dashboard
                          },
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Color(team.color).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              ref.read(workspaceControllerProvider.notifier).getWorkspaceIcon(team.icon),
                              color: Color(team.color),
                              size: 24,
                            ),
                          ),
                          title: Text(
                            team.name,
                            style: AppTypography.titleSmall,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!.membersCount(team.members.length),
                            style: AppTypography.bodySmall.copyWith(color: context.textTertiary),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
                            onPressed: () {
                              Navigator.pushNamed(context, '/team-manage', arguments: team);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinTeamDialog(BuildContext context, WidgetRef ref) {
    final codeController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.joinTeam),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.joinTeamDesc),
                  const SizedBox(height: 16),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.inviteCode,
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                FilledButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final code = codeController.text.trim().toUpperCase();
                          if (code.isEmpty) return;

                          setState(() => isLoading = true);
                          final result = await ref.read(workspaceControllerProvider.notifier).joinTeam(code);
                          setState(() => isLoading = false);

                          if (context.mounted) {
                            Navigator.pop(context);
                            if (result == 'ok') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.of(context)!.teamJoinedSuccess)),
                              );
                            } else if (result == 'already_member') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.of(context)!.alreadyTeamMember)),
                              );
                            } else if (result.startsWith('HATA:')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result),
                                  duration: const Duration(seconds: 10),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.of(context)!.invalidInviteCode)),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(AppLocalizations.of(context)!.join),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
