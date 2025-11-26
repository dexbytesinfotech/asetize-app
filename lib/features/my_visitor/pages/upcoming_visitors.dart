import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/features/my_visitor/pages/today_my_visitor_detail_screen.dart';
import 'package:asetize/widgets/common_search_bar.dart';
import '../../../imports.dart';
import '../bloc/my_visitor_bloc.dart';
import '../bloc/my_visitor_event.dart';
import '../bloc/my_visitor_state.dart';
import '../widgets/visitor_card_widget.dart';
import 'package:asetize/features/data/models/user_response_model.dart' as userResponse;

class UpcomingVisitorScreen extends StatefulWidget {
  const UpcomingVisitorScreen({super.key});

  @override
  State<UpcomingVisitorScreen> createState() => _UpcomingVisitorScreenState();
}

class _UpcomingVisitorScreenState extends State<UpcomingVisitorScreen> {
  final TextEditingController controller = TextEditingController();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  late HomeBloc homeBloc;
  late UserProfileBloc userProfileBloc;
  bool isShowLoader = true;
  List<userResponse.Houses> houses = [];
  // String formatVisitingType(String? visitorType) {
  //   if (visitorType == null || visitorType.isEmpty) {
  //     return '';
  //   }
  //   String formatted = visitorType.replaceAll('_', ' ').toLowerCase();
  //   return formatted[0].toUpperCase() + formatted.substring(1);
  // }
  //
  // String formatVisitingTypeForSubmission(String visitorType) {
  //   return visitorType.toLowerCase().replaceAll(' ', '_');
  // }

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  void apiCall() {
    onUnitSelect(userProfileBloc.selectedUnit);
  }

  void onUnitSelect(userResponse.Houses? house) {
    if (house != null) {
      userProfileBloc.add(OnChangeCurrentUnitEvent(selectedUnit: house));
      homeBloc.add(OnGetUpcomingVisitorsListEvent(
        mContext: context,
        houseId: userProfileBloc.selectedUnit!.id,
        status: "pre-approved",
          startTime: projectUtil.getTodayStartDateTime()
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    if (userProfileBloc.user.houses != null && userProfileBloc.user.houses!.isNotEmpty) {
      houses = userProfileBloc.user.houses ?? [];
    }
    if (homeBloc.upComingVisitorsData.isEmpty) {
      apiCall();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    refreshController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    setState(() {
      isShowLoader = false;
    });
    apiCall();
    await Future.delayed(const Duration(milliseconds: 2000));
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {



    Widget searchBar() {
      return CommonSearchBar(
         hintText: 'Search visitor',
          controller: controller,
          onChangeTextCallBack: (searchText) {
            setState(() {
              controller.text = searchText;
              homeBloc.add(OnGetUpcomingVisitorsListEvent(
                  mContext: context,
                  houseId: userProfileBloc.selectedUnit!.id,
                  status: "pre-approved",
                  search: searchText,
                  startTime: projectUtil.getTodayStartDateTime()
              ));
            });
          },
        onClickCrossCallBack: () {
          controller.clear();
          FocusScope.of(context).unfocus();
          setState(() {
            isShowLoader = false;
          });
          apiCall();
        },
      );
    }

    return BlocListener<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {
        if (state is VisitorHistoryErrorState) {
          WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
        }
        if (state is VisitorHistoryDoneState) {}
        if (state is VisitorCheckoutDoneState) {
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: homeBloc,
        builder: (context, state) {
          if (state is VisitorHistoryErrorState) {
            return WorkplaceWidgets.noDataWidget(context, state.errorMessage);
          }
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  searchBar(),
                  Expanded(
                    child: SmartRefresher(
                      onRefresh: onRefresh,
                      controller: refreshController,
                      child: homeBloc.upComingVisitorsData.isEmpty
                          ? WorkplaceWidgets.noDataWidget(
                        context,
                        state is VisitorHistoryLoadingState ? '' : 'No data found',
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 40),
                        itemCount: homeBloc.upComingVisitorsData.length,
                        itemBuilder: (context, index) {
                          final visitor = homeBloc.upComingVisitorsData[index];
                          return VisitorCardWidget(
                            preApprovedStatus:true,
                            isComingFrom: false,
                            visitorData: visitor,
                            onTab: () {
                              Navigator.push(
                                context,
                                SlideLeftRoute(
                                  widget: VisitorDetailScreen(
                                    isComingFrom: false,
                                    visitorData: visitor,
                                    isShowDeleteMenu: true,
                                  ),
                                ),
                              ).then((value) {
                                closeKeyboard();
                                if (value == true) {
                                  setState(() {
                                    isShowLoader = false;
                                  });
                                  onRefresh();
                                }
                              });
                            },
                            onInfoTab: () {
                              Navigator.push(
                                context,
                                SlideLeftRoute(
                                  widget: VisitorDetailScreen(
                                    isComingFrom: false,
                                    visitorData: visitor,
                                    isShowDeleteMenu:  true
                                  ),
                                ),
                              ).then((value) {
                                closeKeyboard();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (state is VisitorHistoryLoadingState && isShowLoader)
                WorkplaceWidgets.progressLoader(context),
            ],
          );
        },
      ),
    );
  }
}