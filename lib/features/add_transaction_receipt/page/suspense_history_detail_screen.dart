import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/util/animation/slide_left_route.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/app_style.dart';
import '../../../core/util/validation.dart';
import '../../../core/util/workplace_icon.dart';
import '../../account_books/pages/member_screen.dart';
import '../../data/models/user_response_model.dart';
import '../../presentation/widgets/app_button_common.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import '../../presentation/widgets/common_text_field_with_error.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import '../bloc/add_transaction_receipt_bloc.dart';
import '../bloc/add_transaction_receipt_event.dart';
import '../bloc/add_transaction_receipt_state.dart';
import '../widget/payment_history_detail_card.dart';

class SuspenseHistoryDetailPage extends StatefulWidget {
  final int invoiceId;
  final String receiptNumber;
  final String paymentDate;
  final String amount;



  const SuspenseHistoryDetailPage({super.key, required this.invoiceId,    required this.receiptNumber,
    required this.paymentDate,
    required this.amount,
  });

  @override
  SuspenseHistoryDetailPageState createState() => SuspenseHistoryDetailPageState();
}

class SuspenseHistoryDetailPageState extends State<SuspenseHistoryDetailPage> {
  bool isButtonClicked = false;
  String? selectedVehicleType;
  String? selectedVehicleNumber;
  int? selectedVehicleIndex;
  List<Houses> houses = [];
  Houses? selectedUnit;
  int? selectedUnitId; // Added to store selected unit ID

  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'selectUnit': TextEditingController(),
  };
  final Map<String, FocusNode> focusNodes = {
    'name': FocusNode(),
    'selectUnit': FocusNode(),
  };
  final Map<String, String> errorMessages = {
    'name': "",
    'selectUnit': "",
  };

  late AddTransactionReceiptBloc addTransactionReceiptBloc;

  @override
  void initState() {
    addTransactionReceiptBloc = BlocProvider.of<AddTransactionReceiptBloc>(context);
    super.initState();
  }

  checkParty(String? value, String fieldEmail, {bool onchange = false}) {
    setState(() {
      if (Validation.isNotEmpty(value?.trim() ?? '')) {
        errorMessages[fieldEmail] = "";
      } else {
        errorMessages[fieldEmail] = "Name is required";
      }
    });
    return errorMessages[fieldEmail]!.isEmpty; // Return true if no error
  }

  // Add method to validate all fields before submission
  bool validateForm() {
    bool isNameValid = checkParty(controllers['name']!.text, 'name');
    bool isUnitValid = checkSelectedUnitNumber(controllers['selectUnit']!.text, 'selectUnit');
    return isNameValid && isUnitValid;
  }

  memberField(state) {
    return CommonTextFieldWithError(
      onTapCallBack: () {
        Navigator.push(context,
            SlideLeftRoute(widget: const MemberScreen()))
            .then((value) {
          if (value != null) {
            controllers['name']?.text = value.name.toString() ?? '';
            checkParty(value.name.toString(), 'name', onchange: true);
            User user = value;

            if (user.houses != null && user.houses!.isNotEmpty) {
              houses = List.generate(user.houses!.length, (index) {
                return Houses(
                    id: user.houses![index].id,
                    title: user.houses![index].title
                );
              });

              setState(() {
                selectedUnit = houses[0];
                selectedUnitId = houses[0].id;
                controllers['selectUnit']?.text = selectedUnit!.title ?? '';
                errorMessages['selectUnit'] = "";
              });
            } else {
              setState(() {
                houses = [];
                selectedUnit = null;
                selectedUnitId = null;
                controllers['selectUnit']?.text = '';
              });
            }
          }
        });
      },
      readOnly: true,
      focusNode: focusNodes['name'],
      isShowBottomErrorMsg: true,
      errorMessages: errorMessages['name']?.toString() ?? '',
      controllerT: controllers['name'],
      borderRadius: 8,
      inputHeight: 45,
      errorLeftRightMargin: 0,
      maxCharLength: 500,
      errorMsgHeight: 18,
      maxLines: 1,
      autoFocus: false,
      showError: true,
      showCounterText: false,
      capitalization: CapitalizationText.sentences,
      cursorColor: Colors.grey,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,  // Changed from newline to next
      borderStyle: BorderStyle.solid,
      inputKeyboardType: InputKeyboardTypeWithError.multiLine,
      placeHolderTextWidget: Padding(
        padding: const EdgeInsets.only(left: 3.0, bottom: 3),
        child: Text.rich(
          TextSpan(
            text: AppString.nameCapital,
            style: appStyles.texFieldPlaceHolderStyle(),
            children: [
              TextSpan(
                text: '*',
                style: appStyles
                    .texFieldPlaceHolderStyle()
                    .copyWith(color: Colors.red),
              ),
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ),
      hintText: AppString.partyHint,
      hintStyle: appStyles.textFieldTextStyle(
          fontWeight: FontWeight.w400,
          texColor: Colors.grey.shade600,
          fontSize: 14),
      textStyle: appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
      contentPadding:
      const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      onTextChange: (value) {
        checkParty(value, 'name', onchange: true);
      },
      onEndEditing: (value) {
        checkParty(value, 'name');  // This will trigger the "Name is required" error when empty
        FocusScope.of(context).requestFocus(focusNodes['selectUnit']);  // Move focus to next field
      },
    );
  }

  void _onUnitSelected(int index) {
    setState(() {
      if (selectedUnit != houses[index]) {
        selectedUnit = houses[index];
        selectedUnitId = houses[index].id;
        controllers['selectUnit']?.text = selectedUnit!.title ?? '';
        errorMessages['selectUnit'] = "";
      }
    });
  }

  bool checkSelectedUnitNumber(String value, String fieldEmail, {bool onchange = false}) {
    bool isValid = Validation.isNotEmpty(value.trim());

    if (!onchange) {  // Only update state when not in onchange mode
      setState(() {
        errorMessages[fieldEmail] = isValid
            ? ""
            : AppString.trans(context, AppString.emailHintError);
      });
    } else {
      errorMessages[fieldEmail] = isValid
          ? ""
          : AppString.trans(context, AppString.emailHintError);
    }

    return isValid;
  }

  void unitSelectionPopUpSheet() {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text(
            AppString.selectUnit,
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          actions: List.generate(
            houses.length,
                (index) {
              return CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  _onUnitSelected(index);
                },
                child: Text(
                  '${houses[index].title}',
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
          ),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              AppString.cancel,
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  Widget selectUnit(state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextFieldWithError(
            onTapCallBack: () {
              if (houses.length > 1) {
                unitSelectionPopUpSheet();
              } else if (houses.length == 1) {
                _onUnitSelected(0);
              } else {
                print(AppString.noHousesAvailable);
              }
            },
            inputFormatter: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d*$'),
              ),
            ],
            inputKeyboardType: InputKeyboardTypeWithError.number,
            focusNode: focusNodes['selectUnit'],
            isShowBottomErrorMsg: true,
            displayKeyBordDone: false,
            errorMessages: errorMessages['selectUnit']?.toString() ?? '',
            controllerT: controllers['selectUnit'],
            borderRadius: 8,
            inputHeight: 50,
            errorLeftRightMargin: 0,
            maxCharLength: 500,
            errorMsgHeight: 18,
            maxLines: 1,
            autoFocus: false,
            readOnly: true,
            showError: true,
            showCounterText: false,
            capitalization: CapitalizationText.sentences,
            cursorColor: Colors.grey,
            enabledBorderColor: Colors.white,
            focusedBorderColor: Colors.white,
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.newline,
            borderStyle: BorderStyle.solid,
            inputFieldSuffixIcon: houses.length > 1
                ? Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: Colors.grey.shade600,
            )
                : const SizedBox(),
            hintText: AppString.selectUnitNumberHint,
            placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.selectUnitHint,
                  style: appStyles.texFieldPlaceHolderStyle(),
                  children: [
                    TextSpan(
                      text: '*',
                      style: appStyles
                          .texFieldPlaceHolderStyle()
                          .copyWith(color: Colors.red),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            hintStyle: appStyles.textFieldTextStyle(
              fontWeight: FontWeight.w400,
              texColor: Colors.grey.shade600,
              fontSize: 14,
            ),

            textStyle:
            appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
            contentPadding: const EdgeInsets.only(
                left: 15, right: 15, top: 10, bottom: 10),
            onTextChange: (value) {
              checkSelectedUnitNumber(value, 'selectUnit', onchange: true);
            },

            onEndEditing: (value) {
              checkSelectedUnitNumber(value, 'selectUnit');
              FocusScope.of(context).requestFocus(focusNodes['']);
            },
          ),
        ],
      ),
    );
  }


  Widget transferButton(state) {
    return AppButton(
      buttonName: AppString.transfer,
      buttonColor: controllers['selectUnit']!.text.isNotEmpty &&
          controllers['name']!.text.isNotEmpty
          ? AppColors.appBlueColor
          : Colors.grey,
      textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
      isLoader: state is SuspenseEntryLoadingState ? true : false,
      backCallback: () {
        // Validate form when button is clicked
        if (validateForm()) {

          WorkplaceWidgets.showRequestDialog(
            context: context,
            title:
            AppString.confirmSuspenseEntry ?? AppString.approveRequestTitle,
            // content:
            // 'Are you sure you want to make a suspense entry of ${widget.amount} to ${controllers['selectUnit']?.text} house?. This action is final and cannot be undone.'
            //     ??
            //     AppString.receiptNumberLabel,
            customContent: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(text: 'Are you sure you want to make a suspense entry of '),
                  TextSpan(
                    text: widget.amount,
                    style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16,      ),
                  ),
                  const TextSpan(text: ' to '),
                  TextSpan(
                    text: '${controllers['selectUnit']?.text}',
                    style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                  ),
                  const TextSpan(text: ' house? This action is final and cannot be undone.'),
                ],
              ),
            ),
            buttonName1:
            AppString.buttonConfirm ?? AppString.confirmButton,

            // maxLine: 1,
            hintText: AppString.enterReceiptNumber,
            buttonName2: AppString.cancelButton,
            unableButtonColor: AppColors.primaryColor,
            disableButtonColor: Colors.green.withOpacity(0.5),
            onPressedButton1: () {
              // Handle Confirm action
              addTransactionReceiptBloc.add(
                OnSuspenseHouseAssignEvent(
                    mContext: context,
                    invoiceId: widget.invoiceId,
                    assignToHouseId: selectedUnitId
                ),
              );
              Navigator.pop(context);
            },
            onPressedButton2: () {
              Navigator.of(context).pop();
            },
            // textController: receiptNumberTextController
          );
          // Only proceed if validation passes
          // addTransactionReceiptBloc.add(
          //   OnSuspenseEntryEvent(
          //     // Add your event parameters here
          //   ),
          // );
        }
      },
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
        title: AppString.suspenseHistoryDetail,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AddTransactionReceiptBloc, AddTransactionReceiptState>(
        bloc: addTransactionReceiptBloc,
        listener: (context, state) {
          if (state is SuspenseHouseAssignErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is SuspenseHouseAssignDoneState) {
            Navigator.pop(context,true);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const SuspenseHistoryScreen(),
            //   ),
            // );
          }
        },
        child: BlocBuilder<AddTransactionReceiptBloc, AddTransactionReceiptState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0).copyWith(top: 0),
                    child: Column(
                      children: [
                        PaymentHistoryDetailCard(receiptNumber:widget.receiptNumber,paymentDate: widget.paymentDate, amount: widget.amount,transactionReference: AppString.suspiciousAmount,),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                  child: Divider(
                                    thickness: 0,
                                  )),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(AppString.assignToHouse, style: appStyles.textFieldTextStyle(
                                  fontWeight: FontWeight.w500,
                                  texColor: Colors.black,
                                  fontSize: 16),),
                              const SizedBox(
                                width: 6,
                              ),
                              const Expanded(
                                  child: Divider(
                                    thickness: 0,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        memberField(state),
                        const SizedBox(height: 5),
                        selectUnit(state),
                        const SizedBox(height: 5),
                        Text(AppString.warningMessageAssignToHouse,
                          textAlign: TextAlign.center, // Ensures multiline text is also centered
                          style: appStyles.textFieldTextStyle(
                            fontWeight: FontWeight.w400,
                            texColor: AppColors.appBlueColor,
                            fontSize: 15,),),
                        const SizedBox(height: 20),
                        transferButton(state)

                      ],
                    ),
                  ),
                  if (state is SuspenseHouseAssignLoadingState)
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