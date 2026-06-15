import os
import re

lib_dir = r"C:\Users\sejderha\.gemini\antigravity\scratch\nexus_app\lib"

replacements = {
    "AppColors.textPrimary": "context.textPrimary",
    "AppColors.textSecondary": "context.textSecondary",
    "AppColors.textTertiary": "context.textTertiary",
    "AppColors.surface": "context.bgSurface",
    "AppColors.background": "context.bgBackground",
    "AppColors.divider": "context.dividerColor",
}

for root, dirs, files in os.walk(lib_dir):
    if "core\\theme" in root:
        continue
    for file in files:
        if file.endswith(".dart"):
            path = os.path.join(root, file)
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
            
            original = content
            needs_import = False
            for old, new in replacements.items():
                if old in content:
                    content = content.replace(old, new)
                    needs_import = True
            
            if needs_import:
                # Add import if not present
                import_statement = "import 'package:nexus_app/core/theme/theme_ext.dart';"
                if import_statement not in content:
                    # Find last import
                    lines = content.split('\n')
                    last_import = 0
                    for i, line in enumerate(lines):
                        if line.startswith('import '):
                            last_import = i
                    lines.insert(last_import + 1, import_statement)
                    content = '\n'.join(lines)
                
                with open(path, "w", encoding="utf-8") as f:
                    f.write(content)
                print(f"Updated {file}")
