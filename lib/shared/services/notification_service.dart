import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String _restApiKey = 'os_v2_app_sodqw2vf7zeuzp2t62jf6cwnkqxd4bgml2cezem34ogkqvjafwxz5ea5m6kjigzc3wv6qde7ijoijzzmaslfffjo6mn2tiguqn6zzqa';
  static const String _appId = '93870b6a-a5fe-494c-bf53-f6925f0acd54';

  /// Anlık bildirim gönderir
  Future<void> sendInstantNotification({
    String? title,
    String? message,
    Map<String, String>? headings,
    Map<String, String>? contents,
    required List<String> targetUserIds,
  }) async {
    if (targetUserIds.isEmpty) return;
    
    try {
      final response = await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Basic $_restApiKey',
        },
        body: jsonEncode({
          'app_id': _appId,
          'include_aliases': {
            'external_id': targetUserIds,
          },
          'target_channel': 'push',
          'headings': headings ?? {'en': title ?? '', 'tr': title ?? ''},
          'contents': contents ?? {'en': message ?? '', 'tr': message ?? ''},
        }),
      );

      if (response.statusCode != 200) {
        debugPrint('OneSignal Push Error: ${response.body}');
      } else {
        debugPrint('Push notification sent to $targetUserIds');
      }
    } catch (e) {
      debugPrint('Notification sending failed: $e');
    }
  }

  /// İleri tarihli bildirim programlar
  Future<void> scheduleNotification({
    String? title,
    String? message,
    Map<String, String>? headings,
    Map<String, String>? contents,
    required List<String> targetUserIds,
    required DateTime sendAfter,
  }) async {
    if (targetUserIds.isEmpty) return;
    
    // Geçmiş zamana bildirim gönderilemez
    if (sendAfter.isBefore(DateTime.now())) return;
    
    final formattedTime = '${sendAfter.toUtc().toString().substring(0, 19)} GMT+0000';

    try {
      final response = await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Basic $_restApiKey',
        },
        body: jsonEncode({
          'app_id': _appId,
          'include_aliases': {
            'external_id': targetUserIds,
          },
          'target_channel': 'push',
          'headings': headings ?? {'en': title ?? '', 'tr': title ?? ''},
          'contents': contents ?? {'en': message ?? '', 'tr': message ?? ''},
          'send_after': formattedTime,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint('OneSignal Scheduled Push Error: ${response.body}');
      } else {
        debugPrint('Scheduled push notification for $formattedTime to $targetUserIds');
      }
    } catch (e) {
      debugPrint('Scheduled notification failed: $e');
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
