// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get home => 'Inicio';

  @override
  String get modules => 'Módulos';

  @override
  String get profile => 'Perfil';

  @override
  String get notes => 'Notas';

  @override
  String get tasks => 'Mis Tareas';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get workspace => 'Espacio de trabajo (Equipos)';

  @override
  String get todos => 'Lista de tareas';

  @override
  String get archive => 'Archivo';

  @override
  String get appSettings => 'Ajustes de la aplicación';

  @override
  String get subscription => 'Suscripción y Planes';

  @override
  String get appearance => 'Apariencia';

  @override
  String get font => 'Fuente';

  @override
  String get notificationSettings => 'Ajustes de notificaciones';

  @override
  String get language => 'Idioma';

  @override
  String get supportAndLegal => 'Soporte y Legal';

  @override
  String get contactUs => 'Contáctanos / Soporte';

  @override
  String get rateApp => 'Calificar la aplicación';

  @override
  String get privacyPolicy => 'Política de Privacidad y Términos';

  @override
  String get accountManagement => 'Gestión de la cuenta';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta permanentemente';

  @override
  String get greetingMorning => 'Buenos Días';

  @override
  String get greetingAfternoon => 'Buenas Tardes';

  @override
  String get greetingEvening => 'Buenas Noches';

  @override
  String get searchHint => '¿Qué quieres buscar?';

  @override
  String get overview => 'Visión General';

  @override
  String get taskSingle => 'Tarea';

  @override
  String get tasksToCompleteToday => 'Para completar hoy';

  @override
  String get activeReminder => 'Recordatorio Activo';

  @override
  String get todoList => 'Lista de Tareas';

  @override
  String get recentNotes => 'Notas Recientes';

  @override
  String get seeAll => 'Ver Todo';

  @override
  String get noNotesYet => 'Aún no hay notas';

  @override
  String get upcoming => 'Próximamente';

  @override
  String get noPendingTasks => 'Sin tareas pendientes 🎉';

  @override
  String get priorityLow => 'Baja';

  @override
  String get priorityMedium => 'Media';

  @override
  String get priorityHigh => 'Alta';

  @override
  String get priorityCritical => 'Crítica';

  @override
  String get notSpecified => 'No especificado';

  @override
  String get assigned => 'Asignado';

  @override
  String get recentTodos => 'Tareas Recientes';

  @override
  String get noActiveTodos => 'No hay lista activa';

  @override
  String stepsCompleted(int completed, int total) {
    return '$completed / $total pasos completados';
  }

  @override
  String get noteSingle => 'Nota';

  @override
  String get completedSingle => 'Completado';

  @override
  String get todoSingle => 'Por hacer';

  @override
  String get reminderSingle => 'Recordatorio';

  @override
  String get totalNotes => 'Total de notas';

  @override
  String get totalTasks => 'Total de tareas';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get appearanceSelection => 'Selección de apariencia';

  @override
  String get fontSelection => 'Selección de fuente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountDesc =>
      '¿Está seguro de que desea eliminar su cuenta? Esta acción no se puede deshacer y todos sus datos se eliminarán de forma permanente.';

  @override
  String get yesDeleteAccount => 'Sí, eliminar mi cuenta';

  @override
  String get all => 'Todo';

  @override
  String get pinned => 'Fijado';

  @override
  String get favorites => 'Favoritos';

  @override
  String get noPinnedNotes => 'No hay notas fijadas';

  @override
  String get pinnedNotesDesc => 'Fije sus notas importantes para verlas aquí.';

  @override
  String get noFavoriteNotes => 'No hay notas favoritas';

  @override
  String get favoriteNotesDesc =>
      'Agregue las notas que le gusten a favoritos para verlas aquí.';

  @override
  String get noArchivedNotes => 'No hay notas archivadas';

  @override
  String get archivedNotesDesc => 'Aún no hay notas archivadas.';

  @override
  String get createFirstNote => 'Crea tu primera nota';

  @override
  String get createNote => 'Crear nota';

  @override
  String get noteArchived => 'Nota archivada.';

  @override
  String get save => 'Guardar';

  @override
  String get titleHint => 'Título';

  @override
  String get startWritingNote => 'Empieza a escribir tu nota...';

  @override
  String get addTag => 'Añadir etiqueta';

  @override
  String get attachments => 'Archivos adjuntos';

  @override
  String get addImage => 'Añadir imagen';

  @override
  String get addFile => 'Añadir archivo';

  @override
  String get voiceInputComingSoon => 'Entrada de voz próximamente';

  @override
  String get voiceRecord => 'Grabación de voz';

  @override
  String get templates => 'Plantillas';

  @override
  String get fileCannotOpen => 'No se pudo abrir el archivo';

  @override
  String get tagName => 'Nombre de la etiqueta';

  @override
  String get add => 'Añadir';

  @override
  String get untitledNote => 'Nota sin título';

  @override
  String get imageSizeError =>
      'El tamaño de la imagen debe ser inferior a 5 MB.';

  @override
  String get pdfSizeError => 'El tamaño del PDF debe ser inferior a 5 MB.';

  @override
  String get fileUploadFailed => 'Error al cargar el archivo';

  @override
  String get chooseTemplate => 'Elegir plantilla';

  @override
  String get meetingNote => 'Nota de reunión';

  @override
  String get shoppingList => 'Lista de compras';

  @override
  String get projectPlan => 'Plan de proyecto';

  @override
  String get tasksLabel => 'Tareas';

  @override
  String get taskDetail => 'Detalle de la tarea';

  @override
  String get taskTitle => 'Título de la tarea';

  @override
  String get pleaseEnterTaskTitle =>
      'Por favor, introduzca un título de tarea.';

  @override
  String get subtasks => 'Subtareas';

  @override
  String get addNewSubtask => 'Añadir nueva subtarea...';

  @override
  String get assignUser => 'Asignar usuario';

  @override
  String get assignedTo => 'Asignado a';

  @override
  String get pending => 'Pendiente';

  @override
  String get inProgress => 'En progreso';

  @override
  String get taskArchived => 'Tarea archivada.';

  @override
  String get taskNotFound => 'Tarea no encontrada';

  @override
  String get assignToNobody => 'No asignar a nadie';

  @override
  String get assignUserOptional => 'Asignar usuario (Opcional)';

  @override
  String get selectPerson => 'Seleccionar persona';

  @override
  String get priorityLabel => 'Prioridad';

  @override
  String get todosLabel => 'Tareas pendientes';

  @override
  String get todosListEmpty => 'Su lista de tareas está vacía';

  @override
  String get clickPlusToAddList =>
      'Haga clic en el botón + para añadir una nueva lista.';

  @override
  String get newList => 'Nueva lista';

  @override
  String get listNameExample => 'Nombre de la lista (ej. Compras)';

  @override
  String get pleaseEnterTitle => 'Por favor, introduzca un título.';

  @override
  String get itemsEmpty => 'Los elementos están vacíos...';

  @override
  String get addNewItem => 'Añadir nuevo elemento...';

  @override
  String get completedItemsTab => 'Completados';

  @override
  String get deleteListConfirm =>
      '¿Está seguro de que desea eliminar esta lista de forma permanente?';

  @override
  String get deleteList => 'Eliminar lista';

  @override
  String get listArchived => 'Lista archivada.';

  @override
  String get listNotFound => 'Lista no encontrada';

  @override
  String get shopping => 'Compras';

  @override
  String get details => 'Detalles';

  @override
  String get checklist => 'Lista de verificación';

  @override
  String get boardView => 'Vista de tablero';

  @override
  String get listView => 'Vista de lista';

  @override
  String get reminder => 'Recordatorio';

  @override
  String get createReminder => 'Crear recordatorio';

  @override
  String get reminderName => 'Nombre del recordatorio';

  @override
  String get reminderArchived => 'Recordatorio archivado.';

  @override
  String get reminderSavedNotify =>
      'Recordatorio guardado. Se está enviando una notificación a la persona correspondiente...';

  @override
  String get noRemindersYet => 'Aún no tienes recordatorios';

  @override
  String get createFirstReminder => 'Crea tu primer recordatorio';

  @override
  String get selectEndDate => 'Seleccionar fecha de finalización';

  @override
  String get dateLabel => 'Fecha:';

  @override
  String get timeLabel => 'Hora:';

  @override
  String get repeat => 'Repetir';

  @override
  String get noRepeat => 'Sin repetición';

  @override
  String get daily => 'Diario';

  @override
  String get weekly => 'Semanal';

  @override
  String get colorSelection => 'Selección de color:';

  @override
  String get notification => 'Notificación';

  @override
  String get filesAndImages => 'Archivos e imágenes';

  @override
  String get noAttachmentsYet => 'Aún no hay archivos adjuntos';

  @override
  String get addDetailedDescription => 'Añadir descripción detallada...';

  @override
  String get delete => 'Eliminar';

  @override
  String get clearSelection => 'Borrar selección';

  @override
  String get create => 'Crear';

  @override
  String get me => 'Yo';

  @override
  String get legalDocuments => 'Documentos Legales';

  @override
  String get termsOfUse => 'Condiciones de uso';

  @override
  String get accountDeletionPolicy => 'Política de eliminación de cuenta';

  @override
  String get kvkkText => 'Texto de aclaración KVKK';

  @override
  String get appStorePrivacy => 'Cumplimiento de privacidad de App Store';

  @override
  String get googlePlayData =>
      'Cumplimiento de seguridad de datos de Google Play';

  @override
  String get personalWorkspace => 'Personal';

  @override
  String get sharedWorkspace => 'Espacio compartido';

  @override
  String get statusLabel => 'Estado';

  @override
  String get priorityLevel => 'Nivel de prioridad';

  @override
  String get repeatNone => 'Sin repetición';

  @override
  String get repeatDaily => 'Diario';

  @override
  String get repeatWeekly => 'Semanal';

  @override
  String get repeatMonthly => 'Mensual';

  @override
  String get dateAndTime => 'Fecha y hora';

  @override
  String get calendarAndPlanning => 'Calendario y planificación';

  @override
  String get noPlansOnDate => 'No hay planes en esta fecha';

  @override
  String get noArchiveWarning => 'Sin archivo';

  @override
  String get archiveEmptyWarning => 'El archivo está vacío';

  @override
  String get searchAll => 'Todo';

  @override
  String get searchNotes => 'Notas';

  @override
  String get searchTasks => 'Tareas';

  @override
  String get searchTodos => 'Tareas';

  @override
  String get workspaceEmpty => 'No hay espacios';

  @override
  String get subscriptionTitle => 'Suscripción';

  @override
  String get documentNotFound => 'Documento no encontrado.';

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
  String get notInAnyTeam => 'Aún no eres miembro de ningún equipo.';

  @override
  String get joinTeam => 'Únete al equipo';

  @override
  String get joinTeamDesc =>
      'Ingrese el código de invitación de 6 dígitos que recibió del administrador del equipo.';

  @override
  String get inviteCode => 'Código de invitación';

  @override
  String get join => 'Unirse';

  @override
  String get teamJoinedSuccess => '¡Te has unido exitosamente al equipo! 🎉';

  @override
  String get alreadyTeamMember => 'Ya eres miembro de este equipo.';

  @override
  String get invalidInviteCode =>
      'Código de invitación no válido. Por favor verifique nuevamente.';

  @override
  String get noPlansForDate => 'No hay planes para esta fecha.';

  @override
  String get task => 'Tarea';

  @override
  String get error => 'Error';

  @override
  String get reminderLabel => 'Recordatorio';

  @override
  String get unarchiveTooltip => 'Desarchivar';

  @override
  String get itemUnarchived => 'Artículo desarchivado.';

  @override
  String get manageProductivity => 'Gestiona tu productividad';

  @override
  String get loginTitle => 'Acceso';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'ejemplo@correo electrónico.com';

  @override
  String get emailRequired => 'Se requiere correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordRequired => 'Se requiere contraseña';

  @override
  String get forgotPassword => 'Has olvidado tu contraseña';

  @override
  String get orLabel => 'O';

  @override
  String get loginWithGoogle => 'Iniciar sesión con Google';

  @override
  String get noAccount => '¿No tienes una cuenta?';

  @override
  String get createAccount => 'Crear una cuenta';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get welcomeToNotiva => 'Bienvenido a Notiva';

  @override
  String get fullNameLabel => 'Nombre completo';

  @override
  String get fullNameHint => 'Introduce tu nombre';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get passwordLengthHint => 'Al menos 6 caracteres';

  @override
  String get passwordLength => 'Debe tener al menos 6 caracteres.';

  @override
  String get confirmPasswordLabel => 'confirmar Contraseña';

  @override
  String get confirmPasswordHint => 'Vuelva a ingresar su contraseña';

  @override
  String get confirmPasswordRequired => 'Se requiere confirmar la contraseña';

  @override
  String get registerLabel => 'Registro';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get completeProfile => 'Completa tu perfil';

  @override
  String get welcomeHeadline => '¡Bienvenido!';

  @override
  String get completeProfileDesc =>
      'Por favor complete sus datos antes de continuar.';

  @override
  String get photoSizeLimit => 'La foto de perfil debe tener menos de 5 MB.';

  @override
  String get saveAndStart => 'Guardar y comenzar';

  @override
  String get phoneLabel => 'Número de teléfono';

  @override
  String get phoneRequired => 'Se requiere número de teléfono';

  @override
  String get resetPasswordTitle => 'Restablecer contraseña';

  @override
  String get resetPasswordDesc =>
      'Ingrese su dirección de correo electrónico y le enviaremos un enlace para restablecer su contraseña.';

  @override
  String get sendLink => 'Enviar enlace';

  @override
  String get linkSent => 'Enlace enviado!';

  @override
  String get linkSentDesc =>
      'Se ha enviado un enlace para restablecer la contraseña a su dirección de correo electrónico.';

  @override
  String get backToLogin => 'Volver a iniciar sesión';

  @override
  String get workspacesTitle => 'Espacios de trabajo';

  @override
  String get personalWorkspaceCannotBeManaged =>
      'El espacio de trabajo personal no se puede gestionar';

  @override
  String get teamManagement => 'Gestión de equipos';

  @override
  String get inviteCodeLabel => 'Código de invitación';

  @override
  String teamMembersCount(int count) {
    return 'Miembros del equipo ($count)';
  }

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nonePermission => 'Yok';

  @override
  String get readPermission => 'Leer';

  @override
  String get writePermission => 'Escribir';

  @override
  String get leaveTeam => 'Dejar equipo';

  @override
  String get deleteAndDisbandTeam => 'Eliminar y disolver equipo';

  @override
  String get managePermissions => 'Administrar permisos';

  @override
  String get savePermissions => 'Guardar permisos';

  @override
  String get permissions => 'Permisos';

  @override
  String get adminRole => 'Administración';

  @override
  String get unknownUser => 'Usuario desconocido';

  @override
  String get removeMemberTitle => 'Eliminar miembro';

  @override
  String get removeMemberDesc =>
      '¿Estás seguro de que deseas eliminar a este miembro del equipo?';

  @override
  String get remove => 'Eliminar';

  @override
  String get leaveTeamTitle => 'Dejar equipo';

  @override
  String get leaveTeamDesc =>
      '¿Estás seguro de que quieres dejar este equipo? No puedes regresar a menos que el administrador del equipo te invite nuevamente.';

  @override
  String get deleteTeamTitle => 'Eliminar equipo';

  @override
  String get deleteTeamDesc =>
      'Si elimina este equipo, se eliminarán todos los datos que contiene (notas, tareas). ¿Está seguro?';

  @override
  String get deleteAction => 'Borrar';

  @override
  String get inviteCodeCopied => '¡Código de invitación copiado!';

  @override
  String get loading => 'Cargando...';

  @override
  String get errorMsg => 'Error';
}
