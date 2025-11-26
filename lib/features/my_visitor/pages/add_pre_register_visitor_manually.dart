import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import '../../../imports.dart';
import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_state.dart';

class AddGuest extends StatefulWidget {
  const AddGuest({super.key});

  @override
  State<AddGuest> createState() => _AddGuestState();
}

class _AddGuestState extends State<AddGuest> {
  late AddVehicleManagerBloc addVehicleManagerBloc;

  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final FocusNode _guestNameFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();

  Map<String, String> errorMessages = {
    'guestName': '',
    'phoneNumber': '',
  };

  final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  final RegExp _phoneNumberRegex = RegExp(r'^\d{10}$');

  @override
  void initState() {
    super.initState();
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
  }

  void checkGuestName(String value, {bool onchange = false}) {
    if (value.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_nameRegex.hasMatch(value.trim())) {
            errorMessages['guestName'] = '';
          } else {
            if (!onchange) {
              errorMessages['guestName'] = 'Invalid name';
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['guestName'] = 'Guest name is required';
          }
        });
      });
    }
  }

  void checkPhoneNumber(String value, {bool onchange = false}) {
    if (value.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_phoneNumberRegex.hasMatch(value.trim())) {
            errorMessages['phoneNumber'] = '';
          } else {
            if (!onchange) {
              errorMessages['phoneNumber'] = 'Phone number must be 10 digits';
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['phoneNumber'] = 'Phone number is required';
          }
        });
      });
    }
  }

  bool validateFields({bool isButtonClicked = false}) {
    if (_guestNameController.text.isEmpty) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_guestNameFocus);
            setState(() {
              errorMessages['guestName'] = 'Guest name is required';
            });
          }
        });
      }
      return false;
    } else if (!_nameRegex.hasMatch(_guestNameController.text.trim())) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_guestNameFocus);
            setState(() {
              errorMessages['guestName'] = 'Invalid name';
            });
          }
        });
      }
      return false;
    } else if (_phoneNumberController.text.isEmpty) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_phoneNumberFocus);
            setState(() {
              errorMessages['phoneNumber'] = 'Phone number is required';
            });
          }
        });
      }
      return false;
    } else if (!_phoneNumberRegex.hasMatch(_phoneNumberController.text.trim())) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_phoneNumberFocus);
            setState(() {
              errorMessages['phoneNumber'] = 'Phone number must be 10 digits';
            });
          }
        });
      }
      return false;
    }
    return true;
  }

  Widget guestNameField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: _guestNameFocus,
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['guestName'] ?? '',
        controllerT: _guestNameController,
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
              text: 'Guest Name',
              style: appStyles.texFieldPlaceHolderStyle(),
              children: [
                TextSpan(
                  text: ' *',
                  style: appStyles.texFieldPlaceHolderStyle().copyWith(color: Colors.red),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.text,
        hintText: 'Enter Guest Name',
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          checkGuestName(value, onchange: true);
        },
        onEndEditing: (value) {
          checkGuestName(value);
          FocusScope.of(context).requestFocus(_phoneNumberFocus);
        },
      ),
    );
  }

  Widget phoneNumberField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: _phoneNumberFocus,
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['phoneNumber'] ?? '',
        controllerT: _phoneNumberController,
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
              text: 'Mobile Number',
              style: appStyles.texFieldPlaceHolderStyle(),
              children: [
                TextSpan(
                  text: ' *',
                  style: appStyles.texFieldPlaceHolderStyle().copyWith(color: Colors.red),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: 'Enter Mobile Number',
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

  Widget addGuestButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: AppButton(
        buttonName: 'Add Guest',
        buttonColor: validateFields() ? AppColors.textBlueColor : Colors.grey,
        textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
        backCallback: () {

            if (validateFields()) {
              // addVehicleManagerBloc.add(OnAddGuestEvent(
              //   mContext: context,
              //   guestName: _guestNameController.text.trim(),
              //   phone: int.parse(_phoneNumberController.text.trim()),
              //   countryCode: 91,
              // ));
              // Return guest data to the parent screen
              Navigator.pop(context, {
                'name': _guestNameController.text.trim(),
                'phone': _phoneNumberController.text.trim(),
              });
            }

        },
      ),
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
        title: 'Add Guest Manually',
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
        listener: (context, state) {
          if (state is AddVehicleManagerErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
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
                      guestNameField(),
                      phoneNumberField(),
                      addGuestButton(),
                      const SizedBox(height: 20),
                    ],
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