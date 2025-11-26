// ignore_for_file: prefer_const_constructors
import 'package:flutter/rendering.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../../create_post/bloc/create_post_bloc.dart';
import '../../create_post/pages/create_post_screen.dart';
import '../../create_post/widgets/post_process_view.dart';
import '../../my_post/models/get_feed_data_model.dart';
import '../widgets/post_single_widget.dart';
import 'comment_new_screen.dart';
import 'post_like_screen.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class FeedNewScreen extends StatefulWidget {
  const FeedNewScreen({Key? key}) : super(key: key);

  @override
  State<FeedNewScreen> createState() => _FeedNewScreenState();
}

class _FeedNewScreenState extends State<FeedNewScreen> {
  final ScrollController scrollController = ScrollController();
  late MainAppBloc mainAppBloc;
  late UserProfileBloc userProfileBloc;
  late FeedBloc feedBloc;
  // late SpotlightBloc spotlightBloc;
  bool isShowLoader = true;
  bool isPullToRefresh = false;
  bool isLoadMore = false;
  bool _isLoading = false;
  bool isClean = false;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> onRefresh() async {
    if (!isPullToRefresh) {
      setState(() {
        isShowLoader = false;
        isClean = true;
      });
      feedBloc.feedsDataProvider.setPostPageEnded = false;
      isPullToRefresh = true;
      feedBloc.add(FetchFeedDataEvent(mContext: context));
      //spotlightBloc.add(FetchSpotlightRecentDataEvent(mContext: context));
      await Future.delayed(const Duration(milliseconds: 2000));
      isPullToRefresh = false;
      refreshController.refreshCompleted();
    }
  }

  //for pagination load more data
  Future<void> onLoad() async {
    if (!feedBloc.feedsDataProvider.getPostPageEnded && !isLoadMore) {
      print("Load more run ******************************");
      feedBloc.add(FetchFeedDataOnLoadEvent(mContext: context));
      await Future.delayed(const Duration(seconds: 5));
    }
    refreshController.loadComplete();
  }

  String profilePhoto = "";
  @override
  void initState() {
    mainAppBloc = BlocProvider.of<MainAppBloc>(context);
    feedBloc = BlocProvider.of<FeedBloc>(context);
    //spotlightBloc = BlocProvider.of<SpotlightBloc>(context);
    feedBloc.feedsDataProvider.setPostPageEnded = false;
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    scrollController.addListener(_onScroll);
    super.initState();
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }

  Future<void> refreshDataOnNotificationComes() async {
    await onRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }

