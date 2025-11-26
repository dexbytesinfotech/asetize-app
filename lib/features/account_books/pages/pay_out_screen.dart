import 'package:intl/intl.dart';
import 'package:asetize/features/account_books/pages/view_all_payees_screen.dart';
// import 'package:voice_assistant/voice_assistant.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../my_unit/widgets/common_image_view.dart';
import '../bloc/account_book_bloc.dart';
import '../bloc/account_book_event.dart';
import '../bloc/account_book_state.dart';
import 'add_new_payee_screen.dart';

class PayOutScreen extends StatefulWidget {
  final int? expenseId;
  final bool isEditMode;
  final bool isComingFromAccountBook;
  const PayOutScreen({super.key, this.expenseId, this.isEditMode = false, this.isComingFromAccountBook=false});

  @override
  State<PayOutScreen> createState() => _PayOutScreenState();
}

class _PayOutScreenState extends State<PayOutScreen> {
  late AccountBookBloc accountBloc;
  bool _isListening = false;
  int selectExpensesCategoryId = 0;
  int selectPayeeId = 0;
  String? voucherNumber;
  late ScrollController _scrollController;
  File? selectProfilePhoto;
  String? selectProfilePhotoPath;
  String imageErrorMessage = '';

  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  OverlayEntry? overlayEntry;
  bool isImageSelected = false;
  // Add ScrollController

  // Dummy list of payees
  final List<String> payeeList = [
    'John Doe',
    'Jane Smith',
    'Acme Corporation',
    'XYZ Services',
    'Robert Brown',
  ];

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  Map<String, TextEditingController> controllers = {
    'payee': TextEditingController(),
    'amount': TextEditingController(),
    'description': TextEditingController(),
    'date': TextEditingController(),
    'category': TextEditingController(),
    'payment': TextEditingController(),
    'chequeNumber': TextEditingController(),
    'voucherNumber': TextEditingController(),
    'otherCategory': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'payee': FocusNode(),
    'amount': FocusNode(),
    'description': FocusNode(),
    'date': FocusNode(),
    'category': FocusNode(),
    'payment': FocusNode(),
    'chequeNumber': FocusNode(),
    'voucherNumber': FocusNode(),
    'otherCategory': FocusNode(),
  };

  DateTime _selectedDate = DateTime.now();
  List<String> filteredPayees = [];
  bool showAddNewPayee = false;

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    accountBloc.voucherNumberData = null;
    accountBloc.uploadedFilePath = null;
    accountBloc.add(OnGetPayeeListEvent(mContext: context));
    if (widget.isEditMode == false) {
      accountBloc.add(OnGetVoucherNumberEvent(mContext: context));
    }
    if(widget.isEditMode) {
      accountBloc.expenseDetailData =null;
      accountBloc.add(OnGetExpenseDetailEvent(id: widget.expenseId ?? 0));
    }

    controllers['date']?.text = DateFormat('d MMM, yyyy').format(_selectedDate);
    controllers['payment']?.text = 'Cash Payment';
    _scrollController = ScrollController(); // Initialize ScrollController

