import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/core/core.dart';
import 'package:asetize/features/complaints/bloc/complaint_bloc/complaint_event.dart';
import '../../../app_global_components/common_floating_add_button.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/animation/slide_left_route.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/app_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../core/util/workplace_icon.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import '../../presentation/widgets/complaint_card_view.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import '../bloc/complaint_bloc/complaint_bloc.dart';
import '../bloc/complaint_bloc/complaint_state.dart';
import '../bloc/house_block_bloc/house_block_bloc.dart';
import '../widgets/complaint_shimmer_effect.dart';
import 'apply_complaint_screen.dart';
import 'complaint_detail_screen.dart';

class ComplaintTabBarView extends StatefulWidget {
  const ComplaintTabBarView({super.key});

  @override
  State<ComplaintTabBarView> createState() => _ComplaintTabBarViewState();
}

class _ComplaintTabBarViewState extends State<ComplaintTabBarView>
    with TickerProviderStateMixin {
  late TabController tabController;
  int tabInitialIndex = 0;
  late ComplaintBloc complaintBloc;
  late HouseBlockBloc houseBlockBloc;
  RefreshController refreshController1 =
      RefreshController(initialRefresh: false);
  RefreshController refreshController2 =
      RefreshController(initialRefresh: false);
  RefreshController refreshController3 =
      RefreshController(initialRefresh: false);
  bool isPullToRefresh1 = false;
  bool isPullToRefresh2 = false;
  bool isPullToRefresh3 = false;
  bool isLoadMore = false;
  bool isLoadMore2 = false;
  bool isLoadMore3 = false;
  bool isShowLoader = true;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  final ScrollController scrollController3 = ScrollController();

void fetchInitialData() {
  // complaintBloc.complaintOpenData.clear();
  // complaintBloc.complaintInProgressData.clear();
  // complaintBloc.complaintCompletedData.clear();

  if (complaintBloc.complaintOpenData.isNotEmpty ||complaintBloc.complaintInProgressData.isNotEmpty|| complaintBloc.complaintCompletedData.isNotEmpty ){
     isLoadMore = false;
     isLoadMore2 = false;
     isLoadMore3 = false;
     isShowLoader = false;
  }

  complaintBloc.add(FetchComplaintCategoryListEvent(mContext: context));
  complaintBloc
      .add(FetchComplaintOpenDataEvent(mContext: context, status: 'open'));
  complaintBloc.add(FetchComplaintInProgressDataEvent(
      mContext: context, status: 'inprogress'));
  complaintBloc.add(FetchComplaintCompletedDataEvent(
      mContext: context, status: 'completed'));
}

  @override
  void initState() {
    super.initState();
    complaintBloc = BlocProvider.of<ComplaintBloc>(context);
    houseBlockBloc = BlocProvider.of<HouseBlockBloc>(context);
    complaintBloc.pageNew = 2;
    complaintBloc.pageInProgress = 2;
    complaintBloc.pageCompleted = 2;
    fetchInitialData();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabInitialIndex = tabController.index;
      });
    });
    complaintBloc.setPostPageEnded = false;
    scrollController.addListener(_onScroll);
    scrollController2.addListener(_onScroll2);
    scrollController3.addListener(_onScroll3);

    OneSignalNotificationsHandler.instance.refreshPage = refreshAllComplaints;

  }

  Future<void> refreshAllComplaints() async {
    await onRefresh1();
    await onRefresh2();
    await onRefresh3();
  }

  Future<void> onRefresh1() async {
    if (!isPullToRefresh1) {
      complaintBloc.setPostPageEnded = false;
      isPullToRefresh1 = true;
      isShowLoader = false;
      complaintBloc
          .add(FetchComplaintOpenDataEvent(mContext: context, status: 'open'));
      isPullToRefresh1 = false;
      refreshController1.refreshCompleted();
    }
  }

  Future<void> onRefresh2() async {
    if (!isPullToRefresh2) {
      isPullToRefresh2 = true;
      isShowLoader = false;
      complaintBloc.add(FetchComplaintInProgressDataEvent(
          mContext: context, status: 'inprogress'));
      isPullToRefresh2 = false;
      refreshController2.refreshCompleted();
    }
  }

  Future<void> onRefresh3() async {
    if (!isPullToRefresh3) {
      isPullToRefresh3 = true;
      isShowLoader = false;
      complaintBloc.add(FetchComplaintCompletedDataEvent(
          mContext: context, status: 'completed'));
      isPullToRefresh3 = false;
      refreshController3.refreshCompleted();
    }
  }

  Future<void> onLoad1() async {
    if (!complaintBloc.getPostPageEnded && !isLoadMore) {
      complaintBloc.add(
          FetchComplaintOpenOnLoadEvent(mContext: context, status: 'open'));
      await Future.delayed(const Duration(seconds: 5));
    }
    refreshController1.loadComplete();
  }

  Future<void> onLoad2() async {
    if (!complaintBloc.getPostPageEnded2 && !isLoadMore3) {
      complaintBloc.add(FetchComplaintInProgressOnLoadEvent(
          mContext: context, status: 'inprogress'));
      await Future.delayed(const Duration(seconds: 5));
    }
    refreshController2.loadComplete();
  }

  Future<void> onLoad3() async {
    if (!complaintBloc.getPostPageEnded3 && !isLoadMore3) {
      complaintBloc.add(FetchComplaintCompletedOnLoadEvent(
          mContext: context, status: 'completed'));
      refreshController3.loadComplete();
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void _onScroll() {
    if (scrollController.hasClients) {
      /// Code for load more data from API
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      final triggerScroll = maxScroll * 0.5; // 50% of scrollable area
      if (currentScroll >= triggerScroll) {
        // Trigger your onLoad or any other function
        onLoad1();
      }
    }
  }

  void _onScroll2() {
    if (scrollController2.hasClients) {
      /// Code for load more data from API
      final maxScroll = scrollController2.position.maxScrollExtent;
      final currentScroll = scrollController2.position.pixels;
      final triggerScroll = maxScroll * 0.5; // 50% of scrollable area
      if (currentScroll >= triggerScroll) {
        // Trigger your onLoad or any other function
        onLoad2();
      }
    }
  }

  void _onScroll3() {
    if (scrollController3.hasClients) {
      /// Code for load more data from API
      final maxScroll = scrollController3.position.maxScrollExtent;
      final currentScroll = scrollController3.position.pixels;
      final triggerScroll = maxScroll * 0.5; // 50% of scrollable area
      if (currentScroll >= triggerScroll) {
        // Trigger your onLoad or any other function
        onLoad3();
      }
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    refreshController1.dispose();
    refreshController2.dispose();
    refreshController3.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    scrollController2.removeListener(_onScroll);
    scrollController2.dispose();
    scrollController3.removeListener(_onScroll);
    scrollController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    newTabView(ComplaintState state) {
      return SmartRefresher(
        controller: refreshController1,
        onRefresh: onRefresh1,
        enablePullUp: !complaintBloc.getPostPageEnded,
        enablePullDown: true,
        onLoading: onLoad1,
        footer: const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        child: complaintBloc.complaintOpenData.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state is ComplaintLoadingState ? '' : 'No Data',
                        style: appStyles.noDataTextStyle()),

                    // Text((state is ComplaintLoadingState ||
                    //     state is FetchedComplaintInProgressDoneState ||
                    //     state is ComplaintCategoryDoneState ||
                    //     state is FetchedComplaintOpenDataDoneState||
                    //     state is FetchedComplaintCompletedDataDoneState
                    // ) ? '' :  'No Data', style: appStyles.noDataTextStyle()),
                  ],
                ))
            : ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.only(top: 0),
                shrinkWrap: true,
                itemCount: complaintBloc.complaintOpenData.length,
                itemBuilder: (context, index) {
                  return ComplaintCard(
                    title: complaintBloc.complaintOpenData[index].title ?? '',
                    message:
                        complaintBloc.complaintOpenData[index].content ?? '',
                    userName: complaintBloc.complaintOpenData[index].user ?? '',
                    userImageUrl:
                        complaintBloc.complaintOpenData[index].profilePhoto ??
                            '',
                    complaintImageUrl:
                        complaintBloc.complaintOpenData[index].file ?? '',
                    date:
                        complaintBloc.complaintOpenData[index].createdAt ?? '',
                    complaintType:
                        complaintBloc.complaintOpenData[index].status ?? '',
                    flatNumber: '',
                    likeCount: '150',
                    cardClickCallBack: () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                            widget: ComplaintDetailScreen(
                          complaintId:
                              complaintBloc.complaintOpenData[index].id,
                        )),
                      ).then((value) {
                        onRefresh1();
                        onRefresh2();
                        onRefresh3();
                      });
                    },
                  );
                },
              ),
      );
    }

    inProgressTabView(ComplaintState state) {
      return SmartRefresher(
        controller: refreshController2,
        onRefresh: onRefresh2,
        onLoading: onLoad2,
        enablePullUp: !complaintBloc.getPostPageEnded2,
        enablePullDown: true,
        footer: const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        child: complaintBloc.complaintInProgressData.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state is ComplaintLoadingState ? '' : 'No Data',
                        style: appStyles.noDataTextStyle()),
                  ],
                ))
            : ListView.builder(
                controller: scrollController2,
                padding: const EdgeInsets.only(top: 0),
                shrinkWrap: true,
                itemCount: complaintBloc.complaintInProgressData.length,
                itemBuilder: (context, index) {
                  return ComplaintCard(
                    title: complaintBloc.complaintInProgressData[index].title ??
                        '',
                    message:
                        complaintBloc.complaintInProgressData[index].content ??
                            '',
                    userName:
                        complaintBloc.complaintInProgressData[index].user ?? '',
                    userImageUrl: complaintBloc
                            .complaintInProgressData[index].profilePhoto ??
                        '',
                    complaintImageUrl:
                        complaintBloc.complaintInProgressData[index].file ?? '',
                    date: complaintBloc
                            .complaintInProgressData[index].createdAt ??
                        '',
                    complaintType:
                        complaintBloc.complaintInProgressData[index].status ??
                            '',
                    flatNumber: '',
                    likeCount: '150',
                    cardClickCallBack: () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                            widget: ComplaintDetailScreen(
                          complaintId:
                              complaintBloc.complaintInProgressData[index].id,
                        )),
                      ).then((value) {
                        onRefresh1();
                        onRefresh2();
                        onRefresh3();
                      });
                    },
                  );
                },
              ),
      );
    }

    completeTabView(ComplaintState state) {
      return SmartRefresher(
        controller: refreshController3,
        onRefresh: onRefresh3,
        onLoading: onLoad3,
        enablePullUp: !complaintBloc.getPostPageEnded3,
        enablePullDown: true,
        footer: const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        child: complaintBloc.complaintCompletedData.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state is ComplaintLoadingState ? '' : 'No Data',
                        style: appStyles.noDataTextStyle()),
                  ],
                ))
            : ListView.builder(
                controller: scrollController3,
                padding: const EdgeInsets.only(top: 0),
                shrinkWrap: true,
                itemCount: complaintBloc.complaintCompletedData.length,
                itemBuilder: (context, index) {
                  return ComplaintCard(
                    title:
                        complaintBloc.complaintCompletedData[index].title ?? '',
                    message:
                        complaintBloc.complaintCompletedData[index].content ??
                            '',
                    userName:
                        complaintBloc.complaintCompletedData[index].user ?? '',
                    userImageUrl: complaintBloc
                            .complaintCompletedData[index].profilePhoto ??
                        '',
                    complaintImageUrl:
                        complaintBloc.complaintCompletedData[index].file ?? '',
                    date:
                        complaintBloc.complaintCompletedData[index].createdAt ??
                            '',
                    complaintType:
                        complaintBloc.complaintCompletedData[index].status ??
                            '',
                    flatNumber: '',
                    likeCount: '150',
                    cardClickCallBack: () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                            widget: ComplaintDetailScreen(
                          complaintId:
                              complaintBloc.complaintCompletedData[index].id,
                        )),
                      ).then((value) {
                        onRefresh1();
                        onRefresh2();
                        onRefresh3();
                      });
                    },
                  );
                },
              ),
      );
    }

    return BlocBuilder<ComplaintBloc, ComplaintState>(
      bloc: complaintBloc,
  builder: (context, state) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isListScrollingNeed: true,
      isFixedDeviceHeight: false,
      // Set this to false to allow flexible height
      appBarHeight: 56,
      bottomSafeArea: true,
      // Ensure this is required or adjust as needed
      appBar: const CommonAppBar(
        title: AppString.complaintsAppBarHeading,
        icon: WorkplaceIcons.backArrow,
        isHideBorderLine: true,
      ),
      containChild: BlocListener<ComplaintBloc, ComplaintState>(
        bloc: complaintBloc,
        listener: (BuildContext context, ComplaintState state) {
          if (state is ComplaintErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
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
                    'New',
                    style: appStyles.tabTextStyle(),
                  ),
                  Text(
                    'In Progress',
                    style: appStyles.tabTextStyle(),
                  ),
                  Text(
                    'Completed',
                    style: appStyles.tabTextStyle(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: BlocBuilder<ComplaintBloc, ComplaintState>(
                  bloc: complaintBloc,
                  builder: (BuildContext context, state) {
                    if (state is ComplaintInitialState) {
                      // complaintBloc.add(FetchComplaintCategoryListEvent(mContext: context));
                      // complaintBloc.add(FetchComplaintOpenDataEvent(mContext: context, status: 'open'));
                      // complaintBloc.add(FetchComplaintInProgressDataEvent(mContext: context, status: 'inprogress'));
                      // complaintBloc.add(FetchComplaintCompletedDataEvent(mContext: context, status: 'completed'));
                    }
                    if (state is OpenDataMoreLoadingState) {
                      isLoadMore = true;
                    }
                    if (state is InProgressDataMoreLoadingState) {
                      isLoadMore2 = true;
                    }
                    if (state is CompletedMoreLoadingState) {
                      isLoadMore3 = true;
                    }
                    if (state is FetchedComplaintOpenDataDoneState) {
                      isLoadMore = false;
                    }
                    if (state is FetchedComplaintInProgressDoneState) {
                      isLoadMore2 = false;
                    }
                    if (state is FetchedComplaintCompletedDataDoneState) {
                      isLoadMore3 = false;
                    }
                    // if (state is ComplaintLoadingState) {
                    //   return WorkplaceWidgets.progressLoader(context);
                    // }
                    return Stack(
                      children: [
                        TabBarView(
                          controller: tabController,
                          children: [
                            newTabView(state),
                            inProgressTabView(state),
                            completeTabView(state)
                          ],
                        ),
                        NetworkStatusAlertView(
                          onReconnect: (){
                            refreshAllComplaints();
                          },
                        ),
                        if (state is ComplaintLoadingState && isShowLoader)
                          ComplaintShimmerEffect()
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),

      bottomMenuView: AppPermission.instance
              .canPermission(AppString.complaintAdd, context: context) && state is !ComplaintLoadingState
          ? CommonFloatingAddButton(
              onPressed: () {
                Navigator.push(
                  context,
                  SlideLeftRoute(widget: const ApplyComplaintScreen()),
                );
              },
            )
          : const SizedBox(),
    );
  },
);
  }
}
