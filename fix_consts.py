import re

print('Parsing analyze_output.txt...')
with open('analyze_output.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for line in lines:
    if 'invalid_constant' in line or 'non_constant_list_element' in line:
        match = re.search(r'- (lib\\[^:]+):(\d+):(\d+) -', line)
        if match:
            path = match.group(1)
            line_num = int(match.group(2))
            
            with open(path, 'r', encoding='utf-8') as f:
                content_lines = f.readlines()
            
            target_line = content_lines[line_num - 1]
            if 'const ' in target_line:
                content_lines[line_num - 1] = target_line.replace('const ', '')
                with open(path, 'w', encoding='utf-8') as f:
                    f.writelines(content_lines)
                print(f'Fixed const in {path}:{line_num}')
            else:
                for i in range(1, 5):
                    if line_num - 1 - i >= 0:
                        prev_line = content_lines[line_num - 1 - i]
                        if 'const ' in prev_line:
                            content_lines[line_num - 1 - i] = prev_line.replace('const ', '')
                            with open(path, 'w', encoding='utf-8') as f:
                                f.writelines(content_lines)
                            print(f'Fixed const in {path}:{line_num - i} (backwards)')
                            break
print('Done!')