    focusNodes['payee']?.addListener(() {
      if (!focusNodes['payee']!.hasFocus) {
        // when unfocused, hide list
        setState(() {
          filteredPayees.clear();
          showAddNewPayee = false;
        });
      }
    });

  }

  // Toggle listening state for microphone
  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
  }

  void clearAllControllers() {
    controllers.forEach((key, controller) {
      controller.clear();
      controllers['date']?.text = DateFormat('d MMM, yyyy').format(_selectedDate);
      controllers['payment']?.text = 'Cash Payment';
      accountBloc.add(OnGetVoucherNumberEvent(mContext: context));
    });
    // // Reset date to current date
    // _selectedDate = DateTime.now();
    // controllers['date']?.text = DateFormat('d MMM, yyyy').format(_selectedDate);
    // // Reset payment to default
    // controllers['payment']?.text = 'Cash Payment';
    // // Reset category and payee IDs
    // selectExpensesCategoryId = 0;
    // selectPayeeId = 0;
  }

  bool validateFields() {
    bool isChequeSelected = controllers['payment']?.text == 'Cheque payment';
    bool isOtherCategory = controllers['category']?.text == 'Other';
    return (controllers['payee']?.text.isNotEmpty ?? false) &&
        (controllers['category']?.text.isNotEmpty ?? false) &&
        (controllers['amount']?.text.isNotEmpty ?? false) &&
        (controllers['date']?.text.isNotEmpty ?? false) &&
        (controllers['payment']?.text.isNotEmpty ?? false) &&
        (controllers['description']?.text.isNotEmpty ?? false) &&
        (!isChequeSelected ||
            (controllers['chequeNumber']?.text.isNotEmpty ?? false)) &&
        (!isOtherCategory ||
            (controllers['otherCategory']?.text.isNotEmpty ?? false));
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
        String formattedDate = DateFormat('MMMM d, yyyy').format(_selectedDate);
        controllers['date']?.text = formattedDate;
      });
    }
  }

  void showPayeeBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectPayee,
      valuesList: accountBloc.beneficiariesData,
      selectedValue: controllers['payee']?.text ?? "",
      onValueSelected: (value) {
        setState(() {
          controllers['payee']?.text = value;
          filteredPayees.clear();
          showAddNewPayee = false;
        });
      },
    );
  }

  void showCategoryBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectProfession,
      valuesList: accountBloc.expensesList.map((e) => e.name).toList(),
      selectedValue: controllers['category']?.text ?? "",
      onValueSelected: (value) {
        setState(() {
          controllers['category']?.text = value;
          var selectedCategory =
          accountBloc.expensesList.firstWhere((e) => e.name == value);
          selectExpensesCategoryId = selectedCategory.id ?? 0;
          if (value != 'Other') {
            controllers['otherCategory']?.clear();
          }
        });
      },
    );
  }

  void showPaymentMethodBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectPaymentMethod,
      valuesList: accountBloc.paymentList,
      selectedValue: controllers['payment']?.text ?? "Cash Payment",
      onValueSelected: (value) {
        setState(() {
          controllers['payment']?.text = value;
          if (value != 'Cheque payment') {
            controllers['chequeNumber']?.clear();
          }
        });
      },
    );
  }


  Widget payeeField() {
    void filterPayees(String query) {
      setState(() {
        filteredPayees = accountBloc.beneficiariesData
            .where((payee) =>
            '${payee.firstName ?? ''} ${payee.lastName ?? ''}'
                .toLowerCase()
                .contains(query.toLowerCase()))
            .map((payee) => '${payee.firstName ?? ''} ${payee.lastName ?? ''}')
            .toList()
            .where((name) => name.trim().isNotEmpty)
            .toList();
        showAddNewPayee = query.isNotEmpty && filteredPayees.isEmpty;
      });
    }

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextFieldWithError(
            focusNode: focusNodes['payee'],
            isShowBottomErrorMsg: false,
            controllerT: controllers['payee'],
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
                  text: AppString.searchPayee,
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
            isShowShadow: false,
            enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
            errorBorderColor: AppColors.appErrorTextColor,
            focusedBorderColor: AppColors.appBlueColor,
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.next,
            borderStyle: BorderStyle.solid,
            inputKeyboardType: InputKeyboardTypeWithError.text,
            hintText: AppString.searchPayee,
            hintStyle: appStyles.hintTextStyle(),
            textStyle: appStyles.textFieldTextStyle(),
            contentPadding: const EdgeInsets.only(left: 15, right: 15),
            onTextChange: (value) {

              filterPayees(value);
            },
            onEndEditing: (value) {
              FocusScope.of(context).requestFocus(focusNodes['category']);
              setState(() {
                filteredPayees.clear();
                showAddNewPayee = false;
              });
            },
            onTapCallBack: () {
              _scrollController.animateTo(
                _scrollController.offset + 100.0, // Adjust the offset as needed
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() {
                // Show full list when tapped
                filteredPayees = accountBloc.beneficiariesData
                    .map((payee) => '${payee.firstName ?? ''} ${payee.lastName ?? ''}')
                    .where((name) => name.trim().isNotEmpty)
                    .toList();
                showAddNewPayee = false;
              });},
          ),
          if (filteredPayees.isNotEmpty || showAddNewPayee)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(top: 0),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filteredPayees.length + (showAddNewPayee ? 1 : 0),
                itemBuilder: (context, index) {
                  if (showAddNewPayee && index == filteredPayees.length) {
                    return ListTile(
                      title: Center(
                        child: Text(
                          'Add New Payee',
                          style: appStyles.textFieldTextStyle().copyWith(
                            color: AppColors.appBlueColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideLeftRoute(widget: const AddNewPayeeScreen()),
                        ).then((result) {
                          if (result != null && result is Map) {
                            setState(() {
                              controllers['payee']?.text =
                                  result['payeeName'] ?? '';
                              controllers['category']?.text =
                                  result['expenseCategoryName'] ?? '';
                              selectExpensesCategoryId =
                                  result['expenseCategoryId'] ?? 0;
                              selectPayeeId = result['payeeId'] ?? 0;
                              filteredPayees.clear();
                              showAddNewPayee = false;
                              closeKeyboard();
                              accountBloc
                                  .add(OnGetPayeeListEvent(mContext: context));
                            });
                          }
                        });
                      },
                    );
                  }
                  final selectedPayee = accountBloc.beneficiariesData.firstWhere(
                          (payee) =>
                      '${payee.firstName ?? ''} ${payee.lastName ?? ''}' ==
                          filteredPayees[index]);
                  return ListTile(
                    title: Text(
                      filteredPayees[index],
                      style: appStyles.textFieldTextStyle(),
                    ),
                    onTap: () {
                      setState(() {
                        controllers['payee']?.text = filteredPayees[index];
                        selectExpensesCategoryId =
                            int.parse(selectedPayee.expenseCategoryId.toString()) ??
                                0;
                        selectPayeeId = selectedPayee.id ?? 0;
                        controllers['category']?.text =
                            selectedPayee.expenseCategoryName ?? '';
                        filteredPayees.clear();
                        showAddNewPayee = false;
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget managePayee() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            SlideLeftRoute(widget: const ViewAllPayeesScreen()),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.people, // Added icon for manage payee
              size: 22,
              color: AppColors.appBlueColor,
            ),
            SizedBox(width: 8), // Space between icon and text
            Text(
              AppString.managePayee,
              style: TextStyle(fontSize: 14, color: AppColors.appBlueColor),
            ),
            SizedBox(width: 4), // Space between text and arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: AppColors.appBlueColor,
            ),
          ],
        ),
      ),
    );
  }
  Widget categoryField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        onTapCallBack: () => showCategoryBottomSheet(context),
        focusNode: focusNodes['category'],
        isShowBottomErrorMsg: false,
        readOnly: true,
        controllerT: controllers['category'],
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
              text: AppString.selectProfession,
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
          FocusScope.of(context).requestFocus(
              controllers['category']?.text == 'Other'
                  ? focusNodes['otherCategory']
                  : focusNodes['amount']);
        },
      ),
    );
  }

  Widget paymentField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        onTapCallBack: () => showPaymentMethodBottomSheet(context),
        focusNode: focusNodes['payment'],
        isShowBottomErrorMsg: false,
        readOnly: true,
        controllerT: controllers['payment'],
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
              text: AppString.selectPaymentMethod,
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
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.text,
        hintText: AppString.selectPaymentMethod,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
        onTextChange: (value) {},
        onEndEditing: (value) {
          FocusScope.of(context).requestFocus(focusNodes['date']);
        },
      ),
    );
  }

  Widget dateField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        onTapCallBack: _pickDate,
        focusNode: focusNodes['date'],
        isShowBottomErrorMsg: false,
        readOnly: true,
        controllerT: controllers['date'],
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
              text: AppString.expenseDate,
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
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.text,
        hintText: AppString.selectExpenseDate,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldSuffixIcon: WorkplaceWidgets.calendarIcon(color: AppColors.textBlueColor),
        onTextChange: (value) {
          setState(() {});
        },
        onEndEditing: (value) {
          FocusScope.of(context).requestFocus(focusNodes['payee']);
        },
      ),
    );
  }

  Widget amountField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['amount'],
        isShowBottomErrorMsg: false,
        controllerT: controllers['amount'],
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
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        placeHolderTextWidget: Padding(
          padding: const EdgeInsets.only(left: 3.0, bottom: 3),
          child: Text.rich(
            TextSpan(
              text: AppString.amount,
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
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.numberWithDecimal,
        hintText: AppString.enterAmount,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          setState(() {});
        },
        onEndEditing: (value) {
          FocusScope.of(context).requestFocus(focusNodes['description']);

        },
      ),
    );
  }

  Widget otherCategoryField() {
    return Visibility(
      visible: controllers['category']?.text == 'Other',
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['otherCategory'],
          isShowBottomErrorMsg: false,
          controllerT: controllers['otherCategory'],
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
                text: AppString.otherDetail,
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
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.enterOtherDetail,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            setState(() {});
          },
          onEndEditing: (value) {
            FocusScope.of(context).requestFocus(focusNodes['amount']);

          },
        ),
      ),
    );
  }

  Widget chequeNumberField() {
    return Visibility(
      visible: controllers['payment']?.text == 'Cheque payment',
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['chequeNumber'],
          isShowBottomErrorMsg: false,
          controllerT: controllers['chequeNumber'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 20,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(20),
          ],
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.chequeNumber,
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
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.number,
          hintText: AppString.enterChequeNumber,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            setState(() {});
          },
          onEndEditing: (value) {
            FocusScope.of(context).requestFocus(focusNodes['date']);
          },
        ),
      ),
    );
  }

  Widget descriptionField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['description'],
        isShowBottomErrorMsg: false,
        controllerT: controllers['description'],
        borderRadius: 8,
        inputHeight: 100,
        errorLeftRightMargin: 0,
        maxCharLength: 250,
        errorMsgHeight: 20,
        textInputAction: TextInputAction.done,
        minLines: 2,
        maxLines: 4,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.sentences,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Padding(
          padding: const EdgeInsets.only(left: 3.0, bottom: 3),
          child: Text.rich(
            TextSpan(
              text: AppString.description,
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
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.multiLine,
        hintText: AppString.enterDescription,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding:
        const EdgeInsets.only(left: 15, right: 40, top: 10, bottom: 10),
        // inputFieldSuffixIcon: Padding(
        //   padding: const EdgeInsets.only(bottom: 30, top: 15),
        //   child: GestureDetector(
        //     onTap: _toggleListening,
        //     child: VoiceToTextView(
        //       micClicked: _isListening,
        //       isDoingBackgroundProcess: _isListening,
        //       listenTextStreamCallBack: (String? value) {
        //         if (value != null && value.isNotEmpty) {
        //           setState(() {
        //             controllers['description']?.text = value;
        //           });
        //         }
        //       },
        //       listenTextCompleteCallBack:
        //           (String? value, ActionType actionTypeValue) {
        //         if (value != null && value.isNotEmpty) {
        //           setState(() {
        //             controllers['description']?.text = value;
        //             _isListening = false;
        //           });
        //         } else {
        //           setState(() {
        //             _isListening = false;
        //           });
        //         }
        //       },
        //       micIcon: const Icon(Icons.mic, color: AppColors.appBlueColor, size: 24),
        //       micNoneIcon: const Icon(Icons.mic_none,
        //           color: AppColors.appBlueColor, size: 24),
        //       micBgColorColor: AppColors.appBlueColor.withOpacity(0.1),
        //       waveColor: Colors.red,
        //       waveDoneColor: Colors.green,
        //       listenEndTimeInSecond: 5,
        //       clickedActionType: ActionType.search,
        //     ),
        //   ),
        // ),
        onTextChange: (value) {
          setState(() {});
        },
        onEndEditing: (value) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
  void _removeImage() {
    setState(() {
      selectProfilePhoto = null;
      isImageSelected = false;
      selectProfilePhotoPath = null;
      accountBloc.uploadedFilePath = "";
    });
  }
  void photoPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context1) => PhotoPickerBottomSheet(
        isRemoveOptionNeeded: false,
        removedImageCallBack: () {
          Navigator.pop(context1);
          setState(() {
            selectProfilePhotoPath = "";
            isImageSelected = false;
          });
        },
        selectedImageCallBack: (fileList) {
          try {
            if (fileList != null && fileList.isNotEmpty) {
              fileList.map((fileDataTemp) {
                File imageFileTemp = File(fileDataTemp.path);
                selectProfilePhoto = imageFileTemp;
                selectProfilePhotoPath = selectProfilePhoto!.path;
                isImageSelected = true;

                if (imageFile == null) {
                  imageFile = <String, File>{};
                } else {
                  imageFile!.clear();
                }
                if (imagePath == null) {
                  imagePath = <String, String>{};
                } else {
                  imagePath!.clear();
                }
                imageErrorMessage = '';
                String mapKey = DateTime.now().microsecondsSinceEpoch.toString();
                imageFile![mapKey] = imageFileTemp;
                imagePath![mapKey] = imageFileTemp.path;
              }).toList(growable: false);

              setState(() {});

              /// 👉 Instead of only closing, navigate to ImageViewPage
              Navigator.pop(context1); // close bottom sheet first
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: ImageViewPage(
                    imageUrl: selectProfilePhotoPath!,
                    title: 'Image Preview',
                    subTitle: AppString.nocReport,
                    fromFilePicker: true,
                    onUploadCallback: (imageUrl) {
                      // Do something specific for Screen A
                      accountBloc.add(OnUploadVoucherImageEvent(filePath: selectProfilePhotoPath ?? ''));
                    },
                  ),
                ),
              );
            }
          } catch (e) {
            debugPrint('$e');
          }
        },
        selectedCameraImageCallBack: (fileList) {
          try {
            if (fileList != null && fileList.path!.isNotEmpty) {
              File imageFileTemp = File(fileList.path!);
              selectProfilePhoto = imageFileTemp;
              selectProfilePhotoPath = selectProfilePhoto!.path;
              isImageSelected = true;

              if (imageFile == null) {
                imageFile = {};
              } else {
                imageFile!.clear();
              }
              if (imagePath == null) {
                imagePath = {};
              } else {
                imagePath!.clear();
              }
              imageErrorMessage = '';
              String mapKey = DateTime.now().microsecondsSinceEpoch.toString();
              imageFile![mapKey] = imageFileTemp;
              imagePath![mapKey] = imageFileTemp.path;
              setState(() {});

              /// 👉 Close bottom sheet + navigate
              Navigator.pop(context1);
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: ImageViewPage(
                    imageUrl: selectProfilePhotoPath!,
                    title: 'Image Preview',
                    subTitle: AppString.nocReport,
                    fromFilePicker: true,
                    onUploadCallback: (imageUrl) {
                      // Do something specific for Screen A
                      accountBloc.add(OnUploadVoucherImageEvent(filePath: selectProfilePhotoPath ?? ''));
                    },
                  ),
                ),
              );
            }
          } catch (e) {
            debugPrint('$e');
          }
        },
      ),
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(photoPickerBottomSheetCardRadius)),
      ),
    );
  }

  //
  // Navigator.push(
  // context,
  // SlideLeftRoute(
  // widget: ImageViewPage(
  // imageUrl: selectProfilePhotoPath!,
  // title: 'Image Preview',
  // subTitle: AppString.nocReport,
  // fromFilePicker: true, // Use existing AppBar logic
  // ),
  // ),
  // );

  // Widget uploadVoucher(state) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 18.0, bottom: 10, top: 20),
  //         child: Text(
  //           AppString.uploadVoucher,
  //           style: appStyles.texFieldPlaceHolderStyle(),
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () => photoPickerBottomSheet(),
  //         child: Padding(
  //           padding: const EdgeInsets.all(18.0).copyWith(top: 0, bottom: 0),
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 color: AppColors.white,
  //                 border: Border.all(width: 0.8, color: Colors.transparent),
  //                 borderRadius: BorderRadius.circular(8),
  //                 boxShadow: [
  //                   BoxShadow(
  //                       color: Colors.grey.shade200,
  //                       spreadRadius: 3,
  //                       offset: const Offset(0, 1),
  //                       blurRadius: 3)
  //                 ]),
  //             padding: const EdgeInsets.all(8)
  //                 .copyWith(top: 0, bottom: 0, left: 0),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   width: 100,
  //                   height: 100,
  //                   decoration: BoxDecoration(
  //                       color: AppColors.white,
  //                       border:
  //                       Border.all(width: 0.8, color: Colors.transparent),
  //                       borderRadius: BorderRadius.circular(8),
  //                       boxShadow: [
  //                         BoxShadow(
  //                             color: Colors.grey.shade200,
  //                             spreadRadius: 3,
  //                             offset: const Offset(0, 1),
  //                             blurRadius: 3)
  //                       ]),
  //                   child: Stack(
  //                     children: [
  //                       if (selectProfilePhoto != null )
  //                         ClipRRect(
  //                           borderRadius: BorderRadius.circular(8),
  //                           child: Stack(
  //                             children: [
  //                               state is UploadVoucherImageLoadingState ? WorkplaceWidgets.progressLoader(context)
  //       :Image.file(
  //                                 selectProfilePhoto!,
  //                                 width: 100,
  //                                 height: 100,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                               Positioned(
  //                                 top: 4,
  //                                 right: 4,
  //                                 child: GestureDetector(
  //                                   onTap: _removeImage,
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                       shape: BoxShape.circle,
  //                                       color: Colors.black.withOpacity(0.6),
  //                                     ),
  //                                     padding: const EdgeInsets.all(4),
  //                                     child: const Icon(
  //                                       Icons.close,
  //                                       color: Colors.white,
  //                                       size: 16,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         )
  //                       else
  //                         Center(
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Container(
  //                                   padding: const EdgeInsets.all(15),
  //                                   margin: const EdgeInsets.only(bottom: 5),
  //                                   decoration: BoxDecoration(
  //                                       color: Colors.grey.shade200,
  //                                       shape: BoxShape.circle),
  //                                   child: const Icon(Icons.image,
  //                                       size: 24, color: Colors.grey)),
  //                               Text(
  //                                 'Upload',
  //                                 style: appStyles.userJobTitleTextStyle(
  //                                     fontSize: 14,
  //                                     texColor: Colors.grey.shade600),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(width: 16),
  //                 Flexible(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text('Allowed types: jpeg, png, jpg',
  //                           style: appStyles.userJobTitleTextStyle(
  //                               fontSize: 14,
  //                               texColor: Colors.grey.shade600)),
  //                       const SizedBox(
  //                         height: 2,
  //                       ),
  //                       Text('Up to 5MB size',
  //                           style: appStyles.userJobTitleTextStyle(
  //                               fontSize: 14,
  //                               texColor: Colors.grey.shade600)),
  //                       const SizedBox(
  //                         height: 2,
  //                       ),
  //                       Text('Maximum of 1 image',
  //                           style: appStyles.userJobTitleTextStyle(
  //                               fontSize: 14,
  //                               texColor: Colors.grey.shade600)),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }



  Widget voucherPhotoUpload(state) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, bottom: 0, top: 20, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.voucherImage,
            style: appStyles.texFieldPlaceHolderStyle(),
          ),
          const SizedBox(height: 12),

          /// Upload area with condition
          GestureDetector(
            onTap: () {
              if (!isImageSelected) {
                photoPickerBottomSheet();
                closeKeyboard();
              } else {
                Navigator.of(context).push(FadeRoute(
                    widget:  FullPhotoView(
                      title: "Voucher",
                      localProfileImgUrl: selectProfilePhotoPath?? '',
                    )));
              }
            },
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue.shade600,
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              child: isImageSelected && selectProfilePhotoPath != null
                  ? Stack(
                children: [
                  /// Check for loading state
                  if (state is UploadVoucherImageLoadingState)
                    Center(child: WorkplaceWidgets.progressLoader(context))
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(selectProfilePhotoPath!),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  /// Remove button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cloud_upload_outlined,
                      color: AppColors.appBlueColor, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "Click to upload voucher image",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Supports JPG, PNG, GIF up to 5MB",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 0),
        ],
      ),
    );
  }



  Widget buttons (state) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: widget.isEditMode
          ? AppButton(
        buttonName: AppString.updateButton,
        buttonColor: validateFields()? AppColors.textBlueColor : Colors.grey,
        textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
        isLoader: state is UpdatePreExpenseLoadingState ? true : false,
        backCallback: () {
          closeKeyboard();
          if (validateFields()) {
            String? inputDate = controllers['date']?.text.trim();
            if (inputDate != null && inputDate.isNotEmpty) {
              try {
                DateTime parsedDate = DateFormat("MMMM d, yyyy").parse(inputDate);
                String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
                accountBloc.add(
                  OnUpdateExpenseEvent(
                    mContext: context,
                    id: widget.expenseId ?? 0,
                    categoryId: selectExpensesCategoryId,
                    description: controllers['description']?.text.trim() ?? "",
                    amount: controllers['amount']?.text.trim() ?? "",
                    expenseDate: formattedDate,
                    paymentMode: controllers['payment']?.text ?? 'Cash',
                    voucherNumber: voucherNumber.toString(),
                    chequeNumber: controllers['chequeNumber']?.text.trim(),
                    beneficiaryId: selectPayeeId,
                    otherDetails: controllers['otherCategory']?.text.trim(),
                      filePath: accountBloc.uploadedFilePath
                    // triggeredBy: "update",
                  ),
                );
              } catch (e) {
                WorkplaceWidgets.errorSnackBar(context, "Invalid date format");
              }
            }
          }
        },
      )
          : Row(
        children: [
          Expanded(
            child: AppButton(
              buttonName: AppString.saveButton,
              buttonColor: validateFields()  && state is !UploadVoucherImageLoadingState ? AppColors.textBlueColor : Colors.grey,
              textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
              isLoader: state is AccountBookLoadingState && state.loadingButton == 'save' ? true : false,
              backCallback: () {
                closeKeyboard();
                if (validateFields() && state is !UploadVoucherImageLoadingState ) {
                  String? inputDate = controllers['date']?.text.trim();
                  if (inputDate != null && inputDate.isNotEmpty) {
                    try {
                      DateTime parsedDate = DateFormat("d MMM, yyyy").parse(inputDate);
                      String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
                      accountBloc.add(
                        AddExpenseEvent(
                          mContext: context,
                          categoryId: selectExpensesCategoryId,
                          description: controllers['description']?.text.trim() ?? "",
                          amount: controllers['amount']?.text.trim() ?? "",
                          expenseDate: formattedDate,
                          paymentMode: controllers['payment']?.text ?? 'Cash',
                          voucherNumber: voucherNumber.toString(),
                          chequeNumber: controllers['chequeNumber']?.text.trim(),
                          beneficiaryId: selectPayeeId,
                          otherDetails: controllers['otherCategory']?.text.trim(),
                          isSave: true,
                          triggeredBy: "save",
                          isComingFromAccountBook: widget.isComingFromAccountBook,
                          filePath: accountBloc.uploadedFilePath
                        ),
                      );
                    } catch (e) {
                      WorkplaceWidgets.errorSnackBar(context, "Invalid date format");
                    }
                  }
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppButton(
              buttonName: AppString.saveAndAddNew,
              loaderColor:  AppColors.textBlueColor,
              buttonColor: validateFields() && state is !UploadVoucherImageLoadingState? AppColors.white : Colors.grey,
              textStyle:validateFields() && state is !UploadVoucherImageLoadingState? appStyles.buttonTextStyle1(texColor: AppColors.textBlueColor) :appStyles.buttonTextStyle1(texColor: AppColors.white) ,
              isLoader: state is AccountBookLoadingState && state.loadingButton == 'saveAndAddNew' ? true : false,
              buttonBorderColor: validateFields() && state is !UploadVoucherImageLoadingState?AppColors.textBlueColor : Colors.transparent ,
              backCallback: () {
                closeKeyboard();
                if (validateFields() && state is !UploadVoucherImageLoadingState) {
                  String? inputDate = controllers['date']?.text.trim();
                  if (inputDate != null && inputDate.isNotEmpty) {
                    try {
                      DateTime parsedDate = DateFormat("d MMM, yyyy").parse(inputDate);
                      String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
                      accountBloc.add(
                        AddExpenseEvent(
                          mContext: context,
                          categoryId: selectExpensesCategoryId,
                          description: controllers['description']?.text.trim() ?? "",
                          amount: controllers['amount']?.text.trim() ?? "",
                          expenseDate: formattedDate,
                          paymentMode: controllers['payment']?.text ?? 'Cash',
                          voucherNumber: voucherNumber.toString(),
                          chequeNumber: controllers['chequeNumber']?.text.trim(),
                            isComingFromAccountBook: widget.isComingFromAccountBook,
                          beneficiaryId: selectPayeeId,
                          otherDetails: controllers['otherCategory']?.text.trim(),
                          triggeredBy: "saveAndAddNew",
                            filePath: accountBloc.uploadedFilePath
                        ),
                      );
                    } catch (e) {
                      WorkplaceWidgets.errorSnackBar(context, "Invalid date format");
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      bottomSafeArea: true,
      appBarHeight: 50,
      controller: _scrollController, // Attach ScrollController,
      appBar:  CommonAppBar(
        title: widget.isEditMode ? AppString.editExpense : AppString.addExpenses,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AccountBookBloc, AccountBookState>(
        bloc: accountBloc,
        listener: (context, state) {
          if (state is AddExpensesDoneState) {
            clearAllControllers();
            // WorkplaceWidgets.errorPopUp(
            //     context: context,
            //     content: state.message,
            //     onTap: () {
            //       Navigator.of(context).pop();
            //     });
            WorkplaceWidgets.successToast(state.message,
                durationInSeconds: 1);
            if (state.isSave){
              Navigator.pop(context, true);
            }
          }

          if (state is VoucherNumberErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);

            // Navigator.pop(context, true);
          } if (state is UploadVoucherImageErrorState) {
            setState(() {
              selectProfilePhotoPath = null;
              selectProfilePhoto = null;
            });
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);

            // Navigator.pop(context, true);
          } if (state is VoucherNumberDoneState) {

            voucherNumber = accountBloc.voucherNumberData?.nextVoucherNumber.toString() ?? '';

            // Navigator.pop(context, true);
          }

          if (state is GetExpenseDetailDoneState) {
         setState(() {
           controllers['payee']?.text = accountBloc.expenseDetailData?.beneficiaryName ?? '';
           controllers['amount']?.text = (accountBloc.expenseDetailData?.amount ?? '')
               .replaceAll(RegExp(r'[^0-9.]'), '') // remove Rs or any non-numeric/non-dot chars
               .split('.')
               .first;
           controllers['description']?.text =accountBloc.expenseDetailData?.description ?? '';
           controllers['date']?.text =accountBloc.expenseDetailData?.date ?? '';
           controllers['category']?.text =accountBloc.expenseDetailData?.title ?? '';
           selectExpensesCategoryId =accountBloc.expenseDetailData?.categoryId ?? 0;
           controllers['payment']?.text = accountBloc.expenseDetailData?.paymentMode ?? '';
           controllers['chequeNumber']?.text = accountBloc.expenseDetailData?.chequeNumber ?? '';
           voucherNumber= accountBloc.expenseDetailData?.voucherNumber ;
           controllers['otherCategory']?.text = accountBloc.expenseDetailData?.otherDetails ?? '';

           selectPayeeId = accountBloc.expenseDetailData?.beneficiaryId ?? 0;
         });

          }
          if (state is AccountBookErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);

            controllers['date']?.text = DateFormat('d MMM, yyyy').format(_selectedDate);
            controllers['payment']?.text = 'Cash Payment';
          }

          if (state is UpdatePreExpenseErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }


          if (state is UpdatePreExpenseDoneState) {
            WorkplaceWidgets.successToast(state.message);

            Navigator.pop(context, true);

          }



        },
        child: BlocBuilder<AccountBookBloc, AccountBookState>(
          bloc: accountBloc,
          builder: (context, state) {
            if (state is AddExpensesDoneState) {
              clearAllControllers();

              // Navigator.pop(context, true);
            }
            if (state is UploadVoucherImageErrorState) {

                // selectProfilePhotoPath = null;
                selectProfilePhoto = null;
                 isImageSelected = false;
                // imageFile = {};
                // imagePath = {};

              // WorkplaceWidgets.errorSnackBar(context, state.errorMessage);

              // Navigator.pop(context, true);
            }
            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 22,right: 20,top: 10),
                      child: Row(
                        children: [
                        Text(   AppString.voucherNumber,
                          style: appStyles.texFieldPlaceHolderStyle(fontSize: 14),),
                        Text(voucherNumber ?? '', style: appStyles.textFieldTextStyle(fontSize: 16),)
                      ],),
                    ),
                    paymentField(),
                    chequeNumberField(),
                    dateField(),
                    payeeField(),
                    managePayee(),
                    categoryField(),
                    otherCategoryField(),
                    amountField(),
                    descriptionField(),
                    if(widget.isEditMode == false)
                    // uploadVoucher(state),
                    voucherPhotoUpload(state),
                    buttons(state),
                    const SizedBox(height: 20),
                  ],
                ),
                if (state is GetExpenseDetailLoadingState )
                  WorkplaceWidgets.progressLoader(context),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    focusNodes.forEach((key, node) => node.dispose());
    super.dispose();
  }
}