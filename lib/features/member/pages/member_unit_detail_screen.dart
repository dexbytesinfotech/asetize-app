import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_global_components/unit_statement_card_widget.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../my_unit/bloc/my_unit_bloc.dart';
import '../../policy/pages/pdf_view_page.dart';

class MemberUnitDetailScreen extends StatefulWidget {
  final int id;
  final String tableName;
  final String title;
  final String date;
  const MemberUnitDetailScreen({super.key, required this.id, required this.tableName, required this.title, required this.date});

  @override
  State<MemberUnitDetailScreen> createState() =>
      _MemberUnitDetailScreenState();
}

class _MemberUnitDetailScreenState extends State<MemberUnitDetailScreen> {
  late MyUnitBloc myUnitBloc;
  @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    myUnitBloc.add(FetchManagerInvoiceHistoryDetailEvent(mContext: context, id: widget.id, tableName: widget.tableName, ));
    super.initState();
  }
  Color _parseColor(String? colorString, {Color defaultColor = Colors.black}) {
    if (colorString == null || colorString.isEmpty) return defaultColor;
    return Color(int.parse(colorString.replaceFirst("0x", ""), radix: 16));
  }
  List<Widget> detailsRow() {
    return myUnitBloc.transactionManagerDetail.keys.map((key) {
      final value = myUnitBloc.transactionManagerDetail[key];

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
                  SizedBox(width: 15,),

                ],
              ),
            ),
          ),
        ),
        containChild: BlocBuilder<MyUnitBloc, MyUnitState>(
            bloc: myUnitBloc,
            builder: (BuildContext context, state) {
              if (state is MyUnitLoadingState) {
                return WorkplaceWidgets.progressLoader(context);
              }
              if (state is MyUnitErrorState) {
                return  Center(
                  child: Column(
                    children: [
                      Text(state.message,style:appTextStyle.noDataTextStyle(),)
                    ],
                  ),
                );
              }
              return myUnitBloc.transactionManagerDetail.isEmpty? Center(
                child: Column(
                  children: [
                    Text(AppString.noDataFound,style:appTextStyle.noDataTextStyle(),)
                  ],
                ),
              ): Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 20),
                child: Column(
                  children: [
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
                            Text(myUnitBloc.statementPaymentManager.isNotEmpty?'Payment' : "",style: appTextStyle.appTitleStyle(),
                            ),

                            Text(myUnitBloc.statementInvoicesForManager.isNotEmpty && myUnitBloc.statementPaymentManager.isEmpty?'Invoices' : "",style: appTextStyle.appTitleStyle(),
                            )
                          ],),

                        ),

                        if (myUnitBloc.statementPaymentManager.isNotEmpty)ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: 8),
                            itemCount: myUnitBloc.statementPaymentManager.length,
                            itemBuilder: (context, index) {
                              return UnitStatementCardWidget(
                                title:
                                myUnitBloc.statementPaymentManager[index].title ?? '',
                                description:
                                myUnitBloc.statementPaymentManager[index].description ??
                                    '',
                                amount:
                                myUnitBloc.statementPaymentManager[index].amount ?? '',
                                type: myUnitBloc.statementPaymentManager[index].type ?? '',
                                date: myUnitBloc.statementPaymentManager[index].date ?? '',
                                subTitle:
                                myUnitBloc.statementPaymentManager[index].subTitle ??
                                    '',
                                table:
                                myUnitBloc.statementPaymentManager[index].table ?? '',
                                status:
                                myUnitBloc.statementPaymentManager[index].status ?? '',
                                statusColor: _parseColor(
                                    myUnitBloc.statementPaymentManager[index].statusColor ??
                                        ""),
                                balanceAmount: myUnitBloc
                                    .statementPaymentManager[index].balanceAmount ??
                                    "",
                                paymentMethod: myUnitBloc
                                    .statementPaymentManager[index].paymentMethod ??
                                    "",
                              );
                            }),
                        if (myUnitBloc.statementInvoicesForManager.isNotEmpty)ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: 8),
                            itemCount: myUnitBloc.statementInvoicesForManager.length,
                            itemBuilder: (context, index) {
                              return UnitStatementCardWidget(
                                title:
                                myUnitBloc.statementInvoicesForManager[index].title ?? '',
                                description:
                                myUnitBloc.statementInvoicesForManager[index].description ??
                                    '',
                                amount:
                                myUnitBloc.statementInvoicesForManager[index].amount ?? '',
                                type: myUnitBloc.statementInvoicesForManager[index].type ?? '',
                                date: myUnitBloc.statementInvoicesForManager[index].date ?? '',
                                subTitle:
                                myUnitBloc.statementInvoicesForManager[index].subTitle ??
                                    '',
                                table:
                                myUnitBloc.statementInvoicesForManager[index].table ?? '',
                                status:
                                myUnitBloc.statementInvoicesForManager[index].status ?? '',
                                statusColor: _parseColor(
                                    myUnitBloc.statementInvoicesForManager[index].statusColor ??
                                        ""),
                                balanceAmount: myUnitBloc
                                    .statementInvoicesForManager[index].balanceAmount ??
                                    "",
                                paymentMethod: myUnitBloc
                                    .statementInvoicesForManager[index].paymentMethod ??
                                    "",
                              );
                            })
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
