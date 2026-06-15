import os
import re

directories = [
    "lib/modules/notes/views",
    "lib/modules/tasks/views",
    "lib/modules/todos/views",
    "lib/modules/reminders/views"
]

str_map = {
    "Tümü": "all",
    "Sabitlenmiş": "pinned",
    "Favoriler": "favorites",
    "Arşiv": "archive",
    "Sabitlenmiş not bulunamadı": "noPinnedNotes",
    "Önemli notlarınızı sabitleyerek burada görebilirsiniz.": "pinnedNotesDesc",
    "Favori not bulunamadı": "noFavoriteNotes",
    "Beğendiğiniz notları favorilere ekleyerek burada görebilirsiniz.": "favoriteNotesDesc",
    "Arşivlenmiş not yok": "noArchivedNotes",
    "Henüz arşive kaldırılmış bir not bulunmuyor.": "archivedNotesDesc",
    "Henüz not yok": "noNotesYet",
    "İlk notunuzu oluşturun": "createFirstNote",
    "Notlar": "notes",
    "Not Oluştur": "createNote",
    "Not arşivlendi.": "noteArchived",
    "Kaydet": "save",
    "Başlık": "titleHint",
    "Notunuzu yazmaya başlayın...": "startWritingNote",
    "Etiket Ekle": "addTag",
    "Ekler": "attachments",
    "Resim Ekle": "addImage",
    "Dosya Ekle": "addFile",
    "Sesli giriş yakında eklenecek": "voiceInputComingSoon",
    "Ses Kaydı": "voiceRecord",
    "Şablonlar": "templates",
    "Dosya açılamadı": "fileCannotOpen",
    "Etiket adı": "tagName",
    "İptal": "cancel",
    "Ekle": "add",
    "İsimsiz Not": "untitledNote",
    "Fotoğraf boyutu 5 MB'dan küçük olmalıdır.": "imageSizeError",
    "PDF boyutu 5 MB'dan küçük olmalıdır.": "pdfSizeError",
    "Dosya yüklenemedi": "fileUploadFailed",
    "Şablon Seç": "chooseTemplate",
    "Toplantı Notu": "meetingNote",
    "Alışveriş Listesi": "shoppingList",
    "Proje Planı": "projectPlan",

    "Görevler": "tasksLabel",
    "Görev Detayı": "taskDetail",
    "Görev Başlığı": "taskTitle",
    "Lütfen bir görev başlığı girin.": "pleaseEnterTaskTitle",
    "Alt Görevler": "subtasks",
    "Yeni alt görev ekle...": "addNewSubtask",
    "Görevli Ata": "assignUser",
    "Görevli: Atandı": "assignedTo",
    "Bekleyen": "pending",
    "Devam Eden": "inProgress",
    "Görev arşivlendi.": "taskArchived",
    "Görev bulunamadı": "taskNotFound",
    "Kimseye Atama": "assignToNobody",
    "Kişi Ata (Opsiyonel)": "assignUserOptional",
    "Kişi Seçin": "selectPerson",
    "Öncelik": "priorityLabel",

    "Yapılacaklar": "todosLabel",
    "Yapılacaklar listeniz boş": "todosListEmpty",
    "Yeni bir liste eklemek için + butonuna tıklayın.": "clickPlusToAddList",
    "Yeni Liste": "newList",
    "Liste Adı (Örn: Alışveriş)": "listNameExample",
    "Lütfen bir başlık girin.": "pleaseEnterTitle",
    "Maddeler boş...": "itemsEmpty",
    "Yeni madde ekle...": "addNewItem",
    "Tamamlananlar": "completedItemsTab",
    "Bu listeyi kalıcı olarak silmek istediğinize emin misiniz?": "deleteListConfirm",
    "Listeyi Sil": "deleteList",
    "Liste arşivlendi.": "listArchived",
    "Liste bulunamadı": "listNotFound",
    "Alışveriş": "shopping",
    "Detaylar": "details",
    "Checklist": "checklist",
    "Pano Görünümü": "boardView",
    "Liste Görünümü": "listView",

    "Hatırlatıcı": "reminder",
    "Hatırlatıcı Oluştur": "createReminder",
    "Hatırlatıcı adı": "reminderName",
    "Hatırlatıcı arşivlendi.": "reminderArchived",
    "Hatırlatıcı kaydedildi. İlgili kişiye bildirim gönderiliyor...": "reminderSavedNotify",
    "Hatırlatıcılar": "reminders",
    "Henüz hatırlatıcınız yok": "noRemindersYet",
    "İlk hatırlatıcınızı oluşturun": "createFirstReminder",
    "Bitiş Tarihi Seç": "selectEndDate",
    "Tarih:": "dateLabel",
    "Saat:": "timeLabel",
    "Tekrar": "repeat",
    "Tekrar Yok": "noRepeat",
    "Günlük": "daily",
    "Haftalık": "weekly",
    "Renk Seçimi:": "colorSelection",
    "Bildirim": "notification",
    "Araştırma yap": "projectPlan", 
    "Taslak hazırla": "projectPlan", 

    "Dosya ve Resimler": "filesAndImages",
    "Henüz ek bulunmuyor": "noAttachmentsYet",
    "Detaylı açıklama ekleyin...": "addDetailedDescription",
    "Sil": "delete",
    "Seçimi Temizle": "clearSelection",
    "Oluştur": "create",
    "Ben": "me"
}

