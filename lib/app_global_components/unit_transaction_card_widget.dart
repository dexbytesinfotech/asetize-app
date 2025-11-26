import 'package:asetize/widgets/common_card_view.dart';

import '../core/util/app_theme/text_style.dart';
import '../imports.dart';

class UnitTransactionCardWidget extends StatelessWidget {
  final String? title;
  final String? paymentDate;
  final String? amount;
  final String? receiptNumber;
  final String? paymentMethod;
  final String? invoiceNumber;
  final String? durations;
  final String? transactionReference;
  final String? receiptUrl;
  final void Function()? onTap;

  const UnitTransactionCardWidget({super.key,
    this.title,
    this.onTap,
    this.paymentDate,
    this.amount,
    this.receiptNumber,
    this.paymentMethod,
    this.invoiceNumber,
    this.durations,
    this.transactionReference,
    this.receiptUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: onTap,
      child: CommonCardView(
        cardColor: Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        paymentDate ?? "",
                        style: appTextStyle.appTitleStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 2,),
                      if(paymentMethod?.isNotEmpty == true )Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                        decoration: BoxDecoration(
                            color:  Colors.grey ,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(paymentMethod ?? '',style: const TextStyle(color:
                        Colors.white ,
                            fontSize: 11,fontWeight: FontWeight.normal),),
                      )
                    ],
                  ),
                  Text(
                    amount ?? "",
                    style: appTextStyle.appTitleStyle(color: Colors.green),
                  ),
                ],
              ),
              //const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    receiptNumber ?? "",
                    style: appTextStyle.appSubTitleStyle2(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Flexible(
              //       child: Text(
              //         invoiceNumber ?? "",
              //         maxLines: 3,
              //         overflow: TextOverflow.ellipsis,
              //         style: appTextStyle.appSubTitleStyle(
              //           fontWeight: FontWeight.w400,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

