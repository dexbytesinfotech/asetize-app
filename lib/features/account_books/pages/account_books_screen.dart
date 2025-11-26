import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/features/account_books/pages/pay_out_screen.dart';
import 'package:asetize/features/account_books/pages/payment_history_detail_screen.dart';
import 'package:asetize/features/account_books/pages/view_all_payees_screen.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../app_global_components/common_floating_add_button.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/app_permission.dart';
import 'package:asetize/features/account_books/pages/pending_confirmation.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../add_transaction_receipt/page/add_transaction_form.dart';
import '../../add_transaction_receipt/page/suspense_history_screen.dart';
import '../../add_transaction_receipt/page/suspense_entry_screen.dart';
import '../bloc/account_book_bloc.dart';
import '../bloc/account_book_event.dart';
import '../bloc/account_book_state.dart';
import 'filter_bottom_sheet.dart';

class AccountBooksScreen extends StatefulWidget {
  final bool isComeFromAddExpenses;
  const AccountBooksScreen({super.key, this.isComeFromAddExpenses = false});

  @override
  State<AccountBooksScreen> createState() => _AccountBooksScreenState();
}

class _AccountBooksScreenState extends State<AccountBooksScreen> {
  late AccountBookBloc accountBloc;
  Houses? selectedUnit;
  bool isShowLoader = true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController scrollController = ScrollController();
  bool isLoadMore = false;
  String? selectedPaymentType = 'All'; // Default to 'All'

  void _onRefresh() async {
    setState(() {
      isShowLoader = false;
    });
    accountBloc.setPostPageEnded = false;
    accountBloc.add(FetchAccountBookSummaryEvent(
      mContext: context,
      filterName: accountBloc.filterName,
      startDate: accountBloc.selectedStartDate,
      endDate: accountBloc.selectedEndDate,
    ));
    accountBloc.add(FetchAccountBookHistoryEvent(
      mContext: context,
      filterName: accountBloc.filterName,
      startDate: accountBloc.selectedStartDate,
      endDate: accountBloc.selectedEndDate,
      paymentType: widget.isComeFromAddExpenses
          ? 'debit'
          : accountBloc.paymentType,
      isVerified: "1"

      // Force debit
    ));
    await Future.delayed(const Duration(milliseconds: 100));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (!accountBloc.getPostPageEnded && !isLoadMore) {
      accountBloc.add(FetchAccountBookHistoryOnLoadEvent(
        mContext: context,
        filterName: accountBloc.filterName,
        startDate: accountBloc.selectedStartDate,
        endDate: accountBloc.selectedEndDate,
        paymentType: widget.isComeFromAddExpenses
            ? 'debit'
            : accountBloc.paymentType,
        isVerified: '1'// Force debit
      ));
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    _refreshController.loadComplete();
  }

  void _onScroll() {
    if (scrollController.hasClients) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      final triggerScroll = maxScroll * 0.5; // 50% of scrollable area
      if (currentScroll >= triggerScroll) {
        _onLoading();
      }
    }
  }

  void fetchInitialData() {
    if (accountBloc.historyData.isEmpty) {
        isShowLoader = true; // Show loader only when data is empty
    } else {
        isShowLoader = false; // No loader if data exists
    }
    accountBloc.add(FetchAccountBookSummaryEvent(
      mContext: context,
      filterName: accountBloc.filterName,
      startDate: accountBloc.selectedStartDate,
      endDate: accountBloc.selectedEndDate,
    ));

    accountBloc.add(FetchAccountBookHistoryEvent(
      mContext: context,
      filterName: accountBloc.filterName,
      startDate: accountBloc.selectedStartDate,
      endDate: accountBloc.selectedEndDate,
      paymentType: widget.isComeFromAddExpenses
          ? 'debit'
          : accountBloc.paymentType,
      isVerified: '1',
    ));

    accountBloc.add(FetchExpensesCategoryEvent(mContext: context));
    accountBloc.add(FetchPaymentMethodEvent(mContext: context));
  }



