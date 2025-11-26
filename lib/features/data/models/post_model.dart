class PostModel {
  String? profilePhoto;
  String? postBy;
  String? postPublishedAt;
  String? postTitle;
  String? postDescription;
  String? postImageUrl;
  String? likeText;
  String? commentText;
  final List<String>? postImages;
  PostModel({
    this.profilePhoto,
    this.postBy,
    this.postPublishedAt,
    this.postTitle,
    this.postDescription,
    this.postImageUrl,
    this.commentText,
    this.likeText,
    this.postImages,
  });
}

final List<PostModel> postModel = [
  PostModel(
    //1
    profilePhoto: '',
    postBy: 'HR Bot',
    postPublishedAt: '3 year ago',
    postTitle: '''<!DOCTYPE html>
                      <html>
                      <body>
                      <p>Happy Marriage Anniversary &#x1F381; &#127881;</p>
                      </body>''',
    postDescription:
        'Don not stop celebrating your marriage as the years add up. Each wedding anniversary is special, but the milestones are especially remarkable. Whether you have  been married for five years, a decade, or more, every milestone is significant to your relationship. If you are looking for milestone anniversary captions, we have got you covered. Choose your favorite from our list below.',
    //postImageUrl: "https://getmoreimages.com/storage/images/preview_640/beautiful-nature-wallpaper_1596993082.JPG",
    likeText: 'Richa and 700 others',
    commentText: '5 comments',
    postImages: [
      "https://getmoreimages.com/storage/images/preview_640/beautiful-nature-wallpaper_1596993082.JPG",
      "https://www.celebface.in/wp-content/uploads/2021/07/Kim-Soo-Hyun.jpeg",
      "https://image.kpopmap.com/2022/01/all-of-us-are-dead-rising-actor-park-solomon_3.jpg",
      "https://devdiscourse.blob.core.windows.net/devnews/10_12_2021_17_09_32_0906548.jpg",
    ],
  ),
  PostModel(
    //2
    profilePhoto: '',
    postBy: 'HR Bot',
    postPublishedAt: '3 mintues ago',
    postTitle: 'Happy Birthday to you',
    postDescription:
        'Happy birthday to the most amazing person I know! May your birthday be filled with joy, love, and laughter, and may your heart be overflowing',
    // postImageUrl: "https://1739752386.rsc.cdn77.org/data/images/full/240981/kim-soo-hyun.png",
    postImages: [
      "https://1739752386.rsc.cdn77.org/data/images/full/240981/kim-soo-hyun.png",
    ],
    likeText: '34 people like',
    commentText: '1 comment',
  ),
  PostModel(
    //3
    profilePhoto: '',
    postBy: 'HR Bot',
    postPublishedAt: '3 year ago',
    postTitle: null,
    postDescription:
        'Don not stop celebrating your marriage as the years add up. Each wedding anniversary is special, but the milestones are especially remarkable. Whether you have  been married for five years, a decade, or more, every milestone is significant to your relationship. If you are looking for milestone anniversary captions, we have got you covered. Choose your favorite from our list below.',
    //postImageUrl: null,
    postImages: null,
    likeText: 'Richa and 700 others',
    commentText: '5K comments',
  ),
  PostModel(
    //4
    profilePhoto: '',
    postBy: 'HR Bot',
    postPublishedAt: '3 year ago',
    postTitle: null,
    postDescription: null,
    //postImageUrl: "https://www.celebface.in/wp-content/uploads/2021/07/Kim-Soo-Hyun.jpeg",
    postImages: [
      "https://www.celebface.in/wp-content/uploads/2021/07/Kim-Soo-Hyun.jpeg",
    ],
    likeText: 'Richa and 700 others',
    commentText: '55 comments',
  ),
  PostModel(
    //5
    profilePhoto: '',
    postBy: 'HR Bot',
    postPublishedAt: '3 year ago',
    postTitle: "Welcome to Dexbytes",
    postDescription: '',
    //postImageUrl: "https://www.celebface.in/wp-content/uploads/2021/07/Kim-Soo-Hyun.jpeg",
    postImages: [
      "https://www.celebface.in/wp-content/uploads/2021/07/Kim-Soo-Hyun.jpeg",
    ],
    likeText: 'Richa and 700 others',
    commentText: '5 comments',
  ),
];
