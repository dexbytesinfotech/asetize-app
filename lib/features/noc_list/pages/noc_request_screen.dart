import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../bloc/noc_request_bloc.dart';
import '../bloc/noc_request_event.dart';
import '../bloc/noc_request_state.dart';
import '../widgets/noc_request_card.dart';
import 'noc_request_detail_screen.dart';

class NocRequestScreen extends StatefulWidget {
  const NocRequestScreen({super.key});
  @override
  State<NocRequestScreen> createState() => _NocRequestScreenState();
}

class _NocRequestScreenState extends State<NocRequestScreen> {
  bool isLoader = true;
  late NocRequestBloc nocRequestBloc;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    nocRequestBloc = BlocProvider.of<NocRequestBloc>(context);
    // nocRequestBloc.nocRequestData.clear();
    if ( nocRequestBloc.nocRequestData.isNotEmpty){
      nocRequestBloc.add(OnGetNocListEvent(mContext: context,));
      isLoader= false;
    } else {
      nocRequestBloc.add(OnGetNocListEvent(mContext: context,));
    }

    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }

  Future<void> refreshDataOnNotificationComes() async {
    _onRefresh();
  }


  void _onRefresh() async {
    isLoader = false;
    nocRequestBloc.add(OnGetNocListEvent(mContext: context,));
    await Future.delayed(const Duration(milliseconds: 100));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {

    Widget nocRequestedList (){
      return ListView.builder(
        shrinkWrap: true,
        reverse: false,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 0),
        itemCount:  nocRequestBloc.nocRequestData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 0,right: 0,top: 0,bottom: 0),
            child: SocietyNocCard(
              name: nocRequestBloc.nocRequestData[index].requester ?? '',
              title:nocRequestBloc.nocRequestData[index].title ?? '',
              status: (nocRequestBloc.nocRequestData[index].status ?? '')
                  .replaceAll('_', ' ')
                  .replaceFirstMapped(RegExp(r'^\w'), (match) => match.group(0)!.toUpperCase()),
              description:nocRequestBloc.nocRequestData[index].description ?? '',
              date: nocRequestBloc.nocRequestData[index].createdAt ?? '',
              onTap: (){
                Navigator.push(
                  context,
                  SlideLeftRoute(
                      widget:  NocRequestDetailScreen(nocRequestData:nocRequestBloc.nocRequestData[index])
                  ),
                ).then((value) {
                  if (value == true) {
                    isLoader = false;
                    _onRefresh();
                  }
                });
              },
            ),
          );
        },
      );
    }

    Widget noNOCRequestFound(){
      return SizedBox(
        height: MediaQuery.of(context).size.height / 1.4,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppString.noNocRequestFound,
                style: appStyles.noDataTextStyle(),
              ),
            ],
          ),
        ),
      );
    }
    return ContainerFirst(
      contextCurrentView: context,
      resizeToAvoidBottomInset: false,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar:  const CommonAppBar(
        title: AppString.nocRequest,
        icon: WorkplaceIcons.backArrow,
        isThen: false,
      ),
      containChild:BlocListener<NocRequestBloc, NocRequestState>(
        bloc: nocRequestBloc,
        listener: (context, state) {
          if (state is NocRequestInitialState) {
            nocRequestBloc.add(OnGetNocListEvent(mContext: context,)); }
          if (state is NocRequestListErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);

          }
          if (state is NocRequestListDoneState) {
          }
        },
        child: BlocBuilder<NocRequestBloc, NocRequestState>(
          bloc: nocRequestBloc,
          builder: (context, state) {
            return Stack(
              children: [
              SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _onRefresh,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0).copyWith(top: 5,left: 0,right: 0),
                      child: Column(
                        children: [
                          nocRequestBloc.nocRequestData.isEmpty && state is! NocRequestLoadingState
                              ? noNOCRequestFound()
                              : nocRequestedList()
                        ],
                      ),
                    ),
                  ),
                  if (state is NocRequestLoadingState && isLoader)
                    Center(
                      child: WorkplaceWidgets.progressLoader(context),
                    ),
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
      ),

    );
  }
}
