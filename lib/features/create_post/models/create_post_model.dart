class CreateNewPostModel {
  int? id;
  String? title;
  String? content;
  List<String>? mediaFilesUrl;
  List<LocalMediaFile>? localMediaFiles;
  bool? inProgress;
  String? status;
  String? error;

  CreateNewPostModel(
      {this.id,
      this.content = "",
      this.error,
      this.title = "",
      this.inProgress = false,
      this.mediaFilesUrl,
      this.localMediaFiles,
      this.status = "published"});

  CreateNewPostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json[' content'];
    title = json['title'];
    inProgress = json['inProgress'];
    status = json['status'];
    mediaFilesUrl = json['mediaFilesUrl'];
    localMediaFiles = json['localMediaFiles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data[' content'] = content;
    data['title'] = title;
    data['inProgress'] = inProgress;
    data['status'] = status;
    data[' mediaFilesUrl'] = mediaFilesUrl;
    data[' localMediaFiles'] = localMediaFiles;
    return data;
  }
}

class LocalMediaFile {
  String? mediaFilePath;
  String? status;
  String? error;

  LocalMediaFile({this.mediaFilePath, this.status = "pending", this.error});

  LocalMediaFile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    mediaFilePath = json['mediaFilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['mediaFilePath'] = mediaFilePath;
    return data;
  }
}
