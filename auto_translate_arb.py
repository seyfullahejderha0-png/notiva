import json
import os
import time
from deep_translator import GoogleTranslator
import traceback

def main():
    en_file = 'lib/l10n/app_en.arb'
    with open(en_file, 'r', encoding='utf-8') as f:
        en_data = json.load(f)
        
    langs = {
        'it': 'it',
        'pt': 'pt',
        'fr': 'fr',
        'es': 'es',
        'de': 'de'
    }
    
    for lang, trans_lang in langs.items():
        file_path = f'lib/l10n/app_{lang}.arb'
        if not os.path.exists(file_path):
            continue
            
        with open(file_path, 'r', encoding='utf-8') as f:
            target_data = json.load(f)
            
        added = False
        translator = GoogleTranslator(source='en', target=trans_lang)
        
        for k, v in en_data.items():
            if k.startswith('@'):
                if k not in target_data:
                    target_data[k] = v
                    added = True
                continue
                
            if k not in target_data:
                try:
                    if '{' in v:
                        pass
                    print(f'Translating {k} to {lang}...')
                    translated = translator.translate(v)
                    target_data[k] = translated
                    added = True
                    time.sleep(0.5)
                except Exception as e:
                    print(f'Error translating {k} to {lang}: {e}')
                    traceback.print_exc()
                    
        if added:
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(target_data, f, ensure_ascii=False, indent=2)
            print(f'Updated {file_path}')

if __name__ == '__main__':
    main()
