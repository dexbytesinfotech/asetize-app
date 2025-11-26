// import 'package:flutter/cupertino.dart';
// import 'package:asetize/features/follow_up/bloc/follow_up_bloc.dart';
// import 'package:asetize/features/follow_up/bloc/follow_up_state.dart';
// import 'package:asetize/features/follow_up/models/get_quotation_list_model.dart';
// import 'package:asetize/widgets/common_card_view.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// import '../../../core/util/app_permission.dart';
// import '../../../core/util/app_theme/text_style.dart';
// import '../../../imports.dart';
// import '../../../widgets/commonTitleRowWithIcon.dart';
// import '../../../widgets/common_detail_view_row.dart';
// import '../../../widgets/download_button_widget.dart';
// import '../../create_post/bloc/create_post_bloc.dart';
// import '../../member/pages/member_unit_screen.dart';
// import '../../my_unit/widgets/common_image_view.dart';
// import '../../my_unit/widgets/common_pdf_view.dart';
// import '../bloc/follow_up_event.dart';
// import '../models/get_task_detail_model.dart';
// import '../models/get_task_list_model.dart';
// import '../widgets/assign_bottomSheet.dart';
// import '../widgets/follow_up_detail_card_view.dart';
// import '../widgets/follow_up_detail_comment_view.dart';
// import '../widgets/follow_up_detail_history_view.dart';
// import '../../tag_text_field/widgets/tag_text_field.dart';
// import 'add_new_task.dart';
// import 'add_quotation_form.dart';
// import 'new_add_follow_up_screen.dart';
//
// class NewFollowUpDetailScreen extends StatefulWidget {
//   final TaskListData? taskListData;
//   final bool isComingFromMyTask;
//
//
//   const NewFollowUpDetailScreen({super.key, this.taskListData, this.isComingFromMyTask = false});
//
//   @override
//   State<NewFollowUpDetailScreen> createState() =>
//       _NewFollowUpDetailScreenState();
// }
//
// class _NewFollowUpDetailScreenState extends State<NewFollowUpDetailScreen>
//     with TickerProviderStateMixin {
//   late TabController tabController;
//   late FollowUpBloc followUpBloc;
//   late CreatePostBloc createPostBloc;
//   bool isEdit = false;
//   int tabInitialIndex = 0;
//   bool isShowLoader = true;
//   File? selectProfilePhoto;
//   String? selectProfilePhotoPath;
//   String imageErrorMessage = '';
//   int? selectedAssigneeId;
//   String assignTo = "All Assign";
//   final restrictedStatuses = ["closed", "cancelled", "completed", "agreed"];
//
//
//
//   Color getStatusColor(String status) {
//     switch (status) {
//       case 'Completed':
//         return const Color(0xFFD3D3D3); // Light Grey
//       case "Didn't Pick":
//         return const Color(0xFFFFE0B2); // Light Orange
//       case 'Agreed':
//         return const Color(0xFFC8E6C9); // Light Green
//       case 'Follow Up':
//         return const Color(0xFFBBDEFB); // Light Blue
//       case 'Open':
//         return const Color(0xFFFFCDD2); // Light Red
//       case 'All Status':
//         return const Color(0xFFE0F7FA); // Light Cyan
//       case 'Cancelled':
//         return const Color(0xFFF8BBD0); // Light Pink
//       case 'Approved':
//         return const Color(0xFFC8E6C9); // Softer Light Green
//       case 'Rejected':
//         return const Color(0xFFFFCDD2); // Softer Light Red
//       case 'Pending':
//         return const Color(0xFFFFF9C4); // Softer Light Yellow// Light Yellow
//       default:
//         return const Color(0xFFE0E0E0); // Default Light Grey
//     }
//   }
//
//   Color getStatusTextColor(String status) {
//     switch (status) {
//       case 'Completed':
//         return Colors.black87;
//       case "Didn't Pick":
//         return Colors.orange;
//       case 'Agreed':
//         return Colors.green;
//       case 'Follow Up':
//         return Colors.blue;
//       case 'Open':
//         return Colors.red;
//       case 'All Status':
//         return Colors.teal;
//       case 'Cancelled':
//         return Colors.pink;
//       case 'Approved':
//         return Colors.green.shade700;
//       case 'Rejected':
//         return Colors.red.shade700;
//       case 'Pending':
//         return Colors.amber.shade700;
//       default:
//         return Colors.black87;
//     }
//   }
//
//   Map<String, File>? imageFile;
//   Map<String, String>? imagePath;
//   OverlayEntry? overlayEntry;
//   bool isImageSelected = false;
//
//   @override
//   void initState() {
//     permission();
//     followUpBloc = BlocProvider.of<FollowUpBloc>(context);
//     followUpBloc.getTaskDetailData = null;
//     createPostBloc = BlocProvider.of<CreatePostBloc>(context);
//
//     followUpBloc.add(OnGetTaskDetailEvent(taskId: widget.taskListData?.id ?? 0));
//     followUpBloc.add(OnGetTaskHistoryListEvent(taskId: widget.taskListData?.id ?? 0));
//     followUpBloc.add(OnGetQuotationListEvent(taskId: widget.taskListData?.id ?? 0));
//
//     followUpBloc.add(OnGetTaskCommentListEvent(
//       taskId: widget.taskListData?.id ?? 0,
//     ));
//
//     followUpBloc.add(OnGetFollowUpListEvent(
//       taskId: widget.taskListData?.id ?? 0,
//     ));
//
//     super.initState();
//     tabController = TabController(length: buildTabs().length, vsync: this);
//     tabController.addListener(() {
//       setState(() {
//         tabInitialIndex = tabController.index;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     tabController.dispose();
//     super.dispose();
//   }
//
//   void closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
//   Future<String?> photoPickerBottomSheet() async {
//     return await showModalBottomSheet<String>(
//       context: context,
//       builder: (context1) => PhotoPickerBottomSheet(
//         isRemoveOptionNeeded: false,
//         removedImageCallBack: () {
//           Navigator.pop(context1, null); // return null
//         },
//         selectedImageCallBack: (fileList) {
//           if (fileList != null && fileList.isNotEmpty) {
//             File imageFileTemp = File(fileList.first.path);
//
//             Navigator.pop(context1, imageFileTemp.path);
//             closeKeyboard(); // return path
//           }
//         },
//         selectedCameraImageCallBack: (fileData) {
//           if (fileData != null && fileData.path != null) {
//             File imageFileTemp = File(fileData.path!);
//             Navigator.pop(context1, imageFileTemp.path);
//             closeKeyboard(); // return path
//           }
//         },
//       ),
//     );
//   }
//
//   bool canTaskEdit = false;
//   bool canManageTaskEdit = false;
//   bool canShowAssign = false;
//   bool canShowCancel = false;
//   bool canShowComplete = false;
//   bool canShowEdit = false;
//   bool canShowComment = false;
//   bool canShowHistory = false;
//   bool canShowFollowUp = false;
//   bool statusAllowed = false;
//
//   void _resetImageState() {
//     setState(() {
//       isShowLoader = true;
//       selectProfilePhotoPath = null;
//       isImageSelected = false;
//       selectProfilePhoto = null;
//     });
//   }
//
//
//   void permission(){
//     statusAllowed = !restrictedStatuses.contains(widget.taskListData?.status?.toLowerCase());
//     canManageTaskEdit = AppPermission.instance.canPermission(AppString.manageTaskEdit, context: context);
//     canTaskEdit = AppPermission.instance.canPermission(AppString.taskEdit, context: context);
//     canShowEdit =  widget.isComingFromMyTask == true?canTaskEdit&&statusAllowed :canManageTaskEdit&&statusAllowed;
//
//     final canManageTaskAssign = AppPermission.instance.canPermission(AppString.manageTaskAssign, context: context);
//     final canTaskAssign = AppPermission.instance.canPermission(AppString.taskAssign, context: context);
//     canShowAssign = widget.isComingFromMyTask == true? canTaskAssign&&statusAllowed : canManageTaskAssign &&statusAllowed;
//
//     final canManageTaskCancel =
//         AppPermission.instance.canPermission(AppString.manageTaskCancel, context: context) && statusAllowed;
//     final canTaskCancel =
//         AppPermission.instance.canPermission(AppString.taskCancel, context: context)&& statusAllowed;
//     canShowCancel = widget.isComingFromMyTask == true ? canTaskCancel : canManageTaskCancel;
//
//
//
//     final canManageTaskComplete = AppPermission.instance.canPermission(AppString.manageTaskComplete, context: context);
//     final canTaskComplete = AppPermission.instance.canPermission(AppString.taskComplete, context: context);
//     canShowComplete = widget.isComingFromMyTask ? statusAllowed && canTaskComplete : statusAllowed && canManageTaskComplete;
//
//
//
// // for comment
//     final canManageTaskComment =
//     AppPermission.instance.canPermission(AppString.manageTaskComment, context: context);
//     final canTaskComment =
//     AppPermission.instance.canPermission(AppString.taskComment, context: context);
//
//     canShowComment =  widget.isComingFromMyTask == true ? canTaskComment :canManageTaskComment;
//
//     if (canShowComment) {
//       // comment logic
//     }
//
//
// // for history
//
//     final canManageTaskHistory =
//     AppPermission.instance.canPermission(AppString.manageTaskHistory, context: context);
//     final canTaskHistory =
//     AppPermission.instance.canPermission(AppString.taskHistory, context: context);
//
//     canShowHistory =  widget.isComingFromMyTask == true ? canTaskHistory : canManageTaskHistory;
//
//     if (canShowHistory) {
//       // history logic
//     }
//
// // for followup
//
//     final canManageTaskFollowUp =
//     AppPermission.instance.canPermission(AppString.manageTaskFollowUp, context: context);
//     final canTaskFollowUp =
//     AppPermission.instance.canPermission(AppString.taskFollowUp, context: context);
//
//     canShowFollowUp = widget.isComingFromMyTask == true? canTaskFollowUp : canManageTaskFollowUp;
//
//     if (canShowFollowUp) {
//       // follow-up logic
//     }
//   }
//
//   List<Tab> buildTabs() {
//     final tabs = <Tab>[
//       Tab(text: 'Details'),
//     ];
//     if (canShowComment) tabs.add(Tab(text: 'Quotations'));
//     if (canShowComment) tabs.add(Tab(text: 'Comments'));
//     if (canShowFollowUp) tabs.add(Tab(text: 'Follow-up'));
//     if (canShowHistory) tabs.add(Tab(text: 'History'));
//     return tabs;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//
//     List<Widget> buildTabs() {
//       final tabs = [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Tab(
//             iconMargin: EdgeInsets.zero,
//             text: 'Details',
//           ),
//         )
//       ];
//
//       if (canShowComment) {
//         tabs.add(
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Tab(
//                 iconMargin: EdgeInsets.zero,
//                 text: 'Quotations',
//               ),
//             ));
//       }
//
//
//
//
//       if (canShowComment) {
//         tabs.add(
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Tab(
//                 iconMargin: EdgeInsets.zero,
//                 text: 'Comments',
//               ),
//             ));
//       }
//       if (canShowFollowUp) {
//         tabs.add(
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Tab(
//                 iconMargin: EdgeInsets.zero,
//                 text: 'Follow-up',
//               ),
//             ));
//       }
//       if (canShowHistory) {
//         tabs.add(
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Tab(
//                 iconMargin: EdgeInsets.zero,
//                 text: 'History',
//               ),
//             ));
//       }
//       return tabs;
//     }
//
//
//
//     Widget getPriorityIcon(String priority, {double size = 25}) {
//       switch (priority) {
//         case 'Low':
//           return Icon(Icons.keyboard_double_arrow_down_rounded, color: AppColors.textDarkGreenColor, size: size);
//         case 'Medium':
//           return Icon(Icons.drag_handle, color: Colors.orange, size: 24);
//         case 'High':
//           return Icon(Icons.keyboard_double_arrow_up, color: Colors.red, size: size);
//         case 'Urgent':
//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               Icon(Icons.keyboard_double_arrow_up, color: Colors.red, size: size + 4), // मोटा
//               Positioned(
//                 top: -4,
//                 child: Icon(Icons.keyboard_double_arrow_up, color: Colors.red, size: size + 4),
//               ),
//             ],
//           );
//         default:
//           return Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: size);
//       }
//     }
//
//     topCardView() {
//       return
//
//
//         CommonCardView(
//             margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20)
//                   .copyWith(bottom: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.credit_card_rounded,
//                         size: 18,
//                         color: AppColors.appBlueColor,
//                       ),
//                       SizedBox(
//                         width: 6,
//                       ),
//                       Expanded(
//                         child: Text(
//                           (followUpBloc.getTaskDetailData?.moduleName ?? '')
//                               .split('_')
//                               .map((word) => word.isNotEmpty
//                               ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
//                               : '')
//                               .where((w) => w.isNotEmpty)
//                               .join(' '),
//                           style: appTextStyle.appSubTitleStyle2(),
//                         ),
//                       ),
//
//
//
//                       Container(
//                           padding:
//                           EdgeInsets.symmetric(horizontal: 15, vertical: 2),
//                           decoration: BoxDecoration(
//                               color:  getStatusColor(followUpBloc.getTaskDetailData?.status ?? ''),
//                               borderRadius: BorderRadius.circular(15)),
//                           child: Text(
//                             followUpBloc.getTaskDetailData?.status?? '',
//                             style: appTextStyle.appTitleStyle2(
//                                 color: getStatusTextColor(followUpBloc.getTaskDetailData?.status ?? ''), // Apply status text color
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 12),
//                           )),
//
//                       SizedBox(width: 10,),
//                       getPriorityIcon(followUpBloc.getTaskDetailData?.priority?.capitalize() ?? '', size: 25),
//
//                     ],
//                   ),
//                   SizedBox(height: 15),
//                   Text(
//                     followUpBloc.getTaskDetailData?.title?.capitalize() ?? '',
//                     style: appTextStyle.appSubTitleStyle2(fontSize: 16),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     followUpBloc.getTaskDetailData?.description?.capitalize() ?? '',
//                     maxLines: 3,
//                     style: appTextStyle.appTitleStyle2(),
//
//                   ),
//                   SizedBox(height: 10),
//                   // Text(
//                   //   followUpBloc.getTaskDetailData?.priority?.capitalize() ?? '',
//                   //   maxLines: 3,
//                   //   style: appTextStyle.appSubTitleStyle2(),
//                   // ),
//                   // SizedBox(height: 18),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       Flexible(
//                         child: CommonDetailViewRow(
//                             title: "Created",
//                             iconSize: 16,
//                             icons: Icons.access_time,
//                             valueTextStyle: appTextStyle.appTitleStyle2(
//                                 fontWeight: FontWeight.w500, fontSize: 14),
//                             titleTextStyle: appTextStyle.appSubTitleStyle2(
//                                 color: Colors.grey.shade600, fontSize: 14),
//                             value:
//                             followUpBloc.getTaskDetailData?.createdAt ?? ''),
//                       ),
//                       if (followUpBloc.getTaskDetailData?.dueDateDisplay != null)
//                         Flexible(
//                           child: CommonDetailViewRow(
//                               title: "Due Date",
//                               iconSize: 16,
//                               icons: Icons.calendar_month,
//                               valueTextStyle: appTextStyle.appTitleStyle2(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 14,
//                                   color: Colors.red.shade700),
//                               titleTextStyle: appTextStyle.appSubTitleStyle2(
//                                   color: Colors.grey.shade600, fontSize: 14),
//                               value: followUpBloc.getTaskDetailData?.dueDateDisplay ?? ''),
//                         ),
//                     ],
//                   )
//                 ],
//               ),
//             ));
//     }
//     Widget shareAndDownloadQuotationReport (String? nocFile, GetQuotationListData? quotationData, ) {
//       // if (nocFile == null || nocFile.isEmpty) {
//       //   return const SizedBox.shrink();
//       // }
//
//       bool isPdf = nocFile!.toLowerCase().endsWith('.pdf');
//
//       return DownloadButtonWidget(
//         margin: EdgeInsets.symmetric(horizontal: 0),
//         borderRadius: 4,
//         buttonName: "Share/Download Quotation",
//         onTapCallBack: () {
//           if (isPdf) {
//             Navigator.push(
//               context,
//               SlideLeftRoute(
//                 widget: PdfCommonViewPage(
//                     pdfUrl: nocFile,
//                     title: quotationData?.vendorName,
//                     subTitle: "Quotation"),
//               ),
//             );
//           } else {
//             Navigator.push(
//               context,
//               SlideLeftRoute(
//                 widget: ImageViewPage(
//                     imageUrl: nocFile,
//                     title: quotationData?.vendorName,
//                     subTitle: "Quotation"),
//               ),
//             );
//           }
//         },
//       );}
//     Widget  quotationBottomButtons(int id, String status) {
//       return status == "pending" ?
//
//
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 WorkplaceWidgets.showRequestDialog(
//                   context: context,
//                   title:
//                   AppString.approveRequest ?? AppString.approveRequestTitle,
//                   content:
//                   'Are you sure you want to credit to house?\n This action cannot be undone.' ?? "",
//                   buttonName1:
//                   AppString.buttonConfirm ?? AppString.confirmButton,
//                   hintText: AppString.enterReceiptNumber,
//                   buttonName2: AppString.cancelButton,
//                   unableButtonColor: AppColors.textDarkGreenColor,
//                   disableButtonColor: Colors.green.withOpacity(0.5),
//                   onPressedButton1: () {
//
//                     followUpBloc.add(OnApprovedQuotationEvent(
//                         id: id
//                     ));
//
//
//
//
//                     // Handle Confirm action
//                     // accountBloc.add(
//                     //   ReceiptSharedConfirmEvent(
//                     //     mContext: context,
//                     //     id: widget.id ?? 0,
//                     //     receiptNumber: receiptNumberTextController.text ?? '',
//                     //     status: AppString.approvedStatus,
//                     //   ),
//                     // );
//                     Navigator.pop(context);
//                   },
//
//                   onPressedButton2: () {
//                     Navigator.of(context).pop();
//                   },
//                 );
//               },
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//                 decoration: BoxDecoration(
//                     color: AppColors.textDarkGreenColor,
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Center(
//                     child: Text(
//                       AppString.approved,
//                       style: appTextStyle.appTitleStyle(
//                         color: AppColors.white,
//                       ),
//                     )),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 TextEditingController commentsTextController =
//                 TextEditingController();
//                 WorkplaceWidgets.showRequestDialogForRejected(
//                   context: context,
//                   title: AppString.rejectRequestTitle,
//                   content: "",
//                   buttonName1: AppString.submitButton,
//                   buttonName2: AppString.cancelButton,
//                   disableButtonColor: AppColors.textDarkRedColor.safeOpacity(0.5),
//                   unableButtonColor: AppColors.textDarkRedColor,
//                   textController: commentsTextController,
//                   hintText: AppString.enterReasonHint,
//                   maxLine: 3,
//                   onPressedButton1: () {
//
//                     followUpBloc.add(OnRejectQuotationEvent(
//                         id: id
//                     ));
//                     Navigator.pop(context);
//
//
//
//                     // if (commentsTextController.text.trim().isNotEmpty) {
//                     //   accountBloc.add(
//                     //     ReceiptSharedRejectEvent(
//                     //       mContext: context,
//                     //       id: widget.id ?? 0,
//                     //       accountComments: commentsTextController.text,
//                     //       status: AppString.rejectedStatus,
//                     //     ),
//                     //   );
//                     //   Navigator.pop(context);
//                     // }
//                   },
//                   onPressedButton2: () {
//                     Navigator.of(context).pop();
//                   },
//                 );
//               },
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: AppColors.textDarkRedColor,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Center(
//                   child: Text(
//                     AppString.reject,
//                     style: appTextStyle.appTitleStyle(
//                       color: AppColors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//
//         ],
//       ): SizedBox();
//
//
//     }
//
//     // quotationTabView() {
//     //   final quotations = followUpBloc.getTaskQuotationData; // <-- Add your data source
//     //   final screenHeight = MediaQuery.of(context).size.height;
//     //
//     //   return Padding(
//     //     padding: const EdgeInsets.symmetric(horizontal: 16),
//     //     child: Column(
//     //       children: [
//     //         const SizedBox(height: 6),
//     //         if (quotations == null || quotations.isEmpty)
//     //           SizedBox(
//     //             height: screenHeight * 0.4, // 40% of screen height
//     //             child: Center(
//     //               child: Text(
//     //                 "No quotations found",
//     //                 style: appTextStyle.noDataTextStyle(),
//     //               ),
//     //             ),
//     //           )
//     //         else
//     //           ListView.builder(
//     //             shrinkWrap: true,
//     //             physics: const NeverScrollableScrollPhysics(),
//     //             padding: const EdgeInsets.only(bottom: 80),
//     //             itemCount: quotations.length,
//     //             itemBuilder: (context, index) {
//     //               final quotationData = quotations[index];
//     //
//     //               return CommonCardView(
//     //                 margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//     //                 child: Padding(
//     //                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20)
//     //                       .copyWith(bottom: 20),
//     //                   child: Column(
//     //                     crossAxisAlignment: CrossAxisAlignment.start,
//     //                     children: [
//     //                       /// Header Row
//     //                       Row(
//     //                         children: [
//     //                           const Icon(
//     //                             Icons.credit_card_rounded,
//     //                             size: 18,
//     //                             color: AppColors.appBlueColor,
//     //                           ),
//     //                           const SizedBox(width: 6),
//     //                           Expanded(
//     //                             child: Text(
//     //                               quotationData.moduleName?.capitalize() ?? '',
//     //                               style: appTextStyle.appSubTitleStyle2(),
//     //                             ),
//     //                           ),
//     //                           Container(
//     //                             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
//     //                             decoration: BoxDecoration(
//     //                               color: getStatusColor(quotationData.status ?? ''),
//     //                               borderRadius: BorderRadius.circular(15),
//     //                             ),
//     //                             child: Text(
//     //                               quotationData.status ?? '',
//     //                               style: appTextStyle.appTitleStyle2(
//     //                                 color: getStatusTextColor(quotationData.status ?? ''),
//     //                                 fontWeight: FontWeight.w500,
//     //                                 fontSize: 12,
//     //                               ),
//     //                             ),
//     //                           ),
//     //                           const SizedBox(width: 10),
//     //                           getPriorityIcon(
//     //                             quotationData.priority?.capitalize() ?? '',
//     //                             size: 25,
//     //                           ),
//     //                         ],
//     //                       ),
//     //
//     //                       const SizedBox(height: 10),
//     //
//     //                       /// Amount & Date Row
//     //                       Row(
//     //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                         crossAxisAlignment: CrossAxisAlignment.start,
//     //                         children: [
//     //                           Flexible(
//     //                             child: CommonDetailViewRow(
//     //                               title: "Amount",
//     //                               iconSize: 16,
//     //                               icons: Icons.currency_rupee_rounded,
//     //                               valueTextStyle: appTextStyle.appTitleStyle2(
//     //                                 fontWeight: FontWeight.w500,
//     //                                 fontSize: 14,
//     //                               ),
//     //                               titleTextStyle: appTextStyle.appSubTitleStyle2(
//     //                                 color: Colors.grey.shade600,
//     //                                 fontSize: 14,
//     //                               ),
//     //                               value: quotationData.amount?.toString() ?? "0",
//     //                             ),
//     //                           ),
//     //                           Flexible(
//     //                             child: CommonDetailViewRow(
//     //                               title: "Date",
//     //                               iconSize: 16,
//     //                               icons: Icons.access_time,
//     //                               valueTextStyle: appTextStyle.appTitleStyle2(
//     //                                 fontWeight: FontWeight.w500,
//     //                                 fontSize: 14,
//     //                               ),
//     //                               titleTextStyle: appTextStyle.appSubTitleStyle2(
//     //                                 color: Colors.grey.shade600,
//     //                                 fontSize: 14,
//     //                               ),
//     //                               value: quotationData.createdAt ?? '',
//     //                             ),
//     //                           ),
//     //                         ],
//     //                       ),
//     //
//     //                       /// Added By
//     //                       Text(
//     //                         "Added by ${quotationData.addedBy ?? 'Unknown'} on ${quotationData.createdAt ?? ''}"
//     //                             .capitalize(),
//     //                         maxLines: 3,
//     //                         style: appTextStyle.appSubTitleStyle2(),
//     //                       ),
//     //
//     //                       const SizedBox(height: 15),
//     //
//     //                       /// Share & Download
//     //                       shareAndDownloadQuotationReport(quotationData.reportUrl ?? ""),
//     //
//     //                       const SizedBox(height: 15),
//     //
//     //                       /// Bottom Buttons
//     //                       quotationBottomButtons(),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               );
//     //             },
//     //           ),
//     //       ],
//     //     ),
//     //   );
//     // }
//
//
//
//
//     quotationTabView() {
//       final screenHeight = MediaQuery.of(context).size.height;
//
//       // ✅ Dummy data (list of quotations)
//
//
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             const SizedBox(height: 6),
//             if (followUpBloc.getQuotationListData!.isEmpty)
//               SizedBox(
//                 height: screenHeight * 0.4, // 40% of screen height
//                 child: Center(
//                   child: Text(
//                     "No quotations found",
//                     style: appTextStyle.noDataTextStyle(),
//                   ),
//                 ),
//               )
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.only(bottom: 80),
//                 itemCount: followUpBloc.getQuotationListData?.length,
//                 itemBuilder: (context, index) {
//                   final quotationData = followUpBloc.getQuotationListData?[index];
//
//                   return CommonCardView(
//                     margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20)
//                           .copyWith(bottom: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           /// Header Row
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.person_2_outlined,
//                                 size: 18,
//                                 color: Colors.grey.shade600,
//                               ),
//                               const SizedBox(width: 6),
//                               Expanded(
//                                   child:  Text(
//                                     (quotationData?.vendorName ?? '')
//                                         .split('_')
//                                         .map((word) => word.isNotEmpty
//                                         ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
//                                         : '')
//                                         .where((w) => w.isNotEmpty)
//                                         .join(' '),
//                                     style: appTextStyle.appTitleStyle2(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 14,
//                                     ),
//                                   )
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   color: getStatusColor(quotationData?.status ?? ''),
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Text(
//                                   quotationData?.status?? '',
//                                   style: appTextStyle.appTitleStyle2(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 12,
//                                       color: getStatusTextColor(quotationData?.status ?? '')
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               if (quotationData?.status?.toLowerCase() != "approved" &&
//                                   quotationData?.status?.toLowerCase() != "rejected")
//
//                                 GestureDetector(
//                                   onTap: () {
//                                     WorkplaceWidgets.commonEditDeleteBottomSheet(
//                                       context: context,
//                                       isEdit: false,
//                                       onDeleteConfirmed: () {
//                                         followUpBloc.add(OnDeleteQuotationEvent(id: quotationData?.id?? 0));
//
//
//                                       },
//                                       deleteTitle: "Delete Quotation",
//                                       deleteMessage:
//                                       "Are you sure you want to delete this Quotation?", onEdit: () {  },
//                                     );
//                                   },
//                                   child: const Icon(
//                                     CupertinoIcons.ellipsis_vertical,
//                                     size: 20,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           /// Amount & Date Row
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Flexible(
//                                 child: CommonDetailViewRow(
//                                     title: "Amount",
//                                     iconSize: 16,
//                                     icons: Icons.currency_rupee_rounded,
//                                     valueTextStyle: appTextStyle.appTitleStyle2(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 14,
//                                     ),
//                                     titleTextStyle: appTextStyle.appSubTitleStyle2(
//                                       color: Colors.grey.shade600,
//                                       fontSize: 14,
//                                     ),
//                                     value: quotationData?.amount.toString() ?? ''
//                                 ),
//                               ),
//                               Flexible(
//                                 child: CommonDetailViewRow(
//                                   title: "Date",
//                                   iconSize: 16,
//                                   icons: Icons.access_time,
//                                   valueTextStyle: appTextStyle.appTitleStyle2(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                   ),
//                                   titleTextStyle: appTextStyle.appSubTitleStyle2(
//                                     color: Colors.grey.shade600,
//                                     fontSize: 14,
//                                   ),
//                                   value: quotationData?.quotationDate ?? '',
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           if (quotationData?.approvedByUser?.name != null || quotationData?.rejectedByUser?.name != null)
//                             CommonDetailViewRow(
//                               title: quotationData?.approvedByUser?.name != null ? "Approved by" : "Rejected by",
//                               iconSize: 16,
//                               icons: Icons.person_2_outlined,
//                               valueTextStyle: appTextStyle.appTitleStyle2(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                               ),
//                               titleTextStyle: appTextStyle.appSubTitleStyle2(
//                                 color: Colors.grey.shade600,
//                                 fontSize: 14,
//                               ),
//                               value: quotationData?.approvedByUser?.name ?? quotationData?.rejectedByUser?.name ?? '',
//                             ),
//
//
//
//                           /// Added By
//                           Text(
//                             "Added by ${quotationData?.addedByUser?.name} on ${quotationData?.createdAt}",
//                             maxLines: 3,
//                             style: appTextStyle.appSubTitleStyle2(),
//                           ),
//                           const SizedBox(height: 15),
//                           /// Share & Download
//                           shareAndDownloadQuotationReport(quotationData?.attachment ?? "", quotationData),
//
//                           SizedBox(height: quotationData?.status?.toLowerCase()== "pending" ? 15:0),
//
//                           /// Bottom Buttons
//                           quotationBottomButtons(quotationData?.id ?? 0,quotationData?.status?.toLowerCase() ?? '' ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//           ],
//         ),
//       );
//     }
//
//
//     tabBarLineView() {
//       return Container(
//         padding:
//         EdgeInsets.symmetric(horizontal: 15).copyWith(top: 15, bottom: 0),
//         color: Colors.transparent,
//         child: Container(
//           height: 50,
//           padding: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
//           margin: EdgeInsets.zero,
//           decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey.shade300,
//                     blurRadius: 2,
//                     offset: Offset(0.0, 0.2))
//               ],
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           child: TabBar(
//             controller: tabController,
//             isScrollable: false,
//             padding: EdgeInsets.zero,
//             indicatorPadding: EdgeInsets.only(bottom: 1),
//             labelPadding: EdgeInsets.zero,
//             indicator: BoxDecoration(
//                 color: AppColors.appBlueColor,
//                 borderRadius: BorderRadius.circular(8)),
//             dividerColor: Colors.transparent,
//             labelColor: Colors.white,
//             labelStyle: TextStyle(
//               color: Color(0xFF42526E),
//               fontSize: 13,
//               fontFamily: appFonts.defaultFont,
//               fontWeight: appFonts.medium500,
//             ),
//             unselectedLabelColor: Color(0xff747474),
//             onTap: (index) {
//               setState(() {
//                 tabInitialIndex = index;
//               });
//             },
//             tabs: buildTabs(),
//
//             // tabs: [
//             //   Padding(
//             //     padding: const EdgeInsets.symmetric(horizontal: 10),
//             //     child: Tab(
//             //       iconMargin: EdgeInsets.zero,
//             //       text: 'Details',
//             //     ),
//             //   ),
//             //   Visibility(
//             //     visible: canShowComment,
//             //     child: Padding(
//             //       padding: const EdgeInsets.symmetric(horizontal: 10),
//             //       child: Tab(
//             //         iconMargin: EdgeInsets.zero,
//             //         text: 'Comments',
//             //       ),
//             //     ),
//             //   ),
//             //   Visibility(
//             //     visible: canShowFollowUp,
//             //     child: Padding(
//             //       padding: const EdgeInsets.symmetric(horizontal: 10),
//             //       child: Tab(
//             //         iconMargin: EdgeInsets.zero,
//             //         text: 'Follow-up',
//             //       ),
//             //     ),
//             //   ),
//             //   Visibility(
//             //     visible: canShowHistory,
//             //     child: Padding(
//             //       padding: const EdgeInsets.symmetric(horizontal: 10),
//             //       child: Tab(
//             //         iconMargin: EdgeInsets.zero,
//             //         text: 'History',
//             //       ),
//             //     ),
//             //   )
//             // ]
//
//           ),
//         ),
//       );
//     }
//
//
//
//
//     detailAssignmentCardView() {
//       return CommonCardView(
//           margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20)
//                 .copyWith(bottom: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CommonTitleRowWithIcon(
//                   title: 'Assignment',
//                   icon: Icons.person_2_outlined,
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   children: [
//                     CircularImage(
//                       image:
//                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTNjkaQHLXfokbl1GiKnXl6v7GNgnG8rb3JA&s',
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Created by',
//                           style: appTextStyle.appSubTitleStyle3(),
//
//                         ),
//                         Text(
//                           followUpBloc.getTaskDetailData?.createdBy?.name ?? '',
//                           style: appTextStyle.appTitleStyle(fontSize: 15),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 SizedBox(height: followUpBloc.getTaskDetailData?.assignee?.name != null? 10: 0),
//                 if(followUpBloc.getTaskDetailData?.assignee?.name != null )
//                   Row(
//                     children: [
//                       CircularImage(
//                         image:followUpBloc.getTaskDetailData?.assignee?.profilePhoto ??
//                             'https://t3.ftcdn.net/jpg/06/99/46/60/360_F_699466075_DaPTBNlNQTOwwjkOiFEoOvzDV0ByXR9E.jpg',
//                       ),
//                       SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Assigned to',
//                             style: appTextStyle.appSubTitleStyle3(),
//                           ),
//                           Text(
//                             followUpBloc.getTaskDetailData?.assignee?.name ?? '',
//                             style: appTextStyle.appTitleStyle(fontSize: 15),
//
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 SizedBox(height:20),
//               ],
//             ),
//           ));
//     }
//     Widget imageDisplay(String? completionPhotos) {
//       if (completionPhotos == null || completionPhotos.isEmpty) {
//         return const SizedBox();
//       }
//
//       return Container(
//         margin: const EdgeInsets.only(bottom: 0, left: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 25, top: 8),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     FadeRoute(
//                       widget: FullPhotoView(
//                         title: "Completion Photo",
//                         profileImgUrl:completionPhotos,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey, width: 0.5),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(4),
//                     child: CachedNetworkImage(
//                       placeholder: (context, url) => const ImageLoader(),
//                       imageUrl: completionPhotos,
//                       fit: BoxFit.cover,
//                       height: 100,
//                       width: 100,
//                       errorWidget: (context, url, error) => Container(
//                         color: Colors.grey.shade50,
//                         child: const Center(
//                           child: Text(
//                             AppString.couldNotLoadError,
//                             style: TextStyle(color: Colors.black, fontSize: 14),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     Widget taskCompletedCardView() {
//       final taskDetail = followUpBloc.getTaskDetailData;
//
//       if ((taskDetail?.completedAt?.isEmpty ?? true) &&
//           (taskDetail?.completedBy?.name?.isEmpty ?? true) &&
//           (taskDetail?.completedRemark?.isEmpty ?? true) &&
//           (taskDetail?.completedImages?.isEmpty ?? true)) {
//         return const SizedBox();
//       }
//
//       return CommonCardView(
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20).copyWith(bottom: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CommonTitleRowWithIcon(
//                 title: 'Task Completed',
//                 icon: Icons.check_circle_outline,
//                 iconColor: AppColors.textDarkGreenColor,
//               ),
//               const SizedBox(height: 20),
//
//               if ((taskDetail?.completedAt?.isNotEmpty ?? false) ||
//                   (taskDetail?.completedBy?.name?.isNotEmpty ?? false)) ...[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     if (taskDetail?.completedAt?.isNotEmpty ?? false)
//                       Flexible(
//                         child: CommonDetailViewRow(
//                           title: "Completed Date",
//                           iconSize: 16,
//                           icons: Icons.date_range,
//                           valueTextStyle: appTextStyle.appTitleStyle2(
//                               fontWeight: FontWeight.w500, fontSize: 14),
//                           titleTextStyle: appTextStyle.appSubTitleStyle2(
//                               color: Colors.grey.shade600, fontSize: 14),
//                           value: taskDetail!.completedAt!,
//                         ),
//                       ),
//                     if (taskDetail?.completedBy?.name?.isNotEmpty ?? false)
//                       Flexible(
//                         child: CommonDetailViewRow(
//                           title: "Completed By",
//                           iconSize: 16,
//                           icons: Icons.access_time,
//                           valueTextStyle: appTextStyle.appTitleStyle2(
//                               fontWeight: FontWeight.w500, fontSize: 14),
//                           titleTextStyle: appTextStyle.appSubTitleStyle2(
//                               color: Colors.grey.shade600, fontSize: 14),
//                           value: taskDetail!.completedBy!.name!,
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//               ],
//
//               if (taskDetail?.completedRemark?.isNotEmpty ?? false) ...[
//                 Row(
//                   children: [
//                     Icon(Icons.comment, size: 16, color: Colors.grey.shade600),
//                     const SizedBox(width: 6),
//                     Text(
//                       "Completion Remark",
//                       style: appTextStyle.appSubTitleStyle2(
//                         color: Colors.grey.shade600,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     taskDetail!.completedRemark!,
//                     style: appTextStyle.appTitleStyle2(
//                         fontWeight: FontWeight.w500, fontSize: 14),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//
//               if (taskDetail?.completedImages?.isNotEmpty ?? false) ...[
//                 Row(
//                   children: [
//                     Icon(Icons.image, size: 16, color: Colors.grey.shade600),
//                     const SizedBox(width: 7),
//                     Text(
//                       "Completion Photo",
//                       style: appTextStyle.appSubTitleStyle2(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 imageDisplay(taskDetail!.completedImages!.first.toString()),
//                 const SizedBox(height: 16),
//               ],
//             ],
//           ),
//         ),
//       );
//     }
//
//
//
//
//     houseDetailCardView() {
//       final taskDetailData =  followUpBloc.getTaskDetailData;
//       return CommonCardView(
//
//           margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20)
//                 .copyWith(bottom: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CommonTitleRowWithIcon(
//                   title: 'House Details',
//                   icon: Icons.warehouse_outlined,
//                 ),
//                 SizedBox(height: 20),
//
//                 // CommonDetailViewRow(
//                 //   title: AppString.ownerHouseNumber,
//                 //   value: nocRequestData.title ?? '',
//                 //   btName:AppString.checkDues,
//                 //   isShowBt: true,
//                 //   onTapCallBack: (){
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //           builder: (context) => MemberUnitScreen(
//                 //               userName: nocRequestData.requester ?? '',
//                 //               houses: [
//                 //                 Houses(
//                 //                   id: nocRequestData.houseId,
//                 //                   title: nocRequestData.title,
//                 //                 )
//                 //               ])),
//                 //     );
//                 //   },
//                 // ),
//                 CommonDetailViewRow(
//                     btName:AppString.checkDues,
//                     onTapCallBack: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MemberUnitScreen(
//                                 userName: taskDetailData?.houseOwner?.name ?? '',
//                                 houses: [
//                                   Houses(
//                                     id:  taskDetailData?.houseId,
//                                     title: taskDetailData?.houseNumber,
//                                   )
//                                 ])),
//                       );
//                     },
//
//                     title: "Unit",
//                     isShowBt: statusAllowed ?true : false,
//                     icons: CupertinoIcons.house,
//                     value: taskDetailData?.houseNumber??""),
//                 CommonDetailViewRow(
//                     title: "Owner Name",
//                     icons: CupertinoIcons.person_alt_circle,
//                     value: taskDetailData?.houseOwner?.name ?? ''),
//                 CommonDetailViewRow(
//
//                   number:  taskDetailData?.houseOwner?.additionalInfoForHouseOnwer?.phone ?? '',
//
//                   title: "Owner Phone Number",
//                   icons: CupertinoIcons.phone,
//                   isShowBt: true,
//                   value: (taskDetailData?.houseOwner?.additionalInfoForHouseOnwer?.phone ?? "")
//                       .replaceFirst("+91", ""), // removes +91 only from start
//                 ),
//
//                 CommonDetailViewRow(
//                     title: "Owner Phone Email",
//                     icons: CupertinoIcons.mail,
//                     value: taskDetailData?.houseOwner?.email ?? ""),
//                 SizedBox(
//                   height: 10,
//                 )
//               ],
//             ),
//           ));
//     }
//
//
//
//     complaintDetailCardView() {
//       final taskDetailData =  followUpBloc.getTaskDetailData;
//       return CommonCardView(
//
//           margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20)
//                 .copyWith(bottom: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CommonTitleRowWithIcon(
//                   title: 'Complaint Details',
//                   icon: Icons.report_problem_outlined,
//                 ),
//                 SizedBox(height: 20),
//                 CommonDetailViewRow(
//                     title: "Unit",
//                     icons: CupertinoIcons.house,
//                     value: taskDetailData?.houseNumber??""),
//                 CommonDetailViewRow(
//                     title: "Owner Name/Unit",
//                     icons: CupertinoIcons.person_alt_circle,
//                     value: taskDetailData?.complaint?.user ?? ''),
//                 // CommonDetailViewRow(
//                 //   title: "Owner Phone Number",
//                 //   icons: CupertinoIcons.phone,
//                 //   isShowBt: true,
//                 //   value: (taskDetailData?.houseOwner?.additionalInfoForHouseOnwer?.phone ?? "")
//                 //       .replaceFirst("+91", ""), // removes +91 only from start
//                 // ),
//
//                 CommonDetailViewRow(
//                     title: "Complaint Type",
//                     icons: Icons.report_problem_outlined,
//                     value: taskDetailData?.complaint?.title ?? ""),
//                 CommonDetailViewRow(
//                     title: "Complaint Category",
//                     icons: Icons.error_outline,
//                     value: taskDetailData?.complaint?.categoryName ?? ""),
//
//                 CommonDetailViewRow(
//                     title: "Complaint Details",
//                     icons: CupertinoIcons.doc_text,
//                     value: taskDetailData?.complaint?.content ?? ""),
//                 SizedBox(
//                   height: 10,
//                 )
//               ],
//             ),
//           ));
//     }
//
//
//
//
//     detailBtRow() {
//       return Padding(
//         padding:
//         const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 20),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 if (canShowAssign)
//
//                   Flexible(
//                     child: AppButton(
//                       buttonHeight: 40,
//                       buttonName: 'Assign',
//                       buttonBorderColor: Colors.black,
//                       buttonColor: Colors.transparent,
//                       textStyle:
//                       appStyles.buttonTextStyle1(texColor: AppColors.black),
//                       flutterIcon: Icons.person_add_outlined,
//                       iconColor: AppColors.black,
//                       isShowIcon: true,
//                       isLoader: false,
//                       backCallback: () {
//                         showModalBottomSheet(
//                           context: context,
//                           backgroundColor: Colors.transparent,
//                           isScrollControlled: true,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                                 top: Radius.circular(15)),
//                           ),
//                           builder: (ctx) => SizedBox(
//                             height:
//                             MediaQuery.of(ctx).size.height * 0.6,
//                             child: AssignBottomSheet(
//                               title: "Assign To",
//                               people: [
//                                 {
//                                   "name": "All Assign",
//                                   "role": "", // optional, can be empty
//                                 },
//                                 ...followUpBloc.assignees.map((e) {
//                                   if (e.id == 0) {
//                                     return {
//                                       "name": e.name ?? "Unassigned",
//                                       // "role": e.role ?? "", // if role exists
//                                     };
//                                   } else {
//                                     return {
//                                       "name": "${e.firstName ?? ''} ${e.lastName ?? ''}".trim(),
//                                       // "role": e.role ?? "", // if role exists
//                                     };
//                                   }
//                                 }).toList(),
//                               ],
//                               selectedName: "All Assign",
//                               onAssign: (val) {
//                                 print("Selected Option: $val");
//
//                                 if (val == "All Assign") {
//                                   selectedAssigneeId = null;
//                                 } else {
//                                   final selected = followUpBloc
//                                       .assignees
//                                       .firstWhere((e) {
//                                     if (e.id == 0) {
//                                       return e.name == val;
//                                     } else {
//                                       return "${e.firstName ?? ''} ${e.lastName ?? ''}"
//                                           .trim() ==
//                                           val;
//                                     }
//                                   });
//                                   selectedAssigneeId = selected.id;
//                                 }
//
//                                 print(
//                                     "Selected Assignee Id: $selectedAssigneeId");
//
//                                 setState(() {
//                                   assignTo = val;
//                                 });
//                                 followUpBloc.add(OnAssignTaskEvent(
//                                   assignToId: selectedAssigneeId,
//                                   taskId: widget.taskListData?.id, mContext: context,
//
//                                 ));
//
//
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 if (canShowAssign)
//                   SizedBox(
//                     width: canShowCancel ?15:0,
//                   ),
//
//
//                 if (canShowCancel)
//                   Flexible(
//                     child: AppButton(
//                       buttonHeight: 40,
//                       buttonName: 'Cancel',
//                       buttonBorderColor: Colors.red,
//                       buttonColor: Colors.transparent,
//                       textStyle:
//                       appStyles.buttonTextStyle1(texColor: AppColors.red),
//                       flutterIcon: Icons.close,
//                       iconColor: AppColors.red,
//                       isShowIcon: true,
//                       isLoader: false,
//                       backCallback: () {
//                         WorkplaceWidgets.showDeleteConfirmation(
//                             context: context,
//                             title: 'Cancel Task',
//                             content: AppString.cancelTaskContent,
//                             onConfirm: () {
//                               followUpBloc
//                                   .add(OnDeleteTaskEvent(taskId: widget.taskListData?.id ?? 0));
//
//                             },
//                             buttonName1: AppString.no,
//                             buttonName2: AppString.yes);
//                       },
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(
//               height: 15,
//             ),
//
//             if (canShowComplete)
//
//               AppButton(
//                 buttonName: 'Mark Complete',
//                 buttonColor: AppColors.textDarkGreenColor,
//                 textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
//                 flutterIcon: Icons.check,
//                 iconColor: AppColors.white,
//                 isShowIcon: true,
//                 isLoader: false,
//                 backCallback: () {
//                   // followUpBloc.add(
//                   //   OnMarkTaskAsCompleteEvent(
//                   //     mContext: context,
//                   //     taskId: taskId,
//                   //   ),
//                   // );
//                   TextEditingController commentsTextController = TextEditingController();
//                   WorkplaceWidgets.showDialogForCompleted(
//                     context: context,
//                     title: AppString.markTaskComplete,
//                     content:
//                     "Are you sure you want to reject this expense? This action cannot be undone.",
//                     buttonName1: AppString.completeTaskButton,
//                     buttonName2: AppString.cancelButton,
//                     disableButtonColor: AppColors.textDarkGreenColor.safeOpacity(0.5),
//                     unableButtonColor: AppColors.textDarkGreenColor,
//                     textController: commentsTextController,
//                     hintText: AppString.enterReasonHint,
//                     maxLine: 2,
//                     selectedPhotoPath: selectProfilePhotoPath, // 👈 pass current photo
//                     onPressedButton1: () {
//                       if (commentsTextController.text.trim().isNotEmpty) {
//                         followUpBloc.add(
//                           OnMarkTaskAsCompleteEvent(
//                             mContext: context,
//                             taskId: widget.taskListData?.id,
//                             remark: commentsTextController.text.toString(),
//                             completedImages: selectProfilePhotoPath,
//                           ),
//                         );
//                         _resetImageState();
//                         Navigator.pop(context);
//                       }
//                     },
//                     onPressedButton2: () {
//                       Navigator.of(context).pop();
//                     },
//                     onSelectPhoto: () async {
//                       closeKeyboard();
//                       final path = await photoPickerBottomSheet(); // Returns image path
//                       if (path != null) {
//                         setState(() {
//                           selectProfilePhotoPath = path; // Update parent state
//                           isImageSelected = true;
//                         });
//                       }
//                       return selectProfilePhotoPath;
//                     },
//                     onRemovePhoto: () {
//                       setState(() {
//                         selectProfilePhotoPath = null; // 👈 clear photo in parent
//                         isImageSelected = false;
//                       });
//                     },
//                     label: 'Remark',
//                   );
//                 },
//               )
//           ],
//         ),
//       );
//     }
//
//     detailTabView() {
//       return Column(
//         children: [
//           detailAssignmentCardView(),
//           if (restrictedStatuses.contains(widget.taskListData?.status?.toLowerCase()))
//             taskCompletedCardView(),
//           if (widget.taskListData?.moduleName?.toLowerCase() != "miscellaneous" && widget.taskListData?.houseOwner?.name != null)
//             houseDetailCardView(),
//           if (widget.taskListData?.moduleName?.toLowerCase() == "complaint")
//             complaintDetailCardView(),
//           SizedBox(
//             height: 15,
//           ),
//           detailBtRow(),
//         ],
//       );
//     }
//
//     followUpButton() {
//       return AppButton(
//         buttonName: 'Add Follow Up',
//         buttonColor: AppColors.appBlueColor,
//         textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
//         flutterIcon: Icons.add,
//         iconColor: AppColors.white,
//         isShowIcon: true,
//         isLoader: false,
//         backCallback: () {
//
//           Navigator.push(
//             context,
//             SlideLeftRoute(widget:  AddFollowUpScreen(taskId: widget.taskListData?.id)),
//           ).then((value) {
//             if (value == true) {
//               setState(() {
//                 isShowLoader = false;
//
//               });
//               followUpBloc.add(OnGetFollowUpListEvent(
//                 taskId: widget.taskListData?.id ?? 0,
//               ));
//               followUpBloc.add(OnGetTaskDetailEvent(taskId: widget.taskListData?.id ?? 0));
//             }
//           });
//         },
//       );
//     }
//     quotationButton() {
//       return AppButton(
//         buttonName: 'Add Quotation',
//         buttonColor: AppColors.appBlueColor,
//         textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
//         flutterIcon: Icons.add,
//         iconColor: AppColors.white,
//         isShowIcon: true,
//         isLoader: false,
//         backCallback: () {
//
//           Navigator.push(
//             context,
//             SlideLeftRoute(widget:  AddQuotationForm(taskId: widget.taskListData?.id ?? 0)),
//           ).then((value) {
//             if (value == true) {
//               setState(() {
//                 isShowLoader = false;
//
//               });
//               followUpBloc.add(OnGetQuotationListEvent(taskId: widget.taskListData?.id ?? 0));
//
//             }
//           });
//         },
//       );
//     }
//     followUpTabView() {
//       final followUps = followUpBloc.getFollowUpListData;
//       final screenHeight = MediaQuery.of(context).size.height;
//
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             const SizedBox(height: 6),
//             if (followUps.isEmpty)
//               SizedBox(
//                 height: screenHeight * 0.4, // Screen ka 40%
//                 child:  Center(
//                   child: Text(
//                     "No follow-up found",
//                     style: appTextStyle.noDataTextStyle(),
//                   ),
//                 ),
//               )
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.only(bottom: 80),
//                 itemCount: followUps.length,
//                 itemBuilder: (context, index) {
//                   final getFollowUpListData = followUps[index];
//                   return FollowUpDetailCardView(
//                     getFollowUpListData: getFollowUpListData,
//                     isStatusCompleted:  !restrictedStatuses.contains(widget.taskListData?.status?.toLowerCase()) ? true: false,
//                     onDelete: () {
//                       followUpBloc.add(
//                         OnDeleteTaskFollowUpEvent(
//                           taskId: widget.taskListData?.id ?? 0,
//                           followUpId: getFollowUpListData.id ?? 0,
//                         ),
//                       );
//                     },
//                     onEdit: () {
//                       Navigator.push(
//                         context,
//                         SlideLeftRoute(
//                           widget: AddFollowUpScreen(
//                             isEditMode: true,
//                             getFollowUpListData: getFollowUpListData,
//                           ),
//                         ),
//                       ).then((value) {
//                         if (value == true) {
//                           setState(() {
//                             isShowLoader= false;
//                           });
//
//                           followUpBloc.add(
//                             OnGetFollowUpListEvent(
//                               taskId: widget.taskListData?.id ?? 0,
//                             ),
//                           );
//                         }
//                       });
//                     },
//                   );
//                 },
//               ),
//           ],
//         ),
//       );
//     }
//
//
//     historyTabView() {
//       final historyList = followUpBloc.taskHistoryListData ?? [];
//       final screenHeight = MediaQuery.of(context).size.height;
//
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             const SizedBox(height: 6),
//             if (historyList.isEmpty)
//               SizedBox(
//                 height: screenHeight * 0.4, // Screen ka 40%
//                 child:  Center(
//                   child: Text(
//                     "No history found",
//                     style: appTextStyle.noDataTextStyle(),
//                   ),
//                 ),
//               )
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: EdgeInsets.zero,
//                 itemCount: historyList.length,
//                 itemBuilder: (context, index) {
//                   final historyData = historyList[index];
//                   return FollowUpHistoryCardView(
//                     taskHistoryListData: historyData,
//                     // agar is widget ko data chahiye to yaha pass karna hoga
//                     // getFollowUpHistoryData: historyData,
//                   );
//                 },
//               ),
//           ],
//         ),
//       );
//     }
//
//
//     commentTextField() {
//       return Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.3))),
//         ),
//         child: TagTextField(
//           minLines: 1,
//           maxLines: 5,
//           btName: 'Add',
//           isSendButtonTrue: true,
//           leadingWidget: const [SizedBox(width: 20)],
//           focusOnTextField: false,
//           searchResults: (List<User> list) {},
//           onChange: (content) {
//             // createPostBloc.add(OnPostContentEditEvent(
//             //     context: context, content: content));
//           },
//           onPostClick: (content) {
//             followUpBloc.add(OnCommentOnTaskEvent(
//                 taskId: widget.taskListData?.id ?? 0, comment: content));
//           },
//         ),
//       );
//     }
//
//     commentTabView() {
//       final comments = followUpBloc.getTaskCommentData;
//       final screenHeight = MediaQuery.of(context).size.height;
//
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             const SizedBox(height: 6),
//             if (comments == null || comments.isEmpty)
//               SizedBox(
//                 height: screenHeight * 0.4, // Screen height ka 40%
//                 child:  Center(
//                   child: Text(
//                     "No comments found",
//                     style: appTextStyle.noDataTextStyle(),
//                   ),
//                 ),
//               )
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.only(bottom: 80),
//                 itemCount: comments.length,
//                 itemBuilder: (context, index) {
//                   final commentListData = comments[index];
//                   return FollowUpCommentCardView(
//                     getTaskCommentData: commentListData,
//                     isStatusCompleted: !restrictedStatuses.contains(widget.taskListData?.status?.toLowerCase()) ? true: false,
//                     onEdit: () {
//                       setState(() {
//                         isEdit = true;
//                       });
//                       debugPrint("Edit button clicked");
//                     },
//                     onDelete: () {
//                       followUpBloc.add(
//                         OnDeleteTaskCommentEvent(
//                           taskId: widget.taskListData?.id ?? 0,
//                           commentId: commentListData?.id ?? 0,
//                         ),
//                       );
//                     },
//                     onSave: (newComment) {
//                       followUpBloc.add(
//                         OnUpdateTaskCommentEvent(
//                           taskId: widget.taskListData?.id ?? 0,
//                           comment: newComment,
//                           commentId: commentListData?.id ?? 0,
//                         ),
//                       );
//                     },
//                     onCancel: () {},
//                   );
//                 },
//               ),
//           ],
//         ),
//       );
//     }
//
//
//
//
//
//
//     return ContainerFirst(
//       contextCurrentView: context,
//       isSingleChildScrollViewNeed: true,
//       isFixedDeviceHeight: true,
//       isListScrollingNeed: false,
//       isOverLayStatusBar: false,
//       appBarHeight: 50,
//       appBar: CommonAppBar(
//         isThen: false,
//         title: 'Task Details',
//         action: canShowEdit
//             ?InkWell(
//           child: WorkplaceIcons.iconImage(
//             imageUrl: WorkplaceIcons.editButtonIcon,
//             imageColor: Colors.black87,
//             iconSize: const Size(20, 20),
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               SlideLeftRoute(
//                 widget: AddTaskScreen(
//                   getTaskDetailData: followUpBloc.getTaskDetailData,
//                   isEditMode: true,
//                 ),
//               ),
//             ).then((value) {
//               if (value == true) {
//                 setState(() {
//                   isShowLoader = false;
//                 });
//                 followUpBloc
//                     .add(OnGetTaskDetailEvent(taskId: widget.taskListData?.id ?? 0));
//                 // }
//               }
//             });
//           },
//         ): SizedBox(),
//         icon: WorkplaceIcons.backArrow,
//       ),
//       containChild: BlocListener<FollowUpBloc, FollowUpState>(
//         bloc: followUpBloc,
//         listener: (context, state) {
//           if (state is OnCommentOnTaskErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//           if (state is GetTaskCommentListErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//
//           if (state is ApprovedQuotationErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//
//           if (state is RejectQuotationErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//
//           if (state is OnDeleteTaskFollowUpErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//           if (state is OnUpdateTaskCommentErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//
//           // if (state is FollowUpListErrorState) {
//           //   WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           // }
//           if (state is OnDeleteTaskCommentErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           } if (state is AssignTaskErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//           if (state is MarkTaskAsCompleteErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//           if (state is DeleteQuotationErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//
//           if (state is DeleteTaskErrorState) {
//             WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//           }
//
//
//           if (state is DeleteTaskDoneState) {
//             Navigator.pop(context, true);
//             WorkplaceWidgets.successToast(state.message);
//
//           } if (state is DeleteQuotationDoneState) {
//             WorkplaceWidgets.successToast(state.message);
//             followUpBloc.add(OnGetQuotationListEvent(taskId: widget.taskListData?.id ?? 0));
//
//           }
//
//           if (state is RejectQuotationDoneState) {
//             WorkplaceWidgets.successToast(state.message);
//             followUpBloc.add(OnGetQuotationListEvent(taskId: widget.taskListData?.id ?? 0));
//
//           }
//
//           if (state is ApprovedQuotationDoneState) {
//             WorkplaceWidgets.successToast(state.message);
//             followUpBloc.add(OnGetQuotationListEvent(taskId: widget.taskListData?.id ?? 0));
//
//           }
//
//           if (state is MarkTaskAsCompleteDoneState) {
//             WorkplaceWidgets.successToast(state.message);
//             Navigator.pop(context, true);
//           }
//
//           if (state is GetTaskCommentListDoneState) {
//             // WorkplaceWidgets.successToast(state.message);
//           }
//           if (state is AssignTaskDoneState) {
//             isShowLoader =  false;
//             followUpBloc.add(OnGetTaskDetailEvent(taskId: widget.taskListData?.id ?? 0, isAssign: true));
//             WorkplaceWidgets.successToast(state.message);
//           }
//
//
//           if (state is GetTaskDetailDoneState){
//             setState(() {
//
//             });
//           }
//           if (state is OnUpdateTaskCommentDoneState) {
//             setState(() {
//               isEdit= false;
//             });
//           }
//
//         },
//         child: BlocBuilder<FollowUpBloc, FollowUpState>(
//           bloc: followUpBloc,
//           builder: (context, state) {
//             if (state is OnCommentOnTaskDoneState) {
//               isShowLoader =  false;
//               followUpBloc.add(OnGetTaskCommentListEvent(
//                 taskId: widget.taskListData?.id ?? 0,
//               ));
//               // WorkplaceWidgets.successToast(state.message);
//             }
//
//
//             if (state is AssignTaskDoneState) {
//               isShowLoader =  false;
//               followUpBloc.add(OnGetTaskDetailEvent(taskId: widget.taskListData?.id ?? 0, isAssign: true));
//               WorkplaceWidgets.successToast(state.message);
//             }
//             if (state is OnDeleteTaskFollowUpDoneState) {
//               isShowLoader =  false;
//               followUpBloc.add(OnGetFollowUpListEvent(
//                 taskId: widget.taskListData?.id ?? 0,
//               ));
//
//               WorkplaceWidgets.successToast(state.message);
//             }
//
//             if (state is OnDeleteTaskCommentDoneState) {
//               isShowLoader =  false;
//               followUpBloc.add(OnGetTaskCommentListEvent(
//                 taskId: widget.taskListData?.id ?? 0,
//               ));
//               WorkplaceWidgets.successToast(state.message);
//             }
//             if (state is OnUpdateTaskCommentDoneState) {
//               isShowLoader =  false;
//
//               followUpBloc.add(OnGetTaskCommentListEvent(
//                 taskId: widget.taskListData?.id ?? 0,
//               ));
//               WorkplaceWidgets.successToast(state.message);
//             }
//             bool isInitialLoading =   ((state is GetTaskDetailLoadingState || state is GetTaskCommentListLoadingState || state is FollowUpListLoadingState) &&  isShowLoader);
//             return Stack(
//               children: [
//                 if (isInitialLoading)
//                   WorkplaceWidgets.progressLoader(context),
//                 if (! isInitialLoading)
//                   Column(
//                     children: [
//                       topCardView(),
//                       tabBarLineView(),
//                       IndexedStack(
//                         index: tabController.index,
//                         children: [
//                           Visibility(
//                             visible: tabController.index == 0,
//                             maintainState: true,
//                             child: detailTabView(),
//                           ),
//                           Visibility(
//                             visible: tabController.index == 1,
//                             maintainState: true,
//                             child: quotationTabView(),
//                           ),
//                           Visibility(
//                             visible: tabController.index == 2,
//                             maintainState: true,
//                             child: commentTabView(),
//                           ),
//                           Visibility(
//                             visible: tabController.index == 3,
//                             maintainState: true,
//                             child: followUpTabView(),
//                           ),
//                           Visibility(
//                             visible: tabController.index == 4,
//                             maintainState: true,
//                             child: historyTabView(),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 if ((state is GetTaskDetailLoadingState ||state is ApprovedQuotationLoadingState||state is RejectedQuotationLoadingState||state is DeleteQuotationLoadingState|| state is AssignTaskLoadingState ||  state is MarkTaskAsCompleteLoadingState || state is DeleteTaskLoadingState)&& isShowLoader )
//                   WorkplaceWidgets.progressLoader(context),
//               ],
//             );
//           },
//         ),
//       ),
//       bottomMenuView: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           if (tabController.index == 2 && isEdit == false) commentTextField(),
//           if (tabController.index == 3)
//             Container(
//               color: Colors.white,
//               padding:
//               const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 15),
//               child: followUpButton(),
//             ) , if (tabController.index == 1)
//             Container(
//               color: Colors.white,
//               padding:
//               const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 15),
//               child: quotationButton(),
//             )
//         ],
//       ),
//     );
//   }
// }
//




//
