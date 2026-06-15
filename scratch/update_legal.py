import json
import os
import re

translations = {
    "legalDocuments": {"tr": "Yasal Belgeler", "en": "Legal Documents", "de": "Rechtliche Dokumente", "fr": "Documents Légaux", "it": "Documenti Legali", "es": "Documentos Legales", "pt": "Documentos Legais"},
    "termsOfUse": {"tr": "Kullanım Koşulları", "en": "Terms of Use", "de": "Nutzungsbedingungen", "fr": "Conditions d'utilisation", "it": "Termini di utilizzo", "es": "Condiciones de uso", "pt": "Termos de uso"},
    "accountDeletionPolicy": {"tr": "Hesap Silme Politikası", "en": "Account Deletion Policy", "de": "Kontolöschungsrichtlinie", "fr": "Politique de suppression de compte", "it": "Informativa sull'eliminazione dell'account", "es": "Política de eliminación de cuenta", "pt": "Política de exclusão de conta"},
    "kvkkText": {"tr": "KVKK Aydınlatma Metni", "en": "KVKK Clarification Text", "de": "KVKK-Aufklärungstext", "fr": "Texte de clarification KVKK", "it": "Testo di chiarimento KVKK", "es": "Texto de aclaración KVKK", "pt": "Texto de esclarecimento KVKK"},
    "appStorePrivacy": {"tr": "App Store Privacy Uyum Metni", "en": "App Store Privacy Compliance", "de": "App Store Datenschutz-Konformität", "fr": "Conformité de confidentialité App Store", "it": "Conformità alla privacy dell'App Store", "es": "Cumplimiento de privacidad de App Store", "pt": "Conformidade de privacidade da App Store"},
    "googlePlayData": {"tr": "Google Play Veri Güvenliği Uyum Metni", "en": "Google Play Data Safety Compliance", "de": "Google Play Datensicherheit-Konformität", "fr": "Conformité à la sécurité des données Google Play", "it": "Conformità alla sicurezza dei dati di Google Play", "es": "Cumplimiento de seguridad de datos de Google Play", "pt": "Conformidade de segurança de dados do Google Play"}
}

langs = ["tr", "en", "de", "fr", "it", "es", "pt"]
l10n_dir = "lib/l10n"

for lang in langs:
    arb_path = os.path.join(l10n_dir, f"app_{lang}.arb")
    with open(arb_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    for key, values in translations.items():
        data[key] = values[lang]
            
    with open(arb_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("ARB updated for legal docs.")

# Replace in file
file_path = "lib/modules/settings/views/legal_documents_screen.dart"
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

if "import 'package:nexus_app/l10n/app_localizations.dart';" not in content:
    content = content.replace("import 'package:flutter_markdown/flutter_markdown.dart';", "import 'package:flutter_markdown/flutter_markdown.dart';\nimport 'package:nexus_app/l10n/app_localizations.dart';")

content = content.replace("const Text('Yasal Belgeler')", "Text(AppLocalizations.of(context)!.legalDocuments)")
content = content.replace("'Gizlilik Politikası'", "AppLocalizations.of(context)!.privacyPolicy")
content = content.replace("'Kullanım Koşulları'", "AppLocalizations.of(context)!.termsOfUse")
content = content.replace("'Hesap Silme Politikası'", "AppLocalizations.of(context)!.accountDeletionPolicy")
content = content.replace("'KVKK Aydınlatma Metni'", "AppLocalizations.of(context)!.kvkkText")
content = content.replace("'App Store Privacy Uyum Metni'", "AppLocalizations.of(context)!.appStorePrivacy")
content = content.replace("'Google Play Veri Güvenliği Uyum Metni'", "AppLocalizations.of(context)!.googlePlayData")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
print("Updated legal_documents_screen.dart")
