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

  String selectedVendorName = "All Vendors";
  int? selectedVendorId;

  String selectedStatus = "All Statuses";
  String selectedDate = "All Dates";

  final List<String> dates = [
    "All Dates",
    "Last 7 Days",
    "Last 30 Days",
    "This Year"
  ];


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
      // Next page call
      isShowLoader = false;
      assetsManagementBloc.isPaginateLoading = true;

      // 👇 Pass the next page number
      applyAssetFilters(false, assetsManagementBloc.currentPage + 1);

      await Future.delayed(const Duration(milliseconds: 100));
      _refreshControllerForActiveTask.loadComplete();
    } else {
      _refreshControllerForActiveTask.loadNoData();
    }
  }


  // void _onLoading() async {
  //   if (assetsManagementBloc.nextPageUrl.isNotEmpty) {
  //     // Next page call
  //     isShowLoader = false;
  //     assetsManagementBloc.isPaginateLoading = true;
  //     applyAssetFilters(pageKey: followUpBloc.currentPage + 1);
  //     await Future.delayed(const Duration(milliseconds: 100));
  //     _refreshControllerForActiveTask.loadComplete();
  //   }
  // }
  //



  // void _onLoadActiveTask() async {
  //   if (followUpBloc.nextPageUrl.isNotEmpty) {
  //     // Next page call
  //     isLoader = false;
  //     followUpBloc.isPaginateLoading = true;
  //     _applyFiltersForActiveTasks(pageKey: followUpBloc.currentPage + 1);
  //     await Future.delayed(const Duration(milliseconds: 100));
  //     _refreshControllerForActiveTask.loadComplete();
  //   }
  // }
  void applyAssetFilters([bool isClearAssetsList = false, int pageKey = 0]) {

    print("🔹 Applying Filters:");
    print("Category ID: $selectedCategoryId");
    print("Vendor ID: $selectedVendorId");
    print("Status: $selectedStatus");
    print("Date: $selectedDate");


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


  late AssetsManagementBloc assetsManagementBloc;

  @override
  void initState() {
    super.initState();
    assetsManagementBloc = BlocProvider.of<AssetsManagementBloc>(context);
    assetsManagementBloc.add(OnGetAssetFilterList());


    // assetsManagementBloc.add(OnGetUnassignedBarcodesAssetsList());
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




    final canManageAssetsList = AppPermission.instance.canPermission(AppString.manageAssetsCreate, context: context);





    Widget searchBar() {
      return CommonSearchBar(
        controller: controller,
        onChangeTextCallBack: (searchText) {
          applyAssetFilters();
          // Add filtering logic if needed
        },

        onClickCrossCallBack: () {
          controller.clear();
          FocusScope.of(context).unfocus();

          if (controller.text.isEmpty) {
            applyAssetFilters();

          }
        },
        onClickScannerCallBack: () async {
          var res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SimpleBarcodeScannerPage(
                barcodeAppBar: const BarcodeAppBar(
                  appBarTitle: 'Scan Barcode', // or AppString.assetsManagement
                  centerTitle: true,
                  enableBackButton: true,
                  backButtonIcon:   const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ), // or WorkplaceIcons.backArrow if it's an IconData
                ),
              ),

            ),
          );
          if (res == '-1' || res == null) {
            res = '';
          }
          if (res is String && res.isNotEmpty) {
            assetsManagementBloc.add(
                OnCheckBarcodeEvent(
                    mContext: context,
                    barcode: res
                )
            );


            // controller.text = res;
            // applyAssetFilters();
          }
        },

        hintText: AppString.searchAssets,
        isShowScannerIcon: false,
      );
    }

    Widget filters() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              /// CATEGORY FILTER
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
                        title: "Select Category",
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

              /// VENDOR FILTER
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
                        title: "Select Vendor",
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

              // / STATUS FILTER
              FilterChipWidget(
                label: selectedStatus,
                icon: Icons.info_outline,
                onTap: () {
                  final statuses = assetsManagementBloc.statuses;

                  // 🔹 Convert Map values to a list dynamically
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
                        title: "Select Status",
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

              // const SizedBox(width: 5),
              //
              // /// DATE FILTER
              // FilterChipWidget(
              //   label: selectedDate,
              //   icon: Icons.calendar_month,
              //   onTap: () {
              //     showModalBottomSheet(
              //       context: context,
              //       backgroundColor: Colors.transparent,
              //       isScrollControlled: true,
              //       shape: const RoundedRectangleBorder(
              //         borderRadius:
              //         BorderRadius.vertical(top: Radius.circular(15)),
              //       ),
              //       builder: (ctx) => SizedBox(
              //         height: MediaQuery.of(ctx).size.height * 0.6,
              //         child: CommonFilterBottomSheet(
              //           title: "Select Date",
              //           options: dates,
              //           selectedOption: selectedDate,
              //           icon: Icons.calendar_today,
              //           onApply: (val) {
              //             setState(() {
              //               selectedDate = val;
              //             });
              //             applyAssetFilters(true);
              //           },
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      );
    }

    notFoundBarcodePopup(state){

      showDialog(
        context: context,
        builder: (context) => WorkplaceWidgets.productNotFound(
            title: "Product Not Found",
            content:
            'The scanned barcode ${state.barcode} is not in the system. Would you like to assign it to an existing item or add it as a new item?',
            buttonName1: "Cancel",
            buttonName2: "Add New Item",
            buttonName3: "Assign To Existing Item",
            onPressedButton1: () => Navigator.pop(context),
            onPressedButton2: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                SlideLeftRoute(
                    widget:  AddAssetScreen(barcode: state.barcode,)
                ),
              ).then((value) {
                if (value == true) {

                  setState(() {
                    isShowLoader= false;
                  });
                  // Re-fetch list if asset added
                  applyAssetFilters();
                }
              });
              // Handle add new item
            },
            onPressedButton3: (){
              Navigator.pop(context);

              Navigator.push(
                context,
                SlideLeftRoute(
                  widget:  SelectAssetToAssignBarcodeScreen(barcode: state.barcode,),
                ),
              ).then((value) {
                if (value == true) {

                  setState(() {
                    isShowLoader= false;
                  });
                  // Re-fetch list if asset added
                  applyAssetFilters();
                }
              });;

            }
          // button1Color: Colors.grey.shade100,
          // button2Color: AppColors.appBlue,
        ),
      );
    }

    Widget   assetsCardView(state) {
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
          // enablePullUp: followUpBloc.nextPageUrl.isNotEmpty == true,
          footer: const ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
          ),
          // onRefresh: _onRefreshForActiveTask,
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
                  // assignedTo: asset.assign?.name,
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
                        // Re-fetch list if asset added
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
          // action:canManageAssetsList?
          // IconButton(
          //     onPressed: (){
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder:   (context) => const AddAssetScreen()),
          //       ).then((value) {
          //         if (value == true) {
          //
          //           setState(() {
          //             isShowLoader= false;
          //           });
          //           // Re-fetch list if asset added
          //           applyAssetFilters(true);
          //         }
          //       });
          //     },
          //     icon: Container(
          //       decoration:
          //       BoxDecoration(color: AppColors.appBlueColor.withOpacity(0.15), shape: BoxShape.circle),
          //       padding: EdgeInsets.all(5),
          //       child: Icon(
          //         Icons.add,
          //         size: 20,
          //         // blendMode: BlendMode.darken,
          //         color: AppColors.appBlueColor,
          //       ),
          //     )): SizedBox(),

        ),
        containChild: BlocListener<AssetsManagementBloc, AssetsManagementState>(
          bloc: assetsManagementBloc,
          listener: (context, state) {
            // TODO: implement listener

            if (state is CheckBarcodeErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            if (state is CheckBarcodeDoneState) {
              WorkplaceWidgets.successToast(state.message);
              if (state.isAssign == false) {
                notFoundBarcodePopup(state);
              } else {
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    widget: AssetsListDetailScreen(
                        assetId: state.assetId ?? 0
                    ),
                  ),
                );

              }}

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
                      filters(),
                      assetsCardView(state),
                    ],
                  ),
                  if (state is GetMyAssetListLoadingState && isShowLoader )

                    WorkplaceWidgets.progressLoader(context),

                ],
              );
            },
          ),
        ),



        // bottomMenuView: BlocBuilder<AssetsManagementBloc, AssetsManagementState>(
        //   bloc: assetsManagementBloc,
        //   builder: (context, state) {
        //
        //     return assetsManagementBloc.myAssetListData.isNotEmpty &&     AppPermission.instance.canPermission(AppString.manageAssetsScan, context: context)?
        //
        //     CommonCenterBarcodeScannerButton(onPressed: () async {
        //
        //       var res = await Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => SimpleBarcodeScannerPage(
        //             barcodeAppBar: const BarcodeAppBar(
        //               appBarTitle: 'Scan Barcode', // or AppString.assetsManagement
        //               centerTitle: true,
        //               enableBackButton: true,
        //               backButtonIcon:   const Icon(
        //                 Icons.arrow_back_ios_new,
        //                 color: Colors.black,
        //               ), // or WorkplaceIcons.backArrow if it's an IconData
        //             ),
        //           ),
        //
        //         ),
        //       );
        //       if (res == '-1' || res == null) {
        //         res = '';
        //       }
        //       if (res is String && res.isNotEmpty) {
        //         assetsManagementBloc.add(
        //             OnCheckBarcodeEvent(
        //                 mContext: context,
        //                 barcode: res
        //             )
        //         );
        //
        //
        //         // controller.text = res;
        //         // applyAssetFilters();
        //       }
        //
        //     },) : SizedBox();
        //   },
        // )
    );
  }
}
