import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';
import '../../../imports.dart';
import '../../presentation/widgets/app_button_common.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../widgets/common_card_view.dart';

class AssetCardView extends StatelessWidget {
  final String assetName;
  final String category;
  final String vendor;
  final String purchaseDate;
  final String warrantyDate;
  final String? assignedTo;
  final String? assetLocation;
  final String? buttonName;
  final VoidCallback? onTab;
  final VoidCallback? onViewDetail;
  final bool isAssigned;
  final bool showButtons;
  final bool isAssetConfirmationPending;
  final bool isShowBarcode;
  final BorderSide? side;

  /// NEW Dynamic Button Properties
  final IconData? buttonIcon;
  final Color? buttonColor;
  final Color? buttonBorderColor;
  final bool isLoading;

  const AssetCardView({
    super.key,
    required this.assetName,
    required this.category,
    required this.vendor,
    required this.purchaseDate,
    required this.warrantyDate,
    this.assignedTo,
    this.onTab,
    this.assetLocation,
    this.onViewDetail,
    this.buttonName,
    this.side,
    this.isAssetConfirmationPending = false,
    this.isAssigned = false,
    this.isShowBarcode = false,
    this.showButtons = false,

    /// NEW PARAMS
    this.buttonIcon,
    this.buttonColor,
    this.buttonBorderColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'completed':
          return const Color(0xFFD3D3D3);
        case "didn't pick":
          return const Color(0xFFFFE0B2);
        case 'agreed':
          return const Color(0xFFC8E6C9);
        case 'follow up':
          return const Color(0xFFBBDEFB);
        case 'open':
          return const Color(0xFFFFCDD2);
        case 'all status':
          return const Color(0xFFE0F7FA);
        case 'cancelled':
          return const Color(0xFFF8BBD0);
        case 'approved':
          return const Color(0xFFC8E6C9);
        case 'rejected':
          return const Color(0xFFFFCDD2);
        case 'pending':
          return const Color(0xFFFFF9C4);

      /// ----------------- Asset Status -----------------
        case 'available':
          return const Color(0xFFBBDEFB);
        case 'not available':
          return const Color(0xFFFFCDD2);
        case 'assigned':
          return const Color(0xFFD1C4E9);
        case 'defected':
          return const Color(0xFFFFAB91);
        case 'under maintenance':
          return const Color(0xFFFFF59D);
        case 'lost':
          return const Color(0xFFB3E5FC);
        case 'non functional':
          return const Color(0xFFBDBDBD);
        default:
          return const Color(0xFFE0E0E0);
      }
    }

    Color getStatusTextColor(String status) {
      switch (status.toLowerCase()) {
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
          return Colors.red;
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
          return Colors.lightBlue.shade900;
        case 'non functional':
          return Colors.grey.shade900;
        default:
          return Colors.black87;
      }
    }

    return GestureDetector(
      onTap: onViewDetail,
      child: CommonCardView(
        side: side,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Asset Name and Category Row ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      assetName,
                      style: appTextStyle.appTitleStyle2(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  category.isNotEmpty?
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(category),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category.isNotEmpty
                            ? category[0].toUpperCase() + category.substring(1)
                            : '',
                        style: appTextStyle.appTitleStyle(
                          color: getStatusTextColor(category),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ): isAssetConfirmationPending? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: SvgPicture.asset(
                      'assets/images/asset_confirmation_pending.svg',
                      width: 20,
                      height: 20,
                    ),
                  ): SizedBox()
                ],
              ),

              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.store_outlined, size: 18, color: Colors.black),
                      const SizedBox(width: 5),
                      Text(
                        "Vendor: $vendor",
                        style: appTextStyle.appSubTitleStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  if (isShowBarcode)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      child: SvgPicture.asset(
                        'assets/images/barcode-scan-icon.svg',
                        width: 18,
                        height: 18,
                      ),
                    )
                ],
              ),

              SizedBox(height: isShowBarcode ? 2 : 5),

              if (purchaseDate.isNotEmpty)
                Row(
                  children: [
                    const SizedBox(width: 1),

                    const Icon(Icons.calendar_month, size: 16, color: Colors.black),
                    const SizedBox(width: 5),
                    Text(
                      "Purchase: $purchaseDate",
                      style: appTextStyle.appSubTitleStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

              SizedBox(height: warrantyDate.isNotEmpty ? 3 : 0),

              if (warrantyDate.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.verified, size: 16, color: Colors.black),
                    const SizedBox(width: 5),
                    Text(
                      "Warranty: $warrantyDate",
                      style: appTextStyle.appSubTitleStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

              SizedBox(height: assignedTo != null  ? 3 : 0),

              if (assignedTo != null && assignedTo!.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person_2_outlined, size: 20, color: Colors.black),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        "Assigned to: $assignedTo",
                        style: appTextStyle.appSubTitleStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

              SizedBox(height: assetLocation != null ? 4 : 0),

              if (assetLocation != null && assetLocation!.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: Colors.black),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        "Asset location: $assetLocation",
                        style: appTextStyle.appSubTitleStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

              if (showButtons) const SizedBox(height: 5),

              /// ================== BUTTON ==================
              if (showButtons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AppButton(
                        buttonWidth: 100,
                        buttonHeight: 35,

                        /// Dynamic Loader
                        isLoader: isLoading,

                        /// Dynamic Text
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        buttonName: buttonName,

                        /// Dynamic Colors
                        buttonColor: buttonColor ?? AppColors.appBlueColor,
                        buttonBorderColor: buttonBorderColor ?? Colors.grey,

                        /// Dynamic Icon
                        flutterIcon: buttonIcon ?? Icons.person_add_alt_1_outlined,
                        isShowIcon: true,
                        iconSize: const Size(18, 18),

                        /// Callback
                        backCallback: onTab ?? () {},
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
