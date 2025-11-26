import '../../../imports.dart';
import '../bloc/account_book_bloc.dart';
import '../bloc/account_book_event.dart';
import '../bloc/account_book_state.dart';
import '../models/beneficiaries_model.dart';
import 'otp_popup.dart';

class AddNewPayeeScreen extends StatefulWidget {
  final BeneficiariesData? payee;
  final bool isEditMode;

  const AddNewPayeeScreen({super.key,  this.payee, this.isEditMode = false});

  @override
  State<AddNewPayeeScreen> createState() => _AddNewPayeeScreenState();
}

class _AddNewPayeeScreenState extends State<AddNewPayeeScreen> {
  late AccountBookBloc accountBloc;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  int selectExpensesCategoryId = 0;
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());



  // Added profession controller
  Map<String, TextEditingController> controllers = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'profession': TextEditingController(), // Changed from reasonForNoc to profession
  };

  Map<String, FocusNode> focusNodes = {
    'firstName': FocusNode(),
    'lastName': FocusNode(),
    'phoneNumber': FocusNode(),
    'profession': FocusNode(), // Changed from reasonForNoc to profession
  };

  // Dummy list of professions
  final List<String> professionList = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Painter',
    'Mechanic',
    'Gardener',
    'Cleaner',
  ];

  void setData() {
    if(widget.payee == null){
      return ;
    }
    controllers['firstName']?.text = widget.payee?.firstName ?? '';
    controllers['lastName']?.text = widget.payee?.lastName ?? '';
    controllers['phoneNumber']?.text = widget.payee?.mobileNumber ?? '';
    controllers['profession']?.text =  widget.payee?.expenseCategoryName ?? '';
    selectExpensesCategoryId = int.parse(widget.payee!.expenseCategoryId.toString()) ;
  }

  @override
  void initState() {
    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    setData();
    super.initState();
  }

  bool validateFields() {
    final firstName = controllers['firstName']?.text.trim();
    final phoneNumber = controllers['phoneNumber']?.text.trim();
    final profession = controllers['profession']?.text.trim();
    return (firstName?.isNotEmpty ?? false) &&
        (phoneNumber?.isNotEmpty ?? false) &&
        (phoneNumber?.length == 10) &&
        (profession?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {



    // void showCategoryBottomSheet(BuildContext context) {
    //   WorkplaceWidgets.showCustomAndroidBottomSheet(
    //     context: context,
    //     title: AppString.selectCategory,
    //     valuesList: accountBloc.expensesList.map((e) => e.name).toList(),
    //     selectedValue: controllers['category']?.text ?? "",
    //     onValueSelected: (value) {
    //       setState(() {
    //         controllers['category']?.text = value;
    //         var selectedCategory =
    //         accountBloc.expensesList.firstWhere((e) => e.name == value);
    //         selectExpensesCategoryId = selectedCategory.id ?? 0;
    //       });
    //     },
    //   );
    // }





    void showProfessionBottomSheet(BuildContext context) {
      WorkplaceWidgets.showCustomAndroidBottomSheet(
        context: context,
        title: AppString.selectProfession,
        valuesList: accountBloc.expensesList.map((e) => e.name).toList(),
        selectedValue: controllers['profession']?.text ?? "",
        onValueSelected: (value) {
          setState(() {
            controllers['profession']?.text = value;
            var selectedCategory =
            accountBloc.expensesList.firstWhere((e) => e.name == value);
            selectExpensesCategoryId = selectedCategory.id ?? 0;
          });
        },
      );
    }

    Widget firstNameField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['firstName'],
          isShowBottomErrorMsg: false,
          controllerT: controllers['firstName'],
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
          hintText: AppString.enterYourFirstName,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            setState(() {});
          },
          onEndEditing: (value) {
            FocusScope.of(context).requestFocus(focusNodes['lastName']);
          },
        ),
      );
    }

    Widget lastNameField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['lastName'],
          isShowBottomErrorMsg: false,
          controllerT: controllers['lastName'],
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
              child: Text(
                AppString.lastName,
                style: appStyles.texFieldPlaceHolderStyle(),
                textAlign: TextAlign.start,
              )),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.enterYourLastName,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            setState(() {});
          },
          onEndEditing: (value) {
            FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
          },
        ),
      );
    }

    Widget professionField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: () {
            showProfessionBottomSheet(context);
          },
          focusNode: focusNodes['profession'],
          isShowBottomErrorMsg: true,
          readOnly: true,
          controllerT: controllers['profession'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 0,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: AppColors.appBlueColor,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.selectProfession,
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
          hintText: AppString.selectProfession,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
          onTextChange: (value) {},
          onEndEditing: (value) {
            FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
          },
        ),
      );
    }

    Widget phoneNumberField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: () {
            if (phoneNumber != null) {
              WorkplaceWidgets.errorPopUp(
                  context: context,
                  content: AppString.updatePhoneNumberMsg,
                  onTap: () {
                    Navigator.of(context).pop();
                  });
            }
          },
          focusNode: focusNodes['phoneNumber'],
          isShowBottomErrorMsg: false,
          readOnly: phoneNumber != null ? true : false,
          controllerT: controllers['phoneNumber'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          maxLines: 10,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(10), // Restrict to 10 digits
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
          hintText: AppString.enterYoursPhoneNumber,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(
              texColor: phoneNumber != null ? Colors.grey : Colors.black),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldPrefixIcon: CountryCodePicker(
            showFlag: false,
            enabled: false,
            textStyle: appStyles.textFieldTextStyle(),
            padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 10),
            initialSelection: 'IN',
            onChanged: (value) {},
            onInit: (value) {},
          ),
          onTextChange: (value) {
            setState(() {});
          },
          onEndEditing: (value) {},
        ),
      );
    }

    Widget submitButton(state) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: AppButton(
          buttonName: widget.isEditMode?AppString.updatePayee:AppString.submit,
          buttonColor: validateFields() ? AppColors.textBlueColor : Colors.grey,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          isLoader: state is AddNewPayeeLoadingState ||
              state is UpdatePayeeLoadingState ||
              state is SentOtpForMobileNumberVerificationLoadingState ? true : false,
          backCallback: () {
            closeKeyboard();
            if (validateFields()) {
              final currentPhoneNumber = controllers['phoneNumber']?.text ?? '';
              if (widget.payee == null) {
                accountBloc.add(OnSentOtpForMobileNumberVerificationEvent(
                  mContext: context,
                  mobileNumber: currentPhoneNumber,
                ));
              } else {
                final originalPhoneNumber = widget.payee?.mobileNumber ?? '';
                if (currentPhoneNumber != originalPhoneNumber) {
                  accountBloc.add(OnSentOtpForMobileNumberVerificationEvent(
                    isMobileNumberUpdate: true,
                    mContext: context,
                    mobileNumber: currentPhoneNumber,
                  ));
                } else {
                  accountBloc.add(OnUpdatePayeeEvent(
                    id: int.parse(widget.payee!.id.toString()),
                    firstName: controllers['firstName']?.text ?? '',
                    lastName: controllers['lastName']?.text,
                    mobileNumber: currentPhoneNumber,
                    expenseCategoryId: selectExpensesCategoryId,
                  ));
                }
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
        isListScrollingNeed: false,
        isOverLayStatusBar: false,
        bottomSafeArea: true,
        appBarHeight: 50,
        appBar:  CommonAppBar(
          title: widget.isEditMode? AppString.editPayee: AppString.addNewPayee,
          icon: WorkplaceIcons.backArrow,
        ),
        containChild: BlocListener<AccountBookBloc, AccountBookState>(
          bloc: accountBloc,
          listener: (context, state) {
            if (state is AddNewPayeeDoneState) {
                // Return a map with payee name and expense category details
                Navigator.pop(context, {
                  'success': true,
                  'payeeName': '${controllers['firstName']?.text ?? ''} ${controllers['lastName']?.text ?? ''}'.trim(),
                  'expenseCategoryId': selectExpensesCategoryId,
                  'expenseCategoryName': controllers['profession']?.text ?? '',
                  'payeeId': state.id, // Assuming AddNewPayeeDoneState has payeeId
                } );
                WorkplaceWidgets.successToast(state.message);

              // Navigator.pop(context, true);
              // WorkplaceWidgets.successToast(state.message);
            }

            if (state is UpdatePayeeDoneState) {
              Navigator.pop(context, true);
              WorkplaceWidgets.successToast(state.message);
            }
            if (state is OtpVerificationDoneState) {

              if (state.isMobileNumberUpdate == false){
                WorkplaceWidgets.successToast(state.message);
                accountBloc.add(AddNewPayeeEvent(
                  firstName: controllers['firstName']?.text ?? '',
                  lastName: controllers['lastName']?.text,
                  mobileNumber: controllers['phoneNumber']?.text ?? '',
                  expenseCategoryId: selectExpensesCategoryId,
                  context: context,

                  // profession: controllers['profession']?.text, // Added profession
                )

                );
                Navigator.pop(context, true);
              } else {
                WorkplaceWidgets.successToast(state.message);

                accountBloc.add(OnUpdatePayeeEvent(
                  id: int.parse(widget.payee!.id.toString()),
                  firstName: controllers['firstName']?.text ?? '',
                  lastName: controllers['lastName']?.text,
                  mobileNumber: controllers['phoneNumber']?.text?? '',
                  expenseCategoryId: selectExpensesCategoryId,
                ));
                Navigator.pop(context, true);
              }


            }

            if (state is SentOtpForMobileNumberVerificationDoneState) {

              WorkplaceWidgets.successToast(state.message);
              showDialog(
                context: context,
                builder: (context) =>
                    OtpPopup(
                        mobileNumber: controllers['phoneNumber']?.text ,
                      onEdit: () {
                        Navigator.pop(context); // go back to edit screen
                      },
                      onVerify: (otp) {
                        accountBloc.add(OnOtpVerificationEvent(
                          isMobileNumberUpdate: state.isMobileNumberUpdate ?? false,
                          mContext: context,
                          mobileNumber: controllers['phoneNumber']?.text ?? '',
                          otp: otp

                          // profession: controllers['profession']?.text, // Added profession
                        ));



                        // print("OTP entered: $otp");
                        // Navigator.pop(context);
                      },
                      onResend: () {
                        accountBloc.add(OnResendOtpForMobileNumberVerificationEvent(
                          mContext: context,
                          mobileNumber: controllers['phoneNumber']?.text ?? '',
                        ));
                      },
                    ),
              );
            }
            if (state is AddNewPayeeErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
            if (state is OnResendOtpForMobileNumberVerificationDoneState) {
              WorkplaceWidgets.successToast(state.message);
            }
            if (state is OnResendOtpForMobileNumberVerificationErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
            if (state is OtpVerificationErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            if (state is SentOtpForMobileNumberVerificationErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            if (state is UpdatePayeeErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
          },
          child: BlocBuilder<AccountBookBloc, AccountBookState>(
              bloc: accountBloc,
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 5),
                    firstNameField(),
                    lastNameField(),
                    professionField(), // Added profession field
                    phoneNumberField(),
                    submitButton(state),
                    const SizedBox(height: 8),
                  ],
                );
              }),
        ));
  }
}