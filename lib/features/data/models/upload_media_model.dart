class UploadMediaModel {
  UploadMediaData? data;
  String? message;

  UploadMediaModel({this.data, this.message});

  UploadMediaModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new UploadMediaData.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class UploadMediaData {
  int? id;
  String? collectionName;
  String? fileName;
  String? path;

  UploadMediaData({this.id, this.collectionName, this.fileName, this.path});

  UploadMediaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    collectionName = json['collection_name'];
    fileName = json['file_name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['collection_name'] = this.collectionName;
    data['file_name'] = this.fileName;
    data['path'] = this.path;
    return data;
  }
}
