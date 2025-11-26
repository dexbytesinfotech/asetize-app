import 'package:share_handler/share_handler.dart';
import 'package:asetize/imports.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../add_transaction_receipt/page/added_text_with_shared_image.dart';
import '../../complaints/bloc/house_block_bloc/house_block_bloc.dart';
import '../../complaints/bloc/house_block_bloc/house_block_event.dart';
import '../../member/bloc/team_member/team_member_bloc.dart';
import '../../new_sign_up/pages/new_login_with_email_screen.dart';
import '../../notificaion/bloc/notification_bloc/app_notification_bloc.dart';
import '../../notificaion/bloc/notification_bloc/app_notification_event.dart';
import '../../upgrader_widget/upgrader_widget.dart';
import '../widgets/app_update_alert_dialog.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  State createState() => _DashBoardPage();
}

class _DashBoardPage extends State<DashBoardPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late HouseBlockBloc houseBlockBloc;
  late MainAppBloc mainAppBloc;

  SharedMedia? media;
  ScrollController scrollController = ScrollController();
  double bottomMenuHeight2 = 50;
  final PageStorageBucket _bucket = PageStorageBucket();

  Color statusBarColors = const Color(0xff212327);
  late UserProfileBloc userProfileBloc;

  //Current index
  TabItemBottomNavigatorWithStack _currentTab =
      TabItemBottomNavigatorWithStack.menu1;

  //Get selected menu
  Widget buildOffstageNavigator(TabItemBottomNavigatorWithStack tabItem,
      {item}) {
    return Offstage(
        offstage: _currentTab != tabItem,
        child: AppNavigator(
          navigatorKey: _navigatorKeys[tabItem]!,
          tabItem: tabItem,
          item: item,
        ));
  }

  Future<void> initPlatformState() async {
    // Check if permissions are granted for both accountBookList and accountPaymentAdd
    // bool isAccountBookListPermissionGranted = await AppPermission.instance
    //     .canPermission(AppString.accountBookList, context: context);
    //
    // bool isAccountPaymentAddPermissionGranted = await AppPermission.instance
    //     .canPermission(AppString.accountPaymentAdd, context: context);
    //
    // // If both permissions are granted, don't execute the function
    // if (isAccountBookListPermissionGranted || isAccountPaymentAddPermissionGranted) {
    //   return;
    // }

    final handler = ShareHandlerPlatform.instance;

    // Fetch initial shared media during app cold start
    media = await handler.getInitialSharedMedia();

    if (media != null && media!.attachments != null && media!.attachments!.isNotEmpty) {
      final imagePath = media!.attachments!.first!.path ?? '';
      // Navigate to the target screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          MainAppBloc.getDashboardContext,
          SlideLeftRoute(
            widget: AddedTextWithSharedImage(
              title: 'Transaction Receipt',
              imagePath: imagePath,
            ),
          ),
        );
      });
    }

    // Listen for new shared media when the app is running
    handler.sharedMediaStream.listen((SharedMedia newMedia) {
      if (!mounted) return;
      setState(() {
        media = newMedia;
      });
      final imagePath = newMedia.attachments?.first?.path ?? '';
      Navigator.push(
        context,
        SlideLeftRoute(
          widget:AddedTextWithSharedImage(
            title: 'Transaction Receipt',
            imagePath: imagePath,
          ),
        ),
      );
    });

    if (!mounted) return;
  }

  // WidgetsBinding.instance.addPostFrameCallback((_) async {
  // await initPlatformState();
  // });



  //Add Menu navigation key according to added menu
  final Map<TabItemBottomNavigatorWithStack, GlobalKey<NavigatorState>>
  _navigatorKeys = {
    TabItemBottomNavigatorWithStack.menu1: GlobalKey<NavigatorState>(),
    TabItemBottomNavigatorWithStack.menu2: GlobalKey<NavigatorState>(),
    TabItemBottomNavigatorWithStack.menu3: GlobalKey<NavigatorState>(),
    TabItemBottomNavigatorWithStack.menu4: GlobalKey<NavigatorState>(),
    TabItemBottomNavigatorWithStack.menu5: GlobalKey<NavigatorState>(),
  };
// GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey();
  GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    MainAppBloc.dashboardContext = context;
    OneSignalNotificationsHandler.instance.setAppContext(MainAppBloc.getDashboardContext);
    houseBlockBloc = BlocProvider.of<HouseBlockBloc>(context);
    houseBlockBloc.add(FetchHouseBlockEvent(mContext: context));
    mainAppBloc = BlocProvider.of<MainAppBloc>(context);
    mainAppBloc.add(OnGetBrokerListEvent(mContext: context));

    /// Call API to get Notification Count
    BlocProvider.of<AppNotificationBloc>(context).add(OnGetNotificationCountEvent(mContext:  MainAppBloc.dashboardContext));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initPlatformState();
    });

    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

    BlocProvider.of<TeamMemberBloc>(context).add(FetchTeamList(mContext: context));

    if (ApiConst.isProduction == true) {
      /// Update app by new release version on google play store
      AppUpdateChecker().checkVersion(context);
    }
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {

    _pageController.dispose();
    super.dispose();
  }

  /// Update app by new release version on google play store
  // void checkVersion({bool? isRefreshing = false}) async {
  //   _checker.checkUpdate().then((value) {
  //     debugPrint('${{value.canUpdate}}'); //return true if update is available
  //     debugPrint(value.currentVersion); //return current app version
  //     debugPrint(value.newVersion); //return the new app version
  //     debugPrint(value.appURL); //return the app url
  //     debugPrint(value
  //         .errorMessage); //return error message if found else it will return null
  //     if (value.canUpdate) {
  //       if (isRefreshing!) {
  //         Navigator.of(context).pop();
  //       }
  //       Navigator.of(context).push(DialogRoute(
  //         barrierDismissible: false,
  //         builder: (context) => AppUpdateAlertDialog(
  //             contextOfPopUp: context,
  //             updatedAppUrl: value.appURL,
  //             onAfterUpdate: () {
  //               checkVersion(isRefreshing: true);
  //             }),
  //         context: context,
  //       ));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    MainAppBloc.dashboardContext = context;
    return BlocConsumer<WorkplaceNetworkBloc, WorkplaceNetworkState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocBuilder<MainAppBloc, MainAppState>(
            builder: (_, mainAppState) {
              Color statusBarColorsLocal = statusBarColors;
              if (mainAppState is HomeBottomNavigationBarTapedState) {
                statusBarColorsLocal = mainAppState.statusBarColor != null
                    ? projectUtil.colorFromIntString(
                    stringColor: mainAppState.statusBarColor!)
                    : statusBarColors;
              }

          if (mainAppState is MainLogoutUser) {
            Navigator.of(context).pushAndRemoveUntil(
                SlideLeftRoute(widget:  NewLoginWithEmail()),
                (route) => false);
          }

          if (mainAppState is BottomMenuShowHideState) {
            bottomMenuHeight2 = mainAppState.isMenuShow ? 50 : -1;
            scrollController = mainAppState.scrollController!;
          }
         return UpgradeWidget(
           child: ContainerDashboard(
                contextCurrentView: context,
                isOverLayStatusBar: true,
                statusBarColor: statusBarColorsLocal,
                appBarHeight: -1,
                bottomMenuHeight: bottomMenuHeight2,
                bottomMenuView: AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, child) {
                  return AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 950),
                    height: bottomMenuHeight2,
                    child: child,
                  );
                },
                child: bottomMenu()),
                appBar: Container(
                  color: statusBarColorsLocal,
                ),
                containChild: Stack(
                  children: [
                    BlocBuilder<MainAppBloc, MainAppState>(
                      // ignore: non_constant_identifier_names
                        builder: (_, mainAppState) {
                          if (mainAppState
                          is HomeBottomNavigationBarTapedState) {}
                          return Stack(children: <Widget>[
                            buildOffstageNavigator(TabItemBottomNavigatorWithStack.menu1,
                                item: () {
                                  globalScaffoldKey.currentState?.openDrawer();
                                }),
                            buildOffstageNavigator(
                                TabItemBottomNavigatorWithStack.menu2),
                            buildOffstageNavigator(
                                TabItemBottomNavigatorWithStack.menu3),
                            buildOffstageNavigator(
                                TabItemBottomNavigatorWithStack.menu4),
                            buildOffstageNavigator(
                                TabItemBottomNavigatorWithStack.menu5),
                          ]);
                        }),
                    const NetworkStatusAlertView(),
                  ],
                )),
         );
        });
      },
    );
  }

  Widget bottomMenu(){
    return BlocBuilder<UserProfileBloc, UserProfileState>(
        bloc: userProfileBloc,
        builder: (context, state) {
          if (state is UserProfileFetched) {}

          return BottomNavigatorWithStack(
            currentTab: _currentTab,
            onSelectTab: selectTab,menuHeight: bottomMenuHeight2,
          );
        }

    );
  }

  //Selected bottom menu index
  void selectTab(TapedItemModel capedItemModel) {
    TabItemBottomNavigatorWithStack tabItem =
        capedItemModel.tabItemBottomNavigatorWithStack;

    try {
      statusBarColors = Color(int.parse(capedItemModel.statusBarColor!));
    } catch (e) {
      debugPrint("$e");
    }
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }
}
