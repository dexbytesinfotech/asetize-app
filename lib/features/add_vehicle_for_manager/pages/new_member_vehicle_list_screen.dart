import '../../../app_global_components/common_floating_add_button.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../bloc/add_vehicle_manager_bloc.dart';
import '../bloc/add_vehicle_manager_event.dart';
import 'add_member_phone_new_screen.dart';
import 'new_member_list_screen.dart';
import 'new_vehicle_list_screen.dart';

class NewMemberVehicleListScreen extends StatefulWidget {
  final String houseNumber;
  final String houseId;
  final int? memberCount;
  const NewMemberVehicleListScreen({super.key, required this.houseNumber, required this.houseId, this.memberCount});

  @override
  State<NewMemberVehicleListScreen> createState() => NewMemberVehicleListScreenState();
}

class NewMemberVehicleListScreenState extends State<NewMemberVehicleListScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int tabInitialIndex = 0;
  List<Widget> tabs = [];
  late UserProfileBloc userProfileBloc;
  late AddVehicleManagerBloc addVehicleManagerBloc;
  bool isShowLoader = true;
  bool showMember = true;
  bool showVehicle = true;
  bool isShowTab = true;
  bool isFirstLoaded = false;


  @override
  void initState() {
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    tabController = TabController(length: 2, vsync: this);
    addTab();
    tabController.addListener(() {
      setState(() {
        tabInitialIndex = tabController.index;
      });
    });

    super.initState();

  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void addTab() {
    showMember = true;
    isFirstLoaded = true;
    showVehicle = AppPermission.instance.canPermission(AppString.managerVehicleList,context: context);
    if (showMember == true && showVehicle == true) {
      isShowTab = true;
    } else {
      isShowTab = false;
    }

    tabs = [
      //remove tab from list
      Text(
        AppString.members,
        style: appTextStyle.tabTextStyle(),
      ),
      //  if (AppPermission.instance.canPermission(AppString.managerVehicleList,context: context))
      Text(
        AppString.vehicles,
        style: appTextStyle.tabTextStyle(),
      ),

    ];


  }

  @override
  Widget build(BuildContext context) {

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isListScrollingNeed: true,
      isFixedDeviceHeight: false, // Set this to false to allow flexible height
      appBarHeight: 56,
      bottomSafeArea: true, // Ensure this is required or adjust as needed
      appBar:  CommonAppBar(
          title: widget.houseNumber,
          icon: WorkplaceIcons.backArrow,
          isHideBorderLine: true,
      ),
      containChild:  BlocBuilder<UserProfileBloc, UserProfileState>(
          bloc: userProfileBloc,
          builder: (context, state) {
            if (state is UserProfileFetched) {
              addTab();
            }
            return  Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                isShowTab
                    ?
                Container(
                  color: Colors.transparent,
                  child: TabBar(
                    onTap: (int index) {
                      setState(() {
                        tabInitialIndex = index;
                      });
                    },
                    labelColor: AppColors.textBlueColor,
                    labelPadding: const EdgeInsets.only(bottom: 10),
                    indicatorColor: AppColors.textBlueColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 4,
                    unselectedLabelColor: AppColors.greyUnselected,
                    controller: tabController,
                    tabs:tabs ,
                  ),
                ) : const SizedBox(),
                   (showMember == false && showVehicle == false)
                      ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No data',
                          style: appStyles.noDataTextStyle(),
                        )
                      ],
                    ),
                  )
                      :
                Expanded( // Use Flexible instead of Expanded
                  child:
                  // TabBarView(
                  //   controller: tabController,
                      IndexedStack(
                      index: tabInitialIndex,
                    children:  [
                      NewMemberListScreen(houseId: widget.houseId,),
                       if (AppPermission.instance.canPermission(AppString.managerVehicleList,context: context))
                       NewVehicleListScreen(houseId: widget.houseId),
                      // const VehicleListScreen(),
                    ],
                  ),
                ),
              ],
            );}),
        bottomMenuView: tabInitialIndex == 0  && AppPermission.instance.canPermission(AppString.manageMemberAdd, context: context) ?
        CommonFloatingAddButton(
          onPressed: () {
            Navigator.push(
              context,
              SlideLeftRoute(
                  widget: AddMemberPhoneNumberScreen(
                      houseId: widget.houseId)),
            ).then((value) {
              if (value != null) {
                addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                    mContext: context, houseId: widget.houseId));
                setState(() {
                  isShowLoader = false;
                });
              }
            });
          },

        ):const  SizedBox()
    );


  }

}


