import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../presentation/widgets/search_vehicle_card_view.dart';
import '../bloc/find_car_onwer_bloc.dart';
import '../bloc/find_car_onwer_event.dart';
import '../bloc/find_car_onwer_state.dart';

class FindCarOwnerScreen extends StatefulWidget {
  const FindCarOwnerScreen({super.key});

  @override
  _FindCarOwnerScreenState createState() => _FindCarOwnerScreenState();
}

class _FindCarOwnerScreenState extends State<FindCarOwnerScreen> {
  late FindCarOnwerBloc findCarOwnerBloc;
  String? _registrationNumber;
  bool _isSearchEnabled = false;
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
  String? _registrationNumberError;
  Map<String, FocusNode> focusNodes = {
    'registration Number': FocusNode(),
  };
  Map<String, TextEditingController> controllers = {
    'registration Number': TextEditingController(),
  };
  Map<String, String> errorMessages = {
    'registration Number': "",
  };

  @override
  void initState() {
    findCarOwnerBloc = BlocProvider.of<FindCarOnwerBloc>(context);
    findCarOwnerBloc.findMyVehicleList.clear(); // Clear previous notice
    super.initState();
  }

  void _launchURL(String url) async {
    final phoneUrl = 'tel:$url';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }

  void makingWhatsAppCall(String phoneNumber) async {
    var cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    var url = Uri.parse('https://wa.me/$cleanPhoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onRegistrationNumberChange(dynamic value) {
    _registrationNumber = value;

    // Remove all validation checks
    _registrationNumberError = null; // Clear any previous error
    _isSearchEnabled = true; // Enable search by default

    setState(() {});
  }

  void _performSearch() {
    closeKeyboard();
    findCarOwnerBloc.add(SearchVehicleEvent(_registrationNumber!, context));
    setState(() {
      _isSearchEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formatPhoneNumber(String phoneNumber) {
      if (phoneNumber.length == 12) {
        return "+${phoneNumber.substring(0, 2)} ${phoneNumber.substring(2, 7)} ${phoneNumber.substring(7)}";
      }
      return phoneNumber; // Return as is if it doesn't match the expected length
    }

    Widget registrationNumber() {
      return Row(
        children: [
          Flexible(
            child: Container(
              // decoration: BoxDecoration(
              //   color: Colors.transparent,
              //   borderRadius: BorderRadius.circular(8),
              //   boxShadow: const [
              //     BoxShadow(
              //       color: Colors.white, // Set shadow color to transparent
              //       spreadRadius: 0,
              //       blurRadius: 0,
              //       offset: Offset(0, 0),
              //     ),
              //   ],
              // ),
              margin: const EdgeInsets.all(0),
              height: 95,
              width: MediaQuery.of(context).size.width,
              child: CommonTextFieldWithError(
                focusNode: focusNodes['registration Number'],
                isShowBottomErrorMsg: true,
                errorMessages: _registrationNumberError ?? '',
                controllerT: controllers['registration Number'],
                borderRadius: 8,
                inputHeight: 50,
                errorLeftRightMargin: 0,
                maxCharLength: 12, // Keep the max character length if needed
                errorMsgHeight: 18,
                maxLines: 1,
                autoFocus: false,
                enabledBorderColor: AppColors.white,
                focusedBorderColor: AppColors.white,
                backgroundColor: AppColors.white,
                textInputAction: TextInputAction.done,
                borderStyle: BorderStyle.solid,
                showError: _registrationNumberError != null,
                capitalization: CapitalizationText.none,
                cursorColor: Colors.grey,
                inputFormatter: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // Disallow spaces
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')), // Alphanumeric only
                  UpperCaseTextFormatter(), // Custom formatter for uppercase
                  // RegistrationNumberFormatter(), // Formatter for registration number format
                ],
                placeHolderTextWidget: Padding(
                  padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                  child: Text(
                    "Vehicle Number",
                    textAlign: TextAlign.start,
                    style: appStyles.texFieldPlaceHolderNewStyle(texColor: Colors.black),
                  ),
                ),
                inputKeyboardType: InputKeyboardTypeWithError.email,
                hintText: projectUtil.capitalizeFullName(AppString.enterVehicleNumber),
                hintStyle: appStyles.textFieldTextStyle(
                    fontWeight: FontWeight.w400,
                    texColor: Colors.grey.shade600,
                    fontSize: 14),
                textStyle: appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
                inputFieldSuffixIcon: controllers['registration Number']!.text.isEmpty
                    ? const SizedBox()
                    : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      controllers['registration Number']!.clear();
                      findCarOwnerBloc.findMyVehicleList.clear();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18, left: 10),
                    child: Icon(
                      Icons.clear,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.only(left: 15, right: 15, top: -5, bottom: 0),
                onTextChange: _onRegistrationNumberChange,
                onEndEditing: (value) {
                  _onRegistrationNumberChange(value);
                  // Remove the validation check before performing search
                  if (controllers['registration Number']!.text.isNotEmpty) {
                    findCarOwnerBloc.add(SearchVehicleEvent(_registrationNumber!, context));
                  }
                  setState(() {
                    _isSearchEnabled = false;
                  });
                  FocusScope.of(context).unfocus(); // Dismiss the keyboard
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: _isSearchEnabled ? _performSearch : null,
            child: Container(
              margin: const EdgeInsets.only(top: 10, left: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.appBlueColor,
                  borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.search, color: Colors.white),
            ),
          )
        ],
      );
    }

    Widget topCarImageAndSearchButton() {
      return Padding(
        padding: const EdgeInsets.all(20.0).copyWith(top: 0, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/find_my_vehicel.png',
              width: double.infinity,
              height: 185,
              fit: BoxFit.cover,
            ),
            registrationNumber(),
          ],
        ),
      );
    }

    Widget searchVehicleList() {
      return BlocListener<FindCarOnwerBloc, VehicleInfomationState>(
        listener: (context, state) {
          if (state is VehicleInfomationErrorState) {
            WorkplaceWidgets.errorPopUp(
                context: context,
                content: state.errorMessage,
                onTap: () {
                  Navigator.of(context).pop();
                });
          }
        },
        child: BlocBuilder<FindCarOnwerBloc, VehicleInfomationState>(
          builder: (context, state) {
            return  findCarOwnerBloc.findMyVehicleList.isNotEmpty?Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: findCarOwnerBloc.findMyVehicleList.length,
                  itemBuilder: (context, index) {
                    final formattedContact = projectUtil.formatPhoneNumberWithCountryCode(
                      countryCode: findCarOwnerBloc.findMyVehicleList[index].countryCode!, // or from dynamic user input or data
                      phoneNumber: findCarOwnerBloc.findMyVehicleList[index].phone!,
                    );

                    final formattedContactNumberForUi = projectUtil.formatPhoneNumberWithCountryCode(
                      countryCode: findCarOwnerBloc.findMyVehicleList[index].countryCode!, // or from dynamic user input or data
                      phoneNumber: findCarOwnerBloc.findMyVehicleList[index].phone!,
                        withCountryCode: false

                    );

                    final myVehicle =
                    findCarOwnerBloc.findMyVehicleList[index];
                    return SearchVehicleCardView(
                      title: myVehicle.ownerName ?? "",
                      rcNumber: myVehicle.registrationNumber ?? "",
                      flatNumber: myVehicle.shortDescription ?? "",
                      type: myVehicle.vehicleType ?? "",
                      phoneNumber: formattedContactNumberForUi,
                      onTapPhoneCallBack: () {
                        _launchURL(formattedContact);
                      },
                      onTapWhatsAppCallBack: () {
                        makingWhatsAppCall(formattedContact.toString());
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ):const Center(
                child: SizedBox());



      }
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
      appBar: const CommonAppBar(
        title: AppString.findVehicleOwner,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: SingleChildScrollView(
        child: Column(
          children: [
            topCarImageAndSearchButton(),
            searchVehicleList(),
          ],
        ),
      ),
    );
  }
}


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}