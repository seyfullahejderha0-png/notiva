import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_button.dart';
import '../../../shared/widgets/notiva_text_field.dart';
import '../controllers/workspace_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

/// Yeni ekip kurma ekranı.
class CreateWorkspaceScreen extends ConsumerStatefulWidget {
  const CreateWorkspaceScreen({super.key});

  @override
  ConsumerState<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends ConsumerState<CreateWorkspaceScreen> {
  final _nameController = TextEditingController();
  String _selectedIcon = 'folder';
  int _selectedColor = 0xFF2563EB;
  bool _isLoading = false;

  final _icons = ['person', 'work', 'folder', 'home', 'star', 'group'];
  final _iconWidgets = {
    'person': Icons.person_rounded,
    'work': Icons.work_rounded,
    'folder': Icons.folder_rounded,
    'home': Icons.home_rounded,
    'star': Icons.star_rounded,
    'group': Icons.group_rounded,
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(title: const Text('Yeni Ekip Kur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Önizleme
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(_selectedColor).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  _iconWidgets[_selectedIcon] ?? Icons.workspaces_rounded,
                  color: Color(_selectedColor),
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacing24),
            NotivaTextField(
              controller: _nameController,
              label: 'Ekip Adı',
              hint: 'örn: Proje Grubu, Aile',
              prefixIcon: const Icon(Icons.edit_outlined, size: 20),
            ),
            const SizedBox(height: AppConstants.spacing24),

            // İkon seçimi
            Text('İkon Seçin', style: AppTypography.titleSmall),
            const SizedBox(height: AppConstants.spacing12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _icons.map((iconName) {
                final isSelected = _selectedIcon == iconName;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = iconName),
                  child: AnimatedContainer(
                    duration: AppConstants.animFast,
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color(_selectedColor).withOpacity(0.15)
                          : context.bgSurfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: Color(_selectedColor), width: 2)
                          : null,
                    ),
                    child: Icon(
                      _iconWidgets[iconName],
                      color: isSelected ? Color(_selectedColor) : context.textTertiary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.spacing24),

            // Renk seçimi
            Text('Renk Seçin', style: AppTypography.titleSmall),
            const SizedBox(height: AppConstants.spacing12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppColors.workspaceColors.map((color) {
                final isSelected = _selectedColor == color.value;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color.value),
                  child: AnimatedContainer(
                    duration: AppConstants.animFast,
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: context.textPrimary, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.spacing32),
            NotivaPrimaryButton(
              label: 'Ekip Kur',
              icon: Icons.add_rounded,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : () async {
                if (_nameController.text.trim().isEmpty) return;
                
                setState(() => _isLoading = true);
                
                // Ekibi hemen oluştur (Firestore bekleme olmadan)
                final ws = await ref.read(workspaceControllerProvider.notifier).createTeam(
                      _nameController.text.trim(),
                      _selectedColor,
                    );
                
                if (!mounted) return;
                setState(() => _isLoading = false);
                
                // Hemen ekranı kapat ve yönetim ekranına geç
                Navigator.pop(context);
                if (ws != null) {
                  Navigator.pushNamed(context, '/team-manage', arguments: ws);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
