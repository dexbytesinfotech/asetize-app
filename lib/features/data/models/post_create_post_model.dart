import '../../my_post/models/get_feed_data_model.dart';

class CreatePostModel {
  FeedData? data;
  String? message;

  CreatePostModel({this.data, this.message});

  CreatePostModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new FeedData.fromJson(json['data']) : null;
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
