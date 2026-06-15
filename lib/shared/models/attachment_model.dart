/// Ek dosya türleri.
enum AttachmentType { image, pdf, file, voice }

/// Ek dosya modeli.
class AttachmentModel {
  final String id;
  final String parentId; // noteId veya taskId
  final AttachmentType type;
  final String url;
  final String fileName;

  const AttachmentModel({
    required this.id,
    required this.parentId,
    required this.type,
    required this.url,
    required this.fileName,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as String,
      parentId: json['parentId'] as String,
      type: AttachmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AttachmentType.file,
      ),
      url: json['url'] as String,
      fileName: json['fileName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'parentId': parentId,
        'type': type.name,
        'url': url,
        'fileName': fileName,
      };
}
