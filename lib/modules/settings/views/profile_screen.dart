import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../notes/controllers/notes_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../../tasks/models/task_model.dart';
import '../../../core/theme/theme_controller.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import '../../../core/theme/locale_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:app_settings/app_settings.dart';
import 'legal_documents_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final notesState = ref.watch(notesControllerProvider);
    final tasksState = ref.watch(tasksControllerProvider);

    final totalNotes = notesState.state.notes.length;
    final totalTasks = tasksState.tasks.length;
    final completedTasks = tasksState.tasks.where((t) => t.status == TaskStatus.completed).length;

    final user = authState.user;

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Column(
          children: [
            // Profil Özeti
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: context.bgSurfaceVariant,
                    backgroundImage: user?.avatar != null ? NetworkImage(user!.avatar!) : null,
                    child: user?.avatar == null 
                        ? Text(
                            user?.name.substring(0, 1).toUpperCase() ?? 'U',
                            style: AppTypography.headlineLarge.copyWith(color: AppColors.primary),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Kullanıcı',
                    style: AppTypography.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  if (user?.phone != null && user!.phone!.isNotEmpty) ...[
                    Text(
                      user.phone!,
                      style: AppTypography.bodyMedium.copyWith(color: context.textSecondary),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    user?.email ?? 'E-posta belirtilmemiş',
                    style: AppTypography.bodyMedium.copyWith(color: context.textTertiary),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(l10n.editProfile),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Canlı İstatistikler
            Row(
              children: [
                Expanded(child: _ProfileStatCard(title: l10n.totalNotes, count: totalNotes.toString(), color: AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: _ProfileStatCard(title: l10n.totalTasks, count: totalTasks.toString(), color: AppColors.warning)),
                const SizedBox(width: 12),
                Expanded(child: _ProfileStatCard(title: l10n.completedSingle, count: completedTasks.toString(), color: AppColors.success)),
              ],
            ),
            const SizedBox(height: 32),

            // (Modüller taşındı)

            // Uygulama Ayarları
            _SectionTitle(title: AppLocalizations.of(context)!.appSettings),
            const SizedBox(height: 8),
            NotivaCard(
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.workspaces_rounded,
                    color: AppColors.secondary,
                    title: AppLocalizations.of(context)!.workspace,
                    onTap: () => Navigator.pushNamed(context, '/shared-workspace'),
                  ),
                  const Divider(height: 0),
                  _MenuItem(
                    icon: Icons.workspace_premium_rounded,
                    color: Colors.amber,
                    title: AppLocalizations.of(context)!.subscription,
                    onTap: () => Navigator.pushNamed(context, '/subscription'),
                  ),
                  const Divider(height: 0),
                  Consumer(
                    builder: (context, ref, child) {
                      final themeState = ref.watch(themeControllerProvider);
                      final themeMode = themeState.mode;
                      String themeText = l10n.themeSystem;
                      if (themeMode == ThemeMode.light) themeText = l10n.themeLight;
                      if (themeMode == ThemeMode.dark) themeText = l10n.themeDark;

                      return _MenuItem(
                        icon: Icons.dark_mode_outlined,
                        color: context.textSecondary,
                        title: '${AppLocalizations.of(context)!.appearance} ($themeText)',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(l10n.appearanceSelection),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile<ThemeMode>(
                                    title: Text('${l10n.themeSystem} (Cihaz Ayarı)'),
                                    value: ThemeMode.system,
                                    groupValue: themeMode,
                                    onChanged: (val) {
                                      if (val != null) ref.read(themeControllerProvider.notifier).setThemeMode(val);
                                      Navigator.pop(ctx);
                                    },
                                  ),
                                  RadioListTile<ThemeMode>(
                                    title: Text('${l10n.themeLight} Mod'),
                                    value: ThemeMode.light,
                                    groupValue: themeMode,
                                    onChanged: (val) {
                                      if (val != null) ref.read(themeControllerProvider.notifier).setThemeMode(val);
                                      Navigator.pop(ctx);
                                    },
                                  ),
                                  RadioListTile<ThemeMode>(
                                    title: Text('${l10n.themeDark} Mod'),
                                    value: ThemeMode.dark,
                                    groupValue: themeMode,
                                    onChanged: (val) {
                                      if (val != null) ref.read(themeControllerProvider.notifier).setThemeMode(val);
                                      Navigator.pop(ctx);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const Divider(height: 0),
                  Consumer(
                    builder: (context, ref, child) {
                      final themeState = ref.watch(themeControllerProvider);
                      return _MenuItem(
                        icon: Icons.font_download_outlined,
                        color: context.textSecondary,
                        title: '${AppLocalizations.of(context)!.font} (${themeState.fontFamily})',
                        onTap: () {
                          final fonts = [
                            'Inter', 'Poppins', 'Montserrat', 'Roboto', 'Open Sans',
                            'Lato', 'Nunito', 'Raleway', 'Playfair Display', 'JetBrains Mono',
                          ];
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(l10n.fontSelection),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: fonts.length,
                                  itemBuilder: (context, index) {
                                    final font = fonts[index];
                                    return RadioListTile<String>(
                                      title: Text(font, style: GoogleFonts.getFont(font, textStyle: AppTypography.bodyLarge)),
                                      value: font,
                                      groupValue: themeState.fontFamily,
                                      onChanged: (val) {
                                        if (val != null) ref.read(themeControllerProvider.notifier).setFontFamily(val);
                                        Navigator.pop(ctx);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const Divider(height: 0),
                  _MenuItem(
                    icon: Icons.notifications_active_outlined,
                    color: context.textSecondary,
                    title: AppLocalizations.of(context)!.notificationSettings,
                    onTap: () {
                      AppSettings.openAppSettings(type: AppSettingsType.notification);
                    },
                  ),
                  const Divider(height: 0),
                  Consumer(
                    builder: (context, ref, child) {
                      final currentLocale = ref.watch(localeControllerProvider);
                      final langNames = {
                        'tr': 'Türkçe', 'en': 'English', 'de': 'Deutsch', 
                        'fr': 'Français', 'it': 'Italiano', 'es': 'Español', 'pt': 'Português'
                      };
                      return _MenuItem(
                        icon: Icons.language_outlined,
                        color: context.textSecondary,
                        title: '${AppLocalizations.of(context)!.language} (${langNames[currentLocale.languageCode]})',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!.language),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: langNames.entries.map((e) {
                                  return RadioListTile<String>(
                                    title: Text(e.value),
                                    value: e.key,
                                    groupValue: currentLocale.languageCode,
                                    onChanged: (val) {
                                      if (val != null) {
                                        ref.read(localeControllerProvider.notifier).setLocale(Locale(val));
                                        Navigator.pop(ctx);
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            // Destek ve Yasal
            _SectionTitle(title: AppLocalizations.of(context)!.supportAndLegal),
            const SizedBox(height: 8),
            NotivaCard(
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.mail_outline_rounded,
                    color: Colors.blue,
                    title: AppLocalizations.of(context)!.contactUs,
                    onTap: () async {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: 'seyfullahejderha0@gmail.com',
                        query: 'subject=Notiva Destek Talebi',
                      );
                      try {
                        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('E-posta uygulaması açılamadı. seyfullahejderha0@gmail.com adresine yazabilirsiniz.'),
                              duration: Duration(seconds: 4),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(height: 0),
                  _MenuItem(
                    icon: Icons.star_outline_rounded,
                    color: Colors.orange,
                    title: AppLocalizations.of(context)!.rateApp,
                    onTap: () async {
                      final InAppReview inAppReview = InAppReview.instance;
                      if (await inAppReview.isAvailable()) {
                        inAppReview.requestReview();
                      }
                    },
                  ),
                  const Divider(height: 0),
                  _MenuItem(
                    icon: Icons.policy_outlined,
                    color: context.textSecondary,
                    title: AppLocalizations.of(context)!.privacyPolicy,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LegalDocumentsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Hesap Yönetimi
            _SectionTitle(title: AppLocalizations.of(context)!.accountManagement),
            const SizedBox(height: 8),
            NotivaCard(
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    color: AppColors.error,
                    title: AppLocalizations.of(context)!.logout,
                    isDestructive: true,
                    onTap: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      }
                    },
                  ),
                  const Divider(height: 0),
                  _MenuItem(
                    icon: Icons.delete_forever_rounded,
                    color: AppColors.error,
                    title: AppLocalizations.of(context)!.deleteAccount,
                    isDestructive: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l10n.deleteAccountTitle),
                          content: Text(
                            l10n.deleteAccountDesc,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text(l10n.cancel),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(ctx);
                                final success = await ref.read(authControllerProvider.notifier).deleteAccount();
                                if (success && context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                                }
                              },
                              style: TextButton.styleFrom(foregroundColor: AppColors.error),
                              child: Text(l10n.yesDeleteAccount),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: AppTypography.titleSmall.copyWith(color: context.textTertiary),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          color: isDestructive ? AppColors.error : context.textPrimary,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: context.textTertiary),
      onTap: onTap,
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _ProfileStatCard({required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: AppTypography.headlineMedium.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(color: context.textSecondary),
          ),
        ],
      ),
    );
  }
}
