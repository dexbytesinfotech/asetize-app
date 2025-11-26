import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../app_global_components/common_floating_add_button.dart';
import '../../../app_global_components/unit_statement_card_widget.dart';
import '../../../app_global_components/unit_summary_card_widget.dart';
import '../../../app_global_components/unit_transaction_card_widget.dart';
import '../../../app_global_components/year_month_calendar.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../follow_up/pages/add_follow_up_screen.dart';
import '../../follow_up/pages/add_new_task.dart';
import '../../follow_up/pages/new_add_follow_up_screen.dart';
import '../../my_unit/bloc/my_unit_bloc.dart';
import '../../my_unit/pages/house_hold_screen.dart';
import '../../my_unit/pages/transaction_detail_screen.dart';
import '../../my_unit/pages/transaction_payment_detail_screen.dart';
import 'member_unit_detail_screen.dart';

class MemberUnitScreen extends StatefulWidget {
  final String userName;
  final List<Houses> houses;
  const MemberUnitScreen({super.key, required this.userName, required this.houses});

  @override
  State<MemberUnitScreen> createState() => _MemberUnitScreenState();
}

class _MemberUnitScreenState extends State<MemberUnitScreen> with TickerProviderStateMixin{
  late MyUnitBloc myUnitBloc;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  bool isShowLoader = true;
  Houses? selectedUnit;
  late TabController tabController;
  int tabInitialIndex = 0;
  bool? isInvoicePreview;
  String? invoicePreviewMessage;
  String? status;
  int? id;
  String? title;
  @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);

    if (widget.houses.isNotEmpty) {
      selectedUnit = widget.houses[0];
      isInvoicePreview = widget.houses[0].isInvoicePreview;
      invoicePreviewMessage = widget.houses[0].invoicePreviewMessage;
      status = widget.houses[0].status;
      id = widget.houses[0].id;
      title = widget.houses[0].title;
      myUnitBloc.add(FetchManagerInvoiceSummaryEvent(houseId: widget.houses[0].id.toString(), mContext: context));
      myUnitBloc.add(FetchManagerInvoiceStatementEvent(houseId: widget.houses[0].id.toString(), mContext: context));
      myUnitBloc.add(FetchInvoiceManagerTransactionEvent(houseId: widget.houses[0].id.toString(), mContext: context));
    }
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      // bloc.add(TabIndexEvent(tabIndex: tabController.index));
      setState(() {
        tabInitialIndex = tabController.index;
      });
      debugPrint("Current Index.....${tabController.index}");
    });
    super.initState();
  }


  List<Widget> actions() {
    return List.generate(widget.houses.length, (index) {
      return CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
          selectedUnit = widget.houses[index];
          isInvoicePreview = widget.houses[index].isInvoicePreview;
          status = widget.houses[index].status;
          id = widget.houses[index].id;
          title = widget.houses[index].title;
          invoicePreviewMessage = widget.houses[index].invoicePreviewMessage;
          myUnitBloc.add(FetchManagerInvoiceSummaryEvent(houseId: widget.houses[index].id.toString(), mContext: context));
          myUnitBloc.add(FetchManagerInvoiceStatementEvent(houseId: widget.houses[index].id.toString(), mContext: context));
          myUnitBloc.add(FetchInvoiceManagerTransactionEvent(houseId: widget.houses[index].id.toString(), mContext: context));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Remove the SvgPicture and make color blank
            Text(
              '${widget.houses[index].title}',
              style: TextStyle(
                color: selectedUnit?.title == widget.houses[index].title
                    ? AppColors.buttonBgColor3 // Selected color
                    : Colors.black,            // Default color
                fontWeight: selectedUnit?.title == widget.houses[index].title
                    ? FontWeight.w600          // Selected font weight
                    : FontWeight.normal,       // Default font weight
              ),
            ),

          ],
        ),
      );
    });
  }


  void _onRefresh() async {
    setState(() {
      isShowLoader = false;
    });
    myUnitBloc.add(FetchManagerInvoiceSummaryEvent(
        houseId: selectedUnit?.id.toString() ?? '', mContext: context));
    myUnitBloc.add(FetchManagerInvoiceStatementEvent(
        houseId: selectedUnit?.id.toString() ?? '', mContext: context));
    myUnitBloc.add(FetchInvoiceManagerTransactionEvent(
        houseId: selectedUnit?.id.toString() ?? '', mContext: context));
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.houses.isEmpty) {
      return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        isOverLayStatusBar: false,
        appBarHeight: 50,
        appBar: CommonAppBar(
          title: widget.userName,
          icon: WorkplaceIcons.backArrow,
        ),
        containChild: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.apartment,
                size: 50,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'No Units Available',
                style: appTextStyle.appTitleStyle(),
              ),
              const SizedBox(height: 8),
              Text(
                'You currently don\'t have any units assigned.',
                style: appTextStyle.appSubTitleStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    Color _parseColor(String? colorString, {Color defaultColor = Colors.black}) {
      if (colorString == null || colorString.isEmpty) return defaultColor;
      return Color(int.parse(colorString.replaceFirst("0x", ""), radix: 16));
    }
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        isOverLayStatusBar: false,




        appBarHeight: 50,
        appBar: CommonAppBar(
          title: widget.userName,
          icon: WorkplaceIcons.backArrow,
        ),
        containChild: BlocListener<MyUnitBloc, MyUnitState>(
          bloc: myUnitBloc,
          listener: (BuildContext context, MyUnitState state) {
            if (state is MyUnitInvoiceManagerErrorState ) {

              WorkplaceWidgets.errorSnackBar(context, state.message);

              myUnitBloc.add(ResetMyUnitEvent());
            }
          },
          child: BlocBuilder<MyUnitBloc, MyUnitState>(
            bloc: myUnitBloc,
            builder: (BuildContext context, state) {
              if (state is MyUnitInitialState) {
                // myUnitBloc.add(FetchManagerInvoiceSummaryEvent(houseId: selectedUnit?.id.toString() ?? '', mContext: context));
                // myUnitBloc.add(FetchManagerInvoiceStatementEvent(houseId: selectedUnit?.id.toString()?? '', mContext: context));
              }
              if (state is MyUnitLoadingState) {
                if (isShowLoader) {
                  return WorkplaceWidgets.progressLoader(context);
                }
              }
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: _onRefresh,
                footer: const ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                ),
                child:
                ListView(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              if (widget.houses.length > 1) {
                                showCupertinoModalPopup(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CupertinoActionSheet(
                                        title: const Text(
                                          AppString.selectUnit,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87),
                                        ),
                                        actions: actions(),
                                        cancelButton: CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            AppString.cancel,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      );
                                    });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.apartment,
                                  color: AppColors.textBlueColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppString.unitNoWithColon,
                                  style: appTextStyle.appTitleStyle(),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    Text(
                                      selectedUnit?.title ?? AppString.selectUnit,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                    widget.houses.length > 1
                                        ? const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.textBlueColor,
                                      size: 30,
                                    )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          houseHold(),
                        ],
                      ),
                    ),
                  /*  (isInvoicePreview == false && status == "active") ? Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('$invoicePreviewMessage',
                              textAlign: TextAlign.center,
                              style: appStyles.noDataTextStyle(),)
                          ],
                        ),
                      ),
                    ):*/
                    Column(
                      children: [
                        // houseHold(),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15,top: 5),
                          child: UnitSummaryCardWidget(
                            openingBalance: myUnitBloc.summaryManagerData?.openingBalance ?? '',
                            latestInvoiceDue: myUnitBloc.summaryManagerData?.latetInvoiceDue ?? '',
                            totalBalance: myUnitBloc.summaryManagerData?.totalBalance ?? '',
                            unpaidInvoiceCount:  myUnitBloc.summaryManagerData?.unpaidInvoicesCount ?? 0,
                            unpaidInvoicesCountLabel: myUnitBloc.summaryManagerData?.unpaidInvoicesCountLabel,
                            unpaidPaidMessage:  myUnitBloc.summaryManagerData?.unpaidPaidMessage ?? "",
                            isDue: myUnitBloc.summaryManagerData?.isDue ?? false,
                            unpaidPaidMessageTextColor: _parseColor(myUnitBloc.summaryManagerData?.unpaidPaidMessageTextColor),
                            totalBalanceColor: _parseColor(myUnitBloc.summaryManagerData?.totalBalanceColor),
                            latestInvoiceDueColor: _parseColor(myUnitBloc.summaryManagerData?.latetInvoiceDueColor),
                            isShowPayBt: false,
                            isShowCreateTask: false,
                            onTabForTask: (){
                              Navigator.push(
                                context,
                                SlideLeftRoute(widget:  AddTaskScreen(
                                    moduleName: "Maintenance",
                                    description: myUnitBloc.summaryManagerData?.unpaidPaidMessage ?? '',
                                    houseId: selectedUnit?.id,
                                  isComingFrom: true,
                                )),
                              );
                            },

                          ),
                        ),
                        const SizedBox(height: 15),
                        /* Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 10, left: 15, right: 15),
                      child: Row(
                        children: [
                          const Expanded(
                              child: Divider(
                                thickness: 0,
                              )),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            AppString.history,
                            style: appTextStyle.appSubTitleStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          const Expanded(
                              child: Divider(
                                thickness: 0,
                              )),
                        ],
                      ),
                    ),*/
                        Container(
                          color: Colors.transparent,
                          child: TabBar(
                              onTap: (int index) {
                                setState(() {
                                  tabInitialIndex = index;
                                });
                              },
                              labelColor: AppColors.appBlueColor,
                              labelPadding: const EdgeInsets.only(bottom: 10),
                              indicatorColor: AppColors.appBlueColor,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorWeight: 4,
                              unselectedLabelColor: AppColors.greyUnselected,
                              controller: tabController,
                              tabs: [
                                Text(
                                  'Summary',
                                  style: appStyles.tabTextStyle(),
                                ),
                                Text('Payments', style: appStyles.tabTextStyle()),
                                Text(
                                  'Statement',
                                  style: appStyles.tabTextStyle(),
                                )
                              ]),
                        ),
                        Stack(
                          children: [
                            if(tabInitialIndex == 0)
                              SizedBox(child:YearMonthCalendar(calendarWidth: MediaQuery.of(context).size.width,houseId: selectedUnit!.id)),
                            if (tabInitialIndex == 1)
                              Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    myUnitBloc.invoiceManagerTransactionData.isEmpty
                                        ? SizedBox(
                                      height: MediaQuery.of(context).size.height / 2.3,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                (state is MyUnitLoadingState)
                                                    ? ''
                                                    : AppString.youHaveNoPaymentDetailYet,
                                                style: appStyles.noDataTextStyle()),
                                          ],
                                        ),
                                      ),
                                    )
                                        : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(top: 8),
                                        itemCount: myUnitBloc.invoiceManagerTransactionData.length,
                                        itemBuilder: (context, index) {
                                          return UnitTransactionCardWidget(
                                            onTap : () {
                                              Navigator.push(
                                                  context,
                                                  SlideLeftRoute(
                                                      widget:
                                                          TransactionDetailScreen(
                                                            comeFrom: ComeFromForDetails.managerUnitPayment,
                                                            id: myUnitBloc
                                                                .invoiceManagerTransactionData[index]
                                                                .id ??
                                                                0,
                                                            date: myUnitBloc
                                                                .invoiceManagerTransactionData[index]
                                                                .paymentDate ??
                                                                '',
                                                            title: myUnitBloc
                                                                .invoiceManagerTransactionData[index]
                                                                .title ??
                                                                '',
                                                            receiptNumber: myUnitBloc
                                                                .invoiceManagerTransactionData[index]
                                                                .receiptNumber ??
                                                                '',
                                                          )
                                                    /*TransactionPaymentDetailScreen(
                                                            id: myUnitBloc
                                                                .invoiceTransactionData[index]
                                                                .id ??
                                                                0,
                                                            date: myUnitBloc
                                                                .invoiceTransactionData[index]
                                                                .paymentDate ??
                                                                '',
                                                            title: myUnitBloc
                                                                .invoiceTransactionData[index]
                                                                .title ??
                                                                '',
                                                            receiptNumber: myUnitBloc
                                                                .invoiceTransactionData[index]
                                                                .receiptNumber ??
                                                                '',
                                                          )*/));
                                              // FetchInvoiceTransactionDetailEvent
                                            },
                                            invoiceNumber: myUnitBloc.invoiceManagerTransactionData[index].invoiceNumber,
                                            receiptNumber: myUnitBloc.invoiceManagerTransactionData[index].title,
                                            paymentDate: myUnitBloc.invoiceManagerTransactionData[index].paymentDate,
                                            amount: myUnitBloc.invoiceManagerTransactionData[index].amount,
                                            paymentMethod: myUnitBloc.invoiceManagerTransactionData[index].paymentMethod,
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            if (tabInitialIndex == 2)
                              Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    myUnitBloc.statementManagerData.isEmpty
                                        ? SizedBox(
                                      height: MediaQuery.of(context).size.height / 2.3,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                (state is MyUnitLoadingState)
                                                    ? ''
                                                    : AppString.youHaveNoStatementDetailYet,
                                                style: appStyles.noDataTextStyle()),
                                          ],
                                        ),
                                      ),
                                    )
                                        : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(top: 8),
                                        itemCount: myUnitBloc.statementManagerData.length,
                                        itemBuilder: (context, index) {
                                          return UnitStatementCardWidget(
                                            title: myUnitBloc.statementManagerData[index].title ?? '',
                                            description: myUnitBloc.statementManagerData[index].description ?? '',
                                            amount: myUnitBloc.statementManagerData[index].amount ?? '',
                                            type: myUnitBloc.statementManagerData[index].type ?? '',
                                            date: myUnitBloc.statementManagerData[index].date ?? '',
                                            subTitle: myUnitBloc.statementManagerData[index].subTitle ?? '',
                                            table: myUnitBloc.statementManagerData[index].table ?? '',
                                            status:  myUnitBloc.statementManagerData[index].status ?? '',
                                            statusColor:  _parseColor(myUnitBloc.statementManagerData[index].statusColor),
                                            balanceAmount:  myUnitBloc.statementManagerData[index].balanceAmount ?? "",
                                            paymentMethod:  myUnitBloc.statementManagerData[index].paymentMethod ?? "",
                                            onTap: () {
                                              ///  As per the discussion with Dinesh Sir and Jitendra Sir, the statement details should be commented out until the next discussion.
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             TransactionDetailScreen(
                                              //               comeFrom: ComeFromForDetails.managerUnitStatement,
                                              //               id: myUnitBloc
                                              //                   .statementManagerData[index]
                                              //                   .id ??
                                              //                   0,
                                              //               date: myUnitBloc
                                              //                   .statementManagerData[index]
                                              //                   .date ??
                                              //                   '',
                                              //               tableName: myUnitBloc
                                              //                   .statementManagerData[index]
                                              //                   .table ??
                                              //                   '',
                                              //               title: myUnitBloc
                                              //                   .statementManagerData[index]
                                              //                   .title ??
                                              //                   '',
                                              //               receiptNumber: myUnitBloc
                                              //                   .statementManagerData[index]
                                              //                   .title ??
                                              //                   '',
                                              //             )
                                              //             /*MemberUnitDetailScreen(
                                              //               id: myUnitBloc
                                              //                   .statementManagerData[index]
                                              //                   .id ??
                                              //                   0,
                                              //               tableName: myUnitBloc
                                              //                   .statementManagerData[index]
                                              //                   .table ??
                                              //                   '',
                                              //               date: myUnitBloc
                                              //                   .statementManagerData[index]
                                              //                   .date ??
                                              //                   '',
                                              //               title: myUnitBloc
                                              //                   .statementManagerData[index]
                                              //                   .title ??
                                              //                   '',
                                              //             )*/));
                                            },
                                          );
                                        }),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
        bottomMenuView:  Positioned(
          bottom: 20, // comment field ke thoda upar
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () {
                Navigator.push(
          context,
          SlideLeftRoute(widget:  AddTaskScreen(
            moduleName: "Maintenance",
            description: myUnitBloc.summaryManagerData?.unpaidPaidMessage ?? '',
            houseId: selectedUnit?.id,
            isComingFrom: true,

          )),
                ).then((value) {
                if (value == true) {
                  // setState(() {
                  //   isLoader = false;
                  // });
                  // if (tabInitialIndex == 0) {
                  //   _applyFiltersForActiveTasks();
                  // } else {
                  //   _applyFiltersForCompletedTasks();
                  // }
                }
              });
            },
            label: const Text("Create Task", style: TextStyle(color: Colors.white,fontSize: 16),),
            icon: const Icon(Icons.add,color: Colors.white, weight: 5.5,),
            backgroundColor: AppColors.textBlueColor,
          ),
        ),
        // bottomMenuView:  CommonFloatingAddButton(onPressed: () {
        //
        //   Navigator.push(
        //     context,
        //     SlideLeftRoute(widget:  AddTaskScreen(
        //       moduleName: "Maintenance",
        //       description: myUnitBloc.summaryManagerData?.unpaidPaidMessage ?? '',
        //       houseId: selectedUnit?.id,
        //       isComingFrom: true,
        //
        //     )),
        //   );
        // },)

    );
  }


  Widget houseHold() {
    return
      GestureDetector(
        onTap: ()
        {
          Navigator.push(context, SlideLeftRoute(widget: HouseHoldScreen(
              isComingFromViewStatement: true,
              title: title ?? "",
              houseId: id ?? 0 )
          ));
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 4),
          margin: const EdgeInsets.only(right: 0),
          child: const  Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(AppString.houseHold,style: TextStyle(fontSize: 12,color: AppColors.appBlueColor),),
              SizedBox(width: 4,),
              Icon(Icons.arrow_forward_ios_rounded,size: 14,color: AppColors.appBlueColor)
            ],
          ),
        ),
      );
  }
}


