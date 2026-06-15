import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_button.dart';
import '../../../shared/widgets/notiva_text_field.dart';
import '../models/contact_model.dart';
import '../controllers/contacts_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

/// Kişi detay/düzenleme ekranı.
class ContactDetailScreen extends ConsumerStatefulWidget {
  const ContactDetailScreen({super.key});

  @override
  ConsumerState<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends ConsumerState<ContactDetailScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _roleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: const Text('Kişi Detayı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.secondary,
                    child: Text('?', style: AppTypography.headlineLarge.copyWith(color: AppColors.primary)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.bgSurface, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            NotivaTextField(controller: _nameController, label: 'Ad Soyad', hint: 'Kişi adını girin', prefixIcon: const Icon(Icons.person_outline, size: 20)),
            const SizedBox(height: 16),
            NotivaTextField(controller: _phoneController, label: 'Telefon', hint: '0532 111 22 33', keyboardType: TextInputType.phone, prefixIcon: const Icon(Icons.phone_outlined, size: 20)),
            const SizedBox(height: 16),
            NotivaTextField(controller: _emailController, label: 'E-posta', hint: 'ornek@email.com', keyboardType: TextInputType.emailAddress, prefixIcon: const Icon(Icons.email_outlined, size: 20)),
            const SizedBox(height: 16),
            NotivaTextField(controller: _companyController, label: 'Şirket', hint: 'Şirket adı', prefixIcon: const Icon(Icons.business_outlined, size: 20)),
            const SizedBox(height: 16),
            NotivaTextField(controller: _roleController, label: 'Pozisyon', hint: 'Görev/unvan', prefixIcon: const Icon(Icons.work_outline, size: 20)),
            const SizedBox(height: 16),
            NotivaTextField(controller: _notesController, label: 'Notlar', hint: 'Bu kişi hakkında notlar...', maxLines: 4, prefixIcon: const Icon(Icons.note_alt_outlined, size: 20)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing24),
          child: NotivaPrimaryButton(
            label: 'Kaydet', 
            icon: Icons.save_rounded, 
            onPressed: _saveContact,
          ),
        ),
      ),
    );
  }

  void _saveContact() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen kişi adını girin.')));
      return;
    }

    final newContact = ContactModel(
      id: 'c${DateTime.now().millisecondsSinceEpoch}',
      workspaceId: 'ws_1',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      company: _companyController.text.trim(),
      role: _roleController.text.trim(),
      notes: _notesController.text.trim(),
    );

    ref.read(contactsControllerProvider.notifier).addContact(newContact);
    Navigator.pop(context);
  }
}
