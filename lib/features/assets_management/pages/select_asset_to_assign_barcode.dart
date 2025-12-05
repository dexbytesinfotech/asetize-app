import 'package:asetize/features/booking/pages/new_booking_request.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_search_bar.dart';
import '../../follow_up/widgets/common_filter_bottomSheet.dart';
import '../../follow_up/widgets/filter_chip_widget.dart';
import '../bloc/assets_management_bloc.dart';
import '../bloc/assets_management_event.dart';
import '../bloc/assets_management_state.dart';
import '../widgets/assets_card_view.dart';

class SelectAssetToAssignBarcodeScreen extends StatefulWidget {
  final String? barcode;
  const SelectAssetToAssignBarcodeScreen({super.key, this.barcode});

  @override
  State<SelectAssetToAssignBarcodeScreen> createState() =>
      _SelectAssetToAssignBarcodeScreenState();
}

class _SelectAssetToAssignBarcodeScreenState
    extends State<SelectAssetToAssignBarcodeScreen> {
  TextEditingController controller = TextEditingController();
  bool isShowLoader = true;
  String selectedCategoryName = "All Categories";
  int? selectedCategoryId;
  final ScrollController scrollController = ScrollController();
  final RefreshController _refreshControllerForActiveTask = RefreshController(initialRefresh: false);
  String selectedVendorName = "All Vendors";
  int? selectedVendorId;
  String selectedStatus = "All Statuses";
  String selectedDate = "All Dates";
  late AssetsManagementBloc assetsManagementBloc;

  final Set<int> selectedAssetIds = {};

  String _toApiFormat(String? value) {
    if (value == null || value.isEmpty) return "";
    if (value.toLowerCase().startsWith("all")) return "";
    if (value.toLowerCase().replaceAll(" ", "_") == "work_order") {
      return "work_order";
    }
    return value.toLowerCase().replaceAll(" ", "_");
  }

  void applyAssetFilters([bool isClearAssetsList = false, int pageKey = 1]) {
    assetsManagementBloc.add(
      OnGetUnassignedBarcodesAssetsList(
          assetCategoryId: selectedCategoryId,
          vendorId: selectedVendorId,
          status: _toApiFormat(selectedStatus),
          search: controller.text.toLowerCase(),
          isClearAssetList: isClearAssetsList,
          nextPageKeyForAssignBarcode: pageKey),
    );
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
    if (assetsManagementBloc.nextPageUrlForAssignBarcodeScreen.isNotEmpty) {
      isShowLoader = false;
      assetsManagementBloc.isPaginateLoadingForAssignBarcodeScreen = true;
      applyAssetFilters(
          false, assetsManagementBloc.currentPageForAssignBarcodeScreen + 1);
      await Future.delayed(const Duration(milliseconds: 100));
      _refreshControllerForActiveTask.loadComplete();
    } else {
      _refreshControllerForActiveTask.loadNoData();
    }
  }

  @override
  void initState() {
    assetsManagementBloc = BlocProvider.of<AssetsManagementBloc>(context);
    final list = assetsManagementBloc.unassignedBarcodesAssetsList;
    list.clear();
    applyAssetFilters();
    scrollController.addListener(_scrollListener);
    super.initState();
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
            applyAssetFilters();
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
                      height: MediaQuery.of(ctx).size.height * 0.6,
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

                  // 🔹 Convert Map values to a list dynamically
                  final statusList = [
                    if (statuses != null)
                      ...statuses.values.map((e) => e.toString())
                  ];

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
                        title: AppString.selectStatusTitle,
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

    Widget assetsCardView(state) {
      final assetList = assetsManagementBloc.unassignedBarcodesAssetsList ?? [];
      return assetList.isEmpty &&
              state is! GetUnassignedBarcodesAssetsLoadingState
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 2.3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (state is GetUnassignedBarcodesAssetsLoadingState)
                          ? ''
                          : AppString.noAssetFound,
                      style: appStyles.noDataTextStyle(),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: SmartRefresher(
                controller: _refreshControllerForActiveTask,
                enablePullDown: true,
                enablePullUp: assetsManagementBloc
                        .nextPageUrlForAssignBarcodeScreen.isNotEmpty ==
                    true,
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
                    final isSelected = selectedAssetIds.contains(asset.id);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 0),
                      child: AssetCardView(
                        side: isSelected
                            ? BorderSide(
                                color: AppColors.textDarkGreenColor, width: 2)
                            : BorderSide(color: Colors.transparent, width: 2),
                        assetName: asset.title ?? '',
                        category: asset.status.toString().capitalize() ?? '',
                        vendor: asset.vendor?.name.toString() ?? '',
                        purchaseDate: asset.registrationDateDisplay ?? '',
                        warrantyDate: asset.warrantyDateDisplay ?? '',
                        assignedTo: asset.assign?.name,
                        onViewDetail: () {
                          setState(() {
                            selectedAssetIds.clear();
                            if (!isSelected) {
                              selectedAssetIds
                                  .add(asset.id ?? 0); // Select the new one
                            }
                          });
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

    Widget bottomViewForCancelAndAssignStatus() {
      return BlocBuilder<AssetsManagementBloc, AssetsManagementState>(
        bloc: assetsManagementBloc,
        builder: (context, state) {
          final assetDetailData =
              assetsManagementBloc.unassignedBarcodesAssetsList;
          bool isAnySelected = selectedAssetIds.isNotEmpty;
          return assetDetailData.isEmpty
              ? SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 0, left: 17, right: 17, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: AppButton(
                                buttonName: AppString.cancel,
                                buttonColor: Colors.white,
                                buttonBorderColor: Colors.grey,
                                textStyle: appTextStyle.appTitleStyle(
                                    color: Colors.black),
                                flutterIcon: Icons.close_rounded,
                                iconColor: Colors.black,
                                isShowIcon: true,
                                isLoader: false,
                                backCallback: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: AppButton(
                                buttonName: AppString.assignBarcode,
                                buttonColor: isAnySelected
                                    ? AppColors.textBlueColor
                                    : Colors.grey.shade400,
                                textStyle: appTextStyle.appTitleStyle(
                                    color: AppColors.white),
                                flutterIcon: Icons.qr_code_2_outlined,
                                iconColor: AppColors.white,
                                isShowIcon: true,
                                isLoader:
                                    state is AssignBarcodeToAssetLoadingState,
                                backCallback: isAnySelected
                                    ? () {
                                        assetsManagementBloc.add(
                                          OnAssignBarcodeToAsset(
                                            barcode: widget.barcode ?? "",
                                            productId: selectedAssetIds.first,
                                          ),
                                        );
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
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
          title: AppString.assetsManagement,
          icon: WorkplaceIcons.backArrow,
          isHideBorderLine: true,
        ),
        containChild: BlocListener<AssetsManagementBloc, AssetsManagementState>(
          bloc: assetsManagementBloc,
          listener: (context, state) {
            if (state is AssignBarcodeToAssetErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            if (state is AssignBarcodeToAssetDoneState) {
              Navigator.pop(context, true);
              WorkplaceWidgets.successToast(state.message);
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
                  if (state is GetUnassignedBarcodesAssetsLoadingState &&
                      isShowLoader)
                    WorkplaceWidgets.progressLoader(context),
                ],
              );
            },
          ),
        ),
        bottomMenuView: bottomViewForCancelAndAssignStatus());
  }
}
