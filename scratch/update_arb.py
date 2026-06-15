import json
import os

translations = {
    "greetingMorning": {"tr": "Günaydın", "en": "Good Morning", "de": "Guten Morgen", "fr": "Bonjour", "it": "Buongiorno", "es": "Buenos Días", "pt": "Bom Dia"},
    "greetingAfternoon": {"tr": "İyi Günler", "en": "Good Afternoon", "de": "Guten Tag", "fr": "Bon Après-midi", "it": "Buon Pomeriggio", "es": "Buenas Tardes", "pt": "Boa Tarde"},
    "greetingEvening": {"tr": "İyi Akşamlar", "en": "Good Evening", "de": "Guten Abend", "fr": "Bonsoir", "it": "Buonasera", "es": "Buenas Noches", "pt": "Boa Noite"},
    "searchHint": {"tr": "Ne aramak istersin?", "en": "What do you want to search?", "de": "Was möchten Sie suchen?", "fr": "Que voulez-vous chercher?", "it": "Cosa vuoi cercare?", "es": "¿Qué quieres buscar?", "pt": "O que você quer pesquisar?"},
    "overview": {"tr": "Genel Bakış", "en": "Overview", "de": "Übersicht", "fr": "Aperçu", "it": "Panoramica", "es": "Visión General", "pt": "Visão Geral"},
    "taskSingle": {"tr": "Görev", "en": "Task", "de": "Aufgabe", "fr": "Tâche", "it": "Attività", "es": "Tarea", "pt": "Tarefa"},
    "tasksToCompleteToday": {"tr": "Bugün tamamlanması gereken", "en": "To be completed today", "de": "Heute abzuschließen", "fr": "À terminer aujourd'hui", "it": "Da completare oggi", "es": "Para completar hoy", "pt": "A ser concluído hoje"},
    "activeReminder": {"tr": "Aktif Hatırlatıcı", "en": "Active Reminder", "de": "Aktive Erinnerung", "fr": "Rappel Actif", "it": "Promemoria Attivo", "es": "Recordatorio Activo", "pt": "Lembrete Ativo"},
    "todoList": {"tr": "Yapılacak Liste", "en": "To-Do List", "de": "To-Do Liste", "fr": "Liste de choses à faire", "it": "Lista di cose da fare", "es": "Lista de Tareas", "pt": "Lista de Tarefas"},
    "recentNotes": {"tr": "Son Notlar", "en": "Recent Notes", "de": "Aktuelle Notizen", "fr": "Notes Récentes", "it": "Note Recenti", "es": "Notas Recientes", "pt": "Notas Recentes"},
    "seeAll": {"tr": "Tümü", "en": "See All", "de": "Alle sehen", "fr": "Voir Tout", "it": "Vedi Tutto", "es": "Ver Todo", "pt": "Ver Tudo"},
    "noNotesYet": {"tr": "Henüz notunuz yok.", "en": "You have no notes yet.", "de": "Sie haben noch keine Notizen.", "fr": "Vous n'avez pas encore de notes.", "it": "Non hai ancora note.", "es": "Aún no tienes notas.", "pt": "Você ainda não tem notas."},
    "upcoming": {"tr": "Yakın Zamanda", "en": "Upcoming", "de": "Bevorstehend", "fr": "À venir", "it": "In arrivo", "es": "Próximamente", "pt": "Próximos"},
    "noPendingTasks": {"tr": "Bekleyen göreviniz bulunmuyor 🎉", "en": "No pending tasks 🎉", "de": "Keine ausstehenden Aufgaben 🎉", "fr": "Aucune tâche en attente 🎉", "it": "Nessuna attività in sospeso 🎉", "es": "Sin tareas pendientes 🎉", "pt": "Sem tarefas pendentes 🎉"},
    "priorityLow": {"tr": "Düşük", "en": "Low", "de": "Niedrig", "fr": "Basse", "it": "Bassa", "es": "Baja", "pt": "Baixa"},
    "priorityMedium": {"tr": "Orta", "en": "Medium", "de": "Mittel", "fr": "Moyenne", "it": "Media", "es": "Media", "pt": "Média"},
    "priorityHigh": {"tr": "Yüksek", "en": "High", "de": "Hoch", "fr": "Haute", "it": "Alta", "es": "Alta", "pt": "Alta"},
    "priorityCritical": {"tr": "Kritik", "en": "Critical", "de": "Kritisch", "fr": "Critique", "it": "Critica", "es": "Crítica", "pt": "Crítica"},
    "notSpecified": {"tr": "Belirtilmedi", "en": "Not specified", "de": "Nicht angegeben", "fr": "Non spécifié", "it": "Non specificato", "es": "No especificado", "pt": "Não especificado"},
    "assigned": {"tr": "Atandı", "en": "Assigned", "de": "Zugewiesen", "fr": "Assigné", "it": "Assegnato", "es": "Asignado", "pt": "Atribuído"},
    "recentTodos": {"tr": "Son Yapılacaklar", "en": "Recent To-Dos", "de": "Aktuelle To-Dos", "fr": "To-Dos Récents", "it": "Cose da fare recenti", "es": "Tareas Recientes", "pt": "Tarefas Recentes"},
    "noActiveTodos": {"tr": "Aktif yapılacak listesi yok", "en": "No active to-do list", "de": "Keine aktive To-Do Liste", "fr": "Aucune liste active", "it": "Nessuna lista attiva", "es": "No hay lista activa", "pt": "Nenhuma lista ativa"},
    "stepsCompleted": {"tr": "{completed} / {total} adım tamamlandı", "en": "{completed} / {total} steps completed", "de": "{completed} / {total} Schritte abgeschlossen", "fr": "{completed} / {total} étapes terminées", "it": "{completed} / {total} passaggi completati", "es": "{completed} / {total} pasos completados", "pt": "{completed} / {total} passos concluídos"},
    "noteSingle": {"tr": "Not", "en": "Note", "de": "Notiz", "fr": "Note", "it": "Nota", "es": "Nota", "pt": "Nota"},
    "completedSingle": {"tr": "Tamamlanan", "en": "Completed", "de": "Abgeschlossen", "fr": "Terminé", "it": "Completato", "es": "Completado", "pt": "Concluído"},
    "todoSingle": {"tr": "Yapılacak", "en": "To-Do", "de": "To-Do", "fr": "À faire", "it": "Da fare", "es": "Por hacer", "pt": "A fazer"},
    "reminderSingle": {"tr": "Hatırlatıcı", "en": "Reminder", "de": "Erinnerung", "fr": "Rappel", "it": "Promemoria", "es": "Recordatorio", "pt": "Lembrete"},
}

# The ARB parameters format:
# "stepsCompleted": "{completed} / {total} steps completed",
# "@stepsCompleted": {
#   "placeholders": {
#     "completed": {"type": "int"},
#     "total": {"type": "int"}
#   }
# }

param_metadata = {
    "@stepsCompleted": {
        "placeholders": {
            "completed": {"type": "int"},
            "total": {"type": "int"}
        }
    }
}

langs = ["tr", "en", "de", "fr", "it", "es", "pt"]
l10n_dir = "lib/l10n"

for lang in langs:
    arb_path = os.path.join(l10n_dir, f"app_{lang}.arb")
    with open(arb_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    for key, values in translations.items():
        data[key] = values[lang]
        if f"@{key}" in param_metadata:
            data[f"@{key}"] = param_metadata[f"@{key}"]
            
    with open(arb_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("ARB files updated.")
