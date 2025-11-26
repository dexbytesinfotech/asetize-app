import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:asetize/widgets/common_card_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';

class HelperCardView extends StatelessWidget {
  final String phone;
  final onTap;
  final String name;
  final String profileImageUrl;
  final String skills;

  const HelperCardView(
      {super.key,
        this.onTap,
      required this.name,
      required this.phone,
      required this.skills,
      required this.profileImageUrl,
   });

  @override
  Widget build(BuildContext context) {

    makingPhoneCall() async {
      // Format phone number to include country code (+91)
      String formattedPhoneNumber =
          '+${phone}';

      var url = Uri.parse('tel:$formattedPhoneNumber');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }


    makingWhatsAppCall() async {


      var url = Uri.parse(
          'https://wa.me/${phone}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

// Function to create buttons
    Widget buildButton({
      required IconData icon,
      required String text,
      required Color color,
      required Color iconColor,
      required Color borderColor,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            // border: Border.all(width: 1, color: borderColor),
            // borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize:
            MainAxisSize.min, // Ensures buttons don't expand unnecessarily
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              // const SizedBox(width: 4),
              // Text(
              //   text,
              //   style: TextStyle(
              //       color: iconColor,
              //       fontSize: 12,
              //       fontWeight: FontWeight.w500),
              // ),
            ],
          ),
        ),
      );
    }


    return CommonCardView(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                placeholder: (context, url) => const ImageLoader(),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/images/profile_avatar.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
                imageUrl: profileImageUrl ,
                height: 40,
                width: 40,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 12),
            Expanded( // Prevents overflow issues
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectUtil.capitalizeFullName(name) ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: appTextStyle.appTitleStyle2(),
                  ),
                  Text(
                    projectUtil.capitalize(skills) ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: appTextStyle.appSubTitleStyle2(),
                  ),
                  // if(phone.isNotEmpty) SizedBox(height: 4),
                  // if(phone.isNotEmpty) Row(
                  //   children: [
                  //     buildButton(
                  //       icon: Icons.phone,
                  //       text: 'Call',
                  //       color: AppColors.textBlueColor,
                  //       iconColor: Colors.white,
                  //       borderColor: Colors.blue,
                  //       onTap: () async {
                  //         await makingPhoneCall();
                  //       },
                  //     ),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     buildButton(
                  //       icon: FontAwesomeIcons.whatsapp,
                  //       text: 'WhatsApp',
                  //       color: Colors.green,
                  //       iconColor: AppColors.white,
                  //       borderColor: Colors.green,
                  //       onTap: () async {
                  //         await makingWhatsAppCall();
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            if(phone.isNotEmpty) Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  buildButton(
                    icon: Icons.phone,
                    text: '',
                    color: AppColors.textBlueColor,
                    iconColor: Colors.white,
                    borderColor: Colors.blue,
                    onTap: () async {
                      await makingPhoneCall();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  buildButton(
                    icon: FontAwesomeIcons.whatsapp,
                    text: '',
                    color: Colors.green,
                    iconColor: AppColors.white,
                    borderColor: Colors.green,
                    onTap: () async {
                      await makingWhatsAppCall();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
