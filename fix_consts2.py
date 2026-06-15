import os

lib_dir = r"C:\Users\sejderha\.gemini\antigravity\scratch\nexus_app\lib"

for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith(".dart"):
            path = os.path.join(root, file)
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
            
            lines = content.split('\n')
            modified = False
            for i, line in enumerate(lines):
                if 'context.text' in line or 'context.bg' in line or 'context.divider' in line:
                    if 'const ' in line:
                        lines[i] = line.replace('const ', '')
                        modified = True
                    # Also check previous line for const if the statement is multiline
                    if i > 0 and 'const ' in lines[i-1] and not ';' in lines[i-1]:
                        lines[i-1] = lines[i-1].replace('const ', '')
                        modified = True
                    if i > 1 and 'const ' in lines[i-2] and not ';' in lines[i-2]:
                        lines[i-2] = lines[i-2].replace('const ', '')
                        modified = True
            
            if modified:
                with open(path, "w", encoding="utf-8") as f:
                    f.write('\n'.join(lines))
                print(f"Fixed const in {file}")
