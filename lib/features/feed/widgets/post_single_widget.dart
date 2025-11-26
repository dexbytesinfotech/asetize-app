import 'dart:core';
import 'package:asetize/features/feed/widgets/post_center_view.dart';
import 'package:asetize/features/feed/widgets/post_header.dart';
import 'package:asetize/features/feed/widgets/post_like_comment_view.dart';

import '../../../imports.dart';

class PostSingleWidget extends StatelessWidget {
  final bool isRemoveCommentSection;
  final bool showFullDescription;
  final String? profilePhoto;
  final String? postBy;
  final String? jobTitle;
  final String? postPublishedAt;
  final String? fileCount;
  final String? postTitle;
  final String? postDescription;
  final List<String>? postImages;
  final List<String>? postType;
  final Future<bool?> Function(bool)? onTap;
  final Function()? onTapLikeScreen;
  final Function()? onTapCommentScreen;
  final Function()? onTapLikeButton;
  final Function()? onPostTextClick;
  final int? likeCount;
  final String? likeTitle;
  final int? commentCount;
  final String? commentTitle;
  final bool? isLike;
  final bool? isShowMoreIcon;
  final Function()? onDeleteTap;
  final bool? isLikeVisible;
  final bool? isCommentVisible;
  final Function()? onTapShareButton;
  const PostSingleWidget({
    super.key,
    this.isRemoveCommentSection = false,
    this.showFullDescription = false,
    this.profilePhoto,
    this.postBy,
    this.jobTitle,
    this.postPublishedAt,
    this.fileCount,
    this.postTitle,
    this.postDescription,
    this.postImages,
    this.postType,
    this.onTap,
    this.onTapLikeScreen,
    this.onTapCommentScreen,
    this.onTapLikeButton,
    this.likeCount,
    this.likeTitle,
    this.commentCount,
    this.commentTitle,
    this.isLike,
    this.isShowMoreIcon,
    this.onDeleteTap,
    this.isLikeVisible = true,
    this.isCommentVisible = true,
    this.onPostTextClick,
    this.onTapShareButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0, bottom: 10),
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PostHeader(
            profilePhoto: profilePhoto,
            postBy: postBy,
            postPublishedAt: postPublishedAt,
            isShowMoreIcon: isShowMoreIcon,
            onDeleteTap: onDeleteTap,
          ),
          Container(
            color: Colors.transparent,
            child: PostCenterView(
              onPostTextClick: onPostTextClick,
              postBy: postBy,
              showFullDescription: showFullDescription,
              postTitle: postTitle,
              postDescription: postDescription!.replaceAll('\n', '<br>')  ?? "",
              fileCount: fileCount,
              postType: postType,
              postImages: postImages,
            ),
          ),
          const SizedBox(height: 4),
          PostLikeCommentView(
            isRemoveCommentSection: isRemoveCommentSection,
            isLike: isLike,
            likeCount: likeCount,
            commentCount: commentCount,
            likeTitle: '$likeTitle',
            commentTitle: '$commentTitle',
            onTap: onTap,
            onTapLikeScreen: onTapLikeScreen,
            onTapShareButton: onTapShareButton,
            onTapCommentScreen: onTapCommentScreen,
            isLikeVisible: isLikeVisible,
            isCommentVisible: isCommentVisible,
          ),
        ],
      ),
    );
  }
}
