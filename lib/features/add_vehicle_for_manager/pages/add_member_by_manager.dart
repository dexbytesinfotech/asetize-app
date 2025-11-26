import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_state.dart';
import 'package:asetize/features/new_sign_up/bloc/new_signup_state.dart';
import '../../../imports.dart';


class AddMemberByManager extends StatefulWidget {
  final String? houseId;
  final String phoneNumber;
  final String? firstName;
  final String? lastName;

  const AddMemberByManager({super.key,this.houseId,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
  });

  @override
  State<AddMemberByManager> createState() => AddMemberByManagerState();
}

class AddMemberByManagerState extends State<AddMemberByManager> {
  late AddVehicleManagerBloc addVehicleManagerBloc;

  final TextEditingController _vehicleTypeController = TextEditingController();
  String? _vehicleType;
  bool isChecked = false;
  bool isShowLoader = true;
  String? _gender; // New variable for gender
  String? _relationship; // New variable for relationship
  final List<String> genderOptions = ['Male', 'Female'];


  Map<String, TextEditingController> controllers = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'email': TextEditingController(),
    'relation': TextEditingController(),
    'gender': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'firstName': FocusNode(),
    'lastName': FocusNode(),
    'phoneNumber': FocusNode(),
    'email': FocusNode(),
    'relation': FocusNode(),
    'gender': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'firstName': "",
    'lastName': "",
    'phoneNumber': "",
    'email': "",
    'relation': "",
    'gender': "",
  };

  final RegExp _phoneNumberRegex = RegExp(r'^\d{10}$');
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  final RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); // Email regex

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  void _showBottomSheet(BuildContext context, List<String> options,
      ValueSetter<String> onSelect) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0).copyWith(top: 8, bottom: 7),
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 0.4,
            ),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  onSelect(options[index]);
                  errorMessages['propertyType'] = "";
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  checkFirstName(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_nameRegex.hasMatch(value.trim())) {
            errorMessages['firstName'] = "";
          } else {
            if (!onchange) {
              errorMessages['firstName'] = AppString.invalidFirstName;
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['firstName'] = AppString.firstNameRequired;
          }
        });
      });
    }
  }

  checkLastName(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_nameRegex.hasMatch(value.trim())) {
            errorMessages['lastName'] = "";
          } else {
            if (!onchange) {
              errorMessages['lastName'] = AppString.invalidLastName;
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['lastName'] = AppString.lastNameRequired;
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
              errorMessages['phoneNumber'] = AppString.phoneNumberMustBe10Digits;
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['phoneNumber'] = AppString.phoneNumberRequired;
          }
        });
      });
    }
  }

  checkEmail(value, {onchange = false}) {
    // if (Validation.isNotEmpty(value.trim())) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     setState(() {
    //       if (_emailRegex.hasMatch(value.trim())) {
    //         errorMessages['email'] = "";
    //       } else {
    //         if (!onchange) {
    //           errorMessages['email'] = AppString.enterValidEmail; // Define this in AppString
    //         }
    //       }
    //     });
    //   });
    // } else {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     setState(() {
    //       if (!onchange) {
    //         errorMessages['email'] = AppString.emailRequired; // Define this in AppString
    //       }
    //     });
    //   });
    // }
  }

  bool validateFields({isButtonClicked = false}) {
    if (controllers['firstName']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['firstName']);
            setState(() {
              errorMessages['firstName'] = AppString.firstNameRequired;
            });
          }
        });
      }
      return false;
    } else if (controllers['lastName']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['lastName']);
            setState(() {
              errorMessages['lastName'] = AppString.lastNameRequired;
            });
          }
        });
      }
      return false;
    }
    else if (controllers['gender']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['gender']);
            setState(() {
              errorMessages['gender'] = 'Gender is required';
            });
          }
        });
      }
      return false;
    } else if (controllers['relation']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['relation']);
            setState(() {
              errorMessages['relation'] = 'Relation is required';
            });
          }
        });
      }
      return false;
    }else if (selectedOption == null) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
          }
        });
      }
      return false;
    }
    // else if (controllers['phoneNumber']?.text.length != 10) {
    //   if (isButtonClicked) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       if (mounted) {
    //         FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
    //         setState(() {
    //           errorMessages['phoneNumber'] = AppString.phoneNumberMustBe10Digits;
    //         });
    //       }
    //     });
    //   }
    //   return false;
    // }

    // else if (controllers['email']?.text.isEmpty ?? true) {
    //   if (isButtonClicked) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       if (mounted) {
    //         FocusScope.of(context).requestFocus(focusNodes['email']);
    //         setState(() {
    //           errorMessages['email'] = AppString.emailRequired; // Define this in AppString
    //         });
    //       }
    //     });
    //   }
    //   return false;
    // } else if (!_emailRegex.hasMatch(controllers['email']!.text.trim())) {
    //   if (isButtonClicked) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       if (mounted) {
    //         FocusScope.of(context).requestFocus(focusNodes['email']);
    //         setState(() {
    //           errorMessages['email'] = AppString.enterValidEmail; // Define this in AppString
    //         });
    //       }
    //     });
    //   }
    //   return false;
    // }

    else {
      return true;
    }
  }
  List valuesList = [];

  @override
  void initState() {
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    controllers['phoneNumber']?.text = widget.phoneNumber ;

    if(widget.firstName!=null){
      controllers['firstName']?.text = widget.firstName! ;
    }
    if(widget.lastName!=null){
      controllers['lastName']?.text = widget.lastName! ;
    }
    Map<String, dynamic> familyRelationships = MainAppBloc.systemSettingData['family_relationships'] ?? {};

    if (familyRelationships.isNotEmpty) {
      valuesList = familyRelationships.values.toList();
    }

    super.initState();
  }

  Widget firstNameField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['firstName'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['firstName']?.toString() ?? '',
        controllerT: controllers['firstName'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 20,
        autoFocus: false,
        readOnly: widget.firstName!=null?true:false,
        showError: true,
        capitalization: CapitalizationText.characters,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.firstNameCapital,
                style: appStyles.texFieldPlaceHolderStyle(),
                children: [
                  TextSpan(
                    text: ' *',
                    style: appStyles.texFieldPlaceHolderStyle().copyWith(
                        color: Colors.red),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.text,
        hintText: AppString.enterFirstName,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          checkFirstName(value, onchange: true);
        },
        onEndEditing: (value) {
          checkFirstName(value);
          FocusScope.of(context).requestFocus(focusNodes['lastName']);
        },
      ),
    );
  }

  Widget lastNameField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['lastName'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['lastName']?.toString() ?? '',
        controllerT: controllers['lastName'],
        readOnly: widget.lastName!=null?true:false,
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 20,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.characters,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.lastName,
                style: appStyles.texFieldPlaceHolderStyle(),
                children: [
                  TextSpan(
                    text: ' *',
                    style: appStyles.texFieldPlaceHolderStyle().copyWith(
                        color: Colors.red),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.text,
        hintText: AppString.enterLastName,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          checkLastName(value, onchange: true);
        },
        onEndEditing: (value) {
          checkLastName(value);
          FocusScope.of(context).requestFocus(focusNodes['email']); // Focus on email
        },
      ),
    );
  }

  Widget emailField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['email'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['email']?.toString() ?? '',
        controllerT: controllers['email'],
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
                text: AppString.enterEmail, // Define this in AppString
                style: appStyles.texFieldPlaceHolderStyle(),
                children: const [
                  // TextSpan(
                  //   text: ' *',
                  //   style: appStyles.texFieldPlaceHolderStyle().copyWith(
                  //       color: Colors.red),
                  // ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.email, // Adjust as necessary
        hintText: AppString.enterEmail, // Define this in AppString
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          // checkEmail(value, onchange: true);
        },
        onEndEditing: (value) {
          // checkEmail(value);
          FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
        },
      ),
    );
  }

  Widget phoneNumber() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['phoneNumber'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['phoneNumber']?.toString() ?? '',
        readOnly: true,
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
                text: AppString.signUpPhoneNumber,
                style: appStyles.texFieldPlaceHolderStyle(),
                children: [
                  TextSpan(
                    text: ' *',
                    style: appStyles.texFieldPlaceHolderStyle().copyWith(
                        color: Colors.red),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
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
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  // void showRelationshipBottomSheet(BuildContext context) {
  //   String selectedRelationship = controllers['relation']?.text.toString() ?? "";
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Container(
  //             decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(15),
  //                 topRight: Radius.circular(15),
  //               ),
  //             ),
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Padding(
  //                   padding: const  EdgeInsets.only(left: 10,right: 10,bottom: 9),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () => Navigator.pop(context),
  //                         child: const  Text(
  //                           "Cancel",
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w500,
  //                             color: AppColors.appBlueColor,
  //                           ),
  //                         ),
  //                       ),
  //                       GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             controllers['relation']?.text = selectedRelationship.toString();
  //                           });
  //                           Navigator.pop(context);
  //                         },
  //                         child: const Text(
  //                           "Set",
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w500,
  //                             color: AppColors.appBlueColor,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const Divider(height: 0,thickness: 0,),
  //                 const SizedBox(height: 6,),
  //                 ConstrainedBox(
  //                   constraints: BoxConstraints(
  //                     maxHeight: valuesList.length * 60.0 > 240
  //                         ? 240
  //                         : valuesList.length * 60.0,
  //                   ),
  //                   child: ListView.builder(
  //                     padding: EdgeInsets.zero,
  //                     itemCount: valuesList.length,
  //                     itemBuilder: (context, index) {
  //                       final relationship = valuesList[index];
  //                       bool isSelected = selectedRelationship == relationship;
  //                       return GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             selectedRelationship = relationship;
  //                           });
  //                         },
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             border: Border.all(color: isSelected ? AppColors.appBlueColor : Colors.transparent ),
  //                             // color: isSelected ? Colors.blue.shade50 : Colors.transparent,
  //                           ),
  //                           child: ListTile(
  //                             title: Text(
  //                               relationship,
  //                               style: const TextStyle(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // void showGenderBottomSheet(BuildContext context) {
  //   String selectedGender = controllers['gender']?.text.toString() ?? "";
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Container(
  //             decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(15),
  //                 topRight: Radius.circular(15),
  //               ),
  //             ),
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Padding(
  //                   padding: const  EdgeInsets.only(left: 10,right: 10,bottom: 9),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () => Navigator.pop(context),
  //                         child: const  Text(
  //                           "Cancel",
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w500,
  //                             color: AppColors.appBlueColor,
  //                           ),
  //                         ),
  //                       ),
  //                       GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             controllers['gender']?.text = selectedGender.toString();
  //                           });
  //                           Navigator.pop(context);
  //                         },
  //                         child: const Text(
  //                           "Set",
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w500,
  //                             color: AppColors.appBlueColor,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const Divider(height: 0,thickness: 0,),
  //                 const SizedBox(height: 6,),
  //                 ConstrainedBox(
  //                   constraints: BoxConstraints(
  //                     maxHeight: genderOptions.length * 60.0 > 240
  //                         ? 240
  //                         : genderOptions.length * 60.0,
  //                   ),
  //                   child: ListView.builder(
  //                     padding: EdgeInsets.zero,
  //                     itemCount: genderOptions.length,
  //                     itemBuilder: (context, index) {
  //                       final gender = genderOptions[index];
  //                       bool isSelected = selectedGender == gender;
  //                       return GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             selectedGender = gender;
  //                           });
  //                         },
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             border: Border.all(color: isSelected ? AppColors.appBlueColor : Colors.transparent ),
  //                             // color: isSelected ? Colors.blue.shade50 : Colors.transparent,
  //                           ),
  //                           child: ListTile(
  //                             title: Text(
  //                               gender,
  //                               style: const TextStyle(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }



  void showRelationshipBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectRelationship,
      valuesList: valuesList,
      selectedValue: controllers['relation']?.text.toString() ?? "",
      onValueSelected: (value) {
        controllers['relation']?.text = value;
      },
    );
  }


  void showGenderBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectGender,
      valuesList: genderOptions,
      selectedValue: controllers['gender']?.text.toString() ?? "",
      onValueSelected: (value) {
        controllers['gender']?.text = value;
      },
    );
  }


  Widget relationshipField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        onTapCallBack: ()
        {
          showRelationshipBottomSheet(context);
        },
        focusNode: focusNodes['relation'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['relation']?.toString() ?? '',
        readOnly: true,
        controllerT: controllers['relation'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 10,
        errorMsgHeight: 20,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.none,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.selectTheRelationship,
                style: appStyles.texFieldPlaceHolderStyle(),
                children: [
                  TextSpan(
                    text: ' *',
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: AppString.selectTheRelationship,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldSuffixIcon: Icon(Icons.keyboard_arrow_down,color: Colors.black.withOpacity(0.8),),
        onTextChange: (value) {
          //  checkPhoneNumber(value, onchange: true);
        },
        onEndEditing: (value) {
          // checkPhoneNumber(value);
          // FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget genderField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        onTapCallBack: ()
        {
          showGenderBottomSheet(context);
        },
        focusNode: focusNodes['gender'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['gender']?.toString() ?? '',
        readOnly: true,
        controllerT: controllers['gender'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 10,
        errorMsgHeight: 20,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.none,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.selectTheGender,
                style: appStyles.texFieldPlaceHolderStyle(),
                children: [
                  TextSpan(
                    text: ' *',
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: AppString.selectTheGender,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldSuffixIcon: Icon(Icons.keyboard_arrow_down,color: Colors.black.withOpacity(0.8),),
        onTextChange: (value) {
          //  checkPhoneNumber(value, onchange: true);
        },
        onEndEditing: (value) {
          // checkPhoneNumber(value);
          // FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  bool isYouAreVisible = true; // Control visibility of selectYouAre
  String? selectedOption; // Store selected option
  bool isButtonVisible = false; // Control button visibility

  Widget selectYouAre() {
    final options = [
      'Owner',
      'Tenant',
    ];

    Widget buildOption(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Space between options
        child: InkWell(
          onTap: () {
            setState(() {
              selectedOption = title;
              isButtonVisible = true;
            });
          },
          child: Row(
            mainAxisSize:
            MainAxisSize.min, // Row adapts to the width of its children
            children: [
              Radio<String>(
                value: title,
                activeColor: AppColors.appBlueColor,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                    isButtonVisible = true;
                  });
                },
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black), // Adjust font size for compactness
              ),
            ],
          ),
        ),
      );
    }

    return Visibility(
      visible: isYouAreVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text.rich(
              TextSpan(
                text: AppString.youAre, // Placeholder text
                style: appStyles.texFieldPlaceHolderStyle(),
                children: [
                  TextSpan(
                    text: ' *',
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
          // Row of options
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0,).copyWith(left: 1),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.start, // Align row to the start
              children: options
                  .map(buildOption)
                  .toList(), // Dynamically build options
            ),
          ),
        ],
      ),
    );
  }

  submitButton() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName: AppString.submitButton,
          buttonColor: (validateFields())
              ? AppColors.textBlueColor
              : Colors.grey,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          backCallback: (validateFields())? () {
            if (validateFields(isButtonClicked: true)) {
              addVehicleManagerBloc.add(OnAddMemberByManagerEvent(
                  houseId: widget.houseId,
                  mContext: context,
                  email:  controllers['email']!.text.toString(),
                  firstName:  controllers['firstName']!.text.toString(),
                  lastName:  controllers['lastName']!.text.toString(),
                  phone: int.parse(controllers['phoneNumber']!.text),
                  countryCode:int.parse('91'),
                  role:selectedOption.toString().toLowerCase(),
                  gender: controllers['gender']!.text.toString().toLowerCase(), // Include gender
                  relationship: controllers['relation']!.text.toString().toLowerCase(),
                  isPrimaryMember: 0
              ));
            }
          }:null,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      bottomSafeArea: true,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.addMember,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
        listener: (context, state) {
          if (state is AddMemberByManagerErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is AddMemberByManagerDoneState) {
            WorkplaceWidgets.successToast(AppString.memberAddedSuccessfully,durationInSeconds: 1);
            Navigator.pop(context, true);
          }
        },
        child: BlocBuilder<AddVehicleManagerBloc, AddVehicleManagerState>(
          bloc: addVehicleManagerBloc,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      phoneNumber(),
                      firstNameField(),
                      lastNameField(),
                      emailField(), // New email field
                      genderField(),
                      relationshipField(),
                      selectYouAre(), // New selectYouAre widget
                      submitButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                  if (state is AddVehicleManagerLoadingState)
                    Center(
                      child: WorkplaceWidgets.progressLoader(context, color: Colors.transparent),
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