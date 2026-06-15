import 'package:hive_flutter/hive_flutter.dart';

/// Hive tabanlı yerel depolama servisi.
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  final Map<String, Box> _openBoxes = {};

  /// Hive'ı başlatır.
  Future<void> init() async {
    await Hive.initFlutter();
  }

  /// Belirtilen isimde bir kutu açar.
  Future<Box<T>> openBox<T>(String boxName) async {
    if (_openBoxes.containsKey(boxName) && _openBoxes[boxName]!.isOpen) {
      return _openBoxes[boxName] as Box<T>;
    }
    final box = await Hive.openBox<T>(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  /// Belirtilen kutuda veri kaydeder.
  Future<void> put(String boxName, String key, dynamic value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  /// Belirtilen kutudan veri okur.
  Future<T?> get<T>(String boxName, String key) async {
    final box = await openBox(boxName);
    return box.get(key) as T?;
  }

  /// Belirtilen kutudan bir öğeyi siler.
  Future<void> delete(String boxName, String key) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  /// Belirtilen kutudaki tüm öğeleri getirir.
  Future<List<T>> getAll<T>(String boxName) async {
    final box = await openBox(boxName);
    return box.values.cast<T>().toList();
  }

  /// Belirtilen kutunun tüm içeriğini temizler.
  Future<void> clearBox(String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
  }

  /// Tüm kutuları kapatır.
  Future<void> closeAll() async {
    await Hive.close();
    _openBoxes.clear();
  }
}
