// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get home => 'Startseite';

  @override
  String get modules => 'Module';

  @override
  String get profile => 'Profil';

  @override
  String get notes => 'Notizen';

  @override
  String get tasks => 'Meine Aufgaben';

  @override
  String get reminders => 'Erinnerungen';

  @override
  String get workspace => 'Geteilter Arbeitsbereich (Teams)';

  @override
  String get todos => 'To-Do Liste';

  @override
  String get archive => 'Archiv';

  @override
  String get appSettings => 'App-Einstellungen';

  @override
  String get subscription => 'Abonnement & Pläne';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get font => 'Schriftart';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get supportAndLegal => 'Support & Rechtliches';

  @override
  String get contactUs => 'Kontaktiere uns / Support';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get privacyPolicy => 'Datenschutz & Bedingungen';

  @override
  String get accountManagement => 'Kontoverwaltung';

  @override
  String get logout => 'Abmelden';

  @override
  String get deleteAccount => 'Konto dauerhaft löschen';

  @override
  String get greetingMorning => 'Guten Morgen';

  @override
  String get greetingAfternoon => 'Guten Tag';

  @override
  String get greetingEvening => 'Guten Abend';

  @override
  String get searchHint => 'Was möchten Sie suchen?';

  @override
  String get overview => 'Übersicht';

  @override
  String get taskSingle => 'Aufgabe';

  @override
  String get tasksToCompleteToday => 'Heute abzuschließen';

  @override
  String get activeReminder => 'Aktive Erinnerung';

  @override
  String get todoList => 'To-Do Liste';

  @override
  String get recentNotes => 'Aktuelle Notizen';

  @override
  String get seeAll => 'Alle sehen';

  @override
  String get noNotesYet => 'Noch keine Notizen';

  @override
  String get upcoming => 'Bevorstehend';

  @override
  String get noPendingTasks => 'Keine ausstehenden Aufgaben 🎉';

  @override
  String get priorityLow => 'Niedrig';

  @override
  String get priorityMedium => 'Mittel';

  @override
  String get priorityHigh => 'Hoch';

  @override
  String get priorityCritical => 'Kritisch';

  @override
  String get notSpecified => 'Nicht angegeben';

  @override
  String get assigned => 'Zugewiesen';

  @override
  String get recentTodos => 'Aktuelle To-Dos';

  @override
  String get noActiveTodos => 'Keine aktive To-Do Liste';

  @override
  String stepsCompleted(int completed, int total) {
    return '$completed / $total Schritte abgeschlossen';
  }

  @override
  String get noteSingle => 'Notiz';

  @override
  String get completedSingle => 'Abgeschlossen';

  @override
  String get todoSingle => 'To-Do';

  @override
  String get reminderSingle => 'Erinnerung';

  @override
  String get totalNotes => 'Notizen gesamt';

  @override
  String get totalTasks => 'Aufgaben gesamt';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get appearanceSelection => 'Erscheinungsbild-Auswahl';

  @override
  String get fontSelection => 'Schriftauswahl';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get deleteAccountDesc =>
      'Möchten Sie Ihr Konto wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden und alle Ihre Daten werden dauerhaft gelöscht.';

  @override
  String get yesDeleteAccount => 'Ja, mein Konto löschen';

  @override
  String get all => 'Alle';

  @override
  String get pinned => 'Angepinnt';

  @override
  String get favorites => 'Favoriten';

  @override
  String get noPinnedNotes => 'Keine angepinnten Notizen';

  @override
  String get pinnedNotesDesc =>
      'Heften Sie wichtige Notizen an, um sie hier zu sehen.';

  @override
  String get noFavoriteNotes => 'Keine Favoriten-Notizen';

  @override
  String get favoriteNotesDesc =>
      'Fügen Sie Notizen, die Ihnen gefallen, zu den Favoriten hinzu, um sie hier zu sehen.';

  @override
  String get noArchivedNotes => 'Keine archivierten Notizen';

  @override
  String get archivedNotesDesc => 'Es gibt noch keine archivierten Notizen.';

  @override
  String get createFirstNote => 'Erstellen Sie Ihre erste Notiz';

  @override
  String get createNote => 'Notiz erstellen';

  @override
  String get noteArchived => 'Notiz archiviert.';

  @override
  String get save => 'Speichern';

  @override
  String get titleHint => 'Titel';

  @override
  String get startWritingNote => 'Fangen Sie an, Ihre Notiz zu schreiben...';

  @override
  String get addTag => 'Tag hinzufügen';

  @override
  String get attachments => 'Anhänge';

  @override
  String get addImage => 'Bild hinzufügen';

  @override
  String get addFile => 'Datei hinzufügen';

  @override
  String get voiceInputComingSoon => 'Spracheingabe kommt bald';

  @override
  String get voiceRecord => 'Sprachaufnahme';

  @override
  String get templates => 'Vorlagen';

  @override
  String get fileCannotOpen => 'Datei konnte nicht geöffnet werden';

  @override
  String get tagName => 'Tag-Name';

  @override
  String get add => 'Hinzufügen';

  @override
  String get untitledNote => 'Unbenannte Notiz';

  @override
  String get imageSizeError => 'Die Bildgröße muss weniger als 5 MB betragen.';

  @override
  String get pdfSizeError => 'Die PDF-Größe muss weniger als 5 MB betragen.';

  @override
  String get fileUploadFailed => 'Datei-Upload fehlgeschlagen';

  @override
  String get chooseTemplate => 'Vorlage auswählen';

  @override
  String get meetingNote => 'Besprechungsnotiz';

  @override
  String get shoppingList => 'Einkaufsliste';

  @override
  String get projectPlan => 'Projektplan';

  @override
  String get tasksLabel => 'Aufgaben';

  @override
  String get taskDetail => 'Aufgabendetails';

  @override
  String get taskTitle => 'Aufgabentitel';

  @override
  String get pleaseEnterTaskTitle => 'Bitte geben Sie einen Aufgabentitel ein.';

  @override
  String get subtasks => 'Unteraufgaben';

  @override
  String get addNewSubtask => 'Neue Unteraufgabe hinzufügen...';

  @override
  String get assignUser => 'Benutzer zuweisen';

  @override
  String get assignedTo => 'Zugewiesen an';

  @override
  String get pending => 'Ausstehend';

  @override
  String get inProgress => 'In Bearbeitung';

  @override
  String get taskArchived => 'Aufgabe archiviert.';

  @override
  String get taskNotFound => 'Aufgabe nicht gefunden';

  @override
  String get assignToNobody => 'Niemandem zuweisen';

  @override
  String get assignUserOptional => 'Benutzer zuweisen (Optional)';

  @override
  String get selectPerson => 'Person auswählen';

  @override
  String get priorityLabel => 'Priorität';

  @override
  String get todosLabel => 'To-Dos';

  @override
  String get todosListEmpty => 'Ihre To-Do-Liste ist leer';

  @override
  String get clickPlusToAddList =>
      'Klicken Sie auf die Schaltfläche +, um eine neue Liste hinzuzufügen.';

  @override
  String get newList => 'Neue Liste';

  @override
  String get listNameExample => 'Listenname (z.B. Einkaufen)';

  @override
  String get pleaseEnterTitle => 'Bitte geben Sie einen Titel ein.';

  @override
  String get itemsEmpty => 'Elemente sind leer...';

  @override
  String get addNewItem => 'Neues Element hinzufügen...';

  @override
  String get completedItemsTab => 'Abgeschlossen';

  @override
  String get deleteListConfirm =>
      'Sind Sie sicher, dass Sie diese Liste dauerhaft löschen möchten?';

  @override
  String get deleteList => 'Liste löschen';

  @override
  String get listArchived => 'Liste archiviert.';

  @override
  String get listNotFound => 'Liste nicht gefunden';

  @override
  String get shopping => 'Einkaufen';

  @override
  String get details => 'Details';

  @override
  String get checklist => 'Checkliste';

  @override
  String get boardView => 'Board-Ansicht';

  @override
  String get listView => 'Listenansicht';

  @override
  String get reminder => 'Erinnerung';

  @override
  String get createReminder => 'Erinnerung erstellen';

  @override
  String get reminderName => 'Erinnerungsname';

  @override
  String get reminderArchived => 'Erinnerung archiviert.';

  @override
  String get reminderSavedNotify =>
      'Erinnerung gespeichert. Benachrichtigung wird an die betreffende Person gesendet...';

  @override
  String get noRemindersYet => 'Sie haben noch keine Erinnerungen';

  @override
  String get createFirstReminder => 'Erstellen Sie Ihre erste Erinnerung';

  @override
  String get selectEndDate => 'Enddatum auswählen';

  @override
  String get dateLabel => 'Datum:';

  @override
  String get timeLabel => 'Uhrzeit:';

  @override
  String get repeat => 'Wiederholen';

  @override
  String get noRepeat => 'Keine Wiederholung';

  @override
  String get daily => 'Täglich';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get colorSelection => 'Farbauswahl:';

  @override
  String get notification => 'Benachrichtigung';

  @override
  String get filesAndImages => 'Dateien und Bilder';

  @override
  String get noAttachmentsYet => 'Noch keine Anhänge';

  @override
  String get addDetailedDescription =>
      'Detaillierte Beschreibung hinzufügen...';

  @override
  String get delete => 'Löschen';

  @override
  String get clearSelection => 'Auswahl aufheben';

  @override
  String get create => 'Erstellen';

  @override
  String get me => 'Ich';

  @override
  String get legalDocuments => 'Rechtliche Dokumente';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get accountDeletionPolicy => 'Kontolöschungsrichtlinie';

  @override
  String get kvkkText => 'KVKK-Aufklärungstext';

  @override
  String get appStorePrivacy => 'App Store Datenschutz-Konformität';

  @override
  String get googlePlayData => 'Google Play Datensicherheit-Konformität';

  @override
  String get personalWorkspace => 'Persönlich';

  @override
  String get sharedWorkspace => 'Geteilter Arbeitsbereich';

  @override
  String get statusLabel => 'Status';

  @override
  String get priorityLevel => 'Prioritätsstufe';

  @override
  String get repeatNone => 'Keine Wiederholung';

  @override
  String get repeatDaily => 'Täglich';

  @override
  String get repeatWeekly => 'Wöchentlich';

  @override
  String get repeatMonthly => 'Monatlich';

  @override
  String get dateAndTime => 'Datum und Uhrzeit';

  @override
  String get calendarAndPlanning => 'Kalender & Planung';

  @override
  String get noPlansOnDate => 'Keine Pläne an diesem Datum';

  @override
  String get noArchiveWarning => 'Kein Archiv';

  @override
  String get archiveEmptyWarning => 'Archiv ist leer';

  @override
  String get searchAll => 'Alle';

  @override
  String get searchNotes => 'Notizen';

  @override
  String get searchTasks => 'Aufgaben';

  @override
  String get searchTodos => 'To-Dos';

  @override
  String get workspaceEmpty => 'Keine Arbeitsbereiche';

  @override
  String get subscriptionTitle => 'Abonnement';

  @override
  String get documentNotFound => 'Dokument nicht gefunden.';

  @override
  String get today => 'Today';

  @override
  String get basicPlan => 'Basic Plan';

  @override
  String get proPlan => 'Professional';

  @override
  String get enterprisePlan => 'Enterprise';

  @override
  String get unlimitedNotes => 'Unlimited Notes and Tasks';

  @override
  String get storage100mb => '100 MB Storage';

  @override
  String get storage1gb => '1 GB Storage';

  @override
  String get storage5gb => '5 GB Storage';

  @override
  String get teamCapacity3 => '3 Member Team Capacity';

  @override
  String get teamCapacity10 => '10 Member Team Capacity';

  @override
  String get teamCapacity50 => '50 Member Team Capacity';

  @override
  String get workspace1 => '1 Shared Workspace';

  @override
  String get workspace2 => '2 Shared Workspaces';

  @override
  String get advancedReminders => 'Advanced Reminders';

  @override
  String get prioritySupport => 'Priority Support';

  @override
  String get selectPlan => 'Select';

  @override
  String get subscriptionActivated => 'Subscription successfully activated! 🥳';

  @override
  String get subscriptionCancelled =>
      'Purchase was cancelled or could not be completed.';

  @override
  String get subscriptionSubtitle => 'Remove Limits 🚀';

  @override
  String get subscriptionDesc =>
      'Take your Notiva experience to the peak by choosing the best plan for you and your team.';

  @override
  String get teamWork => 'Team Work';

  @override
  String get teamWorkDesc =>
      'Build a team or join an existing team with an invite code to manage your projects together.';

  @override
  String get createNewTeam => 'Create New Team';

  @override
  String get joinWithInviteCode => 'Join with Invite Code';

  @override
  String get myTeams => 'My Teams';

  @override
  String membersCount(int count) {
    return '$count members';
  }

  @override
  String get contactsLabel => 'Contacts';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get tryDifferentKeywords => 'Try different keywords';

  @override
  String get searchTitle => 'Search';

  @override
  String get createReminderTitle => 'Create Reminder';

  @override
  String get titleLabel => 'Title';

  @override
  String get repeatLabel => 'Repeat';

  @override
  String get notificationLabel => 'Notification';

  @override
  String get activityStreamTitle => 'Activity Stream';

  @override
  String get taskUpdatedActivity => 'updated task';

  @override
  String get taskAddedActivity => 'added task';

  @override
  String get reminderAddedActivity => 'added reminder';

  @override
  String get noteAddedActivity => 'added note';

  @override
  String get noteUpdatedActivity => 'updated note';

  @override
  String get notInAnyTeam => 'Sie sind noch keinem Team beigetreten.';

  @override
  String get joinTeam => 'Treten Sie dem Team bei';

  @override
  String get joinTeamDesc =>
      'Geben Sie den 6-stelligen Einladungscode ein, den Sie vom Teamadministrator erhalten haben.';

  @override
  String get inviteCode => 'Einladungscode';

  @override
  String get join => 'Verbinden';

  @override
  String get teamJoinedSuccess =>
      'Sie sind dem Team erfolgreich beigetreten! 🎉';

  @override
  String get alreadyTeamMember => 'Sie sind bereits Mitglied dieses Teams.';

  @override
  String get invalidInviteCode =>
      'Ungültiger Einladungscode. Bitte überprüfen Sie es noch einmal.';

  @override
  String get noPlansForDate => 'Für dieses Datum gibt es keine Pläne.';

  @override
  String get task => 'Aufgabe';

  @override
  String get error => 'Fehler';

  @override
  String get reminderLabel => 'Erinnerung';

  @override
  String get unarchiveTooltip => 'Dearchivieren';

  @override
  String get itemUnarchived => 'Artikel nicht archiviert.';

  @override
  String get manageProductivity => 'Verwalten Sie Ihre Produktivität';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailRequired => 'E-Mail ist erforderlich';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get forgotPassword => 'Passwort vergessen';

  @override
  String get orLabel => 'ODER';

  @override
  String get loginWithGoogle => 'Melden Sie sich mit Google an';

  @override
  String get noAccount => 'Sie haben noch kein Konto?';

  @override
  String get createAccount => 'Benutzerkonto erstellen';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get welcomeToNotiva => 'Willkommen bei Notiva';

  @override
  String get fullNameLabel => 'Vollständiger Name';

  @override
  String get fullNameHint => 'Geben Sie Ihren Namen ein';

  @override
  String get nameRequired => 'Name ist erforderlich';

  @override
  String get passwordLengthHint => 'Mindestens 6 Zeichen';

  @override
  String get passwordLength => 'Muss mindestens 6 Zeichen lang sein';

  @override
  String get confirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get confirmPasswordHint => 'Geben Sie Ihr Passwort erneut ein';

  @override
  String get confirmPasswordRequired =>
      'Zur Bestätigung ist ein Passwort erforderlich';

  @override
  String get registerLabel => 'Registrieren';

  @override
  String get alreadyHaveAccount => 'Sie haben bereits ein Konto?';

  @override
  String get completeProfile => 'Vervollständigen Sie Ihr Profil';

  @override
  String get welcomeHeadline => 'Willkommen!';

  @override
  String get completeProfileDesc =>
      'Bitte vervollständigen Sie Ihre Angaben, bevor Sie fortfahren.';

  @override
  String get photoSizeLimit => 'Das Profilfoto muss kleiner als 5 MB sein.';

  @override
  String get saveAndStart => 'Speichern und starten';

  @override
  String get phoneLabel => 'Telefonnummer';

  @override
  String get phoneRequired => 'Telefonnummer ist erforderlich';

  @override
  String get resetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get resetPasswordDesc =>
      'Geben Sie Ihre E-Mail-Adresse ein und wir senden Ihnen einen Link zum Zurücksetzen des Passworts.';

  @override
  String get sendLink => 'Link senden';

  @override
  String get linkSent => 'Link gesendet!';

  @override
  String get linkSentDesc =>
      'Ein Link zum Zurücksetzen des Passworts wurde an Ihre E-Mail-Adresse gesendet.';

  @override
  String get backToLogin => 'Zurück zum Anmelden';

  @override
  String get workspacesTitle => 'Arbeitsbereiche';

  @override
  String get personalWorkspaceCannotBeManaged =>
      'Der persönliche Arbeitsbereich kann nicht verwaltet werden';

  @override
  String get teamManagement => 'Teammanagement';

  @override
  String get inviteCodeLabel => 'Einladungscode';

  @override
  String teamMembersCount(int count) {
    return 'Teammitglieder ($count)';
  }

  @override
  String get nameLabel => 'Name';

  @override
  String get nonePermission => 'Yok';

  @override
  String get readPermission => 'Lesen';

  @override
  String get writePermission => 'Schreiben';

  @override
  String get leaveTeam => 'Verlasse das Team';

  @override
  String get deleteAndDisbandTeam => 'Team löschen und auflösen';

  @override
  String get managePermissions => 'Berechtigungen verwalten';

  @override
  String get savePermissions => 'Berechtigungen speichern';

  @override
  String get permissions => 'Berechtigungen';

  @override
  String get adminRole => 'Admin';

  @override
  String get unknownUser => 'Unbekannter Benutzer';

  @override
  String get removeMemberTitle => 'Mitglied entfernen';

  @override
  String get removeMemberDesc =>
      'Möchten Sie dieses Mitglied wirklich aus dem Team entfernen?';

  @override
  String get remove => 'Entfernen';

  @override
  String get leaveTeamTitle => 'Verlasse das Team';

  @override
  String get leaveTeamDesc =>
      'Sind Sie sicher, dass Sie dieses Team verlassen möchten? Sie können nicht zurückkehren, es sei denn, der Teamadministrator lädt Sie erneut ein.';

  @override
  String get deleteTeamTitle => 'Team löschen';

  @override
  String get deleteTeamDesc =>
      'Wenn Sie dieses Team löschen, werden alle darin enthaltenen Daten (Notizen, Aufgaben) gelöscht. Bist du sicher?';

  @override
  String get deleteAction => 'Löschen';

  @override
  String get inviteCodeCopied => 'Einladungscode kopiert!';

  @override
  String get loading => 'Laden...';

  @override
  String get errorMsg => 'Fehler';
}
