import re

file_path = "lib/modules/settings/views/profile_screen.dart"
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace `const Text(` before `l10n.deleteAccountDesc`
content = re.sub(r"const\s+Text\(\s*l10n\.deleteAccountDesc", r"Text(\n                            l10n.deleteAccountDesc", content)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
print("Fixed remaining const")
