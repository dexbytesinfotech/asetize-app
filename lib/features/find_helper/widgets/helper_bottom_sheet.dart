import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';

class HelperBottomSheet extends StatefulWidget {
  final User userData;
  final String? name;
  final String? contact;
  final String? skills;
  final String? profilePicture;

   const HelperBottomSheet({
    super.key,
    required this.userData, this.name, this.contact, this.skills, this.profilePicture,
  });

  @override
  State<HelperBottomSheet> createState() =>
      _HelperBottomSheetState();
}

class _HelperBottomSheetState extends State<HelperBottomSheet> {
  makingPhoneCall() async {
    // Format phone number to include country code (+91)
    String formattedPhoneNumber =
        '+${widget.userData.phone}';

    var url = Uri.parse('tel:$formattedPhoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  makingWhatsAppCall() async {


    var url = Uri.parse(
        'https://wa.me/${widget.userData.phone}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Widget divider() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Divider(
          height: 0,
          color: Colors.grey.withOpacity(0.4),
          thickness: 0,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool havingContactNumber = widget.userData.phone?.isNotEmpty == true;
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 1, color: borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize:
            MainAxisSize.min, // Ensures buttons don't expand unnecessarily
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                    color: iconColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    Widget body() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/2,
        decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(30))),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 4,
                    width: 60,
                    margin: const EdgeInsets.only(top: 12),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const ImageLoader(),
                        errorWidget: (context, url, error) => SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            "assets/images/blank_profile_image.png",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        imageUrl: '${widget.userData.profilePhoto}',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.userData.name}" ?? '',
                            style: appTextStyle.appTitleStyle(fontSize: 16),
                          ),
                          Text(
                            widget.userData.jobTitle ?? '',
                            style: appTextStyle.appNormalSmallTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                color: Colors.grey.withOpacity(0.4),
                thickness: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15)
                    .copyWith(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (havingContactNumber)
                      Text(
                        'Phone No.',
                        style: appTextStyle.appNormalSmallTextStyle(
                          fontSize: 14,
                          color: AppColors.appGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    if (havingContactNumber)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '+${widget.userData.phone}' ??
                                '',
                            style: appTextStyle.appTitleStyle(),
                          ),
                          Row(
                            children: [
                              buildButton(
                                icon: Icons.phone,
                                text: 'Call',
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
                                text: 'WhatsApp',
                                color: Colors.green,
                                iconColor: AppColors.white,
                                borderColor: Colors.green,
                                onTap: () async {
                                  await makingWhatsAppCall();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40,)
            ],
          ),
        ),
      );
    }

    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(FadeRoute(
                            widget: FullPhotoView(
                                title: widget.userData.name ?? " ",
                                profileImgUrl: widget.userData.profilePhoto)));
                      },
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const ImageLoader(),
                        errorWidget: (context, url, error) => SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            "assets/images/blank_profile_image.png",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        imageUrl: '${widget.userData.profilePhoto}',
                        height: MediaQuery.of(context).size.height / 1.7,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade400.withOpacity(0.45)),
                          margin: const EdgeInsets.only(top: 15, right: 12),
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            'assets/images/cross_icon.svg',
                            color: Colors.black,
                            width: 13,
                            height: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(top: MediaQuery.of(context).size.height/2, child: body())
          ],
        ));
  }
}


