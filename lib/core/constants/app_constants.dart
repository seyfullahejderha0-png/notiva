/// Notiva uygulama genelinde kullanılan sabitler.
class AppConstants {
  AppConstants._();

  // Uygulama bilgileri
  static const String appName = 'Notiva';
  static const String appVersion = '1.0.0';

  // Firestore koleksiyon adları
  static const String usersCollection = 'users';
  static const String workspacesCollection = 'workspaces';
  static const String notesCollection = 'notes';
  static const String tasksCollection = 'tasks';
  static const String contactsCollection = 'contacts';
  static const String remindersCollection = 'reminders';
  static const String foldersCollection = 'folders';
  static const String tagsCollection = 'tags';
  static const String attachmentsCollection = 'attachments';

  // Hive kutu adları
  static const String userBox = 'user_box';
  static const String workspaceBox = 'workspace_box';
  static const String notesBox = 'notes_box';
  static const String tasksBox = 'tasks_box';
  static const String contactsBox = 'contacts_box';
  static const String remindersBox = 'reminders_box';
  static const String syncQueueBox = 'sync_queue_box';
  static const String settingsBox = 'settings_box';

  // Boşluk değerleri
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // Kenar yumuşatma (Modern yuvarlaklık)
  static const double radiusSmall = 16.0;
  static const double radiusMedium = 24.0;
  static const double radiusLarge = 32.0;
  static const double radiusXLarge = 40.0;

  // Animasyon süreleri
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Minimum buton yüksekliği
  static const double buttonHeight = 52.0;
  static const double inputHeight = 56.0;
}
