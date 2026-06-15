import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_button.dart';
import '../../../shared/widgets/notiva_text_field.dart';
import '../controllers/auth_controller.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../shared/services/storage_service.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:nexus_app/l10n/app_localizations.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Varsa mevcut ismi doldur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authControllerProvider).user;
      if (user != null) {
        _nameController.text = user.name;
        if (user.phone != null) {
          _phoneController.text = user.phone!;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) { // 5 MB Sınırı
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.photoSizeLimit)));
        }
        return;
      }
      setState(() => _imageFile = file);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      String? avatarUrl;
      final user = ref.read(authControllerProvider).user;
      
      // Eğer yeni resim seçildiyse yükle
      if (_imageFile != null) {
        avatarUrl = await storageService.uploadFile(
          file: _imageFile!,
          path: 'avatars/${user?.id ?? 'temp'}',
        ).timeout(const Duration(seconds: 15), onTimeout: () {
          throw Exception('Fotoğraf yükleme zaman aşımına uğradı. (İnternetinizi veya Storage kurallarını kontrol edin)');
        });
      }
      
      await ref.read(authControllerProvider.notifier).updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        avatar: avatarUrl ?? user?.avatar,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Kayıt işlemi zaman aşımına uğradı.');
      });
      
      // main.dart'taki state dinleyicisi sayfayı otomatik değiştirecek, 
      // o yüzden manuel pushReplacementNamed yapmamıza gerek yok.
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    
    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.completeProfile),
        automaticallyImplyLeading: false, // Geri dönülemesin (zorunlu ekran)
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.welcomeHeadline,
                style: AppTypography.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.completeProfileDesc,
                style: AppTypography.bodyMedium.copyWith(color: context.textTertiary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Avatar
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: context.bgSurfaceVariant,
                        backgroundImage: _imageFile != null 
                          ? FileImage(_imageFile!) as ImageProvider
                          : (user?.avatar != null ? NetworkImage(user!.avatar!) : null),
                        child: (_imageFile == null && user?.avatar == null)
                            ? const Icon(Icons.person, size: 50, color: AppColors.primary)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              NotivaTextField(
                controller: _nameController,
                label: AppLocalizations.of(context)!.fullNameLabel,
                prefixIcon: const Icon(Icons.person_outline),
                validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.nameRequired : null,
              ),
              const SizedBox(height: 16),
              NotivaTextField(
                controller: _phoneController,
                label: AppLocalizations.of(context)!.phoneLabel,
                prefixIcon: const Icon(Icons.phone_outlined),
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.phoneRequired : null,
              ),
              const SizedBox(height: 32),
              
              NotivaPrimaryButton(
                label: AppLocalizations.of(context)!.saveAndStart,
                isLoading: _isLoading,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
