import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/util/animation/slide_left_route.dart';
import '../core/util/app_theme/app_color.dart';
import '../core/util/app_theme/app_string.dart';
import '../core/util/app_theme/text_style.dart';
import '../features/presentation/widgets/full_image_view.dart';
import '../features/presentation/widgets/image_loader.dart';

class CommonDetailViewRow extends StatelessWidget {
  final String title;
  final String value;
  final String number;
  final String btName;
  final bool isShowBt;
  final bool isFollowUp;
  final bool isShowStatus;
  final bool isShowCopyIcon;
  final String? imagePath;
  final IconData icons;
  final void Function()? onTapCallBack;
  final TextStyle? titleTextStyle;
  final TextStyle? valueTextStyle;
  final double? iconSize;

  const CommonDetailViewRow({
    super.key,
    this.title = '',
    this.value = '',
    this.number = '',
    this.btName = 'Call',
    this.isFollowUp = false,
    this.isShowBt = false,
    this.isShowStatus = false,
    this.imagePath,
    this.titleTextStyle,
    this.valueTextStyle,
    this.iconSize,
    this.isShowCopyIcon = false,
    this.icons = CupertinoIcons.house,
    this.onTapCallBack,
  });

  @override
  Widget build(BuildContext context) {
    if ((value.isEmpty || value.trim().isEmpty) && !isShowBt && !isShowStatus) {
      return const SizedBox(); // Hide empty rows
    }

    // ----------------- Phone Call Function -----------------
    makingPhoneCall(number) async {
      String formattedPhoneNumber = '$number';
      var url = Uri.parse('tel:$formattedPhoneNumber');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    // ----------------- Status Color Function -----------------
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return Colors.orange;
        case 'rejected':
          return Colors.red;
        case 'approved':
          return Colors.green;
        case 'submitted':
          return Colors.green;
        case 'cancelled':
          return Colors.grey;
        case 'issued':
          return Colors.green;
        case 'completed':
          return Colors.green;
        default:
          return Colors.black12;
      }
    }

    // ----------------- Copy to Clipboard Function -----------------
    void copyToClipboard(String text) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title copied to clipboard'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    // ----------------- Main UI -----------------
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icons,
              color: Colors.grey.shade600,
              size: iconSize ?? 18,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isFollowUp
                      ? titleTextStyle ??
                      appTextStyle.appTitleStyle2(
                          fontSize: 15, fontWeight: FontWeight.w500)
                      : titleTextStyle ??
                      appTextStyle.appSubTitleStyle2(
                          color: Colors.grey.shade600),
                ),
                SizedBox(height: isFollowUp ? 0 : 3),
                if (isFollowUp == false)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ----------------- Value + Copy Icon -----------------
                      if (!isShowStatus)
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  value,
                                  maxLines: 3,
                                  style: valueTextStyle ??
                                      appTextStyle.appTitleStyle2(
                                          fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 5),
                              if (isShowCopyIcon)
                              GestureDetector(
                                onTap: () => copyToClipboard(value),
                                child: const Icon(
                                  Icons.copy,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // ----------------- Call Button -----------------
                      if (isShowBt)
                        GestureDetector(
                          onTap: () async {
                            if (onTapCallBack == null) {
                              await makingPhoneCall(number);
                            } else {
                              onTapCallBack!.call();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 1),
                            margin: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: AppColors.appBlueColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              btName,
                              style: appTextStyle.appSubTitleStyle2(
                                color: AppColors.appBlueColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                      // ----------------- Status Badge -----------------
                      if (isShowStatus)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: getStatusColor(value)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            value,
                            style: appTextStyle.appSubTitleStyle2(
                              color: getStatusColor(value),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
