import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/core/util/app_theme/text_style.dart';
import 'package:asetize/features/my_visitor/pages/pre_register_visitor.dart';
import 'package:asetize/features/my_visitor/pages/today_my_visitor_detail_screen.dart';
import 'package:asetize/features/my_visitor/pages/upcoming_visitors.dart';
import '../../../app_global_components/common_floating_add_button.dart';
import '../../../core/enum/app_enums.dart';
import '../../../core/util/app_permission.dart';
import '../../../imports.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../bloc/my_visitor_bloc.dart';
import '../bloc/my_visitor_event.dart';
import '../bloc/my_visitor_state.dart';
import '../models/visitor_model.dart';
import '../widgets/visitor_card_widget.dart';
import 'all_previous_visitor_history.dart';
import 'package:asetize/features/data/models/user_response_model.dart' as userResponse;

class HomeVisitorListScreen extends StatefulWidget {
  const HomeVisitorListScreen({super.key});
  @override
  State<HomeVisitorListScreen> createState() => _HomeVisitorListScreenState();
}

class _HomeVisitorListScreenState extends State<HomeVisitorListScreen>
    with TickerProviderStateMixin {
  late UserProfileBloc userProfileBloc;
  late AddVehicleManagerBloc addVehicleManagerBloc;
  bool isShowLoader = true;
  late TabController tabController;
  int tabInitialIndex = 0;
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  RefreshController refreshController1 = RefreshController(initialRefresh: false);
  RefreshController refreshController2 = RefreshController(initialRefresh: false);
  late HomeBloc homeBloc;
  List<userResponse.Houses> houses = [];
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
  List<VisitorData> searchedItems = [];
  List<VisitorData> searchedItems2 = [];

  void apiCall() {
    onUnitSelect(userProfileBloc.selectedUnit);
  }

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    apiCall();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabInitialIndex = tabController.index;
      });
    });
    if (userProfileBloc.user.houses != null &&
        userProfileBloc.user.houses!.isNotEmpty) {
      houses = userProfileBloc.user.houses ?? [];
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    tabController.dispose();
    refreshController1.dispose();
    refreshController2.dispose();
    super.dispose();
  }



  void visitorCheckout(BuildContext context, int entryId) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WorkplaceWidgets.titleContentPopup(
          buttonName1: "Cancel",
          buttonName2: "Confirm",
          onPressedButton1TextColor: AppColors.black,
          onPressedButton2TextColor: AppColors.white,
          onPressedButton1Color: Colors.grey.shade200,
          onPressedButton2Color: Colors.green,
          onPressedButton1: () => Navigator.pop(context),
          onPressedButton2: () async {
            homeBloc.add(OnVisitorCheckoutEvent(mContext: context,entryHouseId: entryId, status: "approved"));
            Navigator.pop(context);
          },
          title: "Allow Visitor",
          content: "Do you want to allow the guard to check out this visitor?",
        );
      },
    );
  }

  void visitorDeny(BuildContext context, int entryId) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WorkplaceWidgets.titleContentPopup(
          buttonName1: "Cancel",
          buttonName2: "Confirm",
          onPressedButton1TextColor: AppColors.black,
          onPressedButton2TextColor: AppColors.white,
          onPressedButton1Color: Colors.grey.shade200,
          onPressedButton2Color: AppColors.red,
          onPressedButton1: () => Navigator.pop(context),
          onPressedButton2: () async {
            homeBloc.add(OnVisitorCheckoutEvent(mContext: context,entryHouseId: entryId, status: "denied"));
            Navigator.pop(context);
          },
          title: "Deny Visitor",
          content: "Do you want to deny the guard permission to check out this visitor?",
        );
      },
    );
  }

  void filter(String searchText, List<VisitorData> data) {
    setState(() {
      searchedItems = searchText.isEmpty
          ? data
          : data.where((element) =>
      element.name?.toLowerCase().contains(searchText.toLowerCase()) == true ||
          element.phone?.contains(searchText) == true ||
          element.vehicle?.vehicleNumber?.contains(searchText) == true).toList();
    });
  }

  void onUnitSelect(userResponse.Houses? house) {
    if(house!=null){
      userProfileBloc.add(OnChangeCurrentUnitEvent(selectedUnit: house));
      homeBloc.add(OnGetVisitorCheckedInListEvent(
          houseId:  house.id,
          mContext: context,
          status: "${VisitorStatus.checkedIn.value},${VisitorStatus.checkedOut.value}",
          startTime: projectUtil.getTodayStartDateTime()));
      userProfileBloc.add(OnChangeCurrentUnitEvent(selectedUnit: house));
      homeBloc.add(OnGetVisitorHistoryListEvent(
        houseId:  house.id,
        mContext: context,
        // status: VisitorStatus.checkedIn.value,
        endTime: projectUtil.getYesterdayEndTime(),
      ));
      homeBloc.add(OnGetUpcomingVisitorsListEvent(
          mContext: context,
          houseId: house.id,
          status: "pre-approved",
          startTime: projectUtil.getTodayStartDateTime()
      ));


    }

  }

  Future<void> onRefresh1() async {
    apiCall();
    await Future.delayed(const Duration(milliseconds: 2000));
    refreshController1.refreshCompleted();
  }

  List<Widget> actions() {
    return List.generate(houses.length, (index) {
      return CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
          onUnitSelect(houses[index]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${houses[index].title}',
              style: TextStyle(
                color: userProfileBloc.selectedUnit?.title == houses[index].title
                    ? AppColors.buttonBgColor3 // Selected color
                    : Colors.black,            // Default color
                fontWeight: userProfileBloc.selectedUnit?.title == houses[index].title
                    ? FontWeight.w600          // Selected font weight
                    : FontWeight.normal,       // Default font weight
              ),
            ),

          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget searchBar() {
      return Container(
        margin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        child: TextField(
          controller: controller,
          onChanged: (searchText) => filter(searchText, homeBloc.checkInData),
          style: appTextStyle.appSubTitleStyle(fontWeight: FontWeight.normal, fontSize: 16),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: 'Search by name, mobile, vehicle no.',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.clear();
                FocusScope.of(context).unfocus();
                apiCall();
              },
            )
                : null,
            contentPadding: const EdgeInsets.only(top: 5),
          ),
        ),
      );
    }

    Widget checkInTabView(HomeState state) {
      return SmartRefresher(
        onRefresh: onRefresh1,
        controller: refreshController1,
        child: ListView(
          padding: const EdgeInsets.only(top: 10),
          children: [
            if (homeBloc.checkInData.isNotEmpty) searchBar(),
            if (searchedItems.isEmpty&& state is !VisitorLoadingState && state is !VisitorHistoryLoadingState)
              WorkplaceWidgets.noDataWidget(context, 'No data found')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 40),
                itemCount: searchedItems.length,
                itemBuilder: (context, index) {
                  return VisitorCardWidget(
                    visitorData: searchedItems[index],
                    onTab: () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                          widget:VisitorDetailScreen(visitorData: searchedItems[index]),
                        ),
                      );
                    },
                    onInfoTab: () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                          widget: VisitorDetailScreen(visitorData: searchedItems[index]),
                        ),
                      );
                    },
                    onCheckOutTab: () {
                      visitorCheckout(context, searchedItems[index].houses!.first.entryHouseId ?? 0);
                    },
                    onDenyTab: (){
                      visitorDeny(context, searchedItems[index].houses!.first.entryHouseId  ?? 0);
                    },
                  );
                },
              ),
          ],
        ),
      );
    }

    Widget unitSelectionOption(){
      return  InkWell(
        onTap: (){
          closeKeyboard();
          if (userProfileBloc.user.houses!.length > 1) {
            showCupertinoModalPopup(
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
                  userProfileBloc.selectedUnit?.title ?? AppString.selectUnit,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black87),
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
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isListScrollingNeed: true,
      isFixedDeviceHeight: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(title: AppString.myVisitor, isHideIcon: false,isHideBorderLine: true,),
      containChild: BlocListener<HomeBloc, HomeState>(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is VisitorCheckoutDoneState) {
            setState(() {
              isShowLoader =false;
            });
            apiCall();
            if (state.status != "denied") {
              WorkplaceWidgets.successToast(AppString.visitorAllowSuccessfully);
            } else{
              WorkplaceWidgets.errorSnackBar(context, AppString.visitorDenySuccessfully);
            }
          }
          else if (state is VisitorCheckoutErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          else if (state is VisitorListDoneState) {
            if (controller.text.isEmpty) searchedItems = homeBloc.checkInData;
            if (controller2.text.isEmpty) searchedItems2 = homeBloc.checkOutData;
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            unitSelectionOption(),
            const SizedBox(height: 15,),
            Container(
              color: Color(0xFFF5F5F5),
              child: TabBar(
                onTap: (int index) {
                  setState(() {
                    tabInitialIndex = index;
                  });
                },
                dividerColor: Colors.grey.safeOpacity(0.2),
                labelColor: AppColors.textBlueColor,
                labelPadding: const EdgeInsets.only(bottom: 10),
                indicatorColor: AppColors.textBlueColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                unselectedLabelColor: AppColors.greyUnselected,
                controller: tabController,
                tabs: [
                  Text(
                    'Upcoming',
                    style: appStyles.tabTextStyle(),
                  ),
                  Text(
                    'History',
                    style: appStyles.tabTextStyle(),
                  ),
                ],
              ),
            ),

            Flexible(
              child: BlocBuilder<HomeBloc, HomeState>(
                bloc: homeBloc,
                builder: (context, state) {
                  if (state is VisitorListErrorState) {
                    return WorkplaceWidgets.noDataWidget(context, state.errorMessage);
                  }
                  return Stack(
                    children: [
                      TabBarView(
                        controller: tabController,
                        children: const [
                          UpcomingVisitorScreen(),
                          VisitorHistoryDetailScreen(),
                        ],
                      ),
                      if ((state is VisitorLoadingState || state is VisitorHistoryLoadingState) && isShowLoader)
                        WorkplaceWidgets.progressLoader(
                          context,
                          height: MediaQuery.of(context).size.height - 220,
                        ),
                    ],
                  );
                },
              ),
            )
          ],
        )

      ),
      bottomMenuView:

      // AppPermission.instance.canPermission(AppString.complaintAdd,context: context)?
      CommonFloatingAddButton(onPressed: () {
        Navigator.push(
          context,
          SlideLeftRoute(
              widget:  const PreRegisterVisitorForm()),
        ).then((value) {
          if (value != null && value == true) {
            setState(() {
              isShowLoader = false;
              // tabInitialIndex = 1; // Ensure third tab is selected on return
              // tabController.animateTo(2); // Move to third tab
              apiCall();
            });
            // homeNewBloc.add(OnHomeNoticeBoardEvent());
          }
        });
      },)

            // :const SizedBox(),
    );
  }
}





