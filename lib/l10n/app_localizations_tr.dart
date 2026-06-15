// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get home => 'Ana Sayfa';

  @override
  String get modules => 'Modüller';

  @override
  String get profile => 'Profil';

  @override
  String get notes => 'Notlar';

  @override
  String get tasks => 'Görevlerim';

  @override
  String get reminders => 'Hatırlatıcılar';

  @override
  String get workspace => 'Ortak Alan (Ekipler)';

  @override
  String get todos => 'Yapılacaklar (To-Do) Listesi';

  @override
  String get archive => 'Arşiv';

  @override
  String get appSettings => 'Uygulama Ayarları';

  @override
  String get subscription => 'Abonelik ve Planlar';

  @override
  String get appearance => 'Görünüm';

  @override
  String get font => 'Yazı Tipi';

  @override
  String get notificationSettings => 'Bildirim Ayarları';

  @override
  String get language => 'Dil';

  @override
  String get supportAndLegal => 'Destek ve Yasal';

  @override
  String get contactUs => 'Bize Ulaşın / Destek';

  @override
  String get rateApp => 'Uygulamayı Puanla';

  @override
  String get privacyPolicy => 'Gizlilik Politikası ve Şartlar';

  @override
  String get accountManagement => 'Hesap Yönetimi';

  @override
  String get logout => 'Oturumu Kapat';

  @override
  String get deleteAccount => 'Hesabımı Kalıcı Olarak Sil';

  @override
  String get greetingMorning => 'Günaydın';

  @override
  String get greetingAfternoon => 'İyi Günler';

  @override
  String get greetingEvening => 'İyi Akşamlar';

  @override
  String get searchHint => 'Ne aramak istersin?';

  @override
  String get overview => 'Genel Bakış';

  @override
  String get taskSingle => 'Görev';

  @override
  String get tasksToCompleteToday => 'Bugün tamamlanması gereken';

  @override
  String get activeReminder => 'Aktif Hatırlatıcı';

  @override
  String get todoList => 'Yapılacak Liste';

  @override
  String get recentNotes => 'Son Notlar';

  @override
  String get seeAll => 'Tümü';

  @override
  String get noNotesYet => 'Henüz not yok';

  @override
  String get upcoming => 'Yakın Zamanda';

  @override
  String get noPendingTasks => 'Bekleyen göreviniz bulunmuyor 🎉';

  @override
  String get priorityLow => 'Düşük';

  @override
  String get priorityMedium => 'Orta';

  @override
  String get priorityHigh => 'Yüksek';

  @override
  String get priorityCritical => 'Kritik';

  @override
  String get notSpecified => 'Belirtilmedi';

  @override
  String get assigned => 'Atandı';

  @override
  String get recentTodos => 'Son Yapılacaklar';

  @override
  String get noActiveTodos => 'Aktif yapılacak listesi yok';

  @override
  String stepsCompleted(int completed, int total) {
    return '$completed / $total adım tamamlandı';
  }

  @override
  String get noteSingle => 'Not';

  @override
  String get completedSingle => 'Tamamlanan';

  @override
  String get todoSingle => 'Yapılacak';

  @override
  String get reminderSingle => 'Hatırlatıcı';

  @override
  String get totalNotes => 'Toplam Not';

  @override
  String get totalTasks => 'Toplam Görev';

  @override
  String get editProfile => 'Profili Düzenle';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Aydınlık';

  @override
  String get themeDark => 'Karanlık';

  @override
  String get appearanceSelection => 'Görünüm Seçimi';

  @override
  String get fontSelection => 'Yazı Tipi Seçimi';

  @override
  String get cancel => 'İptal';

  @override
  String get deleteAccountTitle => 'Hesabı Sil';

  @override
  String get deleteAccountDesc =>
      'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinir.';

  @override
  String get yesDeleteAccount => 'Evet, Hesabımı Sil';

  @override
  String get all => 'Tümü';

  @override
  String get pinned => 'Sabitlenmiş';

  @override
  String get favorites => 'Favoriler';

  @override
  String get noPinnedNotes => 'Sabitlenmiş not bulunamadı';

  @override
  String get pinnedNotesDesc =>
      'Önemli notlarınızı sabitleyerek burada görebilirsiniz.';

  @override
  String get noFavoriteNotes => 'Favori not bulunamadı';

  @override
  String get favoriteNotesDesc =>
      'Beğendiğiniz notları favorilere ekleyerek burada görebilirsiniz.';

  @override
  String get noArchivedNotes => 'Arşivlenmiş not yok';

  @override
  String get archivedNotesDesc =>
      'Henüz arşive kaldırılmış bir not bulunmuyor.';

  @override
  String get createFirstNote => 'İlk notunuzu oluşturun';

  @override
  String get createNote => 'Not Oluştur';

  @override
  String get noteArchived => 'Not arşivlendi.';

  @override
  String get save => 'Kaydet';

  @override
  String get titleHint => 'Başlık';

  @override
  String get startWritingNote => 'Notunuzu yazmaya başlayın...';

  @override
  String get addTag => 'Etiket Ekle';

  @override
  String get attachments => 'Ekler';

  @override
  String get addImage => 'Resim Ekle';

  @override
  String get addFile => 'Dosya Ekle';

  @override
  String get voiceInputComingSoon => 'Sesli giriş yakında eklenecek';

  @override
  String get voiceRecord => 'Ses Kaydı';

  @override
  String get templates => 'Şablonlar';

  @override
  String get fileCannotOpen => 'Dosya açılamadı';

  @override
  String get tagName => 'Etiket adı';

  @override
  String get add => 'Ekle';

  @override
  String get untitledNote => 'İsimsiz Not';

  @override
  String get imageSizeError => 'Fotoğraf boyutu 5 MB\'dan küçük olmalıdır.';

  @override
  String get pdfSizeError => 'PDF boyutu 5 MB\'dan küçük olmalıdır.';

  @override
  String get fileUploadFailed => 'Dosya yüklenemedi';

  @override
  String get chooseTemplate => 'Şablon Seç';

  @override
  String get meetingNote => 'Toplantı Notu';

  @override
  String get shoppingList => 'Alışveriş Listesi';

  @override
  String get projectPlan => 'Proje Planı';

  @override
  String get tasksLabel => 'Görevler';

  @override
  String get taskDetail => 'Görev Detayı';

  @override
  String get taskTitle => 'Görev Başlığı';

  @override
  String get pleaseEnterTaskTitle => 'Lütfen bir görev başlığı girin.';

  @override
  String get subtasks => 'Alt Görevler';

  @override
  String get addNewSubtask => 'Yeni alt görev ekle...';

  @override
  String get assignUser => 'Görevli Ata';

  @override
  String get assignedTo => 'Görevli: Atandı';

  @override
  String get pending => 'Bekleyen';

  @override
  String get inProgress => 'Devam Eden';

  @override
  String get taskArchived => 'Görev arşivlendi.';

  @override
  String get taskNotFound => 'Görev bulunamadı';

  @override
  String get assignToNobody => 'Kimseye Atama';

  @override
  String get assignUserOptional => 'Kişi Ata (Opsiyonel)';

  @override
  String get selectPerson => 'Kişi Seçin';

  @override
  String get priorityLabel => 'Öncelik';

  @override
  String get todosLabel => 'Yapılacaklar';

  @override
  String get todosListEmpty => 'Yapılacaklar listeniz boş';

  @override
  String get clickPlusToAddList =>
      'Yeni bir liste eklemek için + butonuna tıklayın.';

  @override
  String get newList => 'Yeni Liste';

  @override
  String get listNameExample => 'Liste Adı (Örn: Alışveriş)';

  @override
  String get pleaseEnterTitle => 'Lütfen bir başlık girin.';

  @override
  String get itemsEmpty => 'Maddeler boş...';

  @override
  String get addNewItem => 'Yeni madde ekle...';

  @override
  String get completedItemsTab => 'Tamamlananlar';

  @override
  String get deleteListConfirm =>
      'Bu listeyi kalıcı olarak silmek istediğinize emin misiniz?';

  @override
  String get deleteList => 'Listeyi Sil';

  @override
  String get listArchived => 'Liste arşivlendi.';

  @override
  String get listNotFound => 'Liste bulunamadı';

  @override
  String get shopping => 'Alışveriş';

  @override
  String get details => 'Detaylar';

  @override
  String get checklist => 'Checklist';

  @override
  String get boardView => 'Pano Görünümü';

  @override
  String get listView => 'Liste Görünümü';

  @override
  String get reminder => 'Hatırlatıcı';

  @override
  String get createReminder => 'Hatırlatıcı Oluştur';

  @override
  String get reminderName => 'Hatırlatıcı adı';

  @override
  String get reminderArchived => 'Hatırlatıcı arşivlendi.';

  @override
  String get reminderSavedNotify =>
      'Hatırlatıcı kaydedildi. İlgili kişiye bildirim gönderiliyor...';

  @override
  String get noRemindersYet => 'Henüz hatırlatıcınız yok';

  @override
  String get createFirstReminder => 'İlk hatırlatıcınızı oluşturun';

  @override
  String get selectEndDate => 'Bitiş Tarihi Seç';

  @override
  String get dateLabel => 'Tarih:';

  @override
  String get timeLabel => 'Saat:';

  @override
  String get repeat => 'Tekrar';

  @override
  String get noRepeat => 'Tekrar Yok';

  @override
  String get daily => 'Günlük';

  @override
  String get weekly => 'Haftalık';

  @override
  String get colorSelection => 'Renk Seçimi:';

  @override
  String get notification => 'Bildirim';

  @override
  String get filesAndImages => 'Dosya ve Resimler';

  @override
  String get noAttachmentsYet => 'Henüz ek bulunmuyor';

  @override
  String get addDetailedDescription => 'Detaylı açıklama ekleyin...';

  @override
  String get delete => 'Sil';

  @override
  String get clearSelection => 'Seçimi Temizle';

  @override
  String get create => 'Oluştur';

  @override
  String get me => 'Ben';

  @override
  String get legalDocuments => 'Yasal Belgeler';

  @override
  String get termsOfUse => 'Kullanım Koşulları';

  @override
  String get accountDeletionPolicy => 'Hesap Silme Politikası';

  @override
  String get kvkkText => 'KVKK Aydınlatma Metni';

  @override
  String get appStorePrivacy => 'App Store Privacy Uyum Metni';

  @override
  String get googlePlayData => 'Google Play Veri Güvenliği Uyum Metni';

  @override
  String get personalWorkspace => 'Kişisel';

  @override
  String get sharedWorkspace => 'Ortak alan';

  @override
  String get statusLabel => 'Durum';

  @override
  String get priorityLevel => 'Önem derecesi';

  @override
  String get repeatNone => 'Tekrar yok';

  @override
  String get repeatDaily => 'Günlük';

  @override
  String get repeatWeekly => 'Haftalık';

  @override
  String get repeatMonthly => 'Aylık';

  @override
  String get dateAndTime => 'Tarih ve Saat';

  @override
  String get calendarAndPlanning => 'Takvim & Planlama';

  @override
  String get noPlansOnDate => 'Bu tarihte plan yok';

  @override
  String get noArchiveWarning => 'Arşiv yok';

  @override
  String get archiveEmptyWarning => 'Arşiv boş';

  @override
  String get searchAll => 'Tümü';

  @override
  String get searchNotes => 'Notlar';

  @override
  String get searchTasks => 'Görevler';

  @override
  String get searchTodos => 'Yapılacaklar';

  @override
  String get workspaceEmpty => 'Ortak alan bulunamadı';

  @override
  String get subscriptionTitle => 'Abonelik';

  @override
  String get documentNotFound => 'Belge bulunamadı.';

  @override
  String get today => 'Bugün';

  @override
  String get basicPlan => 'Basic Plan';

  @override
  String get proPlan => 'Professional';

  @override
  String get enterprisePlan => 'Enterprise';

  @override
  String get unlimitedNotes => 'Sınırsız Not ve Görev';

  @override
  String get storage100mb => '100 MB Depolama Alanı';

  @override
  String get storage1gb => '1 GB Depolama Alanı';

  @override
  String get storage5gb => '5 GB Depolama Alanı';

  @override
  String get teamCapacity3 => '3 Kişilik Ekip Kapasitesi';

  @override
  String get teamCapacity10 => '10 Kişilik Ekip Kapasitesi';

  @override
  String get teamCapacity50 => '50 Kişilik Ekip Kapasitesi';

  @override
  String get workspace1 => '1 Ortak Çalışma Alanı';

  @override
  String get workspace2 => '2 Ortak Çalışma Alanı';

  @override
  String get advancedReminders => 'Gelişmiş Hatırlatıcılar';

  @override
  String get prioritySupport => 'Öncelikli Destek';

  @override
  String get selectPlan => 'Seç';

  @override
  String get subscriptionActivated => 'Abonelik başarıyla aktifleştirildi! 🥳';

  @override
  String get subscriptionCancelled =>
      'Satın alma işlemi iptal edildi veya tamamlanamadı.';

  @override
  String get subscriptionSubtitle => 'Sınırları Kaldırın 🚀';

  @override
  String get subscriptionDesc =>
      'Size ve ekibinize en uygun planı seçerek Notiva deneyimini zirveye taşıyın.';

  @override
  String get teamWork => 'Ekip Çalışması';

  @override
  String get teamWorkDesc =>
      'Bir ekip kurun veya davet koduyla mevcut bir ekibe katılarak projelerinizi birlikte yönetin.';

  @override
  String get createNewTeam => 'Yeni Ekip Kur';

  @override
  String get joinWithInviteCode => 'Davet Koduyla Katıl';

  @override
  String get myTeams => 'Ekiplerim';

  @override
  String membersCount(int count) {
    return '$count üye';
  }

  @override
  String get contactsLabel => 'Kişiler';

  @override
  String get noResultsFound => 'Sonuç bulunamadı';

  @override
  String get tryDifferentKeywords => 'Farklı anahtar kelimeler deneyin';

  @override
  String get searchTitle => 'Ara';

  @override
  String get createReminderTitle => 'Hatırlatıcı Oluştur';

  @override
  String get titleLabel => 'Başlık';

  @override
  String get repeatLabel => 'Tekrar';

  @override
  String get notificationLabel => 'Bildirim';

  @override
  String get activityStreamTitle => 'Aktivite Akışı';

  @override
  String get taskUpdatedActivity => 'görev güncelledi';

  @override
  String get taskAddedActivity => 'görev ekledi';

  @override
  String get reminderAddedActivity => 'hatırlatıcı ekledi';

  @override
  String get noteAddedActivity => 'not ekledi';

  @override
  String get noteUpdatedActivity => 'not güncelledi';

  @override
  String get notInAnyTeam => 'Henüz bir ekibe dahil değilsiniz.';

  @override
  String get joinTeam => 'Ekibe Katıl';

  @override
  String get joinTeamDesc =>
      'Ekip yöneticisinden aldığınız 6 haneli davet kodunu girin.';

  @override
  String get inviteCode => 'Davet Kodu';

  @override
  String get join => 'Katıl';

  @override
  String get teamJoinedSuccess => 'Ekibe başarıyla katıldınız! 🎉';

  @override
  String get alreadyTeamMember => 'Zaten bu ekibin üyesisiniz.';

  @override
  String get invalidInviteCode =>
      'Geçersiz davet kodu. Lütfen tekrar kontrol edin.';

  @override
  String get noPlansForDate => 'Bu tarihte plan yok.';

  @override
  String get task => 'Görev';

  @override
  String get error => 'Hata';

  @override
  String get reminderLabel => 'Hatırlatıcı';

  @override
  String get unarchiveTooltip => 'Arşivden Çıkar';

  @override
  String get itemUnarchived => 'Öğe arşivden çıkarıldı.';

  @override
  String get manageProductivity => 'Üretkenliğinizi yönetin';

  @override
  String get loginTitle => 'Giriş Yap';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get emailHint => 'ornek@email.com';

  @override
  String get emailRequired => 'E-posta gerekli';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get passwordRequired => 'Şifre gerekli';

  @override
  String get forgotPassword => 'Şifremi Unuttum';

  @override
  String get orLabel => 'VEYA';

  @override
  String get loginWithGoogle => 'Google ile Giriş Yap';

  @override
  String get noAccount => 'Hesabınız yok mu? ';

  @override
  String get createAccount => 'Hesap Oluştur';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get welcomeToNotiva => 'Notiva\'ya hoş geldiniz';

  @override
  String get fullNameLabel => 'Ad Soyad';

  @override
  String get fullNameHint => 'Adınızı girin';

  @override
  String get nameRequired => 'Ad gerekli';

  @override
  String get passwordLengthHint => 'En az 6 karakter';

  @override
  String get passwordLength => 'En az 6 karakter olmalı';

  @override
  String get confirmPasswordLabel => 'Şifre Tekrar';

  @override
  String get confirmPasswordHint => 'Şifrenizi tekrar girin';

  @override
  String get confirmPasswordRequired => 'Şifre tekrarı gerekli';

  @override
  String get registerLabel => 'Kayıt Ol';

  @override
  String get alreadyHaveAccount => 'Zaten hesabınız var mı? ';

  @override
  String get completeProfile => 'Profilini Tamamla';

  @override
  String get welcomeHeadline => 'Hoş Geldiniz!';

  @override
  String get completeProfileDesc =>
      'Devam etmeden önce lütfen bilgilerinizi tamamlayın.';

  @override
  String get photoSizeLimit => 'Profil fotoğrafı 5 MB\'dan küçük olmalıdır.';

  @override
  String get saveAndStart => 'Kaydet ve Başla';

  @override
  String get phoneLabel => 'Telefon Numarası';

  @override
  String get phoneRequired => 'Telefon gerekli';

  @override
  String get resetPasswordTitle => 'Şifre Sıfırlama';

  @override
  String get resetPasswordDesc =>
      'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.';

  @override
  String get sendLink => 'Bağlantı Gönder';

  @override
  String get linkSent => 'Bağlantı Gönderildi!';

  @override
  String get linkSentDesc =>
      'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.';

  @override
  String get backToLogin => 'Giriş Ekranına Dön';

  @override
  String get workspacesTitle => 'Çalışma Alanları';

  @override
  String get personalWorkspaceCannotBeManaged => 'Kişisel alan yönetilemez';

  @override
  String get teamManagement => 'Ekip Yönetimi';

  @override
  String get inviteCodeLabel => 'Davet Kodu';

  @override
  String teamMembersCount(int count) {
    return 'Ekip Üyeleri ($count)';
  }

  @override
  String get nameLabel => 'İsim';

  @override
  String get nonePermission => 'Yok';

  @override
  String get readPermission => 'Görme';

  @override
  String get writePermission => 'Düzenleme';

  @override
  String get leaveTeam => 'Ekipten Ayrıl';

  @override
  String get deleteAndDisbandTeam => 'Ekibi Sil ve Dağıt';

  @override
  String get managePermissions => 'Yetkileri Yönet';

  @override
  String get savePermissions => 'Kaydet';

  @override
  String get permissions => 'Yetkiler';

  @override
  String get adminRole => 'Yönetici';

  @override
  String get unknownUser => 'Bilinmeyen Kullanıcı';

  @override
  String get removeMemberTitle => 'Üyeyi Çıkar';

  @override
  String get removeMemberDesc =>
      'Bu üyeyi ekipten çıkarmak istediğinize emin misiniz?';

  @override
  String get remove => 'Çıkar';

  @override
  String get leaveTeamTitle => 'Ekipten Ayrıl';

  @override
  String get leaveTeamDesc =>
      'Bu ekipten ayrılmak istediğinize emin misiniz? Ekip yöneticisi sizi tekrar davet etmedikçe geri dönemezsiniz.';

  @override
  String get deleteTeamTitle => 'Ekibi Sil';

  @override
  String get deleteTeamDesc =>
      'Bu ekibi silerseniz içindeki tüm veriler (notlar, görevler) silinecek. Emin misiniz?';

  @override
  String get deleteAction => 'Sil';

  @override
  String get inviteCodeCopied => 'Davet kodu kopyalandı!';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get errorMsg => 'Hata';
}
