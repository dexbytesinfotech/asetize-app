import 'package:asetize/core/util/app_theme/text_style.dart';
import 'package:asetize/widgets/common_card_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../imports.dart';
import '../models/visitor_model.dart';

class VisitorCardWidget extends StatelessWidget {
  final VisitorData visitorData;
  final void Function()? onTab;
  final void Function()? onInfoTab;
  final void Function()? onCheckOutTab;
  final void Function()? onDenyTab;
  final bool isComingFrom;
  final bool preApprovedStatus;

  final String? status ;
  const VisitorCardWidget({
    super.key,
    required this.visitorData,
    this.onTab,
    this.onInfoTab,
    this.onCheckOutTab,
    this.onDenyTab,
    this.status,
    this.isComingFrom = true,
    this.preApprovedStatus =false
  });

  @override
  Widget build(BuildContext context) {

    String vehicleTypeImage(String? vehicleType) {
      if (vehicleType == null || vehicleType.isEmpty) {
        return WorkplaceIcons.carVehicle;
      }
      switch (vehicleType.toLowerCase()) {
        case "car":
          return WorkplaceIcons.carVehicle;
        case "bike":
          return WorkplaceIcons.bikeVehicle;
        case "scooty":
          return WorkplaceIcons.scooty;
        case "bus":
          return WorkplaceIcons.busNewIcon;
        case "e-rickshaw":
          return WorkplaceIcons.autoRickshaw;
        case "auto-rickshaw":
          return WorkplaceIcons.autoRickshaw;
        case "tempo":
          return WorkplaceIcons.vanNewIcon;
        case "van":
          return WorkplaceIcons.vanNewIcon;
        default:
          return WorkplaceIcons.carVehicle;
      }
    }

    Map<String, Color> visitorTypeColors = {
      'guest': Colors.teal,
      'visitor': Colors.teal,
      'delivery_boy': Colors.deepPurple,
      'helper': Colors.green,
      'technician': Colors.purple,
      'government_official': Colors.teal,
      'salesperson': Colors.deepPurple,
      'security_staff': Colors.brown,
      'healthcare_worker': Colors.pink,
      'contractor': Colors.amber,
      'cab_driver': Colors.indigo,
      'others': Colors.grey,
    };

    Color visitorColor =
        visitorTypeColors[visitorData.visitorType] ?? Colors.blue;

    makingPhoneCall(String phoneNumber) async {
      var url = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return GestureDetector(
        onTap: onTab,
        child: CommonCardView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            visitorData.name ?? "",
                            style: appTextStyle.appTitleStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if(visitorData.houses!.first.approvalStatus != "pending" && preApprovedStatus == false)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    formatStatus(visitorData.houses!.first.approvalStatus) ?? "",
                                    style: appTextStyle.appNormalSmallTextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if(visitorData.status!.isNotEmpty&& preApprovedStatus)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    formatStatus(visitorData.status) ?? "",
                                    style: appTextStyle.appNormalSmallTextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: visitorColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              visitorData.organization ?? "",
                              style: appTextStyle.appNormalSmallTextStyle(
                                color: visitorColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            visitorData.totalVisitors ?? "",
                            style: appTextStyle.appNormalSmallTextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (visitorData.entryTime?.isNotEmpty == true)
                        Row(
                          children: [
                            const Icon(Icons.access_time_filled,
                                size: 18, color: Colors.black87),
                            const SizedBox(width: 8),
                            Text(
                                preApprovedStatus? "Visit Date: ${projectUtil.formatTo12Hour(visitorData.entryTime!)}":"Check-in: ${projectUtil.formatTo12Hour(visitorData.entryTime!)}",
                              style: appTextStyle.appNormalTextStyle(color: Colors.black87),
                            ),

                          ],
                        ),
                      if (visitorData.entryTime?.isNotEmpty == true)
                        const SizedBox(height: 8),
                      if (visitorData.exitTime?.isNotEmpty == true)
                        Row(
                          children: [
                            const Icon(Icons.access_time_filled,
                                size: 18, color: Colors.black87),
                            const SizedBox(width: 8),
                            Text(
                              "Check-out: ${projectUtil.formatTo12Hour(visitorData.exitTime!)}",
                              style: appTextStyle.appNormalTextStyle(color: Colors.black87),
                            ),

                          ],
                        ),
                      if (visitorData.exitTime?.isNotEmpty == true)
                        const SizedBox(height: 8),
                      if (visitorData.vehicle?.vehicleNumber?.isNotEmpty ==
                          true)
                        Row(
                          children: [
                           WorkplaceIcons.iconImage(
                             imageUrl: vehicleTypeImage(visitorData.vehicle?.vehicleType),
                             iconSize: Size(22,22),
                             imageColor:Colors.black.withOpacity(0.7),
                           ),
                            // const Icon(Icons.directions_car,
                            //     size: 18, color: Colors.black87),
                            const SizedBox(width: 8),
                            Text(visitorData.vehicle?.vehicleNumber ?? "",
                                style: appTextStyle.appNormalTextStyle(
                                    color: Colors.black87)),
                          ],
                        ),
                      if (visitorData.vehicle?.vehicleNumber?.isNotEmpty ==
                          true)

                      const SizedBox(height: 15),
                      if(visitorData.houses!.first.approvalStatus == "pending" &&isComingFrom)Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              buttonHeight: 45,
                              isShowIcon: true,
                              iconSize: const Size(20, 20),
                              icon: WorkplaceIcons.deniedIcon,
                              buttonName: 'Deny',
                              buttonColor: AppColors.red,
                              textStyle: appStyles.buttonTextStyle1(
                                  texColor: AppColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              backCallback: onDenyTab
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: AppButton(
                              buttonHeight: 45,
                              isShowIcon: true,
                              iconSize: const Size(18, 18),
                              icon: WorkplaceIcons.allowedIcon,
                              buttonName: 'Allow',
                              buttonColor: Colors.green,
                              textStyle: appStyles.buttonTextStyle1(
                                  texColor: AppColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              backCallback: onCheckOutTab,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  String formatStatus(String? status) {
    if (status == null || status.isEmpty) return "";

    return status
        .replaceAll('-', ' ') // Replace dashes with spaces
        .split(' ') // Split into words
        .map((word) => word[0].toUpperCase() + word.substring(1)) // Capitalize each word
        .join(' '); // Join back into a sentence
  }
}
