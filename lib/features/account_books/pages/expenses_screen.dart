import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/features/account_books/pages/pay_out_screen.dart';
import 'package:asetize/features/account_books/pages/payment_history_detail_screen.dart';
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

class ExpensesScreen extends StatefulWidget {
  final bool isComeFromAddExpenses;
  const ExpensesScreen({super.key, this.isComeFromAddExpenses = false});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> with SingleTickerProviderStateMixin {
  late AccountBookBloc accountBloc;
  Houses? selectedUnit;
  final RefreshController refreshControllerApproved = RefreshController(initialRefresh: false);
  final RefreshController refreshControllerPending = RefreshController(initialRefresh: false);
  final ScrollController scrollControllerApproved = ScrollController();
  final ScrollController scrollControllerPending = ScrollController();
  bool isLoadMoreApproved = false;
  bool isLoading = true;
  bool isLoadMorePending = false;
  bool isInitialLoadingApproved = true;
  bool isInitialLoadingPending = true;
  String? selectedPaymentType = 'All'; // Default to 'All'
  late TabController tabController;
  int tabInitialIndex = 0;
  List<dynamic> approvedData = [];
  List<dynamic> pendingData = [];
  int? selectedExpenseId;


  void isShowLoader(){
    if (accountBloc.approvedHistoryData.isNotEmpty ||accountBloc.pendingHistoryData.isNotEmpty  ){
      isLoading= false;
    }


  }
  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    tabController = TabController(length: 2, vsync: this);
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
    // isShowLoader();
    // Fetch initial data for both tabs
    _fetchInitialData('approved');
    _fetchInitialData('pending');
    accountBloc.add(FetchExpensesCategoryEvent(mContext: context));
    accountBloc.add(FetchPaymentMethodEvent(mContext: context));
    scrollControllerApproved.addListener(() => _onScroll('approved'));
    scrollControllerPending.addListener(() => _onScroll('pending'));
  }





  void _fetchInitialData(String tab) {
    accountBloc.add(FetchAccountBookHistoryEvent(
      mContext: context,
      filterName: accountBloc.filterName,
      startDate: accountBloc.selectedStartDate,
      endDate: accountBloc.selectedEndDate,
      paymentType: widget.isComeFromAddExpenses ? 'debit' : accountBloc.paymentType,
      isVerified: tab == 'approved' ? '1' : '0',
    ));
  }

  void _onRefresh(String tab) async {
    if (tab == 'approved') {
      isLoading = false;
      isInitialLoadingApproved = true;
    } else {
      isLoading = false;
      isInitialLoadingPending = true;
    }

    _fetchInitialData(tab);
    await Future.delayed(const Duration(milliseconds: 100));
    if (tab == 'approved') {
      refreshControllerApproved.refreshCompleted();
    } else {
      refreshControllerPending.refreshCompleted();
    }
  }

  void _onLoading(String tab) async {
    bool pageEnded = tab == 'approved' ? accountBloc.getApprovedPostPageEnded : accountBloc.getPendingPostPageEnded;
    bool isLoadMore = tab == 'approved' ? isLoadMoreApproved : isLoadMorePending;
    if (!pageEnded && !isLoadMore) {
      accountBloc.add(FetchAccountBookHistoryOnLoadEvent(
        mContext: context,
        filterName: accountBloc.filterName,
        startDate: accountBloc.selectedStartDate,
        endDate: accountBloc.selectedEndDate,
        paymentType: widget.isComeFromAddExpenses ? 'debit' : accountBloc.paymentType,
        isVerified: tab == 'approved' ? '1' : '0',
      ));
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    if (tab == 'approved') {
      refreshControllerApproved.loadComplete();
    } else {
      refreshControllerPending.loadComplete();
    }
  }

  void _onScroll(String tab) {
    final controller = tab == 'approved' ? scrollControllerApproved : scrollControllerPending;
    if (controller.hasClients) {
      final maxScroll = controller.position.maxScrollExtent;
      final currentScroll = controller.position.pixels;
      final triggerScroll = maxScroll * 0.5; // 50% of scrollable area
      if (currentScroll >= triggerScroll) {
        _onLoading(tab);
      }
    }
  }

  void clearFilter() {
    accountBloc.filterName = 'current_month'; // Default
    accountBloc.selectedFilterName = 'Current month';
    accountBloc.startDate = null;
    accountBloc.endDate = null;
    accountBloc.selectedStartDate = '';
    accountBloc.selectedEndDate = '';
  }

  @override
  void dispose() {
    refreshControllerApproved.dispose();
    refreshControllerPending.dispose();
    scrollControllerApproved.removeListener(() => _onScroll('approved'));
    scrollControllerPending.removeListener(() => _onScroll('pending'));
    scrollControllerApproved.dispose();
    scrollControllerPending.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void deleteExpense(BuildContext context, int expenseId) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return WorkplaceWidgets.titleContentPopup(
            buttonName1: AppString.cancel,
            buttonName2: AppString.delete,
            onPressedButton1TextColor: AppColors.black,
            onPressedButton2TextColor: AppColors.white,
            onPressedButton1Color: Colors.grey.shade200,
            onPressedButton2Color: Colors.red,
            onPressedButton1: () {
              Navigator.pop(context);
            },
            onPressedButton2: () async {
              accountBloc.add(OnDeleteExpenseEvent(id: expenseId));
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            title: AppString.deleteExpenseTitle,
            content:  AppString.deleteExpenseContent,
          );
        },
      );
    }

