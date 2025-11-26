import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:asetize/features/feed/pages/post_like_screen.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../tag_text_field/widgets/tag_text_field.dart';
import '../../../imports.dart';
import '../../my_post/models/get_feed_data_model.dart';
import '../widgets/post_profile.dart';
import '../widgets/post_single_widget.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class CommentNewScreen extends StatefulWidget {
  final bool showFullDescription;
  final bool showCommentDeletePopup;
  final bool isRemoveCommentSection;
  final int? postId;
  final int? commentId;
  final bool? focusOnTextField;
  const CommentNewScreen({
    super.key,
    this.postId,
    this.commentId,
    this.showCommentDeletePopup = false,
    this.focusOnTextField,
    this.isRemoveCommentSection = true,
    this.showFullDescription = false,
  });

  @override
  State<CommentNewScreen> createState() => _CommentNewScreenState();
}

class _CommentNewScreenState extends State<CommentNewScreen> {
  ScrollController scrollController = ScrollController();
  bool isShowLoader = true;
  late FeedBloc bloc;
  bool _isLoading = false;
  @override
  void initState() {
    bloc = BlocProvider.of<FeedBloc>(context);
    bloc.add(
        FetchSinglePostEvent(mContext: context, postId: widget.postId ?? 0));
    if (widget.commentId != null) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(microseconds: 50), curve: Curves.easeOut);
      });
    }
    super.initState();
    OneSignalNotificationsHandler.instance.refreshPage = refreshData;
  }

  Future<void> refreshData() async {
    isShowLoader = false;
    bloc.add(FetchSinglePostEvent(mContext: context, postId: widget.postId ?? 0));
  }

  @override
  void dispose() {
    bloc.feedsDataProvider.setSelectedSinglePostData(null);
    scrollController.dispose();
    super.dispose();
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
              await file
                  .writeAsBytes(response.bodyBytes); // Save the file locally
              xFiles
                  .add(XFile(filePath)); // Add the file to the list for sharing
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
    Widget commentCard({List<Comments>? comments}) => (comments!.isEmpty)
        ? Column(
            children: [
              Text(AppString.beTheFirstToComment,
                style: appStyles.noDataTextStyle(),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 65, left: 20, right: 20),
            scrollDirection: Axis.vertical,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              // Function to replace the placeholders
              String commentStr = projectUtil.replaceTaggedIdByNameInMassage(
                  inputString:
                      comments[index].comment!.replaceAll('\n', '<br>'),
                  mentionsUserList: BlocProvider.of<MainAppBloc>(context)
                      .mainAppDataProvider!
                      .getTeamMemberList());
              return InkWell(
                onLongPress: () {
                  if (comments[index].isMyComment == true ||
                      widget.showCommentDeletePopup) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (ctx) {
                          return WorkplaceWidgets.titleContentPopup(
                              buttonName1: AppString.yes,
                              buttonName2: AppString.no,
                              onPressedButton1: () {
                                bloc.add(DeleteCommentEvent(
                                    context: context,
                                    commentId: comments[index].commentId,
                                    postId: widget.postId));
                                Navigator.of(ctx).pop();
                              },
                              onPressedButton2: () {
                                Navigator.pop(context);
                              },
                              title: AppString.deleteComment,
                              content: AppString.areYouSureDeleteComment);
                        });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: PostProfile(
                        imageUrl: comments[index].user!.profilePhoto,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 45,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${comments[index].user!.name}',
                              style: appStyles.userNameTextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${comments[index].createdAt}',
                              style: TextStyle(
                                  color: const Color(0xFF575757),
                                  fontSize: 11,
                                  fontFamily: appFonts.defaultFont,
                                  fontWeight: appFonts.regular400,
                                  height: .5),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            HtmlWidget(commentStr,
                                textStyle: appStyles.userNameTextStyle()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            });

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      controller: scrollController,
      appBarHeight: 50,
      appBar: const DetailsScreenAppBar(
        title: " ",
      ),
      containChild: BlocConsumer<FeedBloc, FeedState>(
        bloc: bloc,
        listener: (BuildContext context, FeedState state) {
          if (state is FeedErrorState) {
            // WorkplaceWidgets.errorPopUp(
            //   context: context,
            //   content: '${state.errorMessage}',
            //   onTap: () {
            //     Navigator.of(context).pop();
            //   },
            // );
          }
        },
        builder: (BuildContext context, FeedState state) {
          if (state is FeedLoadingState) {
            if (_isLoading || isShowLoader) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
          if (state is FetchedSinglePostDataState) {
            commentScrollUp();
          }
          if ((bloc.feedsDataProvider.getSelectedSinglePostData() == null)) {
            return Center(
                  child: Text(
                  (state is FeedErrorState)
                      ? state.errorMessage
                      : AppString.noPost,
                  style:appStyles.noDataTextStyle(),
                ));
          } else {
            return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 75),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PostSingleWidget(
                              onTapShareButton: () {
                                downloadAndShareImage(
                                    context,
                                    bloc.feedsDataProvider
                                            .getSelectedSinglePostData()
                                            ?.content!
                                            .trim() ??
                                        '',
                                    List<String>.generate(
                                        bloc.feedsDataProvider
                                                .getSelectedSinglePostData()
                                                ?.feedFiles
                                                ?.length ??
                                            0,
                                        (counter) =>
                                            bloc.feedsDataProvider
                                                .getSelectedSinglePostData()!
                                                .feedFiles![counter]
                                                .url ??
                                            ""));
                              },
                              profilePhoto: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.feedUser
                                  ?.profilePhoto,
                              postBy: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.feedUser
                                  ?.name,
                              postPublishedAt: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.publishedAt,
                              fileCount: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.fileCount,
                              postTitle: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.title!
                                  .trim(),
                              postDescription: bloc.feedsDataProvider
                                      .getSelectedSinglePostData()
                                      ?.content!
                                      .trim() ??
                                  "",
                              postType: List<String>.generate(
                                  bloc.feedsDataProvider
                                          .getSelectedSinglePostData()
                                          ?.feedFiles
                                          ?.length ??
                                      0,
                                  (counter) =>
                                      bloc.feedsDataProvider
                                          .getSelectedSinglePostData()!
                                          .feedFiles![counter]
                                          .type ??
                                      ""),
                              postImages: List<String>.generate(
                                  bloc.feedsDataProvider
                                          .getSelectedSinglePostData()
                                          ?.feedFiles
                                          ?.length ??
                                      0,
                                  (counter) =>
                                      bloc.feedsDataProvider
                                          .getSelectedSinglePostData()!
                                          .feedFiles![counter]
                                          .url ??
                                      ""),
                              isLike: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.isLike,
                              likeCount: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.likeCount,
                              isLikeVisible: bloc.feedsDataProvider
                                          .getSelectedSinglePostData()
                                          ?.likeCount ==
                                      0
                                  ? false
                                  : true,
                              isCommentVisible: bloc.feedsDataProvider
                                          .getSelectedSinglePostData()
                                          ?.commentCount ==
                                      0
                                  ? false
                                  : true,
                              commentCount: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.commentCount,
                              likeTitle: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.likeTitle,
                              commentTitle: bloc.feedsDataProvider
                                  .getSelectedSinglePostData()
                                  ?.commentTitle,
                              onTap: (isLiked) async {
                                isShowLoader = false;
                                bloc.add(SubmitLikeRequestEvent(
                                    mContext: context,
                                    postId: bloc.feedsDataProvider
                                            .getSelectedSinglePostData()
                                            ?.id ??
                                        0,
                                    index: 0,
                                    isLiked: !(isLiked)));
                                return !isLiked;
                              },
                              onTapLikeScreen: () {
                                if (bloc.feedsDataProvider
                                        .getSelectedSinglePostData()!
                                        .likes
                                        ?.isNotEmpty ==
                                    true) {
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget: PostLikeScreen(
                                              likes: bloc.feedsDataProvider
                                                      .getSelectedSinglePostData()!
                                                      .likes ??
                                                  [])));
                                }
                              },
                              isRemoveCommentSection:
                                  widget.isRemoveCommentSection,
                              showFullDescription: widget.showFullDescription,
                              onTapCommentScreen: () {
                                // FocusScope.of(context).requestFocus(fComment);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: bloc.feedsDataProvider
                                              .getSelectedSinglePostData()
                                              ?.comments?.isEmpty == true
                                      ?  Text(
                                          AppString.comments,
                                          style: appTextStyle.appNormalSmallTextStyle(),
                                        )
                                      : Text(
                                          '${AppString.comments} (${bloc.feedsDataProvider.getSelectedSinglePostData()?.comments?.length})',
                                          style: appTextStyle.appNormalSmallTextStyle(),
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            commentCard(
                                comments: bloc.feedsDataProvider
                                        .getSelectedSinglePostData()
                                        ?.comments ??
                                    []),
                          ],
                        ),
                      ),
                    ],
                  ));
          }
        },
      ),
      bottomMenuView: BlocBuilder<FeedBloc, FeedState>(
        bloc: bloc,
        builder: (BuildContext context, FeedState state) {
          if (state is FetchedSinglePostDataState) {
            commentScrollUp();
          }
          return (bloc.feedsDataProvider.getSelectedSinglePostData() == null)
              ? const SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(
                                color: Colors.grey.withOpacity(0.3))),
                      ),
                      child: TagTextField(
                        minLines: 1,
                        maxLines: 5,
                        leadingWidget: const [SizedBox(width: 20)],
                        focusOnTextField: widget.focusOnTextField,
                        searchResults: (List<User> list) {},
                        onPostClick: (content) {
                          setState(() {
                            commentScrollUp();
                          });
                          bloc.add(PostCommentEvent(
                              mContext: context,
                              commentText: content.trim(),
                              postId: widget.postId ?? 0));
                        },
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }

  void commentScrollUp() {
    // Wait until after the first frame (screen load) to call the API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.focusOnTextField == true) {
        try {
          Future.delayed(const Duration(seconds: 2)).then((value) {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(microseconds: 50),
                curve: Curves.easeOut);
          });
        } catch (e) {
          debugPrint('$e');
        }
      }
    });
  }
}
