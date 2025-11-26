import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/app_style.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/validation.dart';
import '../../../core/util/workplace_icon.dart';
import '../../presentation/widgets/app_button_common.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import '../../presentation/widgets/common_text_field_with_error.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import '../bloc/add_transaction_receipt_bloc.dart';
import '../bloc/add_transaction_receipt_event.dart';
import '../bloc/add_transaction_receipt_state.dart';
import 'add_transaction_form.dart';

class SuspiciousEntryScreen extends StatefulWidget {
  const SuspiciousEntryScreen({super.key});

  @override
  SuspiciousEntryScreenState createState() => SuspiciousEntryScreenState();
}

class SuspiciousEntryScreenState extends State<SuspiciousEntryScreen> {
  bool isButtonClicked = false;
  String? selectedVehicleType;
  String? selectedVehicleNumber;
  int? selectedVehicleIndex;
  late AddTransactionReceiptBloc addTransactionReceiptBloc;

  final Map<String, TextEditingController> controllers = {
    'amount': TextEditingController(),
    'date': TextEditingController(),
  };

  final Map<String, FocusNode> focusNodes = {
    'amount': FocusNode(),
    'date': FocusNode(),
  };

  final Map<String, String> errorMessages = {
    'amount': "",
    'date': "",
  };

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    addTransactionReceiptBloc = BlocProvider.of<AddTransactionReceiptBloc>(context);

