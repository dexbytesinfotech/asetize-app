import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:asetize/features/add_transaction_receipt/page/transaction_receipt_detail_screen.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/workplace_icon.dart';
import '../../../imports.dart';
import '../../account_books/pages/member_screen.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import '../bloc/add_transaction_receipt_bloc.dart';
import '../bloc/add_transaction_receipt_event.dart';
import '../bloc/add_transaction_receipt_state.dart';

class AddedTextWithSharedImage extends StatefulWidget {
  final String title;
  final String imagePath;

  const AddedTextWithSharedImage({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<AddedTextWithSharedImage> createState() =>
      _AddedTextWithSharedImageState();
}

class _AddedTextWithSharedImageState extends State<AddedTextWithSharedImage> {
  final TextEditingController _textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late UserProfileBloc userProfileBloc;
  late AddTransactionReceiptBloc addTransactionReceiptBloc;
  late TextRecognizer textRecognizer;
  String? transactionId;
  String? amount;
  String? upiId;
  String? upiTransactionId;
  String? selectPaymentDate = "Select payment date";
  String? googleTransactionId;
  Houses? selectedUnit;
  String recognizedText = '';
  bool isRecognizing = false;
  List<Houses> houses = [];
  bool isSendButtonEnabled = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? date;
  String? time;
  String formattedDate = ""; // Initialize with an empty string
  String formattedTime = ""; // Initialize with an emp
  bool isDisplayOtherOption = false;
  bool isDisplaySelOption = true;
  bool hasOtherOption = false; // Default to No
  List<Houses>? otherMemberHouses = [];
  dynamic selectedUser;

  void _processImage(String imagePath) async {
    projectUtil.printP("Image path Share $imagePath");
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
      // final amountRegex = RegExp(r'');
      final transactionIdRegex = RegExp(r'Transaction ID[:\s]*([A-Za-z0-9]+)');

      // final fallbackAmountRegex = RegExp(r'');
      final upiIdRegex =
      RegExp(r'UPI ID[:\s]+([\w\d\.-]+@[\w\d\.-]+)'); // Updated regex
      final upiTransactionIdRegex = RegExp(r'\b\d{12}\b');
      final googleTransactionIdRegex = RegExp(r'[A-Z]{4}[a-z][A-Za-z0-9]{8,}');
      // Updated regex patterns for date and time
      final dateRegex = RegExp(r'(\d{1,2}\s\w{3}\s\d{4})'); // Matches "25 Apr 2024"
      final timeRegex = RegExp(r'(\d{1,2}:\d{2}\s?[APMapm]{2})'); // Matches "12:17 PM"

      // amount = amountRegex.firstMatch(text)?.group(1);
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


      DateFormat format = DateFormat("dd MMM yyyy");
      try {
        _selectedDate = format.parse(date!);
        print(_selectedDate); // Output: 2024-12-05 00:00:00.000
      } catch (e) {
        print("Error parsing date: $e");
      }

      // Fallback for standalone numeric value
      if (amount == null) {
        for (String line in text.split('\n')) {
          // if (fallbackAmountRegex.hasMatch(line.trim())) {
          //   amount = line.trim();
          //   break;
          // }
        }
      }

      // Update the text controller with the recognized amount
      // Update the text controller with the recognized amount
      if (amount != null) {
        setState(() {
          _textController.text =
          amount!; // Set the recognized amount into the text controller
        });
      } else {
        setState(() {
          _textController.text =
          ""; // Set text to empty string if amount is null
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
      print("Recognized Data:");
      print("Text: $text");
      print("Amount: ${amount ?? ""}");
      print("Transaction ID: ${transactionId ?? ""}");
      print("UPI ID: ${upiId ?? ""}");
      print("UPI Transaction ID: ${upiTransactionId ?? ""}");
      print("Google Transaction ID: ${googleTransactionId ?? ""}");
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



  @override
  void initState() {
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _textController.text = amount.toString();

    addTransactionReceiptBloc =
        BlocProvider.of<AddTransactionReceiptBloc>(context);

    _processImage(widget.imagePath); // Automatically process the image on screen load

    if (userProfileBloc.user.houses != null &&
        userProfileBloc.user.houses!.isNotEmpty) {
      houses = userProfileBloc.user.houses ?? [];
      selectedUnit = userProfileBloc.user.houses![0];
    }
    checkPermission();
    _textController.addListener(() {
      setState(() {
        isSendButtonEnabled = _textController.text.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
    double bottomViewHeight = MediaQuery.of(context).size.height/(isDisplayOtherOption==true?2.6:3.6);

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
          // Update formattedDate when a new date is picked
          formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);
        });
      }
    }

    Widget topCalendarAndTime() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Display Date with Edit Option
          GestureDetector(
            onTap: _pickDate,
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: Color(0xFF464646),
                ),
                const SizedBox(width: 6),
                Text(
                  formattedDate.isNotEmpty && formattedDate != selectPaymentDate ? formattedDate : selectPaymentDate ?? '', // Ensure a default text
                  style:  TextStyle(
                    fontSize: 15,
                    color: formattedDate.isNotEmpty && formattedDate != selectPaymentDate ? const Color(0xFF464646) : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _pickDate,
                  child:  const Icon(
                    Icons.edit,
                    size: 18,
                    color: Color(0xFF707070)
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    List<Widget> actions() {
      return List.generate(otherMemberHouses!.isNotEmpty?otherMemberHouses!.length:houses.length, (index) {
        String? title = otherMemberHouses!.isNotEmpty?otherMemberHouses![index].title:houses[index].title;
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              selectedUnit = otherMemberHouses!.isNotEmpty?otherMemberHouses![index]:houses[index];
            });
          },
          child: Text(
            '$title',
            style: const TextStyle(color: Colors.black),
          ),
        );
      });
    }

    Widget shareImage() {
      return Padding(
        padding:  const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topCalendarAndTime(),
            const SizedBox(height: 15,),
            if (widget.imagePath.isNotEmpty &&
                File(widget.imagePath).existsSync())
              Image.file(
                File(widget.imagePath),
                height: MediaQuery.of(context).size.height - bottomViewHeight,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
              )
            else
              const Text(AppString.noImageSelected),
            const SizedBox(height: 20),
            if (isRecognizing)
              const CircularProgressIndicator()
            else
              // Text(
              //   recognizedText.isNotEmpty
              //       ? recognizedText
              //       : AppString.noTextRecognized,
              //   style: const TextStyle(fontSize: 16),
              // ),

              const SizedBox(),

            // topCalendarAndTime(),
          ],
        ),
      );
    }

    Widget bottomSendTextField() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          uploadForView(),
          Padding(
            padding: const EdgeInsets.all(8.0)
                .copyWith(left: 0, right: 0, bottom: 0,top: 0),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.currency_rupee,
                              color: isSendButtonEnabled
                                  ? AppColors.buttonBgColor3
                                  : Colors.grey,
                              size: 20,
                            )),
                        Expanded(
                          child: TextField(
                              cursorColor: Colors.grey,
                              controller: _textController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                ThousandsSeparatorInputFormatter(),
                              ],
                              decoration:  InputDecoration(
                                hintText: AppString.typeAmountHint,
                                hintStyle: appTextStyle.appLargeTitleStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Arial',
                                ) ,
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                              ),
                              style: appTextStyle.appLargeTitleStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial',
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (houses.length > 1 || (otherMemberHouses!.isNotEmpty && otherMemberHouses!.length > 1)) {
                        showCupertinoModalPopup(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              title: const Text(
                                AppString.selectUnit,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black87),
                              ),
                              actions: actions(),
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
                    },
                    child: Row(
                      children: [
                        const Icon(
                          size: 18,
                          Icons.apartment,
                          color: AppColors.textBlueColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          selectedUnit?.title ?? AppString.selectUnit,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                        if (houses.length > 1 || (otherMemberHouses!.isNotEmpty && otherMemberHouses!.length > 1))
                          const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textBlueColor,
                            size: 34,
                          )
                        else
                          const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 75,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSendButtonEnabled && selectedUnit!=null
                          ? Colors.blue
                          : Colors.grey, // Background color
                      borderRadius: BorderRadius.circular(
                          14), // Circular border radius of 10
                    ),
                    child: TextButton(

                      onPressed: isSendButtonEnabled && selectedUnit != null                     ? () {
                        // String selectedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
                        // String selectedTime = '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'; // Format time as HH:mm
                        if (formattedDate == selectPaymentDate) {
                          // Show Snackbar if date is not selected

                          WorkplaceWidgets.errorSnackBar(context, "Please select the payment date");
                          return; // Exit the function early
                        }
                        try {
                          formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
                          formattedTime = projectUtil.convertTo24HourFormat('${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}');
                          addTransactionReceiptBloc.add(
                            SubmitTransactionReceipt(
                              houseId: selectedUnit?.id ?? 0,
                              amount:
                              _textController.text.replaceAll(',', ''),
                              filePath: widget.imagePath,
                              comments: '',
                              paymentMethod: 'Online',
                              mContext: context,
                              transactionDate: formattedDate, // Use recognized date
                              transactionTime: formattedTime,isForSelf: true/*otherMemberHouses!.isEmpty && houses.isNotEmpty*/,
                            ),
                          );
                          closeKeyboard();
                        } catch (e) {
                          print(e);
                        }
}
                          : null,
                      child: const Text(
                        AppString.sendButton,
                        style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),

                  //
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.send,
                  //     color: isSendButtonEnabled ? Colors.blue : Colors.grey,
                  //     size: 25,
                  //   ),
                  //   onPressed: isSendButtonEnabled
                  //       ? () {
                  //     addTransactionReceiptBloc.add(
                  //       SubmitTransactionReceipt(
                  //         houseId: selectedUnit?.id ?? 0,
                  //         amount: _textController.text.replaceAll(',', ''),
                  //         filePath: widget.imagePath,
                  //         comments: '',
                  //         paymentMethod: 'Online',
                  //         mContext: context,
                  //       ),
                  //     );
                  //     closeKeyboard();
                  //   }
                  //       : null,
                  // ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.sharedTransactionReceipt,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild:
          BlocListener<AddTransactionReceiptBloc, AddTransactionReceiptState>(
        bloc: addTransactionReceiptBloc,
        listener: (context, state) {
          if (state is AddTransactionReceiptErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.message);
          } else if (state is TransactionReceiptSubmitSuccessState) {
            /// Redirect ot home screen
            if(otherMemberHouses!.isNotEmpty){
              Navigator.pop(context);
            }
            else {
              Navigator.pushReplacement(
                context,
                SlideLeftRoute(
                  widget:  const TransactionReceiptDetailScreen(),
                ),
              );
            }

            WorkplaceWidgets.successToast(AppString.receiptsUploadedSuccessfully,durationInSeconds: 1);
          }
        },
        child:
            BlocBuilder<AddTransactionReceiptBloc, AddTransactionReceiptState>(
          bloc: addTransactionReceiptBloc,
          builder: (context, state) {
            return Stack(
              children: [
                shareImage(),
                if (state is AddTransactionReceiptLoadingState)
                  Center(
                    child: WorkplaceWidgets.progressLoader(context),
                  ),
              ],
            );
          },
        ),
      ),
      bottomMenuView: bottomSendTextField(),
    );
  }

  Future<void> checkPermission() async {
    /// Will display Other option
    if(AppPermission.instance
        .canPermission(AppString.managerUnitTransactionReceiptUpload, context: context) && AppPermission.instance
        .canPermission(AppString.unitTransactionReceiptUpload, context: context)){
      selectedUnit = userProfileBloc.selectedUnit;
      isDisplayOtherOption = true;
      isDisplaySelOption = true;
    }
    /// User
    else if(AppPermission.instance
        .canPermission(AppString.unitTransactionReceiptUpload, context: context)){
      isDisplaySelOption = true;
      isDisplayOtherOption = false;
      selectedUnit = userProfileBloc.selectedUnit;
    }    /// Will display Other option
    else if(AppPermission.instance
        .canPermission(AppString.managerUnitTransactionReceiptUpload, context: context)){
      isDisplayOtherOption = true;
      isDisplaySelOption = false;
      houses = [] ;
      selectedUnit = null;
    }
    /// Work for all Single permission user
    else {
      isDisplayOtherOption = false;
      isDisplaySelOption = false;
      houses = [];
      selectedUnit = null;
    }

  }

  Widget uploadForView() {
    if(isDisplayOtherOption && isDisplaySelOption){
      return Container(color: Colors.grey.shade300,height: 50,
        child: Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text("Self"),
                value: false,
                activeColor: AppColors.appBlueColor, // Set selected radio color to blue

                groupValue: hasOtherOption,
                onChanged: (value) {
                  setState(() {
                    hasOtherOption = value!;
                    otherMemberHouses = [];
                    if(houses.isNotEmpty){
                      selectedUnit = houses[0];
                    }
                    else{
                      selectedUnit = null;
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text("Other"),
                value: true,
                activeColor: AppColors.appBlueColor,
                groupValue: hasOtherOption,
                onChanged: (value) {
                  Navigator.push(context,
                      SlideLeftRoute(widget: const MemberScreen()))
                      .then((user) {
                    print(user);
                    setState(() {
                      hasOtherOption = value!;
                      otherMemberHouses = [];
                      if (user.houses != null || user.houses?.isNotEmpty == true) {
                        otherMemberHouses = List.generate(user.houses?.length ?? 0, (index) {
                          return Houses(id: user.houses?[index].id,title: user.houses?[index].title);
                        });
                        selectedUnit = otherMemberHouses![0];
                        print("$otherMemberHouses");
                      }
                    });
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    else if(isDisplayOtherOption){
      return Container(color: Colors.grey.shade300,height: 50,
        child: InkWell(onTap: (){
          Navigator.push(context,
              SlideLeftRoute(widget:  const MemberScreen()))
              .then((user) {
            print(user);
            setState(() {
              selectedUser = user;
              otherMemberHouses = [];
              if (user.houses != null || user.houses?.isNotEmpty == true) {
                otherMemberHouses = List.generate(user.houses?.length ?? 0, (index) {
                  return Houses(id: user.houses?[index].id,title: user.houses?[index].title);
                });
                selectedUnit = otherMemberHouses![0];
                print("$otherMemberHouses");
              }
            });
          });
        },
          child: Row(
            children: [
              const SizedBox(width: 10),
              const Icon(
                Icons.account_box,
                size: 20,
                color: Color(0xFF464646),
              ),
              const SizedBox(width: 10),
              Text(selectedUnit==null || selectedUser==null?"Select Member":"${selectedUser?.name??"Select Member"} ", // Ensure a default text
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF464646),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(selectedUnit==null || selectedUser==null?"":selectedUser?.name!=null?" (Change Member)":"", // Ensure a default text
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    else if(isDisplaySelOption){
      return const SizedBox();
    }
    return Container(color: Colors.grey.shade300,height: 50,
      child: const Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You don't have receipt share permission!", // Ensure a default text
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(',', '');

    if (newText.length > 5) {
      newText = newText.substring(0, 5);
    }

    String formatted = _formatNumber(newText);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatNumber(String s) {
    return s.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
  }
}
// when date is not reconize then where the date is showing where show the please select the date dont show current date when date is not reconize and when user selecet the
// date then on the this text please select the date show the selected date and if date is not reconize and if user click on submit button then show the error that is please
// select the date