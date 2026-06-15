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
import '../../../shared/widgets/notiva_button.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../../shared/models/attachment_model.dart';
import '../../../shared/services/storage_service.dart';
import '../../../shared/widgets/workspace_selector.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../models/task_model.dart';
import '../controllers/tasks_controller.dart';
import '../../../shared/widgets/comments_sheet.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

/// Görev detay/düzenleme ekranı.
class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _subtaskController = TextEditingController();
  TaskStatus _status = TaskStatus.pending;
  TaskPriority _priority = TaskPriority.medium;
  RepeatType _repeat = RepeatType.none;
  DateTime? _dueDate;
  bool _reminder = false;
  final List<SubTask> _subtasks = [];
  final List<AttachmentModel> _attachments = [];
  bool _isUploading = false;
  String? _assignedUserId;
  bool _isInit = false;
  TaskModel? _existingTask;
  String? _selectedWorkspaceId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is TaskModel) {
        _existingTask = args;
        _titleController.text = args.title;
        _descController.text = args.description;
        _status = args.status;
        _priority = args.priority;
        _repeat = args.repeat;
        _dueDate = args.dueDate;
        _reminder = args.reminder;
        _subtasks.clear();
        _subtasks.addAll(args.subtasks);
        _attachments.addAll(args.attachments);
        _assignedUserId = args.assignedTo;
        _selectedWorkspaceId = args.workspaceId;
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  bool _checkPermission() {
    final currentUser = ref.watch(authControllerProvider).user;
    final activeWorkspace = ref.watch(activeWorkspaceProvider);
    
    bool canEdit = _existingTask == null || _existingTask!.createdBy == currentUser?.id;
    if (!canEdit && currentUser != null && activeWorkspace != null && _existingTask?.workspaceId == activeWorkspace.id) {
      if (activeWorkspace.ownerId == currentUser.id) {
        canEdit = true;
      } else if (_existingTask?.assignedTo == currentUser.id) {
        canEdit = true; // Assignee can always edit checklist/status
      } else {
        final perms = activeWorkspace.memberPermissions[currentUser.id] ?? {};
        final role = perms['tasks'] ?? 'write';
        if (role == 'write' || role == 'admin') {
          canEdit = true;
        }
      }
    }
    return canEdit;
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = _checkPermission();
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.bgBackground,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.taskDetail),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.details),
              Tab(text: AppLocalizations.of(context)!.checklist),
              Tab(text: AppLocalizations.of(context)!.attachments),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: context.textSecondary,
          ),
          actions: [
            if (_existingTask != null && _selectedWorkspaceId != null)
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                onPressed: () {
                  CommentsSheet.show(
                    context,
                    workspaceId: _selectedWorkspaceId!,
                    resourceType: 'task',
                    resourceId: _existingTask!.id,
                  );
                },
              ),
            if (canEdit && _existingTask != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () {
                  ref.read(tasksControllerProvider.notifier).deleteTask(_existingTask!.id);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildDetailsTab(canEdit),
            _buildChecklistTab(canEdit),
            _buildAttachmentsTab(canEdit),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.spacing24),
            child: canEdit ? NotivaPrimaryButton(
              label: AppLocalizations.of(context)!.save, 
              icon: Icons.save_rounded, 
              onPressed: _saveTask,
            ) : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsTab(bool canEdit) {
    final activeWorkspace = ref.watch(activeWorkspaceProvider);
    final currentUser = ref.watch(authControllerProvider).user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkspaceSelector(
            selectedWorkspaceId: _selectedWorkspaceId,
            enabled: canEdit,
            onChanged: (val) {
              setState(() => _selectedWorkspaceId = val);
              _autoSaveIfNeeded();
            },
          ),
          const SizedBox(height: 16),
          
          NotivaCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  enabled: canEdit,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                  onChanged: (_) => _autoSaveIfNeeded(),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.taskTitle,
                    hintStyle: AppTypography.titleLarge.copyWith(color: context.textTertiary, fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Divider(color: context.dividerColor.withOpacity(0.5), height: 16),
                TextField(
                  controller: _descController,
                  enabled: canEdit,
                  maxLines: null,
                  minLines: 3,
                  style: AppTypography.bodyMedium,
                  onChanged: (_) => _autoSaveIfNeeded(),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.addDetailedDescription,
                    hintStyle: AppTypography.bodyMedium.copyWith(color: context.textTertiary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          NotivaCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.statusLabel, style: AppTypography.titleSmall),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildStatusOption(TaskStatus.pending, canEdit)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildStatusOption(TaskStatus.inProgress, canEdit)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildStatusOption(TaskStatus.completed, canEdit)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildStatusOption(TaskStatus.cancelled, canEdit)),
                      ],
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),
                Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 20, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.priorityLabel, style: AppTypography.titleSmall),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildPriorityOption(TaskPriority.low, canEdit)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPriorityOption(TaskPriority.medium, canEdit)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildPriorityOption(TaskPriority.high, canEdit)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPriorityOption(TaskPriority.critical, canEdit)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (activeWorkspace != null && activeWorkspace.type == 'team') ...[
            NotivaCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_add_alt_1_outlined, size: 20, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.assignUser, style: AppTypography.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _assignedUserId,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.bgSurfaceVariant.withOpacity(0.3),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabled: canEdit,
                    ),
                    hint: Text(AppLocalizations.of(context)!.selectPerson),
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: context.textSecondary),
                    items: [
                      DropdownMenuItem(value: null, child: Text(AppLocalizations.of(context)!.assignToNobody)),
                      ...activeWorkspace.members.map((memberId) => DropdownMenuItem(
                        value: memberId,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: const Icon(Icons.person, size: 14, color: AppColors.primary),
                            ),
                            SizedBox(width: 12),
                            Consumer(
                              builder: (context, ref, child) {
                                if (memberId == currentUser?.id) {
                                  return Text(AppLocalizations.of(context)!.me);
                                }
                                final userAsync = ref.watch(userDetailsProvider(memberId));
                                return userAsync.when(
                                  data: (data) {
                                    if (data == null) return Text('Kullanıcı: ${memberId.substring(0, 8)}...');
                                    return Text('${data['name'] ?? ''} ${data['surname'] ?? ''}'.trim());
                                  },
                                  loading: () => Text('Kullanıcı: ${memberId.substring(0, 8)}...'),
                                  error: (_, _) => Text('Kullanıcı: ${memberId.substring(0, 8)}...'),
                                );
                              },
                            ),
                          ],
                        ),
                      )),
                    ],
                    onChanged: canEdit ? (val) {
                      setState(() => _assignedUserId = val);
                      _autoSaveIfNeeded();
                    } : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          NotivaCard(
            onTap: canEdit ? () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dueDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _dueDate = picked);
                _autoSaveIfNeeded();
              }
            } : null,
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.primary),
                SizedBox(width: 12),
                Text(
                  _dueDate != null
                      ? '${_dueDate!.day}.${_dueDate!.month}.${_dueDate!.year}'
                      : AppLocalizations.of(context)!.selectEndDate,
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          NotivaCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_outlined, size: 20, color: AppColors.warning),
                    SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.reminder, style: AppTypography.bodyMedium),
                    const Spacer(),
                    Switch(value: _reminder, onChanged: canEdit ? (v) {
                      setState(() => _reminder = v);
                      _autoSaveIfNeeded();
                    } : null),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Icon(Icons.repeat_rounded, size: 20, color: context.textTertiary),
                    SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.repeat, style: AppTypography.bodyMedium),
                    const Spacer(),
                    DropdownButton<RepeatType>(
                      value: _repeat,
                      underline: const SizedBox(),
                      items: RepeatType.values
                          .map((r) => DropdownMenuItem(value: r, child: Text(r.displayLabel(context))))
                          .toList(),
                      onChanged: canEdit ? (v) {
                        setState(() => _repeat = v!);
                        _autoSaveIfNeeded();
                      } : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildChecklistTab(bool canEdit) {
    int completedCount = _subtasks.where((s) => s.isCompleted).length;
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.subtasks, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completedCount/${_subtasks.length} Tamamlandı',
                  style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: NotivaCard(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: _subtasks.length + (canEdit ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _subtasks.length && canEdit) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const SizedBox(width: 48), // Checkbox width
                          Expanded(
                            child: TextField(
                              controller: _subtaskController,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _addSubtask(),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.addNewSubtask,
                                hintStyle: AppTypography.bodyMedium.copyWith(color: context.textTertiary),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                            onPressed: _addSubtask,
                          ),
                        ],
                      ),
                    );
                  }

                  final st = _subtasks[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: st.isCompleted ? context.bgSurfaceVariant.withOpacity(0.5) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: st.isCompleted,
                          activeColor: AppColors.primary,
                          onChanged: canEdit ? (v) {
                            setState(() {
                              _subtasks[index] = st.copyWith(isCompleted: v);
                            });
                            _autoSaveIfNeeded();
                          } : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        Expanded(
                          child: Text(
                            st.title,
                            style: AppTypography.bodyMedium.copyWith(
                              decoration: st.isCompleted ? TextDecoration.lineThrough : null,
                              color: st.isCompleted ? context.textTertiary : context.textPrimary,
                            ),
                          ),
                        ),
                        if (canEdit)
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              setState(() => _subtasks.removeAt(index));
                              _autoSaveIfNeeded();
                            },
                            color: context.textTertiary,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addSubtask() {
    if (_subtaskController.text.trim().isNotEmpty) {
      setState(() {
        _subtasks.add(SubTask(title: _subtaskController.text.trim()));
        _subtaskController.clear();
      });
      _autoSaveIfNeeded();
    }
  }

  Widget _buildAttachmentsTab(bool canEdit) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppLocalizations.of(context)!.filesAndImages, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          if (canEdit)
            NotivaCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image_outlined),
                    label: Text(AppLocalizations.of(context)!.addImage),
                  ),
                  Container(width: 1, height: 24, color: context.dividerColor),
                  TextButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file_rounded),
                    label: const Text('PDF Ekle'),
                  ),
                ],
              ),
            ),
            
          const SizedBox(height: 24),
          if (_isUploading)
            const Center(child: CircularProgressIndicator()),
            
          if (_attachments.isEmpty && !_isUploading)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.file_present_rounded, size: 48, color: context.textTertiary.withOpacity(0.5)),
                    SizedBox(height: 12),
                    Text(AppLocalizations.of(context)!.noAttachmentsYet, style: AppTypography.bodyMedium.copyWith(color: context.textTertiary)),
                  ],
                ),
              ),
            ),
            
          if (_attachments.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _attachments.length,
              itemBuilder: (context, index) {
                final att = _attachments[index];
                return NotivaCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () => _openAttachment(att),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        att.type == AttachmentType.image ? Icons.image : Icons.picture_as_pdf,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(att.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: canEdit ? IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                      onPressed: () {
                        setState(() => _attachments.removeAt(index));
                        storageService.deleteFile(att.url);
                        _autoSaveIfNeeded();
                      },
                    ) : null,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.low: return AppColors.priorityLow;
      case TaskPriority.medium: return AppColors.priorityMedium;
      case TaskPriority.high: return AppColors.priorityHigh;
      case TaskPriority.critical: return AppColors.priorityCritical;
    }
  }

  Color _getStatusColor(TaskStatus s) {
    switch (s) {
      case TaskStatus.pending: return AppColors.statusPending;
      case TaskStatus.inProgress: return AppColors.statusInProgress;
      case TaskStatus.completed: return AppColors.statusCompleted;
      case TaskStatus.cancelled: return AppColors.statusCancelled;
    }
  }

  Widget _buildStatusOption(TaskStatus s, bool canEdit) {
    final isSelected = _status == s;
    final color = _getStatusColor(s);
    return GestureDetector(
      onTap: canEdit ? () {
        setState(() => _status = s);
        _autoSaveIfNeeded();
      } : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : context.bgSurfaceVariant.withOpacity(0.3),
          border: Border.all(color: isSelected ? color : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          s.displayLabel(context),
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? color : context.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityOption(TaskPriority p, bool canEdit) {
    final isSelected = _priority == p;
    final color = _getPriorityColor(p);
    return GestureDetector(
      onTap: canEdit ? () {
        setState(() => _priority = p);
        _autoSaveIfNeeded();
      } : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : context.bgSurfaceVariant.withOpacity(0.3),
          border: Border.all(color: isSelected ? color : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          p.displayLabel(context),
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? color : context.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  TaskModel _buildTaskModel() {
    final taskId = _existingTask?.id ?? 't${DateTime.now().millisecondsSinceEpoch}';
    final currentUser = ref.read(authControllerProvider).user;
    final activeWorkspace = ref.read(activeWorkspaceProvider);

    final task = TaskModel(
      id: taskId,
      workspaceId: _selectedWorkspaceId ?? activeWorkspace?.id ?? 'ws1',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      status: _status,
      priority: _priority,
      dueDate: _dueDate,
      assignedTo: _assignedUserId,
      reminder: _reminder,
      repeat: _repeat,
      subtasks: _subtasks,
      createdBy: _existingTask?.createdBy ?? currentUser?.id ?? 'user1',
      createdAt: _existingTask?.createdAt ?? DateTime.now(),
    );

    final updatedAttachments = _attachments.map((a) => AttachmentModel(
      id: a.id,
      parentId: task.id,
      type: a.type,
      url: a.url,
      fileName: a.fileName,
    )).toList();

    return task.copyWith(attachments: updatedAttachments);
  }

  void _autoSaveIfNeeded() {
    if (_existingTask != null && _titleController.text.trim().isNotEmpty) {
      final task = _buildTaskModel();
      ref.read(tasksControllerProvider.notifier).updateTask(task);
    }
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterTaskTitle)),
      );
      return;
    }

    final taskWithAttachments = _buildTaskModel();

    if (_existingTask != null) {
      if (_existingTask!.workspaceId != taskWithAttachments.workspaceId) {
        ref.read(tasksControllerProvider.notifier).deleteTask(_existingTask!.id, workspaceId: _existingTask!.workspaceId);
        ref.read(tasksControllerProvider.notifier).createTask(taskWithAttachments);
      } else {
        ref.read(tasksControllerProvider.notifier).updateTask(taskWithAttachments);
      }
    } else {
      ref.read(tasksControllerProvider.notifier).createTask(taskWithAttachments);
    }
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _uploadFile(File(pickedFile.path), AttachmentType.image);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      _uploadFile(File(result.files.single.path!), AttachmentType.pdf);
    }
  }

  Future<void> _uploadFile(File file, AttachmentType type) async {
    setState(() => _isUploading = true);
    final url = await storageService.uploadFile(file: file, path: 'tasks');
    if (url != null) {
      final att = AttachmentModel(
        id: 'a${DateTime.now().millisecondsSinceEpoch}',
        parentId: '', 
        type: type,
        url: url,
        fileName: file.path.split('/').last.split('\\').last,
      );
      setState(() => _attachments.add(att));
      _autoSaveIfNeeded();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fileUploadFailed)));
    }
    setState(() => _isUploading = false);
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
}