    super.initState();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.textBlueColor,
              onSurface: Colors.black,
              onPrimary: Colors.white,
              surface: AppColors.white,
              brightness: Brightness.light,
            ),
            dialogBackgroundColor: AppColors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        controllers['date']!.text = DateFormat('MMMM d, yyyy').format(_selectedDate);
        errorMessages['date'] = '';
      });
    }
  }

  void checkDate(String value, String field, {bool onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        errorMessages[field] = "";
      });
    } else {
      setState(() {
        if (!onchange) {
          errorMessages[field] = AppString.trans(context, AppString.emailHintError);
        }
      });
    }
  }

  bool validateFields({bool isButtonClicked = false}) {
    final cleanedAmount = controllers['amount']!.text.replaceAll(",", "").trim();
    final amountValue = double.tryParse(cleanedAmount);

    if (cleanedAmount.isEmpty) {
      if (isButtonClicked) {
        setState(() {
          FocusScope.of(context).requestFocus(focusNodes['amount']);
          errorMessages['amount'] = 'The amount field is required';
        });
      }
      return false;
    } else if (amountValue == null || amountValue <= 0) {
      if (isButtonClicked) {
        setState(() {
          FocusScope.of(context).requestFocus(focusNodes['amount']);
          errorMessages['amount'] = 'Amount must be greater than 0';
        });
      }
      return false;
    } else if (controllers['date']?.text == null || controllers['date']?.text == '') {
      if (isButtonClicked) {
        setState(() {
          FocusScope.of(context).requestFocus(focusNodes['date']);
          errorMessages['date'] = 'The date is required';
        });
      }
      return false;
    }

    return true;
  }


  Widget amountField() {
    return CommonTextFieldWithError(
      inputFormatter: [ThousandsSeparatorInputFormatter()],
      inputKeyboardType: InputKeyboardTypeWithError.number,
      focusNode: focusNodes['amount'],
      isShowBottomErrorMsg: true,
      errorMessages: errorMessages['amount'] ?? '',
      controllerT: controllers['amount'],
      borderRadius: 8,
      inputHeight: 50,
      errorLeftRightMargin: 0,
      maxCharLength: 500,
      errorMsgHeight: 18,
      maxLines: 1,
      autoFocus: false,
      showError: true,
      showCounterText: false,
      displayKeyBordDone: false,
      capitalization: CapitalizationText.sentences,
      cursorColor: Colors.grey,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.newline,
      borderStyle: BorderStyle.solid,
      hintText: AppString.amountHint,
      placeHolderTextWidget: Padding(
        padding: const EdgeInsets.only(left: 3.0, bottom: 3),
        child: Text.rich(
          TextSpan(
            text: AppString.amountHint,
            style: appStyles.texFieldPlaceHolderStyle(),
            children: [
              TextSpan(
                text: '*',
                style: appStyles.texFieldPlaceHolderStyle().copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      hintStyle: appStyles.textFieldTextStyle(
        fontWeight: FontWeight.w400,
        texColor: Colors.grey.shade600,
        fontSize: 14,
      ),
      textStyle: appTextStyle.appLargeTitleStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Arial',
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      onTextChange: (value) {
        final cleanedValue = value.replaceAll(",", "").trim(); // In case of comma separators
        final doubleValue = double.tryParse(cleanedValue);

        setState(() {
          if (cleanedValue.isEmpty) {
            errorMessages['amount'] = 'The amount field is required';
          } else if (doubleValue == null || doubleValue <= 0) {
            errorMessages['amount'] = 'Amount must be greater than 0';
          } else {
            errorMessages['amount'] = '';
          }
        });
      },

      onEndEditing: (value) {
        final cleanedValue = value.replaceAll(",", "").trim();
        final doubleValue = double.tryParse(cleanedValue);

        setState(() {
          if (cleanedValue.isEmpty) {
            errorMessages['amount'] = 'The amount field is required';
          } else if (doubleValue == null || doubleValue <= 0) {
            errorMessages['amount'] = 'Amount must be greater than 0';
          } else {
            errorMessages['amount'] = '';
          }
        });
      },

      onTapCallBack: () {},
    );
  }

  Widget dateField() {
    return CommonTextFieldWithError(
      onTapCallBack: _pickDate,
      readOnly: true,
      focusNode: focusNodes['date'],
      isShowBottomErrorMsg: true,
      errorMessages: errorMessages['date'] ?? '',
      controllerT: controllers['date'],
      borderRadius: 8,
      inputHeight: 50,
      errorLeftRightMargin: 0,
      maxCharLength: 500,
      errorMsgHeight: 18,
      maxLines: 1,
      autoFocus: false,
      placeHolderTextWidget: Padding(
        padding: const EdgeInsets.only(left: 3.0, bottom: 3),
        child: Text.rich(
          TextSpan(
            text: AppString.selectTransactionDate,
            style: appStyles.texFieldPlaceHolderStyle(),
            children: [
              TextSpan(
                text: '*',
                style: appStyles.texFieldPlaceHolderStyle().copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      showError: true,
      showCounterText: false,
      capitalization: CapitalizationText.sentences,
      cursorColor: Colors.grey,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.newline,
      borderStyle: BorderStyle.solid,
      inputKeyboardType: InputKeyboardTypeWithError.multiLine,
      hintText: "Select date",
      textStyle: appTextStyle.appLargeTitleStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Arial',
      ),
      hintStyle: appStyles.textFieldTextStyle(
        fontWeight: FontWeight.w400,
        texColor: Colors.grey.shade600,
        fontSize: 14,
      ),
      inputFieldSuffixIcon: WorkplaceWidgets.calendarIcon(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      onTextChange: (value) => checkDate(value, 'date', onchange: true),
      onEndEditing: (value) => checkDate(value, 'date'),
    );
  }

  Widget submitButton(state) {
    return AppButton(
        buttonName: AppString.submit,
        buttonColor:  validateFields()? AppColors.appBlueColor :  Colors.grey ,
        textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
        isLoader: state is SuspenseEntryLoadingState ?true:false,
        backCallback: validateFields()? ()  {
          if (validateFields(isButtonClicked: true)) {
            final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

            // Submit logic here
            print("Amount: ${controllers['amount']!.text}");
            print("Date: $formattedDate");

            addTransactionReceiptBloc.add(
              OnSuspenseEntryEvent(
                  mContext: context,
                  amount: controllers['amount']!.text.replaceAll(',', ''),
                  paymentMethod: 'online',
                  transactionDate: formattedDate

              ),
            );

          }
        }:null
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
        title: AppString.suspenseEntry,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AddTransactionReceiptBloc, AddTransactionReceiptState>(
        bloc: addTransactionReceiptBloc,
        listener: (context, state) {
          if (state is SuspenseEntryErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is SuspenseEntryDoneState) {
            WorkplaceWidgets.successToast(AppString.suspenseEntryAddSuccessfully,durationInSeconds: 1);
            Navigator.pop(context, true);
          }
        },
        child: BlocBuilder<AddTransactionReceiptBloc, AddTransactionReceiptState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        amountField(),
                        dateField(),
                        const SizedBox(height: 20),
                        submitButton(state),
                      ],
                    ),
                  ),
                  // if (state is SuspenseEntryLoadingState)
                  //   Center(
                  //     child: WorkplaceWidgets.progressLoader(context),
                  //   ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}