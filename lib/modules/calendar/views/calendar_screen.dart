import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../../reminders/controllers/reminders_controller.dart';
import '../../tasks/models/task_model.dart';
import '../../reminders/models/reminder_model.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../../core/constants/app_constants.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';
import 'package:nexus_app/l10n/app_localizations.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  bool _isSameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Get events (Tasks and Reminders) mapped by Date
  Map<DateTime, List<dynamic>> _getEvents(List<TaskModel> tasks, List<ReminderModel> reminders) {
    final Map<DateTime, List<dynamic>> eventMap = {};

    for (var task in tasks) {
      if (task.dueDate != null) {
        final date = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
        if (eventMap[date] == null) eventMap[date] = [];
        eventMap[date]!.add(task);
      }
    }

    for (var rem in reminders) {
      final date = DateTime(rem.date.year, rem.date.month, rem.date.day);
      if (eventMap[date] == null) eventMap[date] = [];
      eventMap[date]!.add(rem);
    }

    return eventMap;
  }

  List<dynamic> _getEventsForDay(DateTime day, Map<DateTime, List<dynamic>> eventMap) {
    final date = DateTime(day.year, day.month, day.day);
    return eventMap[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksControllerProvider).tasks;
    final reminders = ref.watch(remindersControllerProvider).state.reminders;
    
    final eventMap = _getEvents(tasks, reminders);
    final selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay, eventMap);

    return Scaffold(
      backgroundColor: context.bgBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calendarAndPlanning),
        centerTitle: false,
      ),
      body: Column(
        children: [
          NotivaCard(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: (day) => _getEventsForDay(day, eventMap),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: selectedEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: context.bgSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noPlansForDate,
                          style: AppTypography.bodyLarge.copyWith(color: context.textTertiary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      final item = selectedEvents[index];

                      if (item is TaskModel) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(context, '/task-detail', arguments: item),
                            borderRadius: BorderRadius.circular(16),
                            child: NotivaCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: AppTypography.titleMedium.copyWith(
                                            decoration: item.status == TaskStatus.completed ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle_outline, size: 14, color: context.textSecondary),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${AppLocalizations.of(context)!.task} - ${item.status.displayLabel(context)}',
                                              style: AppTypography.labelMedium.copyWith(color: context.textSecondary),
                                            ),
                                            if (item.assignedTo != null) ...[
                                              SizedBox(width: 8),
                                              Icon(Icons.person_outline, size: 14, color: context.textSecondary),
                                              const SizedBox(width: 4),
                                              Consumer(
                                                builder: (context, ref, child) {
                                                  final userAsync = ref.watch(userDetailsProvider(item.assignedTo!));
                                                  return userAsync.when(
                                                    data: (data) => Text(
                                                      data?['name']?.split(' ')[0] ?? AppLocalizations.of(context)!.assigned,
                                                      style: AppTypography.labelMedium.copyWith(color: context.textSecondary),
                                                    ),
                                                    loading: () => Text('...', style: AppTypography.labelMedium.copyWith(color: context.textSecondary)),
                                                    error: (_, _) => Text(AppLocalizations.of(context)!.error, style: AppTypography.labelMedium.copyWith(color: context.textSecondary)),
                                                  );
                                                },
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (item is ReminderModel) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(context, '/reminder-create', arguments: item),
                            borderRadius: BorderRadius.circular(16),
                            child: NotivaCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.warning,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: AppTypography.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.alarm, size: 14, color: context.textSecondary),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${AppLocalizations.of(context)!.reminderLabel} - ${DateFormat('HH:mm').format(item.date)}',
                                              style: AppTypography.labelMedium.copyWith(color: context.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
