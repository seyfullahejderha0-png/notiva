import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notiva_card.dart';
import '../../workspaces/controllers/workspace_controller.dart';
import '../../workspaces/views/workspace_selector_sheet.dart';
import '../../notes/controllers/notes_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../../tasks/models/task_model.dart';
import '../../reminders/controllers/reminders_controller.dart';
import '../../todos/controllers/todos_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../shared/providers/navigation_provider.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

/// Ana panel ekranı.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 18) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  String _getMonthName(BuildContext context, DateTime date) {
    return DateFormat.MMM(Localizations.localeOf(context).languageCode).format(date);
  }

  Widget _buildHeaderIcon(BuildContext context, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.bgSurface,
        border: Border.all(color: context.dividerColor, width: 0.5),
        boxShadow: [BoxShadow(color: AppColors.shadow.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: context.textSecondary),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        padding: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final wsState = ref.watch(workspaceControllerProvider);
    final activeWs = wsState.activeWorkspace;
    final wsController = ref.read(workspaceControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    
    final notesState = ref.watch(notesControllerProvider);
    final tasksState = ref.watch(tasksControllerProvider);
    final remindersState = ref.watch(remindersControllerProvider);
    final todosState = ref.watch(todosControllerProvider);
    
    final pendingTasks = tasksState.tasks.where((t) => t.status != TaskStatus.completed).toList();
    final recentNotes = notesState.state.notes.take(5).toList();
    final recentTasks = pendingTasks.take(5).toList();
    final recentReminders = remindersState.state.reminders.where((r) => r.date.isAfter(DateTime.now())).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final topReminders = recentReminders.take(5).toList();
    final recentTodos = todosState.todos.take(5).toList();

    // Stats calculations
    final todayTasks = pendingTasks.where((t) => t.dueDate != null && t.dueDate!.day == DateTime.now().day).toList();
    final overdueTasks = pendingTasks.where((t) => t.dueDate != null && t.dueDate!.isBefore(DateTime.now()) && t.dueDate!.day != DateTime.now().day).toList();
    final activeReminders = remindersState.state.reminders.length;
    
    final userName = authState.user?.name.split(' ')[0] ?? 'Kullanıcı';

    return Scaffold(
      backgroundColor: context.bgBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await Future.delayed(const Duration(milliseconds: 500)),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── HEADER ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getGreeting(l10n)}, $userName 👋',
                              style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w800, color: context.textPrimary, letterSpacing: -0.5),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${l10n.today}, ${DateTime.now().day} ${_getMonthName(context, DateTime.now())}',
                              style: AppTypography.bodyLarge.copyWith(color: context.textTertiary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeaderIcon(context, Icons.history_rounded, () => Navigator.pushNamed(context, '/activities')),
                          const SizedBox(width: 8),
                          _buildHeaderIcon(context, Icons.calendar_month_rounded, () => Navigator.pushNamed(context, '/calendar')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ─── WORKSPACE & SEARCH ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/search'),
                              child: Container(
                                height: 52,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: context.bgSurface,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(color: AppColors.shadow.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                                  ],
                                  border: Border.all(color: context.dividerColor, width: 0.5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.search_rounded, color: context.textTertiary, size: 22),
                                    const SizedBox(width: 12),
                                    Text(l10n.searchHint, style: AppTypography.bodyMedium.copyWith(color: context.textTertiary)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => WorkspaceSelectorSheet.show(context),
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: activeWs != null ? Color(activeWs.color).withOpacity(0.1) : AppColors.secondaryLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: activeWs != null ? Color(activeWs.color).withOpacity(0.3) : context.dividerColor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    activeWs != null ? wsController.getWorkspaceIcon(activeWs.icon) : Icons.workspaces_rounded,
                                    size: 18,
                                    color: activeWs != null ? Color(activeWs.color) : AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: activeWs != null ? Color(activeWs.color) : AppColors.primary),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ─── BENTO GRID (ÖZET) ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.overview, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold, color: context.textPrimary)),
                      const SizedBox(height: 16),
                      // Bento Ana Kutu: Görevler
                      GestureDetector(
                        onTap: () => ref.read(mainTabProvider.notifier).state = 2,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryDark],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(14)),
                                    child: const Icon(Icons.task_alt_rounded, color: Colors.white, size: 24),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.7), size: 16),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text('${todayTasks.length} ${l10n.taskSingle}', style: AppTypography.headlineMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(l10n.tasksToCompleteToday, style: AppTypography.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Bento Alt Kutular (Hatırlatıcılar & Yapılacaklar)
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/reminders'),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: context.bgSurface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: context.dividerColor, width: 0.5),
                                  boxShadow: [BoxShadow(color: AppColors.shadow.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                      child: const Icon(Icons.notifications_active_rounded, color: AppColors.warning, size: 20),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('$activeReminders', style: AppTypography.headlineMedium.copyWith(color: context.textPrimary, fontWeight: FontWeight.bold)),
                                    Text(l10n.activeReminder, style: AppTypography.labelMedium.copyWith(color: context.textTertiary)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/todos'),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: context.bgSurface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: context.dividerColor, width: 0.5),
                                  boxShadow: [BoxShadow(color: AppColors.shadow.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                      child: const Icon(Icons.checklist_rounded, color: Color(0xFF7C3AED), size: 20),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('${todosState.todos.length}', style: AppTypography.headlineMedium.copyWith(color: context.textPrimary, fontWeight: FontWeight.bold)),
                                    Text(l10n.todoList, style: AppTypography.labelMedium.copyWith(color: context.textTertiary)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 36)),

              // ─── SON NOTLAR (CAROUSEL) ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.recentNotes, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, color: context.textPrimary)),
                      GestureDetector(
                        onTap: () => ref.read(mainTabProvider.notifier).state = 1,
                        child: Text(l10n.seeAll, style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 160,
                  child: recentNotes.isEmpty 
                    ? Center(child: Text(l10n.noNotesYet, style: AppTypography.bodyMedium.copyWith(color: context.textTertiary)))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: recentNotes.length,
                        itemBuilder: (context, index) {
                          final note = recentNotes[index];
                          final gradients = [AppColors.glassBlue, AppColors.glassGreen, AppColors.glassPurple, AppColors.glassOrange];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/note-editor', arguments: note),
                              child: _NotePreviewCard(
                                title: note.title,
                                content: note.content,
                                date: '${note.createdAt.day} ${_getMonthName(context, note.createdAt)}',
                                gradient: gradients[index % gradients.length],
                              ),
                            ),
                          );
                        },
                      ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 36)),

              // ─── YAKLAŞAN GÖREVLER (TIMELINE) ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(l10n.upcoming, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, color: context.textPrimary)),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: recentTasks.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: context.bgSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.dividerColor)),
                        child: Center(child: Text(l10n.noPendingTasks, style: AppTypography.bodyMedium.copyWith(color: context.textTertiary))),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = recentTasks[index];
                          Color priorityColor;
                          String priorityText = '';
                          switch (task.priority) {
                            case TaskPriority.low: priorityColor = AppColors.priorityLow; priorityText = l10n.priorityLow; break;
                            case TaskPriority.medium: priorityColor = AppColors.priorityMedium; priorityText = l10n.priorityMedium; break;
                            case TaskPriority.high: priorityColor = AppColors.priorityHigh; priorityText = l10n.priorityHigh; break;
                            case TaskPriority.critical: priorityColor = AppColors.error; priorityText = l10n.priorityCritical; break;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/task-detail', arguments: task),
                              child: _TaskPreviewCard(
                                title: task.title,
                                dueDate: task.dueDate != null ? '${task.dueDate!.day} ${_getMonthName(context, task.dueDate!)}' : l10n.notSpecified,
                                priority: priorityText,
                                priorityColor: priorityColor,
                              ),
                            ),
                          );
                        },
                        childCount: recentTasks.length,
                      ),
                    ),
              ),

              // ─── YAPILACAKLAR (TODOS) ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.recentTodos, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, color: context.textPrimary)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/todos'),
                        child: Text(l10n.seeAll, style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: recentTodos.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Text(l10n.noActiveTodos, style: AppTypography.bodyMedium.copyWith(color: context.textTertiary)),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final todo = recentTodos[index];
                          final completed = todo.items.where((i) => i.isCompleted).length;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/todo-detail', arguments: todo.id),
                              child: _TodoPreviewCard(
                                title: todo.title,
                                completedItems: completed,
                                totalItems: todo.items.length,
                              ),
                            ),
                          );
                        },
                        childCount: recentTodos.length,
                      ),
                    ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),

      // Hızlı ekleme butonları
      floatingActionButton: _QuickAddFAB(),
    );
  }
}

