import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../follow_up/pages/follow_up_list_screen.dart';
import '../../follow_up/pages/new_follow_up_list_screen.dart';
import 'member_unit_screen.dart';

class MemberProfileBottomSheet extends StatefulWidget {
  final User userData;

  const MemberProfileBottomSheet({
    super.key,
    required this.userData,
  });

  @override
  State<MemberProfileBottomSheet> createState() =>
      _MemberProfileBottomSheetState();
}

class _MemberProfileBottomSheetState extends State<MemberProfileBottomSheet> {
  late final contactNumberWithCountryCode = projectUtil.formatPhoneNumberWithCountryCode(
    countryCode:widget.userData.countryCode!, // or from dynamic user input or data
    phoneNumber: widget.userData.phone!,
  );
  makingPhoneCall() async {
    // Format phone number to include country code (+91)

    var url = Uri.parse('tel:$contactNumberWithCountryCode');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  copyPhoneNumber(BuildContext context) {
    // Format phone number to include country code (+91)
    String formattedPhoneNumber =
        '+${widget.userData.countryCode} ${widget.userData.phone}';
    Clipboard.setData(ClipboardData(text: formattedPhoneNumber));
    // Optional: Show a confirmation message to the user
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    WorkplaceWidgets.errorSnackBar(context, 'Phone number copied to clipboard');
  }

  makingWhatsAppCall() async {
    // Format phone number to include country code (+91)

    var url = Uri.parse(
        'https://wa.me/${contactNumberWithCountryCode.replaceAll(' ', '')}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  shareNameAndPhoneOnWhatsApp() async {
    // Format phone number to include country code (+91)

    String? userName =
        widget.userData.name; // Assume you have a name field in userData

    // Construct the message to be shared
    String message =
        Uri.encodeComponent('Name: $userName\nMobile: ${contactNumberWithCountryCode.replaceAll(' ', '')}');

    // WhatsApp sharing URL for a specific user
    var url = Uri.parse('https://wa.me/?text=$message');

    // Launch WhatsApp
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> addContact(
      BuildContext context, String name, String phoneNumber) async {
    if (await Permission.contacts.request().isGranted) {
      Iterable<ContactInfo> contacts = await FlutterContactsService.getContacts();
      bool contactExists = contacts.any((contact) =>
          contact.phones?.any((phone) => phone.value == phoneNumber) ?? false);

      if (contactExists) {
        WorkplaceWidgets.successToast('This number already exists in your contacts!',durationInSeconds: 1);

      } else {
        // Show confirmation dialog
        _showConfirmationDialog(context, name, phoneNumber);
      }
    } else {
      WorkplaceWidgets.successToast('Permission to access contacts was denied',durationInSeconds: 1);
    }
  }

  void _showConfirmationDialog(
      BuildContext context, String initialName, String phoneNumber) {
    TextEditingController nameController =
        TextEditingController(text: initialName);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text(
                'Confirm Contact',
                textAlign: TextAlign.center,
              ),
              titleTextStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CommonTextFieldWithError(
                          isShowBottomErrorMsg: true,
                          controllerT: nameController,
                          borderRadius: 8,
                          inputHeight: 50,
                          errorLeftRightMargin: 0,
                          maxCharLength: 50,
                          errorMsgHeight: 24,
                          autoFocus: false,
                          showError: true,
                          capitalization: CapitalizationText.none,
                          cursorColor: Colors.grey,
                          placeHolderTextWidget: Padding(
                              padding: const EdgeInsets.only(
                                left: 3.0,
                                bottom: 10,
                                top: 5,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text: "Full Name", // Normal text
                                  style: appStyles
                                      .texFieldPlaceHolderStyle(), // Default style for the main text
                                  children: [
                                    TextSpan(
                                      text: ' *', // Asterisk
                                      style: appStyles
                                          .texFieldPlaceHolderStyle()
                                          .copyWith(
                                              color: Colors
                                                  .red), // Red color for asterisk
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,
                              )),
                          enabledBorderColor: AppColors.white,
                          focusedBorderColor: AppColors.white,
                          backgroundColor: AppColors.white,
                          textInputAction: TextInputAction.done,
                          borderStyle: BorderStyle.solid,
                          inputKeyboardType: InputKeyboardTypeWithError.email,
                          hintText: AppString.pleaseEnterYourEmailAddressSmall,
                          hintStyle: appStyles.hintTextStyle(),
                          textStyle: appStyles.textFieldTextStyle(),
                          contentPadding:
                              const EdgeInsets.only(left: 15, right: 15),
                          onTextChange: (value) {
                            // checkEmail(value, 'email', onchange: true);
                          },
                          onEndEditing: (value) {
                            // checkEmail(value, 'email');
                            // FocusScope.of(context).requestFocus();
                          },
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextFieldWithError(
                          isShowBottomErrorMsg: true,
                          borderRadius: 8,
                          inputHeight: 50,
                          errorLeftRightMargin: 0,
                          maxCharLength: 50,
                          errorMsgHeight: 10,
                          autoFocus: false,
                          showError: true,
                          capitalization: CapitalizationText.none,
                          cursorColor: Colors.grey,
                          placeHolderTextWidget: Padding(
                              padding: const EdgeInsets.only(
                                left: 3.0,
                                bottom: 10,
                                top: 5,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text: "Phone Number", // Normal text
                                  style: appStyles
                                      .texFieldPlaceHolderStyle(), // Default style for the main text
                                ),
                                textAlign: TextAlign.start,
                              )),
                          enabledBorderColor: AppColors.white,
                          focusedBorderColor: AppColors.white,
                          readOnly: true,
                          backgroundColor: AppColors.white,
                          textInputAction: TextInputAction.done,
                          borderStyle: BorderStyle.solid,
                          inputKeyboardType: InputKeyboardTypeWithError.email,
                          hintText: phoneNumber,
                          hintStyle: appStyles.hintTextStyle(
                              texColor: Colors.black,
                              fontWeight: FontWeight.w500),
                          textStyle: appStyles.textFieldTextStyle(texColor:Colors.black),
                          contentPadding:
                              const EdgeInsets.only(left: 15, right: 15),
                          onTextChange: (value) {
                            // checkEmail(value, 'email', onchange: true);
                          },
                          onEndEditing: (value) {
                            // checkEmail(value, 'email');
                            // FocusScope.of(context).requestFocus();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              contentTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
                color: Colors.orange,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                            border: Border.all(
                              color:
                                  Colors.grey, // Set the border color to grey
                              width: 1, // Set the width of the border
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: GestureDetector(
                        onTap: () async {
                          String editedName = nameController.text.trim();
                          if (editedName.isNotEmpty) {
                            ContactInfo newContact = ContactInfo(
                              givenName: editedName,
                              phones: [
                                ValueItem(label: "mobile", value: phoneNumber)
                              ],
                            );
                            await FlutterContactsService.addContact(newContact);

                            WorkplaceWidgets.successToast('Contact added successfully!',durationInSeconds: 1);

                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.textBlueColor),
                          alignment: Alignment.center,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget divider() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Divider(
          height: 0,
          color: Colors.grey.safeOpacity(0.4),
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

    bool canHouseStatementsList = AppPermission.instance.canPermission(AppString.houseStatementsList, context: context)  ;
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
      final contactNumberWithOutCountryCode = projectUtil.formatPhoneNumberWithCountryCode(
          countryCode:widget.userData.countryCode!, // or from dynamic user input or data
          phoneNumber: widget.userData.phone! ?? '',
          withCountryCode:false
      );

      final contactNumberWithCountryCode = projectUtil.formatPhoneNumberWithCountryCode(
          countryCode:widget.userData.countryCode!, // or from dynamic user input or data
          phoneNumber: widget.userData.phone!,
      );
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/2.5,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
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
                            widget.userData.shortDescription ?? '',
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
                color: Colors.grey.safeOpacity(0.4),
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
                            contactNumberWithOutCountryCode ??
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
                    if (havingContactNumber) divider(),
                    if (havingContactNumber)GestureDetector(
                      onTap: () => addContact(
                          context,
                          '${widget.userData.name}' ?? 'Unknown',
                          contactNumberWithCountryCode
                          // '${widget.userData.phone ?? ''}', // Handle nullable phone
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_add,
                              color: AppColors.black, // White icon color for contrast
                              size:
                                  20, // Icon size based on screen size (sp for responsiveness)
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Add Contact' ?? '',
                              style: appTextStyle.appTitleStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (havingContactNumber) divider(),
                    if (havingContactNumber) GestureDetector(
                      onTap: () {
                        shareNameAndPhoneOnWhatsApp();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.share,
                              color: AppColors.black,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 15,
                            ),

                            Text(
                              'Share Contact Detail' ?? '',
                              style: appTextStyle.appTitleStyle(),
                            ),
                          ],





                        ),
                      ),
                    ),
                   if(havingContactNumber && canHouseStatementsList) divider(),
                   if(canHouseStatementsList) InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideLeftRoute(
                              widget:   MemberUnitScreen(
                                  userName: '${widget.userData.name}',
                                  houses: widget.userData.houses ?? []
                              )),
                        ).then((value) {
                          Navigator.of(context).pop();

                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.list_alt,
                            color: AppColors
                                .black, // White icon color for contrast
                            size:
                            20, // Icon size based on screen size (sp for responsiveness)
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'View Statement',
                            style: appTextStyle.appTitleStyle(),
                          ),
                        ],
                      ),
                    ),
                    if(havingContactNumber ) divider(),
                   InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideLeftRoute(
                              widget:  FollowUpTasksScreen(
                                // houses: widget.userData.houses ?? [],

                              )),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.follow_the_signs,
                            color: AppColors.black,
                            size:
                            20, // Icon size based on screen size (sp for responsiveness)
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Follow Up',
                            style: appTextStyle.appTitleStyle(),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                  ],
                ),
              )
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
                            widget:  FullPhotoView(
                                title: widget.userData.name ?? " ",
                                profileImgUrl: widget.userData.profilePhoto)));
                      },
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const ImageLoader(),
                        errorWidget: (context, url, error) => SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/images/blank_profile_image.png",
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
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
                              color: Colors.grey.shade400.safeOpacity(0.45)),
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
            Positioned(top: MediaQuery.of(context).size.height/2.5, child: body())
          ],
        ));
  }
}


