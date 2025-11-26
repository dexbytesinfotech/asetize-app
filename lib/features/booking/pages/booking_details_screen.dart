import 'package:asetize/core/util/app_theme/text_style.dart';
import 'package:asetize/widgets/common_card_view.dart';

import '../../../imports.dart';
import '../../../widgets/common_detail_view_row.dart';
import '../../../widgets/download_button_widget.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  String status = 'confirmed';

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.withOpacity(0.3);
      case 'pending':
        return Colors.orange.withOpacity(0.3);
      case 'cancelled':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green[800]!; // Darker green
      case 'pending':
        return Colors.orange[800]!; // Darker orange
      case 'cancelled':
        return Colors.red[800]!; // Darker red
      default:
        return Colors.black87;
    }
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: appTextStyle.appSubTitleStyle3()),
          Text(value, style: appTextStyle.appTitleStyle()),
        ],
      ),
    );
  }

    Widget titleText(String title) {
    return Text(
      title,
      style: appTextStyle.appTitleStyle2(
          fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: false,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: 'Booking Details',
      ),
      containChild: Padding(
        padding: const EdgeInsets.all(20).copyWith(top: 0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CommonCardView(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title and Status Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Swimming Pool',
                                style: appTextStyle.appTitleStyle2(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Recreation',
                                style: appTextStyle.appSubTitleStyle3(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: getStatusColor(status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: appTextStyle.appSubTitleStyle3(
                              fontSize: 12,
                              color: getStatusTextColor(status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 15),

                    /// Booking Reference
                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Reference',
                            style: appTextStyle.appSubTitleStyle3(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'BK001',
                            style: appTextStyle.appTitleStyle2(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /// Combined Card for all sections
            CommonCardView(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Booking Information
                    titleText('Booking Information'),
                    const SizedBox(height: 8),
                    CommonDetailViewRow(
                      title: 'Date',
                      value: 'Wednesday, October 15, 2025',
                      icons: Icons.calendar_month,
                    ),
                    CommonDetailViewRow(
                      title: 'Time Slot',
                      value: '10:00 AM - 12:00 PM',
                      icons: Icons.access_time,
                    ),
                    CommonDetailViewRow(
                      title: 'Number of Guests',
                      value: '4 guests',
                      icons: Icons.people,
                    ),
                    CommonDetailViewRow(
                      title: 'Location',
                      value: 'Ground Floor, Main Building',
                      icons: Icons.location_on_outlined,
                    ),

                    const Divider(height: 30, thickness: 0.5),

                    /// Contact Details
                    titleText('Contact Details'),
                    const SizedBox(height: 8),
                    CommonDetailViewRow(
                      title: 'Phone Number',
                      value: '+91 98765 43210',
                      icons: Icons.call,
                    ),

                    const Divider(height: 30, thickness: 0.5),

                    /// Purpose
                    titleText('Purpose'),
                    const SizedBox(height: 8),
                    CommonDetailViewRow(
                      title: 'Purpose of booking',
                      value: 'Family gathering and celebration',
                      icons: Icons.article_outlined,
                    ),

                    const Divider(height: 30, thickness: 0.5),

                    /// Payment Details
                    titleText('Payment Details'),
                    const SizedBox(height: 8),
                    CommonDetailViewRow(
                      title: 'Booking Amount',
                      value: '₹500',
                      icons: Icons.currency_rupee_rounded,
                    ),
                    CommonDetailViewRow(
                      title: 'Booked on',
                      value: 'Oct 1, 2025',
                      icons: Icons.calendar_today_outlined,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// Download Receipt Button
            DownloadButtonWidget(
              borderRadius: 5,
              horizontalRadius: 0,
              buttonName: 'Download Receipt',
              onTapCallBack: () {},
            ),

            const SizedBox(height: 10),

            /// Cancel Booking Button
            AppButton(
              buttonHeight: 40,
              buttonName: 'Cancel Booking',
              buttonBorderColor: Colors.red,
              buttonColor: Colors.transparent,
              textStyle: appStyles.buttonTextStyle1(texColor: AppColors.red),
              flutterIcon: Icons.close,
              iconColor: AppColors.red,
              isShowIcon: true,
              isLoader: false,
              backCallback: () {
                WorkplaceWidgets.showDeleteConfirmation(
                  context: context,
                  title: 'Cancel Booking',
                  content: AppString.cancelBookingContent,
                  onConfirm: () {
                    // followUpBloc.add(OnDeleteTaskEvent(taskId: widget.taskListData?.id ?? 0));
                  },
                  buttonName1: AppString.no,
                  buttonName2: AppString.yes,
                );
              },
            ),
          ],
        ),

      ),
    );
  }
}
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../../widgets/common_card_view.dart';
// import '../../../core/util/app_theme/text_style.dart';
//
// class BookingDetailView extends StatelessWidget {
//   const BookingDetailView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Booking Information
//           CommonCardView(
//             margin:
//             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   titleText('Booking Information'),
//                   const SizedBox(height: 8),
//                   CommonDetailViewRow(
//                     title: 'Date',
//                     value: 'Wednesday, October 15, 2025',
//                     icons: Icons.calendar_month,
//                   ),
//                   CommonDetailViewRow(
//                     title: 'Time Slot',
//                     value: '10:00 AM - 12:00 PM',
//                     icons: Icons.access_time,
//                   ),
//                   CommonDetailViewRow(
//                     title: 'Number of Guests',
//                     value: '4 guests',
//                     icons: CupertinoIcons.person_2_fill,
//                   ),
//                   CommonDetailViewRow(
//                     title: 'Location',
//                     value: 'Ground Floor, Main Building',
//                     icons: Icons.location_on_outlined,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           /// Contact Details
//           CommonCardView(
//             margin:
//             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   titleText('Contact Details'),
//                   const SizedBox(height: 8),
//                   CommonDetailViewRow(
//                     title: 'Phone Number',
//                     value: '+91 98765 43210',
//                     icons: Icons.call,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           /// Purpose
//           CommonCardView(
//             margin:
//             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   titleText('Purpose'),
//                   const SizedBox(height: 8),
//                   CommonDetailViewRow(
//                     title: '',
//                     value: 'Family gathering and celebration',
//                     icons: Icons.article_outlined,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           /// Payment Details
//           CommonCardView(
//             margin:
//             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   titleText('Payment Details'),
//                   const SizedBox(height: 8),
//                   CommonDetailViewRow(
//                     title: 'Booking Amount',
//                     value: '₹500',
//                     icons: Icons.currency_rupee_rounded,
//                   ),
//                   CommonDetailViewRow(
//                     title: 'Booked on',
//                     value: 'Oct 1, 2025',
//                     icons: Icons.calendar_today_outlined,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Title widget style
//   Widget titleText(String title) {
//     return Text(
//       title,
//       style: appTextStyle.appSubTitleStyle2(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//       ),
//     );
//   }
// }
