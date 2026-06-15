import json
import os

translations = {
    "totalNotes": {"tr": "Toplam Not", "en": "Total Notes", "de": "Notizen gesamt", "fr": "Total des notes", "it": "Note totali", "es": "Total de notas", "pt": "Total de notas"},
    "totalTasks": {"tr": "Toplam Görev", "en": "Total Tasks", "de": "Aufgaben gesamt", "fr": "Total des tâches", "it": "Attività totali", "es": "Total de tareas", "pt": "Total de tarefas"},
    "editProfile": {"tr": "Profili Düzenle", "en": "Edit Profile", "de": "Profil bearbeiten", "fr": "Modifier le profil", "it": "Modifica profilo", "es": "Editar perfil", "pt": "Editar perfil"},
    "themeSystem": {"tr": "Sistem", "en": "System", "de": "System", "fr": "Système", "it": "Sistema", "es": "Sistema", "pt": "Sistema"},
    "themeLight": {"tr": "Aydınlık", "en": "Light", "de": "Hell", "fr": "Clair", "it": "Chiaro", "es": "Claro", "pt": "Claro"},
    "themeDark": {"tr": "Karanlık", "en": "Dark", "de": "Dunkel", "fr": "Sombre", "it": "Scuro", "es": "Oscuro", "pt": "Escuro"},
    "appearanceSelection": {"tr": "Görünüm Seçimi", "en": "Appearance Selection", "de": "Erscheinungsbild-Auswahl", "fr": "Sélection de l'apparence", "it": "Selezione dell'aspetto", "es": "Selección de apariencia", "pt": "Seleção de aparência"},
    "fontSelection": {"tr": "Yazı Tipi Seçimi", "en": "Font Selection", "de": "Schriftauswahl", "fr": "Sélection de la police", "it": "Selezione del carattere", "es": "Selección de fuente", "pt": "Seleção de fonte"},
    "cancel": {"tr": "İptal", "en": "Cancel", "de": "Abbrechen", "fr": "Annuler", "it": "Annulla", "es": "Cancelar", "pt": "Cancelar"},
    "deleteAccountTitle": {"tr": "Hesabı Sil", "en": "Delete Account", "de": "Konto löschen", "fr": "Supprimer le compte", "it": "Elimina account", "es": "Eliminar cuenta", "pt": "Excluir conta"},
    "deleteAccountDesc": {"tr": "Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinir.", "en": "Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.", "de": "Möchten Sie Ihr Konto wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden und alle Ihre Daten werden dauerhaft gelöscht.", "fr": "Voulez-vous vraiment supprimer votre compte ? Cette action est irréversible et toutes vos données seront définitivement supprimées.", "it": "Sei sicuro di voler eliminare il tuo account? Questa azione non può essere annullata e tutti i tuoi dati verranno eliminati in modo permanente.", "es": "¿Está seguro de que desea eliminar su cuenta? Esta acción no se puede deshacer y todos sus datos se eliminarán de forma permanente.", "pt": "Tem certeza de que deseja excluir sua conta? Esta ação não pode ser desfeita e todos os seus dados serão excluídos permanentemente."},
    "yesDeleteAccount": {"tr": "Evet, Hesabımı Sil", "en": "Yes, Delete My Account", "de": "Ja, mein Konto löschen", "fr": "Oui, supprimer mon compte", "it": "Sì, elimina il mio account", "es": "Sí, eliminar mi cuenta", "pt": "Sim, excluir minha conta"},
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

print("ARB files updated with profile strings.")
