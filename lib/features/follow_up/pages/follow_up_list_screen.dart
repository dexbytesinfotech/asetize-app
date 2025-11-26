// import 'package:flutter/material.dart';
// import 'package:asetize/core/core.dart';
// import 'package:asetize/widgets/common_card_view.dart';
// import '../../app_global_components/common_floating_add_button.dart';
// import '../data/models/user_response_model.dart';
// import '../find_helper/widgets/follow_up_card_view.dart';
// import '../presentation/widgets/appbar/common_appbar.dart';
// import '../presentation/widgets/basic_view_container/container_first.dart';
// import '../presentation/widgets/common_text_field_with_error.dart';
// import '../presentation/widgets/workplace_widgets.dart';
// import 'add_follow_up_screen.dart';
//
// class FollowUpTasksScreen extends StatefulWidget {
//   final List<Houses> houses;
//   const FollowUpTasksScreen({super.key, required this.houses});
//
//   @override
//   State<FollowUpTasksScreen> createState() => _FollowUpTasksScreenState();
// }
//
// class _FollowUpTasksScreenState extends State<FollowUpTasksScreen>
//     with TickerProviderStateMixin {
//   Map<String, TextEditingController> controllers = {
//     'amenityType': TextEditingController(),
//   };
//
//   Map<String, FocusNode> focusNodes = {
//     'amenityType': FocusNode(),
//   };
//
//   Map<String, String> errorMessages = {
//     'amenityType': "",
//   };
//
//   String? selectedAmenity;
//   String selectedStatus = 'All Statuses';
//   bool showTodayOnly = true;
//   late TabController tabController;
//   int tabInitialIndex = 0;
//   final amenityType = [
//     'All Statuses',
//     'Follow Up',
//     'Agreed',
//     "Didn't Pick",
//     'Completed',
//   ];
//
//   final tasks = [
//     {
//       'flat': 'D-402',
//       'name': 'Sonia Gupta',
//       'created': 'May 07, 2025',
//       'date': 'May 12, 2025',
//       'status': 'Completed',
//       'note': 'Payment received',
//     },
//     {
//       'flat': 'C-304',
//       'name': 'Amit Patel',
//       'created': 'May 07, 2025',
//       'date': 'May 15, 2025',
//       'status': "Didn't Pick",
//       'note': '',
//     },
//     {
//       'flat': 'B-205',
//       'name': 'Priya Mehta',
//       'created': 'May 09, 2025',
//       'date': 'May 17, 2025',
//       'status': 'Agreed',
//       'note': 'Promised to pay by 16th',
//     },
//     {
//       'flat': 'A-202',
//       'name': 'Vikram Singh',
//       'created': 'May 10, 2025',
//       'date': 'May 18, 2025',
//       'status': 'Follow Up',
//       'note': '',
//     },
//   ];
//
//   final tasks2 = [
//     {
//       'flat': 'D-402',
//       'name': 'Sonia Gupta',
//       'created': 'May 07, 2025',
//       'date': 'May 12, 2025',
//       'status': 'Completed',
//       'note': 'Payment received',
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 2, vsync: this);
//     tabController.addListener(() {
//       setState(() {
//         tabInitialIndex = tabController.index;
//       });
//     });
//   }
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
//       default:
//         return const Color(0xFFE0E0E0); // Default Light Grey
//     }
//   }
//
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
//       default:
//         return Colors.black87;
//     }
//   }
//
//   void showAmenityTypeBottomSheet(BuildContext context) {
//     WorkplaceWidgets.showCustomAndroidBottomSheet(
//       context: context,
//       title: 'Select Status',
//       valuesList: amenityType,
//       selectedValue: controllers['amenityType']?.text ?? "",
//       onValueSelected: (value) {
//         setState(() {
//           controllers['amenityType']?.text = value;
//           selectedAmenity = value;
//           errorMessages['amenityType'] = "";
//         });
//       },
//     );
//   }
//
//   Widget categoryTypeField() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             margin: const EdgeInsets.only(left: 0),
//             width: MediaQuery.of(context).size.width,
//             child: GestureDetector(
//               onTap: () {
//                 FocusScope.of(context).unfocus();
//                 showAmenityTypeBottomSheet(context);
//               },
//               child: AbsorbPointer(
//                 child: CommonTextFieldWithError(
//                   key: ValueKey(controllers['amenityType']?.text),
//                   focusNode: focusNodes['amenityType'],
//                   isShowBottomErrorMsg: true,
//                   errorMessages: errorMessages['amenityType']?.toString() ?? '',
//                   controllerT: controllers['amenityType'],
//                   borderRadius: 8,
//                   inputHeight: 50,
//                   errorLeftRightMargin: 0,
//                   maxCharLength: 50,
//                   readOnly: true,
//                   errorMsgHeight: 0,
//                   autoFocus: false,
//                   inputFieldSuffixIcon: const Icon(
//                     Icons.keyboard_arrow_down,
//                     color: Colors.grey,
//                   ),
//                   enabledBorderColor: Colors.white,
//                   focusedBorderColor: Colors.white,
//                   hintStyle: appStyles.textFieldTextStyle(
//                       fontWeight: FontWeight.w400,
//                       texColor: Colors.grey.shade600,
//                       fontSize: 14),
//
//                   showError: true,
//                   capitalization: CapitalizationText.none,
//                   backgroundColor: AppColors.white,
//                   textInputAction: TextInputAction.done,
//                   borderStyle: BorderStyle.solid,
//                   cursorColor: Colors.grey,
//                   hintText: 'Select status',
//                   // placeHolderTextWidget: LabelWidget(labelText:'Follow-up Status'),
//                   textStyle:
//                       appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
//                   contentPadding: const EdgeInsets.only(left: 15, right: 15),
//                   onTextChange: (value) {
//                     selectedAmenity = value;
//                   },
//                   onEndEditing: (value) {
//                     // checkAmenityType(value, 'amenityType', onchange: true);
//                     FocusScope.of(context).unfocus();
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 setState(() => showTodayOnly = !showTodayOnly);
//               },
//               child: CommonCardView(
//                 borderRadius: 6,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   height: 45,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       showTodayOnly ? 'Today\'s Task' : 'All Dates',
//                       style: const TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     activeTabView(){
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           children: [
//             const SizedBox(height: 5),
//             categoryTypeField(),
//             Expanded(
//               child: ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 padding: const EdgeInsets.only(bottom: 15),
//                 shrinkWrap: true,
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = tasks[index];
//                   final unit = "${task['name']}, ${task['flat']}";
//                   final created = task['created']!;
//                   final dueDate = task['date']!;
//                   final status = task['status']!;
//                   final note = task['note'] ?? '';
//
//                   return FollowUpCardView(
//                     unit: unit,
//                     name: task['name']!,
//                     createdDate: created,
//                     dueDate: dueDate,
//                     status: status,
//                     statusTag: status,
//                     note: note,
//                     tagColor: getStatusColor(status),
//                     tagTextColor: getStatusTextColor(status),
//                     onMarkComplete: () {
//                       WorkplaceWidgets.successToast('Follow up completed successfully',durationInSeconds: 1);
//
//                     },
//                     onAddFollowUp: () {
//                       Navigator.push(
//                         context,
//                         SlideLeftRoute(
//                           widget: AddFollowUpScreen(
//                             houses: widget.houses,
//                             isComeFromDetail: true,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     completeTabView(){
//       return  ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 4, bottom: 15),
//         shrinkWrap: true,
//         itemCount: tasks2.length,
//         itemBuilder: (context, index) {
//           final task = tasks2[index];
//           final unit = "${task['name']}, ${task['flat']}";
//           final created = task['created']!;
//           final dueDate = task['date']!;
//           final status = task['status']!;
//           final note = task['note'] ?? '';
//
//           return FollowUpCardView(
//             unit: unit,
//             name: task['name']!,
//             createdDate: created,
//             dueDate: dueDate,
//             status: status,
//             statusTag: status,
//             note: note,
//             tagColor: getStatusColor(status),
//             tagTextColor: getStatusTextColor(status),
//             onMarkComplete: () {
//               WorkplaceWidgets.successToast('Follow up completed successfully',durationInSeconds: 1);
//
//             },
//             onAddFollowUp: () {
//               Navigator.push(
//                 context,
//                 SlideLeftRoute(
//                   widget: AddFollowUpScreen(
//                     houses: widget.houses,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       );
//     }
//
//
//     return ContainerFirst(
//         contextCurrentView: context,
//         isSingleChildScrollViewNeed: false,
//         isFixedDeviceHeight: false,
//         isListScrollingNeed: true,
//         isOverLayStatusBar: false,
//         appBarHeight: 56,
//         appBar: const CommonAppBar(
//           title: 'Follow Up Tasks',
//           isHideBorderLine: true,
//         ),
//         containChild: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.only(top: 10),
//               color: Colors.transparent,
//               child: TabBar(
//                   onTap: (int index) {
//                     setState(() {
//                       tabInitialIndex = index;
//                     });
//                   },
//                   labelColor: AppColors.appBlueColor,
//                   labelPadding: const EdgeInsets.only(bottom: 10),
//                   indicatorColor: AppColors.appBlueColor,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   indicatorWeight: 4,
//                   unselectedLabelColor: AppColors.greyUnselected,
//                   controller: tabController,
//                   tabs: [
//                     Text('Active', style: appStyles.tabTextStyle()),
//                     Text(
//                       'Completed',
//                       style: appStyles.tabTextStyle(),
//                     )
//                   ]),
//             ),
//             Expanded(
//               // Use Flexible instead of Expanded
//               child: TabBarView(
//                 controller: tabController,
//                 children: [
//                      activeTabView(),
//                      completeTabView(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         bottomMenuView: CommonFloatingAddButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               SlideLeftRoute(
//                   widget: AddFollowUpScreen(
//                         houses: widget.houses
//                       )),
//             );
//           },
//         ));
//   }
// }
