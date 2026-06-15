// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get home => 'Accueil';

  @override
  String get modules => 'Modules';

  @override
  String get profile => 'Profil';

  @override
  String get notes => 'Notes';

  @override
  String get tasks => 'Mes Tâches';

  @override
  String get reminders => 'Rappels';

  @override
  String get workspace => 'Espace partagé (Équipes)';

  @override
  String get todos => 'Liste de choses à faire';

  @override
  String get archive => 'Archives';

  @override
  String get appSettings => 'Paramètres de l\'app';

  @override
  String get subscription => 'Abonnement et Forfaits';

  @override
  String get appearance => 'Apparence';

  @override
  String get font => 'Police';

  @override
  String get notificationSettings => 'Paramètres de notification';

  @override
  String get language => 'Langue';

  @override
  String get supportAndLegal => 'Support et Légal';

  @override
  String get contactUs => 'Nous contacter / Support';

  @override
  String get rateApp => 'Évaluer l\'application';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get accountManagement => 'Gestion du compte';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer le compte définitivement';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get greetingAfternoon => 'Bon Après-midi';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String get searchHint => 'Que voulez-vous chercher?';

  @override
  String get overview => 'Aperçu';

  @override
  String get taskSingle => 'Tâche';

  @override
  String get tasksToCompleteToday => 'À terminer aujourd\'hui';

  @override
  String get activeReminder => 'Rappel Actif';

  @override
  String get todoList => 'Liste de choses à faire';

  @override
  String get recentNotes => 'Notes Récentes';

  @override
  String get seeAll => 'Voir Tout';

  @override
  String get noNotesYet => 'Aucune note pour le moment';

  @override
  String get upcoming => 'À venir';

  @override
  String get noPendingTasks => 'Aucune tâche en attente 🎉';

  @override
  String get priorityLow => 'Basse';

  @override
  String get priorityMedium => 'Moyenne';

  @override
  String get priorityHigh => 'Haute';

  @override
  String get priorityCritical => 'Critique';

  @override
  String get notSpecified => 'Non spécifié';

  @override
  String get assigned => 'Assigné';

  @override
  String get recentTodos => 'To-Dos Récents';

  @override
  String get noActiveTodos => 'Aucune liste active';

  @override
  String stepsCompleted(int completed, int total) {
    return '$completed / $total étapes terminées';
  }

  @override
  String get noteSingle => 'Note';

  @override
  String get completedSingle => 'Terminé';

  @override
  String get todoSingle => 'À faire';

  @override
  String get reminderSingle => 'Rappel';

  @override
  String get totalNotes => 'Total des notes';

  @override
  String get totalTasks => 'Total des tâches';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get appearanceSelection => 'Sélection de l\'apparence';

  @override
  String get fontSelection => 'Sélection de la police';

  @override
  String get cancel => 'Annuler';

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountDesc =>
      'Voulez-vous vraiment supprimer votre compte ? Cette action est irréversible et toutes vos données seront définitivement supprimées.';

  @override
  String get yesDeleteAccount => 'Oui, supprimer mon compte';

  @override
  String get all => 'Tout';

  @override
  String get pinned => 'Épinglé';

  @override
  String get favorites => 'Favoris';

  @override
  String get noPinnedNotes => 'Aucune note épinglée';

  @override
  String get pinnedNotesDesc =>
      'Épinglez vos notes importantes pour les voir ici.';

  @override
  String get noFavoriteNotes => 'Aucune note favorite';

  @override
  String get favoriteNotesDesc =>
      'Ajoutez les notes que vous aimez aux favoris pour les voir ici.';

  @override
  String get noArchivedNotes => 'Aucune note archivée';

  @override
  String get archivedNotesDesc => 'Il n\'y a pas encore de notes archivées.';

  @override
  String get createFirstNote => 'Créez votre première note';

  @override
  String get createNote => 'Créer une note';

  @override
  String get noteArchived => 'Note archivée.';

  @override
  String get save => 'Enregistrer';

  @override
  String get titleHint => 'Titre';

  @override
  String get startWritingNote => 'Commencez à écrire votre note...';

  @override
  String get addTag => 'Ajouter un tag';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get addImage => 'Ajouter une image';

  @override
  String get addFile => 'Ajouter un fichier';

  @override
  String get voiceInputComingSoon => 'Saisie vocale bientôt disponible';

  @override
  String get voiceRecord => 'Enregistrement vocal';

  @override
  String get templates => 'Modèles';

  @override
  String get fileCannotOpen => 'Impossible d\'ouvrir le fichier';

  @override
  String get tagName => 'Nom du tag';

  @override
  String get add => 'Ajouter';

  @override
  String get untitledNote => 'Note sans titre';

  @override
  String get imageSizeError =>
      'La taille de l\'image doit être inférieure à 5 Mo.';

  @override
  String get pdfSizeError => 'La taille du PDF doit être inférieure à 5 Mo.';

  @override
  String get fileUploadFailed => 'Échec du téléchargement du fichier';

  @override
  String get chooseTemplate => 'Choisir un modèle';

  @override
  String get meetingNote => 'Note de réunion';

  @override
  String get shoppingList => 'Liste de courses';

  @override
  String get projectPlan => 'Plan de projet';

  @override
  String get tasksLabel => 'Tâches';

  @override
  String get taskDetail => 'Détail de la tâche';

  @override
  String get taskTitle => 'Titre de la tâche';

  @override
  String get pleaseEnterTaskTitle => 'Veuillez entrer un titre de tâche.';

  @override
  String get subtasks => 'Sous-tâches';

  @override
  String get addNewSubtask => 'Ajouter une nouvelle sous-tâche...';

  @override
  String get assignUser => 'Assigner un utilisateur';

  @override
  String get assignedTo => 'Assigné à';

  @override
  String get pending => 'En attente';

  @override
  String get inProgress => 'En cours';

  @override
  String get taskArchived => 'Tâche archivée.';

  @override
  String get taskNotFound => 'Tâche introuvable';

  @override
  String get assignToNobody => 'N\'assigner à personne';

  @override
  String get assignUserOptional => 'Assigner un utilisateur (Facultatif)';

  @override
  String get selectPerson => 'Sélectionner une personne';

  @override
  String get priorityLabel => 'Priorité';

  @override
  String get todosLabel => 'Tâches à faire';

  @override
  String get todosListEmpty => 'Votre liste de tâches est vide';

  @override
  String get clickPlusToAddList =>
      'Cliquez sur le bouton + pour ajouter une nouvelle liste.';

  @override
  String get newList => 'Nouvelle liste';

  @override
  String get listNameExample => 'Nom de la liste (ex: Courses)';

  @override
  String get pleaseEnterTitle => 'Veuillez entrer un titre.';

  @override
  String get itemsEmpty => 'Les éléments sont vides...';

  @override
  String get addNewItem => 'Ajouter un nouvel élément...';

  @override
  String get completedItemsTab => 'Terminé';

  @override
  String get deleteListConfirm =>
      'Voulez-vous vraiment supprimer définitivement cette liste ?';

  @override
  String get deleteList => 'Supprimer la liste';

  @override
  String get listArchived => 'Liste archivée.';

  @override
  String get listNotFound => 'Liste introuvable';

  @override
  String get shopping => 'Courses';

  @override
  String get details => 'Détails';

  @override
  String get checklist => 'Liste de contrôle';

  @override
  String get boardView => 'Vue tableau';

  @override
  String get listView => 'Vue liste';

  @override
  String get reminder => 'Rappel';

  @override
  String get createReminder => 'Créer un rappel';

  @override
  String get reminderName => 'Nom du rappel';

  @override
  String get reminderArchived => 'Rappel archivé.';

  @override
  String get reminderSavedNotify =>
      'Rappel enregistré. Une notification est envoyée à la personne concernée...';

  @override
  String get noRemindersYet => 'Vous n\'avez pas encore de rappels';

  @override
  String get createFirstReminder => 'Créez votre premier rappel';

  @override
  String get selectEndDate => 'Sélectionner la date de fin';

  @override
  String get dateLabel => 'Date :';

  @override
  String get timeLabel => 'Heure :';

  @override
  String get repeat => 'Répéter';

  @override
  String get noRepeat => 'Pas de répétition';

  @override
  String get daily => 'Quotidien';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get colorSelection => 'Sélection de couleur :';

  @override
  String get notification => 'Notification';

  @override
  String get filesAndImages => 'Fichiers et images';

  @override
  String get noAttachmentsYet => 'Aucune pièce jointe pour le moment';

  @override
  String get addDetailedDescription => 'Ajouter une description détaillée...';

  @override
  String get delete => 'Supprimer';

  @override
  String get clearSelection => 'Effacer la sélection';

  @override
  String get create => 'Créer';

  @override
  String get me => 'Moi';

  @override
  String get legalDocuments => 'Documents Légaux';

  @override
  String get termsOfUse => 'Conditions d\'utilisation';

  @override
  String get accountDeletionPolicy => 'Politique de suppression de compte';

  @override
  String get kvkkText => 'Texte de clarification KVKK';

  @override
  String get appStorePrivacy => 'Conformité de confidentialité App Store';

  @override
  String get googlePlayData =>
      'Conformité à la sécurité des données Google Play';

  @override
  String get personalWorkspace => 'Personnel';

  @override
  String get sharedWorkspace => 'Espace partagé';

  @override
  String get statusLabel => 'Statut';

  @override
  String get priorityLevel => 'Niveau de priorité';

  @override
  String get repeatNone => 'Pas de répétition';

  @override
  String get repeatDaily => 'Quotidien';

  @override
  String get repeatWeekly => 'Hebdomadaire';

  @override
  String get repeatMonthly => 'Mensuel';

  @override
  String get dateAndTime => 'Date et heure';

  @override
  String get calendarAndPlanning => 'Calendrier et planification';

  @override
  String get noPlansOnDate => 'Aucun plan à cette date';

  @override
  String get noArchiveWarning => 'Aucune archive';

  @override
  String get archiveEmptyWarning => 'L\'archive est vide';

  @override
  String get searchAll => 'Tout';

  @override
  String get searchNotes => 'Notes';

  @override
  String get searchTasks => 'Tâches';

  @override
  String get searchTodos => 'Tâches';

  @override
  String get workspaceEmpty => 'Aucun espace';

  @override
  String get subscriptionTitle => 'Abonnement';

  @override
  String get documentNotFound => 'Document introuvable.';

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
  String get notInAnyTeam => 'Vous n’êtes encore membre d’aucune équipe.';

  @override
  String get joinTeam => 'Rejoindre l\'équipe';

  @override
  String get joinTeamDesc =>
      'Saisissez le code d\'invitation à 6 chiffres que vous avez reçu de l\'administrateur de l\'équipe.';

  @override
  String get inviteCode => 'Code d\'invitation';

  @override
  String get join => 'Rejoindre';

  @override
  String get teamJoinedSuccess =>
      'Vous avez rejoint l\'équipe avec succès ! 🎉';

  @override
  String get alreadyTeamMember => 'Vous êtes déjà membre de cette équipe.';

  @override
  String get invalidInviteCode =>
      'Code d\'invitation invalide. Veuillez vérifier à nouveau.';

  @override
  String get noPlansForDate => 'Aucun projet pour cette date.';

  @override
  String get task => 'Tâche';

  @override
  String get error => 'Erreur';

  @override
  String get reminderLabel => 'Rappel';

  @override
  String get unarchiveTooltip => 'Désarchiver';

  @override
  String get itemUnarchived => 'Article désarchivé.';

  @override
  String get manageProductivity => 'Gérez votre productivité';

  @override
  String get loginTitle => 'Se connecter';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailHint => 'exemple@email.com';

  @override
  String get emailRequired => 'L\'e-mail est requis';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get orLabel => 'OU';

  @override
  String get loginWithGoogle => 'Connectez-vous avec Google';

  @override
  String get noAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get welcomeToNotiva => 'Bienvenue chez Notiva';

  @override
  String get fullNameLabel => 'Nom et prénom';

  @override
  String get fullNameHint => 'Entrez votre nom';

  @override
  String get nameRequired => 'Le nom est requis';

  @override
  String get passwordLengthHint => 'Au moins 6 caractères';

  @override
  String get passwordLength => 'Doit contenir au moins 6 caractères';

  @override
  String get confirmPasswordLabel => 'Confirmez le mot de passe';

  @override
  String get confirmPasswordHint => 'Ressaisissez votre mot de passe';

  @override
  String get confirmPasswordRequired =>
      'Confirmer que le mot de passe est requis';

  @override
  String get registerLabel => 'Registre';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get completeProfile => 'Complétez votre profil';

  @override
  String get welcomeHeadline => 'Accueillir!';

  @override
  String get completeProfileDesc =>
      'Veuillez compléter vos coordonnées avant de continuer.';

  @override
  String get photoSizeLimit =>
      'La photo de profil doit être inférieure à 5 Mo.';

  @override
  String get saveAndStart => 'Enregistrer et démarrer';

  @override
  String get phoneLabel => 'Numéro de téléphone';

  @override
  String get phoneRequired => 'Le numéro de téléphone est requis';

  @override
  String get resetPasswordTitle => 'Réinitialisation du mot de passe';

  @override
  String get resetPasswordDesc =>
      'Entrez votre adresse e-mail et nous vous enverrons un lien de réinitialisation de mot de passe.';

  @override
  String get sendLink => 'Envoyer le lien';

  @override
  String get linkSent => 'Lien envoyé !';

  @override
  String get linkSentDesc =>
      'Un lien de réinitialisation du mot de passe a été envoyé à votre adresse e-mail.';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get workspacesTitle => 'Espaces de travail';

  @override
  String get personalWorkspaceCannotBeManaged =>
      'L\'espace de travail personnel ne peut pas être géré';

  @override
  String get teamManagement => 'Gestion d\'équipe';

  @override
  String get inviteCodeLabel => 'Code d\'invitation';

  @override
  String teamMembersCount(int count) {
    return 'Membres de l\'équipe ($count)';
  }

  @override
  String get nameLabel => 'Nom';

  @override
  String get nonePermission => 'Yok';

  @override
  String get readPermission => 'Lire';

  @override
  String get writePermission => 'Écrire';

  @override
  String get leaveTeam => 'Quitter l\'équipe';

  @override
  String get deleteAndDisbandTeam => 'Supprimer et dissoudre l\'équipe';

  @override
  String get managePermissions => 'Gérer les autorisations';

  @override
  String get savePermissions => 'Enregistrer les autorisations';

  @override
  String get permissions => 'Autorisations';

  @override
  String get adminRole => 'Administrateur';

  @override
  String get unknownUser => 'Utilisateur inconnu';

  @override
  String get removeMemberTitle => 'Supprimer un membre';

  @override
  String get removeMemberDesc =>
      'Êtes-vous sûr de vouloir supprimer ce membre de l\'équipe ?';

  @override
  String get remove => 'Retirer';

  @override
  String get leaveTeamTitle => 'Quitter l\'équipe';

  @override
  String get leaveTeamDesc =>
      'Êtes-vous sûr de vouloir quitter cette équipe ? Vous ne pouvez pas revenir à moins que l\'administrateur de l\'équipe ne vous invite à nouveau.';

  @override
  String get deleteTeamTitle => 'Supprimer l\'équipe';

  @override
  String get deleteTeamDesc =>
      'Si vous supprimez cette équipe, toutes les données qu\'elle contient (notes, tâches) seront supprimées. Es-tu sûr?';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get inviteCodeCopied => 'Code d\'invitation copié!';

  @override
  String get loading => 'Chargement...';

  @override
  String get errorMsg => 'Erreur';
}
