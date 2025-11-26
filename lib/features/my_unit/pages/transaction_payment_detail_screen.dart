import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_global_components/unit_statement_card_widget.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../policy/pages/pdf_view_page.dart';
import '../bloc/my_unit_bloc.dart';

class TransactionPaymentDetailScreen extends StatefulWidget {
  final int id;
  final String title;
  final String date;
  final String receiptNumber;
  const TransactionPaymentDetailScreen({super.key, required this.id, required this.title, required this.date, required this.receiptNumber});

  @override
  State<TransactionPaymentDetailScreen> createState() =>
      _TransactionPaymentDetailScreenState();
}

class _TransactionPaymentDetailScreenState extends State<TransactionPaymentDetailScreen> {
  late MyUnitBloc myUnitBloc;
  @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    myUnitBloc.add(FetchInvoiceTransactionDetailEvent(mContext: context, houseId: widget.id,  ));
    super.initState();
  }
  Color _parseColor(String? colorString, {Color defaultColor = Colors.black}) {
    if (colorString == null || colorString.isEmpty) return defaultColor;
    return Color(int.parse(colorString.replaceFirst("0x", ""), radix: 16));
  }
  List<Widget> detailsRow() {
    return myUnitBloc.transactionPaymentDetail.keys.map((key) {
      final value = myUnitBloc.transactionPaymentDetail[key];

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
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedKey,
              style:  appTextStyle.appTitleStyle(),
            ),
            Text(
              displayValue,
              style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w400),

            ),
          ],
        ),
      );
    }).toList();
  }


  submitButton() {
    return  GestureDetector(
      onTap: ()
      {
          myUnitBloc.add(FetchPaymentReceiptEvent(paymentId: widget.id.toString(), mContext: context));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: const Text(
          AppString.downLoadAndShare,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.appBlueColor,
            decoration: TextDecoration.underline,
            decorationColor:  AppColors.appBlueColor,

          ),
        ),
      ),
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
          color: Colors.white,
          padding: const EdgeInsets.only(left: 5.0,bottom: 0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        width: 0.3,
                        color: Colors.grey.shade300,
                      ))),
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
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:  appTextStyle.appTitleStyle(),
                          ),
                          Text(
                            widget.date,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15,),

                ],
              ),
            ),
          ),
        ),
        containChild: BlocListener<MyUnitBloc, MyUnitState>(
          listener: (BuildContext context, state)
          {
            if(state is PaymentReceiptDoneState)
            {
              Navigator.push(
                  context,
                  SlideLeftRoute(
                      widget: PdfViewPage(
                        title: 'Payment Receipt',
                        subTitle: widget.receiptNumber,
                        pdfUrl: myUnitBloc.pdfUrl ?? '',
                      )));
            }
          },
          child:  BlocBuilder<MyUnitBloc, MyUnitState>(
              bloc: myUnitBloc,
              builder: (BuildContext context, state) {
                if (state is MyUnitLoadingState) {
                  return WorkplaceWidgets.progressLoader(context);
                }
                if (state is MyUnitErrorState) {
                  return  Center(
                    child: Column(
                      children: [
                        Text(state.message,style:appTextStyle.noDataTextStyle(),),
                      ],
                    ),
                  );
                }
                return myUnitBloc.transactionPaymentDetail.isEmpty? Center(
                  child: Column(
                    children: [
                      Text(AppString.noDataFound,style:appTextStyle.noDataTextStyle(),)
                    ],
                  ),
                ): Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15,top: 0,bottom: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                submitButton(),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Card(
                                color: Colors.white, // Set card color based on status
                                elevation: 1.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                                  child: Column(
                                    children: detailsRow(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Text(myUnitBloc.paymentsDetailInvoicesData.isNotEmpty?'Invoices':'Payment' ,style: appTextStyle.appTitleStyle(),)
                                ],
                                ),
                              ),
                              if (myUnitBloc.paymentsDetailInvoicesData.isNotEmpty)ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(top: 8),
                                  itemCount: myUnitBloc.paymentsDetailInvoicesData.length,
                                  itemBuilder: (context, index) {
                                    return UnitStatementCardWidget(
                                      title:
                                      myUnitBloc.paymentsDetailInvoicesData[index].title ?? '',
                                      description:
                                      myUnitBloc.paymentsDetailInvoicesData[index].description ??
                                          '',
                                      amount:
                                      myUnitBloc.paymentsDetailInvoicesData[index].amount ?? '',
                                      type: myUnitBloc.paymentsDetailInvoicesData[index].type ?? '',
                                      date: myUnitBloc.paymentsDetailInvoicesData[index].date ?? '',
                                      subTitle:
                                      myUnitBloc.paymentsDetailInvoicesData[index].subTitle ??
                                          '',
                                      table:
                                      myUnitBloc.paymentsDetailInvoicesData[index].table ?? '',
                                      status:
                                      myUnitBloc.paymentsDetailInvoicesData[index].status ?? '',
                                      statusColor: _parseColor(
                                          myUnitBloc.paymentsDetailInvoicesData[index].statusColor ??
                                              ""),
                                      balanceAmount: myUnitBloc
                                          .paymentsDetailInvoicesData[index].balanceAmount ??
                                          "",
                                      paymentMethod: myUnitBloc
                                          .paymentsDetailInvoicesData[index].paymentMethod ??
                                          "",
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if(state is  MyUnitPdfLoadingState)   WorkplaceWidgets.progressLoader(context)
                  ],
                );
              }),
        )



    );
  }
}