  void clearFilter(){
    accountBloc. filterName = 'current_month'; // Defaul
    accountBloc.selectedFilterName = 'Current month' ;
    accountBloc.startDate = null;
    accountBloc.endDate = null;
    accountBloc.selectedStartDate = '';
    accountBloc.selectedEndDate = '' ;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  void initState() {
    accountBloc = BlocProvider.of<AccountBookBloc>(context);
// Set payment type to 'debit' if isComeFromAddExpenses is true

    clearFilter();

    if (widget.isComeFromAddExpenses) {
      selectedPaymentType = 'Debit';
      accountBloc.selectedPaymentType = 'Debit';
      accountBloc.paymentType = 'debit';
    } else {
      selectedPaymentType = 'All';
      accountBloc.selectedPaymentType = 'All';
      accountBloc.paymentType = 'all';
    }
    fetchInitialData();
    scrollController.addListener(_onScroll);
    accountBloc.setPostPageEnded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget paymentHistoryCard({
      required String title,
      required String description,
      required String subTitle,
      required String table,
      required String amount,
      required String type,
      required String voucherNumber,
      required String paymentMode,
      required String date,
      required Function()? onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: CommonCardView(
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: appTextStyle.appTitleStyle(),
                    ),
                    Text(
                      amount,
                      style: appTextStyle.appTitleStyle(
                        color: type.toLowerCase() == "credited"
                            ? AppColors.appGreen
                            : AppColors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                subTitle.isNotEmpty
                    ? Row(
                        children: [
                          Flexible(
                            child: Text(
                              subTitle.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: appTextStyle.appSubTitleStyle(),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(height: 0),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    voucherNumber.isNotEmpty
                        ? Text(
                      "$voucherNumber",
                      style: appTextStyle.appSubTitleStyle(),
                    )
                        : const SizedBox(),
                    paymentMode.isNotEmpty
                        ? Text(
                      "$paymentMode",
                      style: appTextStyle.appTitleStyle(),
                    )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: appTextStyle.appSubTitleStyle(
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Text(
                          type,
                          style: appTextStyle.appSubTitleStyle(),
                        ),
                        const SizedBox(width: 4),
                        type.toLowerCase() == "credited"
                            ? SvgPicture.asset(
                                'assets/images/left_icon.svg',
                                color: AppColors.appGreen,
                                height: 25,
                              )
                            : SvgPicture.asset(
                                'assets/images/right_icon.svg',
                                color: AppColors.red,
                                height: 25,
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget paymentSummaryCard({
      required String netBalance,
      required String totalPayment,
      required String netBalanceColor,
      required String totalPaymentColor,
      required String totalExpensesColor,
      required String totalExpenses,
    }) {
      return CommonCardView(
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppString.netBalance,
                      style: appTextStyle.appLargeTitleStyle(),
                    ),
                    Text(
                      netBalance,
                      style: appTextStyle.appLargeTitleStyle(
                        color: netBalanceColor.isNotEmpty
                            ? Color(int.parse(netBalanceColor))
                            : AppColors.appGreenCommonColors,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.withOpacity(0.6),
                thickness: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.totalIncome,
                          style: appTextStyle.appSubTitleStyle(
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          totalPayment,
                          style: appTextStyle.appSubTitleStyle(
                            color: totalPaymentColor.isNotEmpty
                                ? Color(int.parse(totalPaymentColor))
                                : AppColors.appBlueColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.totalExpenses,
                          style: appTextStyle.appSubTitleStyle(
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          totalExpenses,
                          style: appTextStyle.appSubTitleStyle(
                            color: totalExpensesColor.isNotEmpty
                                ? Color(int.parse(totalExpensesColor))
                                : Colors.red,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget bottomViewForAccount() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 15, left: 20, right: 20, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (AppPermission.instance
                      .canPermission(AppString.accountPayIn, context: context))
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            MainAppBloc.getDashboardContext,
                            SlideLeftRoute(
                              widget: const AddTransactionForm(
                                  comeWithPermission: [
                                    AppString.accountPaymentAdd
                                  ]),
                            ),
                          ).then((value) {
                            if (value == true) {
                              setState(() {
                                isShowLoader = false;
                              });
                              accountBloc.add(FetchAccountBookSummaryEvent(
                                mContext: context,
                                filterName: accountBloc.filterName,
                                startDate: accountBloc.selectedStartDate,
                                endDate: accountBloc.selectedEndDate,
                              ));
                              accountBloc.add(FetchAccountBookHistoryEvent(
                                mContext: context,
                                filterName: accountBloc.filterName,
                                startDate: accountBloc.selectedStartDate,
                                endDate: accountBloc.selectedEndDate,
                                paymentType: widget.isComeFromAddExpenses
                                    ? 'debit'
                                    : accountBloc.paymentType,
                                isVerified: '1'// Force debit
                              ));
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 17, vertical: 15),
                          decoration: BoxDecoration(
                            color: AppColors.textDarkGreenColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add,
                                  size: 22, color: AppColors.white),
                              const SizedBox(width: 5),
                              Text(
                                AppString.payIn,
                                style: appTextStyle.appTitleStyle(
                                    color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    width: (AppPermission.instance.canPermission(
                                AppString.accountPayIn,
                                context: context) &&
                            AppPermission.instance.canPermission(
                                AppString.accountPayOut,
                                context: context))
                        ? 15
                        : 0,
                  ),
                  if (AppPermission.instance
                      .canPermission(AppString.accountPayOut, context: context))
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                                  SlideLeftRoute(widget: const PayOutScreen(isComingFromAccountBook: true,)))
                              .then((value) {
                            if (value == true) {
                              setState(() {
                                isShowLoader = false;
                              });
                              accountBloc.add(FetchAccountBookSummaryEvent(
                                mContext: context,
                                filterName: accountBloc.filterName,
                                startDate: accountBloc.selectedStartDate,
                                endDate: accountBloc.selectedEndDate,
                              ));
                              accountBloc.add(FetchAccountBookHistoryEvent(
                                mContext: context,
                                filterName: accountBloc.filterName,
                                startDate: accountBloc.selectedStartDate,
                                endDate: accountBloc.selectedEndDate,
                                paymentType: widget.isComeFromAddExpenses
                                    ? 'debit'
                                    : accountBloc.paymentType,
                                isVerified: '1'// Force debit
                              ));
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 17, vertical: 15),
                          decoration: BoxDecoration(
                            color: AppColors.textDarkRedColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.remove,
                                  size: 22, color: AppColors.white),
                              const SizedBox(width: 5),
                              Text(
                                AppString.payOut,
                                style: appTextStyle.appTitleStyle(
                                    color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    }


    Widget bottomViewForAddExpenses(){
      return CommonFloatingAddButton(
        onPressed: () {
          Navigator.push(
            context,
            SlideLeftRoute(widget: const PayOutScreen()),
          ).then((value) {
            // This block runs when AccountBooksScreen is popped
            if (value == true) {
              setState(() {
               widget.isComeFromAddExpenses == true;
              });
              _onRefresh();
              // accountBloc.add(FetchAccountBookHistoryEvent(
              //   mContext: context,
              //   filterName: accountBloc.filterName,
              //   startDate: accountBloc.selectedStartDate,
              //   endDate: accountBloc.selectedEndDate,
              //   paymentType: 'debit', // Force refresh of debit data
              // ));
            }
          });
        },
      );
    }

    Widget suspenseHistory() {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              SlideLeftRoute(
                  widget: const SuspenseHistoryScreen(isShowLoader: true)));
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          margin: const EdgeInsets.only(right: 0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppString.suspensePaymentsLabel,
                style: TextStyle(fontSize: 14, color: AppColors.appBlueColor),
              ),
              SizedBox(width: 0),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 15, color: AppColors.appBlueColor),
            ],
          ),
        ),
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: CommonAppBar(
        title: widget.isComeFromAddExpenses
            ? AppString.expensesList
            : AppString.accountBooks,
        icon: WorkplaceIcons.backArrow,
        isHideBorderLine: true,
        action: widget.isComeFromAddExpenses == false
            ? Container(
                margin: const EdgeInsets.only(right: 0, bottom: 0),
                child: SizedBox(
                  width: 80,
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      WorkplaceWidgets.showPrintOptionDialog(
                        context: context,
                        onConfirm: ({
                          required String selectedOption,
                          DateTime? startDate,
                          DateTime? endDate,
                        }) {
                          String? formattedStartDate;
                          String? formattedEndDate;

                          if (selectedOption == 'custom' &&
                              startDate != null &&
                              endDate != null) {
                            formattedStartDate =
                                projectUtil.submitDateFormat(startDate);
                            formattedEndDate =
                                projectUtil.submitDateFormat(endDate);
                          }

                          accountBloc.add(
                            OnPrintStatementEvent(
                              mContext: context,
                              startDate: formattedStartDate ?? '',
                              endDate: formattedEndDate?? '',
                            ),
                          );
                        },
                      );
                    },
                    icon:
                        const Icon(Icons.print, color: Colors.black, size: 16),
                    label: Text(
                      AppString.print,
                      style: appStyles.userNameTextStyle(
                        fontSize: 13,
                        texColor: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      backgroundColor: Color(0xFFF5F5F5),
                      elevation: 0,
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ),
      containChild: BlocListener<AccountBookBloc, AccountBookState>(
        bloc: accountBloc,
        listener: (BuildContext context, AccountBookState state) {
          if (state is AccountBookErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is PrintStatementErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }

          if (state is PrintStatementDoneState) {
            WorkplaceWidgets.successPopup(
              context: context,
              content: state.message,
              buttonName: AppString.ok,
              buttonColor: AppColors.textBlueColor,
              buttonTextColor: Colors.white,
              onButtonPressed: () {
                Navigator.pop(context);
              },
            );
          }
        },
        child: BlocBuilder<AccountBookBloc, AccountBookState>(
          bloc: accountBloc,
          builder: (BuildContext context, state) {
            if (state is AccountBookInitialState) {}
            if (state is AddExpensesDoneState) {
              accountBloc.add(FetchAccountBookSummaryEvent(
                mContext: context,
                filterName: accountBloc.filterName,
                startDate: accountBloc.selectedStartDate,
                endDate: accountBloc.selectedEndDate,
              ));
              accountBloc.add(FetchAccountBookHistoryEvent(
                mContext: context,
                filterName: accountBloc.filterName,
                startDate: accountBloc.selectedStartDate,
                endDate: accountBloc.selectedEndDate,
                paymentType: widget.isComeFromAddExpenses
                    ? 'debit'
                    : accountBloc.paymentType,
                isVerified: '1'// Force debit
              ));
            }
            if (state is AccountBookLoadingState) {
              if (isShowLoader) {
                return WorkplaceWidgets.progressLoader(context);
              }
            }
            if (state is AccountBookOnLoadLoadingState) {
              isLoadMore = true;
            }
            if (state is FetchAccountBookHistoryDoneState) {
              isLoadMore = false;
            }
            return Stack(
              children: [
                SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: !accountBloc.getPostPageEnded,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  footer: const ClassicFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                  ),
                  child:   ListView(
                    padding: EdgeInsets.zero,
                    controller: scrollController,
                    // physics: NeverScrollableScrollPhysics(),

                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: MainAppBloc.getDashboardContext,
                                isDismissible: false,
                                enableDrag: true,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                ),
                                builder: (ctx) => StatefulBuilder(
                                  builder: (ctx, state) => FractionallySizedBox(
                                    heightFactor: MediaQuery.of(ctx).size.height < 600 ? 0.65 : 0.62,
                                    child: FilterBottomSheet(
                                      filterType: "time_based",
                                      selectedFilterOption:
                                      accountBloc.selectedFilterName,
                                      selectedPaymentType:
                                      accountBloc.selectedPaymentType,
                                      startDate: accountBloc.startDate,
                                      endDate: accountBloc.endDate,
                                      isComeFromAddExpenses:
                                      widget.isComeFromAddExpenses,
                                    ),
                                  ),
                                ),
                              ).then((value) {
                                setState(() {
                                  isShowLoader = false;
                                });
                              });
                            },
                            child: Container(
                              margin:
                              const EdgeInsets.only(right: 5, bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    accountBloc.selectedFilterName,
                                    style: appStyles.userNameTextStyle(
                                      fontSize: 13,
                                      texColor: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.filter_list,
                                      size: 16, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          if (!widget
                              .isComeFromAddExpenses) // Hide payment type filter when isComeFromAddExpenses is true
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: MainAppBloc.getDashboardContext,
                                  isDismissible: false,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                  ),
                                  builder: (ctx) => StatefulBuilder(
                                    builder: (ctx, state) =>
                                        FractionallySizedBox(
                                          heightFactor: 0.42,
                                          child: FilterBottomSheet(
                                            filterType: "payment_type",
                                            isComeFromAddExpenses:
                                            widget.isComeFromAddExpenses,
                                            selectedFilterOption:
                                            accountBloc.selectedFilterName,
                                            selectedPaymentType:
                                            accountBloc.selectedPaymentType,
                                            startDate: accountBloc.startDate,
                                            endDate: accountBloc.endDate,
                                          ),
                                        ),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    isShowLoader = false;
                                  });
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 10, bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      accountBloc.selectedPaymentType,
                                      style: appStyles.userNameTextStyle(
                                        fontSize: 13,
                                        texColor: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.filter_list,
                                        size: 16, color: Colors.black),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      if (widget.isComeFromAddExpenses == false)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 10),
                          child: paymentSummaryCard(
                            netBalanceColor:
                            accountBloc.summaryData?.totalBalanceColor ??
                                '',
                            totalPaymentColor:
                            accountBloc.summaryData?.totalPaymentColor ??
                                '',
                            totalExpensesColor:
                            accountBloc.summaryData?.totalExpensesColor ??
                                '',
                            netBalance:
                            accountBloc.summaryData?.totalBalance ?? '',
                            totalPayment:
                            accountBloc.summaryData?.totalPayment ?? '',
                            totalExpenses:
                            accountBloc.summaryData?.totalExpenses ?? '',
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (widget.isComeFromAddExpenses == false)
                        suspenseHistory(),
                      if (widget.isComeFromAddExpenses == false)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15),
                          child: Row(
                            children: [
                              const Expanded(child: Divider(thickness: 0)),
                              const SizedBox(width: 6),
                              Text(
                                AppString.history,
                                style: appTextStyle.appSubTitleStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Expanded(child: Divider(thickness: 0)),
                            ],
                          ),
                        ),
                      accountBloc.historyData.isEmpty
                          ? SizedBox(
                        height: MediaQuery.of(context).size.height / 2.3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppString.noData,
                                style: appStyles.noDataTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding:  EdgeInsets.only(top: widget.isComeFromAddExpenses?0:8),
                        itemCount: accountBloc.historyData.length,
                        itemBuilder: (context, index) {
                          return paymentHistoryCard(
                            title: accountBloc.historyData[index].title ?? '',
                            description: accountBloc.historyData[index].description ?? '',
                            amount: accountBloc.historyData[index].amount ?? '',
                            type:accountBloc.historyData[index].type ?? '',
                            date: accountBloc.historyData[index].date ?? '',
                            subTitle: accountBloc.historyData[index].subTitle ?? '',
                            table: accountBloc.historyData[index].table ?? '',
                            voucherNumber: accountBloc.historyData[index].voucherNumber ?? '',
                            paymentMode: accountBloc.historyData[index].paymentMode ?? '',
                            onTap: () {
                              Navigator.push(
                                context,
                                SlideLeftRoute(
                                  widget: PaymentHistoryDetailScreen(
                                    id: accountBloc
                                        .historyData[index].id ??
                                        0,
                                    title: accountBloc
                                        .historyData[index].title ??
                                        '',
                                    date: accountBloc
                                        .historyData[index].date ??
                                        '',
                                    tableName: accountBloc
                                        .historyData[index].table ??
                                        '',
                                    isComingFromAccount: true,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 65),
                    ],
                  ),

                ),
                if (state is PrintStatementLoadingState)
                  WorkplaceWidgets.progressLoader(context),
                NetworkStatusAlertView(
                  onReconnect: () {
                    _onRefresh();
                  },
                )
              ],
            );
          },
        ),
      ),
      bottomMenuView: widget.isComeFromAddExpenses ? bottomViewForAddExpenses() : bottomViewForAccount(),
    );
  }
}


