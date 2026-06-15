/// Bildirim servisi — FCM entegrasyonu yer tutucusu.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// FCM'yi başlatır.
  /// TODO: Firebase Cloud Messaging entegrasyonu yapılacak.
  Future<void> init() async {
    // await FirebaseMessaging.instance.requestPermission();
    // final token = await FirebaseMessaging.instance.getToken();
  }

  /// Yerel bildirim gösterir.
  /// TODO: flutter_local_notifications entegrasyonu yapılacak.
  Future<void> showLocalNotification(String title, String body) async {
    // Placeholder
  }

  /// Zamanlı bildirim planlar.
  /// TODO: Zamanlı bildirim entegrasyonu yapılacak.
  Future<void> scheduleNotification(String title, String body, DateTime dateTime) async {
    // Placeholder
  }

  /// Bildirim iptal eder.
  Future<void> cancelNotification(int id) async {
    // Placeholder
  }
}
