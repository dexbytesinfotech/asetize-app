import '../../my_post/models/get_feed_data_model.dart';

class PostCommentModel {
  Comments? data;
  String? message;

  PostCommentModel({this.data, this.message});

  PostCommentModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Comments.fromJson(json['data']) : null;
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

// class CommentData {
//   int? commentId;
//   FeedUser? user;
//   String? comment;
//   String? createdAt;
//
//   CommentData({this.commentId, this.user, this.comment, this.createdAt});
//
//   CommentData.fromJson(Map<String, dynamic> json) {
//     commentId = json['comment_id'];
//     user = json['user'] != null ? new FeedUser.fromJson(json['user']) : null;
//     comment = json['comment'];
//     createdAt = json['created_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['comment_id'] = this.commentId;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     data['comment'] = this.comment;
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }
