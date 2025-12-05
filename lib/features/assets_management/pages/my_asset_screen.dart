import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:asetize/features/assets_management/pages/select_asset_to_assign_barcode.dart';
import 'package:asetize/features/follow_up/pages/add_new_task.dart';

import '../../../app_global_components/common_floating_add_button.dart';
import '../../../core/util/app_permission.dart';
import '../../../imports.dart';
import '../../../widgets/common_search_bar.dart';
import '../../follow_up/widgets/common_filter_bottomSheet.dart';
  import '../../follow_up/widgets/filter_chip_widget.dart';
import '../../follow_up/widgets/task_shimmer.dart';
import '../bloc/assets_management_bloc.dart';
import '../bloc/assets_management_event.dart';
import '../bloc/assets_management_state.dart';
import '../widgets/assets_card_view.dart';
import 'assets_detail_screen.dart';
import 'assets_form_screen.dart';

class MyAssetScreen extends StatefulWidget {
  const MyAssetScreen({super.key});
  @override
  State<MyAssetScreen> createState() => _MyAssetScreenState();
}

class _MyAssetScreenState extends State<MyAssetScreen> {
  TextEditingController controller = TextEditingController();
  bool isShowLoader = true;
  String selectedCategoryName = "All Categories";
  int? selectedCategoryId;
  final RefreshController _refreshControllerForActiveTask =
  RefreshController(initialRefresh: false);
  final ScrollController scrollController = ScrollController();
  bool isFirstLoad = true;
  late AssetsManagementBloc assetsManagementBloc;
  String selectedVendorName = "All Vendors";
  int? selectedVendorId;
  String selectedStatus = "All Statuses";
  String selectedDate = "All Dates";

  String _toApiFormat(String? value) {
    if (value == null || value.isEmpty) return "";
    if (value.toLowerCase().startsWith("all")) return ""; // Handle "All Status" etc.
    // Special case for "Work order"
    if (value.toLowerCase().replaceAll(" ", "_") == "work_order") {
      return "work_order";
    }
    // Default: convert snake_case
    return value.toLowerCase().replaceAll(" ", "_");
  }

  void _onRefreshForActiveTask() async {
    isShowLoader = false;
    applyAssetFilters();
    await Future.delayed(const Duration(milliseconds: 100));
    _refreshControllerForActiveTask.refreshCompleted();
  }

