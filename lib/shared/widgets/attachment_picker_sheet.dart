import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/attachment_model.dart';
import '../services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

class AttachmentPickerSheet extends StatefulWidget {
  final String parentId;
  final Function(AttachmentModel) onUploaded;

  const AttachmentPickerSheet({
    super.key,
    required this.parentId,
    required this.onUploaded,
  });

  static void show(BuildContext context, {
    required String parentId,
    required Function(AttachmentModel) onUploaded,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.bgBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AttachmentPickerSheet(
        parentId: parentId,
        onUploaded: onUploaded,
      ),
    );
  }

  @override
  State<AttachmentPickerSheet> createState() => _AttachmentPickerSheetState();
}

class _AttachmentPickerSheetState extends State<AttachmentPickerSheet> {
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      await _uploadFile(File(pickedFile.path), AttachmentType.image, pickedFile.name);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final extension = result.files.single.extension?.toLowerCase() ?? '';
      AttachmentType type = AttachmentType.file;
      if (extension == 'pdf') type = AttachmentType.pdf;
      
      await _uploadFile(file, type, result.files.single.name);
    }
  }

  Future<void> _uploadFile(File file, AttachmentType type, String fileName) async {
    setState(() => _isUploading = true);
    
    final path = 'attachments/${widget.parentId}';
    final url = await storageService.uploadFile(file: file, path: path);
    
    if (url != null) {
      final attachment = AttachmentModel(
        id: const Uuid().v4(),
        parentId: widget.parentId,
        type: type,
        url: url,
        fileName: fileName,
      );
      widget.onUploaded(attachment);
      if (mounted) Navigator.pop(context);
    } else {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dosya yüklenemedi. Lütfen tekrar deneyin.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: AppColors.primary),
            title: const Text('Kamera (Fotoğraf Çek)'),
            onTap: () => _pickImage(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppColors.primary),
            title: const Text('Galeriden Fotoğraf Seç'),
            onTap: () => _pickImage(ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.attach_file, color: AppColors.primary),
            title: const Text('Belge Seç (PDF, vb.)'),
            onTap: _pickFile,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
