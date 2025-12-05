import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' hide RefreshIndicator;
import 'package:asetize/features/approval_pending_screen/pages/approval_pending_status_screen.dart';
import 'package:asetize/features/assets_management/pages/assets_list_screen.dart';
import 'package:asetize/widgets/common_card_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../app_global_components/unit_statement_card_widget.dart';
import '../../../core/network/api_base_helpers.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../../account_books/pages/add_new_payee_screen.dart';
import '../../add_transaction_receipt/page/add_transaction_form.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../add_vehicle_for_manager/pages/add_vehicle_for_manager_screen.dart';
import '../../assets_management/pages/my_asset_screen.dart';
import '../../booking/pages/amenities_selection_screen.dart';
import '../../commitee_member_tab/bloc/commitee_member_bloc.dart';
import '../../commitee_member_tab/bloc/commitee_member_event.dart';
import '../../complaints/bloc/house_block_bloc/house_block_bloc.dart';
import '../../complaints/bloc/house_block_bloc/house_block_event.dart';
import '../../complaints/pages/complaint_tabbar_screen.dart';
import '../../find_helper/bloc/find_helper_bloc.dart';
import '../../follow_up/bloc/follow_up_bloc.dart';
import '../../follow_up/bloc/follow_up_event.dart';
import '../../follow_up/pages/follow_up_list_screen.dart';
import '../../follow_up/pages/new_follow_up_list_screen.dart';
import '../../member/bloc/team_member/team_member_bloc.dart';
import '../../my_family/pages/my_family_screen.dart';
import '../../my_unit/bloc/my_unit_bloc.dart';
import '../../my_unit/pages/my_unit_new_screen.dart';
import '../../my_vehicle/bloc/my_vehicle_bloc.dart';
import '../../my_vehicle/bloc/my_vehicle_event.dart';
import '../../find_helper/pages/find_helper_screen.dart';
import '../../my_visitor/pages/today_my_visitor_list.dart';
import '../../noc_list/pages/noc_request_screen.dart';
import '../bloc/home_new_bloc.dart';
import '../bloc/home_new_event.dart';
import '../bloc/home_new_state.dart';
import '../widgets/common_residential_unit_card.dart';
import 'all_notice_screen.dart';
import 'notice_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserProfileBloc userProfileBloc;
  late AddVehicleManagerBloc addVehicleManagerBloc;
  late HomeNewBloc homeNewBloc;
  late HouseBlockBloc houseBlockBloc;
  late TeamMemberBloc teamMemberBloc;
  late CommitteeMemberBloc committeeMemberBloc;

  late MyUnitBloc myUnitBloc; late FollowUpBloc followUpBloc;

  bool isShowLoader = true;

  List<Map<String, dynamic>> cardItems = [];
  List<Companies>? companies = [];
  RefreshController refreshController1 =
      RefreshController(initialRefresh: false);
  bool isShowNotice = false;
  Map<String, dynamic> homeInfoMessages = {};
  Map<String, dynamic> versionUpdate = {};

  String currentVersion = '';
  String playStoreVersion = '';
  String appleStoreVersion = '';
  bool isUpdateAvailable = false;




  void onUnitSelect(Houses? house) {
    if (house != null) {
      userProfileBloc.add(OnChangeCurrentUnitEvent(selectedUnit: house));
      if (house.status == "active") {
        // myUnitBloc.add(FetchInvoiceSummaryEvent(
        //     houseId: house.id.toString(), mContext: context));
        myUnitBloc.add(FetchInvoiceStatementEvent(
            houseId: house.id.toString(), mContext: context));
        // myUnitBloc.add(FetchInvoiceTransactionEvent(
        //     houseId: house.id.toString(), mContext: context));

        // myUnitBloc.add(FetchMonthlySummaryEvent(houseId: house.id!, mContext: context, year: 2025));
      } else {
        myUnitBloc.add(OnReLoadMyUnitUiEvent(mContext: context));
      }
    }
  }

  @override
  void initState() {
    //Get data from system setting API response
    if (MainAppBloc.systemSettingData.containsKey('home_info_messages')) {
      var data = MainAppBloc.systemSettingData['home_info_messages'];

      if (data is Map) {
        homeInfoMessages = MainAppBloc.systemSettingData['home_info_messages'];
      } else if (data is List && data.isEmpty) {
        homeInfoMessages = {};
      } else {
        homeInfoMessages = {}; // Fallback in case of unexpected data type
      }
    } else {
      homeInfoMessages = {}; // If the key does not exist
    }
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    if (myUnitBloc.statementData.isEmpty ||
        (myUnitBloc.statementData.isNotEmpty &&
            myUnitBloc.statementData[0].houseId != null &&
            myUnitBloc.statementData[0].houseId! !=
                userProfileBloc.selectedUnit!.id)) {
      onUnitSelect(userProfileBloc.selectedUnit);
    }

    PrefUtils().readBool(WorkplaceNotificationConst.isShowNotice).then((value) {
      setState(() {
        isShowNotice = value;
      });
    });

    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    followUpBloc = BlocProvider.of<FollowUpBloc>(context);
    houseBlockBloc = BlocProvider.of<HouseBlockBloc>(context);
    teamMemberBloc = BlocProvider.of<TeamMemberBloc>(context);

    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    homeNewBloc = BlocProvider.of<HomeNewBloc>(context);
    // homeNewBloc.add(OnHomeNoticeBoardEvent());
    homeNewBloc.add(OnGetHomeAnnouncement());
    committeeMemberBloc = BlocProvider.of<CommitteeMemberBloc>(context);
    committeeMemberBloc.add(FetchCommitteeMembers(mContext: context));
    followUpBloc.add(OnGetTaskFiltersListEvent());


    apiCalling();

    companies = userProfileBloc.user.companies ?? [];

    PrefUtils().readStr(WorkplaceNotificationConst.deviceTokenC).then((value) {
      OneSignalNotificationsHandler.instance
          .setAppContext(MainAppBloc.getDashboardContext);
    });

    initPermission();
    super.initState();
  }

  String formattedDate = '';

  @override
  Widget build(BuildContext context) {
    Widget userName() {
      return BlocListener<UserProfileBloc, UserProfileState>(
        bloc: userProfileBloc,
        listener: (context, state) {
          if (state is UserProfileFetched) {}
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
            bloc: userProfileBloc,
            builder: (context, state) {
              if (state is UserProfileFetched) {
                companies = userProfileBloc.user.companies;
                initPermission();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppString.hello} ${userProfileBloc.user.name ?? ''}",
                      style: appTextStyle.appTitleStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }

    Future<void> onRefresh() async {
      setState(() {
        isShowLoader = false;
      });
      homeNewBloc.add(OnTotalDuesEvent());
      homeNewBloc.add(OnHomeNoticeBoardEvent());
      await Future.delayed(const Duration(milliseconds: 2000));
      refreshController1.refreshCompleted();
    }

    Future<void> launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri,
            mode: LaunchMode.externalApplication); // Open in browser
      } else {
        throw 'Could not launch $url';
      }
    }

    Widget homeInfoMessage() {
      return homeInfoMessages.isNotEmpty
          ? Container(
              decoration: const BoxDecoration(
                color: AppColors.appBlueColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.appBlueColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: homeInfoMessages['home_info_message'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () => launchURL(
                            homeInfoMessages['action_link'],
                          ),
                          child: Text(
                            homeInfoMessages['action_text'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                              decorationThickness: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          : const SizedBox();
    }


    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBackgroundColor: Colors.grey.shade100,
      appBarHeight: 56,
      statusBarColor: Colors.grey.shade100,
      appBar: HomeScreenAppBar(
        notificationCount: /*userProfileBloc.user.notificationCount ??*/ 0,
        itemsLength: companies?.length ?? 0,
        listOfCompanies: companies ?? [],
        // Ensure it doesn't pass `null`
        isShow: isShowNotice,
        onCompanySelect: saveSelectedCompany,
        onOtherOptionSelect: (selectedOptionTitle) {
          if (selectedOptionTitle == 'Add Flat/Villa/Office') {
            context.go('/dashBoard/searchYourSocietyForm');
          }
        },
      ),
      containChild: BlocBuilder<HomeNewBloc, HomeNewState>(
        bloc: homeNewBloc,
        builder: (context, state) {
          if (state is OnTotalDuesLoadingState || homeNewBloc.duesData == null) {
            isShowLoader = false;
          } else if (state is OnTotalDuesErrorState) {
            return Center(child: Text(state.errorMessage));
          } else if (state is HomeAnnouncementErrorState) {
            return Center(child: Text(state.errorMessage));
          }
          if (state is OnTotalDuesLoadedState) {
            isShowLoader = false;
          }
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: onRefresh,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      homeInfoMessage(),
                      userName(),
                      SizedBox(height: 0,),
                      // if (homeNewBloc.duesData?.isDue == true)
                      //   InkWell(
                      //     onTap: () {
                      //       Navigator.push(
                      //         MainAppBloc.getDashboardContext,
                      //         SlideLeftRoute(
                      //             widget: const MyUnitNewScreen()),
                      //       );
                      //     },
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 14.5)
                      //           .copyWith(bottom: 5),
                      //       child: CommonCardView(
                      //         elevation: 1.5,
                      //         margin: const EdgeInsets.only(top: 12),
                      //         cardColor: const Color(0xffFFEBEE),
                      //         child: Container(
                      //           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12).copyWith(right: 1),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 homeNewBloc.duesData?.label ?? "",
                      //                 style: appTextStyle.appTitleStyle(
                      //                     fontWeight: FontWeight.w700),
                      //               ),
                      //               Flexible(
                      //                 child: Align(
                      //                     alignment: Alignment.centerRight,
                      //                     child: Padding(
                      //                       padding: const EdgeInsets.all(8.0)
                      //                           .copyWith(right: 13),
                      //                       child: const Icon(
                      //                         Icons.arrow_forward_ios_outlined,
                      //                         color: Colors.black,
                      //                         size: 16,
                      //                       ),
                      //                     )),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   )
                      // else
                      //   const SizedBox(),
                      homeView()
                    ],
                  ),
                )
              ),
              if(isShowLoader == true)
              Container(
                color: Colors.grey.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),

              ApprovalPendingScreen(
                userName: userProfileBloc.user.name ?? '',
              ),
              NetworkStatusAlertView(onReconnect: (){
                onRefresh();
              },)
            ],
          );
        },
      ),
    );
  }

  Widget noticeBoard2() {
    if (!AppPermission.instance
        .canPermission(AppString.noticeList, context: context)) {
      return const SizedBox();
    }

    return BlocBuilder<HomeNewBloc, HomeNewState>(
      bloc: homeNewBloc,
      builder: (context, state) {
        if (state is NoticeboardLoadingState ||
            state is UserProfileFetching ||
            state is HomeAnnouncementLoadingState) {
          return const SizedBox();
        }

        if (homeNewBloc.homeAnnouncementData == null) {
          return const SizedBox();
        }

        final notice = homeNewBloc.homeAnnouncementData?.announcements;

        return notice?.isEmpty == true?SizedBox():Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              .copyWith(top: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0)
                    .copyWith(bottom: 15, top: 5, left: 2, right: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          AppString.notice,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/images/announcement_icon.svg',
                              color: AppColors.black.safeOpacity(0.7),
                              height: 20,
                              width: 20,
                            ),
                            // const Icon(Icons.notifications_none, size: 20,color: AppColors.appBlueColor,),
                            Positioned(
                              right: 0,
                              top: 0,
                              left: 16,
                              child: Container(
                                height: 6,
                                width: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                          WorkplaceWidgets.calendarIcon(),
                        const SizedBox(width: 4),
                        Text(
                          notice?.isNotEmpty == true ? notice?.first.publishedAt ?? '':"",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: const Border(
                    left: BorderSide(
                      color: AppColors.appBlueColor, // Use your desired color
                      width: 5,
                    ),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top Row (Notice Board + Bell Icon + Date)

                      // const SizedBox(height: 12),

                      /// Notice Content
                      Text(
                        parse(
                          notice?.first.content,
                        ).body!.text.trim(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Read More Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              MainAppBloc.getDashboardContext,
                              SlideLeftRoute(
                                widget:  NoticeDetailPage(
                                  content: notice?.first.content ?? '',
                                  date: notice?.first.publishedAt ?? '',
                                  title: notice?.first.title ?? '',
                                ),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Read More",
                                style: TextStyle(
                                  color: AppColors.appBlueColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 22,
                                color: AppColors.appBlueColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget homeView() {
    return BlocListener<UserProfileBloc, UserProfileState>(
        bloc: userProfileBloc,
        listener: (context, state) {
          if (state is UserProfileFetched) {
            if (userProfileBloc.user.isBlockAccount == true) {
              showDialog(
                  barrierDismissible: false,
                  barrierColor: Colors.grey.shade800.safeOpacity(0.7),
                  context: context,
                  builder: (context1) {
                    return AlertDialog(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.white,
                      title: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade700.safeOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline,
                              size: 40,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              AppString.accountDeactivate,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      titleTextStyle: appStyles.titleStyle(
                        fontSize: AppDimens().fontSize(value: 22),
                        fontWeight: FontWeight.w500,
                        texColor: AppColors.black,
                        fontFamily: AppFonts().defaultFont,
                      ),
                      content: Text(
                        state.displayMessage == null ||
                                state.displayMessage == ""
                            ? AppString.accountDisableMsg
                            : state.displayMessage!,
                        textAlign: TextAlign.center,
                      ),
                      contentTextStyle: appStyles.subTitleStyle(
                        fontSize: AppDimens().fontSize(value: 16),
                        fontWeight: FontWeight.w200,
                        texColor: AppColors.black,
                        fontFamily: AppFonts().defaultFont,
                      ),
                      actionsAlignment: MainAxisAlignment.end,
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                userProfileBloc
                                    .add(UserIsBlockedEvent(mContext: context));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.appTransColor,
                                  ),
                                  color: AppColors.appTransColor,
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 8),
                                  child: Text(
                                    AppString.exit,
                                    style: appStyles.subTitleStyle(
                                      fontSize: AppDimens().fontSize(value: 17),
                                      fontWeight: FontWeight.w500,
                                      texColor: AppColors.appBlue,
                                      fontFamily: AppFonts().defaultFont,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  });
            }
          }
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
            bloc: userProfileBloc,
            builder: (context, state) {
              if (state is UserProfileFetched) {
                initPermission();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (userProfileBloc.selectedUnit?.title != null)
                  //   ResidentialUnitCard(
                  //     title: AppString.myUnit,
                  //     unitNumber: userProfileBloc.selectedUnit?.title ?? '',
                  //     // address: 'Apollo Towers, Sector 5',
                  //     onTap: () {
                  //       Navigator.push(
                  //         MainAppBloc.getDashboardContext,
                  //         SlideLeftRoute(
                  //           widget: const MyUnitNewScreen(),
                  //         ),
                  //       ).then((value) {
                  //         if (value != null && value == true) {
                  //           setState(() {
                  //             isShowLoader = false;
                  //           });
                  //           homeNewBloc.add(OnTotalDuesEvent());
                  //           // homeNewBloc.add(OnHomeNoticeBoardEvent());
                  //         }
                  //       });
                  //     },
                  //   ),
                    LayoutBuilder(builder: (context, constraints) {
                    final itemWidth = (constraints.maxWidth - (4 - 1) * 16) / 4;
                    return Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(top: 15),
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cardItems.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: itemWidth,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 5,
                          mainAxisExtent: 120, // Optional, for height tuning
                        ),

                        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        //   crossAxisCount: 4,
                        //   crossAxisSpacing: 5,
                        //   mainAxisSpacing: 5,
                        //   mainAxisExtent: 115,
                        // ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              switch (cardItems[index]["id"]) {
                                case 1:
                                  Navigator.push(
                                          MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                              widget:
                                                  const MyUnitNewScreen()))
                                      .then((value) {
                                    if (value != null && value == true) {
                                      setState(() {
                                        isShowLoader = false;
                                      });
                                      homeNewBloc.add(OnTotalDuesEvent());
                                      // homeNewBloc.add(OnHomeNoticeBoardEvent());
                                    }
                                  });
                                  break;
                                case 2:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const AllNoticeScreen()));
                                  break;
                                case 3:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const ComplaintTabBarView()));
                                  break;
                                case 4:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const FindHelperScreen()));
                                  break;
                                case 7:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const AddTransactionForm(
                                                  comeWithPermission: [
                                                    AppString
                                                        .managerUnitTransactionReceiptUpload
                                                  ])));
                                  break;
                                case 9:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const AddVehicleForManager()));
                                  break;
                                case 10:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const MyFamilyScreen()));
                                  break;

                                case 12:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const HomeVisitorListScreen()));
                                  break;
                                case 13:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const NocRequestScreen()));
                                  break;
                                case 14:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const AmenitiesSelectionScreen()));
                                  break;
                                  case 15:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                              const FollowUpTasksScreen(

                                              )));
                                  break;
                                case 17:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                          const FollowUpTasksScreen(
                                            isComingFromMyTask: true,

                                          )));
                                  break;

                                case 18:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                          const AmenitiesSelectionScreen()));
                                  break;
                                case 19:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                          const AmenitiesSelectionScreen()));
                                  break;

                                  case 20:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                          const AssetsListScreen()));
                                  break;

                                  case 21:
                                  Navigator.push(
                                      MainAppBloc.getDashboardContext,
                                      SlideLeftRoute(
                                          widget:
                                          const MyAssetScreen()));
                                  break;
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CommonCardView(
                                  elevation: 4,
                                  cardColor: cardItems[index]["bgColor"] ??
                                      Colors.grey.shade200,
                                  borderRadius: 120,
                                  side: BorderSide(
                                      width: 0.2,
                                      color: cardItems[index]["iconColor"]),
                                  // decoration: BoxDecoration(
                                  //   color: cardItems[index]["bgColor"] ?? Colors.grey.shade200,
                                  //   shape: BoxShape.circle,
                                  //   border: Border.all(
                                  //     color:cardItems[index]["iconColor"] ,// Light border color
                                  //     width: 0.3,                     // Border width
                                  //   ),
                                  //   // boxShadow: [
                                  //   //   BoxShadow(
                                  //   //     color: Colors.black.withOpacity(0.12),
                                  //   //     spreadRadius: 2.0,
                                  //   //     blurRadius: 5,
                                  //   //     offset: const Offset(0, 7), // X and Y axis offset
                                  //   //   ),
                                  //   // ],
                                  // ),

                                  // padding: const EdgeInsets.all(18),
                                  child: cardItems[index]["icon"] is String
                                      ? Padding(
                                          padding: const EdgeInsets.all(18),
                                          child: SvgPicture.asset(
                                            cardItems[index]["icon"],
                                            width: 24,
                                            height: 24,
                                            color: cardItems[index]
                                                    ["iconColor"] ??
                                                AppColors.textBlueColor,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(18),
                                          child: Icon(
                                            cardItems[index]["icon"],
                                            size: 24,
                                            color: cardItems[index]
                                                    ["iconColor"] ??
                                                AppColors.textBlueColor,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  // height: 33, // Adjust as needed
                                  child: Text(
                                    cardItems[index]["title"],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: appTextStyle
                                        .appSubTitleStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.5,
                                    )
                                        .copyWith(
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 3,
                                          color: Colors.black.safeOpacity(0.12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 0,
                  ),
                  if (cardItems.isNotEmpty) noticeBoard2(),
                ],
              );
            }));
  }

  Future<void> saveSelectedCompany(
      int companyId, bool isApprovalPending, onChangCompany) async {
    if (isApprovalPending == true || onChangCompany == true) {
      PrefUtils()
          .saveStr(WorkplaceNotificationConst.selectedCompanyId,
              companyId.toString())
          .then((value) {
        ApiBaseHelpers.selectedCompanySaveId = companyId.toString();
        WorkplaceDataSourcesImpl.selectedCompanySaveId = companyId.toString();
        WorkplaceDataSourcesImpl();
        BlocProvider.of<FeedBloc>(context).add(ResetFeedEvent());
        BlocProvider.of<MyUnitBloc>(context).add(ResetMyUnitEvent());
        BlocProvider.of<TeamMemberBloc>(context).add(ResetTeamBlocEvent());
        BlocProvider.of<MyVehicleListBloc>(context)
            .add(ResetMyVehicleBlocEvent());
        BlocProvider.of<FindHelperBloc>(context).add(ResetFindHelperEvent());
        BlocProvider.of<TeamMemberBloc>(context).add(ResetTeamBlocEvent());
        // BlocProvider.of<UserProfileBloc>(context).add(ResetSelectedMyUnit());
        houseBlockBloc.add(FetchHouseBlockEvent(mContext: context));
        cardItems = [];
        apiCalling(isCompanySwitched: onChangCompany);
      });
    }
  }

  void initPermission() {
    cardItems = [];
    cardItems = [
      // if (AppPermission.instance
      //     .canPermission(AppString.unitList, context: context))
      //   {
      //     "title": "My Units",
      //     "icon": Icons.apartment,
      //     "id": 1,
      //     "bgColor": const Color(0xFFe0e7ff),
      //     "iconColor": const Color(0xff4f46e5)
      //     // Light Purple
      //   },
      // if (AppPermission.instance.canPermission(AppString.manageAssetsList, context: context))
        {
          "title": "My Assets",
          "icon": Icons.list_alt_outlined,
          "id": 21,
          "bgColor": const Color(0xFFede9fe),
          "iconColor": const Color(0xff7c3aed)
        },
      if (AppPermission.instance.canPermission(AppString.manageAssetsList, context: context))
        {
          "title": "Assets",
          "icon": Icons.inventory,
          "id": 20,
          "bgColor": const Color(0xFFfff1f2),
          "iconColor": const Color(0xffe11d48)
        },



      if (AppPermission.instance
          .canPermission(AppString.noticeList, context: context))
        {
          "title": "Notice",
          "icon": 'assets/images/announcement_icon.svg',
          "id": 2,
          "bgColor": const Color(0xFFf3e8ff),
          "iconColor": const Color(0xff9333ea)
        },
      if (AppPermission.instance
          .canPermission(AppString.complaintList, context: context))
        {
          "title": "Complaints",
          "icon": Icons.message_outlined,
          "id": 3,
          "bgColor": const Color(0xFFfdf2f8),
          "iconColor": const Color(0xffdb2777),
          // ← new key
        },
      // Modify this line
      if (AppPermission.instance
          .canPermission(AppString.handymanList, context: context))
        {
          "title": "Find a Help",
          "icon": Icons.person_search,
          "id": 4,
          "bgColor": const Color(0xFFdbeafe),
          "iconColor": const Color(0xff2563eb),
        },
      if (AppPermission.instance
          .canPermission(AppString.nocList, context: context))
        {
          "title": "NOC Request",
          "icon": Icons.request_page,
          "id": 13,
          "bgColor": const Color(0xFFE0FFFF),
          "iconColor": const Color(0xff2563eb)
        },

      // if (AppPermission.instance
      //     .canPermission(AppString.manageMemberAdd, context: context))
      //   {
      //     "title": "Add Member",
      //     "icon": Icons.person_add,
      //     "id": 9,
      //     "bgColor": const Color(0xFFf3e8ff),
      //     "iconColor": const Color(0xff9333ea)
      //   },

      if (AppPermission.instance.canPermission(AppString.manageTaskList, context: context))
        {
        "title": "Manage Task",
        "icon":   Icons.fact_check, // Checklist-style icon
        "id": 15,
        "bgColor": const Color(0xFFede9fe),
        "iconColor": const Color(0xff7c3aed)
        },



      if (AppPermission.instance.canPermission(AppString.taskList, context: context))

      {
        "title": "My Task",
        "icon": Icons.assignment,
        "id": 17,
        "bgColor": const Color(0xFFf0fdfa),
        "iconColor": const Color(0xff0d9488)
      },

      // {
      //   "title": "Amenities Booking",
      //   "icon": Icons.book,
      //   "id": 18,
      //   "bgColor": const Color(0xFFede9fe),
      //   "iconColor": const Color(0xff7c3aed)
      // },
      // {
      //   "title": "Amenities",
      //   "icon": Icons.book,
      //   "id": 19,
      //   "bgColor": const Color(0xFFede9fe),
      //   "iconColor": const Color(0xff7c3aed)
      // },



    ];
  }

  void apiCalling({bool? isCompanySwitched = false}) {
    userProfileBloc.add(FetchProfileDetails(mContext: context, isCompanySwitched: isCompanySwitched));
    homeNewBloc.add(OnHomeNoticeBoardEvent());
    homeNewBloc.add(OnTotalDuesEvent());
  }
}