  void _onScroll() {
    // if (scrollController.hasClients) {
    //   /// Code for hide show appbar
    //   if (scrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     mainAppBloc.add(BottomMenuShowHideEvent(
    //         isMenuShow: false, scrollController: scrollController));
    //   } else {
    //     mainAppBloc.add(BottomMenuShowHideEvent(
    //         isMenuShow: true, scrollController: scrollController));
    //   }

    /// Code for load more data from API
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    final triggerScroll = maxScroll * 0.5; // 50% of scrollable area
    if (currentScroll >= triggerScroll) {
      // Trigger your onLoad or any other function
      onLoad();
    }
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
    final String contentToShare =
        postShareText.isNotEmpty ? postShareText : AppString.noPostContent;

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
              await file
                  .writeAsBytes(response.bodyBytes); // Save the file locally
              xFiles
                  .add(XFile(filePath)); // Add the file to the list for sharing
            } else {
              throw Exception(
                  'Failed to download image: ${response.statusCode}');
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
    double bottomMenuHeight2 = Platform.isAndroid
        ? 75
        : MediaQuery.of(context).size.height < 670
            ? 70
            : 95;

    return BlocBuilder<MainAppBloc, MainAppState>(
        builder: (context, mainAppState) {
      if (mainAppState is BottomMenuShowHideState) {
        bottomMenuHeight2 = mainAppState.isMenuShow
            ? Platform.isAndroid
                ? 75
                : MediaQuery.of(context).size.height < 670
                    ? 70
                    : 95
            : 0;
      }
      return ContainerFirst(
          contextCurrentView: context,
          isSingleChildScrollViewNeed: false,
          isListScrollingNeed: true,
          isOverLayStatusBar: true,
          isFixedDeviceHeight: false,
          bottomBarSafeAreaColor: Colors.transparent,
          appBarHeight: bottomMenuHeight2,
          bottomSafeAreaHeight: 0,
          appBar: silverAppBar(),
          // appBarScrollController: scrollController,
          appBackgroundColor: AppColors.white,
          containChild: BlocListener<CreatePostBloc, CreatePostState>(
            listener: (BuildContext context, state) {
              if (state is CreatePostErrorState) {
                WorkplaceWidgets.errorSnackBar(context, state.errorMessage ?? "");
              }
            },
            child: BlocBuilder<FeedBloc, FeedState>(
              bloc: feedBloc,
              builder: (context, state) {
                if (state is FeedInitialState) {
                  feedBloc.add(FetchFeedDataEvent(mContext: context));
                }
                if (state is MoreDataLoadingState) {
                  isLoadMore = true;
                }
                if (state is FeedDataState) {
                  isLoadMore = false;
                }
                return Stack(
                  children: [
                    SmartRefresher(
                        controller: refreshController,
                        enablePullUp:
                            !feedBloc.feedsDataProvider.getPostPageEnded,
                        enablePullDown: true,
                        onRefresh: onRefresh,
                        onLoading: onLoad,
                        footer: const ClassicFooter(
                          loadStyle: LoadStyle.ShowWhenLoading,
                        ),
                        child: (feedBloc.feedsDataProvider
                                .getFeedPostList()
                                .isEmpty)
                            ? Column(children: [
                                // SpotlightOverlayView(),
                                PostProcessView(),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.2,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      (state is FeedLoadingState)
                                          ? ''
                                          : AppString.noPosts,
                                      style: appStyles.noDataTextStyle(),
                                    ),
                                  ),
                                )
                              ])
                            : ListView.separated(
                                controller: scrollController,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    height: 8,
                                    color: Colors.grey.shade300,
                                  );
                                },
                                // physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.only(bottom: 45),
                                scrollDirection: Axis.vertical,
                                itemCount: feedBloc.feedsDataProvider
                                    .getFeedPostList()
                                    .length,
                                itemBuilder: (context, index) {
                                  FeedData feedData = feedBloc.feedsDataProvider
                                      .getFeedPostList()[index];
                                  return Column(
                                    children: [
                                      if (index == 0)
                                        Column(
                                          children: const [
                                            //SpotlightOverlayView(),
                                            PostProcessView(),
                                          ],
                                        ),
                                      PostSingleWidget(
                                        onTapShareButton: () {
                                          downloadAndShareImage(
                                              context,
                                              feedData.content!.trim(),
                                              List<String>.generate(
                                                  feedData.feedFiles!.length,
                                                  (counter) =>
                                                      feedData
                                                          .feedFiles![counter]
                                                          .url ??
                                                      ""));
                                        },
                                        profilePhoto:
                                            feedData.feedUser?.profilePhoto,
                                        postBy: feedData.feedUser?.name,
                                        postPublishedAt: feedData.publishedAt,
                                        fileCount: feedData.fileCount,
                                        postTitle: feedData.title!.trim(),
                                        postDescription:
                                            feedData.content!.trim(),
                                        postType: List<String>.generate(
                                            feedBloc.feedsDataProvider
                                                .getFeedPostList()[index]
                                                .feedFiles!
                                                .length,
                                            (counter) =>
                                                feedData
                                                    .feedFiles![counter].type ??
                                                ""),

                                        /// video /image url
                                        postImages: (feedBloc.feedsDataProvider
                                                .getFeedPostList()[index]
                                                .feedFiles!
                                                .isEmpty)
                                            ? []
                                            : List<String>.generate(
                                                feedData.feedFiles!.length,
                                                (counter) =>
                                                    feedData.feedFiles![counter]
                                                        .url ??
                                                    ""),
                                        isLike: feedData.isLike,
                                        likeCount: feedData.likeCount,
                                        isLikeVisible: feedData.likeCount == 0
                                            ? false
                                            : true,
                                        isCommentVisible:
                                            feedData.commentCount == 0
                                                ? false
                                                : true,
                                        commentCount: feedData.commentCount,
                                        likeTitle: feedData.likeTitle,
                                        commentTitle: feedData.commentTitle,
                                        onTap: (isLiked) async {
                                          isShowLoader = false;
                                          feedBloc.add(SubmitLikeRequestEvent(
                                              mContext: context,
                                              postId: feedData.id ?? 0,
                                              index: index,
                                              isLiked: !isLiked));
                                          return !isLiked;
                                        },
                                        onTapLikeScreen: () {
                                          if (feedBloc.feedsDataProvider
                                              .getFeedPostList()[index]
                                              .likes!
                                              .isNotEmpty) {
                                            Navigator.push(
                                                MainAppBloc.getDashboardContext,
                                                SlideLeftRoute(
                                                    widget:
                                                        PostLikeScreen(
                                                          likes: feedBloc
                                                              .feedsDataProvider
                                                              .getFeedPostList()[
                                                                  index]
                                                              .likes,
                                                        )));
                                          }
                                        },
                                        onTapCommentScreen: () {
                                          Navigator.push(
                                              MainAppBloc.getDashboardContext,
                                              SlideLeftRoute(
                                                  widget:
                                                      CommentNewScreen(
                                                        showFullDescription:
                                                            true,
                                                        isRemoveCommentSection:
                                                            true,
                                                        postId: feedBloc
                                                            .feedsDataProvider
                                                            .getFeedPostList()[
                                                                index]
                                                            .id,
                                                        focusOnTextField: true,
                                                      )));
                                        },
                                        onPostTextClick: () {
                                          Navigator.push(
                                              MainAppBloc.getDashboardContext,
                                              SlideLeftRoute(
                                                  widget:
                                                      CommentNewScreen(
                                                        showFullDescription:
                                                            true,
                                                        postId: feedBloc
                                                            .feedsDataProvider
                                                            .getFeedPostList()[
                                                                index]
                                                            .id,
                                                        focusOnTextField: false,
                                                      )));
                                        },
                                      ),
                                    ],
                                  );
                                })),
                    loaderView(state),
                    NetworkStatusAlertView(
                      onReconnect: (){
                        onRefresh();
                      },
                    )
                  ],
                );
              },
            ),
          ));
    });
  }

  Widget silverAppBar() => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey.shade200))),
        padding: EdgeInsets.only(bottom: 12, left: 15, right: 5,top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppString.posts,
              textAlign: TextAlign.center,
              style: appTextStyle.appBarTitleStyle(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    MainAppBloc.getDashboardContext,
                    SlideLeftRoute(
                        widget:  const CreatePostScreen()));
              },
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  AppString.createPost,
                  style: appTextStyle.appNormalTextStyle(
                      color: AppColors.appBlueColor),
                ),
              ),
            )
          ],
        ),
      );

  Widget appBar() {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 17, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppString.posts,
              textAlign: TextAlign.center,
              style: appTextStyle.appBarTitleStyle(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    MainAppBloc.getDashboardContext,
                    SlideLeftRoute(
                        widget:const CreatePostScreen()));
              },
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  AppString.createPost,
                  style: appTextStyle.appNormalTextStyle(
                      color: AppColors.appBlueColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget loaderView(FeedState state) {
    if (isShowLoader &&
        (_isLoading ||
            state is FeedLoadingState &&
                state.loadingForEvent is FetchFeedDataEvent)) {
      return WorkplaceWidgets.progressLoader(context);
    }
    return const SizedBox();
  }
}
