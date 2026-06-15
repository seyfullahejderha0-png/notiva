import os
import re

def replace_in_file(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for old, new in replacements:
        content = content.replace(old, new)
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

base_dir = 'lib'

# 1. workspace_selector.dart
filepath = os.path.join(base_dir, 'shared', 'widgets', 'workspace_selector.dart')
if os.path.exists(filepath):
    replace_in_file(filepath, [
        ("Text('Kişisel'", "Text(AppLocalizations.of(context)!.personalWorkspace"),
        ("import '../../modules/workspaces/controllers/workspace_controller.dart';", "import '../../modules/workspaces/controllers/workspace_controller.dart';\nimport 'package:nexus_app/l10n/app_localizations.dart';")
    ])

# 2. task_model.dart
filepath = os.path.join(base_dir, 'modules', 'tasks', 'models', 'task_model.dart')
if os.path.exists(filepath):
    replace_in_file(filepath, [
        ("String get displayLabel {", "String displayLabel(context) {\n    final l10n = AppLocalizations.of(context)!;\n"),
        ("return 'Bekleyen';", "return l10n.pending;"),
        ("return 'Devam Eden';", "return l10n.inProgress;"),
        ("return 'Tamamlanan';", "return l10n.completedItemsTab;"),
        ("return 'İptal';", "return l10n.cancel;"),
        ("return 'Düşük';", "return l10n.priorityLow;"),
        ("return 'Orta';", "return l10n.priorityMedium;"),
        ("return 'Yüksek';", "return l10n.priorityHigh;"),
        ("return 'Kritik';", "return l10n.priorityCritical;"),
        ("return 'Tekrar Yok';", "return l10n.repeatNone;"),
        ("return 'Günlük';", "return l10n.repeatDaily;"),
        ("return 'Haftalık';", "return l10n.repeatWeekly;"),
        ("return 'Aylık';", "return l10n.repeatMonthly;"),
        ("import '../../../shared/models/attachment_model.dart';", "import '../../../shared/models/attachment_model.dart';\nimport 'package:nexus_app/l10n/app_localizations.dart';")
    ])

# 3. task_detail_screen.dart
filepath = os.path.join(base_dir, 'modules', 'tasks', 'views', 'task_detail_screen.dart')
if os.path.exists(filepath):
    replace_in_file(filepath, [
        ("Text('Durum'", "Text(AppLocalizations.of(context)!.statusLabel"),
        ("s.displayLabel", "s.displayLabel(context)"),
        ("p.displayLabel", "p.displayLabel(context)"),
        ("r.displayLabel", "r.displayLabel(context)")
    ])

# 4. reminder_detail_screen.dart
filepath = os.path.join(base_dir, 'modules', 'reminders', 'views', 'reminder_detail_screen.dart')
if os.path.exists(filepath):
    replace_in_file(filepath, [
        ("Text('Tarih ve Saat'", "Text(AppLocalizations.of(context)!.dateAndTime"),
        ("r.displayLabel", "r.displayLabel(context)")
    ])

# 5. search_screen.dart
filepath = os.path.join(base_dir, 'modules', 'search', 'views', 'search_screen.dart')
if os.path.exists(filepath):
    replace_in_file(filepath, [
        ("_tabs = ['Tümü', 'Notlar', 'Görevler', 'Yapılacaklar'];", "_tabs = [AppLocalizations.of(context)!.searchAll, AppLocalizations.of(context)!.searchNotes, AppLocalizations.of(context)!.searchTasks, AppLocalizations.of(context)!.searchTodos];")
    ])

# 6. calendar_screen.dart
filepath = os.path.join(base_dir, 'modules', 'calendar', 'views', 'calendar_screen.dart')
if os.path.exists(filepath):
    replace_in_file(filepath, [
        ("Text('Takvim & Planlama'", "Text(AppLocalizations.of(context)!.calendarAndPlanning"),
        ("title: 'Bu tarihte plan yok'", "title: AppLocalizations.of(context)!.noPlansOnDate")
    ])

# 7. archive_screen.dart
filepath = os.path.join(base_dir, 'modules', 'archive', 'views', 'archive_screen.dart')
if os.path.exists(filepath):
    replace_in_file(filepath, [
        ("Text('Arşiv'", "Text(AppLocalizations.of(context)!.archive"),
        ("_tabs = ['Tümü', 'Notlar', 'Görevler', 'Yapılacaklar'];", "_tabs = [AppLocalizations.of(context)!.searchAll, AppLocalizations.of(context)!.searchNotes, AppLocalizations.of(context)!.searchTasks, AppLocalizations.of(context)!.searchTodos];"),
        ("title: 'Arşiv boş'", "title: AppLocalizations.of(context)!.archiveEmptyWarning"),
        ("title: 'Arşiv yok'", "title: AppLocalizations.of(context)!.noArchiveWarning")
    ])

# 8. workspaces_screen.dart & workspace_detail_screen.dart
filepath = os.path.join(base_dir, 'modules', 'workspaces', 'views', 'workspaces_screen.dart')
if os.path.exists(filepath):
    replace_in_file(filepath, [
        ("Text('Ortak Alanlar'", "Text(AppLocalizations.of(context)!.workspace"),
        ("title: 'Ortak alan bulunamadı'", "title: AppLocalizations.of(context)!.workspaceEmpty")
    ])

# 9. subscription_screen.dart
filepath = os.path.join(base_dir, 'modules', 'subscription', 'views', 'subscription_screen.dart')
if os.path.exists(filepath):
    replace_in_file(filepath, [
        ("Text('Abonelik & Planlar'", "Text(AppLocalizations.of(context)!.subscriptionTitle")
    ])

print("Replacements done.")
