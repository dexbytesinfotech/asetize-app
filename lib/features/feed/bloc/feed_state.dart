part of 'feed_bloc.dart';

abstract class FeedState {
  FeedState();
  List<Object> get props => [];
}

class FeedInitialState extends FeedState {}

class FeedLoadingState extends FeedState {
  final FeedEvent? loadingForEvent;
  FeedLoadingState({this.loadingForEvent});
}

class FeedErrorState extends FeedState {
  String errorMessage;
  final FeedEvent? loadingForEvent;
  FeedErrorState({required this.errorMessage, this.loadingForEvent});
}

class FeedDataState extends FeedState {}

class MoreDataLoadingState extends FeedState {}

class MyPostFetchDoneState extends FeedState {}

class PostLikeDoneState extends FeedState {}

class FetchedSinglePostDataState extends FeedState {}

class PostCommentDoneState extends FeedState {}

class UpdatedFeedDataDoneState extends FeedState {}

class DeleteUserFeedDoneState extends FeedState {}

class DeleteCommentDoneState extends FeedState {}
