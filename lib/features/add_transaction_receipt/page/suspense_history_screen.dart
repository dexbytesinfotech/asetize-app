import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/features/add_transaction_receipt/page/suspense_entry_screen.dart';
import 'package:asetize/features/add_transaction_receipt/page/suspense_history_detail_screen.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../app_global_components/common_floating_add_button.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/app_style.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/workplace_icon.dart';
import '../../../imports.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import '../bloc/add_transaction_receipt_bloc.dart';
import '../bloc/add_transaction_receipt_event.dart';
import '../bloc/add_transaction_receipt_state.dart';
import 'add_transaction_form.dart';

class SuspenseHistoryScreen extends StatefulWidget {
  final bool isShowLoader;
  const SuspenseHistoryScreen({super.key, this.isShowLoader = true});

  @override
  SuspenseHistoryScreenState createState() => SuspenseHistoryScreenState();
}

class SuspenseHistoryScreenState extends State<SuspenseHistoryScreen> {
  bool isButtonClicked = false;
  bool isLoader = true;
  String? selectedVehicleType;
  String? selectedVehicleNumber;
  int? selectedVehicleIndex;
  late AddTransactionReceiptBloc addTransactionReceiptBloc;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
  void initState() {

    isLoader= widget.isShowLoader;
    addTransactionReceiptBloc = BlocProvider.of<AddTransactionReceiptBloc>(context);

    if (addTransactionReceiptBloc.suspenseHistory.isEmpty || widget.isShowLoader == false) {
      addTransactionReceiptBloc.add(OnSuspenseHistoryEvent(mContext: context,));
    }
    super.initState();
  }

  void _onRefresh() async {
    isLoader = false;
    addTransactionReceiptBloc.add(OnSuspenseHistoryEvent(mContext: context,));
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CommonCardView(
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
                  Text(
                    title,
                    style: appTextStyle.appTitleStyle(),
                  ),
                  Text(
                    amount,
                    style: appTextStyle.appTitleStyle(
                      color: type.toLowerCase() == "credited" ? AppColors.appGreen : AppColors.red,),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              subTitle.isNotEmpty ? Row(
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
              ) :const SizedBox(height: 0,),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      description.trim(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle.appSubTitleStyle(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w400,),
                  ),
                  Row(
                    children: [
                      Text(
                        type,
                        style: appTextStyle.appSubTitleStyle(),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
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
                      )
                    ],
                  )
                ],
              ),
            ],
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
        isFixedDeviceHeight: false,
        isListScrollingNeed: true,
        isOverLayStatusBar: false,
        bottomSafeArea: true,
        appBarHeight: 56,
        appBar: const CommonAppBar(
          title: AppString.suspensePaymentsAppbar,
          icon: WorkplaceIcons.backArrow,
        ),
        containChild: BlocListener<AddTransactionReceiptBloc, AddTransactionReceiptState>(
          bloc: addTransactionReceiptBloc,
          listener: (context, state) {
            if (state is SuspenseHistoryErrorState) {

              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
            if (state is SuspenseHistoryDoneState) {
              // Handle success state if needed
            }
          },
          child: BlocBuilder<AddTransactionReceiptBloc, AddTransactionReceiptState>(
            builder: (context, state) {
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: _onRefresh,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0).copyWith(top: 0),
                        child: Column(
                          children: [
                            addTransactionReceiptBloc.suspenseHistory.isEmpty && state is! SuspenseHistoryLoadingState
                                ? SizedBox(
                              height: MediaQuery.of(context).size.height / 1.2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppString.noSuspenseHistoryFound,
                                      style: appStyles.noDataTextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 8),
                              itemCount: addTransactionReceiptBloc.suspenseHistory.length,
                              itemBuilder: (context, index) {
                                return paymentHistoryCard(
                                  title: addTransactionReceiptBloc.suspenseHistory[index].title ?? '',
                                  description: addTransactionReceiptBloc.suspenseHistory[index].description ?? '',
                                  amount: addTransactionReceiptBloc.suspenseHistory[index].amount ?? '',
                                  type: addTransactionReceiptBloc.suspenseHistory[index].type ?? '',
                                  date: addTransactionReceiptBloc.suspenseHistory[index].date ?? '',
                                  subTitle: addTransactionReceiptBloc.suspenseHistory[index].subTitle ?? '',
                                  table: addTransactionReceiptBloc.suspenseHistory[index].table ?? '',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                        widget: SuspenseHistoryDetailPage(
                                          receiptNumber: addTransactionReceiptBloc.suspenseHistory[index].subTitle ?? '',
                                          paymentDate: addTransactionReceiptBloc.suspenseHistory[index].date ?? '',
                                          amount: addTransactionReceiptBloc.suspenseHistory[index].amount ?? '',
                                          invoiceId: addTransactionReceiptBloc.suspenseHistory[index].id ?? 0,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        isLoader = false;
                                        addTransactionReceiptBloc.add(OnSuspenseHistoryEvent(mContext: context));
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state is SuspenseHistoryLoadingState && isLoader)
                      Center(
                        child: WorkplaceWidgets.progressLoader(context),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        bottomMenuView: CommonFloatingAddButton(onPressed: () {
          Navigator.push(
            MainAppBloc.getDashboardContext,
            SlideLeftRoute(
                widget:  const SuspiciousEntryScreen(
                )),
          ).then((value) {
            if (value != null && value == true) {
              _onRefresh();
            }
          });
          // photoPickerBottomSheet();
        })
    );
  }
}