class HomePostDataModel {
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

  HomePostDataModel({
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

final List<HomePostDataModel> homePost = [
  HomePostDataModel(
    userImage:
        "https://image.kpopmap.com/2022/01/all-of-us-are-dead-rising-actor-park-solomon_3.jpg",
    userName: "DexBytes App",
    userJobTitle: "Jr. Flutter Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 120,
    isLikeCount: 20,
    isLiked: false,
    postType: "withImage",
    postImages: [
      "https://www.celebface.in/wp-content/uploads/2021/07/Kim-Soo-Hyun.jpeg",
      "https://image.kpopmap.com/2022/01/all-of-us-are-dead-rising-actor-park-solomon_3.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEDieEBz455kBBSvbVN9PxJAF5G3z2NF0KL9IBXDrCbg0QoVsQwSNu33462g4huAU1xxw&usqp=CAU",
      "https://i0.wp.com/kstartrend.com/wp-content/uploads/2022/02/download.png?fit=658%2C552&ssl=1"
    ],
  ),
  HomePostDataModel(
    userImage:
        "https://image.kpopmap.com/2022/01/all-of-us-are-dead-rising-actor-park-solomon_3.jpg",
    userName: "DexBytes App",
    userJobTitle: "Jr. Flutter Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 120,
    isLikeCount: 20,
    isLiked: false,
    customImageUrl:
        "https://t4.ftcdn.net/jpg/02/97/24/51/360_F_297245133_gBPfK0h10UM3y7vfoEiBC3ZXt559KZar.jpg",
    customTitleText: "Welcome to Dexbytes",
    customSubTitleText:
        "Pawan Vishwakarma, we're excited to have you here as part of the team.",
    postType: "custom",
  ),
  HomePostDataModel(
    userImage:
        "https://devdiscourse.blob.core.windows.net/devnews/31_08_2019_18_35_33_1126394.jpg",
    userName: "WorkPlace App",
    userJobTitle: "Sr. Product Manager",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 5,
    isLikeCount: 123,
    isLiked: false,
    postType: "withImage",
    postImages: [
      "https://devdiscourse.blob.core.windows.net/devnews/31_08_2019_18_35_33_1126394.jpg",
      "https://devdiscourse.blob.core.windows.net/devnews/10_12_2021_17_09_32_0906548.jpg",
      "https://i0.wp.com/kstartrend.com/wp-content/uploads/2022/02/download.png?fit=658%2C552&ssl=1"
    ],
  ),
  HomePostDataModel(
    userImage:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRZ1ZF-LBL4MdBsPg_0b6Ubir_iqwc-H6MxF24dRTOIcthUr56mX-ZHeBtNIh3IQ3MpII&usqp=CAU",
    userName: "WorkPlace App",
    userJobTitle: "Sr. Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 5,
    isLikeCount: 123,
    isLiked: false,
    postText:
        "Flutter is Google's portable UI toolkit for crafting beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.",
    postType: "onlyText",
  ),
  HomePostDataModel(
    userImage:
        "https://6.viki.io/image/73e88201a87643fe9d4fe1833eebcbfc.jpeg?s=900x600&e=t",
    userName: "WorkPlace App",
    userJobTitle: "Sr. Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 100,
    isLikeCount: 45,
    postType: "withImage",
    isLiked: false,
    postImages: [
      "https://1739752386.rsc.cdn77.org/data/images/full/240981/kim-soo-hyun.png",
      "https://media.herworld.com/public/2020/08/kim-soo-hyun-dramas-movies.jpg?compress=true&quality=80&w=1080&dpr=2.6",
      "https://i0.wp.com/kstartrend.com/wp-content/uploads/2022/02/download.png?fit=658%2C552&ssl=1",
    ],
  ),
  HomePostDataModel(
    userImage:
        "https://image.kpopmap.com/2022/01/all-of-us-are-dead-rising-actor-park-solomon_3.jpg",
    userName: "DexBytes App",
    userJobTitle: "Jr. Flutter Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 120,
    isLikeCount: 20,
    isLiked: false,
    customImageUrl:
        "https://images.indianexpress.com/2022/04/GettyImages-men-health-1200.jpg",
    customTitleText: "Welcome to Dexbytes",
    customSubTitleText:
        "Nikhilesh Kasdekar, we're excited to have you here as part of the team.",
    postType: "custom",
  ),
  HomePostDataModel(
    userImage:
        "https://static8.depositphotos.com/1468291/934/i/450/depositphotos_9346925-stock-photo-portrait-of-office-worker-at.jpg",
    userName: "WorkPlace App",
    userJobTitle: "Sr. Backend Developer",
    belowPostText:
        "Hi team @Charm Financial. Welcome to Highlight! Hi team @Charm Financial. Welcome to Highlight!",
    isCommentCount: 20,
    isLikeCount: 235,
    isLiked: true,
    postType: "withImage",
    postImages: [
      "https://static8.depositphotos.com/1468291/934/i/450/depositphotos_9346925-stock-photo-portrait-of-office-worker-at.jpg",
    ],
  ),
  HomePostDataModel(
    userImage:
        "https://img.freepik.com/free-photo/close-up-young-successful-man-smiling-camera-standing-casual-outfit-against-blue-background_1258-66609.jpg?w=2000",
    userName: "WorkPlace App",
    userJobTitle: "Sr. Developer",
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