// ─── Daily Briefing Kartı ───
class _DailyBriefCard extends StatelessWidget {
  final IconData icon;
  final int count;
  final String title;
  final LinearGradient gradient;
  final Color iconColor;
  final VoidCallback onTap;

  const _DailyBriefCard({
    required this.icon,
    required this.count,
    required this.title,
    required this.gradient,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: NotivaCard(
        glassmorphism: true,
        gradient: gradient,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count.toString(),
                  style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w900, color: context.textPrimary),
                ),
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(color: context.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Modern Not Önizleme Kartı ───
class _NotePreviewCard extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final LinearGradient gradient;

  const _NotePreviewCard({
    required this.title,
    required this.content,
    required this.date,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return NotivaCard(
      glassmorphism: true,
      gradient: isDark ? null : gradient,
      color: isDark ? context.bgSurfaceVariant : null,
      padding: const EdgeInsets.all(20),
      borderRadius: AppConstants.radiusLarge,
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                content,
                style: AppTypography.bodyMedium.copyWith(color: context.textSecondary, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 14, color: context.textTertiary),
                SizedBox(width: 4),
                Text(date, style: AppTypography.labelMedium.copyWith(color: context.textTertiary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskPreviewCard extends StatelessWidget {
  final String title;
  final String dueDate;
  final String priority;
  final Color priorityColor;
  final String? assignedTo;

  const _TaskPreviewCard({
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.priorityColor,
    this.assignedTo,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return NotivaCard(
      glassmorphism: true,
      gradient: isDark ? null : AppColors.glassBlue,
      color: isDark ? context.bgSurfaceVariant : null,
      padding: const EdgeInsets.all(16),
      borderRadius: AppConstants.radiusMedium,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: priorityColor, width: 2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(dueDate, style: AppTypography.bodySmall.copyWith(color: context.textTertiary)),
                    if (assignedTo != null) ...[
                      SizedBox(width: 8),
                      Icon(Icons.person_outline, size: 12, color: context.textTertiary),
                      const SizedBox(width: 4),
                      Consumer(
                        builder: (context, ref, child) {
                          final userAsync = ref.watch(userDetailsProvider(assignedTo!));
                          return userAsync.when(
                            data: (data) => Text(
                              data?['name']?.split(' ')[0] ?? AppLocalizations.of(context)!.assigned,
                              style: AppTypography.bodySmall.copyWith(color: context.textTertiary),
                            ),
                            loading: () => Text('...', style: AppTypography.bodySmall.copyWith(color: context.textTertiary)),
                            error: (_, _) => Text('Hata', style: AppTypography.bodySmall.copyWith(color: context.textTertiary)),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              priority,
              style: AppTypography.labelSmall.copyWith(color: priorityColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hızlı Ekleme FAB ───
class _QuickAddFAB extends StatefulWidget {
  @override
  State<_QuickAddFAB> createState() => _QuickAddFABState();
}

class _QuickAddFABState extends State<_QuickAddFAB> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isExpanded) ...[
          _buildMiniFab(context, Icons.note_add_rounded, l10n.noteSingle, AppColors.primary,
              () => Navigator.pushNamed(context, '/note-editor')),
          const SizedBox(height: 8),
          _buildMiniFab(context, Icons.add_task_rounded, l10n.taskSingle, AppColors.success,
              () => Navigator.pushNamed(context, '/task-detail')),
          const SizedBox(height: 8),
          _buildMiniFab(context, Icons.checklist_rtl_rounded, l10n.todoSingle, const Color(0xFF14B8A6),
              () => Navigator.pushNamed(context, '/todos')),
          const SizedBox(height: 8),
          _buildMiniFab(context, Icons.notification_add_rounded, l10n.reminderSingle, AppColors.warning,
              () => Navigator.pushNamed(context, '/reminder-create')),
          const SizedBox(height: 12),
        ],
        FloatingActionButton(
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniFab(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: context.bgSurface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: AppColors.shadow.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: Text(label, style: AppTypography.labelMedium),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: label,
          backgroundColor: color,
          onPressed: () {
            setState(() => _isExpanded = false);
            onTap();
          },
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ],
    );
  }
}

class _ReminderPreviewCard extends StatelessWidget {
  final String title;
  final String date;

  const _ReminderPreviewCard({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return NotivaCard(
      glassmorphism: true,
      gradient: AppColors.glassPurple,
      padding: const EdgeInsets.all(16),
      borderRadius: AppConstants.radiusMedium,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.notifications_active_rounded, color: Color(0xFF7C3AED), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                SizedBox(height: 4),
                Text(date, style: AppTypography.bodySmall.copyWith(color: context.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoPreviewCard extends StatelessWidget {
  final String title;
  final int completedItems;
  final int totalItems;

  const _TodoPreviewCard({required this.title, required this.completedItems, required this.totalItems});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return NotivaCard(
      glassmorphism: true,
      gradient: isDark ? null : AppColors.glassGreen,
      color: isDark ? context.bgSurfaceVariant : null,
      padding: const EdgeInsets.all(16),
      borderRadius: AppConstants.radiusMedium,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF14B8A6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.checklist_rtl_rounded, color: Color(0xFF14B8A6), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                SizedBox(height: 4),
                Text(AppLocalizations.of(context)!.stepsCompleted(completedItems, totalItems), style: AppTypography.bodySmall.copyWith(color: context.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

