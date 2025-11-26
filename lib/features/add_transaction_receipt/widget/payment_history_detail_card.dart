import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asetize/widgets/common_card_view.dart';
import 'package:asetize/widgets/common_detail_view_row.dart';

import '../../../core/util/app_theme/text_style.dart';

class PaymentHistoryDetailCard extends StatelessWidget {
  final String receiptNumber;
  final String paymentDate;
  final String amount;
  final String transactionReference;

  const PaymentHistoryDetailCard({
    Key? key,
    required this.receiptNumber,
    required this.paymentDate,
    required this.amount,
    required this.transactionReference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardView(
        margin:
        const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),

      child: Padding(
        padding: const EdgeInsets.all(14).copyWith(bottom: 0,left: 16,right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonDetailViewRow(title: 'Receipt Number', value:receiptNumber,icons: CupertinoIcons.doc_text),
            CommonDetailViewRow(title: 'Amount', value:amount,icons: Icons.currency_rupee),
            CommonDetailViewRow(title: 'Transaction Reference', value:transactionReference,icons: Icons.payment),
          ],
        ),
      ),
    );
  }
}
