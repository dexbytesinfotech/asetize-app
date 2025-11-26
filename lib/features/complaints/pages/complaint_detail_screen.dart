import 'package:flutter/cupertino.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:asetize/imports.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../feed/widgets/post_center_view.dart';
import '../../feed/widgets/post_header.dart';
import '../../feed/widgets/post_profile.dart';
import '../../follow_up/pages/add_new_task.dart';
import '../../tag_text_field/widgets/tag_text_field.dart';
import '../bloc/complaint_bloc/complaint_bloc.dart';
import '../bloc/complaint_bloc/complaint_event.dart';
import '../bloc/complaint_bloc/complaint_state.dart';
import '../models/complaint_data_model.dart';
import '../widgets/mark_resolve_bottom_sheet.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final int? complaintId;

  const ComplaintDetailScreen({super.key, required this.complaintId});

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  late ComplaintBloc complaintBloc;
  ScrollController scrollController = ScrollController();
  bool isShowLoader = true;

  @override
  void initState() {
    complaintBloc = BlocProvider.of<ComplaintBloc>(context);
    complaintBloc.add(FetchComplaintDetailEvent(mContext: context, complaintId: widget.complaintId ?? 0));
    super.initState();
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }

  Future<void> refreshDataOnNotificationComes() async {
    isShowLoader = false;
    complaintBloc.add(FetchComplaintDetailEvent(mContext: context, complaintId: widget.complaintId ?? 0));
  }

  void scroll() {
    try {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 100), curve: Curves.easeOut);
    } catch (e) {
      debugPrint('$e');
    }
  }


  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 10),
      child: Row(
        children: [
          Flexible(
            child: AppButton(
              buttonName: "Mark as resolve",
              backCallback: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => const MarkResolveBottomSheet(),
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))));
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: AppButton(
              buttonName: 'Share Update',
              backCallback: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => const MarkResolveBottomSheet(),
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))));
              },
            ),
          ),
        ],
      ),
    );
  }

  Color statusColor({required String status}) {
    switch (status.toLowerCase()) {
      case "open":
        return Colors.red.safeOpacity(0.9);
      case "inprogress":
        return const Color(0xff0277BD);
      case "completed":
        return Colors.green.safeOpacity(0.9);
      case "reopened":
        return Colors.red.safeOpacity(0.9);
      default:
        return Colors.grey.shade50;
    }
  }

  Color statusTextColor({required String status}) {
    switch (status.toLowerCase()) {
      case "open":
        return Colors.white.safeOpacity(0.9);
      case "inprogress":
        return Colors.white; // Contrast with yellow
      case "completed":
        return Colors.white.safeOpacity(0.9);
      case "reopened":
        return Colors.white.safeOpacity(0.9); // Contrast with green
      default:
        return Colors.black; // Default text color
    }
  }

  void showStatusChangeSheet(BuildContext context) {
    // Define all possible statuses
    List<String> statuses = ["open", "inprogress", "completed"];
    statuses.remove(complaintBloc.compliantDetailData?.status?.toLowerCase());
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          message: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppString.updateStatus,
              style: appTextStyle.appNormalTextStyle(
                  color: AppColors.textBlueColor),
            ),
          ),
          actions: statuses.map((status) {
            // Remove dash and capitalize the first letter
            String formattedStatus = status == "inprogress"
                ? "In Progress"
                : status.replaceAll('-', ' ');
            formattedStatus =
                formattedStatus[0].toUpperCase() + formattedStatus.substring(1);

            return CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<ComplaintBloc>(context).add(
                  ChangeComplaintStatusEvent(
                    mContext: context,
                    status: status.replaceAll('-', ''),
                    id: complaintBloc.compliantDetailData?.id ?? 0,
                  ),
                );
                FocusScope.of(context).unfocus();
              },
              child: Text(
                formattedStatus,
                style: appTextStyle.appNormalSmallTextStyle(),
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppString.cancel,
              style: appTextStyle.appNormalSmallTextStyle(), // Text color
            ),
          ),
        );
      },
    );
  }

  void showStatusChangeSheet2(BuildContext context) {
    List<String> statuses = ["re-opened"];
    // if(complaintBloc.compliantDetailData?.isMyComplain == true && complaintBloc.compliantDetailData?.status?.toLowerCase() =="completed" )
    // {
    //   statuses = ["re-opened"];
    // }
    // // else if(complaintBloc.compliantDetailData?.isMyComplain == true && complaintBloc.compliantDetailData?.status?.toLowerCase() != "completed" )
    // //   {
    // //     statuses =  ["inprogress", "completed","re-opened"];
    // //     statuses.remove(complaintBloc.compliantDetailData?.status?.toLowerCase());
    // //   }
    // else{
    //   statuses = ["open", "inprogress", "completed"];
    //   // Remove the current status from the list
    //   statuses.remove(complaintBloc.compliantDetailData?.status?.toLowerCase());
    // }

    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          message: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppString.updateStatus,
              style: appTextStyle.appNormalTextStyle(
                  color: AppColors.textBlueColor),
            ),
          ),
          actions: statuses.map((status) {
            // Remove dash and capitalize the first letter
            String formattedStatus = status.replaceAll('-', ' ');
            formattedStatus =
                formattedStatus[0].toUpperCase() + formattedStatus.substring(1);

            return CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<ComplaintBloc>(context).add(
                  ChangeComplaintStatusEvent(
                    mContext: context,
                    status: status.replaceAll('-', ''),
                    id: complaintBloc.compliantDetailData?.id ?? 0,
                  ),
                );
                FocusScope.of(context).unfocus();
              },
              child: Text(
                formattedStatus,
                style: appTextStyle.appNormalSmallTextStyle(),
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppString.cancel,
              style: appTextStyle.appNormalSmallTextStyle(), // Text color
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget commentCard({required List<ComplaintComments> comments}) => comments
            .isEmpty
        ? Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              Text(
                AppString.beFirstComment,
                style: appStyles.noDataTextStyle(),
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
              String commentStr = projectUtil.replaceTaggedIdByNameInMassage(
                  inputString:
                      comments[index].comment!.replaceAll('\n', '<br>'),
                  mentionsUserList: BlocProvider.of<MainAppBloc>(context)
                      .mainAppDataProvider!
                      .getTeamMemberList());

              return InkWell(
                onLongPress: () {
                  if (comments[index].isMyComment == true) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (ctx) {
                          return WorkplaceWidgets.titleContentPopup(
                              buttonName1: AppString.yes,
                              onPressedButton1Color: Colors.red,
                              buttonName2: AppString.no,
                              onPressedButton1: () {
                                complaintBloc.add(DeleteComplaintCommentEvent(
                                  mContext: context,
                                  commentId: comments[index].commentId ?? 0,
                                  complaintId: widget.complaintId ?? 0,
                                  status: complaintBloc
                                          .compliantDetailData?.status ??
                                      '',
                                ));

                                Navigator.of(ctx).pop();
                              },
                              onPressedButton2: () {
                                Navigator.pop(context);
                              },
                              title: 'Delete Comment',
                              content:
                                  'Are your sure you want to Comment your post?');
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
                            color: Colors.grey.safeOpacity(0.1),
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
                              style: appTextStyle.appSubTitleStyle(
                                color: const Color(0xFF575757),
                                fontSize: 11,
                                fontWeight: appFonts.regular400,
                              ),
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

    Widget complaintNewCard() {
      return Column(
        children: [
          PostHeader(
            profilePhoto: complaintBloc.compliantDetailData?.profilePhoto,
            postBy: complaintBloc.compliantDetailData?.user,
            postPublishedAt: complaintBloc.compliantDetailData?.createdAt,
          ),
          PostCenterView(
            postBy: complaintBloc.compliantDetailData?.user,
            postTitle: complaintBloc.compliantDetailData?.title,
            postDescription: complaintBloc.compliantDetailData?.content ?? '',
            postImages: complaintBloc.compliantDetailData?.file!.isEmpty == true
                ? []
                : [
                    complaintBloc.compliantDetailData?.file ?? "",
                  ],
            postStatus: Container(
              margin: const EdgeInsets.only(left: 5, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: statusColor(
                    status: complaintBloc.compliantDetailData?.status ?? ''),
              ),
              child: Text(
                '${complaintBloc.compliantDetailData?.status}',
                style: appTextStyle.appSubTitleStyle(
                  color: statusTextColor(
                      status: complaintBloc.compliantDetailData?.status ?? ''),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ContainerFirst(
      controller: scrollController,
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      scrollingOnKeyboardOpen: true,
      appBarHeight: 50,
      appBar: BlocBuilder<ComplaintBloc, ComplaintState>(
          bloc: complaintBloc,
          builder: (BuildContext context, state) {
            return CommonAppBar(
              title: AppString.complaintDetail,
              icon: WorkplaceIcons.backArrow,
              action: complaintBloc.compliantDetailData?.isMyComplain == true &&
                      complaintBloc.compliantDetailData?.status
                              ?.toLowerCase() ==
                          "completed"
                  ? IconButton(
                      padding: const EdgeInsets.only(left: 20),
                      onPressed: () {
                        showStatusChangeSheet2(context);
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ))
                  : AppPermission.instance.canPermission(
                          AppString.complaintStatusUpdate,
                          context: context)
                      ? IconButton(
                          padding: const EdgeInsets.only(left: 20),
                          onPressed: () {
                            showStatusChangeSheet(context);
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ))
                      : const SizedBox(),
            );
          }),
      containChild: BlocListener<ComplaintBloc, ComplaintState>(
        listener: (context, state) {},
        child: BlocBuilder<ComplaintBloc, ComplaintState>(
            bloc: complaintBloc,
            builder: (BuildContext context, state) {
              if (state is ComplaintLoadingState) {
                if(isShowLoader == true) {
                  return const Center(
                  child: CircularProgressIndicator(),
                );
                }
              }
              return Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 75),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    complaintNewCard(),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      thickness: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 15),
                          child: Text(
                            AppString.comments,
                            style: appTextStyle.appNormalSmallTextStyle(),
                          ),
                        ),
                      ],
                    ),
                    commentCard(
                        comments:
                            complaintBloc.compliantDetailData?.comments ?? []),
                  ],
                ),
              );
            }),
      ),
      bottomMenuView: Stack(
        children: [
          /// Comment Permission wali field
          AppPermission.instance
              .canPermission(AppString.complaintComment, context: context)
              ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
                child: TagTextField(
                  minLines: 1,
                  maxLines: 5,
                  leadingWidget: const [SizedBox(width: 20)],
                  focusOnTextField: false,
                  searchResults: (List<User> list) {},
                  onPostClick: (content) {
                    complaintBloc.add(PostComplaintCommentEvent(
                      mContext: context,
                      comment: content.trim(),
                      complaintId: widget.complaintId ?? 0,
                      status:
                      complaintBloc.compliantDetailData?.status ?? '',
                    ));

                    scroll();
                  },
                ),
              ),
            ],
          )
              : const SizedBox(),

          /// Create Task Floating Action Button (Always visible)
         AppPermission.instance.canPermission(
              AppString.complaintStatusUpdate,
              context: context)?
          Positioned(
            bottom: 65, // comment field ke thoda upar
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    widget: AddTaskScreen(
                      isComingFrom: true,
                      moduleName: "Complaint",
                      complaintId: widget.complaintId,
                      description: complaintBloc.compliantDetailData?.content ?? '',
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    // setState(() {
                    //   isLoader = false;
                    // });
                    // if (tabInitialIndex == 0) {
                    //   _applyFiltersForActiveTasks();
                    // } else {
                    //   _applyFiltersForCompletedTasks();
                    // }
                  }
                });
              },
              label: const Text("Create Task", style: TextStyle(color: Colors.white,fontSize: 16),),
              icon: const Icon(Icons.add,color: Colors.white, weight: 5.5,),
              backgroundColor: AppColors.textBlueColor,
            ),
          ): SizedBox()
        ],
      ),

    );
  }
}
