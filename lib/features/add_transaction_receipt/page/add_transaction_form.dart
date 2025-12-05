// File: team_member_details/member_header.dart
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:share_handler/share_handler.dart';
import 'package:asetize/features/account_books/bloc/account_book_bloc.dart';
import 'package:asetize/features/add_transaction_receipt/page/transaction_receipt_detail_screen.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/commonTitleRowWithIcon.dart';
import '../../account_books/pages/member_screen.dart';
import '../bloc/add_transaction_receipt_bloc.dart';
import '../bloc/add_transaction_receipt_event.dart';
import '../bloc/add_transaction_receipt_state.dart';

class AddTransactionForm extends StatefulWidget {
  final List<String>? comeWithPermission;
  final SharedMedia? media;
  final String? imagePath;
  final String? shareImagePath;
  final String? amount;
  final String? receiptNo;
  final String? title;
  final String? partyName;

  const AddTransactionForm(
      {super.key,
        this.media,
        this.amount,
        this.imagePath,
        this.receiptNo,
        this.title,
        this.partyName,
        this.shareImagePath,
        this.comeWithPermission = const []});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final Map<String, TextEditingController> controllers = {
    'amount': TextEditingController(),
    'selectUnit': TextEditingController(),
    'remark': TextEditingController(),
    'party': TextEditingController(),
    'paymentMethod': TextEditingController(),
  };
  final Map<String, FocusNode> focusNodes = {
    'amount': FocusNode(),
    'selectUnit': FocusNode(),
    'remark': FocusNode(),
    'party': FocusNode(),
    'paymentMethod': FocusNode(),
  };
  final Map<String, String> errorMessages = {
    'amount': "",
    'selectUnit': "",
    'remark': "",
    'party': "",
    'paymentMethod': "",
  };

  TextRecognizer textRecognizer = TextRecognizer();

  String? transactionId;
  double? amount;

  String? upiId;
  String? upiTransactionId;
  String? googleTransactionId;

  String imageErrorMessage = '';
  File? selectedReceiptImage;
  String? selectPaymentDate = "Select Payment Date";
  String formattedDate = ""; // Initialize with an empty string


  // int? selectedHouseId;

  String? selectedProfilePhotoPath;

  // bool isVerifyButtonEnabled = false;
  // bool isDisplayingInvoice = true;
  List<Houses>? housesData;
  List<int> houseId = [];

  late AccountBookBloc accountBookBloc;
  String recognizedText = '';
  bool isRecognizing = false;
  String? selectedPaymentMethod;

  DateTime _selectedDate = DateTime.now();
  DateTime? _cashSelectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? date;
  String? time;

  String formattedTime = ""; // Initialize with an emp
  double? fetchedAmount;


  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  late UserProfileBloc userProfileBloc;
  Houses? selectedUnit;
  List<Houses> houses = [];

  List<String> paymentMethods = [];
  late AddTransactionReceiptBloc addTransactionReceiptBloc;

  late BuildContext mContext;

  @override
  void initState() {
    // _processImage(widget.shareImagePath ?? '');
    // if (widget.shareImagePath != null && widget.shareImagePath!.isNotEmpty) {
    //   selectedReceiptImage = File(widget.shareImagePath!);
    //   selectedProfilePhotoPath = widget.shareImagePath;
    // }
    super.initState();
    if (controllers['paymentMethod']!.text == "Cash") {
      // Show Snackbar if date is not selected
      formattedDate == selectPaymentDate;
    }
    addTransactionReceiptBloc =
        BlocProvider.of<AddTransactionReceiptBloc>(context);

    addTransactionReceiptBloc.pendingInvoicesData = null;

    /// Reset all Value in bloc
    addTransactionReceiptBloc.add(OnFormEditEvent(resetAll: true));

    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

    /// Call Function to check and set flow on this
    checkPermission();
    // Automatically process the image on screen load
    // if (widget.amount != null) {
    //   controllers['amount']?.text = widget.amount ?? '';
    //   fetchedAmount = widget.amount !=null ? double.parse(widget.amount!):0.0;
    // }
    // userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    // if (widget.partyName != null) {
    //   controllers['party']?.text = widget.partyName ?? '';
    // }

    // if (userProfileBloc.user.houses != null &&
    //     userProfileBloc.user.houses!.isNotEmpty) {
    //   houses = userProfileBloc.user.houses ?? [];
    // }

    // selectedUnit = userProfileBloc.selectedUnit;
    // controllers['selectUnit']?.text = userProfileBloc.selectedUnit?.title ?? "";

    // if (widget.imagePath?.isNotEmpty == true) {
    //   File imageFileTemp = File(widget.imagePath ?? '');
    //   selectedReceiptImage = imageFileTemp;
    //   selectedProfilePhotoPath = selectedReceiptImage!.path;
    // }
    // addTransactionReceiptBloc.pendingInvoicesData.clear();
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());


