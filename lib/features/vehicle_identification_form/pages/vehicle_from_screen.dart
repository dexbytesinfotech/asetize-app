import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../complaints/bloc/house_block_bloc/house_block_bloc.dart';
import '../../complaints/bloc/house_block_bloc/house_block_event.dart';
import '../../complaints/models/house_bloc_model.dart';
import '../../my_vehicle/bloc/my_vehicle_bloc.dart';
import '../bloc/vehicle_identification_form_bloc.dart';
import '../bloc/vehicle_identification_form_event.dart';
import '../bloc/vehicle_identification_form_state.dart';


class AddVehicleForm extends StatefulWidget {
  final int? userId;
  final int? houseId;
  final String? ownerName;
  const AddVehicleForm({super.key,this.userId, this.houseId,this.ownerName = '' });


  @override
  _AddVehicleFormState createState() => _AddVehicleFormState();
}


class _AddVehicleFormState extends State<AddVehicleForm> {
  bool hasAllocatedParking = true; // Default to No
  bool showBlocField = true; // To show/hide the bloc field
  String? _vehicleType;
  String? _registrationNumber;
  bool isButtonClicked = false;
  bool isImageSelected = false;
  String userFullName = '';
  late UserProfileBloc bloc;
  late VehicleFormBloc vehicleFormBloc;
  List<String> blockList = [];

  List<String> vehicleList = ['Car', 'Bike', 'Scooty'];
  int currentBlockIndex = 0;
  File? selectProfilePhoto;
  String? selectProfilePhotoPath;
  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  late MyVehicleListBloc myVehicleListBloc;


  String? selectFromType;
  String blockErrorMessage = '';
  String? selectBlockType;
  int? selectBlockId;




