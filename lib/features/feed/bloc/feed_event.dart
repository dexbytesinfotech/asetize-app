part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class ResetBlocEvent extends FeedEvent {}

class FetchFeedDataEvent extends FeedEvent {
  final BuildContext mContext;
  const FetchFeedDataEvent({required this.mContext});
}

class FetchFeedDataOnLoadEvent extends FeedEvent {
  final BuildContext mContext;
  const FetchFeedDataOnLoadEvent({required this.mContext});
}

class FetchMyPostListEvent extends FeedEvent {
  final BuildContext context;
  const FetchMyPostListEvent({required this.context});
}

class FetchMyPostOnLoadEvent extends FeedEvent {
  final BuildContext context;
  const FetchMyPostOnLoadEvent({required this.context});
}

class SubmitLikeRequestEvent extends FeedEvent {
  final BuildContext? mContext;
  final int postId;
  final int index;
  final bool isLiked;
  const SubmitLikeRequestEvent({
    required this.mContext,
    required this.postId,
    required this.index,
    required this.isLiked,
  });
}

class FetchSinglePostEvent extends FeedEvent {
  final BuildContext? mContext;
  final int postId;
  const FetchSinglePostEvent({
    required this.mContext,
    required this.postId,
  });
}

class PostCommentEvent extends FeedEvent {
  final BuildContext mContext;
  final String commentText;
  final int postId;
  const PostCommentEvent(
      {required this.mContext,
      required this.commentText,
      required this.postId});
}

class UpdateFeedDataEvent extends FeedEvent {
  final FeedData? updatedFeedData;
  const UpdateFeedDataEvent({this.updatedFeedData});
}

class UpdateCommentDataEvent extends FeedEvent {
  final FeedData? updatedFeedData;
  const UpdateCommentDataEvent({this.updatedFeedData});
}

class DeleteUserFeedEvent extends FeedEvent {
  final BuildContext context;
  final int? postId;
  const DeleteUserFeedEvent({required this.context, this.postId});
}

class DeleteUserPostEvent extends FeedEvent {
  final BuildContext context;
  final int? postId;
  const DeleteUserPostEvent({required this.context, this.postId});
}

class DeleteCommentEvent extends FeedEvent {
  final BuildContext context;
  final int? commentId;
  final int? postId;
  const DeleteCommentEvent(
      {required this.context, this.commentId, this.postId});
}

class ResetFeedEvent extends FeedEvent {}