  void _scrollListener() {
    if (scrollController.hasClients) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      final triggerScroll = maxScroll * 0.4; // 50% of scrollable area
      if (currentScroll >= triggerScroll) {
        _onLoading();
      }
    }
  }

  void _onLoading() async {
    if (assetsManagementBloc.nextPageUrl.isNotEmpty) {
      isShowLoader = false;
      assetsManagementBloc.isPaginateLoading = true;
      applyAssetFilters(false, assetsManagementBloc.currentPage + 1);
      await Future.delayed(const Duration(milliseconds: 100));
      _refreshControllerForActiveTask.loadComplete();
    } else {
      _refreshControllerForActiveTask.loadNoData();
    }
  }

  void applyAssetFilters([bool isClearAssetsList = false, int pageKey = 0]) {
    assetsManagementBloc.add(
      OnGetMyAssetListEvent(

          assetCategoryId: selectedCategoryId,
          vendorId: selectedVendorId,
          status: _toApiFormat(selectedStatus),

          search: controller.text.toLowerCase(),
          isClearAssetList: isClearAssetsList,
          nextPageKey: pageKey


      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isFirstLoad = true;
    assetsManagementBloc = BlocProvider.of<AssetsManagementBloc>(context);
    assetsManagementBloc.add(OnGetAssetFilterList());
    assetsManagementBloc.unassignedBarcodesAssetsList.clear();
   if (assetsManagementBloc.myAssetListData.isNotEmpty){
     applyAssetFilters(false);
     isShowLoader = false;
   } else {
     applyAssetFilters(true);
   }
    scrollController.addListener(_scrollListener);

  }

  @override
  Widget build(BuildContext context) {

    Widget searchBar() {
      return CommonSearchBar(
        controller: controller,
        onChangeTextCallBack: (searchText) {
          applyAssetFilters();
        },
        onClickCrossCallBack: () {
          controller.clear();
          FocusScope.of(context).unfocus();
          if (controller.text.isEmpty) {
            applyAssetFilters(true);
          }
        },
        hintText: AppString.searchAssets,
        isShowScannerIcon: false,
      );
    }

    Widget filtersRow() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChipWidget(
                label: selectedCategoryName,
                icon: Icons.category,
                onTap: () {
                  final categoryList = assetsManagementBloc.categories ?? [];
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    builder: (ctx) => SizedBox(
                      height: MediaQuery.of(ctx).size.height * 0.6,
                      child: CommonFilterBottomSheet(
                        title: AppString.selectCategoryTitle,
                        options: [
                          "All Categories",
                          ...categoryList.map((e) => e.title ?? '').toList(),
                        ],
                        selectedOption: selectedCategoryName,
                        icon: Icons.category,
                        onApply: (val) {
                          setState(() {
                            selectedCategoryName = val;

                            if (val == "All Categories") {
                              selectedCategoryId = null;
                            } else {
                              final selected = categoryList.firstWhere(
                                    (e) => e.title == val,
                                orElse: () => categoryList.first,
                              );
                              selectedCategoryId = selected.id;
                            }
                          });
                          applyAssetFilters(true);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 5),
              FilterChipWidget(
                label: selectedVendorName,
                icon: Icons.person_2_outlined,
                onTap: () {
                  final vendorList = assetsManagementBloc.vendors ?? [];

                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    builder: (ctx) => SizedBox(
                      height: MediaQuery.of(ctx).size  .height * 0.6,
                      child: CommonFilterBottomSheet(
                        title: AppString.selectVendorTitle,
                        options: [
                          "All Vendors",
                          ...vendorList.map((e) => e.name ?? '').toList(),
                        ],
                        selectedOption: selectedVendorName,
                        icon: Icons.person_2_outlined,
                        onApply: (val) {
                          setState(() {
                            selectedVendorName = val;

                            if (val == "All Vendors") {
                              selectedVendorId = null;
                            } else {
                              final selected = vendorList.firstWhere(
                                    (e) => e.name == val,
                                orElse: () => vendorList.first,
                              );
                              selectedVendorId = selected.id;
                            }
                          });
                          applyAssetFilters(true);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 5),
              FilterChipWidget(
                label: selectedStatus,
                icon: Icons.info_outline,
                onTap: () {
                  final statuses = assetsManagementBloc.statuses;
                  final statusList = [
                    if (statuses != null) ...statuses.values.map((e) => e.toString())
                  ];
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    builder: (ctx) => SizedBox(
                      height: MediaQuery.of(ctx).size.height * 0.6,
                      child: CommonFilterBottomSheet(
                        title:  AppString.selectStatusTitle,
                        options: [
                          "All Statuses",
                          ...statusList,
                        ],
                        selectedOption: selectedStatus,
                        icon: Icons.info_outline,
                        onApply: (val) {
                          setState(() {
                            selectedStatus = val;
                          });
                          applyAssetFilters(true);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    Widget  assetsCardView(state) {
      final assetList = assetsManagementBloc.myAssetListData ?? [];
      return assetList.isEmpty && state is! GetMyAssetListLoadingState
          ? SizedBox(
        height: MediaQuery.of(context).size.height / 2.3,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppString.noAssetFound,
                style: appStyles.noDataTextStyle(),
              ),
            ],
          ),
        ),
      ):

      SizedBox(
        height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
        child: SmartRefresher(
          controller: _refreshControllerForActiveTask,
          enablePullDown: true,
          enablePullUp: assetsManagementBloc.nextPageUrl.isNotEmpty == true,
          onRefresh: _onRefreshForActiveTask,
          onLoading: _onLoading,
          footer: const ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: assetList.length,
            itemBuilder: (context, index) {
              final asset = assetList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                child: AssetCardView(
                  assetName: asset.title ?? '',
                  category: "",
                  vendor: asset.vendor?.name.toString() ?? '',
                  isAssetConfirmationPending:  asset.assign?.status?.toLowerCase() == "pending" ? true: false ,
                  purchaseDate: "",
                  warrantyDate: asset.warrantyDateDisplay ?? '',
                  isShowBarcode: asset.isBarcode ?? false,
                  onViewDetail: () {
                    Navigator.push(
                      context,
                      SlideLeftRoute(
                        widget:  AssetsListDetailScreen(assetId: asset.id ?? 0, isComingFromMyAsset: true,),
                      ),
                    ).then((value) {
                      if (value == true) {
                        setState(() {
                          isShowLoader= false;
                        });
                        applyAssetFilters(true);
                      }
                    });;
                  },
                  onTab: () {},
                  isAssigned: true,
                ),
              );
            },
          ),
        ),
      );
    }

    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        isOverLayStatusBar: false,
        appBarHeight: 56,
        appBar: CommonAppBar(
          title: AppString.myAsset,
          icon: WorkplaceIcons.backArrow,
          isHideBorderLine: true,
        ),
        containChild: BlocListener<AssetsManagementBloc, AssetsManagementState>(
          bloc: assetsManagementBloc,
          listener: (context, state) {
            if (state is CheckBarcodeErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
            if (state is GetMyAssetListDoneState) {
              if (isFirstLoad) {
                setState(() {
                  isFirstLoad = false;
                });
              }
            }
          },
          child: BlocBuilder<AssetsManagementBloc, AssetsManagementState>(
            bloc: assetsManagementBloc,
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      searchBar(),
                      const SizedBox(height: 10),
                      filtersRow(),
                      assetsCardView(state),
                    ],
                  ),

                  if (isFirstLoad && (state is GetMyAssetListLoadingState) && isShowLoader )
                    TaskFullPageShimmer()
                  else if (!isFirstLoad && (state is GetMyAssetListLoadingState) && isShowLoader )
                    WorkplaceWidgets.progressLoader(context)

                ],
              );
            },
          ),
        ),
    );
  }
}
