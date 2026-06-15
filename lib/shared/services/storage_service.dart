import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile({
    required File file,
    required String path,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';
      final ref = _storage.ref().child('$path/$fileName');
      
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      debugPrint('Dosya yükleme hatası: $e');
      return null;
    }
  }

  Future<bool> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
      return true;
    } catch (e) {
      debugPrint('Dosya silme hatası: $e');
      return false;
    }
  }
}

final storageService = StorageService();
