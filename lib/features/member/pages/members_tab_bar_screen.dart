import 'package:asetize/features/member/pages/teams_screen.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../commitee_member_tab/bloc/commitee_member_bloc.dart';
import '../../commitee_member_tab/bloc/commitee_member_event.dart';
import '../../commitee_member_tab/pages/commitee_member_screen.dart';
import '../../complaints/bloc/house_block_bloc/house_block_bloc.dart';
import '../bloc/team_member/team_member_bloc.dart';

class MembersTabBarScreen extends StatefulWidget {
  const MembersTabBarScreen({super.key});

  @override
  State<MembersTabBarScreen> createState() => _MembersTabBarScreenState();
}

class _MembersTabBarScreenState extends State<MembersTabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late HouseBlockBloc houseBlockBloc;

  int tabInitialIndex = 0;
  List<User> searchedItems = [];
  bool isGrid = true;
  late TeamMemberBloc bloc;
  late CommitteeMemberBloc committeeMemberBloc;
  final TextEditingController controller = TextEditingController();
  List<Widget> tabs = [];
  bool showMember = true;
  bool showCommittee = true;
  bool isShowTab = true;
  late UserProfileBloc userProfileBloc;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    addTab();
    bloc = BlocProvider.of<TeamMemberBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    // houseBlockBloc = BlocProvider.of<HouseBlockBloc>(context);
    // houseBlockBloc.add(FetchHouseBlockEvent(mContext: context));

    committeeMemberBloc = BlocProvider.of<CommitteeMemberBloc>(context);
    tabController.addListener(() {
      setState(() {
        tabInitialIndex = tabController.index;
      });
    });
    PrefUtils()
        .readBool(WorkplaceNotificationConst.teamViewIsGrid)
        .then((value) {
      setState(() {
        isGrid = value;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void filter(String searchText, List<User> data) {
    List<User> results = [];
    if (searchText.isEmpty) {
      results = data;
    } else {
      results = data
          .where((element) =>
              element.name!.toLowerCase().startsWith(searchText.toLowerCase()))
          .toList();
    }
    setState(() {
      searchedItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamMemberBloc, TeamMemberState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is TeamMemberInitial) {
          bloc.add(FetchTeamList(mContext: context));
          committeeMemberBloc.add(FetchCommitteeMembers(mContext: context));
        }
        if (state is StoreTeamViewIsListOrGridState) {
          isGrid = state.isGrid;
        }

        return ContainerFirst(
          contextCurrentView: context,
          isSingleChildScrollViewNeed: false,
          isListScrollingNeed: true,
          isFixedDeviceHeight: false,
          appBarHeight: 56,
          bottomSafeArea: true,
          appBar: appBar(),
          containChild: BlocBuilder<UserProfileBloc, UserProfileState>(
              bloc: userProfileBloc,
              builder: (context, state) {
                if (state is UserProfileFetched) {
                  addTab();
                }
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    isShowTab
                        ? Container(
                            color: Color(0xFFF5F5F5),
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
                              tabs: tabs,
                            ),
                          )
                        : const SizedBox(),
                    (showMember == false && showCommittee == false)
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
                        : Expanded(
                            // Use Flexible instead of Expanded
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                if (AppPermission.instance.canPermission(
                                    AppString.memberList,
                                    context: context))
                                  const TeamsScreen(),
                                if (AppPermission.instance.canPermission(
                                    AppString.committeeList,
                                    context: context))
                                  const CommitteeMemberScreen(),
                              ],
                            ),
                          ),
                  ],
                );
              }),
        );
      },
    );
  }

  Widget appBar() {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 17, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppString.members,
              textAlign: TextAlign.center,
              style: appTextStyle.appBarTitleStyle(),
            ),
            // SizedBox(width: 20,),
            if (showMember && tabInitialIndex == 0)
              isGrid
                  ? IconButton(
                      icon: SvgPicture.asset('assets/images/list1.svg'),
                      onPressed: () {
                        bloc.add(const StoreTeamViewIsListOrGridEvent(
                            isGrid: false));
                      },
                    )
                  : IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/grid_icon.svg',
                      ),
                      onPressed: () {
                        bloc.add(
                            const StoreTeamViewIsListOrGridEvent(isGrid: true));
                      },
                    ),
          ],
        ),
      ),
    );
  }

  void addTab() {
    showMember = AppPermission.instance
        .canPermission(AppString.memberList, context: context);
    showCommittee = AppPermission.instance
        .canPermission(AppString.committeeList, context: context);
    if (showMember == true && showCommittee == true) {
      isShowTab = true;
    } else {
      isShowTab = false;
    }

    tabs = [
      //remove tab from list
      if (AppPermission.instance
          .canPermission(AppString.memberList, context: context))
        Text(
          AppString.members,
          style: appTextStyle.tabTextStyle(),
        ),
      if (AppPermission.instance
          .canPermission(AppString.committeeList, context: context))
        Text(
          AppString.committee,
          style: appTextStyle.tabTextStyle(),
        ),
    ];
  }
}
