import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_search_bar.dart';
import '../models/add_vehicle_for_manager_model.dart';
import '../widgets/block_card_widget.dart';
import 'new_member_vehicle_list_screen.dart';

class SearchHouseNumberScreen extends StatefulWidget {
  final List<HousesListData>? housesList;

  const SearchHouseNumberScreen({super.key, this.housesList});

  @override
  State<SearchHouseNumberScreen> createState() =>
      _SearchHouseNumberScreenState();
}

class _SearchHouseNumberScreenState extends State<SearchHouseNumberScreen> {
  TextEditingController controller = TextEditingController();
  List<HousesListData> searchedHouses = [];

  @override
  void initState() {
    super.initState();
    searchedHouses = widget.housesList ?? []; // Initialize with full list
  }

  void filter(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        searchedHouses = widget.housesList ?? [];
      });
      return;
    }

    List<HousesListData> results = widget.housesList!
        .where((house) => house.houseNumber!
        .toLowerCase()
        .contains(searchText.toLowerCase()))
        .toList();

    setState(() {
      searchedHouses = results;
    });
  }

  Widget searchBar() {
    return CommonSearchBar(
      controller: controller,
      hintText: AppString.searchBlockSmall,
      onChangeTextCallBack:(searchText) {
        filter(searchText);
      },
      onClickCrossCallBack: () {
        controller.clear();
        FocusScope.of(context).unfocus();
        if (controller.text.isEmpty) {
          searchedHouses = widget.housesList ?? [];
        }
      },
    );
  }


  Widget houseList(){
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 5),
        physics: const BouncingScrollPhysics(),
        itemCount: searchedHouses.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget:  NewMemberVehicleListScreen(
                    houseNumber:  searchedHouses[index].houseNumber ?? "",
                    memberCount:  searchedHouses[index].membersCount,
                    houseId: searchedHouses[index].id.toString() ?? '', ),
                ),
              );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MemberListScreen(houseId: searchedHouses[index].id.toString()),
              //   ),
              // );
            },
            child: BlockCardView(
              membersCount:  searchedHouses[index].membersCount,
              vehiclesCount:  searchedHouses[index].vehiclesCount,
              title: searchedHouses[index].houseNumber ?? "",
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: false,
      isListScrollingNeed: true,
      appBar: const CommonAppBar(
        title: AppString.searchHouseNumber,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: Column(
        children: [
          searchBar(),
          houseList()

        ],
      ),
    );
  }
}

