import 'package:alphabet_list_view/alphabet_list_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../member/bloc/team_member/team_member_bloc.dart';
import '../../member/widget/members_list_view.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);
  @override
  State createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  late TeamMemberBloc bloc;
  final TextEditingController controller = TextEditingController();
  List<User> searchedItems = [];
  List<dynamic> dynamicData = [];
  bool isGrid = true;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<TeamMemberBloc>(context);
    PrefUtils().readBool(WorkplaceNotificationConst.teamViewIsGrid).then((value) {
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
  void filter(String searchText, List<User> data) {
    List<User> results = [];
    if (searchText.isEmpty) {
      results = data;
    } else {
      results = data.where((element) {
        final nameMatch = element.name?.toLowerCase().contains(searchText.toLowerCase()) ?? false;
        final descriptionMatch = element.shortDescription?.toLowerCase().contains(searchText.toLowerCase()) ?? false;
        return nameMatch || descriptionMatch;
      }).toList();
    }
    setState(() {
      searchedItems = results;
    });
  }
  List<AlphabetListViewItemGroup> _groupItemsByAlphabet(List<User> users) {
    Map<String, List<User>> groupedItems = {};
    for (var user in users) {
      if (user.name != null && user.name!.isNotEmpty) {
        String initial = user.name![0].toUpperCase();
        groupedItems.putIfAbsent(initial, () => []).add(user);
      }
    }
    return groupedItems.entries.map((entry) {
      return AlphabetListViewItemGroup(
        tag: entry.key.toString(),
        children: entry.value.map((user) {
          return Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
            child: MemberListViewWidget(
              imageUrl: user.profilePhoto,
              userName: user.name ?? '',
              jobTitle: user.shortDescription ?? '',
              onClickCallBack: () {
                Navigator.of(context).pop(user);
              },
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        height: 50,
        child: TextField(
          controller: controller,
          onChanged: (searchText) {
            filter(searchText, bloc.usersListMain);
          },
          style: appTextStyle.appNormalSmallTextStyle(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: AppString.searchWithDot,
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.only(top: 5),
          ),
        ),
      );
    }
    Widget appBar() {
      return Column(
        children: [
          const CommonAppBar(title: AppString.members),
          searchBar(),
        ],
      );
    }
    AppDimens appDimens = AppDimens();
    appDimens.appDimensFind(context: context);
    final AlphabetListViewOptions options = AlphabetListViewOptions(
      listOptions: ListOptions(
        showSectionHeader: true,
        stickySectionHeader: false,
        listHeaderBuilder: (context, symbol) => Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(3.0).copyWith(left: 8),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: Text(
              symbol,
              style: appTextStyle.appNormalSmallTextStyle(color: Colors.grey.shade700),
            ),
          ),
        ),
      ),
      scrollbarOptions: const ScrollbarOptions(
        padding: EdgeInsets.only(top: 0),
        backgroundColor: Colors.white,
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
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              symbol,
              style: appTextStyle.appNormalSmallTextStyle(color: AppColors.white),
            ),
          );
        },
      ),
    );
    return BlocBuilder<TeamMemberBloc, TeamMemberState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is TeamMemberInitial) {
          bloc.add(FetchTeamList(mContext: context));
        }
        if (state is TeamMemberDataFetched) {
          if (controller.text.isEmpty) {
            searchedItems = bloc.usersListMain;
          }
          dynamicData = WorkplaceDataSourcesImpl.teamDataList;
        }
        if (state is StoreTeamViewIsListOrGridState) {
          isGrid = state.isGrid;
        }
        final itemGroups = _groupItemsByAlphabet(searchedItems.isEmpty ? bloc.data : searchedItems);
        return ContainerFirst(
          contextCurrentView: context,
          isSingleChildScrollViewNeed: false,
          isFixedDeviceHeight: true,
          isListScrollingNeed: true,
          isOverLayStatusBar: false,
          appBarHeight: 100,
          appBar: appBar(),
          containChild: Stack(
            children: [
              searchedItems.isEmpty
                  ? Align(
                alignment: Alignment.center,
                child: Text(
                  AppString.noMember,
                  style: appTextStyle.noDataTextStyle(),
                ),
              )
                  : AlphabetListView(
                items: itemGroups,
                options: options,
              ),
              if (state is TeamMemberLoadingState) WorkplaceWidgets.progressLoader(context),
            ],
          ),
        );
      },
    );
  }

}