  final TextEditingController _vehicleTypeController = TextEditingController();
  Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'registration Number': TextEditingController(),
    'Vehicle Make': TextEditingController(),
    'Vehicle Type': TextEditingController(),
    'Vehicle Color': TextEditingController(),
    'In Which Block': TextEditingController(),
    'block': TextEditingController(),
  };


  Map<String, FocusNode> focusNodes = {
    'name': FocusNode(),
    'registration Number': FocusNode(),
    'Vehicle Make': FocusNode(),
    'Vehicle Type': FocusNode(),
    'In Which Block': FocusNode(),
    'Vehicle Color': FocusNode(),
    'block': FocusNode(),
  };
  Map<String, String> errorMessages = {
    'name': "",
    'registration Number': "",
    'Vehicle Make': "",
    'Vehicle Type': "",
    'Vehicle Color': "",
    'In Which Block': "",
    'block': "",
  };


  _AddVehicleFormState();
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<UserProfileBloc>(context);
    myVehicleListBloc = BlocProvider.of<MyVehicleListBloc>(context);
    vehicleFormBloc = BlocProvider.of<VehicleFormBloc>(context);
    userFullName = bloc.user.name ?? '';
    if(MainAppBloc.houseBlockList.isNotEmpty){
      blockList = List.generate(
          MainAppBloc.houseBlockList.length,
              (index) {
            return MainAppBloc.houseBlockList[index].blockName ?? ''; // Return the correct type
          }
      );
    }


  }

  //
  // void _showBottomSheet(BuildContext context, List<String> options,
  //     ValueSetter<String> onSelect) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Title and Close Icon
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   'Select Vehicle Type',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 IconButton(
  //                   icon: const Icon(Icons.close,color: AppColors.black,),
  //                   onPressed: () => Navigator.pop(context),
  //                 ),
  //               ],
  //             ),
  //             ListView.separated(
  //               itemCount: options.length,
  //               shrinkWrap: true,
  //               separatorBuilder: (context, index) => const Divider(
  //                 color: Colors.grey,
  //                 thickness: 0.5,
  //               ),
  //               itemBuilder: (context, index) {
  //                 return InkWell(
  //                   onTap: () {
  //                     onSelect(options[index]);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Padding(
  //                     padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
  //                     child: Row(
  //                       children: [
  //                         Text(
  //                           options[index],
  //                           style: const TextStyle(fontSize: 16,          color: Colors.black,),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  //
  //
  //
  // void showBlockBottomSheet(BuildContext context) {
  //   String selectedBlock = controllers['block']?.text.toString() ?? "";
  //   int? selectBlockTypeId2;
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
  //
  //
  //                           setState(() {
  //                             controllers['block']?.text = selectedBlock.toString();
  //
  //
  //                             selectBlockId = selectBlockTypeId2;
  //
  //
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
  //                     maxHeight:  MainAppBloc.houseBlockList.length * 60.0 > 240
  //                         ? 240
  //                         :  MainAppBloc.houseBlockList.length * 60.0,
  //                   ),
  //                   child: ListView.builder(
  //                     padding: EdgeInsets.zero,
  //                     itemCount:  MainAppBloc.houseBlockList.length,
  //                     itemBuilder: (context, index) {
  //                       final block =  MainAppBloc.houseBlockList[index].blockName;
  //                       bool isSelected = selectedBlock == block;
  //                       return GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             selectedBlock = block ?? '';
  //                             selectBlockTypeId2 =   MainAppBloc.houseBlockList[index].id;
  //                           });
  //                         },
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             border: Border.all(color: isSelected ? AppColors.appBlueColor : Colors.transparent ),
  //                             // color: isSelected ? Colors.blue.shade50 : Colors.transparent,
  //                           ),
  //                           child: ListTile(
  //                             title: Text(
  //                               MainAppBloc.houseBlockList[index].blockName ?? "",
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




  void showVehicleTypeBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectVehicleType,
      valuesList: vehicleList, // List of vehicle types
      selectedValue: _vehicleTypeController.text,
      onValueSelected: (value) {
        setState(() {
          _vehicleTypeController.text = value;
          _vehicleType = value; // Update the vehicle type
        });
      },
    );
  }


  void showBlockBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectBlock,
      valuesList: blockList, // List of blocks
      selectedValue: controllers['block']?.text.toString() ?? "",
      onValueSelected: (value) {
        setState(() {
          controllers['block']?.text = value; // Update the selected block
          selectBlockId = MainAppBloc.houseBlockList.firstWhere(
                (block) => block.blockName == value,
          ).id; // Update the block ID based on selection
        });
      },
    );
  }






  Widget fullNameField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['name'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['name']?.toString() ?? '',
        controllerT: TextEditingController(
          text: widget.ownerName!.isNotEmpty?  widget.ownerName ?? "" : bloc.user.name ?? "",
        ),
        // Set name from bloc
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 20,
        maxLines: 1,
        autoFocus: false,
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        showError: false,
        // Hide error since it's read-only
        capitalization: CapitalizationText.none,
        cursorColor: Colors.grey,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
        ],
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.vehicleOwnerName, // Normal text
                style: appStyles
                    .texFieldPlaceHolderStyle(), // Default style for the main text
                children: [
                  TextSpan(
                    text: '*', // Asterisk
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red), // Red color for asterisk
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        inputKeyboardType: InputKeyboardTypeWithError.text,
        hintText: AppString.vehicleOwnerNameHint,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.texFieldPlaceHolderNewStyle(texColor: Colors.black,fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: null,
        // Disable text change listener since it's read-only
        onEndEditing: null,
        // No validation required
        readOnly: true, // Make the field read-only
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
        maxCharLength: 12,
        errorMsgHeight: 20,
        maxLines: 1,
        autoFocus: true,
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        showError: true,
        capitalization: CapitalizationText.none,
        cursorColor: AppColors.appBlueColor,
        inputFormatter: [
          // Ensure that all input is capitalized
          FilteringTextInputFormatter.deny(RegExp(r'\s')), // Disallow spaces
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          // Alphanumeric only
          UpperCaseTextFormatter(),
          // Custom formatter for uppercase
          // RegistrationNumberFormatter(),
          // Your custom formatter for registration number
        ],
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.rcNumberHint, // Normal text
                style: appStyles
                    .texFieldPlaceHolderStyle(), // Default style for the main text
                children: [
                  TextSpan(
                    text: '*', // Asterisk
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red), // Red color for asterisk
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        inputKeyboardType: InputKeyboardTypeWithError.email,
        hintText: AppString.rcNumberHint,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.texFieldPlaceHolderNewStyle(texColor: Colors.black,fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          _registrationNumber = value;
          checkRegistration(value, 'registration Number', onchange: true);
        },
        onEndEditing: (value) {
          checkRegistration(value, 'registration Number', onchange: true);
        },
      ),
    );
  }


  Widget parkingQuestion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child:   Text.rich(
            TextSpan(
              text: AppString.doYouHaveAllocatedParking,
              style: appStyles.texFieldPlaceHolderStyle(),
              children: [
                TextSpan(
                  text: '*',
                  style: appStyles.texFieldPlaceHolderStyle().copyWith(color: Colors.red),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text(AppString.yes),
                value: true,
                activeColor: AppColors.appBlueColor, // Set selected radio color to blue


                groupValue: hasAllocatedParking,
                onChanged: (value) {
                  setState(() {
                    hasAllocatedParking = value!;
                    showBlocField = true; // Show the text field for Yes
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text(AppString.no),
                value: false,
                activeColor: AppColors.appBlueColor,
                groupValue: hasAllocatedParking,
                onChanged: (value) {
                  setState(() {
                    hasAllocatedParking = value!;
                    showBlocField = false; // Hide the text field for No
                  });
                },
              ),
            ),
          ],
        ),
        if (showBlocField)
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: AppString.inWhichBlock,
                    style: appStyles.texFieldPlaceHolderStyle(),
                    children: [
                      TextSpan(
                        text: '*',
                        style: appStyles.texFieldPlaceHolderStyle().copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: blockTypeField(),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     SizedBox(width: 115, child: blockTypeField()),
                //   ],
                // ),
                // Add the error message below the dropdown
                if (blockErrorMessage != "")
                  Padding(
                    padding: const EdgeInsets.only(left: 3, top: 8),
                    child: Text(
                      blockErrorMessage,
                      style: appTextStyle.errorTextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget blockTypeField () {
    return CommonTextFieldWithError(
      inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
      onTapCallBack: () {
        showBlockBottomSheet(context);
      },
      readOnly: true,
      focusNode: focusNodes['block'],
      isShowBottomErrorMsg: true,
      errorMessages: errorMessages['block']?.toString() ?? '',
      controllerT: controllers['block'],
      borderRadius: 8,
      inputHeight: 45,
      errorLeftRightMargin: 0,
      maxCharLength: 500,
      errorMsgHeight: 18,
      maxLines: 1,
      autoFocus: false,
      showError: true,
      showCounterText: false,
      hintStyle: appStyles.hintTextStyle(),
      capitalization: CapitalizationText.sentences,
      cursorColor: Colors.grey,
      isShowShadow: false,
      enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
      errorBorderColor: AppColors.appErrorTextColor,
      focusedBorderColor: AppColors.appBlueColor,
      textInputAction: TextInputAction.newline,
      borderStyle: BorderStyle.solid,
      inputKeyboardType: InputKeyboardTypeWithError.multiLine,
      hintText: AppString.selectInWhichBlock,
      textStyle: appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
      contentPadding:
      const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      onTextChange: (value) {


      },
      onEndEditing: (value) {
      },
    );
  }

  Widget vehicleType() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          showVehicleTypeBottomSheet(context);
          closeKeyboard();
        },
        child: AbsorbPointer(
          // Prevents the keyboard from showing up
          child: CommonTextFieldWithError(
            focusNode: focusNodes['Vehicle Type'],
            isShowBottomErrorMsg: true,
            errorMessages: errorMessages['Vehicle Type']?.toString() ?? '',
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
            isShowShadow: false,
            enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
            errorBorderColor: AppColors.appErrorTextColor,
            focusedBorderColor: AppColors.appBlueColor,
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
                    text: AppString.vehicleType, // Normal text
                    style: appStyles
                        .texFieldPlaceHolderStyle(), // Default style for the main text
                    children: [
                      TextSpan(
                        text: '*', // Asterisk
                        style: appStyles.texFieldPlaceHolderStyle().copyWith(
                            color: Colors.red), // Red color for asterisk
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                )),
            inputKeyboardType: InputKeyboardTypeWithError.email,
            inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),


            hintText: AppString.vehicleTypeHint,
            hintStyle: appStyles.hintTextStyle(),
            textStyle: appStyles.texFieldPlaceHolderNewStyle(texColor: Colors.black,fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.only(left: 15, right: 15),
            onTextChange: (value) {
              _vehicleType = value;
            },
            onEndEditing: (value) {
              checkVehicleType(value, 'Vehicle Type', onchange: true);
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }


  checkName(value, name, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.isNotEmpty(value.trim())) {
          errorMessages[name] = "";
        } else {
          if (!onchange) {
            errorMessages[name] = AppString.trans(context, AppString.nameError);
          }
        }
      });
    } else {
      setState(() {
        if (!onchange) {
          if (name == 'name') {
            errorMessages[name] = AppString.trans(context, AppString.nameError);
          }
        }
      });
    }
  }


  checkRegistration(value, registration, {onchange = false}) {
    final isValidFormat =
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value.trim());


    setState(() {
      if (Validation.isNotEmpty(value.trim())) {
        if (isValidFormat) {
          errorMessages[registration] =
          ""; // Clear error message if the format is correct
        } else {
          errorMessages[registration] = AppString.registrationError;
        }
      } else {
        errorMessages[registration] = AppString.registrationError;
      }
    });


    // Trigger validation to enable/disable the submit button
    validateName();
  }




  void validateBlock(String value, String fieldKey, {bool onChange = false}) {
    final isValidFormat =
    RegExp(r'^[a-zA-Z0-9 ]{3,20}$').hasMatch(value.trim());


    setState(() {
      if (Validation.isNotEmpty(value.trim())) {
        if (isValidFormat) {
          errorMessages[fieldKey] = ""; // Clear error message if valid
        } else {
          errorMessages[fieldKey] =
              AppString.invalidBlockFormat;
        }
      } else {
        errorMessages[fieldKey] = AppString.blockFieldEmpty;
      }
    });


    // Trigger validation for the submit button
    validateName();
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




  bool validateName({isButtonClicked = false}) {
    bool isRegistrationValid = controllers['registration Number'] != null &&
        controllers['registration Number']!.text.trim().isNotEmpty &&
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
            .hasMatch(controllers['registration Number']!.text.trim());


    bool isVehicleTypeSelected = _vehicleTypeController.text.isNotEmpty;
    bool isBlockSelected = selectBlockId != null;


    setState(() {
      if (isButtonClicked) {
        // Validate RC Number
        if (controllers['registration Number'] == null ||
            controllers['registration Number']!.text.trim().isEmpty) {
          errorMessages['registration Number'] = AppString.registrationError;
        } else if (!isRegistrationValid) {
          errorMessages['registration Number'] =
              AppString.registrationError;
        } else {
          errorMessages['registration Number'] = ""; // Clear error if valid
        }


        // Validate "Vehicle Type" only if RC Number is valid
        if (isRegistrationValid) {
          if (!isVehicleTypeSelected) {
            errorMessages['Vehicle Type'] = AppString.vehicleTypeError;
          } else {
            errorMessages['Vehicle Type'] = ""; // Clear error if valid
          }
        }


        // Only validate "In Which Block" if the user has selected "Yes" for parking allocation
        if (isRegistrationValid && isVehicleTypeSelected && hasAllocatedParking) {
          if (!isBlockSelected) {
            blockErrorMessage = AppString.blockErrorMessage; // Error message for block field
          } else {
            blockErrorMessage = ""; // Clear error if block is selected
          }
        }
      }
    });


    // Return true only if RC Number, Vehicle Type, and Block are valid, and parking is allocated
    return isRegistrationValid && isVehicleTypeSelected && (hasAllocatedParking ? isBlockSelected : true);
  }


  @override
  Widget build(BuildContext context) {
    submitButton() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName:AppString.submit,
          buttonColor: validateName() ? AppColors.textBlueColor : Colors.grey,
          buttonBorderColor:
          validateName() ? AppColors.textBlueColor : Colors.grey,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          backCallback:validateName()? () {
            setState(() {
              isButtonClicked = true;
            });
            if (validateName(isButtonClicked: true)) {
              closeKeyboard();
              vehicleFormBloc.add(
                SubmitVehicleFormEvent(
                  registrationNumber: _registrationNumber ?? '',
                  ownerName: bloc.user.name ?? "",
                  vehicleType: _vehicleType?.toLowerCase() ?? '',
                  blockId: selectBlockId,
                  isParkingAllotted:  hasAllocatedParking ? 1 : 0,
                  houseId: widget.houseId,
                  userId: widget.userId,
                  // blockId:    selectBlockType != null ? getBlockId(selectBlockType) : null, // Set blockId here
                  mContext: context, make: '',
                ),
              );
            }
          }:null,
        ),
      );
    }


    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      statusBarColor: const Color(0xFFf9fafb) ,
      appBar: const CommonAppBar(
        title: AppString.vehicleDetail,
        icon: WorkplaceIcons.backArrow,
        isThen: false,
      ),
      containChild: BlocListener<VehicleFormBloc, VehicleFormState>(
        bloc: vehicleFormBloc,
        listener: (context, state) {
          if (state is VehicleFormError) {
            WorkplaceWidgets.errorPopUp(
                context: context,
                content: state.error,
                onTap: () {
                  Navigator.of(context).pop();
                });
          } else if (state is VehicleFormSuccess) {

            WorkplaceWidgets.successToast(AppString.vehicleDetailsAddedSuccessfully);
            Navigator.pop(context, true);
            // Navigator.pop(context, true);
          }
        },
        child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5,),
                  fullNameField(),
                  registrationNumber(),
                  vehicleType(),
                  parkingQuestion(),
                  submitButton(),
                ],
              ),
            ),
      ),
    );
  }


  // Close key board on click
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
}


class RegistrationNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String input = newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');


    if (input.length > 2) {
      input = '${input.substring(0, 2)} ${input.substring(2)}';
    }
    if (input.length > 5) {
      input = '${input.substring(0, 5)} ${input.substring(5)}';
    }
    if (input.length > 8) {
      input = '${input.substring(0, 8)} ${input.substring(8)}';
    }


    return TextEditingValue(
      text: input,
      selection: TextSelection.collapsed(offset: input.length),
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







