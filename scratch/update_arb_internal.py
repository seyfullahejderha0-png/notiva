import json
import os
import re

translations = {
    # Notes
    "all": {"tr": "Tümü", "en": "All", "de": "Alle", "fr": "Tout", "it": "Tutti", "es": "Todo", "pt": "Tudo"},
    "pinned": {"tr": "Sabitlenmiş", "en": "Pinned", "de": "Angepinnt", "fr": "Épinglé", "it": "Fissato", "es": "Fijado", "pt": "Fixado"},
    "favorites": {"tr": "Favoriler", "en": "Favorites", "de": "Favoriten", "fr": "Favoris", "it": "Preferiti", "es": "Favoritos", "pt": "Favoritos"},
    "archive": {"tr": "Arşiv", "en": "Archive", "de": "Archiv", "fr": "Archives", "it": "Archivio", "es": "Archivo", "pt": "Arquivo"},
    "noPinnedNotes": {"tr": "Sabitlenmiş not bulunamadı", "en": "No pinned notes", "de": "Keine angepinnten Notizen", "fr": "Aucune note épinglée", "it": "Nessuna nota fissata", "es": "No hay notas fijadas", "pt": "Nenhuma nota fixada"},
    "pinnedNotesDesc": {"tr": "Önemli notlarınızı sabitleyerek burada görebilirsiniz.", "en": "Pin your important notes to see them here.", "de": "Heften Sie wichtige Notizen an, um sie hier zu sehen.", "fr": "Épinglez vos notes importantes pour les voir ici.", "it": "Fissa le note importanti per vederle qui.", "es": "Fije sus notas importantes para verlas aquí.", "pt": "Fixe suas notas importantes para vê-las aqui."},
    "noFavoriteNotes": {"tr": "Favori not bulunamadı", "en": "No favorite notes", "de": "Keine Favoriten-Notizen", "fr": "Aucune note favorite", "it": "Nessuna nota preferita", "es": "No hay notas favoritas", "pt": "Nenhuma nota favorita"},
    "favoriteNotesDesc": {"tr": "Beğendiğiniz notları favorilere ekleyerek burada görebilirsiniz.", "en": "Add notes you like to favorites to see them here.", "de": "Fügen Sie Notizen, die Ihnen gefallen, zu den Favoriten hinzu, um sie hier zu sehen.", "fr": "Ajoutez les notes que vous aimez aux favoris pour les voir ici.", "it": "Aggiungi le note che ti piacciono ai preferiti per vederle qui.", "es": "Agregue las notas que le gusten a favoritos para verlas aquí.", "pt": "Adicione notas que você gosta aos favoritos para vê-las aqui."},
    "noArchivedNotes": {"tr": "Arşivlenmiş not yok", "en": "No archived notes", "de": "Keine archivierten Notizen", "fr": "Aucune note archivée", "it": "Nessuna nota archiviata", "es": "No hay notas archivadas", "pt": "Nenhuma nota arquivada"},
    "archivedNotesDesc": {"tr": "Henüz arşive kaldırılmış bir not bulunmuyor.", "en": "There are no archived notes yet.", "de": "Es gibt noch keine archivierten Notizen.", "fr": "Il n'y a pas encore de notes archivées.", "it": "Non ci sono ancora note archiviate.", "es": "Aún no hay notas archivadas.", "pt": "Ainda não há notas arquivadas."},
    "noNotesYet": {"tr": "Henüz not yok", "en": "No notes yet", "de": "Noch keine Notizen", "fr": "Aucune note pour le moment", "it": "Ancora nessuna nota", "es": "Aún no hay notas", "pt": "Ainda sem notas"},
    "createFirstNote": {"tr": "İlk notunuzu oluşturun", "en": "Create your first note", "de": "Erstellen Sie Ihre erste Notiz", "fr": "Créez votre première note", "it": "Crea la tua prima nota", "es": "Crea tu primera nota", "pt": "Crie sua primeira nota"},
    "notes": {"tr": "Notlar", "en": "Notes", "de": "Notizen", "fr": "Notes", "it": "Note", "es": "Notas", "pt": "Notas"},
    "createNote": {"tr": "Not Oluştur", "en": "Create Note", "de": "Notiz erstellen", "fr": "Créer une note", "it": "Crea nota", "es": "Crear nota", "pt": "Criar nota"},
    "noteArchived": {"tr": "Not arşivlendi.", "en": "Note archived.", "de": "Notiz archiviert.", "fr": "Note archivée.", "it": "Nota archiviata.", "es": "Nota archivada.", "pt": "Nota arquivada."},
    "save": {"tr": "Kaydet", "en": "Save", "de": "Speichern", "fr": "Enregistrer", "it": "Salva", "es": "Guardar", "pt": "Salvar"},
    "titleHint": {"tr": "Başlık", "en": "Title", "de": "Titel", "fr": "Titre", "it": "Titolo", "es": "Título", "pt": "Título"},
    "startWritingNote": {"tr": "Notunuzu yazmaya başlayın...", "en": "Start writing your note...", "de": "Fangen Sie an, Ihre Notiz zu schreiben...", "fr": "Commencez à écrire votre note...", "it": "Inizia a scrivere la tua nota...", "es": "Empieza a escribir tu nota...", "pt": "Comece a escrever sua nota..."},
    "addTag": {"tr": "Etiket Ekle", "en": "Add Tag", "de": "Tag hinzufügen", "fr": "Ajouter un tag", "it": "Aggiungi tag", "es": "Añadir etiqueta", "pt": "Adicionar tag"},
    "attachments": {"tr": "Ekler", "en": "Attachments", "de": "Anhänge", "fr": "Pièces jointes", "it": "Allegati", "es": "Archivos adjuntos", "pt": "Anexos"},
    "addImage": {"tr": "Resim Ekle", "en": "Add Image", "de": "Bild hinzufügen", "fr": "Ajouter une image", "it": "Aggiungi immagine", "es": "Añadir imagen", "pt": "Adicionar imagem"},
    "addFile": {"tr": "Dosya Ekle", "en": "Add File", "de": "Datei hinzufügen", "fr": "Ajouter un fichier", "it": "Aggiungi file", "es": "Añadir archivo", "pt": "Adicionar arquivo"},
    "voiceInputComingSoon": {"tr": "Sesli giriş yakında eklenecek", "en": "Voice input coming soon", "de": "Spracheingabe kommt bald", "fr": "Saisie vocale bientôt disponible", "it": "Input vocale in arrivo", "es": "Entrada de voz próximamente", "pt": "Entrada de voz em breve"},
    "voiceRecord": {"tr": "Ses Kaydı", "en": "Voice Record", "de": "Sprachaufnahme", "fr": "Enregistrement vocal", "it": "Registrazione vocale", "es": "Grabación de voz", "pt": "Gravação de voz"},
    "templates": {"tr": "Şablonlar", "en": "Templates", "de": "Vorlagen", "fr": "Modèles", "it": "Modelli", "es": "Plantillas", "pt": "Modelos"},
    "fileCannotOpen": {"tr": "Dosya açılamadı", "en": "File could not be opened", "de": "Datei konnte nicht geöffnet werden", "fr": "Impossible d'ouvrir le fichier", "it": "Impossibile aprire il file", "es": "No se pudo abrir el archivo", "pt": "Não foi possível abrir o arquivo"},
    "tagName": {"tr": "Etiket adı", "en": "Tag name", "de": "Tag-Name", "fr": "Nom du tag", "it": "Nome tag", "es": "Nombre de la etiqueta", "pt": "Nome da tag"},
    "add": {"tr": "Ekle", "en": "Add", "de": "Hinzufügen", "fr": "Ajouter", "it": "Aggiungi", "es": "Añadir", "pt": "Adicionar"},
    "untitledNote": {"tr": "İsimsiz Not", "en": "Untitled Note", "de": "Unbenannte Notiz", "fr": "Note sans titre", "it": "Nota senza titolo", "es": "Nota sin título", "pt": "Nota sem título"},
    "imageSizeError": {"tr": "Fotoğraf boyutu 5 MB'dan küçük olmalıdır.", "en": "Image size must be less than 5 MB.", "de": "Die Bildgröße muss weniger als 5 MB betragen.", "fr": "La taille de l'image doit être inférieure à 5 Mo.", "it": "La dimensione dell'immagine deve essere inferiore a 5 MB.", "es": "El tamaño de la imagen debe ser inferior a 5 MB.", "pt": "O tamanho da imagem deve ser inferior a 5 MB."},
    "pdfSizeError": {"tr": "PDF boyutu 5 MB'dan küçük olmalıdır.", "en": "PDF size must be less than 5 MB.", "de": "Die PDF-Größe muss weniger als 5 MB betragen.", "fr": "La taille du PDF doit être inférieure à 5 Mo.", "it": "La dimensione del PDF deve essere inferiore a 5 MB.", "es": "El tamaño del PDF debe ser inferior a 5 MB.", "pt": "O tamanho do PDF deve ser inferior a 5 MB."},
    "fileUploadFailed": {"tr": "Dosya yüklenemedi", "en": "File upload failed", "de": "Datei-Upload fehlgeschlagen", "fr": "Échec du téléchargement du fichier", "it": "Caricamento file non riuscito", "es": "Error al cargar el archivo", "pt": "Falha no upload do arquivo"},
    "chooseTemplate": {"tr": "Şablon Seç", "en": "Choose Template", "de": "Vorlage auswählen", "fr": "Choisir un modèle", "it": "Scegli modello", "es": "Elegir plantilla", "pt": "Escolher modelo"},
    "meetingNote": {"tr": "Toplantı Notu", "en": "Meeting Note", "de": "Besprechungsnotiz", "fr": "Note de réunion", "it": "Nota di riunione", "es": "Nota de reunión", "pt": "Nota de reunião"},
    "shoppingList": {"tr": "Alışveriş Listesi", "en": "Shopping List", "de": "Einkaufsliste", "fr": "Liste de courses", "it": "Lista della spesa", "es": "Lista de compras", "pt": "Lista de compras"},
    "projectPlan": {"tr": "Proje Planı", "en": "Project Plan", "de": "Projektplan", "fr": "Plan de projet", "it": "Piano di progetto", "es": "Plan de proyecto", "pt": "Plano de projeto"},

    # Tasks
    "tasksLabel": {"tr": "Görevler", "en": "Tasks", "de": "Aufgaben", "fr": "Tâches", "it": "Attività", "es": "Tareas", "pt": "Tarefas"},
    "taskDetail": {"tr": "Görev Detayı", "en": "Task Detail", "de": "Aufgabendetails", "fr": "Détail de la tâche", "it": "Dettagli attività", "es": "Detalle de la tarea", "pt": "Detalhe da tarefa"},
    "taskTitle": {"tr": "Görev Başlığı", "en": "Task Title", "de": "Aufgabentitel", "fr": "Titre de la tâche", "it": "Titolo attività", "es": "Título de la tarea", "pt": "Título da tarefa"},
    "pleaseEnterTaskTitle": {"tr": "Lütfen bir görev başlığı girin.", "en": "Please enter a task title.", "de": "Bitte geben Sie einen Aufgabentitel ein.", "fr": "Veuillez entrer un titre de tâche.", "it": "Inserisci un titolo per l'attività.", "es": "Por favor, introduzca un título de tarea.", "pt": "Por favor, insira um título para a tarefa."},
    "subtasks": {"tr": "Alt Görevler", "en": "Subtasks", "de": "Unteraufgaben", "fr": "Sous-tâches", "it": "Sottoattività", "es": "Subtareas", "pt": "Subtarefas"},
    "addNewSubtask": {"tr": "Yeni alt görev ekle...", "en": "Add new subtask...", "de": "Neue Unteraufgabe hinzufügen...", "fr": "Ajouter une nouvelle sous-tâche...", "it": "Aggiungi nuova sottoattività...", "es": "Añadir nueva subtarea...", "pt": "Adicionar nova subtarefa..."},
    "assignUser": {"tr": "Görevli Ata", "en": "Assign User", "de": "Benutzer zuweisen", "fr": "Assigner un utilisateur", "it": "Assegna utente", "es": "Asignar usuario", "pt": "Atribuir usuário"},
    "assignedTo": {"tr": "Görevli: Atandı", "en": "Assigned to", "de": "Zugewiesen an", "fr": "Assigné à", "it": "Assegnato a", "es": "Asignado a", "pt": "Atribuído a"},
    "pending": {"tr": "Bekleyen", "en": "Pending", "de": "Ausstehend", "fr": "En attente", "it": "In sospeso", "es": "Pendiente", "pt": "Pendente"},
    "inProgress": {"tr": "Devam Eden", "en": "In Progress", "de": "In Bearbeitung", "fr": "En cours", "it": "In corso", "es": "En progreso", "pt": "Em andamento"},
    "taskArchived": {"tr": "Görev arşivlendi.", "en": "Task archived.", "de": "Aufgabe archiviert.", "fr": "Tâche archivée.", "it": "Attività archiviata.", "es": "Tarea archivada.", "pt": "Tarefa arquivada."},
    "taskNotFound": {"tr": "Görev bulunamadı", "en": "Task not found", "de": "Aufgabe nicht gefunden", "fr": "Tâche introuvable", "it": "Attività non trovata", "es": "Tarea no encontrada", "pt": "Tarefa não encontrada"},
    "assignToNobody": {"tr": "Kimseye Atama", "en": "Assign to nobody", "de": "Niemandem zuweisen", "fr": "N'assigner à personne", "it": "Non assegnare a nessuno", "es": "No asignar a nadie", "pt": "Não atribuir a ninguém"},
    "assignUserOptional": {"tr": "Kişi Ata (Opsiyonel)", "en": "Assign User (Optional)", "de": "Benutzer zuweisen (Optional)", "fr": "Assigner un utilisateur (Facultatif)", "it": "Assegna utente (Opzionale)", "es": "Asignar usuario (Opcional)", "pt": "Atribuir usuário (Opcional)"},
    "selectPerson": {"tr": "Kişi Seçin", "en": "Select Person", "de": "Person auswählen", "fr": "Sélectionner une personne", "it": "Seleziona persona", "es": "Seleccionar persona", "pt": "Selecionar pessoa"},
    "priorityLabel": {"tr": "Öncelik", "en": "Priority", "de": "Priorität", "fr": "Priorité", "it": "Priorità", "es": "Prioridad", "pt": "Prioridade"},

    # Todos
    "todosLabel": {"tr": "Yapılacaklar", "en": "Todos", "de": "To-Dos", "fr": "Tâches à faire", "it": "Cose da fare", "es": "Tareas pendientes", "pt": "Afazeres"},
    "todosListEmpty": {"tr": "Yapılacaklar listeniz boş", "en": "Your todo list is empty", "de": "Ihre To-Do-Liste ist leer", "fr": "Votre liste de tâches est vide", "it": "La tua lista delle cose da fare è vuota", "es": "Su lista de tareas está vacía", "pt": "Sua lista de afazeres está vazia"},
    "clickPlusToAddList": {"tr": "Yeni bir liste eklemek için + butonuna tıklayın.", "en": "Click the + button to add a new list.", "de": "Klicken Sie auf die Schaltfläche +, um eine neue Liste hinzuzufügen.", "fr": "Cliquez sur le bouton + pour ajouter une nouvelle liste.", "it": "Fai clic sul pulsante + per aggiungere un nuovo elenco.", "es": "Haga clic en el botón + para añadir una nueva lista.", "pt": "Clique no botão + para adicionar uma nova lista."},
    "newList": {"tr": "Yeni Liste", "en": "New List", "de": "Neue Liste", "fr": "Nouvelle liste", "it": "Nuovo elenco", "es": "Nueva lista", "pt": "Nova lista"},
    "listNameExample": {"tr": "Liste Adı (Örn: Alışveriş)", "en": "List Name (e.g. Shopping)", "de": "Listenname (z.B. Einkaufen)", "fr": "Nom de la liste (ex: Courses)", "it": "Nome elenco (es. Spesa)", "es": "Nombre de la lista (ej. Compras)", "pt": "Nome da lista (ex: Compras)"},
    "pleaseEnterTitle": {"tr": "Lütfen bir başlık girin.", "en": "Please enter a title.", "de": "Bitte geben Sie einen Titel ein.", "fr": "Veuillez entrer un titre.", "it": "Inserisci un titolo.", "es": "Por favor, introduzca un título.", "pt": "Por favor, insira um título."},
    "itemsEmpty": {"tr": "Maddeler boş...", "en": "Items are empty...", "de": "Elemente sind leer...", "fr": "Les éléments sont vides...", "it": "Gli elementi sono vuoti...", "es": "Los elementos están vacíos...", "pt": "Os itens estão vazios..."},
    "addNewItem": {"tr": "Yeni madde ekle...", "en": "Add new item...", "de": "Neues Element hinzufügen...", "fr": "Ajouter un nouvel élément...", "it": "Aggiungi nuovo elemento...", "es": "Añadir nuevo elemento...", "pt": "Adicionar novo item..."},
    "completedItemsTab": {"tr": "Tamamlananlar", "en": "Completed", "de": "Abgeschlossen", "fr": "Terminé", "it": "Completati", "es": "Completados", "pt": "Concluídos"},
    "deleteListConfirm": {"tr": "Bu listeyi kalıcı olarak silmek istediğinize emin misiniz?", "en": "Are you sure you want to permanently delete this list?", "de": "Sind Sie sicher, dass Sie diese Liste dauerhaft löschen möchten?", "fr": "Voulez-vous vraiment supprimer définitivement cette liste ?", "it": "Sei sicuro di voler eliminare in modo permanente questo elenco?", "es": "¿Está seguro de que desea eliminar esta lista de forma permanente?", "pt": "Tem certeza de que deseja excluir permanentemente esta lista?"},
    "deleteList": {"tr": "Listeyi Sil", "en": "Delete List", "de": "Liste löschen", "fr": "Supprimer la liste", "it": "Elimina elenco", "es": "Eliminar lista", "pt": "Excluir lista"},
    "listArchived": {"tr": "Liste arşivlendi.", "en": "List archived.", "de": "Liste archiviert.", "fr": "Liste archivée.", "it": "Elenco archiviato.", "es": "Lista archivada.", "pt": "Lista arquivada."},
    "listNotFound": {"tr": "Liste bulunamadı", "en": "List not found", "de": "Liste nicht gefunden", "fr": "Liste introuvable", "it": "Elenco non trovato", "es": "Lista no encontrada", "pt": "Lista não encontrada"},
    "shopping": {"tr": "Alışveriş", "en": "Shopping", "de": "Einkaufen", "fr": "Courses", "it": "Spesa", "es": "Compras", "pt": "Compras"},
    "details": {"tr": "Detaylar", "en": "Details", "de": "Details", "fr": "Détails", "it": "Dettagli", "es": "Detalles", "pt": "Detalhes"},
    "checklist": {"tr": "Checklist", "en": "Checklist", "de": "Checkliste", "fr": "Liste de contrôle", "it": "Lista di controllo", "es": "Lista de verificación", "pt": "Lista de verificação"},
    "boardView": {"tr": "Pano Görünümü", "en": "Board View", "de": "Board-Ansicht", "fr": "Vue tableau", "it": "Visualizzazione bacheca", "es": "Vista de tablero", "pt": "Visualização de quadro"},
    "listView": {"tr": "Liste Görünümü", "en": "List View", "de": "Listenansicht", "fr": "Vue liste", "it": "Visualizzazione elenco", "es": "Vista de lista", "pt": "Visualização de lista"},

    # Reminders
    "reminder": {"tr": "Hatırlatıcı", "en": "Reminder", "de": "Erinnerung", "fr": "Rappel", "it": "Promemoria", "es": "Recordatorio", "pt": "Lembrete"},
    "createReminder": {"tr": "Hatırlatıcı Oluştur", "en": "Create Reminder", "de": "Erinnerung erstellen", "fr": "Créer un rappel", "it": "Crea promemoria", "es": "Crear recordatorio", "pt": "Criar lembrete"},
    "reminderName": {"tr": "Hatırlatıcı adı", "en": "Reminder name", "de": "Erinnerungsname", "fr": "Nom du rappel", "it": "Nome promemoria", "es": "Nombre del recordatorio", "pt": "Nome do lembrete"},
    "reminderArchived": {"tr": "Hatırlatıcı arşivlendi.", "en": "Reminder archived.", "de": "Erinnerung archiviert.", "fr": "Rappel archivé.", "it": "Promemoria archiviato.", "es": "Recordatorio archivado.", "pt": "Lembrete arquivado."},
    "reminderSavedNotify": {"tr": "Hatırlatıcı kaydedildi. İlgili kişiye bildirim gönderiliyor...", "en": "Reminder saved. Notification is being sent to the relevant person...", "de": "Erinnerung gespeichert. Benachrichtigung wird an die betreffende Person gesendet...", "fr": "Rappel enregistré. Une notification est envoyée à la personne concernée...", "it": "Promemoria salvato. Invio notifica alla persona interessata...", "es": "Recordatorio guardado. Se está enviando una notificación a la persona correspondiente...", "pt": "Lembrete salvo. A notificação está sendo enviada para a pessoa relevante..."},
    "reminders": {"tr": "Hatırlatıcılar", "en": "Reminders", "de": "Erinnerungen", "fr": "Rappels", "it": "Promemoria", "es": "Recordatorios", "pt": "Lembretes"},
    "noRemindersYet": {"tr": "Henüz hatırlatıcınız yok", "en": "You don't have any reminders yet", "de": "Sie haben noch keine Erinnerungen", "fr": "Vous n'avez pas encore de rappels", "it": "Non hai ancora promemoria", "es": "Aún no tienes recordatorios", "pt": "Você ainda não tem lembretes"},
    "createFirstReminder": {"tr": "İlk hatırlatıcınızı oluşturun", "en": "Create your first reminder", "de": "Erstellen Sie Ihre erste Erinnerung", "fr": "Créez votre premier rappel", "it": "Crea il tuo primo promemoria", "es": "Crea tu primer recordatorio", "pt": "Crie seu primeiro lembrete"},
    "selectEndDate": {"tr": "Bitiş Tarihi Seç", "en": "Select End Date", "de": "Enddatum auswählen", "fr": "Sélectionner la date de fin", "it": "Seleziona data di fine", "es": "Seleccionar fecha de finalización", "pt": "Selecionar data de término"},
    "dateLabel": {"tr": "Tarih:", "en": "Date:", "de": "Datum:", "fr": "Date :", "it": "Data:", "es": "Fecha:", "pt": "Data:"},
    "timeLabel": {"tr": "Saat:", "en": "Time:", "de": "Uhrzeit:", "fr": "Heure :", "it": "Ora:", "es": "Hora:", "pt": "Hora:"},
    "repeat": {"tr": "Tekrar", "en": "Repeat", "de": "Wiederholen", "fr": "Répéter", "it": "Ripeti", "es": "Repetir", "pt": "Repetir"},
    "noRepeat": {"tr": "Tekrar Yok", "en": "No Repeat", "de": "Keine Wiederholung", "fr": "Pas de répétition", "it": "Nessuna ripetizione", "es": "Sin repetición", "pt": "Sem repetição"},
    "daily": {"tr": "Günlük", "en": "Daily", "de": "Täglich", "fr": "Quotidien", "it": "Quotidiano", "es": "Diario", "pt": "Diário"},
    "weekly": {"tr": "Haftalık", "en": "Weekly", "de": "Wöchentlich", "fr": "Hebdomadaire", "it": "Settimanale", "es": "Semanal", "pt": "Semanal"},
    "colorSelection": {"tr": "Renk Seçimi:", "en": "Color Selection:", "de": "Farbauswahl:", "fr": "Sélection de couleur :", "it": "Selezione colore:", "es": "Selección de color:", "pt": "Seleção de cor:"},
    "notification": {"tr": "Bildirim", "en": "Notification", "de": "Benachrichtigung", "fr": "Notification", "it": "Notifica", "es": "Notificación", "pt": "Notificação"},
    
    # Others
    "filesAndImages": {"tr": "Dosya ve Resimler", "en": "Files and Images", "de": "Dateien und Bilder", "fr": "Fichiers et images", "it": "File e immagini", "es": "Archivos e imágenes", "pt": "Arquivos e imagens"},
    "noAttachmentsYet": {"tr": "Henüz ek bulunmuyor", "en": "No attachments yet", "de": "Noch keine Anhänge", "fr": "Aucune pièce jointe pour le moment", "it": "Ancora nessun allegato", "es": "Aún no hay archivos adjuntos", "pt": "Ainda sem anexos"},
    "addDetailedDescription": {"tr": "Detaylı açıklama ekleyin...", "en": "Add detailed description...", "de": "Detaillierte Beschreibung hinzufügen...", "fr": "Ajouter une description détaillée...", "it": "Aggiungi descrizione dettagliata...", "es": "Añadir descripción detallada...", "pt": "Adicionar descrição detalhada..."},
    "delete": {"tr": "Sil", "en": "Delete", "de": "Löschen", "fr": "Supprimer", "it": "Elimina", "es": "Eliminar", "pt": "Excluir"},
    "clearSelection": {"tr": "Seçimi Temizle", "en": "Clear Selection", "de": "Auswahl aufheben", "fr": "Effacer la sélection", "it": "Cancella selezione", "es": "Borrar selección", "pt": "Limpar seleção"},
    "create": {"tr": "Oluştur", "en": "Create", "de": "Erstellen", "fr": "Créer", "it": "Crea", "es": "Crear", "pt": "Criar"},
    "me": {"tr": "Ben", "en": "Me", "de": "Ich", "fr": "Moi", "it": "Io", "es": "Yo", "pt": "Eu"}
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

print("ARB files updated with internal screen strings.")
