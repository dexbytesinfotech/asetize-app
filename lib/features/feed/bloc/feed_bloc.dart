import '../../../core/util/app_navigator/app_navigator.dart';
import '../../../imports.dart';
import '../../domain/usecases/delete_comment.dart';
import '../../domain/usecases/delete_user_post.dart';
import '../../domain/usecases/get_user_post_data.dart';
import '../../my_post/models/get_feed_data_model.dart';
import '../../domain/usecases/post_comment.dart';
part 'feed_event.dart';
part 'feed_state.dart';
part '../data_provider/feeds_data_provider.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  GetFeedData feedDetails =
      GetFeedData(RepositoryImpl(WorkplaceDataSourcesImpl()));

  String url = "";
  String myPostUrl = "";

  PostLike postLike = PostLike(RepositoryImpl(WorkplaceDataSourcesImpl()));
  GetSinglePost singlePost =
      GetSinglePost(RepositoryImpl(WorkplaceDataSourcesImpl()));

  PostCommentUseCase postComment =
      PostCommentUseCase(RepositoryImpl(WorkplaceDataSourcesImpl()));

  DeleteUserPost deleteUserPost =
      DeleteUserPost(RepositoryImpl(WorkplaceDataSourcesImpl()));
  DeleteComment deleteComment =
      DeleteComment(RepositoryImpl(WorkplaceDataSourcesImpl()));
  GetUserPostData userPostData =
      GetUserPostData(RepositoryImpl(WorkplaceDataSourcesImpl()));

  final FeedsDataProvider feedsDataProvider;
  FeedBloc(this.feedsDataProvider) : super(FeedInitialState()) {
    on<FetchFeedDataEvent>((event, emit) async {
      emit(FeedLoadingState(loadingForEvent: event));
      Either<Failure, FeedDataModel> response =
          await feedDetails.call(const FeedParams(url: null));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        }
      }, (right) {
        feedsDataProvider.setFeedList(right.data);
        url = right.pagination?.nextPageApiUrl ?? '';
        emit(FeedDataState());
      });
    });

    on<FetchFeedDataOnLoadEvent>((event, emit) async {
      emit(MoreDataLoadingState());
      Either<Failure, FeedDataModel> response =
          await feedDetails.call(FeedParams(url: (url.isEmpty) ? null : url));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        }
      }, (right) {
        if (url.isNotEmpty) {
          feedsDataProvider.addFeedList(right.data);
          url = right.pagination!.nextPageApiUrl!;
        } else {
          feedsDataProvider.setPostPageEnded = true;
        }
        emit(FeedDataState());
      });
    });

    on<FetchMyPostOnLoadEvent>((event, emit) async {
      emit(MoreDataLoadingState());
      Either<Failure, FeedDataModel> response = await feedDetails
          .call(FeedParams(url: (myPostUrl.isEmpty) ? null : myPostUrl));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.context);
        } else {}
      }, (right) {
        if (myPostUrl.isNotEmpty) {
          feedsDataProvider.addMyPostList(right.data);
          myPostUrl = right.pagination!.nextPageApiUrl!;
        } else {
          feedsDataProvider.setPostPageEnded = true;
        }
        emit(MyPostFetchDoneState());
      });
    });

    on<FetchMyPostListEvent>((event, emit) async {
      emit(FeedLoadingState(loadingForEvent: event));
      Either<Failure, FeedDataModel> response =
          await userPostData.call(const UserPostParams(url: null));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.context);
        } else {}
      }, (right) {
        feedsDataProvider.setMyPostList(right.data);
        myPostUrl = right.pagination!.nextPageApiUrl!;
        emit(MyPostFetchDoneState());
      });
    });

    on<SubmitLikeRequestEvent>((event, emit) async {
      feedsDataProvider.likeUnLike(
          isLiked: event.isLiked, postId: event.postId);
      emit(PostLikeDoneState());

      Either<Failure, dynamic> response =
          await postLike.call(PostLikeParams(postId: event.postId));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext!);
        }
      }, (right) {});
    });

    on<FetchSinglePostEvent>((event, emit) async {
      emit(FeedLoadingState());
      Either<Failure, dynamic> response =
          await singlePost.call(SinglePostParams(postId: event.postId));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext!);
        }
        if (left is NoDataFailure) {
          emit(FeedErrorState(errorMessage: left.errorMessage));
        } else {
          emit(FeedErrorState(errorMessage: 'Something went wrong'));
        }
      }, (right) {
        feedsDataProvider.setSelectedSinglePostData(right.data);
        print("Single data..........${right.data}");
        emit(FetchedSinglePostDataState());
      });
    });

    on<PostCommentEvent>((event, emit) async {
      Either<Failure, dynamic> response = await postComment.call(
          PostCommentParams(
              postId: event.postId, commentText: event.commentText));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        }
      }, (right) {
        try {
          Comments commentData = right.data;
          feedsDataProvider.addComment(commentData: commentData, postId: event.postId);
        } catch (e) {
          print(e);
        }
        emit(PostCommentDoneState());
      });
    });

    on<DeleteUserPostEvent>((event, emit) async {
      Either<Failure, bool> response =
          await deleteUserPost.call(DeleteUserPostParams(postId: event.postId));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.context);
        }
      }, (right) {
        feedsDataProvider.deleteFeedPost(event.postId!);
         // updatePostList(postId : event.postId );
        emit(DeleteUserFeedDoneState());
      });
    });

    /// I will cal at the time of delete comment
    on<DeleteCommentEvent>((event, emit) async {
      Either<Failure, bool> response = await deleteComment
          .call(DeleteCommentParams(commentId: event.commentId));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.context);
        }
      }, (right) {
        feedsDataProvider.deleteComment(
            commentId: event.commentId, postId: event.postId!);
        emit(DeleteCommentDoneState());
      });
    });

    ///After creating post update feed data list
    on<UpdateFeedDataEvent>((event, emit) {
      feedsDataProvider.insetSingleFeedPostOnCreate(
          currentFeed: event.updatedFeedData!);
      emit(UpdatedFeedDataDoneState());
    });


    on<ResetBlocEvent>((event, emit) {
      emit(FeedInitialState());
    });


    on<ResetFeedEvent>((event, emit) async {
      // Perform any necessary cleanup in FeedsDataProvider
      feedsDataProvider.setFeedList(null); // Clear the feed list
      feedsDataProvider.setMyPostList(null); // Clear the my post list
      feedsDataProvider.setSelectedSinglePostData(null); // Clear the selected single post data
      feedsDataProvider.setPostPageEnded = false; // Reset the post page ended flag

      emit(FeedInitialState());
    });

  }



}