# Provide safe translation replacement logic.
def process_file(path):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    original_content = content
    
    # 1. Inject import if not present
    if "import 'package:nexus_app/l10n/app_localizations.dart';" not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:nexus_app/l10n/app_localizations.dart';")
    
    # We will use `AppLocalizations.of(context)!` to be safe instead of assuming `l10n` exists.
    # We must remove const where it wraps our target strings.
    for tr, key in str_map.items():
        # Handle const Text('tr') -> Text(AppLocalizations.of(context)!.key)
        # Using regex to account for spacing
        pattern_const_text = r"const\s+Text\(\s*['\"]" + re.escape(tr) + r"['\"]\s*\)"
        content = re.sub(pattern_const_text, f"Text(AppLocalizations.of(context)!.{key})", content)

        # Handle Text('tr') -> Text(AppLocalizations.of(context)!.key)
        pattern_text = r"Text\(\s*['\"]" + re.escape(tr) + r"['\"]\s*\)"
        content = re.sub(pattern_text, f"Text(AppLocalizations.of(context)!.{key})", content)
        
        # Handle const SnackBar(content: Text('tr')) 
        # (This is tricky because removing const from SnackBar might be needed)
        # We will remove const from SnackBar if it contains our text
        pattern_const_snackbar = r"const\s+SnackBar\(\s*content:\s*(?:const\s+)?Text\(\s*['\"]" + re.escape(tr) + r"['\"]\s*\)\s*\)"
        content = re.sub(pattern_const_snackbar, f"SnackBar(content: Text(AppLocalizations.of(context)!.{key}))", content)

        # Handle other strings like label: 'tr' -> label: AppLocalizations.of(context)!.key
        # We only want to replace standalone strings if they are exactly matching and wrapped in quotes.
        # Be careful not to replace parts of variable names.
        pattern_string = r"['\"]" + re.escape(tr) + r"['\"]"
        content = re.sub(pattern_string, f"AppLocalizations.of(context)!.{key}", content)

    # Some variables like `final List<String> _tags = ['proje', 'plan'];` don't have context. 
    # Or static fields. We can ignore them or manually fix if compile fails.
    
    if content != original_content:
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Updated: {path}")

for d in directories:
    for root, _, files in os.walk(d):
        for file in files:
            if file.endswith(".dart"):
                process_file(os.path.join(root, file))

