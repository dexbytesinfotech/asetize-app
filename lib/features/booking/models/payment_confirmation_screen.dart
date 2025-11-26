import 'package:dotted_border/dotted_border.dart';

import '../../../imports.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  State<PaymentConfirmationScreen> createState() => _BookingRequestState();
}

class _BookingRequestState extends State<PaymentConfirmationScreen> {
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());


  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isListScrollingNeed: false,
        isFixedDeviceHeight: false,
        appBarHeight: 56,
        appBar: const CommonAppBar(
          title: 'Payment & Confirmation',
          isHideIcon: false,
        ),
        containChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DottedBorder(
                  options: RectDottedBorderOptions(
                    color: AppColors.textBlueColor,
                    strokeWidth: 2,
                    dashPattern: [6, 4],
                  ),
                  child: Container(
                    color: AppColors.textBlueColor.withOpacity(0.2),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Summary',
                          textAlign: TextAlign.center,
                          style: appStyles.photoBottomSheetTitleStyle(),
                        ),
                        Text(
                          'Event: Birthday Party',
                          textAlign: TextAlign.center,
                          style: appStyles.containerLeftTextStyle(),
                        ), Text(
                          'Date: May 14, 2025',
                          textAlign: TextAlign.center,
                          style: appStyles.containerLeftTextStyle(),
                        ), Text(
                          'Time: 4:00 PM - 11:00 PM ',
                          textAlign: TextAlign.center,
                          style: appStyles.containerLeftTextStyle(),
                        ), Text(
                          'Guests: 50',
                          textAlign: TextAlign.center,
                          style: appStyles.containerLeftTextStyle(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
             SizedBox(height: 10,),
              Text(
                'Payment Deatils',
                textAlign: TextAlign.center,
                style: appStyles.photoBottomSheetTitleStyle(),
              ),
              Text(
                'Booking Fee: 1000',
                textAlign: TextAlign.center,
                style: appStyles.containerLeftTextStyle(),
              ), Text(
                'Cleaning Fee: 500',
                textAlign: TextAlign.center,
                style: appStyles.containerLeftTextStyle(),
              ), Text(
                'Secuirty Deposit: 2000',
                textAlign: TextAlign.center,
                style: appStyles.containerLeftTextStyle(),
              ),
              Text(
                'Total : 3500',
                textAlign: TextAlign.center,
                style: appStyles.photoBottomSheetTitleStyle(),
              ),
             SizedBox(height: 20,),
              Text(
                'Payment instructions: ',
                textAlign: TextAlign.center,
                style: appStyles.containerLeftTextStyle(),
              ),
              Text(
                'Pay via UPI to scociety@upi',
                textAlign: TextAlign.center,
                style: appStyles.containerLeftTextStyle(fontSize: 16),
              ),
             SizedBox(height: 20,),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DottedBorder(
                  options: RectDottedBorderOptions(
                    color: AppColors.grey,
                    strokeWidth: 2,
                    dashPattern: [6, 4],
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey),
                        // const SizedBox(height: 8),
                        Text(
                          'Tap to upload Payment Screenshot \n JPG, PNG, JPEG',
                          textAlign: TextAlign.center,
                          style: appStyles.hintTextStyle(texColor: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )


    );
  }
}
