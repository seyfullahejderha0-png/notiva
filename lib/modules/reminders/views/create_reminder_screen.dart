import 'package:flutter/material.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_button.dart';
import '../../../shared/widgets/notiva_text_field.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../../shared/widgets/workspace_selector.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../models/reminder_model.dart';
import '../controllers/reminders_controller.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

/// Hatırlatıcı oluşturma ekranı.
class CreateReminderScreen extends ConsumerStatefulWidget {
  const CreateReminderScreen({super.key});

  @override
  ConsumerState<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends ConsumerState<CreateReminderScreen> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _repeat = 'none';
  bool _notificationEnabled = true;
  String? _assignedUserId;
  bool _isInit = false;
  ReminderModel? _existingReminder;
  String? _selectedWorkspaceId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ReminderModel) {
        _existingReminder = args;
        _titleController.text = args.title;
        _selectedDate = args.date;
        _selectedTime = TimeOfDay(hour: args.date.hour, minute: args.date.minute);
        _repeat = args.repeat;
        _notificationEnabled = args.notificationEnabled;
        _assignedUserId = args.assignedTo;
        _selectedWorkspaceId = args.workspaceId;
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authControllerProvider).user;
    final activeWorkspace = ref.watch(activeWorkspaceProvider);

    bool canEdit = true;
    if (_existingReminder != null && currentUser != null && activeWorkspace != null && _existingReminder?.workspaceId == activeWorkspace.id) {
      if (activeWorkspace.ownerId != currentUser.id) {
        final perms = activeWorkspace.memberPermissions[currentUser.id] ?? {};
        final role = perms['reminders'] ?? 'write';
        if (role != 'write' && role != 'admin') {
          canEdit = false;
        }
      }
    }

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.createReminder)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Çalışma Alanı Seçicisi
            WorkspaceSelector(
              selectedWorkspaceId: _selectedWorkspaceId,
              enabled: canEdit,
              onChanged: (val) {
                setState(() => _selectedWorkspaceId = val);
              },
            ),
            SizedBox(height: 16),
            NotivaTextField(
              controller: _titleController,
              label: AppLocalizations.of(context)!.titleHint,
              hint: AppLocalizations.of(context)!.reminderName,
              prefixIcon: const Icon(Icons.notifications_outlined, size: 20),
              enabled: canEdit,
            ),
            SizedBox(height: 20),

            // Görevli Seçimi (Opsiyonel)
            if (activeWorkspace != null && activeWorkspace.type == 'team') ...[
              Text(AppLocalizations.of(context)!.assignUserOptional, style: AppTypography.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _assignedUserId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  enabled: canEdit,
                ),
                hint: Text(AppLocalizations.of(context)!.selectPerson),
                items: [
                  DropdownMenuItem(value: null, child: Text(AppLocalizations.of(context)!.clearSelection)),
                  ...activeWorkspace.members.map((memberId) => DropdownMenuItem(
                    value: memberId,
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 16)),
                        SizedBox(width: 8),
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
                onChanged: canEdit ? (val) => setState(() => _assignedUserId = val) : null,
              ),
              const SizedBox(height: 20),
            ],

            // Tarih seçici
            NotivaCard(
              onTap: canEdit ? () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              } : null,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('${AppLocalizations.of(context)!.dateLabel}: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}', style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Saat seçici
            NotivaCard(
              onTap: canEdit ? () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (picked != null) setState(() => _selectedTime = picked);
              } : null,
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 20, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('${AppLocalizations.of(context)!.timeLabel}: ${_selectedTime.format(context)}', style: AppTypography.bodyMedium),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Tekrar seçici
            Text(AppLocalizations.of(context)!.repeat, style: AppTypography.titleSmall),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildRepeatChip(AppLocalizations.of(context)!.noRepeat, 'none', canEdit),
                _buildRepeatChip(AppLocalizations.of(context)!.daily, 'daily', canEdit),
                _buildRepeatChip(AppLocalizations.of(context)!.weekly, 'weekly', canEdit),
              ],
            ),
            const SizedBox(height: 20),

            // Bildirim toggle
            NotivaCard(
              child: Row(
                children: [
                  Icon(Icons.notifications_active_rounded, size: 20, color: AppColors.warning),
                  SizedBox(width: 12),
                  Text(AppLocalizations.of(context)!.notification, style: AppTypography.bodyMedium),
                  const Spacer(),
                  Switch(value: _notificationEnabled, onChanged: canEdit ? (v) => setState(() => _notificationEnabled = v) : null),
                ],
              ),
            ),
            SizedBox(height: 32),
            if (canEdit)
              NotivaPrimaryButton(
                label: AppLocalizations.of(context)!.save, 
                icon: Icons.save_rounded, 
                onPressed: _saveReminder,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatChip(String label, String value, bool canEdit) {
    final isSelected = _repeat == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: canEdit ? (_) => setState(() => _repeat = value) : null,
      selectedColor: AppColors.secondary,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: isSelected ? AppColors.primary : context.textSecondary,
      ),
    );
  }

  void _saveReminder() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterTitle)),
      );
      return;
    }

    final finalDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final remId = _existingReminder?.id ?? 'rem_${DateTime.now().millisecondsSinceEpoch}';

    final activeWorkspace = ref.read(activeWorkspaceProvider);

    final reminder = ReminderModel(
      id: _existingReminder?.id ?? 'r${DateTime.now().millisecondsSinceEpoch}',
      workspaceId: _selectedWorkspaceId ?? activeWorkspace?.id ?? 'ws1',
      title: _titleController.text.trim(),
      date: finalDateTime,
      repeat: _repeat,
      notificationEnabled: _notificationEnabled,
      assignedTo: _assignedUserId,
    );

    if (_existingReminder != null) {
      if (_existingReminder!.workspaceId != reminder.workspaceId) {
        ref.read(remindersControllerProvider.notifier).deleteReminder(_existingReminder!.id, workspaceId: _existingReminder!.workspaceId);
        ref.read(remindersControllerProvider.notifier).createReminder(reminder);
      } else {
        ref.read(remindersControllerProvider.notifier).updateReminder(reminder);
      }
    } else {
      ref.read(remindersControllerProvider.notifier).createReminder(reminder);
      
      // Bildirim gidecekmiş gibi simüle et
      if (_assignedUserId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.reminderSavedNotify)),
        );
      }
    }

    Navigator.pop(context);
  }
}
