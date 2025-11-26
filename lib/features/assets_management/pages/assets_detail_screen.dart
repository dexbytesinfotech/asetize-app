import 'package:asetize/features/booking/pages/new_booking_request.dart';

import '../../../app_global_components/common_floating_add_button.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/commonTitleRowWithIcon.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../widgets/common_card_view.dart';
import '../../../widgets/common_detail_view_row.dart';
import '../../../widgets/common_search_bar.dart';
import '../../follow_up/widgets/common_filter_bottomSheet.dart';
import '../../follow_up/widgets/filter_chip_widget.dart';
import '../bloc/assets_management_bloc.dart';
import '../bloc/assets_management_event.dart';
import '../bloc/assets_management_state.dart';
import '../widgets/assets_card_view.dart';
import 'assets_form_screen.dart';

class AssetsListDetailScreen extends StatefulWidget {
  final int assetId;
  final bool isShowBottomButtons;
  final bool isComingFromMyLiability;
  final bool isComingFromMyAsset;
  const AssetsListDetailScreen({super.key, required this.assetId, this.isShowBottomButtons = false, this.isComingFromMyAsset= false, this.isComingFromMyLiability = false});

  @override
  State<AssetsListDetailScreen> createState() => _AssetsListScreenState();
}

class _AssetsListScreenState extends State<AssetsListDetailScreen> {
  late AssetsManagementBloc assetsManagementBloc;

  bool isShowLoader = true;
  bool isInitialLoading = false;

