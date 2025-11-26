import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/features/account_books/pages/payment_confirmation_screen.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../../add_transaction_receipt/bloc/add_transaction_receipt_state.dart';
import '../../add_transaction_receipt/page/add_transaction_form.dart';
import '../bloc/account_book_bloc.dart';
import '../bloc/account_book_event.dart';
import '../bloc/account_book_state.dart';

class PendingConfirmation extends StatefulWidget {
  final bool? isHomePendingConfirmation;
  const PendingConfirmation({super.key, this.isHomePendingConfirmation = true  });
  @override
  State<PendingConfirmation> createState() => _PendingConfirmationState();
}

class _PendingConfirmationState extends State<PendingConfirmation> {
  bool isShowLoader = true;
  bool isLoadMore = false;
  late UserProfileBloc userProfileBloc;
  final RefreshController refreshController =
  RefreshController(initialRefresh: false);
  final ScrollController scrollController = ScrollController();
  late AccountBookBloc accountBloc;

  void _onLoading() async {
    if (!accountBloc.getPostPageEnded && !isLoadMore) {
      accountBloc.add(GetListOfPandingReceiptsOnLoadEvent(mContext: context));
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    refreshController.loadComplete();
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

  void _onRefresh() async {
      isShowLoader = false;
    accountBloc.setPostPageEnded = false;
    accountBloc.add(GetPendingListEvent(mContext: context));
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    if (accountBloc.getPendingList.isNotEmpty){
      isShowLoader = false;
    }
    accountBloc.add(GetPendingListEvent(mContext: context));
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    scrollController.addListener(_onScroll);
    accountBloc.setPostPageEnded = false;
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }

  Future<void> refreshDataOnNotificationComes() async {
    _onRefresh();
  }

  @override
  void dispose() {
    refreshController.dispose();
    scrollController.removeListener(_onScroll);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    Widget buildPaymentHistoryCard({
      required String title,
      required String name,
      required String description,
      required String amount,
      required String paymentMethod,
      required String status,
      required String date,
      required bool duplicateEntry,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child:CommonCardView(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(projectUtil.capitalizeFullName(name),
                          style: appTextStyle.appTitleStyle2().copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        Text(", $title", style: appTextStyle.appTitleStyle2()),
                      ],
                    ),
                    Text(amount, style: appTextStyle.appTitleStyle2(color: AppColors.appGreen)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        description.trim(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: appTextStyle.appSubTitleStyle(),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(paymentMethod, style: appTextStyle.appTitleStyle()),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(date, style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.w400,color: Colors.grey.shade500)),
                    duplicateEntry?
                    const Icon(
                      Icons.warning,
                      color: Colors.amber,
                      size: 20.0, // Adjust the size as needed
                    ) : SizedBox()


                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget bottomFloatingActionButtonView(){
      return BlocBuilder<UserProfileBloc, UserProfileState>(
        bloc: userProfileBloc,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (AppPermission.instance
                  .canPermission(AppString.accountPaymentAdd, context: context) && widget.isHomePendingConfirmation!)

                Padding(
                  padding: const EdgeInsets.only(bottom: 25, right: 16),
                  child: SizedBox(
                    width: 130.0,
                    height: 60.0,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.textBlueColor,
                      foregroundColor: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            color: AppColors.textNormalColor,
                            size: 28,
                          ),
                          const SizedBox(width: 5),
                          Text(AppString.addPayment, style: appStyles.hStyle11()),
                          const SizedBox(width: 8),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          MainAppBloc.getDashboardContext,
                          SlideLeftRoute(
                              widget:
                              const AddTransactionForm(comeWithPermission: [AppString.accountPaymentAdd],)),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }


    Widget pendingConfirmationList(){
      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(top: 4),
        itemCount: accountBloc.getPendingList.length,
        itemBuilder: (context, index) {
          final item = accountBloc.getPendingList[index];
          return buildPaymentHistoryCard(
            title: item.title ?? '',
            description: item.description ?? '',
            amount: item.amount ?? '',
            name: item.shortDescription ?? '',
            paymentMethod: item.paymentMethod ?? '',
            status: item.status ?? '',
            date: item.createdAt ?? '',
            duplicateEntry: item.duplicateEntry ?? false,
            onTap: () {
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: PaymentConfirmation(
                    id: item.id ?? 0,
                    duplicateEntryMessage:item.duplicateEntryMessage ,
                    name: item.shortDescription ?? '',
                    selectUnit: item.title ?? '',
                    paymentMethod: item.paymentMethod ?? '',
                    amount: item.amount ?? '',
                    duplicateEntry:item.duplicateEntry ,
                    description: item.description ?? '',
                    imagePath: item.imagePath ?? '',
                    isHomePendingConfirmation: widget.isHomePendingConfirmation,
                  ),
                ),
              ).then((value) {
                if (value == true) {
                  isShowLoader = false;
                  accountBloc.add(GetPendingListEvent(mContext: context));
                }
              });
            },
          );
        },
      );
    }
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBarHeight: 50,
      appBar: const CommonAppBar(
        title: AppString.pendingConfirmation,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AccountBookBloc, AccountBookState>(
        bloc: accountBloc,
        listener: (context, state) {
          if (state is AccountBookErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is AddTransactionReceiptOnLoadingState) {
            setState(() {
              isLoadMore = true;
            });
          }
          if (state is GetPendingListDoneState) {
            setState(() {
              isLoadMore = false;
            });
          }
          if (state is AccountBookInitialState){
            accountBloc.add(GetListOfPandingReceiptsOnLoadEvent(mContext: context));
          }
        },
        child: BlocBuilder<AccountBookBloc, AccountBookState>(
          bloc: accountBloc,
          builder: (context, state) {
            if (state is AccountBookOnLoadLoadingState) {
              isLoadMore = true;
            }
            if (state is AccountBookLoadingState && isShowLoader){
              return  WorkplaceWidgets.progressLoader(context);
            }

            return Stack(
              children: [
                SmartRefresher(
                controller: refreshController,
                enablePullDown: true,
                enablePullUp: !accountBloc.getPostPageEnded,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
                child: accountBloc.getPendingList.isEmpty
                    ?  Center(child: Text(state is AccountBookLoadingState ? '' : AppString.noData, style: appStyles.noDataTextStyle()))
                    : pendingConfirmationList()
            ),
                NetworkStatusAlertView(onReconnect: (){
                  _onRefresh();
                },)

            ],
            );
          },
        ),
      ),
      bottomMenuView:  bottomFloatingActionButtonView()
    );
  }
}