    Widget paymentHistoryCard({
      required String title,
      required String description,
      required String subTitle,
      required String table,
      required String amount,
      required String type,
      required String date,
      required Function()? onTap,
      required bool isPending,
      required int id,
      required String voucherNumber,   // ✅ New field
      required String paymentMode,     // ✅ New field
    }) {
      return InkWell(
        onLongPress: isPending
            ? () {
          showCupertinoModalPopup(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                title: const Text(
                  AppString.chooseAnOption,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PayOutScreen(
                            expenseId: id,
                            isEditMode: true,
                          ),
                        ),
                      ).then((value) {
                        if (value == true) {
                          _onRefresh('pending');
                        }
                      });
                      setState(() {
                        selectedExpenseId = null;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WorkplaceIcons.iconImage(
                          imageUrl: WorkplaceIcons.editIcon,
                          imageColor: AppColors.black,
                          iconSize: const Size(25, 25),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Edit Expense',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      deleteExpense(context, id);
                      setState(() {
                        selectedExpenseId = null;
                      });
                    },
                    isDestructiveAction: true,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.delete,
                          size: 20,
                          color: CupertinoColors.destructiveRed,
                        ),
                        SizedBox(width: 10),
                        Text(
                          AppString.delete,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      selectedExpenseId = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    AppString.cancel,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          );
          setState(() {
            selectedExpenseId = id;
          });
        }
            : null,
        onTap: onTap,
        child: CommonCardView(
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ✅ Title + Amount
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

                const SizedBox(height: 6),

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

                // ✅ Subtitle
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
                    : const SizedBox(),

                // const SizedBox(height: 4),

                // ✅ Description
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Flexible(
                //       child: Text(
                //         description.trim(),
                //         maxLines: 3,
                //         overflow: TextOverflow.ellipsis,
                //         style: appTextStyle.appSubTitleStyle(),
                //       ),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: 10),

                // ✅ Date + Transaction Type
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


    Widget bottomViewForAddExpenses() {
      return CommonFloatingAddButton(
        onPressed: () {
          Navigator.push(
            context,
            SlideLeftRoute(widget: const PayOutScreen()),
          ).then((value) {
            if (value == true) {
              _onRefresh('approved');
              if (AppPermission.instance.canPermission(AppString.expenseAction, context: context)) {
                _onRefresh('pending');
              }
            }
          });
        },
      );
    }

    Widget historyListView(List<dynamic> data, ScrollController controller, RefreshController refreshController, String tab) {
      return SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: tab == 'approved' ? !accountBloc.getApprovedPostPageEnded : !accountBloc.getPendingPostPageEnded,
        onRefresh: () => _onRefresh(tab),
        onLoading: () => _onLoading(tab),
        footer: const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          padding: EdgeInsets.only(top: widget.isComeFromAddExpenses ? 0 : 8),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return paymentHistoryCard(
              title: data[index].title ?? '',
              description: data[index].description ?? '',
              amount: data[index].amount ?? '',
              type: data[index].type ?? '',
              date: data[index].date ?? '',
              subTitle: data[index].subTitle ?? '',
              table: data[index].table ?? '',
              id: data[index].id ?? 0,
              voucherNumber: data[index].voucherNumber ?? '' ,
              paymentMode: data[index].paymentMode ?? '' ,
              isPending: tab == 'pending',
              onTap: () {
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    widget: PaymentHistoryDetailScreen(
                      id: data[index].id ?? 0,
                      title: data[index].title ?? '',
                      date: data[index].date ?? '',
                      tableName: data[index].table ?? '',
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    _onRefresh('approved');
                    if (AppPermission.instance.canPermission(AppString.expenseAction, context: context)) {
                      _onRefresh('pending');
                    }
                  }
                });
              },
            );
          },
        ),
      );
    }

