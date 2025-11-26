// media_model.dart
class Media {
  final int id;
  final String collectionName;
  final String fileName;
  final String path;

  Media({
    required this.id,
    required this.collectionName,
    required this.fileName,
    required this.path,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['data']['id'],
      collectionName: json['data']['collection_name'],
      fileName: json['data']['file_name'],
      path: json['data']['path'],
    );
  }
}
