import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
// Ensure you have this import for Material widgets
import 'package:asetize/features/new_sign_up/bloc/new_signup_state.dart';
import 'package:asetize/features/new_sign_up/pages/new_login_with_email_screen.dart';
import 'package:asetize/features/new_sign_up/pages/sign_up_success_screen.dart';
import 'package:asetize/features/new_sign_up/pages/terms_and_conditions.dart';

import '../../../imports.dart';
import '../bloc/new_signup_bloc.dart';
import '../bloc/new_signup_event.dart';

class RequestForAddNewSociety extends StatefulWidget {
  final bool? isSocietyNotFound;
  const RequestForAddNewSociety({super.key, this.isSocietyNotFound});

  @override
  State<RequestForAddNewSociety> createState() => _RequestForAddNewSocietyState();
}

class _RequestForAddNewSocietyState extends State<RequestForAddNewSociety> {
  late NewSignupBloc newSignupBloc;

  final TextEditingController _vehicleTypeController = TextEditingController();
  String? _vehicleType;
  bool isChecked = false;
  bool isShowLoader = true;
  List<String> propertyTypeList = ['Villa', 'Flat', 'Both'];

  Map<String, TextEditingController> controllers = {
    'communityName': TextEditingController(),
    'registration Number': TextEditingController(),
    'propertyType': TextEditingController(),
    'presidentName': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'ownerEmail': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'communityName': FocusNode(),
    'registration Number': FocusNode(),
    'propertyType': FocusNode(),
    'phoneNumber': FocusNode(),
    'presidentName': FocusNode(),
    'ownerEmail': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'communityName': "",
    'propertyType': "",
    'phoneNumber': "",
    'ownerLastName': "",
    'registration Number': "",
    'presidentName': "",
    'ownerEmail': "",
  };

