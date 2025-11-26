import 'package:flutter/cupertino.dart';
import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_state.dart';
import 'package:asetize/features/new_sign_up/bloc/new_signup_state.dart';
import '../../../app_global_components/cupertino_custom_picker.dart';
import '../../../imports.dart';

class AddFamilyMember extends StatefulWidget {
  final String? houseId;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;

  const AddFamilyMember(
      {super.key,
      this.houseId,
      this.phoneNumber,
      this.firstName,
      this.lastName});

  @override
  State<AddFamilyMember> createState() => AddFamilyMemberState();
}

class AddFamilyMemberState extends State<AddFamilyMember> {
  late AddVehicleManagerBloc addVehicleManagerBloc;

  final TextEditingController _vehicleTypeController = TextEditingController();
  bool isChecked = false;
  bool isShowLoader = true;

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
  final RegExp _emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); // Email regex
  final List<String> genderOptions = ['Male', 'Female'];

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

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
              errorMessages['phoneNumber'] =
                  AppString.phoneNumberMustBe10Digits;
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
    } else if (controllers['gender']?.text.isEmpty ?? true) {
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
    } else if (selectedOption == null) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {}
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

    if (widget.phoneNumber != null) {
      controllers['phoneNumber']?.text = widget.phoneNumber!;
    }

    if (widget.firstName != null) {
      controllers['firstName']?.text = widget.firstName!;
    }
    if (widget.lastName != null) {
      controllers['lastName']?.text = widget.lastName!;
    }

    Map<String, dynamic> familyRelationships =
        MainAppBloc.systemSettingData['family_relationships'];

    valuesList = familyRelationships.values.toList();

    super.initState();
  }

  Widget firstNameField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
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
        errorMsgHeight: 24,
        autoFocus: false,
        readOnly: widget.firstName != null ? true : false,
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
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red),
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
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['lastName'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['lastName']?.toString() ?? '',
        controllerT: controllers['lastName'],
        readOnly: widget.lastName != null ? true : false,
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 24,
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
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red),
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
        hintText: AppString.enterLastName,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          checkLastName(value, onchange: true);
        },
        onEndEditing: (value) {
          checkLastName(value);
          FocusScope.of(context)
              .requestFocus(focusNodes['email']); // Focus on email
        },
      ),
    );
  }

  Widget emailField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
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
        errorMsgHeight: 24,
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
                children: const [],
              ),
              textAlign: TextAlign.start,
            )),
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType:
            InputKeyboardTypeWithError.email, // Adjust as necessary
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
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
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
        errorMsgHeight: 24,
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
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red),
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
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: AppString.enterPhoneNumber,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldPrefixIcon: CountryCodePicker(
          showFlag: false,
          enabled: false,
          textStyle: appStyles.textFieldTextStyle(),
          padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 10),
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

  bool isYouAreVisible = true; // Control visibility of selectYouAre
  String? selectedOption; // Store selected option
  bool isButtonVisible = false; // Control button visibility

  Widget selectYouAre() {
    // List of options
    final options = [
      'Owner',
      'Tenant',
      // 'Renting with family',
      // 'Renting with other flatmates',
    ];

    // Function to create a Row of options
    Widget buildOption(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), // Space between options
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
      );
    }

    return Visibility(
      visible: isYouAreVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
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
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
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

  void showRelationshipBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectRelationship,
      valuesList: valuesList,
      selectedValue: controllers['relation']?.text ?? "",
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
        onTapCallBack: () {
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
        errorMsgHeight: 24,
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
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: AppString.selectTheRelationship,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldSuffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black.withOpacity(0.8),
        ),
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
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        onTapCallBack: () {
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
        errorMsgHeight: 24,
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
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: AppString.selectTheGender,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldSuffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black.withOpacity(0.8),
        ),
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

  submitButton(state) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName: AppString.submitButton,
          buttonColor:
              (validateFields()) ? AppColors.textBlueColor : Colors.grey,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          // isLoader: state is AddVehicleManagerLoadingState ? true:false,
          backCallback: () {
            if (validateFields(isButtonClicked: true)) {
              if (widget.houseId != null) {
                addVehicleManagerBloc.add(OnAddMemberByManagerEvent(
                    houseId: widget.houseId,
                    mContext: context,
                    email: controllers['email']!.text.toString(),
                    firstName: controllers['firstName']!.text.toString(),
                    lastName: controllers['lastName']!.text.toString(),
                    phone: int.parse(controllers['phoneNumber']!.text),
                    countryCode: 91,
                    role: selectedOption.toString().toLowerCase(),
                    gender: controllers['gender']!
                        .text
                        .toString()
                        .toLowerCase(), // Include gender
                    relationship: controllers['relation']!
                        .text
                        .toString()
                        .toLowerCase(), // Include relationship
                    isPrimaryMember: 0));
              }
            }
          },
        ));
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
        title: AppString.addFamilyMember,
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
                      const SizedBox(height: 20),
                      phoneNumber(),
                      const SizedBox(height: 8),
                      firstNameField(),
                      const SizedBox(height: 8),
                      lastNameField(),
                      const SizedBox(height: 8),
                      emailField(),
                      const SizedBox(height: 8),
                      genderField(), // New gender field
                      const SizedBox(height: 8),
                      relationshipField(), // New relationship field
                      const SizedBox(height: 8),
                      selectYouAre(),
                      const SizedBox(height: 8),
                      submitButton(state),
                      const SizedBox(height: 20),
                    ],
                  ),
                  if (state is AddVehicleManagerLoadingState)
                    Center(
                      child: WorkplaceWidgets.progressLoader(context),
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
