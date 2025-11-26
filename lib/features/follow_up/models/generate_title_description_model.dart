class GenerateTitleDescriptionModel {
  GenerateTitleDescriptionData? data;
  String? message;

  GenerateTitleDescriptionModel({this.data, this.message});

  GenerateTitleDescriptionModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GenerateTitleDescriptionData.fromJson(json['data']) : null;
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

class GenerateTitleDescriptionData {
  String? title;
  String? description;

  GenerateTitleDescriptionData({this.title, this.description});

  GenerateTitleDescriptionData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
