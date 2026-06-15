import re
import os

file_path = "lib/modules/settings/views/profile_screen.dart"
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("const Text(l10n.editProfile)", "Text(l10n.editProfile)")
content = content.replace("const Text(l10n.appearanceSelection)", "Text(l10n.appearanceSelection)")
content = content.replace("const Text(l10n.fontSelection)", "Text(l10n.fontSelection)")
content = content.replace("const Text(l10n.deleteAccountTitle)", "Text(l10n.deleteAccountTitle)")
content = content.replace("const Text(l10n.cancel)", "Text(l10n.cancel)")
content = content.replace("const Text(l10n.yesDeleteAccount)", "Text(l10n.yesDeleteAccount)")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

file_path_dash = "lib/modules/dashboard/views/dashboard_screen.dart"
with open(file_path_dash, "r", encoding="utf-8") as f:
    content_dash = f.read()

# Fix l10n in _TaskPreviewCard
content_dash = content_dash.replace("data?['name']?.split(' ')[0] ?? l10n.assigned,", "data?['name']?.split(' ')[0] ?? AppLocalizations.of(context)!.assigned,")

# Fix l10n in _TodoPreviewCard
content_dash = content_dash.replace("Text(l10n.stepsCompleted(completedItems, totalItems)", "Text(AppLocalizations.of(context)!.stepsCompleted(completedItems, totalItems)")

with open(file_path_dash, "w", encoding="utf-8") as f:
    f.write(content_dash)
print("Fixed constants")
