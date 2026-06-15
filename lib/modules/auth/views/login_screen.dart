import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_button.dart';
import '../../../shared/widgets/notiva_text_field.dart';
import '../controllers/auth_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

import 'package:nexus_app/l10n/app_localizations.dart';
/// Giriş ekranı.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
    // Yönlendirme main.dart tarafından authState dinlenerek otomatik yapılır.
  }

  Future<void> _handleGoogleLogin() async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
    // Yönlendirme main.dart tarafından otomatik yapılır.
  }

  Future<void> _handleAppleLogin() async {
    await ref.read(authControllerProvider.notifier).signInWithApple();
    // Yönlendirme main.dart tarafından otomatik yapılır.
  }


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: context.bgBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacing24),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo & Başlık
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      Text(
                        'Notiva',
                        style: AppTypography.headlineLarge.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacing8),
                      Text(
                        AppLocalizations.of(context)!.manageProductivity,
                        style: AppTypography.bodyMedium.copyWith(
                          color: context.textTertiary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacing48),

                      // Form kartı
                      Container(
                        padding: EdgeInsets.all(AppConstants.spacing24),
                        decoration: BoxDecoration(
                          color: context.bgSurface,
                          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                          border: Border.all(color: context.dividerColor, width: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.loginTitle,
                              style: AppTypography.titleLarge,
                            ),
                            const SizedBox(height: AppConstants.spacing24),
                            NotivaTextField(
                              controller: _emailController,
                              label: AppLocalizations.of(context)!.emailLabel,
                              hint: AppLocalizations.of(context)!.emailHint,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email_outlined, size: 20),
                              validator: (v) =>
                                  v == null || v.isEmpty ? AppLocalizations.of(context)!.emailRequired : null,
                            ),
                            const SizedBox(height: AppConstants.spacing16),
                            NotivaTextField(
                              controller: _passwordController,
                              label: AppLocalizations.of(context)!.passwordLabel,
                              hint: '••••••••',
                              obscureText: true,
                              prefixIcon: const Icon(Icons.lock_outline, size: 20),
                              validator: (v) =>
                                  v == null || v.isEmpty ? AppLocalizations.of(context)!.passwordRequired : null,
                            ),
                            const SizedBox(height: AppConstants.spacing8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: NotivaTextButton(
                                label: AppLocalizations.of(context)!.forgotPassword,
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/forgot-password'),
                              ),
                            ),
                            if (authState.errorMessage != null) ...[
                              const SizedBox(height: AppConstants.spacing8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.errorLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: AppColors.error, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authState.errorMessage!,
                                        style: AppTypography.bodySmall
                                            .copyWith(color: AppColors.error),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: AppConstants.spacing24),
                            NotivaPrimaryButton(
                               label: AppLocalizations.of(context)!.loginTitle,
                              onPressed: _handleLogin,
                              isLoading: authState.isLoading,
                            ),
                            const SizedBox(height: AppConstants.spacing16),
                            Row(
                              children: [
                                Expanded(child: Divider(color: context.dividerColor)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(AppLocalizations.of(context)!.orLabel, style: AppTypography.labelSmall.copyWith(color: context.textTertiary)),
                                ),
                                Expanded(child: Divider(color: context.dividerColor)),
                              ],
                            ),
                            const SizedBox(height: AppConstants.spacing16),
                            OutlinedButton.icon(
                              onPressed: authState.isLoading ? null : _handleGoogleLogin,
                              icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
                               label: Text(AppLocalizations.of(context)!.loginWithGoogle),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacing24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.noAccount,
                            style: AppTypography.bodyMedium.copyWith(
                              color: context.textTertiary,
                            ),
                          ),
                          NotivaTextButton(
                             label: AppLocalizations.of(context)!.createAccount,
                            onPressed: () => Navigator.pushNamed(context, '/register'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
