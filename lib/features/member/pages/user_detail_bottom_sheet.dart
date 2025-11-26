import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:asetize/imports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import 'member_unit_screen.dart';

class UserDetailBottomSheet extends StatefulWidget {
  final User userData;

  final Map<String, dynamic>? map;

  const UserDetailBottomSheet({
    Key? key,
    required this.userData,
    this.map,
  }) : super(key: key);

  @override
  State<UserDetailBottomSheet> createState() => _UserDetailBottomSheetState();
}

class _UserDetailBottomSheetState extends State<UserDetailBottomSheet> {
  bool isReadMore = false;

  makingPhoneCall() async {
    // Format phone number to include country code (+91)
    String formattedPhoneNumber = '+${widget.userData.countryCode} ${widget
        .userData.phone}';

    var url = Uri.parse('tel:$formattedPhoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  copyPhoneNumber(BuildContext context) {
    // Format phone number to include country code (+91)
    String formattedPhoneNumber = '+${widget.userData.countryCode} ${widget.userData.phone}';
    Clipboard.setData(ClipboardData(text: formattedPhoneNumber));
    // Optional: Show a confirmation message to the user
    WorkplaceWidgets.successToast('Phone number copied to clipboard',durationInSeconds: 1);


  }

  makingWhatsAppCall() async {
    // Format phone number to include country code (+91)
    String formattedPhoneNumber = '+${widget.userData.countryCode} ${widget
        .userData.phone}';

