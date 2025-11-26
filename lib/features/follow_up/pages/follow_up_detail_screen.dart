// import 'package:asetize/widgets/common_card_view.dart';
//
// import '../../core/util/app_theme/text_style.dart';
// import '../../imports.dart';
// import '../../widgets/common_detail_view_row.dart';
// import 'add_follow_up_screen.dart';
//
// class FollowUpDetailScreen extends StatefulWidget {
//   const FollowUpDetailScreen({super.key});
//
//   @override
//   State<FollowUpDetailScreen> createState() => _FollowUpDetailScreenState();
// }
//
// class _FollowUpDetailScreenState extends State<FollowUpDetailScreen> {
//
//
//
// // Function to create buttons
//   Widget buildButton({
//     required IconData icon,
//     required String text,
//     required Color color,
//     required Color iconColor,
//     required Color borderColor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//         decoration: BoxDecoration(
//           color: color,
//           border: Border.all(width: 1, color: borderColor),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Row(
//           mainAxisSize:
//           MainAxisSize.min, // Ensures buttons don't expand unnecessarily
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Icon(icon, color: iconColor, size: 18),
//             const SizedBox(width: 4),
//             Text(
//               text,
//               style: TextStyle(
//                   color: iconColor,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
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
//   Widget invoiceDateView({
//     IconData icon = Icons.calendar_today_outlined,
//     String title = '',
//     String value = '',
//     Color iconColor = const Color(0xFF757575),
//     Color valueColor = Colors.black
//   }){
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 2),
//           child: Icon(icon, size: 18, color: iconColor),
//         ),
//         const SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: appTextStyle.appSubTitleStyle2(fontSize: 13),
//             ),
//             const SizedBox(height: 1),
//              Text(
//               value,
//               style:  appTextStyle.appTitleStyle(fontSize: 14,color: valueColor),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//
//   Widget maintenanceCardView(){
//     return CommonCardView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Due Monthly Maintenance Invoice',
//               style: appTextStyle.appTitleStyle2(),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.receipt_long, size: 20, color: AppColors.textBlueColor),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: Text(
//                     'Your April month maintenance invoice of Rs 1050 is outstanding.',
//                     style: appTextStyle.appTitleStyle(fontSize: 14,fontWeight: FontWeight.w400),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   /// Invoice Date
//                   invoiceDateView(
//                     icon: Icons.calendar_month,
//                     title: 'Invoice Date',
//                     value: "May 25, 2025"
//                   ),
//
//                   /// Due Date
//                   invoiceDateView(
//                     icon: Icons.error,
//                     title: 'Due Date',
//                     value: "May 30, 2025",
//                     iconColor: Colors.red,
//                     valueColor: Colors.red,
//                   ),
//
//
//
//
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget ownerCardView({
//     required String unit,
//     required String owner,
//     required List<String> status,
//   }){
//     return CommonCardView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start, // align items from top
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(owner, style: appTextStyle.appTitleStyle2()),
//                   Text(unit,
//                       style: appTextStyle.appSubTitleStyle2()),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     height: 26,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: status.length,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           alignment: Alignment.center,
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           margin: const EdgeInsets.only(right: 10),
//                           decoration: BoxDecoration(
//                             color: getStatusColor(status[index]).safeOpacity(0.8),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(status[index],
//                               style: appTextStyle.appTitleStyle(
//                                   color: Colors.black,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500)
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             buildButton(
//               icon: Icons.phone,
//               text: 'Call',
//               color: AppColors.textBlueColor,
//               iconColor: Colors.white,
//               borderColor: Colors.blue,
//               onTap: ()  {
//
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget followUpHistoryCardView({
//     required List<Map<String, String>> followUpHistory,
//     required String totalFollowUps,
//     required String nextFollowUp,
//     required String createdDate,
//     required String createdBy,
//   }){
//     return CommonCardView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Follow-up History', style: appTextStyle.appTitleStyle2()),
//             const SizedBox(height: 8),
//             CommonDetailViewRow(
//                 title: "Next Follow-up",
//                 value:nextFollowUp,
//                 icons: Icons.calendar_month
//             ),
//             const CommonDetailViewRow(
//                 title: "Remark",
//                 value:'No remarks added',
//                 icons: Icons.chat
//             ),
//             Divider(height: 0,color: Colors.grey.shade200,thickness: 0.8,),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(children: [
//                   Icon(Icons.access_time_sharp, size: 16, color: Colors.grey.shade600),
//                   const SizedBox(width: 6),
//                   Text('Created: $createdDate', style: appTextStyle.appSubTitleStyle2(fontSize: 12)),
//                 ]),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: const Row(
//                     children: [
//                       Icon(Icons.info_outline,color: Colors.black,size: 16,),
//                       SizedBox(width: 6,),
//                       Text('Details Pending',
//                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return ContainerFirst(
//         contextCurrentView: context,
//         isSingleChildScrollViewNeed: true,
//         isFixedDeviceHeight: false,
//         isListScrollingNeed: false,
//         isOverLayStatusBar: false,
//         appBarHeight: 56,
//         appBar:  const CommonAppBar(
//           title: 'Follow Up Detail',
//         ),
//         containChild: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             children: [
//
//               maintenanceCardView(),
//               ownerCardView( unit: 'House #A-123',owner: 'Michael Johnson', status: ["Didn't Pick","Follow-up #1"],),
//               followUpHistoryCardView(
//                 followUpHistory: [
//                   {
//                     'title': 'Last Follow-up',
//                     'date': '10 May 2025',
//                     'note': 'Phone call made - No response',
//                   },
//                   {
//                     'title': 'Previous',
//                     'date': '25 Apr 2025',
//                     'note': 'Email reminder sent',
//                   },
//                   {
//                     'title': 'First Contact',
//                     'date': '15 Apr 2025',
//                     'note': 'Notice delivered',
//                   },
//                 ],
//                 totalFollowUps: '3',
//                 nextFollowUp: '25 May 2025',
//                 createdDate: '15 Mar 2025',
//                 createdBy: 'John Smith',
//               ),
//
//               const SizedBox(height: 15,),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: AppButton(
//                       textStyle: const TextStyle(color: Colors.black,fontSize: 16),
//                       buttonName: 'Mark Complete',
//                       buttonColor: Colors.white,
//                       buttonBorderColor: Colors.grey,
//                       backCallback: () {},
//                     ),
//                   ),
//                   const SizedBox(width: 16), // Spacing between buttons
//                   Expanded(
//                     child: AppButton(
//                       textStyle: const TextStyle(color: Colors.white,fontSize: 16),
//                       buttonName: 'Add Follow-up',
//                       buttonColor:AppColors.textBlueColor,
//                       backCallback: () {
//                         Navigator.push(
//                           context,
//                           SlideLeftRoute(
//                             widget: const AddFollowUpScreen(
//                              isComeFromDetail: true,
//                               houses: [],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         )
//     );
//   }
// }
