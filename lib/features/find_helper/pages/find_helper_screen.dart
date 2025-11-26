import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_search_bar.dart';
import '../../member/pages/member_profile_bottom_sheet.dart';
import '../widgets/helper_bottom_sheet.dart';
import '../widgets/helper_card_widget.dart';
import '../bloc/find_helper_bloc.dart';
import '../models/find_helper_model.dart';
import '../widgets/common_filter_bottomsheet.dart';

class FindHelperScreen extends StatefulWidget {
  const FindHelperScreen({super.key});

  @override
  State<FindHelperScreen> createState() => _FindHelperScreenState();
}

class _FindHelperScreenState extends State<FindHelperScreen> {
  TextEditingController controller = TextEditingController();
  List<FindHelperData> searchedItems = [];
  bool isLoader = true;

  final List<String> options = [
    'Security Guard',
    'Electrician',
    'Water Tanker Driver',
    'Gas Cylinder Delivery',
    'Water Can Supplier',
    'Housekeeping Staff',
  ];

  List<String> selectedFilters = [];
  List<FindHelperData> storeFilterOption = [];
  late FindHelperBloc findHelperBloc;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    isLoader = false;
    findHelperBloc.add(FetchFindHelperDataEvent(mContext: context));
    await Future.delayed(const Duration(milliseconds: 100));
    _refreshController.refreshCompleted();
  }



  void filter(String searchText, List<FindHelperData> data) {
    List<FindHelperData> results = [];
    if (searchText.isEmpty) {
      results = data;
    } else {
      results = data
          .where((element) =>
      (element.skills?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
          (element.name?.toLowerCase().contains(searchText.toLowerCase()) ?? false))
          .toList();
    }
    setState(() {
      searchedItems = results;
    });
  }


  Widget searchBar() {
    return CommonSearchBar(
      controller: controller,
      onChangeTextCallBack:(searchText) {
        filter(searchText, findHelperBloc.findHelperData);
      },
      onClickCrossCallBack: () {
        controller.clear();
        FocusScope.of(context).unfocus();
        if (controller.text.isEmpty) {
          searchedItems = findHelperBloc.findHelperData;
        }
      },
      hintText: AppString.searchHelper,
    );
  }

  @override
  void initState() {
    findHelperBloc = BlocProvider.of<FindHelperBloc>(context);
    // if (findHelperBloc.findHelperData.isEmpty) {
    //   findHelperBloc.add(FetchFindHelperDataEvent(mContext: context));
    // }
    if (findHelperBloc.findHelperData.isEmpty)
    findHelperBloc.add(FetchFindHelperDataEvent(mContext: context));

    storeFilterOption =
        List.from(findHelperBloc.findHelperData); // Initially show all helpers

    super.initState();
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 12) {
      return "+${phoneNumber.substring(0, 2)} ${phoneNumber.substring(2, 7)} ${phoneNumber.substring(7)}";
    }
    return phoneNumber; // Return as is if it doesn't match the expected length
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<FindHelperBloc, FindHelperState>(
      builder: (context, state) {
        return  ContainerFirst(
            contextCurrentView: context,
            isSingleChildScrollViewNeed: true,
            isFixedDeviceHeight: true,
            isListScrollingNeed: true,
            isOverLayStatusBar: false,
            bottomSafeArea: true,
            isOverLayAppBar: false,
            appBarHeight: findHelperBloc.findHelperData.isNotEmpty ? 107 : 56,
            appBar: Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  const CommonAppBar(
                    title: AppString.findAHelper,
                    icon: WorkplaceIcons.backArrow,
                  ),
                  findHelperBloc.findHelperData.isNotEmpty
                      ? searchBar()
                      : const SizedBox(
                    height: 0,
                  ),
                ],
              ),
            ),
            containChild: BlocBuilder<FindHelperBloc, FindHelperState>(
              builder: (context, state) {
                if (state is FindHelperErrorState) {
                  return Center(child: Text(state.errorMessage));
                }

                if (state is FetchFindHelperDataDoneState) {
                  if (controller.text.isEmpty) {
                    searchedItems = findHelperBloc.findHelperData;
                  }
                }
                if (state is FindHelperLoadingState && isLoader) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height/2,
                    child: WorkplaceWidgets.progressLoader(context),
                  );
                }
                return SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  onRefresh: _onRefresh,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            searchedItems.isEmpty
                                ? SizedBox(
                              height: MediaQuery.of(context).size.height / 1.2,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    AppString.noHelper,
                                    style: appTextStyle.noDataTextStyle(),
                                  )
                                ],
                              ),
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 5),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: searchedItems.length,
                              itemBuilder: (context, index) {
                                final helper = searchedItems[index];
                                final contactNumberForHelper= projectUtil.formatPhoneNumberWithCountryCode(
                                  countryCode:searchedItems[index].countryCode!, // or from dynamic user input or data
                                  phoneNumber: searchedItems[index].contact!,
                                );
                                return HelperCardView(
                                  phone: contactNumberForHelper ?? "",
                                  name: helper.name ?? "",
                                  profileImageUrl: helper.profilePicture ?? "",
                                  skills: helper.skills ?? "",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ));
      },
    );



  }

  void makingWhatsAppCall(String phoneNumber) async {
    // Ensure the phone number is in international format without spaces or special characters
    var cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    var url = Uri.parse('https://wa.me/$cleanPhoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


