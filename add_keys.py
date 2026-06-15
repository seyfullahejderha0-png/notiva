import json
import glob
import os
import sys

def main():
    if len(sys.argv) < 4 or (len(sys.argv) - 1) % 3 != 0:
        print('Usage: python add_keys.py key_name english_value turkish_value ...')
        return

    keys = {}
    args = sys.argv[1:]
    for i in range(0, len(args), 3):
        key = args[i]
        en_val = args[i+1]
        tr_val = args[i+2]
        keys[key] = {'en': en_val, 'tr': tr_val}

    for file_path in glob.glob('lib/l10n/app_*.arb'):
        lang = os.path.basename(file_path).split('_')[-1].split('.')[0]
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        for k, vals in keys.items():
            if lang in vals:
                data[k] = vals[lang]
                
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            
    print('Done adding keys.')

if __name__ == '__main__':
    main()
