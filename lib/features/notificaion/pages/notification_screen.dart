import 'package:asetize/app_global_components/notification_permission_status_view.dart';
import 'package:asetize/core/util/app_navigator/app_navigator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../bloc/notification_bloc/app_notification_bloc.dart';
import '../bloc/notification_bloc/app_notification_event.dart';
import '../bloc/notification_bloc/app_notification_state.dart';

class NotificationScreen extends StatefulWidget {
  final String mobileNumber;

  const NotificationScreen({Key? key, this.mobileNumber = "9171579456"})
      : super(key: key);
  @override
  State createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  late AppNotificationBloc appNotificationBloc;
  int activeIndex = 0;
  bool isShowLoader = false;

  @override
  void initState() {
    projectUtil.removeBadge();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appNotificationBloc = BlocProvider.of<AppNotificationBloc>(context);
          appNotificationBloc.add(const OnNotificationStatusChangeEvent(enabledState: true));
          appNotificationBloc.add(GetAppNotificationListEvent(mContext: context));


    /// Check notification enabled permission and call API to get notification data
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }

  Future<void> refreshDataOnNotificationComes() async {
    _onRefresh();
  }

  void _onRefresh() async {
    isShowLoader = true;
    AppNotificationBloc appNotificationBloc = BlocProvider.of<AppNotificationBloc>(context);
    appNotificationBloc.add(GetAppNotificationListEvent(mContext: context));
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     // App is in the foreground
  //     _onAppForeground();
  //   }
  // }
  //
  // void _onAppForeground() {
  //   // Perform any actions when the app resumes from the background
  //   debugPrint("App resumed from background");
  //
  //   /// Check notification enabled permission and call API to get notification data
  // }

  @override
  Widget build(BuildContext context) {
    AppNotificationBloc appNotificationBloc =
    BlocProvider.of<AppNotificationBloc>(context);
    AppDimens appDimens = AppDimens();
    appDimens.appDimensFind(context: context);

    NotificationIcon notificationIconDetail(String type, category) {
      switch (type) {
        case 'post':
          return NotificationIcon(
              icon: WorkplaceIcons.postIcon,
              iconBgColor: AppColors.appPurpleAccent);

          case 'post_comment':
          return NotificationIcon(
              icon: WorkplaceIcons.postCommentIcon,
              iconBgColor: AppColors.appPurpleAccent);
        case 'expense':
          return NotificationIcon(
              icon: WorkplaceIcons.postCommentIcon,
              iconBgColor: AppColors.appPurpleAccent);

          case 'complaint':
          return NotificationIcon(

              icon: WorkplaceIcons.complaintIcon,
              iconBgColor: AppColors.red);

          case 'complaint_comment':
          return NotificationIcon(
              icon: WorkplaceIcons.postCommentIcon,
              iconBgColor: AppColors.appPurpleAccent);


          case 'payment':
          return NotificationIcon(
              icon: WorkplaceIcons.payment,
              iconBgColor: AppColors.yellow);

          case 'invoice':
          return NotificationIcon(
              icon: WorkplaceIcons.invoice,
              iconBgColor: AppColors.appBlueColor);

          case 'join_request':
          return NotificationIcon(
              icon: WorkplaceIcons.joinRequest,
              iconBgColor: AppColors.yellow);

        case 'announcement':
          return NotificationIcon(
              icon: WorkplaceIcons.announcementIcon,
              iconBgColor: AppColors.appPurpleAccent);

        default:
          return NotificationIcon(
              icon: WorkplaceIcons.notificationIcon,
              iconBgColor: AppColors.appAmber);
      }
    }

    Widget noDataView() {
      return Center(
          child: Text(
            AppString.noNotifications,
            style: appStyles.noDataTextStyle(),
          ));
    }

    Widget notificationPermissionRequired() {
      return Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Notification permission is required. Please enable it in the app settings.",
                    style: appStyles.noDataTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: 100,
                      child: AppButton(
                        buttonHeight: 45,
                        buttonName: "Request",
                        backCallback: () {
                          openAppSettings().then((result) {
                            debugPrint("");
                          });
                        },
                      )),
                ],
              )));
    }

    Widget notificationCard() => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: appNotificationBloc.notificationList.length,
        itemBuilder: (context, index) {
          NotificationIcon notificationIcon = notificationIconDetail(
              appNotificationBloc.notificationList[index].data?.type ?? "", "");

          return NotificationCardWidget(
            userName: appNotificationBloc.notificationList[index].title,
            message: appNotificationBloc.notificationList[index].body,
            timeAgo: appNotificationBloc.notificationList[index].sendAt,
            imageUrl: notificationIcon.icon,
            color: notificationIcon.iconBgColor,
            // postId: appNotificationBloc.notificationList[index].data!.postId,
            // leaveId: appNotificationBloc.notificationList[index].data!.leaveId,
            postType:
            appNotificationBloc.notificationList[index].data?.type ?? "",
            isRead: appNotificationBloc.notificationList[index].isRead,
            onClickPost: () {
              if (appNotificationBloc.notificationList[index].isRead == 0) {
                BlocProvider.of<AppNotificationBloc>(context)
                    .add(MarkNotificationReadEvent(
                  messageID: appNotificationBloc.notificationList[index].id)
                );
              }

              appNavigator.onTapNotification(context,appNotificationBloc.notificationList[index].data!.toJson());
            },
          );
        });

    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isListScrollingNeed: true,
        appBarHeight: 56,
        appBar: const CommonAppBar(
          title: AppString.notifications,
          icon: WorkplaceIcons.backArrow,
        ),
        containChild: BlocConsumer<AppNotificationBloc, AppNotificationState>(
          listener: (BuildContext context, AppNotificationState state) {},
          builder: (context, state) {
            // if (state is AppNotificationLoadingState) {
            //   if (isShowLoader == false) {
            //     return const Center(
            //                     child: CircularProgressIndicator(),
            //                   );
            //   }
            // }
            if (state is FetchAppNotificationDataState) {
              isShowLoader = false;
            }
            return RefreshIndicator(
              onRefresh: () async {
                _onRefresh();
              },
              child: Stack(
                children: [
                  Stack(
                    children: [
                      appNotificationBloc.notificationList.isEmpty ? noDataView()
                          : ListView(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          const NotificationPermissionStatusView(),
                          SizedBox(
                            height: 10.sp,
                          ),
                          notificationCard(),
                        ],
                      ),
                      if (state is AppNotificationLoadingState)
                        WorkplaceWidgets.progressLoader(context,
                            color: isShowLoader == true
                                ? Color(0xFFF5F5F5).safeOpacity(.4)
                                : Color(0xFFF5F5F5)
                        ),

                    ],
                  ),
                   NetworkStatusAlertView(onReconnect: (){
                     _onRefresh();
                  },)
                ],

              ),
            );
          },
        ));
  }

  /// Screen will redirect according to type
  void redirectToScreen(Widget singlePostScreen) {
    Navigator.of(MainAppBloc.getDashboardContext)
        .push(SlideLeftRoute(widget:singlePostScreen));
  }

  // void checkNotificationPermission() {
  //   /// Check and request for notification permission
  //   FirebaseNotifications.requestNotificationPermission().then((value) {
  //     if (value) {
  //       appNotificationBloc
  //           .add(const OnNotificationStatusChangeEvent(enabledState: true));
  //       appNotificationBloc.add(GetAppNotificationListEvent(mContext: context));
  //     } else {
  //       appNotificationBloc
  //           .add(const OnNotificationStatusChangeEvent(enabledState: false));
  //     }
  //   });
  // }

}

/// We will use it for set a property of single icon
class NotificationIcon {
  String? icon;
  Color? iconBgColor;
  NotificationIcon({this.icon, this.iconBgColor});
}
