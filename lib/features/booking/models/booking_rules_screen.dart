
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:asetize/features/booking/models/payment_confirmation_screen.dart';

import '../../../imports.dart';

class BookingRules extends StatefulWidget {
  const BookingRules({super.key});

  @override
  State<BookingRules> createState() => _BookingRequestState();
}

class _BookingRequestState extends State<BookingRules> {
  bool _isAgreed = false;

  final String justifyContent = """
  <h2>Community Hall Rules</h2>
  <ul>
    <li>No loud music after 10 PM</li>
    <li>Alcohol is strictly prohibited</li>
    <li>Limited parking for outside vehicles</li>
    <li>No adhesive decorations on walls</li>
    <li>Security deposit refundable after inspection</li>
    <li>Max capacity: 100 persons</li>
    <li>All external vendors to be pre-approved & agree to all rules</li>
  </ul>
  """;

  Widget button() {
    return AppButton(
      buttonName: 'Submit Request',
      buttonColor: _isAgreed ? AppColors.textBlueColor : Colors.grey,
      textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
      backCallback: _isAgreed
          ? () {
        Navigator.push(
          MainAppBloc.getDashboardContext,
          SlideLeftRoute(
            widget:  const PaymentConfirmationScreen(),
          ),
        );
      }
          : null, // Disable tap if not agreed
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isListScrollingNeed: false,
      isFixedDeviceHeight: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: 'Amenity Rules',
        isHideIcon: false,
      ),
      containChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HtmlWidget(
              justifyContent,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _isAgreed,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed = value!;
                    });
                  },
                  activeColor: AppColors.textBlueColor,
                ),
                const Expanded(
                  child: Text(
                    'I agree to all rules',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            button()
          ],
        ),
      ),
    );
  }
}
