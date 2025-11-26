class MyPostDataModel {
  final String userImage;
  final String userName;
  final String userJobTitle;
  final String belowPostText;
  final String postText;
  final List<String>? postImages;
  final int isCommentCount;
  final String postType;
  final String? customImageUrl;
  final String? customTitleText;
  final String? customSubTitleText;
  int isLikeCount;
  bool isLiked;

  MyPostDataModel({
    required this.userImage,
    required this.userName,
    required this.userJobTitle,
    required this.belowPostText,
    this.postText = "",
    this.postImages,
    required this.isCommentCount,
    required this.isLikeCount,
    required this.isLiked,
    required this.postType,
    this.customImageUrl,
    this.customTitleText,
    this.customSubTitleText,
  });
}

final List<MyPostDataModel> myPost = [
  MyPostDataModel(
    userImage: "https://asianwiki.com/images/a/a1/Ahn_Hyo-Seop-1995-p1.jpg",
    userName: "Mohit Panchal",
    userJobTitle: "Jr. Flutter Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 120,
    isLikeCount: 20,
    isLiked: false,
    postType: "withImage",
    postImages: [
      "https://asianwiki.com/images/a/a1/Ahn_Hyo-Seop-1995-p1.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBFCoMQ0kIbp7Ivbq47E618aLOOa10UZi7fg&usqp=CAU",
      "https://i.pinimg.com/736x/23/54/8b/23548b322f8117d4f11333c4ca704d78.jpg"
    ],
  ),
  MyPostDataModel(
    userImage: "https://asianwiki.com/images/a/a1/Ahn_Hyo-Seop-1995-p1.jpg",
    userName: "Mohit Panchal",
    userJobTitle: "Jr. Flutter Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 5,
    isLikeCount: 123,
    isLiked: false,
    postType: "withImage",
    postImages: [
      "https://upload.wikimedia.org/wikipedia/commons/8/80/20220226_Ahn_Hyo-seop_%EC%95%88%ED%9A%A8%EC%84%AD_Photoshoot_for_Marie_Claire_Korea_%282%29.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEwVfdzoS4BRd2jZnnPUUWU5rquAHkA40BAK6NgLvueqRjfz_ovmAuNqJmHc29R0XXlkM&usqp=CAU",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMgwcuqPGDtOjmr7d4ZsseSgLt9GCF2uK8NSGLV1F477Qm-BKY-8RLLk_AM--Xytg3E1Y&usqp=CAU"
    ],
  ),
  MyPostDataModel(
    userImage: "https://asianwiki.com/images/a/a1/Ahn_Hyo-Seop-1995-p1.jpg",
    userName: "Mohit Panchal",
    userJobTitle: "Jr. Flutter Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 20,
    isLikeCount: 235,
    isLiked: true,
    postType: "withImage",
    postImages: [
      "https://i.pinimg.com/originals/5c/93/38/5c9338a11dbfdc031736b5c4dd4f9609.jpg",
    ],
  ),
  MyPostDataModel(
    userImage: "https://asianwiki.com/images/a/a1/Ahn_Hyo-Seop-1995-p1.jpg",
    userName: "Mohit Panchal",
    userJobTitle: "Jr. Flutter Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 5,
    isLikeCount: 123,
    isLiked: false,
    postText:
        "Flutter is Google's portable UI toolkit for crafting beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.",
    postType: "onlyText",
  ),
  MyPostDataModel(
    userImage: "https://asianwiki.com/images/a/a1/Ahn_Hyo-Seop-1995-p1.jpg",
    userName: "Mohit Panchal",
    userJobTitle: "Jr. Flutter Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 100,
    isLikeCount: 45,
    postType: "withImage",
    isLiked: false,
    postImages: [
      "https://i0.wp.com/www.alphagirlreviews.com/wp-content/uploads/2022/07/Ahn-hyo-seop-for-Esquire-1.jpg?resize=740%2C1000»"
    ],
  ),
  MyPostDataModel(
    userImage: "https://asianwiki.com/images/a/a1/Ahn_Hyo-Seop-1995-p1.jpg",
    userName: "Mohit Panchal",
    userJobTitle: "Jr. Flutter Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 5,
    isLikeCount: 123,
    isLiked: false,
    postText:
        "Dart is a client-optimized language for developing fast apps on any platform. Its goal is to offer the most productive programming language for multi-platform development, paired with a flexible execution runtime platform for app frameworks.",
    postType: "onlyText",
  ),
];
