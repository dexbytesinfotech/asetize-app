import 'package:go_router/go_router.dart';

import '../../../core/util/app_navigator/app_navigator.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/download_button_widget.dart';
import '../../presentation/pages/dashboard_screen.dart';
import 'my_booking_screen.dart';

class BookingConfirmedScreen extends StatefulWidget {
  const BookingConfirmedScreen({super.key});

  @override
  State<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends State<BookingConfirmedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRow(String label, String value, {bool isLink = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10).copyWith(top: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: appTextStyle.appTitleStyle(
                  fontWeight: FontWeight.w400, fontSize: 14)),
          Text(
            value,
            style: appTextStyle.appTitleStyle(fontSize: 14),
          ),
        ],
      ),
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
        title: 'Booking Confirmed',
      ),
      containChild: Column(
        children: [
          Container(
            color: Colors.transparent,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: _animation,
                  child: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    radius: 40,
                    child:
                        const Icon(Icons.check, size: 45, color: Colors.green),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Thank you for your booking!',
                  style: appTextStyle.appTitleStyle2(fontSize: 20),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pool,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Swimming Pool',
                        style: appTextStyle.appTitleStyle(),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildRow('Date & Time', 'May 7, 2025 • 6:00 PM'),
                  _buildRow('Members', '2 People'),
                  _buildRow('Duration', '1.5 Hours'),
                  _buildRow('Amount Paid', '₹1500.00'),
                  _buildRow('Transaction ID', 'TXN25050708', isLink: true),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          DownloadButtonWidget(
            borderRadius: 5,
            buttonName: 'Download Receipt',
            onTapCallBack: () {},
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    buttonName: 'My Booking',
                    buttonColor: AppColors.appBlueColor,
                    backCallback: () {
                      // Navigate to My Booking screen
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                          widget: const MyBookingScreen(isComeFromSuccess: true,),
                        ),
                      );
                    },
                  ),
                ),
                // const SizedBox(width: 16), // Spacing between buttons
                // Expanded(
                //   child: AppButton(
                //     textStyle: const TextStyle(color: Colors.black,fontSize: 16),
                //     buttonName: 'Book Another',//Exit
                //     buttonColor: Colors.white,
                //     buttonBorderColor: Colors.grey,
                //     backCallback: () {
                //       //context.go('/dashBoard');
                //       // Navigator.pushAndRemoveUntil(
                //       //      context,
                //       //   MaterialPageRoute(
                //       //     builder: (context) => const DashBoardPage(),
                //       //   ),
                //       //       (Route<dynamic> route) => false, // This removes all previous routes
                //       // );
                //       // appNavigator.launchDashBoardScreen(context);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