    var url = Uri.parse(
        'https://wa.me/${widget.userData.countryCode}${widget.userData.phone}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  shareNameAndPhoneOnWhatsApp() async {
    // Format phone number to include country code (+91)
    String formattedPhoneNumber = '+${widget.userData.countryCode}${widget.userData.phone}';
    String? userName = widget.userData.name; // Assume you have a name field in userData

    // Construct the message to be shared
    String message = Uri.encodeComponent('Name: $userName\nMobile: $formattedPhoneNumber');

    // WhatsApp sharing URL for a specific user
    var url = Uri.parse('https://wa.me/?text=$message');

    // Launch WhatsApp
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  email() async {
    var url = Uri.parse('mailto:${widget.userData.email}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget emailPhoneIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
              onTap: email,
              child: const Icon(
                Icons.email,
                color: AppColors.appGreen,
                size: 32,
              )
          ),
          const SizedBox(
            width: 8,
          ),
          InkWell(
              onTap: makingPhoneCall,
              child: const Icon(
                Icons.call,
                color: AppColors.appGreen,
                size: 30,
              )),
        ],
      ),
    );
  }

  Future<void> addContact(
      BuildContext context, String name, String phoneNumber) async {
    if (await Permission.contacts.request().isGranted) {
      Iterable<ContactInfo> contacts = await FlutterContactsService.getContacts();
      bool contactExists = contacts.any((contact) =>
      contact.phones?.any((phone) => phone.value == phoneNumber) ?? false);

      if (contactExists) {
        WorkplaceWidgets.successToast('This number already exists in your contacts',durationInSeconds: 1);

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
              backgroundColor: Colors.grey.shade100,
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
                    const Text(
                      'Full Name',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: TextField(
                        controller: nameController,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Name',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phone Number',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: phoneNumber,

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              contentTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
                color: Colors.black,
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
                            color: Colors.grey.shade200,
                            border: Border.all(
                              color: Colors.grey,  // Set the border color to grey
                              width: 1,  // Set the width of the border
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
                              phones: [ValueItem(label: "mobile", value: phoneNumber)],
                            );
                            await FlutterContactsService.addContact(newContact);
                            WorkplaceWidgets.successToast('Contact added successfully',durationInSeconds: 1);

                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.buttonBgColor3
                          ),
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



  Map<String, dynamic> infoMap = {};

  @override
  void initState() {
    // TODO: implement initState
    // Convert object to a map
    infoMap = widget.userData.additionalInfo?.toMap() ?? {};

    debugPrint('Additional Info Map........$infoMap');

    infoMap.forEach((key, value) {
      String keys = '${key[0].toUpperCase()}${key.substring(1)}';
      return debugPrint('key = ${keys.replaceAll('_', ' ')}  value = $value');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool canHouseStatementsList = AppPermission.instance.canPermission(AppString.houseStatementsList,context: context);
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 50),
              Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 60, bottom: 30),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.appWhite,
                      ),
                      color: AppColors.appWhite,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                  child: Column(
                    children: [
                      Text(
                        '${widget.userData.name}',
                        textAlign: TextAlign.center,
                        style: appTextStyle.appTitleStyle(),
                      ),
                      if(canHouseStatementsList)InkWell(
                        onTap: ()
                        {
                          Navigator.push(
                            context,
                            SlideLeftRoute(
                                widget:  MemberUnitScreen(userName:'${widget.userData.name}', houses: widget.userData.houses ?? [])),
                          ).then((value){
                            Navigator.of(context).pop();
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (widget.userData.shortDescription != null &&
                                  widget.userData.shortDescription!.isNotEmpty)
                                  ? widget.userData.shortDescription!
                                  : "",
                              textAlign: TextAlign.center,
                              style: appTextStyle.appSubTitleStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 6,),
                            if((widget.userData.shortDescription != null &&
                                widget.userData.shortDescription!.isNotEmpty))const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color:AppColors.black,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if(widget.userData.phone != "" && widget.userData.phone != null)
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await makingPhoneCall();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.phone,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () async {
                                    await makingWhatsAppCall();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Colors.green),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap:  () {
                                    shareNameAndPhoneOnWhatsApp();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.share,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () => addContact(
                                      context,
                                      '${'DexBytes ' }${widget.userData.name }'?? 'Unknown',
                                      '+${widget.userData.countryCode} ${widget
                                          .userData.phone}'
                                    // '${widget.userData.phone ?? ''}', // Handle nullable phone
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    padding: const EdgeInsets.only(right: 2),
                                    decoration: const BoxDecoration(
                                      color: AppColors.buttonBgColor3, // Background color of the button
                                      shape: BoxShape.circle, // Rounded button
                                    ),
                                    child: const Icon(
                                      Icons.person_add,
                                      color: Colors.white, // White icon color for contrast
                                      size: 18, // Icon size based on screen size (sp for responsiveness)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                       Column(
                        children: _buildInfoRows() ?? [],
                      ),
                    ],
                  )),
            ],
          ),
        /*  Positioned(
            top: 110, // Positioned 125 units from the top
            right: 20, // Positioned 30 units from the right
            child: GestureDetector(
              onTap: (){
                
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.buttonBgColor3, // Background color of the button
                  shape: BoxShape.circle, // Rounded button
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3), // Shadow direction
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.wallet,
                  color: Colors.white, // White icon color for contrast
                  size: 18, // Icon size based on screen size (sp for responsiveness)
                ),
              ),
            ),
          ),*/
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3))
              ],
              border: Border.all(color: AppColors.appWhite, width: 4),
              color: AppColors.appGrey,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(FadeRoute(
                    widget:
                        FullPhotoView(
                            title: widget.userData.name ?? " ",
                            profileImgUrl: widget.userData.profilePhoto)));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const ImageLoader(),
                  errorWidget: (context, url, error) =>
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset(
                          "assets/images/profile_avatar.png",
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                  height: 100,
                  width: 100,
                  imageUrl: '${widget.userData.profilePhoto}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget>? _buildInfoRows() {
    return widget.map?.keys.map((key) {
      String? value = widget.map![key];
      String formattedKey =
      '${key[0].toUpperCase()}${key.substring(1)}'.replaceAll('_', ' ');
      if (value != null && value
          .toString()
          .isNotEmpty) {
        return formattedKey == "Phone"
            ? const SizedBox()
            : RowTextWidget(
          leftText: formattedKey,
          rightText: value.toString(),
        );
      } else {
        return const SizedBox();
      }
    }).toList();
  }
}

