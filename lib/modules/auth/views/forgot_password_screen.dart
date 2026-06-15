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

/// Şifremi unuttum ekranı.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_emailController.text.trim().isEmpty) return;
    final success = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(_emailController.text.trim());
    if (success && mounted) {
      setState(() => _sent = true);
    }
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
              child: _sent ? _buildSuccessContent() : _buildFormContent(authState),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_reset_rounded, size: 48, color: AppColors.primary),
        const SizedBox(height: AppConstants.spacing16),
        Text(AppLocalizations.of(context)!.resetPasswordTitle, style: AppTypography.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: AppConstants.spacing8),
        Text(
          AppLocalizations.of(context)!.resetPasswordDesc,
          style: AppTypography.bodyMedium.copyWith(color: context.textTertiary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.spacing24),
        NotivaTextField(
          controller: _emailController,
          label: AppLocalizations.of(context)!.emailLabel,
          hint: AppLocalizations.of(context)!.emailHint,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined, size: 20),
        ),
        const SizedBox(height: AppConstants.spacing24),
        NotivaPrimaryButton(
          label: AppLocalizations.of(context)!.sendLink,
          onPressed: _handleReset,
          isLoading: authState.isLoading,
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 32),
        ),
        const SizedBox(height: AppConstants.spacing16),
        Text(AppLocalizations.of(context)!.linkSent, style: AppTypography.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: AppConstants.spacing8),
        Text(
          AppLocalizations.of(context)!.linkSentDesc,
          style: AppTypography.bodyMedium.copyWith(color: context.textTertiary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.spacing24),
        NotivaSecondaryButton(
          label: AppLocalizations.of(context)!.backToLogin,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
