class CommentDataModel {
  final String? imageUrl;
  final String? commentUserName;
  final String? commentUserJobTitle;
  final String? timeAgo;
  final String? comment;
  int isLikeCount;
  bool isLiked;

  CommentDataModel({
    required this.imageUrl,
    required this.commentUserName,
    required this.commentUserJobTitle,
    required this.timeAgo,
    required this.comment,
    required this.isLikeCount,
    required this.isLiked,
  });
}

final List<CommentDataModel> commentList = [
  CommentDataModel(
    imageUrl:
        "https://devdiscourse.blob.core.windows.net/devnews/31_08_2019_18_35_33_1126394.jpg",
    commentUserName: "DexBytes App",
    commentUserJobTitle: "Jr. Flutter Developer",
    timeAgo: "1 day ago",
    comment: "Hi, @Mike_Polsey. Welcome to DexBytes!",
    isLikeCount: 0,
    isLiked: false,
  ),
  CommentDataModel(
    imageUrl:
        "https://image.kpopmap.com/2022/01/all-of-us-are-dead-rising-actor-park-solomon_3.jpg",
    commentUserName: "DexBytes App",
    commentUserJobTitle: "Jr. Developer",
    timeAgo: "1 hour ago",
    comment: "Hi team @Charm Financial. Welcome to DexBytes!",
    isLikeCount: 20,
    isLiked: true,
  ),
  CommentDataModel(
    imageUrl: "https://photos.hancinema.net/photos/photo1581223.jpg",
    commentUserName: "DexBytes App",
    commentUserJobTitle: "Sr. Product Manager",
    timeAgo: "4 day ago",
    comment:
        "Hi there! Thanks for contacting us. We'll reply to your message within 8 hours.",
    isLikeCount: 5,
    isLiked: false,
  ),
  CommentDataModel(
    imageUrl:
        "https://static8.depositphotos.com/1468291/934/i/450/depositphotos_9346925-stock-photo-portrait-of-office-worker-at.jpg",
    commentUserName: "DexBytes App",
    commentUserJobTitle: "Jr. Flutter Developer",
    timeAgo: "1 day ago",
    comment:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isLikeCount: 13,
    isLiked: true,
  ),
  CommentDataModel(
    imageUrl:
        "https://image.kpopmap.com/2022/01/all-of-us-are-dead-rising-actor-park-solomon_3.jpg",
    commentUserName: "DexBytes App",
    commentUserJobTitle: "Jr. Flutter Developer",
    timeAgo: "1 day ago",
    comment:
        "We hope you find what you're looking for and that you enjoy your stay",
    isLikeCount: 20,
    isLiked: false,
  ),
  CommentDataModel(
    imageUrl:
        "https://devdiscourse.blob.core.windows.net/devnews/31_08_2019_18_35_33_1126394.jpg",
    commentUserName: "DexBytes App",
    commentUserJobTitle: "Jr. Flutter Developer",
    timeAgo: "1 day ago",
    comment:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isLikeCount: 20,
    isLiked: false,
  ),
  CommentDataModel(
    imageUrl:
        "https://image.kpopmap.com/2022/01/all-of-us-are-dead-rising-actor-park-solomon_3.jpg",
    commentUserName: "DexBytes App",
    commentUserJobTitle: "Jr. Flutter Developer",
    timeAgo: "1 day ago",
    comment:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isLikeCount: 20,
    isLiked: false,
  ),
];
