import 'package:flutter/material.dart';

import '../../../core/util/app_theme/text_style.dart';

class HowToPayCardView extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, String>> paymentDetails;
  final String importantNote;

  const HowToPayCardView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.paymentDetails,
    required this.importantNote,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: appTextStyle.appTitleStyle2(),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: appTextStyle.appSubTitleStyle2(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ...paymentDetails.map((detail) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _getIconForPaymentType(detail['type']),
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail['title'] ?? '',
                            style: appTextStyle.appSubTitleStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          ...detail.entries.where((e) => e.key != 'type' && e.key != 'title').map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 5.0, top: 2.0),
                              child: Text(
                                '${entry.key.replaceFirstMapped(RegExp(r'^[A-Z]'), (match) => '${match[0]!.toLowerCase()}')}: ${entry.value}',
                                style: appTextStyle.appSubTitleStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.yellow[50],
              child: Text(
                importantNote,
                style: appTextStyle.appSubTitleStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPaymentType(String? type) {
    switch (type?.toLowerCase()) {
      case 'bank':
        return Icons.account_balance;
      case 'upi':
        return Icons.payment;
      case 'cheque':
        return Icons.receipt;
      default:
        return Icons.info;
    }
  }
}

// Example usage
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: HowToPayCardView(
//           title: 'Payment Instructions',
//           subtitle: 'Choose any of the following payment methods to clear your dues. Your payment will be reflected within 24 hours.',
//           paymentDetails: [
//             {
//               'type': 'bank',
//               'title': 'Bank Account Transfer',
//               'Account Number': '123456789012',
//               'IFSC Code': 'SBIN0001234',
//               'Account Name': 'Society Welfare Association',
//               'Branch Name': 'Main Branch, City Center',
//             },
//             {
//               'type': 'upi',
//               'title': 'UPI Payment',
//               'UPI ID': 'society@okaxis',
//               'Instruction': 'Use GPay, PhonePe, Paytm or any UPI app to transfer funds',
//             },
//             {
//               'type': 'cheque',
//               'title': 'Payment by Cheque',
//               'Instruction': 'Cheque in favor of Society Welfare Association. Submit cheque at society office during working hours (10 AM - 5 PM)',
//             },
//           ],
//           importantNote: 'Keep your receipt number for reference\nContact office for payment confirmation\nLate payment charges may apply after due date',
//         ),
//       ),
//     ),
//   ));
// }