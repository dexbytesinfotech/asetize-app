import '../../../imports.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_state.dart';
import 'add_family_member_screen.dart';

class AddFamilyPhoneVerifyScreen extends StatefulWidget {
  final String? houseId;
  const AddFamilyPhoneVerifyScreen({super.key, this.houseId});

  @override
  State<AddFamilyPhoneVerifyScreen> createState() => _AddFamilyPhoneVerifyScreenState();
}

class _AddFamilyPhoneVerifyScreenState extends State<AddFamilyPhoneVerifyScreen> {
  late AddVehicleManagerBloc addVehicleManagerBloc;
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
  final RegExp _phoneNumberRegex = RegExp(r'^\d{10}$');
  Map<String, TextEditingController> controllers = {
    'phoneNumber': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'phoneNumber': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'phoneNumber': "",
  };

  @override
  void initState() {
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    super.initState();
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

  bool validateFields({isButtonClicked = false}) {
    if (controllers['phoneNumber']?.text.length != 10) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
            setState(() {
              errorMessages['phoneNumber'] = AppString.phoneNumberMustBe10Digits;
            });
          }
        });
      }
      return false;
    }
    else {
      return true;
    }
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
                    style: appStyles.texFieldPlaceHolderStyle().copyWith(
                        color: Colors.red),
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


  nextButton(state) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName: AppString.nextButton,
          buttonColor: (validateFields())
              ? AppColors.textBlueColor
              : Colors.grey,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
            isLoader: state is VerifyPhoneNumberLoadingState ? true : false,
          backCallback: () {
            if (validateFields(isButtonClicked: true)) {
              addVehicleManagerBloc.add(VerifyPhoneNumberEvent(
                mContext: context,
                phoneNumber: int.parse(controllers['phoneNumber']!.text),
              ));
              // closeKeyboard();
            }
          },
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
        title: AppString.addFamilyMember,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
        listener: (context, state) {
          if(state is VerifyPhoneNumberDoneState)
          {
            Navigator.push(
              context,
              SlideLeftRoute(
                widget:  AddFamilyMember(
                  houseId: widget.houseId,
                  phoneNumber : controllers['phoneNumber']!.text.toString() ?? "",
                  firstName: state.firstName,
                  lastName: state.lastName,
                ),
              ),
            ).then((value){
              if(value!=null && value is bool && value == true){
                Navigator.pop(context,true);
              }
            });
          }
          if(state is VerifyPhoneNumberErrorState)
          {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
        },
        child: BlocBuilder<AddVehicleManagerBloc, AddVehicleManagerState>(
          bloc: addVehicleManagerBloc,
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    phoneNumber(),
                    const SizedBox(height: 8),
                    nextButton(state),
                    const SizedBox(height: 20),
                  ],
                ),
                // if (state is VerifyPhoneNumberLoadingState)
                //   WorkplaceWidgets.progressLoader(context)
              ],
            );
          },
        ),
      ),
    );
  }
}
