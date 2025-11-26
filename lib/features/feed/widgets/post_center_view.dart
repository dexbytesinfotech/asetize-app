import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../../../imports.dart';
import '../../../core/util/app_theme/text_style.dart';

class PostCenterView extends StatefulWidget {
  final bool showFullDescription;
  final String? postBy;
  final String? fileCount;
  final String? postTitle;
  final String postDescription;
  final List<String>? postImages;
  final List<String>? postType;
  final Function()? onPostTextClick;
  final Widget? postStatus;
  const PostCenterView({
    Key? key,
    required this.postDescription,
    this.postTitle,
    this.postBy,
    this.postImages,
    this.fileCount,
    this.postType,
    this.showFullDescription = false,
    this.onPostTextClick,
   this.postStatus,
  }) : super(key: key);

  @override
  State createState() => _PostCenterViewState(
      postDescription, postTitle, postImages, fileCount, postType);
}

class _PostCenterViewState extends State<PostCenterView> {
  String? fileCount;
  String? postTitle;
  String postDescription;
  List<String>? postImages;
  List<String>? postType;

  String firstHalf = "";
  String secondHalf = "";
  bool flag = true;

  _PostCenterViewState(this.postDescription, this.postTitle, this.postImages,
      this.fileCount, this.postType);

  @override
  void didUpdateWidget(covariant PostCenterView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    String commentStr = projectUtil.replaceTaggedIdByNameInMassage(
        inputString: widget.postDescription,
        mentionsUserList: BlocProvider.of<MainAppBloc>(context)
            .mainAppDataProvider!
            .getTeamMemberList());

    setState(() {
      postDescription = commentStr.trim();
      postTitle = widget.postTitle;
      postImages = widget.postImages;
      fileCount = widget.fileCount;
      postType = widget.postType;

      if (postDescription.length > 350) {
        firstHalf = postDescription.substring(0, 350);
        secondHalf = postDescription.substring(350, postDescription.length);
      } else {
        firstHalf = postDescription;
        secondHalf = "";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    postDescription = projectUtil.replaceTaggedIdByNameInMassage(
        inputString: postDescription,
        mentionsUserList: BlocProvider.of<MainAppBloc>(context)
            .mainAppDataProvider!
            .getTeamMemberList());

    if (postDescription.length > 350) {
      firstHalf = postDescription.substring(0, 350);
      secondHalf = postDescription.substring(350, postDescription.length);
    } else {
      firstHalf = postDescription;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Convert color to RGBA format (black with 80% opacity)
    String rgbaColor =
        "rgba(${AppColors.appBlack.red}, ${AppColors.appBlack.green}, ${AppColors.appBlack.blue}, 0.8)";
    String? title = postTitle?.replaceAll('\n', '<br>');
    String justifyTitle = '''
    <div style="text-align: justify; font-size: 14px; color: $rgbaColor; font-family: 'Roboto';">
       $title
    </div>
    ''';

    String justifyFirstHalf = '''
    <div style="text-align: justify; font-size: 14px; color: black; font-family: 'Roboto';">
       $firstHalf
    </div>
    ''';

    String justifySecondHalf = '''
    <div style="text-align: justify; font-size: 14px; color: black; font-family: 'Roboto';">
       $secondHalf
    </div>
    ''';

    String firstAndSecond = '''
    <div style="text-align: justify; font-size: 14px; color: black; font-family: 'Roboto';">
       $firstHalf$secondHalf
    </div>
    ''';

    Widget sliderView() => PinchZoomReleaseUnzoomWidget(
          fingersRequiredToPinch: 2,
          child: SliderScreen(
            initialPage: 0,
            postBy: widget.postBy,
            activeDotColor: AppColors.appBlueColor,
            inActiveDotColor: Colors.grey,
            imageHeight: postType?[0] == "video" ? 500 : 400,
            urlImages: postImages ??
                [
                ],
            viewType: postType,
            isDotOverlay: true, // to show dot outside or inside the images
            isDotVisible: true,
            dotBackgroundVisible: false,
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.onPostTextClick,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (postTitle != null || postTitle?.isNotEmpty == true)
                  ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: HtmlWidget(
                          postTitle!,
                          textStyle: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              color: AppColors.appBlack.withOpacity(0.8)),
                        )),
                    widget.postStatus ?? const SizedBox(),
                  ],
                ),
              )
                  : const SizedBox(),
              SizedBox(
                height: (postTitle != null &&
                        postTitle?.isNotEmpty == true &&
                        postDescription.isNotEmpty == true)
                    ? 4
                    : 0,
              ),
              (widget.showFullDescription == true)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child: HtmlWidget(
                            projectUtil.replaceTaggedIdByNameInMassage(
                                inputString:
                                    firstAndSecond, //widget.postDescription,
                                mentionsUserList:
                                    BlocProvider.of<MainAppBloc>(context)
                                        .mainAppDataProvider!
                                        .getTeamMemberList()),
                            textStyle: appTextStyle.appNormalSmallTextStyle(),
                          )),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        if (postDescription.isNotEmpty == true)
                          (secondHalf.isEmpty)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                          child: HtmlWidget(
                                        justifyFirstHalf,
                                      ))
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: HtmlWidget(
                                        flag
                                            ? '''
                                            <div style="text-align: justify; font-size: 14px; color: black; font-family: 'Roboto';">
                                               $firstHalf...
                                            </div>
                                            '''
                                            : firstAndSecond,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          flag = !flag;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              flag ? "show more" : "show less",
                                              style: appTextStyle.appNormalSmallTextStyle(
                                                  color: AppColors.appBlueColor,
                                                 ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                      ],
                    )
            ],
          ),
        ),
        if (postImages?.isNotEmpty == true) const SizedBox(height: 20),
        if (postImages?.isNotEmpty == true) sliderView(),
      ],
    );
  }
}
