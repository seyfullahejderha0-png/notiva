import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/attachment_model.dart';
import '../../../shared/services/storage_service.dart';
import '../../../shared/widgets/workspace_selector.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../models/note_model.dart';
import '../controllers/notes_controller.dart';
import '../../../shared/widgets/comments_sheet.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

/// Zengin not editörü ekranı.
class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final FocusNode _contentFocus = FocusNode();
  bool _isPinned = false;
  bool _isFavorite = false;
  final List<String> _tags = ['proje', 'plan'];
  final List<AttachmentModel> _attachments = [];
  bool _isUploading = false;
  bool _isInit = false;
  NoteModel? _existingNote;
  String? _selectedWorkspaceId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is NoteModel) {
        _existingNote = args;
        _titleController.text = args.title;
        _contentController.text = args.content;
        _isPinned = args.pinned;
        _isFavorite = args.favorite;
        _tags.clear();
        _tags.addAll(args.tags);
        _attachments.clear();
        _attachments.addAll(args.attachments);
        _selectedWorkspaceId = args.workspaceId;
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authControllerProvider).user;
    final activeWorkspace = ref.watch(activeWorkspaceProvider);
    
    bool canEdit = _existingNote == null || _existingNote!.createdBy == currentUser?.id;
    if (!canEdit && currentUser != null && activeWorkspace != null && _existingNote?.workspaceId == activeWorkspace.id) {
        if (activeWorkspace.ownerId == currentUser.id) {
          canEdit = true;
        } else {
          final perms = activeWorkspace.memberPermissions[currentUser.id] ?? {};
          final role = perms['notes'] ?? 'write';
          if (role == 'write' || role == 'admin') {
            canEdit = true;
          }
        }
    }

    return Scaffold(
      backgroundColor: context.bgSurface,
      appBar: AppBar(
        backgroundColor: context.bgSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_existingNote != null && _selectedWorkspaceId != null)
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              onPressed: () {
                CommentsSheet.show(
                  context,
                  workspaceId: _selectedWorkspaceId!,
                  resourceType: 'note',
                  resourceId: _existingNote!.id,
                );
              },
            ),
          IconButton(
            icon: Icon(
              _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
              color: _isPinned ? AppColors.primary : context.textTertiary,
            ),
            onPressed: canEdit ? () => setState(() => _isPinned = !_isPinned) : null,
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _isFavorite ? AppColors.warning : context.textTertiary,
            ),
            onPressed: canEdit ? () => setState(() => _isFavorite = !_isFavorite) : null,
          ),
          if (canEdit)
            TextButton(
              onPressed: _saveNote,
              child: Text(AppLocalizations.of(context)!.save),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Çalışma Alanı Seçicisi
                    WorkspaceSelector(
                      selectedWorkspaceId: _selectedWorkspaceId,
                      enabled: canEdit,
                      onChanged: (val) {
                        setState(() => _selectedWorkspaceId = val);
                      },
                    ),
              // Başlık
              TextField(
                controller: _titleController,
                style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.titleHint,
                  hintStyle: AppTypography.headlineSmall.copyWith(color: context.textTertiary, fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  enabled: canEdit,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                readOnly: !canEdit,
              ),
              Divider(color: context.dividerColor.withOpacity(0.5), height: 16),
              // İçerik (maxLines: null sayesinde metin uzadıkça aşağı büyür)
              TextField(
                controller: _contentController,
                focusNode: _contentFocus,
                style: AppTypography.bodyLarge.copyWith(height: 1.6),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.startWritingNote,
                  hintStyle: AppTypography.bodyLarge.copyWith(color: context.textTertiary),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  enabled: canEdit,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                readOnly: !canEdit,
              ),
              
              const SizedBox(height: 32),
          if (_tags.isNotEmpty || _isUploading || _attachments.isNotEmpty || canEdit)
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.spacing24, vertical: 12),
              decoration: BoxDecoration(
                color: context.bgSurfaceVariant.withOpacity(0.3),
                border: Border(top: BorderSide(color: context.dividerColor, width: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Etiketler
                  if (_tags.isNotEmpty || canEdit)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._tags.map((tag) => Chip(
                              label: Text(tag),
                              deleteIcon: canEdit ? const Icon(Icons.close, size: 16) : null,
                              onDeleted: canEdit ? () => setState(() => _tags.remove(tag)) : null,
                              backgroundColor: AppColors.secondaryLight,
                              labelStyle: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
                            )),
                        if (canEdit)
                          ActionChip(
                            avatar: Icon(Icons.add, color: AppColors.success, size: 18),
                            label: Text(AppLocalizations.of(context)!.addTag, style: AppTypography.labelMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                            onPressed: () => _showAddTagDialog(),
                            backgroundColor: AppColors.successLight.withAlpha(128),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                      ],
                    ),
                  
                  if (_isUploading)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Center(child: LinearProgressIndicator()),
                    ),
                  
                  // Ekler listesi
                  if (_attachments.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Text(AppLocalizations.of(context)!.attachments, style: AppTypography.titleMedium),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _attachments.length,
                      itemBuilder: (context, index) {
                        final att = _attachments[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: context.bgSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.dividerColor, width: 0.5),
                          ),
                          child: ListTile(
                            onTap: () => _openAttachment(att),
                            leading: Icon(
                              att.type == AttachmentType.image ? Icons.image_rounded : Icons.picture_as_pdf_rounded,
                              color: AppColors.primary,
                            ),
                            title: Text(att.fileName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodyMedium),
                            trailing: canEdit
                                ? IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                                    onPressed: () {
                                      setState(() => _attachments.removeAt(index));
                                      storageService.deleteFile(att.url);
                                    },
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
                  ],
                ),
              ),
            ),
          ),
          // Alt araç çubuğu
          if (canEdit)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: context.bgSurface,
                boxShadow: [
                  BoxShadow(color: AppColors.shadow.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.sell_outlined, size: 22), onPressed: _showAddTagDialog, color: context.textSecondary, tooltip: AppLocalizations.of(context)!.addTag),
                    IconButton(icon: Icon(Icons.image_outlined, size: 22), onPressed: _pickImage, color: context.textSecondary, tooltip: AppLocalizations.of(context)!.addImage),
                    IconButton(icon: Icon(Icons.attach_file_rounded, size: 22), onPressed: _pickFile, color: context.textSecondary, tooltip: AppLocalizations.of(context)!.addFile),
                    IconButton(icon: Icon(Icons.mic_outlined, size: 22), onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.voiceInputComingSoon)));
                    }, color: context.textSecondary, tooltip: AppLocalizations.of(context)!.voiceRecord),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: _showTemplatesSheet,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.dashboard_customize_outlined, size: 16, color: AppColors.primary),
                              SizedBox(width: 6),
                              Text(AppLocalizations.of(context)!.templates, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openAttachment(AttachmentModel att) async {
    if (att.type == AttachmentType.image) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(att.url, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 32),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final uri = Uri.parse(att.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fileCannotOpen)));
        }
      }
    }
  }

  void _showAddTagDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addTag),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.tagName),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _tags.add(controller.text.trim()));
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }
    
    final noteId = _existingNote?.id ?? 'n${DateTime.now().millisecondsSinceEpoch}';
    
    // ParentId'leri güncelle
    final updatedAttachments = _attachments.map((a) => AttachmentModel(
      id: a.id,
      parentId: noteId,
      type: a.type,
      url: a.url,
      fileName: a.fileName,
    )).toList();

    final currentUser = ref.read(authControllerProvider).user;
    final activeWorkspace = ref.read(activeWorkspaceProvider);

    final note = NoteModel(
      id: noteId,
      workspaceId: _selectedWorkspaceId ?? activeWorkspace?.id ?? 'ws1',
      title: _titleController.text.trim().isEmpty ? AppLocalizations.of(context)!.untitledNote : _titleController.text.trim(),
      content: _contentController.text.trim(),
      tags: _tags,
      folderId: _existingNote?.folderId ?? 'f1',
      pinned: _isPinned,
      archived: _existingNote?.archived ?? false,
      favorite: _isFavorite,
      createdBy: _existingNote?.createdBy ?? currentUser?.id ?? 'user1',
      sharedWith: _existingNote?.sharedWith ?? [],
      attachments: updatedAttachments,
      createdAt: _existingNote?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    if (_existingNote != null) {
      if (_existingNote!.workspaceId != note.workspaceId) {
        ref.read(notesControllerProvider).deleteNote(_existingNote!.id, workspaceId: _existingNote!.workspaceId);
        ref.read(notesControllerProvider).createNote(note);
      } else {
        ref.read(notesControllerProvider).updateNote(note);
      }
    } else {
      ref.read(notesControllerProvider).createNote(note);
    }
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70); // Kaliteyi %70'e düşürerek boyutu küçültüyoruz
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) { // 5 MB Sınırı
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fotoğraf boyutu 5 MB\'dan küçük olmalıdır.')));
        }
        return;
      }
      _uploadFile(file, AttachmentType.image);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) { // 5 MB Sınırı
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF boyutu 5 MB\'dan küçük olmalıdır.')));
        }
        return;
      }
      _uploadFile(file, AttachmentType.pdf);
    }
  }

  Future<void> _uploadFile(File file, AttachmentType type) async {
    setState(() => _isUploading = true);
    final url = await storageService.uploadFile(file: file, path: 'notes');
    if (url != null) {
      final att = AttachmentModel(
        id: 'a${DateTime.now().millisecondsSinceEpoch}',
        parentId: '', // Kaydedilince dolacak
        type: type,
        url: url,
        fileName: file.path.split('/').last.split('\\').last,
      );
      setState(() => _attachments.add(att));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fileUploadFailed)));
    }
    setState(() => _isUploading = false);
  }

  void _showTemplatesSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.bgSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(AppLocalizations.of(context)!.chooseTemplate, style: AppTypography.titleMedium),
                ),
                ListTile(
                  leading: Icon(Icons.meeting_room_outlined, color: AppColors.primary),
                  title: Text(AppLocalizations.of(context)!.meetingNote),
                  onTap: () {
                    setState(() {
                      if (_titleController.text.isEmpty) _titleController.text = AppLocalizations.of(context)!.meetingNote;
                      _contentController.text = '📋 Toplantı Notu\n\nTarih: \nKatılımcılar: \nKararlar: \nAksiyonlar: \n\n${_contentController.text}';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
                  title: Text(AppLocalizations.of(context)!.shoppingList),
                  onTap: () {
                    setState(() {
                      if (_titleController.text.isEmpty) _titleController.text = AppLocalizations.of(context)!.shopping;
                      _contentController.text = '🛒 Alışveriş\n\n☐ Süt\n☐ Ekmek\n☐ \n\n${_contentController.text}';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.rocket_launch_outlined, color: AppColors.primary),
                  title: Text(AppLocalizations.of(context)!.projectPlan),
                  onTap: () {
                    setState(() {
                      if (_titleController.text.isEmpty) _titleController.text = AppLocalizations.of(context)!.projectPlan;
                      _contentController.text = '🚀 Proje Planı\n\nHedef: \nTeslim: \nGörevler: \n\n${_contentController.text}';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
