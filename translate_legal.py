import re
from deep_translator import GoogleTranslator

def translate_markdown(text):
    # Split text into chunks to avoid limits
    translator = GoogleTranslator(source='tr', target='en')
    lines = text.split('\n')
    translated_lines = []
    
    current_chunk = []
    current_len = 0
    
    for line in lines:
        if current_len + len(line) > 3000:
            chunk_text = '\n'.join(current_chunk)
            if chunk_text.strip():
                try:
                    translated_lines.append(translator.translate(chunk_text))
                except Exception as e:
                    print(f"Error translating: {e}")
                    translated_lines.append(chunk_text)
            current_chunk = [line]
            current_len = len(line)
        else:
            current_chunk.append(line)
            current_len += len(line) + 1
            
    if current_chunk:
        chunk_text = '\n'.join(current_chunk)
        if chunk_text.strip():
            try:
                translated_lines.append(translator.translate(chunk_text))
            except Exception as e:
                print(f"Error translating: {e}")
                translated_lines.append(chunk_text)
                
    return '\n'.join(translated_lines)

# Read the file
file_path = "lib/modules/settings/views/legal_documents_screen.dart"
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Find all blocks: const String _varName = '''...''';
pattern = r"const String (_[a-zA-Z0-9_]+) = '''(.*?)''';"
matches = re.findall(pattern, content, flags=re.DOTALL)

append_content = "\n// --- ENGLISH TRANSLATIONS ---\n"
for var_name, text in matches:
    if var_name.endswith("_en"):
        continue
    print(f"Translating {var_name}...")
    translated = translate_markdown(text)
    append_content += f"\nconst String {var_name}_en = '''\n{translated}\n''';\n"

# Rewrite the file
# Note: we need to replace the _getDocumentContent logic to use these
content += append_content
with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
print("Done appending translations.")
