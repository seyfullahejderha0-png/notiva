import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// No description provided for @home.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get home;

  /// No description provided for @modules.
  ///
  /// In tr, this message translates to:
  /// **'Modüller'**
  String get modules;

  /// No description provided for @profile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @notes.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get notes;

  /// No description provided for @tasks.
  ///
  /// In tr, this message translates to:
  /// **'Görevlerim'**
  String get tasks;

  /// No description provided for @reminders.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcılar'**
  String get reminders;

  /// No description provided for @workspace.
  ///
  /// In tr, this message translates to:
  /// **'Ortak Alan (Ekipler)'**
  String get workspace;

  /// No description provided for @todos.
  ///
  /// In tr, this message translates to:
  /// **'Yapılacaklar (To-Do) Listesi'**
  String get todos;

  /// No description provided for @archive.
  ///
  /// In tr, this message translates to:
  /// **'Arşiv'**
  String get archive;

  /// No description provided for @appSettings.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Ayarları'**
  String get appSettings;

  /// No description provided for @subscription.
  ///
  /// In tr, this message translates to:
  /// **'Abonelik ve Planlar'**
  String get subscription;

  /// No description provided for @appearance.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get appearance;

  /// No description provided for @font.
  ///
  /// In tr, this message translates to:
  /// **'Yazı Tipi'**
  String get font;

  /// No description provided for @notificationSettings.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Ayarları'**
  String get notificationSettings;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @supportAndLegal.
  ///
  /// In tr, this message translates to:
  /// **'Destek ve Yasal'**
  String get supportAndLegal;

  /// No description provided for @contactUs.
  ///
  /// In tr, this message translates to:
  /// **'Bize Ulaşın / Destek'**
  String get contactUs;

  /// No description provided for @rateApp.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı Puanla'**
  String get rateApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası ve Şartlar'**
  String get privacyPolicy;

  /// No description provided for @accountManagement.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Yönetimi'**
  String get accountManagement;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Oturumu Kapat'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabımı Kalıcı Olarak Sil'**
  String get deleteAccount;

  /// No description provided for @greetingMorning.
  ///
  /// In tr, this message translates to:
  /// **'Günaydın'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In tr, this message translates to:
  /// **'İyi Günler'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In tr, this message translates to:
  /// **'İyi Akşamlar'**
  String get greetingEvening;

  /// No description provided for @searchHint.
  ///
  /// In tr, this message translates to:
  /// **'Ne aramak istersin?'**
  String get searchHint;

  /// No description provided for @overview.
  ///
  /// In tr, this message translates to:
  /// **'Genel Bakış'**
  String get overview;

  /// No description provided for @taskSingle.
  ///
  /// In tr, this message translates to:
  /// **'Görev'**
  String get taskSingle;

  /// No description provided for @tasksToCompleteToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün tamamlanması gereken'**
  String get tasksToCompleteToday;

  /// No description provided for @activeReminder.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Hatırlatıcı'**
  String get activeReminder;

  /// No description provided for @todoList.
  ///
  /// In tr, this message translates to:
  /// **'Yapılacak Liste'**
  String get todoList;

  /// No description provided for @recentNotes.
  ///
  /// In tr, this message translates to:
  /// **'Son Notlar'**
  String get recentNotes;

  /// No description provided for @seeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get seeAll;

  /// No description provided for @noNotesYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz not yok'**
  String get noNotesYet;

  /// No description provided for @upcoming.
  ///
  /// In tr, this message translates to:
  /// **'Yakın Zamanda'**
  String get upcoming;

  /// No description provided for @noPendingTasks.
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen göreviniz bulunmuyor 🎉'**
  String get noPendingTasks;

  /// No description provided for @priorityLow.
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get priorityHigh;

  /// No description provided for @priorityCritical.
  ///
  /// In tr, this message translates to:
  /// **'Kritik'**
  String get priorityCritical;

  /// No description provided for @notSpecified.
  ///
  /// In tr, this message translates to:
  /// **'Belirtilmedi'**
  String get notSpecified;

  /// No description provided for @assigned.
  ///
  /// In tr, this message translates to:
  /// **'Atandı'**
  String get assigned;

  /// No description provided for @recentTodos.
  ///
  /// In tr, this message translates to:
  /// **'Son Yapılacaklar'**
  String get recentTodos;

  /// No description provided for @noActiveTodos.
  ///
  /// In tr, this message translates to:
  /// **'Aktif yapılacak listesi yok'**
  String get noActiveTodos;

  /// No description provided for @stepsCompleted.
  ///
  /// In tr, this message translates to:
  /// **'{completed} / {total} adım tamamlandı'**
  String stepsCompleted(int completed, int total);

  /// No description provided for @noteSingle.
  ///
  /// In tr, this message translates to:
  /// **'Not'**
  String get noteSingle;

  /// No description provided for @completedSingle.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan'**
  String get completedSingle;

  /// No description provided for @todoSingle.
  ///
  /// In tr, this message translates to:
  /// **'Yapılacak'**
  String get todoSingle;

  /// No description provided for @reminderSingle.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get reminderSingle;

  /// No description provided for @totalNotes.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Not'**
  String get totalNotes;

  /// No description provided for @totalTasks.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Görev'**
  String get totalTasks;

  /// No description provided for @editProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profili Düzenle'**
  String get editProfile;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Aydınlık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Karanlık'**
  String get themeDark;

  /// No description provided for @appearanceSelection.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm Seçimi'**
  String get appearanceSelection;

  /// No description provided for @fontSelection.
  ///
  /// In tr, this message translates to:
  /// **'Yazı Tipi Seçimi'**
  String get fontSelection;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı Sil'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountDesc.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinir.'**
  String get deleteAccountDesc;

  /// No description provided for @yesDeleteAccount.
  ///
  /// In tr, this message translates to:
  /// **'Evet, Hesabımı Sil'**
  String get yesDeleteAccount;

  /// No description provided for @all.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get all;

  /// No description provided for @pinned.
  ///
  /// In tr, this message translates to:
  /// **'Sabitlenmiş'**
  String get pinned;

  /// No description provided for @favorites.
  ///
  /// In tr, this message translates to:
  /// **'Favoriler'**
  String get favorites;

  /// No description provided for @noPinnedNotes.
  ///
  /// In tr, this message translates to:
  /// **'Sabitlenmiş not bulunamadı'**
  String get noPinnedNotes;

  /// No description provided for @pinnedNotesDesc.
  ///
  /// In tr, this message translates to:
  /// **'Önemli notlarınızı sabitleyerek burada görebilirsiniz.'**
  String get pinnedNotesDesc;

  /// No description provided for @noFavoriteNotes.
  ///
  /// In tr, this message translates to:
  /// **'Favori not bulunamadı'**
  String get noFavoriteNotes;

  /// No description provided for @favoriteNotesDesc.
  ///
  /// In tr, this message translates to:
  /// **'Beğendiğiniz notları favorilere ekleyerek burada görebilirsiniz.'**
  String get favoriteNotesDesc;

  /// No description provided for @noArchivedNotes.
  ///
  /// In tr, this message translates to:
  /// **'Arşivlenmiş not yok'**
  String get noArchivedNotes;

  /// No description provided for @archivedNotesDesc.
  ///
  /// In tr, this message translates to:
  /// **'Henüz arşive kaldırılmış bir not bulunmuyor.'**
  String get archivedNotesDesc;

  /// No description provided for @createFirstNote.
  ///
  /// In tr, this message translates to:
  /// **'İlk notunuzu oluşturun'**
  String get createFirstNote;

  /// No description provided for @createNote.
  ///
  /// In tr, this message translates to:
  /// **'Not Oluştur'**
  String get createNote;

  /// No description provided for @noteArchived.
  ///
  /// In tr, this message translates to:
  /// **'Not arşivlendi.'**
  String get noteArchived;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @titleHint.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get titleHint;

  /// No description provided for @startWritingNote.
  ///
  /// In tr, this message translates to:
  /// **'Notunuzu yazmaya başlayın...'**
  String get startWritingNote;

  /// No description provided for @addTag.
  ///
  /// In tr, this message translates to:
  /// **'Etiket Ekle'**
  String get addTag;

  /// No description provided for @attachments.
  ///
  /// In tr, this message translates to:
  /// **'Ekler'**
  String get attachments;

  /// No description provided for @addImage.
  ///
  /// In tr, this message translates to:
  /// **'Resim Ekle'**
  String get addImage;

  /// No description provided for @addFile.
  ///
  /// In tr, this message translates to:
  /// **'Dosya Ekle'**
  String get addFile;

  /// No description provided for @voiceInputComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Sesli giriş yakında eklenecek'**
  String get voiceInputComingSoon;

  /// No description provided for @voiceRecord.
  ///
  /// In tr, this message translates to:
  /// **'Ses Kaydı'**
  String get voiceRecord;

  /// No description provided for @templates.
  ///
  /// In tr, this message translates to:
  /// **'Şablonlar'**
  String get templates;

  /// No description provided for @fileCannotOpen.
  ///
  /// In tr, this message translates to:
  /// **'Dosya açılamadı'**
  String get fileCannotOpen;

  /// No description provided for @tagName.
  ///
  /// In tr, this message translates to:
  /// **'Etiket adı'**
  String get tagName;

  /// No description provided for @add.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get add;

  /// No description provided for @untitledNote.
  ///
  /// In tr, this message translates to:
  /// **'İsimsiz Not'**
  String get untitledNote;

  /// No description provided for @imageSizeError.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf boyutu 5 MB\'dan küçük olmalıdır.'**
  String get imageSizeError;

  /// No description provided for @pdfSizeError.
  ///
  /// In tr, this message translates to:
  /// **'PDF boyutu 5 MB\'dan küçük olmalıdır.'**
  String get pdfSizeError;

  /// No description provided for @fileUploadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Dosya yüklenemedi'**
  String get fileUploadFailed;

  /// No description provided for @chooseTemplate.
  ///
  /// In tr, this message translates to:
  /// **'Şablon Seç'**
  String get chooseTemplate;

  /// No description provided for @meetingNote.
  ///
  /// In tr, this message translates to:
  /// **'Toplantı Notu'**
  String get meetingNote;

  /// No description provided for @shoppingList.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş Listesi'**
  String get shoppingList;

  /// No description provided for @projectPlan.
  ///
  /// In tr, this message translates to:
  /// **'Proje Planı'**
  String get projectPlan;

  /// No description provided for @tasksLabel.
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get tasksLabel;

  /// No description provided for @taskDetail.
  ///
  /// In tr, this message translates to:
  /// **'Görev Detayı'**
  String get taskDetail;

  /// No description provided for @taskTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görev Başlığı'**
  String get taskTitle;

  /// No description provided for @pleaseEnterTaskTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir görev başlığı girin.'**
  String get pleaseEnterTaskTitle;

  /// No description provided for @subtasks.
  ///
  /// In tr, this message translates to:
  /// **'Alt Görevler'**
  String get subtasks;

  /// No description provided for @addNewSubtask.
  ///
  /// In tr, this message translates to:
  /// **'Yeni alt görev ekle...'**
  String get addNewSubtask;

  /// No description provided for @assignUser.
  ///
  /// In tr, this message translates to:
  /// **'Görevli Ata'**
  String get assignUser;

  /// No description provided for @assignedTo.
  ///
  /// In tr, this message translates to:
  /// **'Görevli: Atandı'**
  String get assignedTo;

  /// No description provided for @pending.
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In tr, this message translates to:
  /// **'Devam Eden'**
  String get inProgress;

  /// No description provided for @taskArchived.
  ///
  /// In tr, this message translates to:
  /// **'Görev arşivlendi.'**
  String get taskArchived;

  /// No description provided for @taskNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Görev bulunamadı'**
  String get taskNotFound;

  /// No description provided for @assignToNobody.
  ///
  /// In tr, this message translates to:
  /// **'Kimseye Atama'**
  String get assignToNobody;

  /// No description provided for @assignUserOptional.
  ///
  /// In tr, this message translates to:
  /// **'Kişi Ata (Opsiyonel)'**
  String get assignUserOptional;

  /// No description provided for @selectPerson.
  ///
  /// In tr, this message translates to:
  /// **'Kişi Seçin'**
  String get selectPerson;

  /// No description provided for @priorityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Öncelik'**
  String get priorityLabel;

  /// No description provided for @todosLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yapılacaklar'**
  String get todosLabel;

  /// No description provided for @todosListEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Yapılacaklar listeniz boş'**
  String get todosListEmpty;

  /// No description provided for @clickPlusToAddList.
  ///
  /// In tr, this message translates to:
  /// **'Yeni bir liste eklemek için + butonuna tıklayın.'**
  String get clickPlusToAddList;

  /// No description provided for @newList.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Liste'**
  String get newList;

  /// No description provided for @listNameExample.
  ///
  /// In tr, this message translates to:
  /// **'Liste Adı (Örn: Alışveriş)'**
  String get listNameExample;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir başlık girin.'**
  String get pleaseEnterTitle;

  /// No description provided for @itemsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Maddeler boş...'**
  String get itemsEmpty;

  /// No description provided for @addNewItem.
  ///
  /// In tr, this message translates to:
  /// **'Yeni madde ekle...'**
  String get addNewItem;

  /// No description provided for @completedItemsTab.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlananlar'**
  String get completedItemsTab;

  /// No description provided for @deleteListConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Bu listeyi kalıcı olarak silmek istediğinize emin misiniz?'**
  String get deleteListConfirm;

  /// No description provided for @deleteList.
  ///
  /// In tr, this message translates to:
  /// **'Listeyi Sil'**
  String get deleteList;

  /// No description provided for @listArchived.
  ///
  /// In tr, this message translates to:
  /// **'Liste arşivlendi.'**
  String get listArchived;

  /// No description provided for @listNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Liste bulunamadı'**
  String get listNotFound;

  /// No description provided for @shopping.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş'**
  String get shopping;

  /// No description provided for @details.
  ///
  /// In tr, this message translates to:
  /// **'Detaylar'**
  String get details;

  /// No description provided for @checklist.
  ///
  /// In tr, this message translates to:
  /// **'Checklist'**
  String get checklist;

  /// No description provided for @boardView.
  ///
  /// In tr, this message translates to:
  /// **'Pano Görünümü'**
  String get boardView;

  /// No description provided for @listView.
  ///
  /// In tr, this message translates to:
  /// **'Liste Görünümü'**
  String get listView;

  /// No description provided for @reminder.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get reminder;

  /// No description provided for @createReminder.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı Oluştur'**
  String get createReminder;

  /// No description provided for @reminderName.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı adı'**
  String get reminderName;

  /// No description provided for @reminderArchived.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı arşivlendi.'**
  String get reminderArchived;

  /// No description provided for @reminderSavedNotify.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı kaydedildi. İlgili kişiye bildirim gönderiliyor...'**
  String get reminderSavedNotify;

  /// No description provided for @noRemindersYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz hatırlatıcınız yok'**
  String get noRemindersYet;

  /// No description provided for @createFirstReminder.
  ///
  /// In tr, this message translates to:
  /// **'İlk hatırlatıcınızı oluşturun'**
  String get createFirstReminder;

  /// No description provided for @selectEndDate.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş Tarihi Seç'**
  String get selectEndDate;

  /// No description provided for @dateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tarih:'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Saat:'**
  String get timeLabel;

  /// No description provided for @repeat.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar'**
  String get repeat;

  /// No description provided for @noRepeat.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Yok'**
  String get noRepeat;

  /// No description provided for @daily.
  ///
  /// In tr, this message translates to:
  /// **'Günlük'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get weekly;

  /// No description provided for @colorSelection.
  ///
  /// In tr, this message translates to:
  /// **'Renk Seçimi:'**
  String get colorSelection;

  /// No description provided for @notification.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim'**
  String get notification;

  /// No description provided for @filesAndImages.
  ///
  /// In tr, this message translates to:
  /// **'Dosya ve Resimler'**
  String get filesAndImages;

  /// No description provided for @noAttachmentsYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz ek bulunmuyor'**
  String get noAttachmentsYet;

  /// No description provided for @addDetailedDescription.
  ///
  /// In tr, this message translates to:
  /// **'Detaylı açıklama ekleyin...'**
  String get addDetailedDescription;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @clearSelection.
  ///
  /// In tr, this message translates to:
  /// **'Seçimi Temizle'**
  String get clearSelection;

  /// No description provided for @create.
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get create;

  /// No description provided for @me.
  ///
  /// In tr, this message translates to:
  /// **'Ben'**
  String get me;

  /// No description provided for @legalDocuments.
  ///
  /// In tr, this message translates to:
  /// **'Yasal Belgeler'**
  String get legalDocuments;

  /// No description provided for @termsOfUse.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları'**
  String get termsOfUse;

  /// No description provided for @accountDeletionPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Silme Politikası'**
  String get accountDeletionPolicy;

  /// No description provided for @kvkkText.
  ///
  /// In tr, this message translates to:
  /// **'KVKK Aydınlatma Metni'**
  String get kvkkText;

  /// No description provided for @appStorePrivacy.
  ///
  /// In tr, this message translates to:
  /// **'App Store Privacy Uyum Metni'**
  String get appStorePrivacy;

  /// No description provided for @googlePlayData.
  ///
  /// In tr, this message translates to:
  /// **'Google Play Veri Güvenliği Uyum Metni'**
  String get googlePlayData;

  /// No description provided for @personalWorkspace.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel'**
  String get personalWorkspace;

  /// No description provided for @sharedWorkspace.
  ///
  /// In tr, this message translates to:
  /// **'Ortak alan'**
  String get sharedWorkspace;

  /// No description provided for @statusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get statusLabel;

  /// No description provided for @priorityLevel.
  ///
  /// In tr, this message translates to:
  /// **'Önem derecesi'**
  String get priorityLevel;

  /// No description provided for @repeatNone.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar yok'**
  String get repeatNone;

  /// No description provided for @repeatDaily.
  ///
  /// In tr, this message translates to:
  /// **'Günlük'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get repeatMonthly;

  /// No description provided for @dateAndTime.
  ///
  /// In tr, this message translates to:
  /// **'Tarih ve Saat'**
  String get dateAndTime;

  /// No description provided for @calendarAndPlanning.
  ///
  /// In tr, this message translates to:
  /// **'Takvim & Planlama'**
  String get calendarAndPlanning;

  /// No description provided for @noPlansOnDate.
  ///
  /// In tr, this message translates to:
  /// **'Bu tarihte plan yok'**
  String get noPlansOnDate;

  /// No description provided for @noArchiveWarning.
  ///
  /// In tr, this message translates to:
  /// **'Arşiv yok'**
  String get noArchiveWarning;

  /// No description provided for @archiveEmptyWarning.
  ///
  /// In tr, this message translates to:
  /// **'Arşiv boş'**
  String get archiveEmptyWarning;

  /// No description provided for @searchAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get searchAll;

  /// No description provided for @searchNotes.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get searchNotes;

  /// No description provided for @searchTasks.
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get searchTasks;

  /// No description provided for @searchTodos.
  ///
  /// In tr, this message translates to:
  /// **'Yapılacaklar'**
  String get searchTodos;

  /// No description provided for @workspaceEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Ortak alan bulunamadı'**
  String get workspaceEmpty;

  /// No description provided for @subscriptionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Abonelik'**
  String get subscriptionTitle;

  /// No description provided for @documentNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Belge bulunamadı.'**
  String get documentNotFound;

  /// No description provided for @today.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get today;

  /// No description provided for @basicPlan.
  ///
  /// In tr, this message translates to:
  /// **'Basic Plan'**
  String get basicPlan;

  /// No description provided for @proPlan.
  ///
  /// In tr, this message translates to:
  /// **'Professional'**
  String get proPlan;

  /// No description provided for @enterprisePlan.
  ///
  /// In tr, this message translates to:
  /// **'Enterprise'**
  String get enterprisePlan;

  /// No description provided for @unlimitedNotes.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız Not ve Görev'**
  String get unlimitedNotes;

  /// No description provided for @storage100mb.
  ///
  /// In tr, this message translates to:
  /// **'100 MB Depolama Alanı'**
  String get storage100mb;

  /// No description provided for @storage1gb.
  ///
  /// In tr, this message translates to:
  /// **'1 GB Depolama Alanı'**
  String get storage1gb;

  /// No description provided for @storage5gb.
  ///
  /// In tr, this message translates to:
  /// **'5 GB Depolama Alanı'**
  String get storage5gb;

  /// No description provided for @teamCapacity3.
  ///
  /// In tr, this message translates to:
  /// **'3 Kişilik Ekip Kapasitesi'**
  String get teamCapacity3;

  /// No description provided for @teamCapacity10.
  ///
  /// In tr, this message translates to:
  /// **'10 Kişilik Ekip Kapasitesi'**
  String get teamCapacity10;

  /// No description provided for @teamCapacity50.
  ///
  /// In tr, this message translates to:
  /// **'50 Kişilik Ekip Kapasitesi'**
  String get teamCapacity50;

  /// No description provided for @workspace1.
  ///
  /// In tr, this message translates to:
  /// **'1 Ortak Çalışma Alanı'**
  String get workspace1;

  /// No description provided for @workspace2.
  ///
  /// In tr, this message translates to:
  /// **'2 Ortak Çalışma Alanı'**
  String get workspace2;

  /// No description provided for @advancedReminders.
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş Hatırlatıcılar'**
  String get advancedReminders;

  /// No description provided for @prioritySupport.
  ///
  /// In tr, this message translates to:
  /// **'Öncelikli Destek'**
  String get prioritySupport;

  /// No description provided for @selectPlan.
  ///
  /// In tr, this message translates to:
  /// **'Seç'**
  String get selectPlan;

  /// No description provided for @subscriptionActivated.
  ///
  /// In tr, this message translates to:
  /// **'Abonelik başarıyla aktifleştirildi! 🥳'**
  String get subscriptionActivated;

  /// No description provided for @subscriptionCancelled.
  ///
  /// In tr, this message translates to:
  /// **'Satın alma işlemi iptal edildi veya tamamlanamadı.'**
  String get subscriptionCancelled;

  /// No description provided for @subscriptionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınırları Kaldırın 🚀'**
  String get subscriptionSubtitle;

  /// No description provided for @subscriptionDesc.
  ///
  /// In tr, this message translates to:
  /// **'Size ve ekibinize en uygun planı seçerek Notiva deneyimini zirveye taşıyın.'**
  String get subscriptionDesc;

  /// No description provided for @teamWork.
  ///
  /// In tr, this message translates to:
  /// **'Ekip Çalışması'**
  String get teamWork;

  /// No description provided for @teamWorkDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bir ekip kurun veya davet koduyla mevcut bir ekibe katılarak projelerinizi birlikte yönetin.'**
  String get teamWorkDesc;

  /// No description provided for @createNewTeam.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ekip Kur'**
  String get createNewTeam;

  /// No description provided for @joinWithInviteCode.
  ///
  /// In tr, this message translates to:
  /// **'Davet Koduyla Katıl'**
  String get joinWithInviteCode;

  /// No description provided for @myTeams.
  ///
  /// In tr, this message translates to:
  /// **'Ekiplerim'**
  String get myTeams;

  /// No description provided for @membersCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} üye'**
  String membersCount(int count);

  /// No description provided for @contactsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kişiler'**
  String get contactsLabel;

  /// No description provided for @noResultsFound.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı'**
  String get noResultsFound;

  /// No description provided for @tryDifferentKeywords.
  ///
  /// In tr, this message translates to:
  /// **'Farklı anahtar kelimeler deneyin'**
  String get tryDifferentKeywords;

  /// No description provided for @searchTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get searchTitle;

  /// No description provided for @createReminderTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı Oluştur'**
  String get createReminderTitle;

  /// No description provided for @titleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get titleLabel;

  /// No description provided for @repeatLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar'**
  String get repeatLabel;

  /// No description provided for @notificationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim'**
  String get notificationLabel;

  /// No description provided for @activityStreamTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aktivite Akışı'**
  String get activityStreamTitle;

  /// No description provided for @taskUpdatedActivity.
  ///
  /// In tr, this message translates to:
  /// **'görev güncelledi'**
  String get taskUpdatedActivity;

  /// No description provided for @taskAddedActivity.
  ///
  /// In tr, this message translates to:
  /// **'görev ekledi'**
  String get taskAddedActivity;

  /// No description provided for @reminderAddedActivity.
  ///
  /// In tr, this message translates to:
  /// **'hatırlatıcı ekledi'**
  String get reminderAddedActivity;

  /// No description provided for @noteAddedActivity.
  ///
  /// In tr, this message translates to:
  /// **'not ekledi'**
  String get noteAddedActivity;

  /// No description provided for @noteUpdatedActivity.
  ///
  /// In tr, this message translates to:
  /// **'not güncelledi'**
  String get noteUpdatedActivity;

  /// No description provided for @notInAnyTeam.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir ekibe dahil değilsiniz.'**
  String get notInAnyTeam;

  /// No description provided for @joinTeam.
  ///
  /// In tr, this message translates to:
  /// **'Ekibe Katıl'**
  String get joinTeam;

  /// No description provided for @joinTeamDesc.
  ///
  /// In tr, this message translates to:
  /// **'Ekip yöneticisinden aldığınız 6 haneli davet kodunu girin.'**
  String get joinTeamDesc;

  /// No description provided for @inviteCode.
  ///
  /// In tr, this message translates to:
  /// **'Davet Kodu'**
  String get inviteCode;

  /// No description provided for @join.
  ///
  /// In tr, this message translates to:
  /// **'Katıl'**
  String get join;

  /// No description provided for @teamJoinedSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Ekibe başarıyla katıldınız! 🎉'**
  String get teamJoinedSuccess;

  /// No description provided for @alreadyTeamMember.
  ///
  /// In tr, this message translates to:
  /// **'Zaten bu ekibin üyesisiniz.'**
  String get alreadyTeamMember;

  /// No description provided for @invalidInviteCode.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz davet kodu. Lütfen tekrar kontrol edin.'**
  String get invalidInviteCode;

  /// No description provided for @noPlansForDate.
  ///
  /// In tr, this message translates to:
  /// **'Bu tarihte plan yok.'**
  String get noPlansForDate;

  /// No description provided for @task.
  ///
  /// In tr, this message translates to:
  /// **'Görev'**
  String get task;

  /// No description provided for @error.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get error;

  /// No description provided for @reminderLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get reminderLabel;

  /// No description provided for @unarchiveTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Arşivden Çıkar'**
  String get unarchiveTooltip;

  /// No description provided for @itemUnarchived.
  ///
  /// In tr, this message translates to:
  /// **'Öğe arşivden çıkarıldı.'**
  String get itemUnarchived;

  /// No description provided for @manageProductivity.
  ///
  /// In tr, this message translates to:
  /// **'Üretkenliğinizi yönetin'**
  String get manageProductivity;

  /// No description provided for @loginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In tr, this message translates to:
  /// **'ornek@email.com'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In tr, this message translates to:
  /// **'E-posta gerekli'**
  String get emailRequired;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Şifre gerekli'**
  String get passwordRequired;

  /// No description provided for @forgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum'**
  String get forgotPassword;

  /// No description provided for @orLabel.
  ///
  /// In tr, this message translates to:
  /// **'VEYA'**
  String get orLabel;

  /// No description provided for @loginWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile Giriş Yap'**
  String get loginWithGoogle;

  /// No description provided for @noAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız yok mu? '**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Oluştur'**
  String get createAccount;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler eşleşmiyor'**
  String get passwordsDoNotMatch;

  /// No description provided for @welcomeToNotiva.
  ///
  /// In tr, this message translates to:
  /// **'Notiva\'ya hoş geldiniz'**
  String get welcomeToNotiva;

  /// No description provided for @fullNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Adınızı girin'**
  String get fullNameHint;

  /// No description provided for @nameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ad gerekli'**
  String get nameRequired;

  /// No description provided for @passwordLengthHint.
  ///
  /// In tr, this message translates to:
  /// **'En az 6 karakter'**
  String get passwordLengthHint;

  /// No description provided for @passwordLength.
  ///
  /// In tr, this message translates to:
  /// **'En az 6 karakter olmalı'**
  String get passwordLength;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Tekrar'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In tr, this message translates to:
  /// **'Şifrenizi tekrar girin'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Şifre tekrarı gerekli'**
  String get confirmPasswordRequired;

  /// No description provided for @registerLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get registerLabel;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabınız var mı? '**
  String get alreadyHaveAccount;

  /// No description provided for @completeProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profilini Tamamla'**
  String get completeProfile;

  /// No description provided for @welcomeHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Hoş Geldiniz!'**
  String get welcomeHeadline;

  /// No description provided for @completeProfileDesc.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmeden önce lütfen bilgilerinizi tamamlayın.'**
  String get completeProfileDesc;

  /// No description provided for @photoSizeLimit.
  ///
  /// In tr, this message translates to:
  /// **'Profil fotoğrafı 5 MB\'dan küçük olmalıdır.'**
  String get photoSizeLimit;

  /// No description provided for @saveAndStart.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet ve Başla'**
  String get saveAndStart;

  /// No description provided for @phoneLabel.
  ///
  /// In tr, this message translates to:
  /// **'Telefon Numarası'**
  String get phoneLabel;

  /// No description provided for @phoneRequired.
  ///
  /// In tr, this message translates to:
  /// **'Telefon gerekli'**
  String get phoneRequired;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Sıfırlama'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.'**
  String get resetPasswordDesc;

  /// No description provided for @sendLink.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı Gönder'**
  String get sendLink;

  /// No description provided for @linkSent.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı Gönderildi!'**
  String get linkSent;

  /// No description provided for @linkSentDesc.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.'**
  String get linkSentDesc;

  /// No description provided for @backToLogin.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Ekranına Dön'**
  String get backToLogin;

  /// No description provided for @workspacesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma Alanları'**
  String get workspacesTitle;

  /// No description provided for @personalWorkspaceCannotBeManaged.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel alan yönetilemez'**
  String get personalWorkspaceCannotBeManaged;

  /// No description provided for @teamManagement.
  ///
  /// In tr, this message translates to:
  /// **'Ekip Yönetimi'**
  String get teamManagement;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Davet Kodu'**
  String get inviteCodeLabel;

  /// No description provided for @teamMembersCount.
  ///
  /// In tr, this message translates to:
  /// **'Ekip Üyeleri ({count})'**
  String teamMembersCount(int count);

  /// No description provided for @nameLabel.
  ///
  /// In tr, this message translates to:
  /// **'İsim'**
  String get nameLabel;

  /// No description provided for @nonePermission.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get nonePermission;

  /// No description provided for @readPermission.
  ///
  /// In tr, this message translates to:
  /// **'Görme'**
  String get readPermission;

  /// No description provided for @writePermission.
  ///
  /// In tr, this message translates to:
  /// **'Düzenleme'**
  String get writePermission;

  /// No description provided for @leaveTeam.
  ///
  /// In tr, this message translates to:
  /// **'Ekipten Ayrıl'**
  String get leaveTeam;

  /// No description provided for @deleteAndDisbandTeam.
  ///
  /// In tr, this message translates to:
  /// **'Ekibi Sil ve Dağıt'**
  String get deleteAndDisbandTeam;

  /// No description provided for @managePermissions.
  ///
  /// In tr, this message translates to:
  /// **'Yetkileri Yönet'**
  String get managePermissions;

  /// No description provided for @savePermissions.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get savePermissions;

  /// No description provided for @permissions.
  ///
  /// In tr, this message translates to:
  /// **'Yetkiler'**
  String get permissions;

  /// No description provided for @adminRole.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici'**
  String get adminRole;

  /// No description provided for @unknownUser.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen Kullanıcı'**
  String get unknownUser;

  /// No description provided for @removeMemberTitle.
  ///
  /// In tr, this message translates to:
  /// **'Üyeyi Çıkar'**
  String get removeMemberTitle;

  /// No description provided for @removeMemberDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu üyeyi ekipten çıkarmak istediğinize emin misiniz?'**
  String get removeMemberDesc;

  /// No description provided for @remove.
  ///
  /// In tr, this message translates to:
  /// **'Çıkar'**
  String get remove;

  /// No description provided for @leaveTeamTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ekipten Ayrıl'**
  String get leaveTeamTitle;

  /// No description provided for @leaveTeamDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekipten ayrılmak istediğinize emin misiniz? Ekip yöneticisi sizi tekrar davet etmedikçe geri dönemezsiniz.'**
  String get leaveTeamDesc;

  /// No description provided for @deleteTeamTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ekibi Sil'**
  String get deleteTeamTitle;

  /// No description provided for @deleteTeamDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekibi silerseniz içindeki tüm veriler (notlar, görevler) silinecek. Emin misiniz?'**
  String get deleteTeamDesc;

  /// No description provided for @deleteAction.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get deleteAction;

  /// No description provided for @inviteCodeCopied.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu kopyalandı!'**
  String get inviteCodeCopied;

  /// No description provided for @loading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get loading;

  /// No description provided for @errorMsg.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get errorMsg;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
