// ignore_for_file: prefer_const_constructors

import '../core/util/app_theme/text_style.dart';
import '../features/my_unit/pages/how_to_pay.dart';
import '../imports.dart';

class UnitSummaryCardWidget extends StatelessWidget {
  final bool? isDue;
  final String? totalBalance;
  final String? openingBalance;
  final String? latestInvoiceDue;
  final String? unpaidPaidMessage;
  final String? unpaidInvoicesCountLabel;
  final int? unpaidInvoiceCount;
  final Color? unpaidPaidMessageTextColor;
  final Color? totalBalanceColor;
  final Color? latestInvoiceDueColor;
  final backCallback;
  final onTabForTask;
  final bool isShowPayBt;
  final bool isLoader;
  final bool isShowPayNow;
  final bool isShowCreateTask;
  final bool isShowHowToPay;


  const UnitSummaryCardWidget(
      {super.key,
      this.isDue,
      this.totalBalance,
      this.openingBalance,
      this.latestInvoiceDue,
      this.unpaidPaidMessage,
      this.unpaidInvoiceCount,
      this.unpaidPaidMessageTextColor,
      this.totalBalanceColor,
      this.latestInvoiceDueColor,
      this.unpaidInvoicesCountLabel,
        this.isShowHowToPay = true,
      this.isShowPayBt = true,
      this.isShowPayNow = false,
        this.isShowCreateTask = false,
        this.isLoader = false, // <-- new default value

        this.backCallback,
        this.onTabForTask

      });

  @override
  Widget build(BuildContext context) {


    Widget imageView(String image){
      return Container(
        padding: EdgeInsets.all(3),
        margin: EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white
        ),
        child: SvgPicture.asset(
          image,
          height: 10,
          width: 10,
        ),
      );
    }


    Widget payButton() {
      return isShowPayBt == true
          ? Container(
        margin: const EdgeInsets.symmetric(horizontal: 14)
            .copyWith(top: 10, bottom: 10),
        child: isLoader
            ? Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.textBlueColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: const SizedBox(
              height: 12, // Adjust height as needed
              width: 12,  // Adjust width as needed
              child: CircularProgressIndicator(
                strokeWidth: 2, // Adjust the thickness of the loader
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          ),
        )
            : GestureDetector(
          onTap: () {
            backCallback.call();
          },
          child: Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.textBlueColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 15),
                Text(
                  "Pay Now",
                  style: AppStyle().buttonTextStyle1(),
                ),
                SizedBox(width: 5),
                imageView("assets/images/gpay_logo.svg"),
                imageView("assets/images/phone-pe.svg"),
                imageView("assets/images/paytm.svg"),
                imageView("assets/images/mastercard.svg"),
              ],
            ),
          ),
        ),
      )
          : SizedBox();
    }
    Widget paymentDetails() {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  SlideLeftRoute(
                      widget: HowToPayScreen(
                      )));
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppString.howToPayWithIconText,
                    style: TextStyle(fontSize: 12, color: AppColors.appBlueColor),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: AppColors.appBlueColor)
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget createTaskButton() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14)
            .copyWith(top: 10, bottom: 0),
        child: GestureDetector(
          onTap: () {
            onTabForTask.call();
          },
          child: Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.textBlueColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 15),
                Text(
                  "Create Invoice Task",
                  style: AppStyle().buttonTextStyle1(),
                ),
              ],
            ),
          ),
        ),
      );
    }


    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFDDEEFF), // light blue tint
            Color(0xFFFFE8CC), // Light orange (peachy)
// Subtle and elegant darkening

// warm cream
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      // color: Colors.white, // Set card color based on status
      // elevation: 1.5,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 10),
              child: Column(
                children: [
                  if (openingBalance?.isNotEmpty == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.openingBalance,
                          style: appTextStyle.appSubTitleStyle(
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          openingBalance ?? "",
                          style: appTextStyle.appSubTitleStyle(
                              color: const Color(0xFF252525),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  if (openingBalance?.isNotEmpty == true)
                    const SizedBox(
                      height: 10,
                    ),
                  if (latestInvoiceDue?.isNotEmpty == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.totalDue,
                          style: appTextStyle.appSubTitleStyle(
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          latestInvoiceDue ?? "",
                          style: appTextStyle.appSubTitleStyle(
                              color: latestInvoiceDueColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  if (latestInvoiceDue?.isNotEmpty == true)
                    const SizedBox(
                      height: 10,
                    ),
                ],
              ),
            ),
            if (openingBalance!.isNotEmpty)
              Divider(
                color: Colors.grey.withOpacity(0.6),
                thickness: 0,
              ),
            if (totalBalance?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppString.netBalance,
                      style: appTextStyle.appLargeTitleStyle(),
                    ),
                    Column(
                      children: [
                        Text(
                          totalBalance ?? "",
                          style: appTextStyle.appLargeTitleStyle(
                              color:
                                  totalBalanceColor //isDue == true ? AppColors.red : AppColors.grey,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (unpaidInvoiceCount! > 0)
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 5, top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      unpaidInvoicesCountLabel ?? '',
                      style: appTextStyle.appSubTitleStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade700),
                    ),
                    Text(
                      '$unpaidInvoiceCount' ?? "",
                      style: appTextStyle.appSubTitleStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            if (unpaidPaidMessage?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 5, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        '$unpaidPaidMessage' ?? "",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: appTextStyle.appSubTitleStyle(
                            fontWeight: FontWeight.normal,
                            color: unpaidPaidMessageTextColor),
                      ),
                    ),
                  ],
                ),
              ),
            if (unpaidPaidMessage?.isNotEmpty == true && isShowPayNow ) payButton(),

            if (isShowHowToPay)
            paymentDetails(),

            if (isShowCreateTask)createTaskButton(
            )
          ],
        ),
      ),
    );
  }
}