  // Add regex patterns for validation
  final RegExp _communityNameRegex = RegExp(r'^[a-zA-Z\s]+$');
  final RegExp _registrationNumberRegex =
      RegExp(r'^[A-Z]{2}\s\d{2}\s[A-Z]{2}\s\d{4}$');
  final RegExp _phoneNumberRegex =
      RegExp(r'^\d{10}$'); // Updated regex for 10 digits
  final RegExp _nameRegex =
      RegExp(r'^[a-zA-Z\s]+$'); // For first name and last name
  final RegExp _propertyTypeRegex =
      RegExp(r'^(Villa|Flat|Both)$'); // Regex for property type validation

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  void _showBottomSheet(BuildContext context, List<String> options,
      ValueSetter<String> onSelect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Close Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Property Type',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,color: AppColors.black,),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              ListView.separated(
                itemCount: options.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      onSelect(options[index]);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                      child: Row(
                        children: [
                          Text(
                            options[index],
                            style: const TextStyle(fontSize: 16,color:  Colors.black,),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
   /*   builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0).copyWith(top: 8, bottom: 7),
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey, // Divider color
              thickness: 0.4, // Divider thickness
            ),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  onSelect(options[index]);
                  // Clear the error message when an option is selected
                  errorMessages['propertyType'] = "";
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },*/
    );
  }

  checkEmail(value, fieldEmail, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (Validation.validateEmail(value.trim())) {
            errorMessages[fieldEmail] = "";
          } else {
            if (!onchange) {
              errorMessages[fieldEmail] =
              AppString.invalidEmailFormat; // Updated error message
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages[fieldEmail] =
            AppString.emailRequired; // Updated error message
          }
        });
      });
    }
  }

  checkCommunityName(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_communityNameRegex.hasMatch(value.trim())) {
            errorMessages['communityName'] = "";
          } else {
            if (!onchange) {
              errorMessages['communityName'] =
              AppString.invalidCommunityName; // Updated error message
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['communityName'] =
                AppString.communityNameRequired; // Updated error message
          }
        });
      });
    }
  }

  checkRegistration(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!_registrationNumberRegex.hasMatch(value.trim())) {
            errorMessages['registration Number'] = "";
          } else {
            if (!onchange) {
              errorMessages['registration Number'] =
                  AppString.invalidRegistrationNumber;// Updated error message
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['registration Number'] =
                AppString.registrationNumberRequired; // Updated error message
          }
        });
      });
    }
  }

  checkPhoneNumber(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_phoneNumberRegex.hasMatch(value.trim())) {
            errorMessages['phoneNumber'] = "";
          } else {
            if (!onchange) {
              errorMessages['phoneNumber'] =
              AppString.phoneNumberMustBe10Digits; // Updated error message
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['phoneNumber'] =
                AppString.phoneNumberRequired;  // Updated error message
          }
        });
      });
    }
  }

  checkOwnerFirstName(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_nameRegex.hasMatch(value.trim())) {
            errorMessages['presidentName'] = "";
          } else {
            if (!onchange) {
              errorMessages['presidentName'] =
              AppString.invalidFirstName; // Updated error message
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['presidentName'] =
            AppString.presidentNameRequired; // Updated error message
          }
        });
      });
    }
  }

  checkVehicleType(value, vehicleType, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.isNotEmpty(value.trim())) {
          errorMessages[vehicleType] = "";
        } else {
          if (!onchange) {
            errorMessages[vehicleType] =
                AppString.trans(context, AppString.vehicleTypeError);
          }
        }
      });
    } else {
      setState(() {
        if (!onchange) {
          if (vehicleType == 'Vehicle Type') {
            errorMessages[vehicleType] =
                AppString.trans(context, AppString.vehicleTypeError);
          }
        }
      });
    }
  }

  bool validateFields({isButtonClicked = false}) {
    if (controllers['communityName']?.text == null ||
        controllers['communityName']?.text == '') {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['communityName']);
            setState(() {
              errorMessages['communityName'] =
              AppString.communityNameRequired; // Updated error message
            });
          }
        });
      }
      return false;
    } else if (controllers['registration Number']?.text == null ||
        controllers['registration Number']?.text == '') {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context)
                .requestFocus(focusNodes['registration Number']);
            setState(() {
              errorMessages['registration Number'] =
             AppString.invalidRegistrationNumber; // Updated error message
            });
          }
        });
      }
      return false;
    } else if (_vehicleType == null ||
        !_propertyTypeRegex.hasMatch(_vehicleType!)) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              errorMessages['propertyType'] =
                  AppString.propertyTypeRequired; // Updated error message
            });
          }
        });
      }
      return false;
    } else if (controllers['phoneNumber']?.text.length != 10) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
            setState(() {
              errorMessages['phoneNumber'] =
              AppString.phoneNumberMustBe10Digits; // Updated error message
            });
          }
        });
      }
      return false;
    } else if (controllers['presidentName']?.text == null ||
        controllers['presidentName']?.text == '') {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['presidentName']);
            setState(() {
              errorMessages['presidentName'] =
              AppString.presidentNameRequired; // Updated error message
            });
          }
        });
      }
      return false;
    } else if (controllers['ownerEmail']!.text.isEmpty ||
        controllers['ownerEmail']!.text == '') {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              errorMessages['ownerEmail'] =
              AppString.emailRequired; // Updated error message
            });
          }
        });
      }
      return false;
    } else if (!Validation.validateEmail(controllers['ownerEmail']!.text)) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              errorMessages['ownerEmail'] =
              AppString.invalidEmailFormat; // Updated error message
            });
          }
        });
      }
      return false;
    } else {
      return true;
    }
  }
 @override
  void initState() {
   newSignupBloc = BlocProvider.of<NewSignupBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    Widget communityName() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['communityName'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['communityName']?.toString() ?? '',
          controllerT: controllers['communityName'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.characters,
          cursorColor: Colors.grey,
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text:AppString.communityName, // Normal text
                  style: appStyles
                      .texFieldPlaceHolderStyle(), // Default style for the main text
                  children: [
                    TextSpan(
                      text: ' *', // Asterisk
                      style: appStyles.texFieldPlaceHolderStyle().copyWith(
                          color: Colors.red), // Red color for asterisk
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              )),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.enterCommunityName,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            checkCommunityName(value, onchange: true);
          },
          onEndEditing: (value) {
            checkCommunityName(value);
            FocusScope.of(context)
                .requestFocus(focusNodes['registration Number']);
          },
        ),
      );
    }

    Widget registrationNumber() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['registration Number'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['registration Number']?.toString() ?? '',
          controllerT: controllers['registration Number'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 13,
          errorMsgHeight: 20,
          maxLines: 1,
          autoFocus: false,
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
          ],
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.registrationNumber, // Normal text
                  style: appStyles
                      .texFieldPlaceHolderStyle(), // Default style for the main text
                  children: [
                    TextSpan(
                      text: ' *', // Asterisk
                      style: appStyles.texFieldPlaceHolderStyle().copyWith(
                          color: Colors.red), // Red color for asterisk
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              )),
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText:  AppString.enterRegistrationNumber,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            checkRegistration(value, onchange: true);
          },
          onEndEditing: (value) {
            checkRegistration(value);
          },
        ),
      );
    }

    void showVehicleTypeBottomSheet(BuildContext context) {
      WorkplaceWidgets.showCustomAndroidBottomSheet(
        context: context,
        title: AppString.selectThePropertyType,
        valuesList: propertyTypeList, // List of vehicle types
        selectedValue: _vehicleTypeController.text,
        onValueSelected: (value) {
          setState(() {
            _vehicleTypeController.text = value;
            _vehicleType = value; // Update the vehicle type
            errorMessages['propertyType'] = ""; // Clear error message
          });
        },
      );
    }


    Widget propertyType() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            closeKeyboard();
            showVehicleTypeBottomSheet(context);
          },
          child: AbsorbPointer(
            child: CommonTextFieldWithError(
              focusNode: focusNodes['propertyType'],
              isShowBottomErrorMsg: true,
              errorMessages: errorMessages['propertyType']?.toString() ?? '',
              controllerT: _vehicleTypeController,
              borderRadius: 8,
              inputHeight: 50,
              errorLeftRightMargin: 0,
              maxCharLength: 50,
              readOnly: true,
              errorMsgHeight: 20,
              autoFocus: false,
              showError: true,
              capitalization: CapitalizationText.none,
              enabledBorderColor: AppColors.white,
              focusedBorderColor: AppColors.white,
              backgroundColor: AppColors.white,
              textInputAction: TextInputAction.done,
              borderStyle: BorderStyle.solid,
              cursorColor: Colors.grey,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              placeHolderTextWidget: Padding(
                  padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                  child: Text.rich(
                    TextSpan(
                      text: AppString.propertyType, // Normal text
                      style: appStyles
                          .texFieldPlaceHolderStyle(), // Default style for the main text
                      children: [
                        TextSpan(
                          text: ' *', // Asterisk
                          style: appStyles.texFieldPlaceHolderStyle().copyWith(
                              color: Colors.red), // Red color for asterisk
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  )),
              inputKeyboardType: InputKeyboardTypeWithError.text,
              hintText:  AppString.selectPropertyType,
              hintStyle: appStyles.hintTextStyle(),
              textStyle: appStyles.textFieldTextStyle(),
              contentPadding: const EdgeInsets.only(left: 15, right: 15),
              onTextChange: (value) {
                _vehicleType = value;
              },
              onEndEditing: (value) {
                checkVehicleType(value, 'Vehicle Type', onchange: true);
                FocusScope.of(context).unfocus();
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
      );
    }

    Widget presidentName() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['presidentName'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['presidentName']?.toString() ?? '',
          controllerT: controllers['presidentName'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.characters,
          cursorColor: Colors.grey,
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.presidentName, // Normal text
                  style: appStyles
                      .texFieldPlaceHolderStyle(), // Default style for the main text
                  children: [
                    TextSpan(
                      text: ' *', // Asterisk
                      style: appStyles.texFieldPlaceHolderStyle().copyWith(
                          color: Colors.red), // Red color for asterisk
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              )),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText:AppString.enterPresidentName,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            checkOwnerFirstName(value, onchange: true);
          },
          onEndEditing: (value) {
            checkOwnerFirstName(value);
            FocusScope.of(context).requestFocus(focusNodes['ownerEmail']);
          },
        ),
      );
    }

    Widget phoneNumber() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['phoneNumber'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['phoneNumber']?.toString() ?? '',
          controllerT: controllers['phoneNumber'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 10,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.signUpPhoneNumber, // Normal text
                  style: appStyles
                      .texFieldPlaceHolderStyle(), // Default style for the main text
                  children: [
                    TextSpan(
                      text: ' *', // Asterisk
                      style: appStyles.texFieldPlaceHolderStyle().copyWith(
                          color: Colors.red), // Red color for asterisk
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              )),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.phone,
          hintText: AppString.enterPhoneNumber,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldPrefixIcon: CountryCodePicker(
            showFlag : false,
            enabled: false,
            textStyle: appStyles.textFieldTextStyle(),
            padding: const EdgeInsets.only(
                left:  0,
                top: 0,
                bottom: 0,
                right:10
            ),
            initialSelection: 'IN',
          ),
          onTextChange: (value) {
            checkPhoneNumber(value, onchange: true);
          },
          onEndEditing: (value) {
            checkPhoneNumber(value);
            FocusScope.of(context).requestFocus(focusNodes['ownerEmail']);
          },
        ),
      );
    }

    Widget emailField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['ownerEmail'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['ownerEmail']?.toString() ?? '',
          controllerT: controllers['ownerEmail'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.presidentEmail, // Normal text
                  style: appStyles
                      .texFieldPlaceHolderStyle(), // Default style for the main text
                  children: [
                    TextSpan(
                      text: ' *', // Asterisk
                      style: appStyles.texFieldPlaceHolderStyle().copyWith(
                          color: Colors.red), // Red color for asterisk
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
          hintText: AppString.enterPresidentEmail,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            checkEmail(value, 'ownerEmail', onchange: true);
          },
          onEndEditing: (value) {
            checkEmail(value, 'ownerEmail');
            FocusScope.of(context).requestFocus();
          },
        ),
      );
    }

    Widget termsAndCondition() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
          },
          child: Row(
            children: [
              Checkbox(
                fillColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppColors.appBlueColor; // Blue when checked
                  }
                  return Colors.white; // White when unchecked
                }),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: AppString.iAgreeToThe,
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                    children: [
                      TextSpan(
                        text: AppString.signUpTermsAndConditions,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: AppColors.appBlueColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              SlideLeftRoute(
                                widget:  const TermsAndCondition(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    }

    submitButton() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName: AppString.signUp,
          buttonColor: (validateFields() && isChecked)
              ? AppColors.textBlueColor
              : Colors.grey, // Button color based on validation
          // buttonBorderColor: AppColors.textBlueColor,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          backCallback: () {
            if (validateFields() && isChecked) {
              newSignupBloc.add(OnSignupEvent(
                  communityName:  controllers['communityName']!.text.toString(),
                  registrationNumber: controllers['registration Number']!.text.toString(),
                  propertyType: _vehicleType?.toLowerCase() ?? '',
                  phone: controllers['phoneNumber']!.text.toString(),
                  ownerName: controllers['presidentName']!.text.toString(),
                  ownerEmail: controllers['ownerEmail']!.text.toString(),
            ));
            }
          },
        ),
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      bottomSafeArea: true,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.signUp,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<NewSignupBloc, NewSignupState>(
        listener: (context, state) {
          if (state is SignupErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }

          if (state is SignupDoneState) {
            Fluttertoast.showToast(
              backgroundColor: Colors.green.shade500,
              msg: AppString.yourRequestSendSuccessful,
            );

            if (widget.isSocietyNotFound == true) {
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: const NewLoginWithEmail(),
                ),
              );
            } else {
              context.go("/dashBoard");
            }
          }

        },
        child: BlocBuilder<NewSignupBloc, NewSignupState>(
          bloc: newSignupBloc,
          builder: (context, state) {
            if (state is SignupInitialState) {}
            if (state is SignupLoadingState) {
              if (isShowLoader) {
                return WorkplaceWidgets.progressLoader(context);
              }
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  communityName(),
                  registrationNumber(),
                  propertyType(),
                  phoneNumber(),
                  presidentName(),
                  emailField(),
                  termsAndCondition(),
                  submitButton(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
