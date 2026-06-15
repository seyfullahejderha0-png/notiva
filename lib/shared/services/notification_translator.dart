import 'package:flutter/foundation.dart';

class NotificationTranslator {
  /// Desteklenen diller için bildirim başlıkları
  static Map<String, String> getTaskAddedTitle(String taskName) {
    return {
      'en': 'New Task: $taskName',
      'tr': 'Yeni Görev: $taskName',
      'de': 'Neue Aufgabe: $taskName',
      'es': 'Nueva Tarea: $taskName',
      'fr': 'Nouvelle Tâche: $taskName',
      'it': 'Nuovo Compito: $taskName',
      'pt': 'Nova Tarefa: $taskName',
    };
  }

  static Map<String, String> getTaskAddedMessage(String assignerName) {
    return {
      'en': '$assignerName assigned a new task to you.',
      'tr': '$assignerName size yeni bir görev atadı.',
      'de': '$assignerName hat Ihnen eine neue Aufgabe zugewiesen.',
      'es': '$assignerName te ha asignado una nueva tarea.',
      'fr': '$assignerName vous a assigné une nouvelle tâche.',
      'it': '$assignerName ti ha assegnato un nuovo compito.',
      'pt': '$assignerName atribuiu uma nova tarefa a você.',
    };
  }

  static Map<String, String> getTaskUpdatedTitle(String taskName) {
    return {
      'en': 'Task Updated: $taskName',
      'tr': 'Görev Güncellendi: $taskName',
      'de': 'Aufgabe Aktualisiert: $taskName',
      'es': 'Tarea Actualizada: $taskName',
      'fr': 'Tâche Mise à Jour: $taskName',
      'it': 'Compito Aggiornato: $taskName',
      'pt': 'Tarefa Atualizada: $taskName',
    };
  }

  static Map<String, String> getTaskUpdatedMessage(String updaterName) {
    return {
      'en': '$updaterName updated a task.',
      'tr': '$updaterName bir görevi güncelledi.',
      'de': '$updaterName hat eine Aufgabe aktualisiert.',
      'es': '$updaterName actualizó una tarea.',
      'fr': '$updaterName a mis à jour une tâche.',
      'it': '$updaterName ha aggiornato un compito.',
      'pt': '$updaterName atualizou uma tarefa.',
    };
  }

  static Map<String, String> getUpcomingTaskTitle() {
    return {
      'en': 'Upcoming Task',
      'tr': 'Yaklaşan Görev',
      'de': 'Anstehende Aufgabe',
      'es': 'Próxima Tarea',
      'fr': 'Tâche à Venir',
      'it': 'Compito in Arrivo',
      'pt': 'Tarefa Próxima',
    };
  }

  static Map<String, String> getUpcomingTaskMessage(String taskName) {
    return {
      'en': 'You have a task due tomorrow: $taskName',
      'tr': 'Yarına yetiştirmen gereken bir görev var: $taskName',
      'de': 'Sie haben morgen eine Aufgabe fällig: $taskName',
      'es': 'Tienes una tarea para mañana: $taskName',
      'fr': 'Vous avez une tâche à rendre demain : $taskName',
      'it': 'Hai un compito in scadenza domani: $taskName',
      'pt': 'Você tem uma tarefa para amanhã: $taskName',
    };
  }

  static Map<String, String> getDueTodayTaskTitle() {
    return {
      'en': 'Task Due Today',
      'tr': 'Bugün Teslim Edilecek Görev',
      'de': 'Heute fällige Aufgabe',
      'es': 'Tarea para Hoy',
      'fr': 'Tâche à Rendre Aujourd\'hui',
      'it': 'Compito in Scadenza Oggi',
      'pt': 'Tarefa para Hoje',
    };
  }

  static Map<String, String> getDueTodayTaskMessage(String taskName) {
    return {
      'en': 'Task you need to complete today: $taskName',
      'tr': 'Bugün tamamlaman gereken görev: $taskName',
      'de': 'Aufgabe, die Sie heute abschließen müssen: $taskName',
      'es': 'Tarea que debes completar hoy: $taskName',
      'fr': 'Tâche que vous devez terminer aujourd\'hui : $taskName',
      'it': 'Compito che devi completare oggi: $taskName',
      'pt': 'Tarefa que você precisa concluir hoje: $taskName',
    };
  }

  static Map<String, String> getNoteAddedTitle() {
    return {
      'en': 'New Note',
      'tr': 'Yeni Not',
      'de': 'Neue Notiz',
      'es': 'Nueva Nota',
      'fr': 'Nouvelle Note',
      'it': 'Nuova Nota',
      'pt': 'Nova Nota',
    };
  }

  static Map<String, String> getNoteAddedMessage(String workspaceName, String noteTitle) {
    return {
      'en': 'A new note was added to $workspaceName: $noteTitle',
      'tr': '$workspaceName alanına yeni bir not eklendi: $noteTitle',
      'de': 'Eine neue Notiz wurde zu $workspaceName hinzugefügt: $noteTitle',
      'es': 'Se añadió una nueva nota a $workspaceName: $noteTitle',
      'fr': 'Une nouvelle note a été ajoutée à $workspaceName : $noteTitle',
      'it': 'Una nuova nota è stata aggiunta a $workspaceName: $noteTitle',
      'pt': 'Uma nova nota foi adicionada a $workspaceName: $noteTitle',
    };
  }

  static Map<String, String> getNoteUpdatedTitle() {
    return {
      'en': 'Note Updated',
      'tr': 'Not Güncellendi',
      'de': 'Notiz Aktualisiert',
      'es': 'Nota Actualizada',
      'fr': 'Note Mise à Jour',
      'it': 'Nota Aggiornata',
      'pt': 'Nota Atualizada',
    };
  }

  static Map<String, String> getNoteUpdatedMessage(String workspaceName, String noteTitle) {
    return {
      'en': 'A note was updated in $workspaceName: $noteTitle',
      'tr': '$workspaceName alanında bir not güncellendi: $noteTitle',
      'de': 'Eine Notiz in $workspaceName wurde aktualisiert: $noteTitle',
      'es': 'Se actualizó una nota en $workspaceName: $noteTitle',
      'fr': 'Une note a été mise à jour dans $workspaceName : $noteTitle',
      'it': 'Una nota è stata aggiornata in $workspaceName: $noteTitle',
      'pt': 'Uma nota foi atualizada em $workspaceName: $noteTitle',
    };
  }

  static Map<String, String> getCommentAddedTitle(String itemType) {
    // Basic itemType conversion or we can leave it
    return {
      'en': 'New Comment',
      'tr': 'Yeni Yorum',
      'de': 'Neuer Kommentar',
      'es': 'Nuevo Comentario',
      'fr': 'Nouveau Commentaire',
      'it': 'Nuovo Commento',
      'pt': 'Novo Comentário',
    };
  }

  static Map<String, String> getCommentAddedMessage(String authorName, String text) {
    return {
      'en': '$authorName commented: $text',
      'tr': '$authorName yorum yaptı: $text',
      'de': '$authorName hat kommentiert: $text',
      'es': '$authorName comentó: $text',
      'fr': '$authorName a commenté : $text',
      'it': '$authorName ha commentato: $text',
      'pt': '$authorName comentou: $text',
    };
  }
}
