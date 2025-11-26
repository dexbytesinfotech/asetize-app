import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../imports.dart';
import '../../feed/pages/comment_new_screen.dart';
import '../../feed/pages/post_like_screen.dart';
import '../../feed/widgets/post_single_widget.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;


class MyPostScreen extends StatefulWidget {
  final String? userName;

  const MyPostScreen({Key? key, this.userName}) : super(key: key);
  @override
  State createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  final ScrollController scrollController = ScrollController();
  late UserProfileBloc userProfileBloc;
  late FeedBloc feedBloc;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isShowLoader = true;
  bool isLoadMore = false;
  bool _isLoading = false;

  @override
  void initState() {
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    feedBloc = BlocProvider.of<FeedBloc>(context);
    feedBloc.add(FetchMyPostListEvent(context: context));
    feedBloc.feedsDataProvider.setPostPageEnded = false;
    scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    /// Code for load more data from API
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    final triggerScroll = maxScroll * 0.5; // 50% of scrollable area
    if (currentScroll >= triggerScroll) {
      // Trigger your onLoad or any other function
      onLoad();
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }

  Future<void> onRefresh() async {
    feedBloc.feedsDataProvider.setPostPageEnded = false;
    setState(() {
      isShowLoader = false;
    });
    feedBloc.add(FetchMyPostListEvent(context: context));
    await Future.delayed(const Duration(milliseconds: 2000));
    refreshController.refreshCompleted();
  }

//for pagination load more data
  Future<void> onLoad() async {
    if (!feedBloc.feedsDataProvider.getPostPageEnded && !isLoadMore) {
      print("Load more run ******************************");
      feedBloc.add(FetchMyPostOnLoadEvent(context: context));
      await Future.delayed(const Duration(seconds: 5));
    }
    refreshController.loadComplete();
  }

  Future<void> downloadAndShareImage(
      BuildContext context,
      String trim,
      List<String> list,
      ) async {
    setState(() {
      _isLoading = true; // Start loading if needed
    });

    String postShareText = parse('${trim}').body!.text;
    final String contentToShare = postShareText.isNotEmpty ? postShareText : AppString.noPostContent;

    try {
      if (list != null && list.isNotEmpty) {
        final List<XFile> xFiles = []; // List to hold the image files to share

        final tempDir = await getTemporaryDirectory();

        for (String imageUrl in list) {
          final String fileName = path.basename(imageUrl);
          final String filePath = path.join(tempDir.path, fileName);
          final File file = File(filePath);

          if (await file.exists()) {
            xFiles.add(XFile(filePath));
          } else {
            // Download the file if not already cached
            final response = await http.get(Uri.parse(imageUrl));
            if (response.statusCode == 200) {
              await file.writeAsBytes(response.bodyBytes); // Save the file locally
              xFiles.add(XFile(filePath)); // Add the file to the list for sharing
            } else {
              throw Exception('Failed to download image: ${response.statusCode}');
            }
          }
        }

        // Share the images with the text
        await Share.shareXFiles(
          xFiles,
          text: contentToShare,
        );
      } else {
        // If no images, just share the text
        await Share.share(contentToShare);
      }
    } catch (e) {

      WorkplaceWidgets.errorSnackBar(context, 'Error downloading or sharing images: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        appBarHeight: 50,
        appBackgroundColor: AppColors.white,
        appBar: const DetailsScreenAppBar(
          title: AppString.myPost,
        ),
        containChild: BlocBuilder<FeedBloc, FeedState>(
          bloc: feedBloc,
          builder: (BuildContext context, state) {
            if (state is MyPostFetchDoneState) {
              isShowLoader = false;
            }
            if (state is MoreDataLoadingState) {
              isLoadMore = true;
            }
            if (state is MyPostFetchDoneState) {
              isLoadMore = false;
            }
            // if(state is FeedInitialState)
            //   {
            //   feedBloc.add(FetchMyPostListEvent(context: context));
            //   }
            return Stack(
              children: [
                Stack(
                  children: [
                    SmartRefresher(
                      controller: refreshController,
                      enablePullUp: !feedBloc.feedsDataProvider.getPostPageEnded,
                      onLoading: onLoad,
                      enablePullDown: true,
                      onRefresh: onRefresh,
                      footer: const ClassicFooter(
                        loadStyle: LoadStyle.ShowWhenLoading,
                      ),
                      child: (feedBloc.feedsDataProvider.getMyPostList().isEmpty)
                          ? Center(
                              child: Text(
                                (state is FeedLoadingState)
                                    ? ''
                                    : AppString.noPosts,
                                style: appStyles.noDataTextStyle(),
                              ),
                            )
                          : ListView.separated(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  feedBloc.feedsDataProvider.getMyPostList().length,
                              itemBuilder: (context, index) {
                                return PostSingleWidget(
                                  onTapShareButton: () {
                                    downloadAndShareImage(context,feedBloc.feedsDataProvider
                                        .getMyPostList()[index]
                                        .content!
                                        .trim()
                                        ,List<String>.generate(
                                            feedBloc.feedsDataProvider
                                                .getMyPostList()[index]
                                                .feedFiles!
                                                .length,
                                                (counter) =>
                                            feedBloc.feedsDataProvider
                                                .getMyPostList()[index]
                                                .feedFiles![counter]
                                                .url ??
                                                ""),
                                    );
                                  },
                                  profilePhoto: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .feedUser
                                      ?.profilePhoto,
                                  postBy: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .feedUser
                                      ?.name,
                                  postPublishedAt: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .publishedAt,
                                  isShowMoreIcon: true,
                                  onDeleteTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (ctx) {
                                          return WorkplaceWidgets.titleContentPopup(
                                              buttonName1: AppString.yes,
                                              buttonName2: AppString.no,
                                              onPressedButton1: () {
                                                feedBloc.add(DeleteUserPostEvent(
                                                    context: context,
                                                    postId: feedBloc
                                                        .feedsDataProvider
                                                        .getMyPostList()[index]
                                                        .id));
                                                Navigator.of(ctx).pop();
                                              },
                                              onPressedButton2: () {
                                                Navigator.pop(context);
                                              },
                                              title: AppString.deletePost,
                                              content:
                                                  AppString.areYouSureToDeletePost);
                                        });
                                  },
                                  fileCount: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .fileCount,
                                  postTitle: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .title!
                                      .trim(),
                                  postDescription: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .content!
                                      .trim(),
                                  postType: List<String>.generate(
                                      feedBloc.feedsDataProvider
                                          .getMyPostList()[index]
                                          .feedFiles!
                                          .length,
                                      (counter) =>
                                          feedBloc.feedsDataProvider
                                              .getMyPostList()[index]
                                              .feedFiles![counter]
                                              .type ??
                                          ""),
                                  postImages: (feedBloc.feedsDataProvider
                                          .getMyPostList()[index]
                                          .feedFiles!
                                          .isEmpty)
                                      ? []
                                      : List<String>.generate(
                                          feedBloc.feedsDataProvider
                                              .getMyPostList()[index]
                                              .feedFiles!
                                              .length,
                                          (counter) =>
                                              feedBloc.feedsDataProvider
                                                  .getMyPostList()[index]
                                                  .feedFiles![counter]
                                                  .url ??
                                              ""),
                                  isLike: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .isLike,
                                  likeCount: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .likeCount,
                                  commentCount: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .commentCount,
                                  isLikeVisible: feedBloc.feedsDataProvider
                                              .getMyPostList()[index]
                                              .likeCount ==
                                          0
                                      ? false
                                      : true,
                                  isCommentVisible: feedBloc.feedsDataProvider
                                              .getMyPostList()[index]
                                              .commentCount ==
                                          0
                                      ? false
                                      : true,
                                  likeTitle: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .likeTitle,
                                  commentTitle: feedBloc.feedsDataProvider
                                      .getMyPostList()[index]
                                      .commentTitle,
                                  onTap: (isLiked) async {
                                    //like unlike the post
                                    // isShowLoader = false;
                                    BlocProvider.of<FeedBloc>(context).add(
                                        SubmitLikeRequestEvent(
                                            mContext: context,
                                            postId: feedBloc.feedsDataProvider
                                                    .getMyPostList()[index]
                                                    .id ??
                                                0,
                                            index: index,
                                            isLiked: !isLiked));
                                    return !isLiked;
                                  },
                                  onTapLikeScreen: () {
                                    //Navigate to like screen
                                    if (feedBloc.feedsDataProvider
                                            .getMyPostList()[index]
                                            .likes
                                            ?.isNotEmpty ==
                                        true) {
                                      Navigator.push(
                                          MainAppBloc.getDashboardContext,
                                          SlideLeftRoute(
                                              widget:  PostLikeScreen(
                                                    likes: feedBloc
                                                        .feedsDataProvider
                                                        .getMyPostList()[index]
                                                        .likes,
                                                  )));
                                    }
                                  },
                                  onTapCommentScreen: () {
                                    Navigator.push(
                                        MainAppBloc.getDashboardContext,
                                        SlideLeftRoute(
                                            widget: CommentNewScreen(
                                              showCommentDeletePopup: true,
                                                  isRemoveCommentSection: true,
                                                  showFullDescription: true,
                                                  postId: feedBloc.feedsDataProvider
                                                      .getMyPostList()[index]
                                                      .id,
                                                  focusOnTextField: true,
                                                )));
                                  },
                                  onPostTextClick: () {
                                    Navigator.push(
                                        MainAppBloc.getDashboardContext,
                                        SlideLeftRoute(
                                            widget: CommentNewScreen(
                                                  showCommentDeletePopup: true,
                                                  showFullDescription: true,
                                                  postId: feedBloc.feedsDataProvider
                                                      .getMyPostList()[index]
                                                      .id,
                                                  focusOnTextField: false,
                                                )));
                                  },
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 8,
                                  color: Colors.grey.shade300,
                                );
                              },
                            ),
                    ),
                    loaderView(state)
                  ],
                ),
                const NetworkStatusAlertView()
              ],
            );
          },
        ));
  }

  Widget loaderView(FeedState state) {
    if (isShowLoader && state is FeedLoadingState && state.loadingForEvent is FetchMyPostListEvent) {
      return WorkplaceWidgets.progressLoader(context);
    }
    return const SizedBox();
  }
}
