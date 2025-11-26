import '../../../../imports.dart';

class PostLikeCommentView extends StatelessWidget {
  final bool isRemoveCommentSection;
  final Future<bool?> Function(bool)? onTap;
  final Function()? onTapLikeScreen;
  final Function()? onTapCommentScreen;
  final Function()? onTapLikeButton;
  final int? likeCount;
  final String? likeTitle;
  final int? commentCount;
  final String? commentTitle;
  final bool? isLike;
  final bool? isLikeVisible;
  final bool? isCommentVisible;
  final Function()? onTapShareButton;
  const PostLikeCommentView(
      {super.key,
      this.isRemoveCommentSection = false,
      this.onTap,
      this.onTapLikeScreen,
      this.onTapCommentScreen,
      this.likeCount,
      this.likeTitle,
      this.commentCount,
      this.commentTitle,
      this.isLike = false,
      this.onTapLikeButton,
      this.isLikeVisible, this.onTapShareButton,
      this.isCommentVisible});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (isLikeVisible == true)
                              InkWell(
                                onTap: onTapLikeScreen,
                                child: Row(
                                  children: [
                                    Icon(
                                      (isLike != null && isLike!)
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_outlined,
                                      color: (isLike != null && isLike!)
                                          ? AppColors.appBlueColor
                                          : AppColors.appBlack,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '$likeCount ${AppString.likes}',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isCommentVisible == true)
                              InkWell(
                                onTap: onTapCommentScreen,
                                child: Text(
                                  '$commentCount ${AppString.comments}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 0,
                        thickness: 0,
                      ))),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
        SizedBox(
            height: 35,
            child: Padding(
              padding: const EdgeInsets.only(left: 19, right: 20),
              child: Row(
                mainAxisAlignment: (isRemoveCommentSection == false)
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 4,
                      child: Container(
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: LikeButton(
                                  onTap: onTap,
                                  size: 25,
                                  isLiked: isLike,
                                  likeText: AppString.likes,
                                  likedTextColor: AppColors.appBlueColor,
                                  unLikeTextColor: AppColors.appBlack,
                                  padding:
                                      const EdgeInsets.only(right: 0, left: 0),
                                  likeCountPadding:
                                      const EdgeInsets.only(right: 2, left: 0),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor: AppColors.appBlueColor,
                                    dotSecondaryColor: Colors.blue,
                                  ),
                                  circleColor: const CircleColor(
                                      start: AppColors.appBlueColor,
                                      end: AppColors.appBlueColor),
                                  likeBuilder: (tapped) {
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 6),
                                        child: Icon(
                                          Icons.thumb_up_outlined,
                                          color: tapped
                                              ? AppColors.appBlueColor
                                              : AppColors.appBlack,
                                          size: 20,
                                        ));
                                  },
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () async {
                              //     if (onTap != null) {
                              //       await onTap!(isLike ?? false);
                              //     }
                              //   },
                              //   child: Container(
                              //     color: Colors.transparent,
                              //       height: 40,
                              //       padding: const EdgeInsets.only(bottom: 6),
                              //       child: Row(
                              //         mainAxisSize: MainAxisSize.max,
                              //         mainAxisAlignment:
                              //         MainAxisAlignment.center,
                              //         children: [
                              //           Text('Like ',
                              //               style: TextStyle(
                              //                   color: isLike == true
                              //                       ? AppColors.buttonBgColor4
                              //                       : AppColors.appBlack,
                              //                   fontSize: 12))
                              //         ],
                              //       )),
                              // ),
                            ],
                          ))),
                  if (isRemoveCommentSection == false)
                    Expanded(
                        flex: 4,
                        child: InkWell(
                            onTap: onTapCommentScreen,
                            child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  //Stack(
                                  // alignment: Alignment.topCenter,
                                  children: [
                                    const Padding(
                                      //color: Colors.green,
                                      padding: EdgeInsets.only(
                                          top: 0, right: 5, bottom: 5),
                                      child: Icon(
                                        Icons.message,
                                        color: AppColors.appBlack,
                                        size: 20,
                                      ),
                                    ),
                                    Container(
                                        // padding: const EdgeInsets.only(top: 22),
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: const Text(AppString.comment,
                                            style: TextStyle(
                                                color: AppColors.appBlack,
                                                fontSize: 12)))
                                  ],
                                )))),
                  Expanded(
                      flex: 2,
                      child: InkWell(
                          onTap: onTapShareButton,
                          child: Container(
                              color: Colors.transparent,
                              child: Row(
                                //Stack(
                                // alignment: Alignment.topCenter,
                                children: [
                                  const Padding(
                                    //color: Colors.green,
                                    padding: EdgeInsets.only(
                                        top: 0, right: 5, bottom: 5),
                                    child: Icon(
                                      Icons.share,
                                      color: AppColors.appBlack,
                                      size: 20,
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.only(top: 22),
                                      padding:
                                      const EdgeInsets.only(bottom: 8),
                                      child: const Text(AppString.share,
                                          style: TextStyle(
                                              color: AppColors.appBlack,
                                              fontSize: 14)))
                                ],
                              )))),
                ],
              ),
            )),
      ],
    );
  }
}
