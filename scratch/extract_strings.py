import os
import re

directories = [
    "lib/modules/notes/views",
    "lib/modules/tasks/views",
    "lib/modules/todos/views",
    "lib/modules/reminders/views"
]

turkish_chars_pattern = re.compile(r"['\"][^'\"]*[çÇşŞğĞüÜöÖıİ][^'\"]*['\"]")

found_strings = set()

for d in directories:
    for root, _, files in os.walk(d):
        for file in files:
            if file.endswith(".dart"):
                file_path = os.path.join(root, file)
                with open(file_path, "r", encoding="utf-8") as f:
                    lines = f.readlines()
                    for line in lines:
                        # Extract strings with single quotes
                        matches = re.findall(r"'([^']*)'", line)
                        for match in matches:
                            # Skip simple empty or very short non-word strings
                            if len(match) > 1 and re.search(r"[a-zA-ZçÇşŞğĞüÜöÖıİ]", match):
                                # Skip obvious path/keys
                                if not ("/" in match or match.startswith("ws") or match.startswith("user") or match.startswith("f1") or match.startswith("n1")):
                                    found_strings.add(match)

print("FOUND STRINGS:")
for s in sorted(list(found_strings)):
    print(s)
