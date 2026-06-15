import os
import re

directories = [
    "lib/modules/notes/views",
    "lib/modules/tasks/views",
    "lib/modules/todos/views",
    "lib/modules/reminders/views"
]

def fix_consts(content):
    # Remove const before common widgets if they contain AppLocalizations
    # This is a bit brute force but works for simple cases.
    
    # We just blindly remove 'const ' from lines that have AppLocalizations
    # and also remove 'const' from previous line if it ends with 'const '
    
    lines = content.split('\n')
    for i in range(len(lines)):
        if "AppLocalizations" in lines[i]:
            lines[i] = lines[i].replace("const ", "")
            # check backwards for const that wraps this
            for j in range(i-1, max(-1, i-5), -1):
                if "const " in lines[j] and ("(" in lines[j] or "[" in lines[j]):
                    lines[j] = lines[j].replace("const ", "")
    
    return '\n'.join(lines)

for d in directories:
    for root, _, files in os.walk(d):
        for file in files:
            if file.endswith(".dart"):
                path = os.path.join(root, file)
                with open(path, "r", encoding="utf-8") as f:
                    content = f.read()
                
                new_content = fix_consts(content)
                if new_content != content:
                    with open(path, "w", encoding="utf-8") as f:
                        f.write(new_content)
                    print(f"Fixed const in {path}")