  @override
  void initState() {
    assetsManagementBloc = BlocProvider.of<AssetsManagementBloc>(context);
    assetsManagementBloc.assetDetailListData = null;
    assetsManagementBloc.assetsMemberListData = null;
    assetsManagementBloc.assetHistoryData.clear();


    assetsManagementBloc.add(
        OnGetAssetDetailListEvent(mContext: context, assetId: widget.assetId));

    assetsManagementBloc.add(
        OnGetAssetHistoryEvent(assetId: widget.assetId));

    assetsManagementBloc.add(OnAssetMemberListEvent(mContext: context));

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final canManageAssetsUpdateStatus = AppPermission.instance.canPermission(AppString.manageAssetsUpdateStatus, context: context);
    final canManageAssetsEdit = AppPermission.instance.canPermission(AppString.manageAssetsEdit, context: context);
    // final assetDetailData = assetsManagementBloc.assetDetailListData;

    /// ----------------- Status Color Logic -  ----------------
    /// ----------------- Status Color Logic -----------------
    /// ----------------- Status Color Logic -----------------
    Color getStatusColor(String status) {
      switch (status.toLowerCase().replaceAll("_", " ")) {
        case 'completed':
          return const Color(0xFFD3D3D3); // Light Grey
        case "didn't pick":
          return const Color(0xFFFFE0B2); // Light Orange
        case 'agreed':
          return const Color(0xFFC8E6C9); // Light Green
        case 'follow up':
          return const Color(0xFFBBDEFB); // Light Blue
        case 'open':
          return const Color(0xFFFFCDD2); // Light Red
        case 'all status':
          return const Color(0xFFE0F7FA); // Light Cyan
        case 'cancelled':
          return const Color(0xFFF8BBD0); // Light Pink
        case 'approved':
          return const Color(0xFFC8E6C9); // Softer Light Green
        case 'rejected':
          return const Color(0xFFFFCDD2); // Softer Light Red
        case 'pending':
          return const Color(0xFFFFF9C4); // Softer Light Yellow

        /// ----------------- Asset Status -----------------
        case 'available':
          return const Color(0xFFBBDEFB); // Light Blue
        case 'not available':
          return const Color(0xFFFFCDD2); // Light Red
        case 'assigned':
          return const Color(0xFFD1C4E9); // Soft Purple
        case 'defected':
          return const Color(0xFFFFAB91); // Light Orange-Red
        case 'under maintenance':
          return const Color(0xFFFFF59D); // Light Yellow
        case 'lost':
          return const Color(0xFFB3E5FC); // Light Sky Blue
        case 'non functional':
          return const Color(0xFFBDBDBD); // Medium Grey
        default:
          return const Color(0xFFE0E0E0); // Default Light Grey
      }
    }

    Color getStatusTextColor(String status) {
      switch (status.toLowerCase().replaceAll("_", " ")) {
        case 'completed':
          return Colors.black87;
        case "didn't pick":
          return Colors.orange;
        case 'agreed':
          return Colors.green;
        case 'follow up':
          return Colors.blue;
        case 'open':
          return Colors.red;
        case 'all status':
          return Colors.teal;
        case 'cancelled':
          return Colors.pink;
        case 'approved':
          return Colors.green;
        case 'rejected':
          return Colors.red.shade700;
        case 'pending':
          return Colors.amber.shade700;

        /// ----------------- Asset Status -----------------
        case 'available':
          return Colors.blue.shade700;
        case 'not available':
          return Colors.red.shade700;
        case 'assigned':
          return Colors.deepPurple.shade700;
        case 'defected':
          return Colors.deepOrange.shade700;
        case 'under maintenance':
          return Colors.amber.shade800;
        case 'lost':
          return Colors.lightBlue.shade900; // Dark Sky Blue
        case 'non functional':
          return Colors.grey.shade900; // Darker Grey for text
        default:
          return Colors.black87;
      }
    }

    Widget invoiceImageDisplay(List<String>? taskImages) {
      if (taskImages == null || taskImages.isEmpty) {
        return const SizedBox();
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 0, left: 0),
        padding: const EdgeInsets.only(left: 25, top: 8, right: 25, bottom: 10),
        child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 images per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1, // square tiles
          ),
          itemCount: taskImages.length,
          itemBuilder: (context, index) {
            final imageUrl = taskImages[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  FadeRoute(
                    widget: FullPhotoView(
                      title: "Invoice Image",
                      profileImgUrl: imageUrl,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => const ImageLoader(),
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade50,
                      child: const Center(
                        child: Text(
                          AppString.couldNotLoadError,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }


     confirmationAlertDialog() {
        WorkplaceWidgets.  showDynamicQuestionBottomSheet(
          context: context,

          /// QUESTION 1
          question1: "I received the asset in good condition",
          question1Options: ["Yes", "No"],
          question1RequiredSymbol: "*",

          /// QUESTION 2 (Conditional)
          question2: "Have you accepted or returned the asset?",
          question2Options: ["Accepted", "Returned"],
          question2RequiredSymbol: "*",

          /// When to show Q2
          showQuestion2When: (ans) => ans == "No",

          /// Final Callback
          onSubmit: (q1Ans, q2Ans) {
            print("Q1 Answer = $q1Ans");
            print("Q2 Answer = $q2Ans");
            assetsManagementBloc.add(
              OnAssetConfirmationEvent(
                mContext: context,
                assetId: widget.assetId,
                isGoodCondition: q1Ans,
                status: q2Ans == "Accepted"
                    ? "confirmed"
                    : q2Ans == "Returned"
                    ? "rejected"
                    : "confirmed",
              ),
            );




            // TODO: You can call your API / Bloc here
          },

          title: 'Asset Confirmation',

          titleTextStyle: null,
          question2OptionColors: {
            "Accepted": AppColors.textDarkGreenColor,
            "Returned": AppColors.textDarkRedColor
          },
          question1OptionColors: {
            "Yes": AppColors.textDarkGreenColor,
            "No": AppColors.textDarkRedColor
          },
        );
      }



    Widget assetDetailsCardView() {
      final assetDetailData = assetsManagementBloc.assetDetailListData;
      final invoiceFile = assetsManagementBloc.assetDetailListData?.invoiceFile;

      return CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20)
                .copyWith(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ----------------- Header Section -----------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFeef2ff),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFF3b82f6),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assetDetailData?.title ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Dynamic Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(
                            assetDetailData?.status?.capitalize() ?? ""),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                          projectUtil.formatForDisplay(assetDetailData?.status?.capitalize() ?? "",),

                        style: TextStyle(
                          color: getStatusTextColor(
                              assetDetailData?.status?.capitalize() ?? ""),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),

                /// ----------------- Category & Vendor Section -----------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // ✅ Keeps alignment top even for multi-line text
                  children: [
                    Expanded(
                      child: CommonDetailViewRow(
                        title: "Product Category",
                        icons: Icons.category_outlined, // ✅ Added icon
                        value: assetDetailData?.category?.name ?? "",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CommonDetailViewRow(
                        title: "Vendor Name",
                        icons:
                        Icons.store_mall_directory_outlined, // ✅ Added icon
                        value: assetDetailData?.vendor?.name ?? "",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 0),

                /// ----------------- Purchase Details Section -----------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // ✅ Keeps label aligned even for multi-line text
                  children: [
                    Expanded(
                      child: CommonDetailViewRow(
                        title: "Purchase Date",
                        icons: Icons.calendar_today_outlined,
                        value: assetDetailData?.registrationDateDisplay ?? "",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CommonDetailViewRow(
                        title: "Purchase Cost",
                        icons: Icons.attach_money,
                        value: assetDetailData?.purchaseCostDisplay ?? "",
                      ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CommonDetailViewRow(
                        title: "Barcode",
                        icons: Icons.qr_code_2_outlined,
                        value: assetDetailData?.barcode?.barcode ?? "",
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: CommonDetailViewRow(
                        title: "Label",
                        icons: Icons.label_important_outline,
                        value: assetDetailData?.barcode?.label ?? "",
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      child: CommonDetailViewRow(
                        title: "Asset Received Status",
                        icons: Icons.verified_outlined,
                        value: assetDetailData?.assign?.status?.capitalize() ?? "",
                      ),
                    ),

                    Expanded(
                      child: CommonDetailViewRow(
                        title: "Asset Location",
                        icons: Icons.location_on_outlined,
                        value: assetDetailData?.location ?? "",
                      ),
                    ),

                  ],
                ),

                if (invoiceFile != null && invoiceFile.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.image, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 7),
                      Text(
                        invoiceFile.length > 1
                            ? "Invoice Images"
                            : "Invoice Image",
                        style: appTextStyle.appSubTitleStyle2(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  invoiceImageDisplay(invoiceFile),
                ]
              ],
            )),
      );
    }

    Widget bottomViewForEditAndUpdateStatus() {
      return BlocBuilder<AssetsManagementBloc, AssetsManagementState>(
        bloc: assetsManagementBloc,
        builder: (context, state) {
          final assetDetailData = assetsManagementBloc.assetDetailListData;

          return assetDetailData == null?SizedBox():
            Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 15, left: 14, right: 14, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                  if (canManageAssetsUpdateStatus)
                        Expanded(
                        child: AppButton(
                          buttonName: 'Update Status',
                          buttonColor: Colors.white,
                          buttonBorderColor: Colors.grey,
                          textStyle:
                              appTextStyle.appTitleStyle(color: Colors.black),
                          flutterIcon: Icons.refresh,
                          iconColor: Colors.black,
                          isShowIcon: true,
                          isLoader: false,
                          borderRadius: 8,
                          backCallback: () {
                            final statuses = assetsManagementBloc.statuses;

                            // ✅ Convert Map entries into key-value pairs
                            // Example: {"available": "Available", "assigned": "Assigned"}
                            final statusMap = statuses ?? {};

                            // ✅ Extract values (for showing)
                            final statusValueList = statusMap.values
                                .map((e) => e.toString())
                                .toList();

                            WorkplaceWidgets.updateAssetStatus(
                              context: context,
                              currentStatus: projectUtil.formatForDisplay(assetDetailData?.status ?? ''),
                              statusList:
                                  statusValueList, // show only display values
                              selectedStatus: "", // optional default
                              userList:
                                  assetsManagementBloc.assetsMemberListData ??
                                      [],
                              selectedUser: null,
                              onUpdate: (selectedStatusValue, assignedUserId) {
                                // ✅ Find the key (send to backend)
                                final selectedKey = statusMap.entries
                                    .firstWhere(
                                      (entry) =>
                                          entry.value
                                              .toString()
                                              .toLowerCase() ==
                                          selectedStatusValue.toLowerCase(),
                                      orElse: () => const MapEntry('', ''),
                                    )
                                    .key;

                                // ✅ Trigger Bloc event using the key
                                assetsManagementBloc
                                    .add(OnChangeAssetStatusEvent(
                                  mContext: context,
                                  status: selectedKey,
                                  userId: assignedUserId,
                                  assetId: assetDetailData.id,
                                ));

                                Navigator.pop(context);

                                print("Display Value: $selectedStatusValue");
                                print("Key Sent: $selectedKey");
                                print("Assigned User ID: $assignedUserId");
                              },
                            );

                            print('Update Status Clicked');
                          },
                        ),
                      ),

                       SizedBox(width: (canManageAssetsUpdateStatus && !canManageAssetsEdit) || (!canManageAssetsUpdateStatus && canManageAssetsEdit) ?0:15),

                      // 🔵 Edit Button

                      if (canManageAssetsEdit)
                      Expanded(
                        child: AppButton(
                          buttonName: 'Edit',
                          buttonColor: AppColors.textBlueColor,
                          textStyle: appTextStyle.appTitleStyle(
                              color: AppColors.white),
                          flutterIcon: Icons.edit_outlined,
                          iconColor: AppColors.white,
                          isShowIcon: true,
                          isLoader: false,
                          backCallback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddAssetScreen(
                                        isEditMode: true,
                                        detailData: assetDetailData,
                                        assetId: widget.assetId,
                                      )),
                            ).then((value) {
                              if (value == true) {
                                setState(() {
                                  isShowLoader = false;
                                });
                                // Re-fetch list if asset added
                                assetsManagementBloc.add(
                                    OnGetAssetDetailListEvent(
                                        mContext: context,
                                        assetId: widget.assetId));
                              }
                            });
                            // 👉 Navigate to Edit form logic
                          },
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


    Widget bottomAssetConfirmationButton() {
      return BlocBuilder<AssetsManagementBloc, AssetsManagementState>(
        bloc: assetsManagementBloc,
        builder: (context, state) {
          final assetDetailData = assetsManagementBloc.assetDetailListData;

          return assetDetailData != null && assetDetailData.assign?.status?.toLowerCase() == "pending" ?
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 15, left: 14, right: 14, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                        Expanded(
                          child: AppButton(
                            buttonName: 'Asset Confirmation',
                            buttonColor: AppColors.textDarkGreenColor,
                            textStyle: appTextStyle.appTitleStyle(
                                color: AppColors.white),
                            flutterIcon: Icons.edit_outlined,
                            iconColor: AppColors.white,
                            isShowIcon: false,
                            isLoader: state is AssetConfirmationLoadingState ? true: false,
                            backCallback: () {
                              confirmationAlertDialog();
                              // 👉 Navigate to Edit form logic
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ):SizedBox();
        },
      );
    }

    Widget buildTimelineEntry({
      required String title,
      required String subtitle,
      required String date,
      required String author,
      required String time,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Left Timeline Icon + Line
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFBFD9FF)),
                ),
                child: const Center(
                  child: Icon(Icons.access_time,
                      size: 18, color: Color(0xFF4B74D6)),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 2,
                height: 60,
                color: const Color(0xFFF0F0F2),
              ),
            ],
          ),
          const SizedBox(width: 12),

          /// Middle Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTextStyle.appTitleStyle2(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: appTextStyle.appSubTitleStyle2(
                      color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Text(
                  "$date  •  by $author",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          /// Right Time
          SizedBox(
            width: 70,
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    // Widget productHistoryCardView(assetDetailData) {
    //   return CommonCardView(
    //     margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20)
    //           .copyWith(bottom: 10),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           /// 🔹 Title Row
    //           const CommonTitleRowWithIcon(
    //             title: 'Product History',
    //             icon: Icons.history,
    //           ),
    //           const SizedBox(height: 20),
    //
    //           /// 🔹 Timeline Entries
    //           buildTimelineEntry(
    //             title: "Status Changed",
    //             subtitle: "Status changed from 'Assigned' to 'Available'",
    //             date: "Feb 20, 2024",
    //             author: "Admin User",
    //             time: "02:30 PM",
    //           ),
    //           const Divider(height: 30, color: Color(0xFFF1F1F3)),
    //
    //           buildTimelineEntry(
    //             title: "Maintenance Completed",
    //             subtitle: "Regular maintenance and software updates completed",
    //             date: "Feb 15, 2024",
    //             author: "Tech Team",
    //             time: "10:15 AM",
    //           ),
    //           const Divider(height: 30, color: Color(0xFFF1F1F3)),
    //
    //           buildTimelineEntry(
    //             title: "Assigned",
    //             subtitle: "Asset assigned to John Doe",
    //             date: "Feb 1, 2024",
    //             author: "Admin User",
    //             time: "09:00 AM",
    //           ),
    //           const Divider(height: 30, color: Color(0xFFF1F1F3)),
    //
    //           buildTimelineEntry(
    //             title: "Registered",
    //             subtitle: "Asset added to inventory",
    //             date: "Jan 15, 2024",
    //             author: "Admin User",
    //             time: "11:30 AM",
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    Widget productHistoryCardView(AssetsManagementBloc bloc) {
      final historyList = bloc.assetHistoryData; // List<AssetHistoryData>

      return CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20)
              .copyWith(bottom: historyList.isEmpty ? 35:20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title Row
              const CommonTitleRowWithIcon(
                title: 'Product History',
                icon: Icons.history,
              ),
              const SizedBox(height: 20),

              /// If empty show message
              if (historyList.isEmpty)
                const Center(
                  child: Text(
                    "No history available",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )

              else
                ListView.builder(
                  padding: EdgeInsetsGeometry.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];

                    return Column(
                      children: [
                        buildTimelineEntry(
                          title: item.action ?? "",
                          subtitle: item.message ?? "",
                          date: item.createdAt ?? "",
                          author: item.user?.name ?? "",
                          time: item.createdTime?? "",
                        ),
                        if (index != historyList.length - 1)
                          const Divider(height: 30, color: Color(0xFFF1F1F3)),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      );
    }

    /// 🔹 Timeline Item Builder (Custom Layout)

    Widget assetInformationCardView(assetDetailData) {
      return CommonCardView(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20)
              .copyWith(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTitleRowWithIcon(
                title: 'Asset Information',
                icon: Icons.warehouse_outlined,
              ),
              SizedBox(height: 20),
              CommonDetailViewRow(
                title: "Model Number",
                icons: Icons.devices_other, // ✅ Device icon
                value: assetDetailData?.modelNumber ?? '',
              ),
              CommonDetailViewRow(
                title: "Item Code",
                icons: Icons.qr_code_2, // ✅ QR / barcode icon
                value: assetDetailData?.itemCode ?? "",
              ),
              CommonDetailViewRow(
                title: "Manufacturer",
                icons: Icons.business, // ✅ Company / manufacturer icon
                value: assetDetailData?.manufacture ?? "" ?? "",
              ),
              CommonDetailViewRow(
                title: "Warranty Months",
                icons: Icons.shield_outlined, // ✅ Warranty shield icon
                value: assetDetailData?.warrantyDateDisplay.toString() ?? "",
              ),
              CommonDetailViewRow(
                title: "Expired Date",
                icons: Icons.calendar_month, // ✅ Calendar icon
                value: assetDetailData?.expiredDateDisplay ?? "" ?? "",
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    }
    // Widget barcodeCardView(assetDetailData) {
    //   return CommonCardView(
    //     margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20)
    //           .copyWith(bottom: 10),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           // 🔹 Title with Icon
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               CommonTitleRowWithIcon(
    //                 title: 'Barcode',
    //                 icon: Icons.qr_code_2_outlined,
    //               ),
    //               Container(
    //                 margin: const EdgeInsets.only(right: 0, bottom: 0),
    //                 child: SizedBox(
    //                   width: 80,
    //                   height: 32,
    //                   child: OutlinedButton.icon(
    //                     onPressed: () {
    //
    //                     },
    //                     icon:
    //                     const Icon(Icons.print, color: Colors.black, size: 16),
    //                     label: Text(
    //                       AppString.print,
    //                       style: appStyles.userNameTextStyle(
    //                         fontSize: 13,
    //                         texColor: Colors.black,
    //                         fontWeight: FontWeight.w500,
    //                       ),
    //                     ),
    //                     style: OutlinedButton.styleFrom(
    //                       side: const BorderSide(color: Colors.grey, width: 1),
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       padding: const EdgeInsets.symmetric(
    //                           horizontal: 8, vertical: 4),
    //                       backgroundColor: Color(0xFFF5F5F5),
    //                       elevation: 0,
    //                     ),
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //
    //           const SizedBox(height: 20),
    //
    //           // 🔹 Barcode container area
    //           Container(
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               color: Colors.grey.shade50,
    //               borderRadius: BorderRadius.circular(12),
    //             ),
    //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
    //             child:
    //
    //             //
    //
    //
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 // 🔹 Asset name
    //           Image.asset("assets/images/barcode.jpg"),
    //                 SizedBox(height: 15,),
    //
    //
    //
    //                 // 🔹 Scan info text
    //                  Text(
    //                   'Scan to view details',
    //                    style: appTextStyle.appTitleStyle2(
    //                        fontWeight: FontWeight.w500),
    //                 ),
    //
    //                 const SizedBox(height: 10),
    //
    //                 // 🔹 Footer note
    //                  Text(
    //                   'Scan this code to quickly access asset information',
    //                   textAlign: TextAlign.center,
    //                   style:appTextStyle.appSubTitleStyle2(
    //                     fontSize: 13,
    //                       color: Colors.grey.shade600),
    //                 ),
    //               ],
    //             ),
    //           ),
    //
    //           const SizedBox(height: 15),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    Widget descriptionCardView(assetDetailData) {
      // Check if smallDescription is empty or null
      if (assetDetailData?.smallDescription == null ||
          assetDetailData!.smallDescription.trim().isEmpty) {
        return const SizedBox.shrink(); // Hide widget
      }

      return CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20)
              .copyWith(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonTitleRowWithIcon(
                title: 'Description',
                icon: Icons.warehouse_outlined,
              ),
              const SizedBox(height: 10),
              Text(
                assetDetailData.smallDescription,
                maxLines: 3,
                style: appTextStyle.appSubTitleStyle2(
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    }

    Widget fullDescriptionCardView(assetDetailData) {
      // Check if description is empty or null
      if (assetDetailData?.description == null ||
          assetDetailData!.description.trim().isEmpty) {
        return const SizedBox.shrink(); // Hide widget
      }

      return CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20)
              .copyWith(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonTitleRowWithIcon(
                title: 'Full Description',
                icon: Icons.warehouse_outlined,
              ),
              const SizedBox(height: 10),
              Text(
                assetDetailData.description,
                maxLines: 3,
                style: appTextStyle.appSubTitleStyle2(
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
            ],
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
          isThen: true,
          title: AppString.assetDetails,
          icon: WorkplaceIcons.backArrow,
          isHideBorderLine: true,
        ),
        containChild: BlocListener<AssetsManagementBloc, AssetsManagementState>(
          bloc: assetsManagementBloc,
          listener: (context, state) {
            if (state is AddAssetErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
            if (state is AssetMemberListErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
            if (state is GetAssetDetailListErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }     if (state is AssetConfirmationErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
            if (state is ChangeAssetStatusErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            // if (state is AddAssetCategoryErrorState) {
            //   WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            // }

            if (state is AddAssetDoneState) {
              Navigator.pop(context, true);
              WorkplaceWidgets.successToast(state.message);
            }

            // if (state is GetAssetHistoryDoneState) {
            //   WorkplaceWidgets.successToast(state.message);
            // }

            if (state is GetAssetHistoryErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }


            if (state is ChangeAssetStatusDoneState) {
              WorkplaceWidgets.successToast(state.message);
            }
          },
          child: BlocBuilder<AssetsManagementBloc, AssetsManagementState>(
            bloc: assetsManagementBloc,
            builder: (context, state) {
              if (state is ChangeAssetStatusDoneState) {
                isShowLoader = false;
                assetsManagementBloc.add(OnGetAssetDetailListEvent(
                    mContext: context, assetId: widget.assetId));
                WorkplaceWidgets.successToast(state.message);
              }

              if (state is AssetConfirmationDoneState) {
                isShowLoader = false;
                assetsManagementBloc.add(OnGetAssetDetailListEvent(
                    mContext: context, assetId: widget.assetId));
                assetsManagementBloc.add(
                    OnGetAssetHistoryEvent(assetId: widget.assetId));
                WorkplaceWidgets.successToast(state.message);
              }

              final assetDetailData = assetsManagementBloc.assetDetailListData;

              bool isInitialLoading =
                  ((state is GetAssetDetailListLoadingState ||
                          state is AssetMemberListLoadingState) &&
                      isShowLoader && assetsManagementBloc.assetDetailListData == null);
              print("isInitialLoading: $isInitialLoading");

              return Stack(
                children: [
                  if (isInitialLoading)
                    WorkplaceWidgets.progressLoader(context),
                  if (!isInitialLoading  )
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          assetDetailsCardView(),
                          // barcodeCardView(assetDetailData),
                          descriptionCardView(assetDetailData),
                          assetInformationCardView(assetDetailData),
                          fullDescriptionCardView(assetDetailData),
                          if ( AppPermission.instance.canPermission(AppString.manageAssetsHistory, context: context))
                          productHistoryCardView(assetsManagementBloc),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  if ((state is ChangeAssetStatusLoadingState) && isShowLoader)
                    WorkplaceWidgets.progressLoader(context),
                ],
              );
            },
          ),
        ),
        bottomMenuView:
        canManageAssetsUpdateStatus && canManageAssetsEdit && widget.isShowBottomButtons ?

        bottomViewForEditAndUpdateStatus():    widget.isComingFromMyLiability == false? bottomAssetConfirmationButton(): SizedBox()

    );
  }
}