    Widget fetchInvoiceBtn(state) {
      if (!addTransactionReceiptBloc.isDisplayFetchInvoiceBtn) {
        return const SizedBox();
      }
      return Container(width: 95,
        margin: const EdgeInsets.only(top: 0, bottom: 0),
        child: AppButton(textStyle: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),buttonHeight: 20,
          // Disable the button if amount is empty OR if submit button is visible
          buttonColor: AppColors.textBlueColor,
          buttonName: AppString.checkDues,
          backCallback: () {
            // Only allow the callback if the button is not disabled
            if ((controllers['amount']?.text.isNotEmpty ?? false)) {

              fetchedAmount = double.parse(
                  (controllers['amount']?.text ?? '').replaceAll(',', '')
              );
              // fetchedAmount = double.parse("${controllers['amount']?.text}");
              addTransactionReceiptBloc
                  .add(OnFormEditEvent(isDisplayFetchInvoiceBtn: false));

              // previousSelectedUnit = selectedUnit;

              callFetchInvoiceApi();
              closeKeyboard();
            }
          },
        ),
      );
    }

    Widget amountField(state) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CommonTextFieldWithError(
                  inputFormatter: [
                    ThousandsSeparatorInputFormatter(), // Use the custom formatter
                  ],
                  inputKeyboardType: InputKeyboardTypeWithError.numberWithDecimal,
                  // Ensure correct type
                  focusNode: focusNodes['amount'],
                  isShowBottomErrorMsg: true,
                  errorMessages: errorMessages['amount']?.toString() ?? '',
                  controllerT: controllers['amount'],
                  borderRadius: 8,
                  inputHeight: 50,
                  errorLeftRightMargin: 0,

                  maxCharLength: 500,
                  errorMsgHeight: 15,
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
                  textInputAction: TextInputAction.done,
                  borderStyle: BorderStyle.solid,
                  hintText: AppString.enterAmountHint,inputFieldSuffixIcon:  fetchInvoiceBtn(state),
                  placeHolderTextWidget: Padding(
                    padding: const EdgeInsets.only(left: 3.0, bottom: 0),
                    child: Text.rich(
                      TextSpan(
                        text: AppString.amountHint,
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
                  textStyle: appTextStyle.appLargeTitleStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                  contentPadding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  onTextChange: (value) {
                    final cleanedValue = value.toString().replaceAll(',', '');

                    if (cleanedValue.isEmpty || double.tryParse(cleanedValue) == null || double.parse(cleanedValue) <= 0) {
                      addTransactionReceiptBloc.add(OnFormEditEvent(
                        isDisplayFetchInvoiceBtn: true,
                        finalAmount: 0,
                        isReadyToSubmit: false,
                      ));
                      return;
                    }

                    final parsedValue = double.parse(cleanedValue);

                    if (parsedValue > 0 && parsedValue != fetchedAmount) {
                      addTransactionReceiptBloc.add(OnFormEditEvent(
                        isDisplayFetchInvoiceBtn: true,
                        finalAmount: parsedValue,
                        isReadyToSubmit: false,
                      ));
                    } else {
                      bool isReadyToSubmit = addTransactionReceiptBloc.pendingInvoicesData != null && selectedUnit != null;
                      addTransactionReceiptBloc.add(OnFormEditEvent(
                        isDisplayFetchInvoiceBtn: false,
                        finalAmount: parsedValue,
                        isReadyToSubmit: isReadyToSubmit,
                      ));
                    }
                  },

                  onEndEditing: (value) {},

                  onTapCallBack: () {},
                ),

              ],
            ),
          ],
        ),
      );
    }

    void showHouseSelectionSheet() {
      if (houses.length > 1) {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context1) {
            return CupertinoActionSheet(
              title: const Text(
                AppString.selectHouse,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
              actions: houses
                  .map((house) => CupertinoActionSheetAction(
                onPressed: () {
                  // setState(() {
                  // _clearReceiptData();
                  // _showNextSection = false;

                  // selectedHouseId =
                  //     house.id; // Assuming Houses has an 'id' field
                  // selectedHouseTitle = house
                  //     .title; // Assuming Houses has a 'title' field
                  // });

                  Navigator.pop(context);
                  if(house == selectedUnit){
                    return ;
                  }
                  selectedUnit = house;
                  addTransactionReceiptBloc.add(OnFormEditEvent(
                      selectedUnitId: selectedUnit?.id, isDisplayFetchInvoiceBtn: true));
                  callFetchInvoiceApi();
                },
                child: Text(
                  house.title ?? '',
                  style: TextStyle(
                    color: house.title == selectedUnit!.title
                        ? AppColors.textBlueColor
                        : Colors.black,
                    fontWeight: house.title == selectedUnit!.title
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ))
                  .toList(),
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context1),
                child: const Text(
                  AppString.cancel,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          },
        );
      }
    }

    memberField(state) {
      return CommonTextFieldWithError(
        onTapCallBack: () {
          // _clearReceiptData();
          Navigator.push(context,
              SlideLeftRoute(widget: const MemberScreen()))
              .then((value) {
            // print(value);
            controllers['party']?.text = value.name.toString() ?? '';
            checkParty(value.name.toString(), 'party', onchange: true);
            User user = value;
            if (user.houses != null || user.houses?.isNotEmpty == true) {
              houses = List.generate(user.houses?.length ?? 0, (index) {
                return Houses(
                    id: user.houses?[index].id,
                    title: user.houses?[index].title);
              });
              selectedUnit = houses[0];
              addTransactionReceiptBloc
                  .add(OnFormEditEvent(selectedUnitId: selectedUnit?.id,isDisplayFetchInvoiceBtn: true));
              callFetchInvoiceApi();
            }
          });
          // setState(() {
          // _showNextSection =
          //     false; // Hide next section when amount changes// Assuming Houses has a 'title' field
          // });
        },
        readOnly: true,
        focusNode: focusNodes['party'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['party']?.toString() ?? '',
        controllerT: controllers['party'],
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
        textInputAction: TextInputAction.newline,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.multiLine,
        placeHolderTextWidget: Padding(
          padding: const EdgeInsets.only(left: 3.0, bottom: 0),
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
        // labelText: 'Owner',
        // labelStyle: const TextStyle(
        //     fontWeight: FontWeight.w500, color: AppColors.black),
        hintStyle: appStyles.textFieldTextStyle(
            fontWeight: FontWeight.w400,
            texColor: Colors.grey.shade600,
            fontSize: 14),
        textStyle: appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
        contentPadding:
        const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),

        onTextChange: (value) {
          checkParty(value, 'party', onchange: true);
        },
        onEndEditing: (value) {
          checkParty(value, 'party');
          FocusScope.of(context).requestFocus(focusNodes['']);
        },
      );
    }

    Widget buildHouseSelector() {
      bool isSingleHouse = houses.length == 1;
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20, top: 5),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isSingleHouse ? null : showHouseSelectionSheet,
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 3,
                      offset: const Offset(0, 1),
                      blurRadius: 3)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedUnit!.title ?? AppString.selectUnit,
                  style: TextStyle(
                    color: selectedUnit!.title != null
                        ? Colors.black
                        : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                if (!isSingleHouse)
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 16,
                    color: Colors.grey.shade600,
                  )
              ],
            ),
          ),
        ),
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
                  // If there is only one house, select it directly
                  // if(selectedUnit != previousSelectedUnit) {
                  _onUnitSelected(0); // Or handle it differently as needed
                  // }
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
                    text: AppString.houseFlatNumber,
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

    Widget imageUpload(state) {
      if(addTransactionReceiptBloc.imageFile!=null && addTransactionReceiptBloc.imageFile!.isNotEmpty){
        selectedReceiptImage = addTransactionReceiptBloc.imageFile?.values.first;
      }
      else{
        selectedReceiptImage = null;
        return const SizedBox();
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: AppString.transactionReceiptUpload,
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
            const SizedBox(height: 10),
            GestureDetector(
              onTap: null /*() => photoPickerBottomSheet()*/,
              child: Container(
                padding:
                const EdgeInsets.all(8).copyWith(top: 0, bottom: 0, left: 0),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(width: 0.8, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 3,
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Stack(

                        children: [
                          if (selectedReceiptImage != null && selectedReceiptImage!.path.trim().isNotEmpty)

                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap:(){
                                      String title = AppString.transactionReceiptUpload;
                                      String method = controllers['paymentMethod']!.text;
                                      if(method.isNotEmpty){
                                        title = title.replaceFirst("Upload", method);
                                      }
                                      Navigator.of(context).push(FadeRoute(
                                        widget:  FullPhotoView(
                                          comeFromTransactionPage : true,
                                          title: title ,
                                          localProfileImgUrl: selectedProfilePhotoPath,
                                        ),
                                      ));
                                    },
                                    child: Image.file(
                                      selectedReceiptImage!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Positioned(
                                  //   top: 4,
                                  //   right: 4,
                                  //   child: GestureDetector(
                                  //     onTap: _removeImage,
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: Colors.black.withOpacity(0.6),
                                  //       ),
                                  //       padding: const EdgeInsets.all(4),
                                  //       child: const Icon(
                                  //         Icons.close,
                                  //         color: Colors.white,
                                  //         size: 16,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          else
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.image,
                                        size: 24, color: Colors.grey),
                                  ),
                                  Text(
                                    AppString.upload,
                                    style: appStyles.userJobTitleTextStyle(
                                      fontSize: 14,
                                      texColor: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // const SizedBox(width: 16),
                    // Flexible(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         AppString.uploadHint,
                    //         style: appStyles.userJobTitleTextStyle(
                    //           fontSize: 14,
                    //           texColor: Colors.grey.shade600,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 2),
                    //       Text(
                    //         AppString.uploadSizeHint,
                    //         style: appStyles.userJobTitleTextStyle(
                    //           fontSize: 14,
                    //           texColor: Colors.grey.shade600,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 2),
                    //       Text(
                    //         AppString.uploadMaxImageHint,
                    //         style: appStyles.userJobTitleTextStyle(
                    //           fontSize: 14,
                    //           texColor: Colors.grey.shade600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            if (imageErrorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  imageErrorMessage,
                  style: appStyles.errorStyle(),
                ),
              ),
          ],
        ),
      );
    }


    Widget paymentMethodField(state) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextFieldWithError(
              readOnly: true,
              inputFormatter: const <TextInputFormatter>[],
              inputKeyboardType: InputKeyboardTypeWithError.text,
              focusNode: focusNodes['paymentMethod'],
              isShowBottomErrorMsg: true,
              errorMessages: errorMessages['paymentMethod']?.toString() ?? '',
              controllerT: controllers['paymentMethod'],
              borderRadius: 8,
              onTapCallBack: () {
                // _clearReceiptData();
                paymentOptionSheet(paymentMethods);
              },
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
              textInputAction: TextInputAction.none,
              borderStyle: BorderStyle.solid,
              hintText: AppString.paymentMethod,
              placeHolderTextWidget: Padding(
                padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                child: Text.rich(
                  TextSpan(
                    text: AppString.paymentMethodLabelNew,
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
              inputFieldSuffixIcon: Icon(
                CupertinoIcons.chevron_down,
                size: 16,
                color: Colors.grey.shade600,
              ),
              contentPadding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              onTextChange: (value) {
                // setState(() {
                //   _showNextSection = false; // Hide next section when payment method changes
                // });
                checkPaymentMethod(value, onchange: true);
              },
              onEndEditing: (value) {
                checkPaymentMethod(value);
              },
            ),
          ],
        ),
      );
    }

    Widget remarksField(state) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextFieldWithError(
              focusNode: focusNodes['remark'],
              isShowBottomErrorMsg: true,
              errorMessages: errorMessages['remark']?.toString() ?? '',
              controllerT: controllers['remark'],
              borderRadius: 8,
              inputHeight: 50,
              // Adjust height as needed
              errorLeftRightMargin: 0,
              maxCharLength: 500,
              errorMsgHeight: 18,
              minLines: 1,
              // maxLines: 5, // Allow up to 5 lines
              autoFocus: false,
              showError: true,
              showCounterText: false,
              capitalization: CapitalizationText.sentences,
              cursorColor: Colors.grey,
              enabledBorderColor: Colors.white,
              focusedBorderColor: Colors.white,
              backgroundColor: AppColors.white,
              textInputAction: TextInputAction.done,
              // keyboardType: TextInputType.multiline, // Ensure this is set
              borderStyle: BorderStyle.solid,
              hintText: AppString.remarksHint,
              placeHolderTextWidget: Padding(
                padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                child: Text.rich(
                  TextSpan(
                    text: AppString.remarksHint,
                    style: appStyles.texFieldPlaceHolderStyle(),
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
              onEndEditing: (value) {
                checkSelectedUnitNumber(value, 'selectUnit');
                FocusScope.of(context).requestFocus(focusNodes['']);
              },
              onTextChange: (value) {
                checkSelectedUnitNumber(value, 'selectUnit', onchange: true);
              },
            ),
          ],
        ),
      );
    }

    Widget submitFormBtn(state) {
      if(addTransactionReceiptBloc.isDisplayFetchInvoiceBtn || !addTransactionReceiptBloc.isReadyToSubmit){
        return const SizedBox();
      }
      return Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20),
        child: AppButton(
          isLoader: state is AddTransactionReceiptLoadingState? true: false,
          buttonColor: !addTransactionReceiptBloc.isReadyToSubmit || state is AddTransactionReceiptLoadingState
              ? Colors.grey
              : AppColors.textBlueColor,
          buttonName: AppString.submit,
          backCallback: () {
            if (!addTransactionReceiptBloc.isReadyToSubmit || state is AddTransactionReceiptLoadingState) {
              return;
            }
            // if (controllers['paymentMethod']!.text == "Cash")
            //   formattedDate = selectPaymentDate!;
            if (_cashSelectedDate == null && controllers['paymentMethod']!.text == "Cash") {
              WorkplaceWidgets.errorSnackBar(context, "Please select the payment date");
              return; //
            }
            if ( formattedDate == selectPaymentDate) {
              // Show Snackbar if date is not selected

              WorkplaceWidgets.errorSnackBar(context, "Please select the payment date");
              return; // Exit the function early
            }
            formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);



            // String timeToSend = formattedTime.isNotEmpty ? formattedTime : projectUtil.convertTo24HourFormat(
            //     '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}');


            formattedTime = projectUtil.convertTo24HourFormat(
                '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}');
            // String currentDate =
            // DateFormat('yyyy-MM-dd').format(DateTime.now());
            if (validateFields(isButtonClicked: true)) {
              bool isNotAccountant = true;
              /// It will true in case of submit payment by Accountant
              if(widget.comeWithPermission![0] == AppString.accountPaymentAdd){
                isNotAccountant = false;
              }

              addTransactionReceiptBloc.add(SubmitTransactionReceipt(
                  houseId: (AppPermission.instance.canPermission(
                      AppString.accountPaymentAdd,
                      context: mContext))
                      ? selectedUnit?.id ??
                      0 // Use 0 if selectedHouseId is null
                      : selectedUnit?.id ?? 0,
                  // Use 0 if selectedUnit?.id is null
                  amount: controllers['amount']?.text.replaceAll(',', '') ?? '',
                  filePath: selectedProfilePhotoPath ?? '',
                  comments:
                  controllers['remark']?.text.replaceAll(',', '') ?? '',
                  paymentMethod: controllers['paymentMethod']!.text.isEmpty
                      ? "Online"
                      : controllers['paymentMethod']!.text.toString(),
                  transactionDate: formattedDate,
                  // Use recognized date
                  transactionTime: formattedTime,
                  mContext: mContext,isForSelf: isNotAccountant));
            } else {
              print('error');
            }
          },
        ),
      );
    }

    Widget title({required String text}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              text,
              style: appStyles.texFieldPlaceHolderStyle(),
            ),
          ],
        ),
      );
    }



    // controllers['paymentMethod']!.text.isNotEmpty
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBarHeight: 50,
      appBar: BlocBuilder<AddTransactionReceiptBloc, AddTransactionReceiptState>(
        bloc: addTransactionReceiptBloc,
        builder: (context, state) {
          String title = AppString.transactionReceiptUpload;
          String method = controllers['paymentMethod']!.text;
          if(method.isNotEmpty){
            title = title.replaceFirst("Upload", method);
          }
          return  CommonAppBar(
            isThen:false,
            title: title,
            icon: WorkplaceIcons.backArrow,
          );
          //  }
        },
      ) ,
      containChild:
      BlocListener<AddTransactionReceiptBloc, AddTransactionReceiptState>(
        bloc: addTransactionReceiptBloc,
        listener: (context, state) {
          if (state is AddTransactionReceiptErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.message);
          } else if (state is TransactionReceiptSubmitSuccessState) {
            /// Reset all Value in bloc
            addTransactionReceiptBloc.add(OnFormEditEvent(resetAll: true));

            redirectOnSubmitSuccess();
          } else if (state is AddTransactionReceiptSuccessState) {
            // setState(() {
            //   isDisplayingInvoice = true;
            // });
            bool isReadYtoSubmit = addTransactionReceiptBloc.pendingInvoicesData != null ;
            addTransactionReceiptBloc.add(OnFormEditEvent(
                imageFile: imageFile,
                imagePath: imagePath,
                isDisplayFetchInvoiceBtn: false, isReadyToSubmit: isReadYtoSubmit));
          }

          else if (state is FormEditDoneState) {
            if (selectedUnit != null &&
                !addTransactionReceiptBloc.isDisplayFetchInvoiceBtn ) {
              //callFetchInvoiceApi();
            }
          }
        },
        child:
        BlocBuilder<AddTransactionReceiptBloc, AddTransactionReceiptState>(
          bloc: addTransactionReceiptBloc,
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, left: 15, right: 18, bottom: 0),
                    child: Column(
                      children: [
                        if (controllers['paymentMethod']!.text.isNotEmpty && controllers['paymentMethod']!.text.toLowerCase() != "cash")
                          imageUpload(state),
                        const SizedBox(height: 5),

                        amountField(state),
                        const SizedBox(height: 0),
                        topCalendarAndTime(),
                        const SizedBox(height: 15),

                        if (canDisplaySelectMemberView())
                          Column(
                            children: [
                              memberField(state),
                              if (houses.isNotEmpty) ...[
                                title(text: AppString.selectUnitWithStar),
                                buildHouseSelector(),
                                // selectUnit(state),
                              ],
                            ],
                          )
                        else
                          selectUnit(state),
                        invoiceList(state),

                        /*if (controllers['paymentMethod']!.text.isNotEmpty)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (AppPermission.instance.canPermission(
                                  AppString.accountBookList,
                                  context: context))
                                paymentMethodField(state),
                            ],
                          ),*/
                        if (amount != null) remarksField(state),
                        const SizedBox(height: 8),


                        submitFormBtn(state),
                        // const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                // if (state is AddTransactionReceiptLoadingState)
                //   WorkplaceWidgets.progressLoader(mContext),
              ],
            );
            //  }
          },
        ),
      ),
    );
  }

  checkParty(value, fieldEmail, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.isNotEmpty(value.trim())) {
          errorMessages[fieldEmail] = "";
        } else {
          if (!onchange) {
            errorMessages[fieldEmail] =
                AppString.trans(context, AppString.emailHintError1);
          }
        }
      });
    } else {
      setState(() {
        if (!onchange) {
          if (fieldEmail == 'party') {
            errorMessages[fieldEmail] =
                AppString.trans(context, AppString.emailHintError);
          }
        }
      });
    }
  }

  checkPaymentMethod(String value, {bool onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        errorMessages['paymentMethod'] = "";
      });
    } else {
      setState(() {
        if (!onchange) {
          errorMessages['paymentMethod'] = AppString.paymentMethod;
        }
      });
    }
  }

  void checkSelectedUnitNumber(String value, String fieldEmail,
      {bool onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        errorMessages[fieldEmail] = "";
      });
    } else {
      setState(() {
        if (!onchange) {
          errorMessages[fieldEmail] =
              AppString.trans(context, AppString.emailHintError);
        }
      });
    }
  }

  Widget topCalendarAndTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3,bottom: 5),
          child: Text.rich(
            TextSpan(
              text: "Payment Date",
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
        GestureDetector(
            onTap: _pickDate,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 0.5,color: Colors.grey.shade200),
                  color: Colors.white),
              height: 48,
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Text(
                    formattedDate.isNotEmpty && formattedDate != selectPaymentDate ? formattedDate : selectPaymentDate ?? '', // Ensure a default text
                    style:  TextStyle(
                      fontSize: 15,
                      color: formattedDate.isNotEmpty && formattedDate != selectPaymentDate ? Colors.black : Colors.grey.shade600,
                      fontWeight: formattedDate.isNotEmpty && formattedDate != selectPaymentDate ?FontWeight.w500:FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
        ),
      ],
    );
  }

  /// Payment Option picker sheet
  void paymentOptionSheet(List<String> paymentMethods,
      {bool? canClose = false, Function(String)? onSelectedPaymentMethod}) {
    String selected = "";
    showCupertinoModalPopup(
      context: mContext,
      barrierDismissible: canClose!,
      builder: (BuildContext popupContext) => CupertinoActionSheet(
        title: const Text(
          AppString.selectPaymentMethod,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        actions: paymentMethods.map((method) {
          return CupertinoActionSheetAction(
            onPressed: () {
              // setState(() {
              //   controllers['paymentMethod']?.text = method;
              //   selectedPaymentMethod = method; // Update the
              //   // Clear the error message when a selection is made
              //   errorMessages['paymentMethod'] = '';
              // });
              selected = method;

              /// Here we are make sure image must upload successfully because image is mandatory in case user update receipt from online
              if (!canClose) {
                if (selected.isNotEmpty) {
                  Navigator.pop(popupContext);
                  // Navigator.pop(popupContext);
                  onSelectedPaymentMethod?.call(method);
                }
              } else {
                Navigator.pop(popupContext);
                Navigator.pop(popupContext);
              }
            },
            child: Text(
              method,
              style: TextStyle(
                color: controllers['paymentMethod']?.text == method
                    ? AppColors.textBlueColor
                    : Colors.black,
                fontWeight: controllers['paymentMethod']?.text == method
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            if (!canClose) {
              if (selected.isNotEmpty) {
                Navigator.pop(popupContext);
              } else {
                Navigator.pop(popupContext);
                Navigator.pop(mContext);
              }
            } else {
              Navigator.pop(popupContext);
            }
          },
          isDefaultAction: false,
          child: const Text(
            AppString.cancel,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  /// Receipt image picker
  void photoPickerBottomSheet(
      {bool? canClose = false,bool? canSkip = false,
        Function({Map<String, File>? imageFile, Map<String, String>? imagePath})?
        onSelectedImageCallBack}) {
    showModalBottomSheet(
      context: mContext,
      enableDrag: false,
      isDismissible: canClose!,
      builder: (popupContext) {
        Map<String, File>? imageFile = <String, File>{};
        Map<String, String>? imagePath = <String, String>{};

        return PhotoPickerBottomSheet(
          isRemoveOptionNeeded: true,
          cancelText:"Cancel",
          cancelIcon:const Padding(
            padding:  EdgeInsets.only(left: 5),
            child: Icon(
              Icons.close,
              color: AppColors.textBlueColor,
              size: 26,
            ),
          ),
          topLineClickCallBack: () {
            if (!canClose) {
              if (imageFile!.isNotEmpty) {
                Navigator.pop(popupContext);
              }
            } else {
              Navigator.pop(popupContext);
            }
          },
          removedImageCallBack: () {
            Navigator.pop(popupContext);
            Navigator.pop(mContext);

          },
          onSkipClick: canSkip==false?null:() {
            Navigator.pop(popupContext);
          },
          selectedImageCallBack: (fileList) {
            try {
              if (fileList != null && fileList.isNotEmpty) {
                fileList.map((fileDataTemp) {
                  File imageFileTemp = File(fileDataTemp.path);
                  String mapKey =
                  DateTime.now().microsecondsSinceEpoch.toString();
                  imageFile![mapKey] = imageFileTemp;
                  imagePath![mapKey] = imageFileTemp.path;
                }).toList(growable: false);
              }
            } catch (e) {
              debugPrint('$e');
            }
            /// Here we are make sure image must upload successfully because image is mandatory in case user update receipt from online
            if (!canClose && imageFile!.isNotEmpty) {
              if (imageFile!.isNotEmpty) {
                Navigator.pop(popupContext);
                onSelectedImageCallBack?.call(
                    imageFile: imageFile, imagePath: imagePath);
              }
            } else {
              Navigator.pop(popupContext);
            }
          },
          selectedCameraImageCallBack: (fileList) {
            try {
              if (fileList != null && fileList.path!.isNotEmpty) {
                File imageFileTemp = File(fileList.path!);
                imageFile = {};
                imagePath = {};
                String mapKey =
                DateTime.now().microsecondsSinceEpoch.toString();
                imageFile![mapKey] = imageFileTemp;
                imagePath![mapKey] = imageFileTemp.path;
              }
            } catch (e) {
              debugPrint('$e');
            }

            /// Here we are make sure image must upload successfully because image is mandatory in case user update receipt from online
            if (!canClose && imageFile!.isNotEmpty) {
              if (imageFile!.isNotEmpty) {
                Navigator.pop(popupContext);
                onSelectedImageCallBack?.call(
                    imageFile: imageFile, imagePath: imagePath);
              }
            } else {
              Navigator.pop(popupContext);
            }
          },
        );
      },
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(photoPickerBottomSheetCardRadius)),
      ),
    );
  }

  /// Unit Selection sheet
  void unitSelectionPopUpSheet() {
    // Check if there is more than one house
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
                  _onUnitSelected(index); // Use the new method

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

  /// In this function we ar checking flow according to Uer access permissions
  Future<void> checkPermission() async {
    paymentMethods = [];
    // Add payment methods based on permissions
    if (AppPermission.instance
        .canPermission(AppString.accountCash, context: context)) {
      paymentMethods.add('Cash');
    }
    // if (AppPermission.instance
    //     .canPermission(AppString.accountOnline, context: context)) {
    paymentMethods.add('Online');
    // }
    // if (AppPermission.instance
    //     .canPermission(AppString.accountCheque, context: context)) {
    paymentMethods.add('Cheque');
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) {

      projectUtil.printP(
          "method >> ${widget.comeWithPermission![0]} == ${AppString.managerUnitTransactionReceiptUpload}");
      /// User Flow for uploading image
      if (widget.comeWithPermission![0] ==
          AppString.unitTransactionReceiptUpload) {
        houses = [];
        if (userProfileBloc.user.houses != null &&
            userProfileBloc.user.houses!.isNotEmpty) {
          houses = userProfileBloc.user.houses ?? [];
          selectedUnit = houses.isNotEmpty ? houses[0] : null;
        }
        selectedUnit = userProfileBloc.selectedUnit;

        controllers['paymentMethod']!.text = "Online";
        controllers['selectUnit']?.text = selectedUnit?.title ?? "";
        photoPickerBottomSheet(
            canClose: false,
            onSelectedImageCallBack: (
                {Map<String, File>? imageFile,
                  Map<String, String>? imagePath}) async {
              projectUtil.printP("Photo  $imagePath");
              await _processImage(imagePath!.values.first);
              if (amount!=null && amount! > 0) {
                callFetchInvoiceApi();
              }

              selectedProfilePhotoPath = imagePath.isNotEmpty?imagePath.values.first:"";

              projectUtil.printP("amount >>  $amount");
              addTransactionReceiptBloc.add(OnFormEditEvent(
                  imageFile: imageFile,
                  imagePath: imagePath,
                  isDisplayFetchInvoiceBtn: false,
                  finalAmount: amount,
                  selectedUnitId: selectedUnit?.id));
              projectUtil.printP("Photo  $imagePath");
            });
      }

      /// For manager
      else if (widget.comeWithPermission![0] ==
          AppString.managerUnitTransactionReceiptUpload) {
        /// Call Payment method
        paymentOptionSheet(paymentMethods, canClose: false,
            onSelectedPaymentMethod: (method) {
              projectUtil.printP("method $method");
              controllers['paymentMethod']!.text = method;
              bool canClosePhotoPopUp = method == "Cash" ? true : false;
              if(!canClosePhotoPopUp){
                photoPickerBottomSheet(
                    canClose: canClosePhotoPopUp,
                    onSelectedImageCallBack: (
                        {Map<String, File>? imageFile,
                          Map<String, String>? imagePath}) async {
                      await _processImage(imagePath!.values.first);
                      selectedProfilePhotoPath = imagePath.isNotEmpty?imagePath.values.first:"";
                      if (amount!=null && amount! > 0) {
                        callFetchInvoiceApi();
                      }
                      projectUtil.printP("amount >>  $amount");
                      addTransactionReceiptBloc.add(OnFormEditEvent(
                          imageFile: imageFile,
                          imagePath: imagePath,
                          isDisplayFetchInvoiceBtn: false,
                          finalAmount: amount));
                      projectUtil.printP("Photo  $imagePath");
                    });
              }
              else {
                addTransactionReceiptBloc.add(OnFormEditEvent(
                    imageFile: imageFile,
                    imagePath: imagePath,
                    isDisplayFetchInvoiceBtn: false,
                    finalAmount: amount));
              }
            });
      }

      /// For Accountant
      else if (widget.comeWithPermission![0] == AppString.accountPaymentAdd) {
        paymentOptionSheet(paymentMethods, canClose: false,
            onSelectedPaymentMethod: (method) {
              projectUtil.printP("method $method");
              controllers['paymentMethod']!.text = method;
              bool canClosePhotoPopUp = method == "Cash" ? true : false;
              if(!canClosePhotoPopUp){
                photoPickerBottomSheet(
                    canSkip: true,
                    canClose: canClosePhotoPopUp,
                    onSelectedImageCallBack: (
                        {Map<String, File>? imageFile,
                          Map<String, String>? imagePath}) async {
                      await _processImage(imagePath!.values.first);
                      selectedProfilePhotoPath = imagePath.isNotEmpty?imagePath.values.first:"";
                      if (amount!=null && amount! > 0) {
                        callFetchInvoiceApi();
                      }
                      projectUtil.printP("amount >>  $amount");
                      addTransactionReceiptBloc.add(OnFormEditEvent(
                          imageFile: imageFile,
                          imagePath: imagePath,
                          isDisplayFetchInvoiceBtn: false,
                          finalAmount: amount));
                      projectUtil.printP("Photo  $imagePath");
                    });
              }
              else {
                addTransactionReceiptBloc.add(OnFormEditEvent(
                    imageFile: imageFile,
                    imagePath: imagePath,
                    isDisplayFetchInvoiceBtn: false,
                    finalAmount: amount));
              }
            });
      }
    });
  }
  void receivedANewMessage(BuildContext context,) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WorkplaceWidgets.titleContentPopup(
          buttonName1: AppString.capitalSkip,
          buttonName2: AppString.yes,
          onPressedButton1TextColor: AppColors.black,
          onPressedButton2TextColor: AppColors.white,
          onPressedButton1Color: Colors.grey.shade200,
          onPressedButton2Color: AppColors.appBlueColor,
          onPressedButton1: () {
            Navigator.pop(context);
          },
          onPressedButton2: () async {
            Navigator.pop(context);
          },
          title: AppString
              .receiptsUploadedSuccessfully,
          content: AppString.receiptsStatusAlertContent,
        );
      },
    );
  }
  /// In this function we ar checking flow according to Uer access permissions
  Future<void> redirectOnSubmitSuccess() async {
    /// User Flow for uploading image
    if (widget.comeWithPermission![0] ==
        AppString.unitTransactionReceiptUpload) {
      // Navigate to home if permission exists
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => const TransactionReceiptDetailScreen()),
      // );
      Navigator.pop(mContext,true);

      // receivedANewMessage(context);
      // Fluttertoast.showToast(
      //     backgroundColor: Colors.green.shade500,
      //     msg: AppString
      //         .receiptsUploadedSuccessfully); // Replace '/home' with your actual home route
    }

    /// For manager
    else if (widget.comeWithPermission![0] ==
        AppString.managerUnitTransactionReceiptUpload) {
      Navigator.pop(context, true);
      WorkplaceWidgets.successToast(AppString.receiptsUploadedSuccessfully,durationInSeconds: 1);
    }

    /// For manager
    else if (widget.comeWithPermission![0] == AppString.accountPaymentAdd) {
      Navigator.pop(mContext,true);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const AccountBooksScreen()),
      // );

      WorkplaceWidgets.successToast(AppString.receiptsUploadedSuccessfully,durationInSeconds: 1);
    } else {
      Navigator.pop(context, true);
      WorkplaceWidgets.successToast(AppString.receiptsUploadedSuccessfully,durationInSeconds: 1);
    }
  }

  Future<void> _processImage(String imagePath) async {
    projectUtil.printP("Image path $imagePath");
    String? amountTemp;
    if (!File(imagePath).existsSync()) {
      setState(() {
        recognizedText = AppString.invalidImagePath;
      });
      return;
    }

    setState(() {
      isRecognizing = true;
    });
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognisedText =
      await textRecognizer.processImage(inputImage);

      String text = "";
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          text += "${line.text}\n";
        }
      }

      // Define regex patterns
      final amountRegex = RegExp(r'₹\s*([\d,]+\.?\d*)');
      final transactionIdRegex = RegExp(r'Transaction ID[:\s]*([A-Za-z0-9]+)');

      final fallbackAmountRegex = RegExp(r'');
      final upiIdRegex =
      RegExp(r'UPI ID[:\s]+([\w\d\.-]+@[\w\d\.-]+)'); // Updated regex
      final upiTransactionIdRegex = RegExp(r'\b\d{12}\b');
      final googleTransactionIdRegex = RegExp(r'[A-Z]{4}[a-z][A-Za-z0-9]{8,}');
      // Updated regex patterns for date and time
      final dateRegex = RegExp(r'(\d{1,2}\s\w{3}\s\d{4})'); // Matches "25 Apr 2024"
      final timeRegex = RegExp(r'(\d{1,2}:\d{2}\s?[APMapm]{2})'); // Matches "12:17 PM"

      amountTemp = amountRegex.firstMatch(text)?.group(1);
      transactionId = transactionIdRegex.firstMatch(text)?.group(1);
      upiId = upiIdRegex.firstMatch(text)?.group(1);
      upiTransactionId = upiTransactionIdRegex.firstMatch(text)?.group(0);
      googleTransactionId = googleTransactionIdRegex.firstMatch(text)?.group(0);
      date = dateRegex.firstMatch(text)?.group(1);
      time = timeRegex.firstMatch(text)?.group(1);

      // If date or time is not recognized, set to current date and time
      if (date == null || time == null) {
        formattedDate = selectPaymentDate!; // Set placeholder text
        final now = DateTime.now();
        time = "${now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'pm' : 'am'}";
      } else {
        // Set formattedDate and formattedTime to recognized values
        formattedDate = date!;
        formattedTime = time!;
      }

      DateFormat format = DateFormat("d MMM, yyyy");
      try {
        _selectedDate = format.parse(date!);
        print(_selectedDate); // Output: 2024-12-05 00:00:00.000
      } catch (e) {
        print("Error parsing date: $e");
      }
      // Fallback for standalone numeric value
      if (amountTemp == null) {
        for (String line in text.split('\n')) {
          if (fallbackAmountRegex.hasMatch(line.trim())) {
            amountTemp = line.trim();
            try {
              amount = double.parse(amountTemp);
            } catch (e) {
              print(e);
            }
            break;
          }
        }
      }
      // Update the text controller with the recognized amount
      if (amountTemp != null) {
        amount = double.parse(amountTemp);
        setState(() {
          controllers['amount']?.text =
          amountTemp!; // Set the recognized amount into the text controller
          fetchedAmount = amount;
        });
      } else {
        setState(() {
          amount = 0.0;
          controllers['amount']?.text =
          ""; // Set text to empty string if amount is null
          fetchedAmount = 0.0;
        });
      }
      // Build the result and update the UI
      String result = '';
      result += 'Amount: ${amount ?? ""}\n';
      result += 'Transaction ID: ${transactionId ?? ""}\n';
      result += 'UPI ID: ${upiId ?? ""}\n';
      result += 'UPI Transaction ID: ${upiTransactionId ?? ""}\n';
      result += 'Google Transaction ID: ${googleTransactionId ?? ""}\n';
      result += 'Date: ${date ?? ""}\n'; // Add recognized date
      result += 'Time: ${time ?? ""}\n'; // Add recognized time

      if (result.isEmpty) {
        result = AppString.errorMessageNoDataFound;
      }

      setState(() {
        recognizedText = result;
        formattedDate = date!;
        formattedTime = time!;
      });
    } catch (e) {
      setState(() {
        recognizedText = 'Error recognizing text: $e';
      });
    } finally {
      setState(() {
        isRecognizing = false;
      });
    }
  }


  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Restrict to today's date
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
        _cashSelectedDate = picked;
        // Update formattedDate when a new date is picked
        formattedDate = DateFormat('d MMM, yyyy').format(_selectedDate);
      });
    }
  }



  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        // Update formattedTime when a new time is picked
        formattedTime =
        '${_selectedTime.hour % 12}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.hour >= 12 ? 'PM' : 'AM'}';
      });
    }
  }

  bool validateFields({isButtonClicked = false}) {
    if (controllers['amount']?.text == null ||
        controllers['amount']?.text == '') {
      setState(() {
        if (isButtonClicked) {
          FocusScope.of(context).requestFocus(focusNodes['amount']);
          errorMessages['amount'] = AppString.errorForEnterAmount;
        }
      });
      return false;
    } else if (!Validation.isNotEmpty(controllers['amount']?.text ?? '')) {
      setState(() {
        if (isButtonClicked) {
          FocusScope.of(context).requestFocus(focusNodes['amount']);
          errorMessages['amount'] = AppString.enterValidAddress;
        }
      });
      return false;
    }

    if (selectedUnit == null) {
      setState(() {
        if (isButtonClicked) {
          FocusScope.of(context).requestFocus(focusNodes['selectUnit']);
          errorMessages['selectUnit'] = AppString.errorSelectTheUnit;
        }
      });
      return false;
    } else {
      // Offline payment ke case me validation skip karna hai
      return true;
    }
  }

  void _onUnitSelected(int index) {
    if(selectedUnit == houses[index]){
      return ;
    }
    selectedUnit = houses[index];
    controllers['selectUnit']?.text = selectedUnit!.title!;
    errorMessages['selectUnit'] = "";

    addTransactionReceiptBloc
        .add(OnFormEditEvent(selectedUnitId: selectedUnit?.id,isDisplayFetchInvoiceBtn: true));
    callFetchInvoiceApi();
  }

  /// Calling API to fetch amount
  void callFetchInvoiceApi() {

    if (selectedUnit == null || controllers['amount']?.text == null ||
        controllers['amount']?.text == '') {
      return;
    }

    // if (selectedUnit == null || selectedUnit == previousSelectedUnit) {
    //   return; // Do not call the API
    // }


    addTransactionReceiptBloc.add(
      GetPandingReceipt(
          houseId: selectedUnit?.id.toString() ?? '',
          amount: controllers['amount']?.text.replaceAll(',', '') ?? '',
          mContext: context,isForSelf: false),
    );
  }

  Widget pendingInvoices({
    required String durations,
    required String invoiceNumber,
    required String invoiceAmountLabel,
    required String status,
    required bool isChecked,
    Function(bool?)? onCheckboxChanged,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        return Column(
          children: [
            CommonCardView(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Padding(
                padding: const EdgeInsets.all(16.0)
                    .copyWith(bottom: 5, left: 0, top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 13,
                        ),
                        Text(
                          durations,
                          style: appStyles.userNameTextStyle(
                            texColor: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '($invoiceNumber)',
                          style: appStyles.userNameTextStyle(
                            texColor: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.18, // 25% of screen width
                        ),
                        Expanded(
                          child: Checkbox(
                            value: isChecked,
                            onChanged: onCheckboxChanged,
                            checkColor: Colors.white,
                            fillColor:
                            MaterialStateProperty.resolveWith((states) {
                              return isChecked
                                  ? Colors.green
                                  : Colors.transparent;
                            }),
                            side: BorderSide(
                                color: isChecked ? Colors.green : Colors.white),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Text(
                            invoiceAmountLabel,
                            textAlign: TextAlign.end,
                            style: appStyles.amountTextStyle(),
                          ),
                        ),
                        Text(
                          status,
                          style: appStyles.userNameTextStyle(
                            texColor: status == "Fully Paid" ||
                                status == "Partially Paid"
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }

  Widget invoiceList(state) {
    if (addTransactionReceiptBloc.isDisplayFetchInvoiceBtn ||
        addTransactionReceiptBloc.pendingInvoicesData == null ||
        selectedUnit == null) {
      return const SizedBox();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTitleRowWithIcon(title: AppString.invoices,icon: CupertinoIcons.doc_text_fill,),
        const SizedBox(
          height: 5,
        ),
        addTransactionReceiptBloc.pendingInvoicesData != null &&
            addTransactionReceiptBloc.pendingInvoicesData!.isNotEmpty
            ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8),
            itemCount:
            addTransactionReceiptBloc.pendingInvoicesData!.length,
            itemBuilder: (context, index) {
              return pendingInvoices(
                durations: addTransactionReceiptBloc
                    .pendingInvoicesData![index].durations!,
                invoiceNumber: addTransactionReceiptBloc
                    .pendingInvoicesData![index].invoiceNumber!,
                status: addTransactionReceiptBloc
                    .pendingInvoicesData![index].status!,
                isChecked: addTransactionReceiptBloc
                    .pendingInvoicesData![index].isChecked!,
                invoiceAmountLabel: addTransactionReceiptBloc
                    .pendingInvoicesData![index].invoiceAmountLabel!,
                // onCheckboxChanged: (bool? ) {  },
              );
            })
            : addTransactionReceiptBloc.pendingInvoicesData != null &&
            addTransactionReceiptBloc.pendingInvoicesData!.isEmpty
            ? CommonCardView(
            margin: EdgeInsets.only(top: 10),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  AppString.noPendingDues,
                  textAlign: TextAlign.center,
                  style: appStyles.userNameTextStyle(
                    texColor: AppColors.appBlueColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ))
            : const SizedBox(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  bool canDisplaySelectMemberView(){
    if(widget.comeWithPermission![0] ==
        AppString.managerUnitTransactionReceiptUpload || widget.comeWithPermission![0] == AppString.accountPaymentAdd){
      return true;
    }
    return false;
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String input = newValue.text.replaceAll(',', '');
    if (input.contains('.')) {
      List<String> parts = input.split('.');
      String integerPart = parts[0];
      String decimalPart = parts[1];

      if (integerPart.length > 5) {
        integerPart = integerPart.substring(0, 5);
      }
      if (decimalPart.length > 3) {
        decimalPart = decimalPart.substring(0, 3);
      }

      String formatted = _formatNumber(integerPart) + '.' + decimalPart;
      return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } else {
      if (input.length > 5) input = input.substring(0, 5);
      String formatted = _formatNumber(input);
      return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String _formatNumber(String s) {
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if ((s.length - i) % 3 == 0 && i != 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}