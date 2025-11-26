import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../noc_list/models/noc_singal_request_model.dart';
import '../bloc/my_unit_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../widgets/common_image_view.dart';
import '../widgets/common_pdf_view.dart';
import 'noc_payment_screenshot_upload_screen.dart';

class RequestForNocScreen extends StatefulWidget {
  final int? houseId;
  final String? title;
  final SingalData? nocEditData;


  const RequestForNocScreen({super.key,  this.houseId,  this.title, this.nocEditData});
  @override
  State<RequestForNocScreen> createState() => _RequestForNocScreenState();
}

class _RequestForNocScreenState extends State<RequestForNocScreen> {
  bool isLoading = true;
  late MyUnitBloc myUnitBloc;
  String? selectedBrokerId;
  bool? hasPoliceVerificationCompleted;


  Map<String, TextEditingController> controllers = {
    'reasonForNoc': TextEditingController(),
    'remarkForNoc': TextEditingController(),
    'newFirstName': TextEditingController(),
    'newLastName': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'newAddress': TextEditingController(),
    'brokerName': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'reasonForNoc': FocusNode(),
    'remarkForNoc': FocusNode(),
    'newFirstName': FocusNode(),
    'newLastName': FocusNode(),
    'phoneNumber': FocusNode(),
    'newAddress': FocusNode(),
    'brokerName': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'reasonForNoc': "",
    'remarkForNoc': "",
    'newFirstName': "",
    'newLastName': "",
    'phoneNumber': "",
    'newAddress': "",
    'brokerName': "",
  };

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  List reasonsList = [];
  List<dynamic> reasonsTypeList = [];
  String formatReasonForNoc(String? reasonForNoc) {
    if (reasonForNoc == null || reasonForNoc.isEmpty) {
      return '';
    }
    String formatted = reasonForNoc.replaceAll('-', ' ').toLowerCase();
    if (formatted.isEmpty) {
      return '';
    }
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
  void setData() {
    if(widget.nocEditData==null){
      return ;
    }
    controllers['reasonForNoc']?.text = widget.nocEditData!.purpose ?? '';
    controllers['remarkForNoc']?.text = widget.nocEditData!.remarks ?? '';
    controllers['newFirstName']?.text = widget.nocEditData!.firstName ?? '';
    controllers['newLastName']?.text = widget.nocEditData!.lastName ?? '';
    controllers['phoneNumber']?.text =
        (widget.nocEditData!.phone ?? '').replaceFirst('+91', '');

    controllers['newAddress']?.text = widget.nocEditData!.address ?? '';
    controllers['brokerName']?.text = widget.nocEditData!.broker?.name ?? '';
    if(widget.nocEditData?.isCompletedPoliceVerification != null||widget.nocEditData?.isCompletedPoliceVerification != '') {
      hasPoliceVerificationCompleted =widget.nocEditData?.isCompletedPoliceVerification;
    }
  }
  @override
  void initState() {
    super.initState();
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    setData();
    reasonsList = MainAppBloc.systemSettingData['noc_types'] ?? [];
    myUnitBloc.nocSubmittedData = null;
    myUnitBloc.getNocData = null;
    if (reasonsList.isNotEmpty) {
      reasonsTypeList = reasonsList.map((item) => formatReasonForNoc(item.toString())).toList();
    }
  }

  void showReasonBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.titleReasonForNOC,
      valuesList: reasonsList,
      selectedValue: controllers['reasonForNoc']?.text.toString() ?? "",
      onValueSelected: (value) {
        controllers['reasonForNoc']?.text = value;
        setState(() {
          errorMessages['reasonForNoc'] = "";
          controllers['newFirstName']?.clear();
          controllers['newLastName']?.clear();
          controllers['newAddress']?.clear();
          controllers['remarkForNoc']?.clear();
          controllers['phoneNumber']?.clear();
          errorMessages['newFirstName'] = "";
          errorMessages['newLastName'] = "";
          errorMessages['newAddress'] = "";
        });
      },
    );
  }

  void showBrokerBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.titleBroker,
      valuesList: MainAppBloc.brokerListData.map((broker) => broker.name).toList(),
      selectedValue: controllers['brokerName']?.text.toString() ?? "",
      onValueSelected: (value) {
        final selectedBroker = MainAppBloc.brokerListData.firstWhere(
              (broker) => broker.name == value,
        );
        controllers['brokerName']?.text = selectedBroker.name ?? '';
        selectedBrokerId = selectedBroker.id.toString(); // Save broker ID
            },
    );
  }

  bool validateFields({bool isButtonClicked = false}) {
    if (isButtonClicked) {
      setState(() {
        errorMessages.updateAll((key, value) => "");
      });
    }
    if (controllers['reasonForNoc']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        setState(() {
          errorMessages['reasonForNoc'] = AppString.reasonForNOCRequired;
        });
        FocusScope.of(context).requestFocus(focusNodes['reasonForNoc']);
      }
      return false;
    }
    String reason = controllers['reasonForNoc']?.text.toLowerCase() ?? '';
    if (reason == 'sale of property' || reason == 'rental agreement') {
      if (controllers['newFirstName']?.text.isEmpty == true) {
        if (isButtonClicked) {
          setState(() {
            errorMessages['newFirstName'] = reason == 'sale of property'
                ? AppString.firstNameRequired
                : AppString.firstNameRequired;
          });
          FocusScope.of(context).requestFocus(focusNodes['newFirstName']);
        }
        return false;
      }

      if (controllers['newLastName']?.text.isEmpty ?? true) {
        if (isButtonClicked) {
          setState(() {
            errorMessages['newLastName'] = reason == 'sale of property'
                ? AppString.lastNameRequired
                : AppString.lastNameRequired;
          });
          FocusScope.of(context).requestFocus(focusNodes['newLastName']);
        }
        return false;
      }

      if (controllers['phoneNumber']?.text.isEmpty ?? true) {
        if (isButtonClicked) {
          setState(() {
            errorMessages['phoneNumber'] = AppString.phoneNumberRequired;
          });
          FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
        }
        return false;
      } else if (controllers['phoneNumber']?.text.length != 10) {
        if (isButtonClicked) {
          setState(() {
            errorMessages['phoneNumber'] = AppString.phoneNumberMustBe10Digits;
          });
          FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
        }
        return false;
      }



      if (controllers['newAddress']?.text.isEmpty ?? true) {
        if (isButtonClicked) {
          setState(() {
            errorMessages['newAddress'] = reason == 'sale of property'
                ?  AppString.addressRequired
                : AppString.addressRequired;
          });
          FocusScope.of(context).requestFocus(focusNodes['newAddress']);
        }
        return false;
      }
    }
    String reasonForAgreement = controllers['reasonForNoc']?.text.toLowerCase() ?? '';
    if (reasonForAgreement == 'rental agreement') {
      if (hasPoliceVerificationCompleted == null) {
        if (isButtonClicked) {
          setState(() {
            errorMessages['policeVerification'] = AppString.policeVerificationRequired;
          });
        }
        return false;
      }
    }
    return true;
  }

  void _showPendingVerificationPopup(BuildContext context) {
    WorkplaceWidgets.errorPopUp(
        context: context,
        isShowIcon: true,
        content: AppString.pendingPoliceVerificationContent,
        onTap: () {
          Navigator.of(context).pop();
        });

  }

  void showNocPaymentConfirmationPopup(BuildContext context) {
    WorkplaceWidgets.errorPopUp(
        context: context,
        isShowIcon: false,
        content: AppString.nocPaymentPopup,
        onTap: () {
          Navigator.of(context).pop();
        });
  }


  @override
  Widget build(BuildContext context) {
    Widget reasonForNocField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: () {
            showReasonBottomSheet(context);
          },
          focusNode: focusNodes['reasonForNoc'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['reasonForNoc']?.toString() ?? '',
          readOnly: true,
          controllerT: controllers['reasonForNoc'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: AppColors.appBlueColor,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.reasonForNOCLabel,
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
          isShowShadow: false,
          enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
          errorBorderColor: AppColors.appErrorTextColor,
          focusedBorderColor: AppColors.appBlueColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.selectReasonForNOC,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon:WorkplaceWidgets.downArrowIcon(),
          onTextChange: (value) {},
          onEndEditing: (value) {
            FocusScope.of(context).requestFocus(focusNodes['remarkForNoc']);
          },
        ),
      );
    }

    Widget brokerName() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: () {
            showBrokerBottomSheet(context);
          },
          focusNode: focusNodes['brokerName'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['brokerName']?.toString() ?? '',
          readOnly: true,
          controllerT: controllers['brokerName'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: AppColors.appBlueColor,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.brokerName,
                style: appStyles.texFieldPlaceHolderStyle(),
                children: const [

                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
          isShowShadow: false,
          enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
          errorBorderColor: AppColors.appErrorTextColor,
          focusedBorderColor: AppColors.appBlueColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.selectBrokerName,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
          onTextChange: (value) {},
          onEndEditing: (value) {
          },
        ),
      );
    }

    Widget remarkForNocField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['remarkForNoc'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['remarkForNoc']?.toString() ?? '',
          controllerT: controllers['remarkForNoc'],
          readOnly: false,
          borderRadius: 8,
          inputHeight: 100,
          errorLeftRightMargin: 0,
          maxCharLength: 200,
          errorMsgHeight: 20,
          minLines: 3,
          maxLines: 3,
          autoFocus: false,
          showError: true,
          showCounterText: false,
          capitalization: CapitalizationText.sentences,
          cursorColor: AppColors.appBlueColor,
          isShowShadow: false,
          enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
          errorBorderColor: AppColors.appErrorTextColor,
          focusedBorderColor: AppColors.appBlueColor,
          backgroundColor: Colors.white,
          textInputAction: TextInputAction.done,
          borderStyle: BorderStyle.solid,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.additionalNotes,
                style: appStyles.texFieldPlaceHolderStyle(),
                children: const [
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
          inputKeyboardType: InputKeyboardTypeWithError.multiLine,
          hintText: AppString.enterAdditionalNotes,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          onTextChange: (value) {

          },
          onEndEditing: (value) {
            FocusScope.of(context).requestFocus(focusNodes['newFirstName']);
          },
        ),
      );
    }

    Widget newFirstNameField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20,),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['newFirstName'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['newFirstName']?.toString() ?? '',
          controllerT: controllers['newFirstName'],
          readOnly: false,
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.words,
          cursorColor: AppColors.appBlueColor,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.firstNameLabel,
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
          isShowShadow: false,
          enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
          errorBorderColor: AppColors.appErrorTextColor,
          focusedBorderColor: AppColors.appBlueColor,
          backgroundColor: AppColors.white,
          borderStyle: BorderStyle.solid,
          textInputAction: TextInputAction.next,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.enterFirstNameHint,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            setState(() {
              errorMessages['newFirstName'] = value.trim().isEmpty ? AppString.firstNameRequired : '';
            });
          },
          onEndEditing: (value) {
            FocusScope.of(context).requestFocus(focusNodes['newLastName']);
          },
        ),
      );
    }

    Widget newLastNameField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20,),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['newLastName'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['newLastName']?.toString() ?? '',
          controllerT: controllers['newLastName'],
          readOnly: false,
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.words,
          cursorColor: AppColors.appBlueColor,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.lastName,
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
          isShowShadow: false,
          enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
          errorBorderColor: AppColors.appErrorTextColor,
          focusedBorderColor: AppColors.appBlueColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.enterLastNameHint,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            setState(() {
              errorMessages['newLastName'] = value.trim().isEmpty
                  ? AppString.lastNameRequired
                  : '';
            });
          },
          onEndEditing: (value) {
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
          readOnly: false,
          controllerT: controllers['phoneNumber'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 10,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: AppColors.appBlueColor,
          inputFormatter: [
            FilteringTextInputFormatter.digitsOnly, // Allow only digits
            LengthLimitingTextInputFormatter(10), // Limit to 10 digits
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
                    style: appStyles.texFieldPlaceHolderStyle().copyWith(color: Colors.red),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
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
            showFlag: false,
            enabled: false,
            textStyle: appStyles.textFieldTextStyle(),
            padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 10),
            initialSelection: 'IN',
          ),
          onTextChange: (value) {
            setState(() {
              if (value.trim().isEmpty) {
                errorMessages['phoneNumber'] = AppString.phoneNumberRequired;
              } else if (value.length != 10) {
                errorMessages['phoneNumber'] = AppString.phoneNumberMustBe10Digits;
              } else {
                errorMessages['phoneNumber'] = '';
              }
            });
          },
          onEndEditing: (value) {
            FocusScope.of(context).requestFocus(focusNodes['newAddress']);
          },
        ),
      );
    }

    Widget newAddressField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20,),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['newAddress'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['newAddress']?.toString() ?? '',
          controllerT: controllers['newAddress'],
          readOnly: false,
          borderRadius: 8,
          inputHeight: 100,
          errorLeftRightMargin: 0,
          maxCharLength: 200,
          errorMsgHeight: 20,
          minLines: 3,
          maxLines: 3,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.sentences,
          cursorColor: AppColors.appBlueColor,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.address,
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
          isShowShadow: false,
          enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
          errorBorderColor: AppColors.appErrorTextColor,
          focusedBorderColor: AppColors.appBlueColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.multiLine,
          hintText: AppString.enterAddress,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          onTextChange: (value) {
            setState(() {
              errorMessages['newAddress'] = value.trim().isEmpty
                  ? AppString.addressRequired
                  : '';
            });
          },
          onEndEditing: (value) {
            FocusScope.of(context).unfocus();
          },
        ),
      );
    }

    Widget policeVerificationQuestions() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Text.rich(
              TextSpan(
                text: AppString.policeVerification,
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
                child: RadioListTile<bool?>(
                  title: const Text(AppString.completed),
                  value: true,
                  activeColor: AppColors.appBlueColor,
                  groupValue: hasPoliceVerificationCompleted ,
                  onChanged: (value) {
                    setState(() {
                      hasPoliceVerificationCompleted = value;
                      errorMessages['policeVerification'] = ""; // Clear error when selected
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<bool?>(
                  title: const Text(AppString.pending),
                  value: false,
                  activeColor: AppColors.appBlueColor,
                  groupValue: hasPoliceVerificationCompleted,
                  onChanged: (value) {
                    setState(() {
                      hasPoliceVerificationCompleted = value;
                      errorMessages['policeVerification'] = ""; // Clear error when selected
                      // Show popup when "Pending" is selected
                      if (value == false) {
                        _showPendingVerificationPopup(context);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          if (errorMessages['policeVerification']?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 0),
              child: Text(
                errorMessages['policeVerification']!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    }

    Widget submitButton(state) {
      String reason = controllers['reasonForNoc']?.text.toLowerCase() ?? '';
      bool isPoliceVerificationValid = reason != 'rental agreement' || hasPoliceVerificationCompleted != null;
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName: AppString.submit,
          buttonColor: (validateFields() &&  isPoliceVerificationValid) ? AppColors.textBlueColor : Colors.grey,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          isLoader: state is SubmitRequestForNOCLoadingState ||state is UpdateRequestForNOCLoadingState ? true : false,
          backCallback: () {
            if (validateFields()) {
              closeKeyboard();
              int? isCompletedPoliceVerification;
              if (reason == "rental agreement") {
                isCompletedPoliceVerification = hasPoliceVerificationCompleted! ? 1 : 0;
              }

              if(widget.nocEditData!=null)
              {
                if(widget.nocEditData!.id!=null) {
                  myUnitBloc.add(
                    OnUpdateRequestForNOCEvent(
                      mContext: context,
                      id:widget.nocEditData?.id  ,
                      houseId: widget.houseId ?? 0,
                      reason: controllers['reasonForNoc']!.text.toString(),
                      remark: controllers['remarkForNoc']!.text.toString(),
                      firstName: projectUtil.capitalize(controllers['newFirstName']!.text),
                      lastName: projectUtil.capitalize(controllers['newLastName']!.text),
                      address: controllers['newAddress']!.text,
                      phoneNumber: controllers['phoneNumber']!.text,
                      brokerId: selectedBrokerId ?? widget.nocEditData?.broker?.id.toString(),
                      isCompletedPoliceVerification: isCompletedPoliceVerification,
                    ),
                  );
                }
                else{

                }
              }
              else
              {
                myUnitBloc.add(
                  OnSubmitRequestForNOCEvent(
                    mContext: context,
                    houseId: widget.houseId ?? 0,
                    reason: controllers['reasonForNoc']!.text.toString(),
                    remark: controllers['remarkForNoc']!.text.toString(),
                    firstName: projectUtil.capitalize(controllers['newFirstName']!.text),
                    lastName: projectUtil.capitalize(controllers['newLastName']!.text),
                    address: controllers['newAddress']!.text,
                    phoneNumber: controllers['phoneNumber']!.text,
                    brokerId: selectedBrokerId,
                    isCompletedPoliceVerification: isCompletedPoliceVerification,
                  ),
                );
              }



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
      appBar: CommonAppBar(
        title: AppString.requestNOCFor(widget.title ?? widget.nocEditData?.title ?? ''),
        icon: WorkplaceIcons.backArrow,
        isThen: false,
      ),
      containChild: BlocListener<MyUnitBloc, MyUnitState>(
        bloc: myUnitBloc,
        listener: (BuildContext context, MyUnitState state) {
          if (state is SubmitRequestForNOCErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }   if (state is OnNocPaymentReceiptErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is SubmitRequestForNOCDoneState) {
            Navigator.pop(context, true);
          }
          if (state is UpdateRequestForNOCDoneState) {
            Navigator.pop(context, true);
            WorkplaceWidgets.successToast(state.message);


          }
        },
        child: BlocBuilder<MyUnitBloc, MyUnitState>(
          bloc: myUnitBloc,
          builder: (BuildContext context, state) {
            String reason = controllers['reasonForNoc']?.text.toLowerCase() ?? '';
            return SingleChildScrollView(
              child: Stack(
                children: [
                  if (state is! CheckStatusOfNOCSubmissionDoneState && state is! CheckStatusOfNOCSubmissionLoadingState)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        reasonForNocField(),

                        if (reason == 'rental agreement' || reason == 'sale of property') ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 22),
                            child: Text(
                              reason == 'rental agreement'
                                  ? AppString.newTenant
                                  : AppString.newOwner,
                              style: appTextStyle.appTitleStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (reason == 'sale of property'|| reason == 'rental agreement') ...[
                            const SizedBox(height: 10),
                            newFirstNameField(),
                            newLastNameField(),
                            phoneNumber(),
                            newAddressField(),
                           if (MainAppBloc.brokerListData.isNotEmpty)
                            brokerName(),
                          ],
                        ],


                       if (reason == 'rental agreement')
                         policeVerificationQuestions(),


                        if (reason == 'rental agreement')
                        const SizedBox(height: 10),


                        remarkForNocField(),
                        submitButton(state),
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



