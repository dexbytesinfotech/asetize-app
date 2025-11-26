import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_card_view.dart';

class VehicleCardWidget extends StatelessWidget {
  final String? registrationNumber;
  final String? ownerName;
  final String? vehicleType;
  final int isParkingAllotted;
  final void Function()? onLongPress;
  final void Function()? onTap;
  final Color cardColor;
  final String? blockName;
  final EdgeInsetsGeometry? margin;
  const VehicleCardWidget({
    super.key,
    this.registrationNumber,
    this.ownerName,
    this.vehicleType,
    this.onLongPress,
    this.onTap,
    required this.isParkingAllotted,
    this.cardColor = Colors.white,
    this.blockName,
    this.margin,
  });

  String vehicleTypeImage(String? vehicleType) {
    if (vehicleType == null || vehicleType.isEmpty) {
      return "assets/images/default_vehicle.svg"; // Default icon for null/empty cases
    }
    switch (vehicleType.toLowerCase()) {
      case "car":
        return "assets/images/car_vehicle.svg";
      case "bike":
        return "assets/images/bike_vehicle.svg";
      case "scooty":
        return "assets/images/scooter_vehicle.svg";
      default:
        return "assets/images/default_vehicle.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: CommonCardView(
        cardColor: cardColor ?? Colors.white, // Set card color based on status
        elevation: 0.5,
        margin:  margin ??  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                ),
                child: SvgPicture.asset(
                  vehicleTypeImage(vehicleType),
                  height: 20,
                  width: 20,
                  color: AppColors.textBlueColor,
                ),
              ),
              const SizedBox(width: 15),
              Expanded( // Prevents overflow issues
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      registrationNumber ?? "N/A",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: appTextStyle.appTitleStyle2(),
                    ),
                    Text(
                      ownerName ?? "N/A",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: appTextStyle.appSubTitleStyle2(),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isParkingAllotted == 1
                      ? SvgPicture.asset(
                    'assets/images/parking_icon.svg',
                    color: Colors.green,
                    height: 25,
                    width: 25,
                    fit: BoxFit.fill,
                  )
                      : SvgPicture.asset(
                    'assets/images/no_parking_icon.svg',
                    color: Colors.red,
                    fit: BoxFit.fill,
                  ),
                  if (blockName != null && blockName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        blockName!,
                        style: const TextStyle(color: Colors.black),
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