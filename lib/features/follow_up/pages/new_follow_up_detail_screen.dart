// import 'package:asetize/widgets/common_card_view.dart';
//
// import '../../../core/util/app_theme/text_style.dart';
// import '../../../imports.dart';
// import '../../../widgets/common_detail_view_row.dart';
// import '../bloc/follow_up_bloc.dart';
// import '../bloc/follow_up_event.dart';
// import '../bloc/follow_up_state.dart';
// import '../models/get_task_list_model.dart';
// import 'add_follow_up_screen.dart';
// import 'new_add_follow_up_screen.dart';
//
// class FollowUpDetailScreen extends StatefulWidget {
//   final TaskListData taskListData;
//   final bool isShowBottomMenu;
//
//   const FollowUpDetailScreen(
//       {super.key, required this.taskListData, this.isShowBottomMenu = true});
//
//   @override
//   State<FollowUpDetailScreen> createState() => _FollowUpDetailScreenState();
// }
//
// class _FollowUpDetailScreenState extends State<FollowUpDetailScreen> {
//   late FollowUpBloc followUpBloc;
//   bool isShowLoader = true;
//
//   @override
//   void initState() {
//     followUpBloc = BlocProvider.of<FollowUpBloc>(context);
//     // followUpBloc.getFollowUpListData?.clear();
//
//     followUpBloc
//         .add(OnGetFollowUpListEvent(taskId: widget.taskListData.id ?? 0));
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     void showAddFollowUpRequiredPopup(BuildContext context) {
//       WorkplaceWidgets.errorPopUp(
//         context: context,
//         isShowIcon: true,
//         // iconColor: Colors.green,
//         // icon: Icons.verified, // ✅ No dues icon
//         content: AppString.followUpNotAdded,
//         onTap: () {
//           Navigator.of(context).pop();
//         },
//       );
//     }
//
//     // void showAddFollowUpRequiredPopup(BuildContext context) {
//     //   showDialog(
//     //     context: context,
//     //
//     //     builder: (ctx) => WorkplaceWidgets.errorPopUp(
//     //         isShowIcon: true,
//     //
//     //         context: context,
//     //       content: AppString.followUpNotAdded,
//     //       onTap: (){
//     //           Navigator.pop(context);
//     //
//     //       }
//     //       // buttonName2: AppString.ok,
//     //       // content: AppString.followUpNotAdded,
//     //       // onPressedButton2: () {
//     //       //   Navigator.pop(context);
//     //       // },
//     //       // onPressedButton2Color: Colors.blue,
//     //       // onPressedButton2TextColor: Colors.white,
//     //     ),
//     //   );
//     // }
//
//     Widget buildButton({
//       required IconData icon,
//       required String text,
//       required Color color,
//       required Color iconColor,
//       required Color borderColor,
//       required VoidCallback onTap,
//     }) {
//       return GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//           decoration: BoxDecoration(
//             color: color,
//             border: Border.all(width: 1, color: borderColor),
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: Row(
//             mainAxisSize:
//                 MainAxisSize.min, // Ensures buttons don't expand unnecessarily
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Icon(icon, color: iconColor, size: 18),
//               const SizedBox(width: 4),
//               Text(
//                 text,
//                 style: TextStyle(
//                     color: iconColor,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     Color getStatusColor(String status) {
//       switch (status) {
//         case 'Completed':
//           return const Color(0xFFD3D3D3); // Light Grey
//         case "Didn't Pick":
//           return const Color(0xFFFFE0B2); // Light Orange
//         case 'Agreed':
//           return const Color(0xFFC8E6C9); // Light Green
//         case 'Follow Up':
//           return const Color(0xFFBBDEFB); // Light Blue
//         default:
//           return const Color(0xFFE0E0E0); // Default Light Grey
//       }
//     }
//
//     Widget invoiceDateView(
//         {IconData icon = Icons.calendar_today_outlined,
//         String title = '',
//         String value = '',
//         Color iconColor = const Color(0xFF757575),
//         Color valueColor = Colors.black}) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 2),
//             child: Icon(icon, size: 18, color: iconColor),
//           ),
//           const SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: appTextStyle.appSubTitleStyle2(fontSize: 13),
//               ),
//               const SizedBox(height: 1),
//               Text(
//                 value,
//                 style:
//                     appTextStyle.appTitleStyle(fontSize: 14, color: valueColor),
//               ),
//             ],
//           ),
//         ],
//       );
//     }
//
//     Widget maintenanceCardView() {
//       return CommonCardView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Due Monthly Maintenance Invoice',
//                 style: appTextStyle.appTitleStyle2(),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.receipt_long,
//                       size: 20, color: AppColors.textBlueColor),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       'Your April month maintenance invoice of Rs 1050 is outstanding.',
//                       style: appTextStyle.appTitleStyle(
//                           fontSize: 14, fontWeight: FontWeight.w400),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     /// Invoice Date
//                     invoiceDateView(
//                         icon: Icons.calendar_month,
//                         title: 'Invoice Date',
//                         value: "May 25, 2025"),
//
//                     /// Due Date
//                     invoiceDateView(
//                       icon: Icons.error,
//                       title: 'Due Date',
//                       value: "May 30, 2025",
//                       iconColor: Colors.red,
//                       valueColor: Colors.red,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//     }
//
//     Widget ownerCardView({
//       required String unit,
//       required String owner,
//       required List<String> status,
//     }) {
//       return owner.isNotEmpty
//           ? CommonCardView(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                 child: Row(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start, // align items from top
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(owner, style: appTextStyle.appTitleStyle2()),
//                           Text(unit, style: appTextStyle.appSubTitleStyle2()),
//                           const SizedBox(height: 10),
//                           SizedBox(
//                             height: 26,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: status.length,
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index) {
//                                 return Container(
//                                   alignment: Alignment.center,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 15),
//                                   margin: const EdgeInsets.only(right: 10),
//                                   decoration: BoxDecoration(
//                                     color: getStatusColor(status[index])
//                                         .safeOpacity(0.8),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Text(status[index],
//                                       style: appTextStyle.appTitleStyle(
//                                           color: Colors.black,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w500)),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     buildButton(
//                       icon: Icons.phone,
//                       text: 'Call',
//                       color: AppColors.textBlueColor,
//                       iconColor: Colors.white,
//                       borderColor: Colors.blue,
//                       onTap: () {
//                         projectUtil.makingPhoneCall(
//                             phoneNumber: widget.taskListData.houseOwner
//                                     ?.additionalInfo?.phone ??
//                                 '');
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : SizedBox();
//     }
//
//
//
//     Widget nextFollowUpCardView() {
//       if (followUpBloc.getFollowUpListData == null ||
//           followUpBloc.getFollowUpListData!.isEmpty) {
//         return const SizedBox();
//       }
//       final followUpListData = followUpBloc.getFollowUpListData?[0];
//       return CommonCardView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CommonDetailViewRow(
//                 isFollowUp: true,
//                 title: followUpListData?.followupDate ?? '',
//                 // value: followUpListData?.followupDate ?? '',
//                 icons: Icons.calendar_month,
//               ),
//               CommonDetailViewRow(
//                 title: followUpListData?.remark ?? '',
//                 isFollowUp: true,
//
//                 // value: followUpListData?.remark ?? '',
//                 icons: Icons.chat,
//               ),
//               Divider(height: 0, color: Colors.grey.shade200, thickness: 0.8),
//               const SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(children: [
//                     Icon(Icons.access_time_sharp,
//                         size: 16, color: Colors.grey.shade600),
//                     const SizedBox(width: 6),
//                     Text(
//                       'Created: ${followUpListData?.createdAt}',
//                       style: appTextStyle.appSubTitleStyle2(fontSize: 12),
//                     ),
//                   ]),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.info_outline, color: Colors.black, size: 16),
//                         SizedBox(width: 6),
//                         Text('Details Pending',
//                             style: TextStyle(
//                                 fontSize: 12, fontWeight: FontWeight.w500)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     Widget followUpHistoryCardView({required bool isShowBottomMenu}) {
//       final totalItems = followUpBloc.getFollowUpListData?.length ?? 0;
//
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
//         child: ListView.builder(
//           padding: EdgeInsets.zero,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: isShowBottomMenu
//               ? (totalItems > 1 ? totalItems - 1 : 0) // Skip first item
//               : totalItems, // Show all items
//           itemBuilder: (BuildContext context, int index) {
//             // Adjust index based on condition
//             final adjustedIndex = isShowBottomMenu ? index + 1 : index;
//             final followUpListData =
//                 followUpBloc.getFollowUpListData?[adjustedIndex];
//
//             return CommonCardView(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CommonDetailViewRow(
//                       isFollowUp: true,
//                       title: followUpListData?.followupDate ?? '',
//                       icons: Icons.calendar_month,
//                     ),
//                     CommonDetailViewRow(
//                       isFollowUp: true,
//                       title: followUpListData?.remark ?? '',
//                       icons: Icons.chat,
//                     ),
//                     Divider(
//                         height: 0, color: Colors.grey.shade200, thickness: 0.8),
//                     const SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(children: [
//                           Icon(Icons.access_time_sharp,
//                               size: 16, color: Colors.grey.shade600),
//                           const SizedBox(width: 6),
//                           Text(
//                             'Created: ${followUpListData?.createdAt}',
//                             style: appTextStyle.appSubTitleStyle2(fontSize: 12),
//                           ),
//                         ]),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Row(
//                             children: [
//                               Icon(Icons.info_outline,
//                                   color: Colors.black, size: 16),
//                               SizedBox(width: 6),
//                               Text('Details Pending',
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     }
//
//     return ContainerFirst(
//         contextCurrentView: context,
//         isSingleChildScrollViewNeed: true,
//         isFixedDeviceHeight: false,
//         isListScrollingNeed: false,
//         isOverLayStatusBar: false,
//         appBarHeight: 56,
//         appBar: const CommonAppBar(
//           title: 'Follow Up Detail',
//         ),
//         containChild: BlocListener<FollowUpBloc, FollowUpState>(
//             bloc: followUpBloc,
//             listener: (context, state) {
//               if (state is GetTaskListErrorState) {
//                 WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//               }
//
//               if (state is MarkTaskAsCompleteErrorState) {
//                 WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
//               }
//
//               if (state is MarkTaskAsCompleteDoneState) {
//                 WorkplaceWidgets.successToast(state.message);
//                 // Navigator.pop(context, true);
//               }
//               if (state is GetTaskListDoneState) {
//                 WorkplaceWidgets.successToast(state.message);
//               }
//             },
//             child: BlocBuilder<FollowUpBloc, FollowUpState>(
//               bloc: followUpBloc,
//               builder: (context, state) {
//                 if (state is FollowUpListLoadingState && isShowLoader) {
//                   return Center(
//                     child: WorkplaceWidgets.progressLoader(context),
//                   ); // Or your custom loader
//                 }
//
//                 return Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Column(
//                         children: [
//                           maintenanceCardView(),
//                           ownerCardView(
//                             unit: 'House ${widget.taskListData.houseNumber}',
//                             owner: widget.taskListData.houseOwner?.name ?? '',
//                             status: [
//                               "${widget.taskListData.status}",
//                               "Follow-up #1"
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           if (followUpBloc.getFollowUpListData!.isNotEmpty &&
//                               widget.isShowBottomMenu)
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 'Next Follow-up',
//                                 style: appTextStyle.appTitleStyle2(),
//                               ),
//                             ),
//                           SizedBox(
//                               height: followUpBloc
//                                           .getFollowUpListData!.isNotEmpty &&
//                                       widget.isShowBottomMenu
//                                   ? 10
//                                   : 0),
//                           if (widget.isShowBottomMenu) nextFollowUpCardView(),
//                           SizedBox(height: widget.isShowBottomMenu ? 15 : 0),
//                           if (followUpBloc.getFollowUpListData!.isNotEmpty &&
//                               (followUpBloc.getFollowUpListData?.length ?? 0) >
//                                   1)
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 'Follow-up History',
//                                 style: appTextStyle.appTitleStyle2(),
//                               ),
//                             ),
//                           const SizedBox(height: 10),
//                           followUpHistoryCardView(
//                               isShowBottomMenu: widget.isShowBottomMenu),
//                           SizedBox(
//                               height: followUpBloc
//                                           .getFollowUpListData!.isNotEmpty &&
//                                       (followUpBloc.getFollowUpListData
//                                                   ?.length ??
//                                               0) >
//                                           1
//                                   ? 80
//                                   : 0),
//                         ],
//                       ),
//                     ),
//                     // if (state is MarkTaskAsCompleteLoadingState)
//                     //     Center(
//                     // child: WorkplaceWidgets.progressLoader(context),
//                     // ) // Or your custom loader
//                   ],
//                 );
//               },
//             )),
//         bottomMenuView: widget.isShowBottomMenu
//             ? BlocBuilder<FollowUpBloc, FollowUpState>(
//                 bloc: followUpBloc,
//                 builder: (context, state) {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 15, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFf9fafb),
//                           border: Border(
//                             top: BorderSide(
//                               color: Colors.grey.shade300,
//                               width: 0.5,
//                             ),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: AppButton(
//                                 textStyle: const TextStyle(
//                                     color: Colors.white, fontSize: 16),
//                                 buttonName: 'Mark Complete',
//                                 isLoader:
//                                     state is MarkTaskAsCompleteLoadingState
//                                         ? true
//                                         : false,
//                                 buttonColor: AppColors.textDarkGreenColor,
//                                 buttonBorderColor: Colors.grey,
//                                 backCallback: () {
//                                   followUpBloc.getFollowUpListData!.isEmpty
//                                       ? showAddFollowUpRequiredPopup(context)
//                                       : Size(1, 1);
//
//                                   // followUpBloc.add(
//                                   //         // OnMarkTaskAsCompleteEvent(
//                                   //         //     mContext: context,
//                                   //         //     taskId: widget.taskListData.id)
//                                   //
//                                   // );
//                                 },
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: AppButton(
//                                 textStyle: const TextStyle(
//                                     color: Colors.white, fontSize: 16),
//                                 buttonName: 'Add Follow-up',
//                                 buttonColor: AppColors.textBlueColor,
//                                 backCallback: () {
//                                   Navigator.push(
//                                     context,
//                                     SlideLeftRoute(
//                                       widget: AddFollowUpScreen(
//                                         taskId: widget.taskListData.id,
//                                         houses: [],
//                                       ),
//                                     ),
//                                   ).then((value) {
//                                     if (value == true) {
//                                       setState(() {
//                                         isShowLoader = false;
//                                       });
//
//                                       followUpBloc.add(OnGetFollowUpListEvent(
//                                           taskId: widget.taskListData.id ?? 0));
//                                     }
//                                   });
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               )
//             : SizedBox());
//   }
// }
