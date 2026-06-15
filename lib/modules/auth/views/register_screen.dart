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
/// Kayıt ekranı.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.passwordsDoNotMatch)),
      );
      return;
    }
    await ref.read(authControllerProvider.notifier).register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
    // Yönlendirme otomatik.
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacing24),
            child: Form(
              key: _formKey,
              child: Container(
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.createAccount, style: AppTypography.titleLarge),
                    const SizedBox(height: AppConstants.spacing8),
                    Text(
                      AppLocalizations.of(context)!.welcomeToNotiva,
                      style: AppTypography.bodyMedium.copyWith(
                        color: context.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing24),
                    NotivaTextField(
                      controller: _nameController,
                      label: AppLocalizations.of(context)!.fullNameLabel,
                      hint: AppLocalizations.of(context)!.fullNameHint,
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                      validator: (v) => v == null || v.isEmpty ? AppLocalizations.of(context)!.nameRequired : null,
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    NotivaTextField(
                      controller: _emailController,
                      label: AppLocalizations.of(context)!.emailLabel,
                      hint: AppLocalizations.of(context)!.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      validator: (v) => v == null || v.isEmpty ? AppLocalizations.of(context)!.emailRequired : null,
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    NotivaTextField(
                      controller: _passwordController,
                      label: AppLocalizations.of(context)!.passwordLabel,
                      hint: AppLocalizations.of(context)!.passwordLengthHint,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      validator: (v) {
                        if (v == null || v.isEmpty) return AppLocalizations.of(context)!.passwordRequired;
                        if (v.length < 6) return AppLocalizations.of(context)!.passwordLength;
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    NotivaTextField(
                      controller: _confirmController,
                      label: AppLocalizations.of(context)!.confirmPasswordLabel,
                      hint: AppLocalizations.of(context)!.confirmPasswordHint,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      validator: (v) =>
                          v == null || v.isEmpty ? AppLocalizations.of(context)!.confirmPasswordRequired : null,
                    ),
                    if (authState.errorMessage != null) ...[
                      const SizedBox(height: AppConstants.spacing12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          authState.errorMessage!,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppConstants.spacing24),
                    NotivaPrimaryButton(
                      label: AppLocalizations.of(context)!.registerLabel,
                      onPressed: _handleRegister,
                      isLoading: authState.isLoading,
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.alreadyHaveAccount,
                          style: AppTypography.bodyMedium
                              .copyWith(color: context.textTertiary),
                        ),
                        NotivaTextButton(
                          label: AppLocalizations.of(context)!.loginTitle,
                          onPressed: () => Navigator.pop(context),
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
    );
  }
}