    // Check permission for accountPayOut
    bool hasAccountPayOutPermission = AppPermission.instance.canPermission(AppString.expenseAction, context: context);

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: CommonAppBar(
        title: widget.isComeFromAddExpenses ? AppString.expensesList : AppString.accountBooks,
        icon: WorkplaceIcons.backArrow,
        isHideBorderLine: true,
      ),
      containChild: BlocListener<AccountBookBloc, AccountBookState>(
        bloc: accountBloc,
        listener: (BuildContext context, AccountBookState state) {
          if (state is AccountBookErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }

          if (state is DeleteExpenseErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
        if (state is DeleteExpenseDoneState) {
          WorkplaceWidgets.successToast(state.message,
                    durationInSeconds: 1);
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
          if (state is AddExpensesDoneState) {
            _onRefresh('approved');
            if (hasAccountPayOutPermission) {
              _onRefresh('pending');
            }
          }
          if (state is AccountBookOnLoadLoadingState) {
            setState(() {
              if (state.isVerified == '1') {
                isLoadMoreApproved = true;
              } else if (state.isVerified == '0' && hasAccountPayOutPermission) {
                isLoadMorePending = true;
              }
            });
          }
          if (state is FetchAccountBookHistoryDoneState) {
            setState(() {
              if (state.isVerified == '1') {
                approvedData = List.from(accountBloc.approvedHistoryData);
                isLoadMoreApproved = false;
                isInitialLoadingApproved = false;
              } else if (state.isVerified == '0' && hasAccountPayOutPermission) {
                pendingData = List.from(accountBloc.pendingHistoryData);
                isLoadMorePending = false;
                isInitialLoadingPending = false;
              }
            });
          }
          if (state is DeleteExpenseDoneState) {
            _onRefresh('pending');
          }
        },
        child: BlocBuilder<AccountBookBloc, AccountBookState>(
          bloc: accountBloc,
          builder: (BuildContext context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    if (hasAccountPayOutPermission) ...[
                      // Show TabBar if permission is granted
                      Container(
                        color: const Color(0xFFF5F5F5),
                        child: TabBar(
                          onTap: (int index) {
                            setState(() {
                              tabInitialIndex = index;
                            });
                          },
                          dividerColor: Colors.grey.withOpacity(0.2),
                          labelColor: AppColors.textBlueColor,
                          labelPadding: const EdgeInsets.only(bottom: 10),
                          indicatorColor: AppColors.textBlueColor,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 4,
                          unselectedLabelColor: AppColors.greyUnselected,
                          controller: tabController,
                          tabs: [
                            Text(
                              'Pending',
                              style: appStyles.tabTextStyle(),
                            ),
                            Text(
                              'Approved',
                              style: appStyles.tabTextStyle(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
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
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              ),
                              builder: (ctx) => StatefulBuilder(
                                builder: (ctx, state) => FractionallySizedBox(
                                  heightFactor: MediaQuery.of(ctx).size.height < 600 ? 0.65 : 0.62,
                                  child: FilterBottomSheet(
                                    filterType: "time_based",
                                    selectedFilterOption: accountBloc.selectedFilterName,
                                    selectedPaymentType: accountBloc.selectedPaymentType,
                                    startDate: accountBloc.startDate,
                                    endDate: accountBloc.endDate,
                                    isComeFromAddExpenses: widget.isComeFromAddExpenses,
                                  ),
                                ),
                              ),
                            ).then((value) {
                              setState(() {
                                _onRefresh('approved');
                                if (hasAccountPayOutPermission) {
                                  _onRefresh('pending');
                                }
                              });
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5, bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                                const Icon(Icons.filter_list, size: 16, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (!widget.isComeFromAddExpenses) // Hide payment type filter when isComeFromAddExpenses is true
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: MainAppBloc.getDashboardContext,
                                isDismissible: false,
                                enableDrag: true,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                ),
                                builder: (ctx) => StatefulBuilder(
                                  builder: (ctx, state) => FractionallySizedBox(
                                    heightFactor: 0.42,
                                    child: FilterBottomSheet(
                                      filterType: "payment_type",
                                      isComeFromAddExpenses: widget.isComeFromAddExpenses,
                                      selectedFilterOption: accountBloc.selectedFilterName,
                                      selectedPaymentType: accountBloc.selectedPaymentType,
                                      startDate: accountBloc.startDate,
                                      endDate: accountBloc.endDate,
                                    ),
                                  ),
                                ),
                              ).then((value) {
                                setState(() {
                                  _onRefresh('approved');
                                  if (hasAccountPayOutPermission) {
                                    _onRefresh('pending');
                                  }
                                });
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10, bottom: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                                  const Icon(Icons.filter_list, size: 16, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    Expanded(
                      child: hasAccountPayOutPermission
                          ? TabBarView(
                        controller: tabController,
                        children: [
                          // Pending Tab
                          isInitialLoadingPending && isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : pendingData.isEmpty
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
                              : historyListView(pendingData, scrollControllerPending, refreshControllerPending, 'pending'),
                          // Approved Tab
                          isInitialLoadingApproved && isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : approvedData.isEmpty
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
                              : historyListView(approvedData, scrollControllerApproved, refreshControllerApproved, 'approved'),
                        ],
                      )
                          : // Show only Approved data without TabBar
                      isInitialLoadingApproved && isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : approvedData.isEmpty
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
                          : historyListView(approvedData, scrollControllerApproved, refreshControllerApproved, 'approved'),
                    ),
                  ],
                ),
                if (state is PrintStatementLoadingState || state is DeleteExpenseLoadingState)
                  WorkplaceWidgets.progressLoader(context),
                NetworkStatusAlertView(
                  onReconnect: () {
                    _onRefresh('approved');
                    if (hasAccountPayOutPermission) {
                      _onRefresh('pending');
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
      bottomMenuView: bottomViewForAddExpenses(),
    );
  }
}