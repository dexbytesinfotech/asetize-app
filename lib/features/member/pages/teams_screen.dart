import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:asetize/widgets/common_search_bar.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import '../bloc/team_member/team_member_bloc.dart';
import '../widget/filter_for_block.dart';
import '../widget/members_list_view.dart';
import '../widget/teams_grid_view_widget.dart';
import 'member_profile_bottom_sheet.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  State createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  late TeamMemberBloc teamMemberBloc;
  final TextEditingController controller = TextEditingController();
  bool isGrid = true;
  bool isShowLoader = true;
  String? selectedBlockName;

  @override
  void initState() {
    super.initState();
    teamMemberBloc = BlocProvider.of<TeamMemberBloc>(context);
    controller.clear();
    PrefUtils().readBool(WorkplaceNotificationConst.teamViewIsGrid)
        .then((value) {
      setState(() {
        isGrid = value;
      });
    });

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    List<AlphabetListViewItemGroup> _groupItemsByAlphabet(List<User> users) {
      Map<String, List<User>> groupedItems = {};
      for (var user in users) {
        if (user.name != null && user.name!.isNotEmpty) {
          String initial = user.name![0].toUpperCase();
          groupedItems.putIfAbsent(initial, () => []).add(user);
        }
      }

      List<AlphabetListViewItemGroup> itemGroups = [];
      itemGroups = groupedItems.entries.map((animalLetter) {
        var user = animalLetter.value;
        return AlphabetListViewItemGroup(
            tag: animalLetter.key.toString(),
            children: user.map((user) {
              return Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10,top: 15),
                  child: MemberListViewWidget(
                    imageUrl: user.profilePhoto,
                    userName: user.name ?? '',
                    jobTitle: user.shortDescription ?? '',
                    onClickCallBack: () {
                      FocusScope.of(context).unfocus();
                      return showModalBottomSheet(
                        context: MainAppBloc.getDashboardContext,
                        isDismissible: false,
                        enableDrag: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        builder: (ctx) => StatefulBuilder(
                          builder: (ctx, state) => Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top),
                            child: MemberProfileBottomSheet(userData: user),
                          ),
                        ),
                      ).then((value) {});
                    },
                  ));
            }).toList());
      }).toList();
      return itemGroups;
    }

    AppDimens appDimens = AppDimens();
    appDimens.appDimensFind(context: context);

    final AlphabetListViewOptions options = AlphabetListViewOptions(
      listOptions: ListOptions(
        showSectionHeader: true,
        stickySectionHeader: false,
        padding: const EdgeInsets.only(bottom: 45),
        listHeaderBuilder: (context, symbol) => SizedBox()


        //     Padding(
        //   padding: const EdgeInsets.only(left: 20, right: 0, bottom: 5),
        //   child: Container(
        //     padding: const EdgeInsets.all(3.0).copyWith(left: 8),
        //     margin: const EdgeInsets.only(
        //       top: 0,
        //       bottom: 10,
        //     ),
        //     decoration: BoxDecoration(
        //         color: AppColors.appBlueColor.safeOpacity(0.1),
        //         borderRadius: const BorderRadius.all(Radius.circular(6))),
        //     child: Text(
        //       symbol,
        //       style: appTextStyle.appSubTitleStyle(
        //           color: AppColors.appBlueColor, fontWeight: FontWeight.normal),
        //     ),
        //   ),
        // ),
      ),
      scrollbarOptions: const ScrollbarOptions(
        padding: EdgeInsets.only(top: 0, bottom: 30),
        backgroundColor: Colors.transparent,
      ),
      overlayOptions: OverlayOptions(
          showOverlay: true,
          alignment: Alignment.topRight,
          overlayBuilder: (context, symbol) {
            return Container(
              margin: const EdgeInsets.only(top: 45),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: AppColors.textBlueColor,
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text(
                symbol,
                style: appTextStyle.appSubTitleStyle(
                    color: AppColors.white, fontWeight: FontWeight.normal),
              ),
            );
          }),
    );

  return BlocListener<TeamMemberBloc, TeamMemberState>(
  listener: (context, state) {
    // TODO: implement listener
    if (state is TeamMemberDataFetched) {
      // if (controller.text.isEmpty && selectedBlockName == null) {
      //   // searchedItems = teamMemberBloc.data;
      // }
      // else{
      //   filter(selectedBlockName ?? "",teamMemberBloc.data,true);
      // }
      // dynamicData = WorkplaceDataSourcesImpl.teamDataList;
    }
  },
  child: BlocBuilder<TeamMemberBloc, TeamMemberState>(
      bloc: teamMemberBloc,
      builder: (context, state) {
        if (state is TeamMemberInitial) {
          teamMemberBloc.add(FetchTeamList(mContext: context));
        }
        if (state is StoreTeamViewIsListOrGridState) {
          isGrid = state.isGrid;
        }
        final itemGroups;

        if(selectedBlockName != null){
           itemGroups = _groupItemsByAlphabet(teamMemberBloc.data);
        }
        else{
           itemGroups = _groupItemsByAlphabet(teamMemberBloc.data);

        }
        
        return  Stack(
          children: [
            teamMemberBloc.usersListMain.isNotEmpty
                ?
            RefreshIndicator(
              color: AppColors.appBlueA,
              onRefresh: () async {
                onPullToRefresh();
              },
              child: Container(
                height: double.infinity,
                color: Colors.transparent,
                child: Column(
                  children: [
                    searchBar(state),
                    teamMemberBloc.data.isEmpty
                        ? Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          AppString.noMember,
                          style: appTextStyle.noDataTextStyle(),
                        ),
                      ),
                    )
                        :Expanded(
                      // Wrap GridView.builder with Expanded
                      child:
                      isGrid?
                      GridView.builder(
                        padding: EdgeInsets.all(4.sp)
                            .copyWith(bottom: 45),
                        physics:
                        const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: teamMemberBloc.data.length,
                        itemBuilder:
                            (BuildContext context, int index) {
                          User mUser = teamMemberBloc.data[index];
                          String userName = mUser.name ?? '';
                          return TeamsGridViewWidget(
                            imageUrl: mUser.profilePhoto,
                            userName: userName,
                            jobTitle: mUser.shortDescription ??
                                'A1-101,A-201',
                            onClickCallBack: () {
                              FocusScope.of(context).unfocus();
                              return showModalBottomSheet(
                                context: MainAppBloc
                                    .getDashboardContext,
                                isDismissible: false,
                                enableDrag: true,
                                isScrollControlled: true,
                                backgroundColor:
                                Colors.transparent,
                                shape:
                                const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.vertical(
                                      top: Radius.circular(
                                          15)),
                                ),
                                builder: (ctx) =>
                                    StatefulBuilder(
                                      builder: (ctx, state) =>
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(
                                                    context)
                                                    .padding
                                                    .top),
                                            child:
                                            MemberProfileBottomSheet(
                                                userData:mUser),
                                          ),
                                    ),
                              ).then((value) {});
                            },
                          );
                        },
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 150,
                        ),
                      ):
                      AlphabetListView(
                        items: itemGroups,
                        options: options,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Center(
              child: Text(
                (state is TeamMemberLoadingState)
                    ? ''
                    : AppString.noDataFound,
                style: appTextStyle.noDataTextStyle(),
              ),
            ),
            if (isShowLoader && state is TeamMemberLoadingState)
              WorkplaceWidgets.progressLoader(context),
            NetworkStatusAlertView(onReconnect: (){
              onPullToRefresh();
            },)
          ],
        );
      },
    ),
);
  }

  Widget searchBar(state) {
    selectedBlockName =  teamMemberBloc.selectedFilter.isEmpty || teamMemberBloc.selectedFilter[0].isEmpty?null:teamMemberBloc.selectedFilter[0];
    return Container(
        margin: const EdgeInsets.only(top: 15, bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 19),
        height: 50, // Ensure the container has a defined height
        child: Row(
          children: [
            Expanded( // Wrap TextField in Expanded to take available space
              child: CommonSearchBar(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
               controller: controller,
               hintText: AppString.searchWithDot,
               onChangeTextCallBack: (searchText) {
                 teamMemberBloc.add(OnSearchMemberEvent(searchKey: searchText));
               },
             onClickCrossCallBack:  () {
               controller.clear();
               FocusScope.of(context).unfocus();
               teamMemberBloc.add(const OnSearchMemberEvent(searchKey: ""));
             },),),
            const SizedBox(width: 10,),
            Stack(
              alignment: Alignment.bottomRight,
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
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      builder: (ctx) => StatefulBuilder(
                        builder: (ctx, state) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.63,
                          child: FractionallySizedBox(
                            heightFactor: 1.0,
                            child: MemberFilterBottomSheet(
                              initialSelectedBlock: selectedBlockName,
                              onApply: (selectedBlock) async {
                                String searchKey = controller.text;
                                // Handle the selected block here
                                if (selectedBlock?.isNotEmpty == true) {
                                  // Handle the selected block here
                                  // await PrefUtils().saveStr(WorkplaceNotificationConst.filterValue, selectedBlock);
                                   selectedBlockName = selectedBlock;
                                  // filter(selectedBlock ?? "",teamMemberBloc.data,true);
                                  teamMemberBloc.add(OnFilterUpdateEvent(selectedFilter:[selectedBlock!],searchKey: searchKey));
                                }
                                else{
                                  // setState(() async {
                                    selectedBlockName = null;
                                    teamMemberBloc.add(OnFilterUpdateEvent(selectedFilter:[selectedBlock!],searchKey: searchKey));
                                    // await PrefUtils().saveStr(WorkplaceNotificationConst.filterValue, "");
                                    // blockFilterData.clear();
                                    // searchedItems = teamMemberBloc.data;
                                    // filter(selectedBlock ?? "",teamMemberBloc.data,true);
                                  // });
                                }

                                // Example action
                                // setState(() {
                                //   isShowLoader = false; // Update loader state if needed
                                // });
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 48,
                        margin: const EdgeInsets.only(right: 0, bottom: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: selectedBlockName != null ?AppColors.appBlueColor:Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: selectedBlockName != null ?AppColors.appBlueColor:Colors.grey.shade400)
                        ),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // if(selectedBlockName != null) Text(selectedBlockName ?? "",
                                //      style: appStyles.userNameTextStyle(
                                //          fontSize: 13,
                                //          texColor: Colors.black,
                                //          fontWeight: FontWeight.w500
                                //      )
                                // ),
                                //  if(selectedBlockName != null) const SizedBox(width: 4,),
                                SvgPicture.asset('assets/images/filter_icon.svg',color: selectedBlockName != null ?AppColors.white:AppColors.black.withOpacity(0.6),height: 25,width: 20,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // if(selectedBlockName != null)const Padding(
                //   padding: EdgeInsets.only(left: 10,top: 2),
                //   child: Icon(Icons.circle, color: AppColors.appBlueColor,size: 15,),
                // )
              ],
            ),
          ],
        ));
  }

  Future<void> onPullToRefresh() async {
    controller.clear();
    FocusScope.of(context).unfocus();
    teamMemberBloc.add(FetchTeamList(mContext: context));
    setState(() {
      isShowLoader = false; // Show loader immediately
    });
    await Future.delayed(
        const Duration(seconds: 1)); // Wait for 2 seconds
    setState(() {
      isShowLoader = false; // Hide loader after 2 seconds
    });
  }
}
