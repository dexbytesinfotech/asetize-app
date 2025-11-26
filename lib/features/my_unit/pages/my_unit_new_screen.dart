// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/features/my_unit/pages/transaction_detail_screen.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../app_global_components/no_units_error_screen.dart';
import '../../../app_global_components/unit_statement_card_widget.dart';
import '../../../app_global_components/unit_summary_card_widget.dart';
import '../../../app_global_components/unit_transaction_card_widget.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../service/razorpay_service.dart';
import '../../add_transaction_receipt/page/transaction_receipt_detail_screen.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_state.dart';
import '../bloc/my_unit_bloc.dart';
import 'house_hold_screen.dart';
import 'how_to_pay.dart';

class MyUnitNewScreen extends StatefulWidget {
  final String comeFor;

  const MyUnitNewScreen({super.key, this.comeFor = ""});

  @override
  State<MyUnitNewScreen> createState() => _MyUnitNewScreenState();
}

class _MyUnitNewScreenState extends State<MyUnitNewScreen>
    with TickerProviderStateMixin {
  late MyUnitBloc myUnitBloc;
  late UserProfileBloc userProfileBloc;
  late AddVehicleManagerBloc addVehicleManagerBloc;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isShowLoader = false;

  // Houses? selectedUnit;
  // List<Houses> houses = [];
  bool? isInvoicePreview;
  String? invoicePreviewMessage;

  late TabController tabController;
  int tabInitialIndex = 0;


  @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    myUnitBloc.add(OnHowToPayGetListEvent());
    if (userProfileBloc.user.houses != null &&
        userProfileBloc.user.houses!.isNotEmpty) {
      //houses = userProfileBloc.user.houses ?? [];
      // if(myUnitBloc.statementData.isEmpty || (myUnitBloc.statementData.isNotEmpty && myUnitBloc.statementData[0].houseId!=null && myUnitBloc.statementData[0].houseId! != userProfileBloc.selectedUnit!.id)){
      onUnitSelect(userProfileBloc.selectedUnit);
      // }
    }

    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    changTab();

    tabController.addListener(() {
      // bloc.add(TabIndexEvent(tabIndex: tabController.index));
      setState(() {
        tabInitialIndex = tabController.index;
      });
    });
    super.initState();
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;

  }

  Future<void> refreshDataOnNotificationComes() async {
    _onRefresh();
  }

  List<Widget> actions() {
    return List.generate(userProfileBloc.user.houses!.length, (index) {
      return CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
          onUnitSelect(userProfileBloc.user.houses![index]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Remove the SvgPicture and make color blank
            Text(
              '${userProfileBloc.user.houses![index].title}',
              style: TextStyle(
                color: userProfileBloc.selectedUnit?.title ==
                        userProfileBloc.user.houses![index].title
                    ? AppColors.buttonBgColor3 // Selected color
                    : Colors.black, // Default color
                fontWeight: userProfileBloc.selectedUnit?.title ==
                        userProfileBloc.user.houses![index].title
                    ? FontWeight.w600 // Selected font weight
                    : FontWeight.normal, // Default font weight
              ),
            ),
          ],
        ),
      );
    });
  }

  void _onRefresh() async {
    onUnitSelect(userProfileBloc.selectedUnit);
    await Future.delayed(const Duration(milliseconds: 500));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {


    return BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
      listener: (BuildContext context, AddVehicleManagerState state) {
        if (state is DeleteMemberDoneState) {
          //select 0 index house
          onUnitSelect(userProfileBloc.profileHouses?[0]);
          userProfileBloc.add(FetchProfileDetails(mContext: context));
        }
      },
      child: ContainerFirst(
          contextCurrentView: context,
          isSingleChildScrollViewNeed: false,
          isFixedDeviceHeight: true,
          isListScrollingNeed: true,
          isOverLayStatusBar: false,
          appBarHeight: 56,
          appBar: const CommonAppBar(
            title: AppString.myUnits,
            icon: WorkplaceIcons.backArrow,
          ),
          containChild: BlocListener<MyUnitBloc, MyUnitState>(
            bloc: myUnitBloc,
            listener: (BuildContext context, MyUnitState state) {
              if (state is MyUnitErrorState2) {
                WorkplaceWidgets.errorSnackBar(context, state.message);
              }
              if (state is PaymentsInitiateErrorState) {

                WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
              }
              if (state is PaymentGatewayDetailErrorState) {

                WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
              }

               if (state is PaymentCancelDoneState) {
                WorkplaceWidgets.successToast(state.message);
              }
               if (state is PaymentSuccessDoneState) {
                _onRefresh();
                WorkplaceWidgets.successToast(state.message);
              }
              if (state is PaymentGatewayDetailDoneState) {
                   showPaymentBottomSheet2(
                    context,
                    myUnitBloc.summaryData?.totalBalance ?? "",
                    state);
              }
            },
            child: BlocBuilder<MyUnitBloc, MyUnitState>(
              bloc: myUnitBloc,
              builder: (BuildContext context, state) {
                if (state is MyUnitInitialState) {
                  onUnitSelect(userProfileBloc.selectedUnit);
                }

                if (state is MyUnitLoadingState) {
                  isShowLoader = true;
                } else {
                  isShowLoader = false;
                }
                if (userProfileBloc.selectedUnit == null) {
                  return const Center(child: NoUnitsErrorScreen());
                }

                // return Column(
                //   children: [
                //     SizedBox(height: 300,width: double.infinity,child: const YearMonthCalendar(calendarHeight: 500,calendarWidth: double.infinity,)),
                //   ],
                // );
                return Stack(
                  children: [
                  SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: false,
                  onRefresh: _onRefresh,
                  footer: const ClassicFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 5,top: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (userProfileBloc.user.houses!.length > 1) {
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
                                          cancelButton:
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              AppString.cancel,
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                        userProfileBloc.selectedUnit?.title ??
                                            AppString.selectUnit,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                      ),
                                      userProfileBloc.user.houses!.length > 1
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
                            if (userProfileBloc.selectedUnit != null && userProfileBloc.selectedUnit!.status == "active")
                              houseHold(),

                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 5,top: 5),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           const Icon(
                      //             Icons.payments,
                      //             color: AppColors.textBlueColor,
                      //           ),
                      //           const SizedBox(width: 8),
                      //           Text(
                      //             AppString.paymentDetails,
                      //             style: appTextStyle.appTitleStyle(),
                      //           ),
                      //           const SizedBox(width: 8),
                      //         ],
                      //       ),
                      //       paymentDetails(),
                      //
                      //     ],
                      //   ),
                      // ),
                      selectedUnitDetailsView(state)
                    ],
                  ),
                ),
                  NetworkStatusAlertView(onReconnect: (){
                    _onRefresh();
                  },)

                  ],
                );
              },
            ),
          )),
    );
  }

  void onUnitSelect(Houses? house) {
    if (house != null) {
      userProfileBloc.add(OnChangeCurrentUnitEvent(selectedUnit: house));
      if (house.status == "active") {
        myUnitBloc.add(FetchInvoiceSummaryEvent(
            houseId: house.id.toString(), mContext: context));
        myUnitBloc.add(FetchInvoiceStatementEvent(
            houseId: house.id.toString(), mContext: context));
        myUnitBloc.add(FetchInvoiceTransactionEvent(
            houseId: house.id.toString(), mContext: context));

        myUnitBloc.add(FetchMonthlySummaryEvent(
            houseId: house.id!, mContext: context, year: 2025));
      } else {
        myUnitBloc.add(OnReLoadMyUnitUiEvent(mContext: context));
      }
    }
  }

  Color _parseColor(String? colorString, {Color defaultColor = Colors.black}) {
    if (colorString == null || colorString.isEmpty) return defaultColor;
    return Color(int.parse(colorString.replaceFirst("0x", ""), radix: 16));
  }

  void cancelRequest(BuildContext context, int houseMemberID) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WorkplaceWidgets.titleContentPopup(
          buttonName1: AppString.yes,
          buttonName2: AppString.no,
          onPressedButton2TextColor: AppColors.black,
          onPressedButton1TextColor: AppColors.white,
          onPressedButton2Color: Colors.grey.shade200,
          onPressedButton1Color: Colors.red,
          onPressedButton2: () {
            Navigator.pop(context);
          },
          onPressedButton1: () async {
            addVehicleManagerBloc.add(
              DeleteMemberEvent(
                houseMemberId: houseMemberID.toString(),
                mContext: context,
              ),
            );

            /*   userProfileBloc.add(OnChangeCurrentUnitEvent(selectedUnit: null));
            /// After cancel request change selected unit of index 0
            if (userProfileBloc.profileHouses?.isNotEmpty == true ) {
              PrefUtils().saveInt(WorkplaceNotificationConst.mySelectedUnitId,userProfileBloc.profileHouses?[0].id);
              PrefUtils().saveBool(WorkplaceNotificationConst.isInvoicePreview,userProfileBloc.profileHouses?[0].isInvoicePreview );
              PrefUtils().saveStr(WorkplaceNotificationConst.invoicePreviewMessage,userProfileBloc.profileHouses?[0].invoicePreviewMessage );
            }*/
            // onUnitSelect(userProfileBloc.selectedUnit);
            Navigator.of(ctx).pop();
          },
          title: AppString.cancelRequestTitle,
          content: AppString.cancelRequestContent,
        );
      },
    );
  }

  Widget selectedUnitDetailsView(state) {
    double height = MediaQuery.of(context).size.height / 1.5;
    final savedCompanyId = WorkplaceDataSourcesImpl.selectedCompanySaveId;
    Companies? company;
    try {
      company = userProfileBloc.user.companies!.firstWhere((company) => "${company.id}" == savedCompanyId);
    } catch (e) {
      print(e);
    }

    final bool isShowPayNowValue =
        (userProfileBloc.user.companies?.isNotEmpty ?? false) &&
            (company!=null && company.enableOnlinePayment == true) &&
            (() {
              final raw = myUnitBloc.summaryData?.totalBalance ?? '0';
              final cleaned = raw.replaceAll(RegExp(r'[^0-9\.-]'), '');
              return (num.tryParse(cleaned) ?? 0) > 0;
            })();

    if (isShowLoader) {
      return SizedBox(
          height: height, child: WorkplaceWidgets.progressLoader(context));
    }

    /// Selected Unit not Active
    if (userProfileBloc.selectedUnit != null && userProfileBloc.selectedUnit!.status != "active") {
      return SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(8.0).copyWith(left: 20, right: 20),
                child: Text(
                  textAlign: TextAlign.center,
                  AppString.joinHouseRequest,
                  style: appStyles.noDataTextStyle(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  cancelRequest(
                      context, userProfileBloc.selectedUnitHouseMemberId ?? 0);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        AppString.cancelRequest,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.appBlueColor,
                          color: AppColors.appBlueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ));
    }

    if (userProfileBloc.selectedUnit?.isInvoicePreview == false &&
        userProfileBloc.selectedUnit!.status == "active") {

      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${userProfileBloc.selectedUnit?.invoicePreviewMessage}',
                textAlign: TextAlign.center,
                style: appStyles.noDataTextStyle(),
              ),
            ],
          ),
        ),
      );
    }

    return state is InvoiceSummaryDoneState || myUnitBloc.summaryData != null

        ? Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [

                    // houseHold(),
                    UnitSummaryCardWidget(
                        backCallback: () {
                          myUnitBloc.add(OnPaymentGatewayDetailEvent(
                              mContext: context,
                              gatewayName: "razorpay")); // Reset the state

                        },
                        isShowHowToPay: myUnitBloc.howToPayData != null,
                        isShowPayNow: isShowPayNowValue,
                        isLoader: state is PaymentGatewayDetailLoadingState ? true:false,
                        openingBalance:
                            myUnitBloc.summaryData?.openingBalance ?? '',
                        latestInvoiceDue: !isOnSummaryTab()
                            ? ""
                            : (myUnitBloc.summaryData?.latetInvoiceDue ?? ''),
                        totalBalance:
                            myUnitBloc.summaryData?.totalBalance ?? '',
                        unpaidInvoiceCount: isOnSummaryTab()
                            ? (myUnitBloc.summaryData?.unpaidInvoicesCount ?? 0)
                            : 0,
                        unpaidPaidMessage: isOnSummaryTab()
                            ? (myUnitBloc.summaryData?.unpaidPaidMessage ?? "")
                            : "",
                        isDue: myUnitBloc.summaryData?.isDue ?? false,
                        unpaidPaidMessageTextColor: _parseColor(
                            myUnitBloc.summaryData?.unpaidPaidMessageTextColor),
                        totalBalanceColor: _parseColor(
                            myUnitBloc.summaryData?.totalBalanceColor),
                        latestInvoiceDueColor: _parseColor(
                            myUnitBloc.summaryData?.latetInvoiceDueColor),
                        unpaidInvoicesCountLabel:
                            myUnitBloc.summaryData?.unpaidInvoicesCountLabel),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (isOnSummaryTab() &&
                  AppPermission.instance.canPermission(
                      AppString.unitTransactionReceipt,
                      context: context))
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        SlideLeftRoute(
                            widget:
                                 TransactionReceiptDetailScreen(isShowPayNow: isShowPayNowValue,isDue: myUnitBloc.summaryData?.isDue)));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          AppString.transactionReceipts,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textBlueColor,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: isOnSummaryTab() ? 18 : 0,
              ),
              TabBar(
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
                    Text('Payments', style: appStyles.tabTextStyle()),
                    Text(
                      'Statement',
                      style: appStyles.tabTextStyle(),
                    )
                  ]),
              Stack(
                children: [
                  // if(tabInitialIndex == 0)
                  //   SizedBox(child:YearMonthCalendar(calendarWidth: MediaQuery.of(context).size.width,)),
                  if (tabInitialIndex == 0)
                    Column(
                      children: [
                        myUnitBloc.invoiceTransactionData.isEmpty
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 2.3,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          (state is MyUnitLoadingState)
                                              ? ''
                                              : AppString
                                                  .youHaveNoPaymentDetailYet,
                                          style: appStyles.noDataTextStyle()),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                itemCount:
                                    myUnitBloc.invoiceTransactionData.length,
                                itemBuilder: (context, index) {
                                  return UnitTransactionCardWidget(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          SlideLeftRoute(
                                              widget:
                                                  TransactionDetailScreen(
                                                    comeFrom: ComeFromForDetails
                                                        .unitPayment,
                                                    id: myUnitBloc
                                                            .invoiceTransactionData[
                                                                index]
                                                            .id ??
                                                        0,
                                                    date: myUnitBloc
                                                            .invoiceTransactionData[
                                                                index]
                                                            .paymentDate ??
                                                        '',
                                                    title: myUnitBloc
                                                            .invoiceTransactionData[
                                                                index]
                                                            .title ??
                                                        '',
                                                    receiptNumber: myUnitBloc
                                                            .invoiceTransactionData[
                                                                index]
                                                            .receiptNumber ??
                                                        '',
                                                  )));
                                      // FetchInvoiceTransactionDetailEvent
                                    },
                                    invoiceNumber: myUnitBloc
                                        .invoiceTransactionData[index]
                                        .invoiceNumber,
                                    receiptNumber: myUnitBloc
                                        .invoiceTransactionData[index].title,
                                    paymentDate: myUnitBloc
                                        .invoiceTransactionData[index]
                                        .paymentDate,
                                    amount: myUnitBloc
                                        .invoiceTransactionData[index].amount,
                                    paymentMethod: myUnitBloc
                                        .invoiceTransactionData[index]
                                        .paymentMethod,
                                  );
                                }),
                      ],
                    ),
                  if (tabInitialIndex == 1)
                    Column(
                      children: [
                        myUnitBloc.statementData.isEmpty
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 2.3,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          (state is MyUnitLoadingState)
                                              ? ''
                                              : AppString
                                                  .youHaveNoStatementDetailYet,
                                          style: appStyles.noDataTextStyle()),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                itemCount: myUnitBloc.statementData.length,
                                itemBuilder: (context, index) {
                                  return UnitStatementCardWidget(
                                    title:
                                        myUnitBloc.statementData[index].title ??
                                            '',
                                    description: myUnitBloc
                                            .statementData[index].description ??
                                        '',
                                    amount: myUnitBloc
                                            .statementData[index].amount ??
                                        '',
                                    type:
                                        myUnitBloc.statementData[index].type ??
                                            '',
                                    date:
                                        myUnitBloc.statementData[index].date ??
                                            '',
                                    subTitle: myUnitBloc
                                            .statementData[index].subTitle ??
                                        '',
                                    table:
                                        myUnitBloc.statementData[index].table ??
                                            '',
                                    status: myUnitBloc
                                            .statementData[index].status ??
                                        '',
                                    statusColor: _parseColor(myUnitBloc
                                            .statementData[index].statusColor ??
                                        ""),
                                    balanceAmount: myUnitBloc
                                            .statementData[index]
                                            .balanceAmount ??
                                        "",
                                    paymentMethod: myUnitBloc
                                            .statementData[index]
                                            .paymentMethod ??
                                        "",
                                    onTap: () {
                                      ///  As per the discussion with Dinesh Sir and Jitendra Sir, the statement details should be commented out until the next discussion.
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             TransactionDetailScreen(comeFrom: ComeFromForDetails.unitStatement,
                                      //               id: myUnitBloc
                                      //                   .statementData[index]
                                      //                   .id ??
                                      //                   0,
                                      //               tableName: myUnitBloc
                                      //                   .statementData[index]
                                      //                   .table ??
                                      //                   '',
                                      //               date: myUnitBloc
                                      //                   .statementData[index]
                                      //                   .date ??
                                      //                   '',
                                      //               title: myUnitBloc
                                      //                   .statementData[index]
                                      //                   .title ??
                                      //                   '',
                                      //               receiptNumber: myUnitBloc
                                      //                   .statementData[index].subTitle ??
                                      //                   '',
                                      //             )));
                                    },
                                  );
                                }),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                ],
              ),
            ],
          )
        : WorkplaceWidgets.progressLoader(context);
  }

  void changTab() {
    if (widget.comeFor.isNotEmpty) {
      switch (widget.comeFor.toLowerCase()) {
        case "payment":
          tabInitialIndex = 0;
          tabController.index = 0;
          break;
        case "invoice":
          tabInitialIndex = 1;
          tabController.index = 1;
          break;
      }
    }
  }

  Widget houseHold() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                SlideLeftRoute(
                    widget: HouseHoldScreen(
                  title: userProfileBloc.selectedUnit?.title ?? "",
                  houseId: userProfileBloc.selectedUnit?.id ?? 0,
                )));
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppString.houseHold,
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
            // padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppString.howToPayWithIconText,
                  style: TextStyle(fontSize: 20, color: AppColors.appBlueColor),
                ),
                SizedBox(
                  width: 4,
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 18, color: AppColors.appBlueColor)
              ],
            ),
          ),
        ),
      ],
    );
  }

  rowWidget(String rightText, leftText, {bool isBoldText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(rightText, style: appStyles.subTitleStyle(fontSize: 14)),
          Text(leftText,
              style: appStyles.subTitleStyle(
                  fontSize: 14,
                  texColor: Colors.black,
                  fontWeight: isBoldText == true
                      ? FontWeight.w600
                      : FontWeight.normal)),
        ],
      ),
    );
  }

  void showPaymentBottomSheet2(BuildContext context, String amount, state) {
    final myUnitBloc =
        BlocProvider.of<MyUnitBloc>(context); // Get MyUnitBloc from context
    final razorpay = RazorpayService(context, myUnitBloc);
    final cleanedAmount = amount.replaceAll(RegExp(r'[^\d.]'), '');
    final double originalAmount = double.tryParse(cleanedAmount) ?? 0;
    final TextEditingController amountController =
        TextEditingController(text: originalAmount.toStringAsFixed(0));

    double enteredAmount = originalAmount;
    razorpay.calculateCharges(enteredAmount, 0.18, 0.02);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 30,
            left: 20,
            right: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Make a Payment",
                    style: AppStyle()
                        .titleStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Pay your maintenance dues for Unit No: ${userProfileBloc.selectedUnit?.title}",
                    style: AppStyle().subTitleStyle(
                        fontSize: 14, texColor: Colors.grey.shade600),
                  ),
                  SizedBox(height: 20),

                  // Amount Input Field
                  CommonTextFieldWithError(
                    isShowBottomErrorMsg: true,
                    controllerT: amountController,
                    borderRadius: 8,
                    inputHeight: 50,
                    errorLeftRightMargin: 0,
                    maxCharLength: 500,
                    errorMsgHeight: 18,
                    minLines: 1,
                    autoFocus: false,
                    showError: true,
                    showCounterText: false,
                    capitalization: CapitalizationText.sentences,
                    cursorColor: Colors.grey,
                    enabledBorderColor: Colors.white,
                    focusedBorderColor: Colors.white,
                    backgroundColor: AppColors.white,
                    textInputAction: TextInputAction.done,
                    inputKeyboardType: InputKeyboardTypeWithError.numberWithDecimal, // Ensure this is set
                    borderStyle: BorderStyle.solid,
                    hintText: "Amount",
                    placeHolderTextWidget: Padding(
                      padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                      child: Text.rich(
                        TextSpan(
                          text: "Amount",
                          style: appStyles.texFieldPlaceHolderStyle(
                              fontWeight: FontWeight.w500),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    hintStyle: appStyles.textFieldTextStyle(
                      fontWeight: FontWeight.w400,
                      texColor: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                    textStyle: appStyles.textFieldTextStyle(
                        fontWeight: FontWeight.w500),
                    contentPadding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    onEndEditing: (value) {},
                    onTextChange: (value) {
                      final val = double.tryParse(value) ?? 0;
                      if (val <= originalAmount) {
                        setState(() {
                          enteredAmount = val;
                          razorpay.calculateCharges(enteredAmount, 0.18, 0.02);
                        });
                      } else {
                        // If user enters more, reset to max allowed
                        amountController.text = originalAmount.toStringAsFixed(2);
                        amountController.selection = TextSelection.fromPosition(
                          TextPosition(offset: amountController.text.length),
                        );
                        setState(() {
                          enteredAmount = originalAmount;
                          razorpay.calculateCharges(enteredAmount, 0.18, 0.02);
                        });
                      }
                    },
                  ),

                  // Total Due Row
                  rowWidget("Remaining Due:",
                      "₹ ${(originalAmount - enteredAmount).toStringAsFixed(2)}"),

                  rowWidget(
                    projectUtil.capitalizeFirstLetter(myUnitBloc.paymentGatewayDetailData?.platformFeeLabelName) ??
                        "Platform Fee (2%):",
                    "₹ ${razorpay.fee.toStringAsFixed(2)}",
                  ),
                  rowWidget(
                    projectUtil.capitalizeFirstLetter(myUnitBloc.paymentGatewayDetailData?.gstLabelName) ??
                        "GST (18%):",
                    "₹ ${razorpay.gst.toStringAsFixed(2)}",
                  ),

                  rowWidget("Total Payable:",
                      "₹ ${razorpay.totalAmount.toStringAsFixed(2)}",
                      isBoldText: true),

                  SizedBox(height: 30),

                  // Buttons
                  BlocListener<MyUnitBloc, MyUnitState>(
                    bloc: myUnitBloc,
                    listener: (context, state) {
                      if (state is PaymentCancelLoadingState ||
                          state is PaymentSuccessLoadingState ||
                          state is PaymentsInitiateLoadingState) {
                        WorkplaceWidgets.progressLoader(context);
                      }

                      if (state is PaymentsInitiateDoneState) {
                        FocusScope.of(context).unfocus();
                        // Open Razorpay checkout
                        razorpay.openCheckout2(
                          baseAmount: enteredAmount,
                          razorPayKey: myUnitBloc.paymentGatewayDetailData?.key ?? '',
                          name: myUnitBloc.paymentGatewayDetailData?.name ?? "Asetize",
                          description: myUnitBloc.paymentGatewayDetailData?.description ?? "Maintenance Payment",
                          contact: '+${userProfileBloc.user.countryCode} ${userProfileBloc.user.phone}' ?? "",
                          email: "",
                          paymentAttemptId: state.paymentAttemptId.toString(),
                          houseId: state.houseId.toString(),
                          houseName: state.houseName.toString(),
                          gst: myUnitBloc.paymentGatewayDetailData?.gstPercentage ?? 0.18,
                          platformFee: myUnitBloc.paymentGatewayDetailData?.platformFeePercentage ?? 0.02,
                          upi: myUnitBloc.paymentGatewayDetailData?.upi ?? false,
                          card: myUnitBloc.paymentGatewayDetailData?.card ?? false,
                          netBanking: myUnitBloc.paymentGatewayDetailData?.netBanking ?? false,
                          wallet: myUnitBloc.paymentGatewayDetailData?.wallet ?? false,
                          emi: myUnitBloc.paymentGatewayDetailData?.emi ?? false,
                          payLater: myUnitBloc.paymentGatewayDetailData?.payLater ?? false,
                        );
                        // Close the bottom sheet immediately
                          Navigator.pop(context); // Close the bottom sheet

                      }
                    },
                    child: BlocBuilder<MyUnitBloc, MyUnitState>(
                      bloc: myUnitBloc,
                      builder: (context, state) {
                        bool isPayDisabled = amountController.text.isEmpty || double.tryParse(amountController.text) == null || (double.tryParse(amountController.text) ?? 0) <= 0;
                        bool isCancelDisabled = state is PaymentsInitiateLoadingState;

                        return Row(
                          children: [
                            // Cancel Button
                            Expanded(
                              child: AppButton(
                                buttonHeight: 50,
                                borderRadius: 8,
                                buttonName: "Cancel",
                                buttonColor: AppColors.white,
                                textStyle: appStyles.buttonTextStyle1(
                                  texColor: AppColors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                                buttonBorderColor: Colors.grey,
                                isLoader: false,
                                backCallback: isCancelDisabled
                                    ? null
                                    : () => Navigator.pop(context),
                              ),
                            ),
                            SizedBox(width: 10),

                            Expanded(
                              child: AppButton(
                                buttonHeight: 50,
                                borderRadius: 8,
                                buttonName: "Pay ₹${razorpay.totalAmount.toStringAsFixed(2)}",
                                buttonColor: isPayDisabled
                                    ? AppColors.grey
                                    : AppColors.textBlueColor,
                                textStyle: appStyles.buttonTextStyle1(
                                  texColor: AppColors.white,
                                ),
                                isLoader: state is PaymentsInitiateLoadingState,
                                backCallback: isPayDisabled
                                    ? null
                                    : () {
                                  myUnitBloc.add(OnPaymentsInitiateEvent(
                                    mContext: context,
                                    houseId: userProfileBloc.selectedUnit?.id ?? 0,
                                    amount: double.parse(amountController.text),
                                    gatewayAmount: double.parse(
                                        razorpay.fee.toStringAsFixed(2)),
                                    gstAmount: double.parse(
                                        razorpay.gst.toStringAsFixed(2)),
                                    totalAmount: double.parse(
                                        razorpay.totalAmount.toStringAsFixed(2)),
                                  ));
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              );
            },
          ),
        );
      },
    );
  }

  bool isOnSummaryTab() => true;
}
