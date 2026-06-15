import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import 'connectivity_service.dart';

/// Çevrimdışı yazma işlemlerini kuyrukta tutan ve
/// çevrimiçi olunduğunda senkronize eden servis.
class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final ConnectivityService _connectivity = ConnectivityService();
  Box? _syncBox;

  /// Senkronizasyon kuyruğunu başlatır.
  Future<void> init() async {
    _syncBox = await Hive.openBox(AppConstants.syncQueueBox);

    // Bağlantı değişikliklerini dinle
    _connectivity.connectivityStream.listen((isConnected) {
      if (isConnected) {
        processQueue();
      }
    });
  }

  /// Kuyruğa yeni bir işlem ekler.
  Future<void> addToQueue({
    required SyncOperation operation,
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final item = {
      'operation': operation.name,
      'collection': collection,
      'documentId': documentId,
      'data': jsonEncode(data),
      'timestamp': DateTime.now().toIso8601String(),
    };

    final key = '${collection}_${documentId}_${DateTime.now().millisecondsSinceEpoch}';
    await _syncBox?.put(key, item);

    // Çevrimiçiyse hemen işle
    if (_connectivity.isConnected) {
      await processQueue();
    }
  }

  /// Kuyruktaki tüm bekleyen işlemleri işler.
  Future<void> processQueue() async {
    if (_syncBox == null || _syncBox!.isEmpty) return;

    final keys = _syncBox!.keys.toList();
    for (final key in keys) {
      final item = _syncBox!.get(key) as Map?;
      if (item == null) continue;

      try {
        // TODO: Firestore'a gerçek yazma işlemi burada yapılacak
        // final operation = SyncOperation.values.byName(item['operation']);
        // final collection = item['collection'];
        // final documentId = item['documentId'];
        // final data = jsonDecode(item['data']);
        //
        // switch (operation) {
        //   case SyncOperation.create:
        //     await FirebaseFirestore.instance.collection(collection).doc(documentId).set(data);
        //   case SyncOperation.update:
        //     await FirebaseFirestore.instance.collection(collection).doc(documentId).update(data);
        //   case SyncOperation.delete:
        //     await FirebaseFirestore.instance.collection(collection).doc(documentId).delete();
        // }

        await _syncBox!.delete(key);
      } catch (e) {
        // Hata durumunda kuyrukta bırak, sonra tekrar dene
        continue;
      }
    }
  }

  /// Kuyruk sayısını döndürür.
  int get pendingCount => _syncBox?.length ?? 0;

  /// Tüm kuyruğu temizler.
  Future<void> clearQueue() async {
    await _syncBox?.clear();
  }
}

/// Senkronizasyon işlem türleri.
enum SyncOperation {
  create,
  update,
  delete,
}
