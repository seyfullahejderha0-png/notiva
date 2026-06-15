import re
import os

file_path = "lib/modules/dashboard/views/dashboard_screen.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Add intl import
if "import 'package:intl/intl.dart';" not in content:
    content = content.replace("import 'package:flutter_riverpod/flutter_riverpod.dart';", 
                              "import 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:intl/intl.dart';\nimport 'package:nexus_app/l10n/app_localizations.dart';")

# 1. Update _getGreeting
content = re.sub(
    r"String _getGreeting\(\) \{.*?return 'İyi Akşamlar';\s*\}",
    "String _getGreeting(AppLocalizations l10n) {\n    final hour = DateTime.now().hour;\n    if (hour < 12) return l10n.greetingMorning;\n    if (hour < 18) return l10n.greetingAfternoon;\n    return l10n.greetingEvening;\n  }",
    content, flags=re.DOTALL
)

# 2. Update _getMonthName
content = re.sub(
    r"String _getMonthName\(int month\) \{.*?return months\[month\];\s*\}",
    "String _getMonthName(BuildContext context, DateTime date) {\n    return DateFormat.MMM(Localizations.localeOf(context).languageCode).format(date);\n  }",
    content, flags=re.DOTALL
)

# Replace usage of _getMonthName
content = content.replace("_getMonthName(DateTime.now().month)", "_getMonthName(context, DateTime.now())")
content = content.replace("_getMonthName(note.createdAt.month)", "_getMonthName(context, note.createdAt)")
content = content.replace("_getMonthName(task.dueDate!.month)", "_getMonthName(context, task.dueDate!)")

# 3. Inside build: get l10n
if "final l10n = AppLocalizations.of(context)!;" not in content:
    content = content.replace("final wsState = ref.watch(workspaceControllerProvider);", 
                              "final l10n = AppLocalizations.of(context)!;\n    final wsState = ref.watch(workspaceControllerProvider);")

# 4. Replace hardcoded texts
content = content.replace("'${_getGreeting()}, $userName 👋'", "'${_getGreeting(l10n)}, $userName 👋'")
content = content.replace("'Ne aramak istersin?'", "l10n.searchHint")
content = content.replace("'Genel Bakış'", "l10n.overview")
content = content.replace("'${todayTasks.length} Görev'", "'${todayTasks.length} ${l10n.taskSingle}'")
content = content.replace("'Bugün tamamlanması gereken'", "l10n.tasksToCompleteToday")
content = content.replace("'Aktif Hatırlatıcı'", "l10n.activeReminder")
content = content.replace("'Yapılacak Liste'", "l10n.todoList")
content = content.replace("'Son Notlar'", "l10n.recentNotes")
content = content.replace("'Tümü'", "l10n.seeAll")
content = content.replace("'Henüz notunuz yok.'", "l10n.noNotesYet")
content = content.replace("'Yakın Zamanda'", "l10n.upcoming")
content = content.replace("'Bekleyen göreviniz bulunmuyor 🎉'", "l10n.noPendingTasks")
content = content.replace("priorityText = 'Düşük'", "priorityText = l10n.priorityLow")
content = content.replace("priorityText = 'Orta'", "priorityText = l10n.priorityMedium")
content = content.replace("priorityText = 'Yüksek'", "priorityText = l10n.priorityHigh")
content = content.replace("priorityText = 'Kritik'", "priorityText = l10n.priorityCritical")
content = content.replace("'Belirtilmedi'", "l10n.notSpecified")
content = content.replace("'Atandı'", "l10n.assigned")
content = content.replace("'Son Yapılacaklar'", "l10n.recentTodos")
content = content.replace("'Aktif yapılacak listesi yok'", "l10n.noActiveTodos")

# 5. Fix QuickAddFAB texts
content = content.replace("('Not',", "(l10n.noteSingle,")
content = content.replace("('Görev',", "(l10n.taskSingle,")
content = content.replace("('Yapılacak',", "(l10n.todoSingle,")
content = content.replace("('Hatırlatıcı',", "(l10n.reminderSingle,")
content = content.replace("'Not',", "l10n.noteSingle,")
content = content.replace("'Görev',", "l10n.taskSingle,")
content = content.replace("'Yapılacak',", "l10n.todoSingle,")
content = content.replace("'Hatırlatıcı',", "l10n.reminderSingle,")
content = content.replace("_buildMiniFab(Icons.note_add_rounded, l10n.noteSingle,", "_buildMiniFab(context, Icons.note_add_rounded, l10n.noteSingle,")
content = content.replace("_buildMiniFab(Icons.add_task_rounded, l10n.taskSingle,", "_buildMiniFab(context, Icons.add_task_rounded, l10n.taskSingle,")
content = content.replace("_buildMiniFab(Icons.checklist_rtl_rounded, l10n.todoSingle,", "_buildMiniFab(context, Icons.checklist_rtl_rounded, l10n.todoSingle,")
content = content.replace("_buildMiniFab(Icons.notification_add_rounded, l10n.reminderSingle,", "_buildMiniFab(context, Icons.notification_add_rounded, l10n.reminderSingle,")

content = content.replace("Widget _buildMiniFab(IconData icon, String label, Color color, VoidCallback onTap)", "Widget _buildMiniFab(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap)")

# stepsCompleted
# '$completedItems / $totalItems adım tamamlandı' -> l10n.stepsCompleted(completedItems, totalItems)
content = content.replace("'$completedItems / $totalItems adım tamamlandı'", "l10n.stepsCompleted(completedItems, totalItems)")
content = content.replace("'$completedItems / $totalItems adm tamamland'", "l10n.stepsCompleted(completedItems, totalItems)")

# Pass l10n to _QuickAddFAB
# wait, FAB can just get AppLocalizations.of(context)!.
content = re.sub(
    r"Widget build\(BuildContext context\) \{",
    "Widget build(BuildContext context) {\n    final l10n = AppLocalizations.of(context)!;",
    content, count=1
)
content = content.replace("class _QuickAddFABState extends State<_QuickAddFAB> with SingleTickerProviderStateMixin {\n  bool _isExpanded = false;\n\n  @override\n  Widget build(BuildContext context) {\n    return Column(", "class _QuickAddFABState extends State<_QuickAddFAB> with SingleTickerProviderStateMixin {\n  bool _isExpanded = false;\n\n  @override\n  Widget build(BuildContext context) {\n    final l10n = AppLocalizations.of(context)!;\n    return Column(")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
print("Updated dashboard_screen.dart")
