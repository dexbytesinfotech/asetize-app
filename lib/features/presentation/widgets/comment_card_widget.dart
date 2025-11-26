import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';
import 'package:asetize/imports.dart';

class CommentCardWidget extends StatelessWidget {
  final String? imageUrl;
  final String? commentUserName;
  final String? commentUserJobTitle;
  final String? timeAgo;
  final String? comment;
  final onMoreIconClickCallBack;
  final onTitleClickCallBack;
  final bool isLiked;
  final int isLikeCount;
  final Future<bool?> Function(bool)? onTapLiked;
  final LikeCountWidgetBuilder? countBuilder;
  final LikeWidgetBuilder? likeBuilder;

  const CommentCardWidget({
    Key? key,
    this.imageUrl,
    this.commentUserName,
    this.commentUserJobTitle,
    this.onMoreIconClickCallBack,
    this.onTitleClickCallBack,
    this.timeAgo,
    this.isLiked = false,
    this.isLikeCount = 0,
    this.likeBuilder,
    this.countBuilder,
    this.onTapLiked,
    this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    likeCommentRow() {
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 0, top: 12, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LikeButton(
              size: 24,
              bubblesSize: 0,
              circleSize: 0,
              padding: const EdgeInsets.only(right: 22),
              likeCountPadding: const EdgeInsets.only(left: 0, right: 0),
              animationDuration: const Duration(milliseconds: 750),
              likeCountAnimationDuration: const Duration(microseconds: 500),
              isLiked: isLiked,
              countPostion: CountPostion.bottom,
              likeCount: isLikeCount,
              likeBuilder: likeBuilder,
              countBuilder: countBuilder,
              likeCountAnimationType: LikeCountAnimationType.none,
            ),
            Flexible(
                child: Padding(
              padding: const EdgeInsets.only(top: 3.6),
              child: Text(
                comment ?? "Hi, @Mike_Polsey. Welcome to DexBytes!",
                style: appStyles.userNameTextStyle(fontWeight: FontWeight.w300),
              ),
            )),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  onTitleClickCallBack?.call();
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: CachedNetworkImage(
                          placeholder: (context, url) => const ImageLoader(),
                          height: 37,
                          width: 37,
                          imageUrl: imageUrl ??
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPhFl6zHkAHKFN0kNZl0jhZLfgeYYy2WzbezLIKbdF0eBJgVBP0ZmkVClZuU61_fF1bSc&usqp=CAU",
                          fit: BoxFit.cover,
                          errorWidget: (
                            BuildContext context,
                            String url,
                            Object error,
                          ) {
                            return Container(color: Colors.grey);
                          }),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commentUserName ?? "WorkPlace App",
                          style: appStyles.userNameTextStyle(),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          commentUserJobTitle ?? "Sr. Product Manager",
                          style: appStyles.userJobTitleTextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                          timeAgo ?? "1 hour ago",
                          style: appStyles.userJobTitleTextStyle(),
                        ),
                        const SizedBox(
                          height: 9.2,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              onMoreIconClickCallBack?.call();
                            },
                            child: WorkplaceIcons.iconImage(
                              iconSize: const Size(3.8, 3.8),
                              imageUrl: WorkplaceIcons.moreIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          likeCommentRow(),
          const SizedBox(width: 60, child: Divider()),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
