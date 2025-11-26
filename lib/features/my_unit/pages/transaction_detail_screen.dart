import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../../app_global_components/unit_statement_card_widget.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/commonTitleRowWithIcon.dart';
import '../../../widgets/common_card_view.dart';
import '../../../widgets/download_button_widget.dart';
import '../../policy/pages/pdf_view_page.dart';
import '../bloc/my_unit_bloc.dart';


enum ComeFromForDetails { unitStatement, unitPayment, managerUnitPayment,managerUnitStatement }

class TransactionDetailScreen extends StatefulWidget {
  final int id;
  final String? tableName;
  final String title;
  final String date;
  final String receiptNumber;
  final ComeFromForDetails comeFrom;
  const TransactionDetailScreen(
      {super.key,
      required this.id,
      required this.comeFrom,
       this.tableName,
      required this.title,
      required this.date,
      required this.receiptNumber});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late MyUnitBloc myUnitBloc;
  String unitTitle = '';

  @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    myUnitBloc.add(FetchInvoiceHistoryDetailEvent(
      mContext: context,
      id: widget.id,
      houseId: widget.id.toString(),
      comeFrom: widget.comeFrom,
      tableName: widget.tableName,
    ));
    super.initState();
  }

  Color _parseColor(String? colorString, {Color defaultColor = Colors.black}) {
    if (colorString == null || colorString.isEmpty) return defaultColor;
    return Color(int.parse(colorString.replaceFirst("0x", ""), radix: 16));
  }

  IconData _getIcon(String key) {
    switch (key.toLowerCase()) {
      case 'duration':
        return Icons.access_time; // Waiting action
      case 'payment date':
        return Icons.date_range_sharp; // Waiting action
      case 'amount':
        return Icons.currency_rupee_outlined; // Waiting action
      case 'receipt number':
        return Icons.receipt_long; // Waiting action
      case 'payment method':
        return Icons.money; // Waiting action
      case 'durations':
        return Icons.access_time; // Waiting action
      default:
        return Icons.receipt_long_sharp; // Waiting action
    }

  }


  List<Widget> detailsRow2() {
    return myUnitBloc.transactionDetail.keys.map((key) {
      final value = myUnitBloc.transactionDetail[key];

      if (key == "house_name") {
        unitTitle = "$value";
        return const SizedBox();
      }
      // Format the key to make it user-friendly
      String formattedKey =
      '${key[0].toUpperCase()}${key.substring(1)}'.replaceAll('_', ' ');

      // Convert value to string if it's not null or empty
      String displayValue = '';
      if (value != null) {
        displayValue = value is String
            ? value
            : value.toString(); // Convert non-string values to strings
      }

      // Handle specific logic for file key
      if (key == 'payments' || key == 'invoices') {
        return const SizedBox(); // Skip rendering for empty files
      }

      // Skip rendering if the value is empty
      if (displayValue.isEmpty) {
        return const SizedBox();
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 18, right: 15, top: 10, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                _getIcon(formattedKey),
                color: Colors.grey.shade600,
                size: 18,
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(projectUtil.capitalizeFullName(formattedKey), style: appTextStyle.appSubTitleStyle2(color: Colors.grey.shade600)),
                  SizedBox(height: 3),
                  Text(
                    displayValue,
                    maxLines: 2,
                    style: appTextStyle.appTitleStyle2(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  downloadButton() {
    return DownloadButtonWidget(
      onTapCallBack: (){
        myUnitBloc.add(FetchPaymentReceiptEvent(
            paymentId: widget.id.toString(), mContext: context));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isFixedDeviceHeight: true,
        isListScrollingNeed: false,
        isOverLayStatusBar: false,
        appBarHeight: 56,
        appBar: Container(
          color:  Color(0xFFF5F5F5),
          padding: const EdgeInsets.only(left: 5.0, bottom: 0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    splashRadius: 23,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  BlocBuilder<MyUnitBloc, MyUnitState>(
                      bloc: myUnitBloc,
                      builder: (BuildContext context, state) {
                        return Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  unitTitle.isNotEmpty
                                      ? unitTitle
                                      : widget.title,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: appTextStyle.appBarTitleStyle(),
                                ),
                                // Text(
                                //   widget.date,
                                //   textAlign: TextAlign.start,
                                //   overflow: TextOverflow.ellipsis,
                                //   style: appTextStyle.appSubTitleStyle(
                                //       fontWeight: FontWeight.w400),
                                // ),
                              ],
                            ),
                          ),
                        );
                      }),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        containChild: BlocListener<MyUnitBloc, MyUnitState>(
          listener: (BuildContext context, state) {
            if (state is PaymentReceiptDoneState) {
              Navigator.push(
                  context,
                  SlideLeftRoute(
                      widget:  PdfViewPage(
                            title:  unitTitle.isNotEmpty
                                ? unitTitle
                                : widget.title,
                            subTitle: widget.receiptNumber,
                            pdfUrl: myUnitBloc.pdfUrl ?? '',
                          )));
            }
          },
          child: BlocBuilder<MyUnitBloc, MyUnitState>(
              bloc: myUnitBloc,
              builder: (BuildContext context, state) {
                if (state is MyUnitLoadingState) {
                  return WorkplaceWidgets.progressLoader(context);
                }
                if (state is MyUnitErrorState) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          state.message,
                          style: appTextStyle.noDataTextStyle(),
                        )
                      ],
                    ),
                  );
                }
                return myUnitBloc.transactionDetail.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            Text(
                              AppString.noDataFound,
                              style: appTextStyle.noDataTextStyle(),
                            )
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 20),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    CommonCardView(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Column(
                                          children:[
                                            Column(
                                              children: detailsRow2(),
                                            ),
                                            downloadButton()
                                          ]
                                        ),
                                      ),
                                    ),
                                    if(myUnitBloc.statementPayment.isNotEmpty || myUnitBloc.statementInvoices.isNotEmpty) Column(children: [

                                      SizedBox(height: 15,),

                                      myUnitBloc.statementInvoices.isNotEmpty
                                          ? CommonTitleRowWithIcon(title: myUnitBloc.statementPayment.isNotEmpty?'Payment' : "Invoices",icon: CupertinoIcons.doc_text_fill,)
                                          : SizedBox(),
                                      SizedBox(height: 5),
                                       if (myUnitBloc.statementPayment.isNotEmpty)ListView.builder(
                                           shrinkWrap: true,
                                           physics: const NeverScrollableScrollPhysics(),
                                           padding: const EdgeInsets.only(top: 8),
                                           itemCount: myUnitBloc.statementPayment.length,
                                           itemBuilder: (context, index) {
                                             return UnitStatementCardWidget(
                                               title:
                                               myUnitBloc.statementPayment[index].title ?? '',
                                               description:
                                               myUnitBloc.statementPayment[index].description ??
                                                   '',
                                               amount:
                                               myUnitBloc.statementPayment[index].amount ?? '',
                                               type: myUnitBloc.statementPayment[index].type ?? '',
                                               date: myUnitBloc.statementPayment[index].date ?? '',
                                               subTitle:
                                               myUnitBloc.statementPayment[index].subTitle ??
                                                   '',
                                               table:
                                               myUnitBloc.statementPayment[index].table ?? '',
                                               status:
                                               myUnitBloc.statementPayment[index].status ?? '',
                                               statusColor: _parseColor(
                                                   myUnitBloc.statementPayment[index].statusColor ??
                                                       ""),
                                               balanceAmount: myUnitBloc
                                                   .statementPayment[index].balanceAmount ??
                                                   "",
                                               paymentMethod: myUnitBloc
                                                   .statementPayment[index].paymentMethod ??
                                                   "",
                                             );
                                           }),
                                       if (myUnitBloc.statementInvoices.isNotEmpty)ListView.builder(
                                           shrinkWrap: true,
                                           physics: const NeverScrollableScrollPhysics(),
                                           padding: const EdgeInsets.only(top: 8),
                                           itemCount: myUnitBloc.statementInvoices.length,
                                           itemBuilder: (context, index) {
                                             return UnitStatementCardWidget(
                                               title:
                                               myUnitBloc.statementInvoices[index].title ?? '',
                                               description:
                                               myUnitBloc.statementInvoices[index].description ??
                                                   '',
                                               amount:
                                               myUnitBloc.statementInvoices[index].amount ?? '',
                                               type: myUnitBloc.statementInvoices[index].type ?? '',
                                               date: myUnitBloc.statementInvoices[index].date ?? '',
                                               subTitle:
                                               myUnitBloc.statementInvoices[index].subTitle ??
                                                   '',
                                               table:
                                               myUnitBloc.statementInvoices[index].table ?? '',
                                               status:
                                               myUnitBloc.statementInvoices[index].status ?? '',
                                               statusColor: _parseColor(
                                                   myUnitBloc.statementInvoices[index].statusColor ??
                                                       ""),
                                               balanceAmount: myUnitBloc
                                                   .statementInvoices[index].balanceAmount ??
                                                   "",
                                               paymentMethod: myUnitBloc
                                                   .statementInvoices[index].paymentMethod ??
                                                   "",
                                             );
                                           })
                                     ],)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (state is MyUnitPdfLoadingState)
                            WorkplaceWidgets.progressLoader(context)
                        ],
                      );
              }),
        ));
  }
}
