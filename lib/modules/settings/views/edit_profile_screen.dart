import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_button.dart';
import '../../../shared/widgets/notiva_text_field.dart';
import '../../auth/controllers/auth_controller.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../shared/services/storage_service.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil fotoğrafı 5 MB\'dan küçük olmalıdır.')));
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
      
      if (_imageFile != null) {
        avatarUrl = await storageService.uploadFile(
          file: _imageFile!,
          path: 'avatars/${user?.id ?? 'temp'}',
        ).timeout(const Duration(seconds: 15), onTimeout: () {
          throw Exception('Fotoğraf yükleme zaman aşımına uğradı.');
        });
      }
      
      await ref.read(authControllerProvider.notifier).updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        avatar: avatarUrl ?? user?.avatar,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Güncelleme zaman aşımına uğradı.');
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil başarıyla güncellendi!')),
        );
        Navigator.pop(context);
      }
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
        title: const Text('Profili Düzenle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                label: 'İsim ve Soyisim',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (val) => val == null || val.isEmpty ? 'İsim gerekli' : null,
              ),
              const SizedBox(height: 16),
              NotivaTextField(
                controller: _phoneController,
                label: 'Telefon Numarası',
                prefixIcon: const Icon(Icons.phone_outlined),
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? 'Telefon gerekli' : null,
              ),
              const SizedBox(height: 32),
              
              NotivaPrimaryButton(
                label: 'Değişiklikleri Kaydet',
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
