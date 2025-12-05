import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:asetize/features/assets_management/pages/select_asset_to_assign_barcode.dart';

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

class AssetsListScreen extends StatefulWidget {
  const AssetsListScreen({super.key});

  @override
  State<AssetsListScreen> createState() => _AssetsListScreenState();
}

class _AssetsListScreenState extends State<AssetsListScreen>
    with TickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final RefreshController _refreshControllerAssets = RefreshController(initialRefresh: false);
  final RefreshController _refreshControllerLiability = RefreshController(initialRefresh: false);
  final ScrollController _scrollControllerAssets = ScrollController();
  final ScrollController _scrollControllerLiability = ScrollController();
  bool isFirstLoad = true;
  String selectedCategoryName = "All Categories";
  int? selectedCategoryId;
  String selectedVendorName = "All Vendors";
  int? selectedVendorId;
  String selectedStatus = "All Statuses";
  bool _areFiltersDirty = false;
  bool isShowLoader = true;
  late AssetsManagementBloc assetsManagementBloc;
  late TabController tabController;
  int tabInitialIndex = 0;
  void _markFiltersAsDirty() {
    if (!_areFiltersDirty) {
      setState(() => _areFiltersDirty = true);
    }
  }

  void _clearFiltersDirtyFlag() {
    _areFiltersDirty = false;
  }

  String _toApiFormat(String? value) {
    if (value == null || value.isEmpty) return "";
    if (value.toLowerCase().startsWith("all")) return "";
    return value.toLowerCase().replaceAll(" ", "_");
  }
  // Reset all filters & search
  void _resetFiltersAndSearch() {
    controller.clear();
    selectedCategoryName = "All Categories";
    selectedCategoryId = null;
    selectedVendorName = "All Vendors";
    selectedVendorId = null;
    selectedStatus = "All Statuses";
    _clearFiltersDirtyFlag();
  }
  // Apply Filters - Assets Tab
  void _applyFiltersForAssets({int pageKey = 1, bool isClearAssetList = false}) {
    assetsManagementBloc.add(OnGetAssetListEvent(
      assetCategoryId: selectedCategoryId,
      vendorId: selectedVendorId,
      status: _toApiFormat(selectedStatus),
      search: controller.text.trim(),
      isClearAssetList: isClearAssetList,
      nextPageKey: pageKey,
    ));
  }
  // Apply Filters - My Liability Tab
  void _applyFiltersForLiability({int pageKey = 1, bool isClearAssetList = false}) {
    assetsManagementBloc.add(OnGetMyLiabilityListEvent(
      assetCategoryId: selectedCategoryId,
      vendorId: selectedVendorId,
      status: _toApiFormat(selectedStatus),
      search: controller.text.trim(),
      isClearAssetList: isClearAssetList,
      nextPageKey: pageKey,
      myLiability: 1,
    ));
  }

  void _onRefreshAssets() async {
    isShowLoader = false;
    _applyFiltersForAssets(isClearAssetList: true);
    await Future.delayed(const Duration(milliseconds: 100));
    _refreshControllerAssets.refreshCompleted();
  }

  void _onRefreshLiability() async {
    isShowLoader = false;
    _applyFiltersForLiability(isClearAssetList: true);
    await Future.delayed(const Duration(milliseconds: 100));
    _refreshControllerLiability.refreshCompleted();
  }

  void _onLoadMoreAssets() async {
    if (assetsManagementBloc.nextPageUrl.isNotEmpty) {
      assetsManagementBloc.isPaginateLoading = true;
      isShowLoader = false;
      _applyFiltersForAssets(pageKey: assetsManagementBloc.currentPage + 1);
      await Future.delayed(const Duration(milliseconds: 100));
      _refreshControllerAssets.loadComplete();
    } else {
      _refreshControllerAssets.loadNoData();
    }
  }

  void _onLoadMoreLiability() async {
    if (assetsManagementBloc.nextPageUrlLiability.isNotEmpty) {
      assetsManagementBloc.isPaginateLoading = true;
      isShowLoader = false;
      _applyFiltersForLiability(pageKey: assetsManagementBloc.currentPageLiability + 1);
      await Future.delayed(const Duration(milliseconds: 100));
      _refreshControllerLiability.loadComplete();
    } else {
      _refreshControllerLiability.loadNoData();
    }
  }

  void notFoundBarcodePopup(CheckBarcodeDoneState state) {
    showDialog(
      context: context,
      builder: (context) => WorkplaceWidgets.productNotFound(
        title: AppString.productNotFoundTitle,
        content: AppString.productNotFoundContent(state.barcode),
        buttonName1:  AppString.cancel,
        buttonName2: AppString.addNewItem,
        buttonName3: AppString.assignToExistingItem,
        onPressedButton1: () => Navigator.pop(context),
        onPressedButton2: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            SlideLeftRoute(widget: AddAssetScreen(barcode: state.barcode)),
          ).then((value) {
            if (value == true) {
              _applyFiltersForAssets(isClearAssetList: true);
            }
          });
        },
        onPressedButton3: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            SlideLeftRoute(widget: SelectAssetToAssignBarcodeScreen(barcode: state.barcode)),
          ).then((value) {
            if (value == true) {
              _applyFiltersForAssets(isClearAssetList: true);
            }
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isFirstLoad = true;
    assetsManagementBloc = BlocProvider.of<AssetsManagementBloc>(context);
    assetsManagementBloc.add(OnGetAssetFilterList());
    assetsManagementBloc.activeAssetList.clear();
    assetsManagementBloc.liabilityAssetList.clear();
    _applyFiltersForAssets(isClearAssetList: true);
    _applyFiltersForLiability(isClearAssetList: true);
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        final newIndex = tabController.index;
        if (newIndex != tabInitialIndex) {
          final bool shouldReset = _areFiltersDirty;

          setState(() {
            tabInitialIndex = newIndex;
            if (shouldReset) {
              _resetFiltersAndSearch();
            }
          });

          // Reload only if reset happened OR first load
          if (shouldReset || assetsManagementBloc.activeAssetList.isEmpty) {
            if (tabInitialIndex == 0) {
              _applyFiltersForAssets(isClearAssetList: true);
            } else {
              _applyFiltersForLiability(isClearAssetList: true);
            }
          }

          if (shouldReset) {
            _clearFiltersDirtyFlag();
          }
        }
      }
    });
    _scrollControllerAssets.addListener(() {
      if (_scrollControllerAssets.position.pixels >=
          _scrollControllerAssets.position.maxScrollExtent * 0.4) {
        _onLoadMoreAssets();
      }
    });
    _scrollControllerLiability.addListener(() {
      if (_scrollControllerLiability.position.pixels >=
          _scrollControllerLiability.position.maxScrollExtent * 0.4) {
        _onLoadMoreLiability();
      }
    });
  }

  @override
  void dispose() {
    _scrollControllerAssets.dispose();
    _scrollControllerLiability.dispose();
    _refreshControllerAssets.dispose();
    _refreshControllerLiability.dispose();
    tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget searchBar() {
    return CommonSearchBar(
      controller: controller,
      onChangeTextCallBack: (_) {
        _markFiltersAsDirty();
        tabInitialIndex == 0
            ? _applyFiltersForAssets(isClearAssetList: true)
            : _applyFiltersForLiability(isClearAssetList: true);
      },
      onClickCrossCallBack: () {
        if (controller.text.isNotEmpty) {
          controller.clear();
          _markFiltersAsDirty();
          FocusScope.of(context).unfocus();
          tabInitialIndex == 0
              ? _applyFiltersForAssets(isClearAssetList: true)
              : _applyFiltersForLiability(isClearAssetList: true);
        }
      },
      onClickScannerCallBack: () async {
        var res = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SimpleBarcodeScannerPage(
              barcodeAppBar: BarcodeAppBar(
                appBarTitle: AppString.scanBarcode,
                centerTitle: true,
                enableBackButton: true,
                backButtonIcon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
              ),
            ),
          ),
        );
        if (res is String && res.isNotEmpty && res != '-1') {
          assetsManagementBloc.add(OnCheckBarcodeEvent(mContext: context, barcode: res));
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
                final list = assetsManagementBloc.categories ?? [];
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  builder: (_) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: CommonFilterBottomSheet(
                      title: AppString.selectCategoryTitle,
                      icon: Icons.category,
                      options: ["All Categories", ...list.map((e) => e.title ?? '').toList()],
                      selectedOption: selectedCategoryName,
                      onApply: (val) {
                        setState(() {
                          selectedCategoryName = val;
                          selectedCategoryId = val == "All Categories"
                              ? null
                              : list.firstWhere((e) => e.title == val, orElse: () => list[0]).id;
                        });
                        _markFiltersAsDirty();
                        tabInitialIndex == 0
                            ? _applyFiltersForAssets(isClearAssetList: true)
                            : _applyFiltersForLiability(isClearAssetList: true);
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
                final list = assetsManagementBloc.vendors ?? [];
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  builder: (_) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: CommonFilterBottomSheet(
                      title: AppString.selectVendorTitle,
                      icon: Icons.person_2_outlined,
                      options: ["All Vendors", ...list.map((e) => e.name ?? '').toList()],
                      selectedOption: selectedVendorName,
                      onApply: (val) {
                        setState(() {
                          selectedVendorName = val;
                          selectedVendorId = val == "All Vendors"
                              ? null
                              : list.firstWhere((e) => e.name == val, orElse: () => list[0]).id;
                        });
                        _markFiltersAsDirty();
                        tabInitialIndex == 0
                            ? _applyFiltersForAssets(isClearAssetList: true)
                            : _applyFiltersForLiability(isClearAssetList: true);
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
                final statusList = assetsManagementBloc.statuses?.values.toList() ?? [];
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  builder: (_) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: CommonFilterBottomSheet(
                      title: AppString.selectStatusTitle,
                      icon: Icons.info_outline,
                      options: ["All Statuses", ...statusList],
                      selectedOption: selectedStatus,
                      onApply: (val) {
                        setState(() => selectedStatus = val);
                        _markFiltersAsDirty();
                        tabInitialIndex == 0
                            ? _applyFiltersForAssets(isClearAssetList: true)
                            : _applyFiltersForLiability(isClearAssetList: true);
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

  Widget assetsTabView(AssetsManagementState state) {
    final list = assetsManagementBloc.activeAssetList;
    return SmartRefresher(
      controller: _refreshControllerAssets,
      enablePullDown: true,
      enablePullUp: assetsManagementBloc.nextPageUrl.isNotEmpty,
      onRefresh: _onRefreshAssets,
      onLoading: _onLoadMoreAssets,
      footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
      child: list.isEmpty && state is! GetAssetListLoadingState && state is! MyLiabilityListLoadingState
          ? SizedBox(
        height: MediaQuery.of(context).size.height / 2.3,
        child: Center(child: Text(AppString.noAssetFound, style: appStyles.noDataTextStyle())),
      )
          : ListView.builder(
        controller: _scrollControllerAssets,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        itemCount: list.length,
        itemBuilder: (_, index) {
          final asset = list[index];
          return AssetCardView(
            assetName: asset.title ?? '',
            category: projectUtil.formatForDisplay(asset.status ?? ''),
            vendor: asset.vendor?.name ?? '',
            purchaseDate: asset.registrationDateDisplay ?? '',
            warrantyDate: asset.warrantyDateDisplay ?? '',
            assignedTo: asset.assign?.name,
            assetLocation: asset.location,
            isShowBarcode: asset.isBarcode ?? false,
            onViewDetail: () {
              Navigator.push(
                context,
                SlideLeftRoute(widget: AssetsListDetailScreen(isShowBottomButtons: true, assetId: asset.id ?? 0)),
              ).then((value) {
                if (value == true) {
                  setState(() {
                    isShowLoader = false;
                  });
                  _applyFiltersForLiability(isClearAssetList: true);
                }
              });
            },
            onTab: () {},
            isAssigned: asset.assign != null,
          );
        },
      ),
    );
  }

  Widget myLiabilityTabView(AssetsManagementState state) {
    final list = assetsManagementBloc.liabilityAssetList;
    return SmartRefresher(
      controller: _refreshControllerLiability,
      enablePullDown: true,
      enablePullUp: assetsManagementBloc.nextPageUrlLiability.isNotEmpty,
      onRefresh: _onRefreshLiability,
      onLoading: _onLoadMoreLiability,
      footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
      child: list.isEmpty && state is! GetAssetListLoadingState && state is! MyLiabilityListLoadingState
          ? SizedBox(
        height: MediaQuery.of(context).size.height / 2.3,
        child: Center(child: Text(AppString.noLiabilityAssetsFound, style: appStyles.noDataTextStyle())),
      )
          : ListView.builder(
        controller: _scrollControllerLiability,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        itemCount: list.length,
        itemBuilder: (_, index) {
          final asset = list[index];
          return AssetCardView(
            assetName: asset.title ?? '',
            category: projectUtil.formatForDisplay(asset.status ?? ''),
            vendor: asset.vendor?.name ?? '',
            purchaseDate: asset.registrationDateDisplay ?? '',
            warrantyDate: asset.warrantyDateDisplay ?? '',
            assignedTo: asset.assign?.name,
            assetLocation: asset.location,
            isShowBarcode: asset.isBarcode ?? false,
            showButtons: true,
            buttonName: AppString.sendReminder,
            buttonIcon: Icons.send,
            onViewDetail: () {
              Navigator.push(
                context,
                SlideLeftRoute(widget: AssetsListDetailScreen(isShowBottomButtons: false, assetId: asset.id ?? 0, isComingFromMyLiability: true,)),
              );
            },
            onTab: () {
              assetsManagementBloc.add(OnSendAssetAcceptReminderEvent(assetId: asset.id ?? 0));
            },
            isAssigned: asset.assign != null,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canManageAssets = AppPermission.instance.canPermission(AppString.manageAssetsCreate, context: context);
    return BlocBuilder<AssetsManagementBloc, AssetsManagementState>(
      bloc: assetsManagementBloc,
      builder: (context, state) {
      return ContainerFirst(
       contextCurrentView: context,
       isSingleChildScrollViewNeed: false,
       isFixedDeviceHeight: false,
       isListScrollingNeed: true,
       isOverLayStatusBar: false,
       appBarHeight: 56,
       appBar: CommonAppBar(
        title: AppString.assetsManagement,
        isHideBorderLine: true,
        action: canManageAssets
            ? IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAssetScreen()),
          ).then((value) {
            if (value == true) {
              _applyFiltersForAssets(isClearAssetList: true);
            }
          }),
          icon: Container(
            decoration: BoxDecoration(color: AppColors.appBlueColor.withOpacity(0.15), shape: BoxShape.circle),
            padding: const EdgeInsets.all(5),
            child: const Icon(Icons.add, size: 20, color: AppColors.appBlueColor),
          ),
        )
            : null,
      ),
      containChild: BlocListener<AssetsManagementBloc, AssetsManagementState>(
        listener: (context, state) {
          if (state is CheckBarcodeErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is GetAssetListErrorState ) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          } if (state is MyLiabilityListErrorState ) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is SendAssetAcceptReminderErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is SendAssetAcceptReminderDoneState) {
            WorkplaceWidgets.successToast(state.message);
          }

          if (state is GetAssetListDoneState || state is MyLiabilityListDoneState) {
            if (isFirstLoad) {
              setState(() {
                isFirstLoad = false;
              });
            }
          }

          if (state is CheckBarcodeDoneState) {
            WorkplaceWidgets.successToast(state.message);

          if (state.isAssign == false) {
              notFoundBarcodePopup(state);
            } else {
              Navigator.push(
                context,
                SlideLeftRoute(widget: AssetsListDetailScreen(assetId: state.assetId ?? 0)),
              );
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
                    const SizedBox(height: 8),
                    TabBar(
                      controller: tabController,
                      labelColor: AppColors.appBlueColor,
                      labelPadding: const EdgeInsets.only(bottom: 10),
                      indicatorColor: AppColors.appBlueColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 4,
                      unselectedLabelColor: AppColors.greyUnselected,
                      tabs: [
                        Text(AppString.assetsTab, style: appStyles.tabTextStyle()),
                        Text(AppString.myLiabilityTab, style: appStyles.tabTextStyle()),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          assetsTabView(state),
                          myLiabilityTabView(state),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isFirstLoad && (state is GetAssetListLoadingState || state is MyLiabilityListLoadingState || state is SendAssetAcceptReminderLoadingState) && isShowLoader)
                  TaskFullPageShimmer()
                else if (!isFirstLoad &&
                    (state is GetAssetListLoadingState || state is MyLiabilityListLoadingState || state is SendAssetAcceptReminderLoadingState) && isShowLoader)
                  WorkplaceWidgets.progressLoader(context)
              ],
            );
          },
        ),
      ),
      bottomMenuView: AppPermission.instance.canPermission(AppString.manageAssetsScan, context: context) && assetsManagementBloc.activeAssetList.isNotEmpty
          ? CommonCenterBarcodeScannerButton(
        onPressed: () async {
          var res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SimpleBarcodeScannerPage(
                barcodeAppBar: BarcodeAppBar(
                  appBarTitle: AppString.scanBarcode,
                  centerTitle: true,
                  enableBackButton: true,
                  backButtonIcon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
              ),
            ),
          );
          if (res is String && res.isNotEmpty && res != '-1') {
            assetsManagementBloc.add(OnCheckBarcodeEvent(mContext: context, barcode: res));
          }
        },
      )
          : const SizedBox(),
    );
  },
);
  }
}