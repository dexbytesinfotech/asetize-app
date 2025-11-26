// // File: team_member_details/member_header.dart
// import 'package:flutter/cupertino.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:intl/intl.dart';
// import 'package:share_handler/share_handler.dart';
// import 'package:asetize/features/account_books/bloc/account_book_bloc.dart';
// import 'package:asetize/features/add_transaction_receipt/page/transaction_receipt_detail_screen.dart';
// import '../../../core/util/app_permission.dart';
// import '../../../core/util/app_theme/text_style.dart';
// import '../../../imports.dart';
// import '../../account_books/pages/member_screen.dart';
// import '../bloc/add_transaction_receipt_bloc.dart';
// import '../bloc/add_transaction_receipt_event.dart';
// import '../bloc/add_transaction_receipt_state.dart';
//
// class AddNewTransactionReceipt extends StatefulWidget {
//   final SharedMedia? media;
//   final String? imagePath;
//   final String? shareImagePath;
//
//   final String? amount;
//   final String? receiptNo;
//   final String? title;
//   final String? partyName;
//
//   const AddNewTransactionReceipt(
//       {super.key,
//       this.media,
//       this.amount,
//       this.imagePath,
//       this.receiptNo,
//       this.title,
//       this.partyName,
//       this.shareImagePath});
//
//   @override
//   State<AddNewTransactionReceipt> createState() =>
//       _AddNewTransactionReceiptState();
// }
//
// class _AddNewTransactionReceiptState extends State<AddNewTransactionReceipt> {
//
//
//   final Map<String, TextEditingController> controllers = {
//     'amount': TextEditingController(),
//     'selectUnit': TextEditingController(),
//     'remark': TextEditingController(),
//     'party': TextEditingController(),
//     'paymentMethod': TextEditingController(),
//   };
//   final Map<String, FocusNode> focusNodes = {
//     'amount': FocusNode(),
//     'selectUnit': FocusNode(),
//     'remark': FocusNode(),
//     'party': FocusNode(),
//     'paymentMethod': FocusNode(),
//   };
//   final Map<String, String> errorMessages = {
//     'amount': "",
//     'selectUnit': "",
//     'remark': "",
//     'party': "",
//     'paymentMethod': "",
//   };
//   TextRecognizer textRecognizer = TextRecognizer();
//   String? transactionId;
//   String? amount;
//   String? upiId;
//   String? upiTransactionId;
//   String? googleTransactionId;
//
//   String imageErrorMessage = '';
//   File? selectedProfilePhoto;
//   int? selectedHouseId;
//   bool _showNextSection = false;
//
//   String? selectedProfilePhotoPath;
//   bool isVerifyButtonEnabled = false;
//   bool isDisplayingInvoice = true;
//   List<Houses>? housesData;
//   List<int> houseId = [];
//   String? selectedHouseTitle;
//   late AccountBookBloc accountBookBloc;
//   String recognizedText = '';
//   bool isRecognizing = false;
//   String? selectedPaymentMethod;
//
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay.now();
//   String? date;
//   String? time;
//   String formattedDate = ""; // Initialize with an empty string
//   String formattedTime = ""; // Initialize with an emp
//   double? fetchedAmount;
//
//   // String? selectProfilePhotoPath;
//   List<String> houseList = [];
//   Map<String, File>? imageFile;
//   Map<String, String>? imagePath;
//   bool isImageSelected = false;
//   late UserProfileBloc userProfileBloc;
//   Houses? selectedUnit;
//   List<Houses> houses = [];
//   late AddTransactionReceiptBloc addTransactionReceiptBloc;
//
//   @override
//   void initState() {
//
//     _processImage(widget.shareImagePath ?? '');
//
//
//     if (widget.shareImagePath != null && widget.shareImagePath!.isNotEmpty) {
//       selectedProfilePhoto = File(widget.shareImagePath!);
//       selectedProfilePhotoPath = widget.shareImagePath;
//       isImageSelected = true;
//     }
//     super.initState();
//
//     addTransactionReceiptBloc =
//         BlocProvider.of<AddTransactionReceiptBloc>(context);
//     // Automatically process the image on screen load
//
//     if (widget.amount != null) {
//       controllers['amount']?.text = widget.amount ?? '';
//       fetchedAmount = widget.amount !=null ? double.parse(widget.amount!):0.0;
//     }
//     userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
//     if (widget.partyName != null) {
//       controllers['party']?.text = widget.partyName ?? '';
//     }
//
//     if (userProfileBloc.user.houses != null &&
//         userProfileBloc.user.houses!.isNotEmpty) {
//       houses = userProfileBloc.user.houses ?? [];
//       // selectedUnit = userProfileBloc.user.houses![0];
//       // controllers['selectUnit']?.text = selectedUnit?.title ?? '';
//       // Set default unit
//     }
//
//     selectedUnit = userProfileBloc.selectedUnit;
//     controllers['selectUnit']?.text = userProfileBloc.selectedUnit?.title ?? "";
//
//     if (widget.imagePath?.isNotEmpty == true) {
//       File imageFileTemp = File(widget.imagePath ?? '');
//       selectedProfilePhoto = imageFileTemp;
//       selectedProfilePhotoPath = selectedProfilePhoto!.path;
//     }
//     addTransactionReceiptBloc.pendingInvoicesData!.clear();
//   }
//
//   void photoPickerBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context1) => PhotoPickerBottomSheet(
//         isRemoveOptionNeeded: false,
//         removedImageCallBack: () {
//           Navigator.pop(context1);
//           setState(() {
//             selectedProfilePhotoPath = "";
//             isImageSelected = false;
//           });
//         },
//         selectedImageCallBack: (fileList) {
//           try {
//             if (fileList != null && fileList.isNotEmpty) {
//               fileList.map((fileDataTemp) {
//                 File imageFileTemp = File(fileDataTemp.path);
//                 selectedProfilePhoto = imageFileTemp;
//                 selectedProfilePhotoPath = selectedProfilePhoto!.path;
//                 isImageSelected = true;
//                 imageFile = <String, File>{};
//                 imagePath = <String, String>{};
//                 imageErrorMessage = '';
//                 String mapKey =
//                     DateTime.now().microsecondsSinceEpoch.toString();
//                 imageFile![mapKey] = imageFileTemp;
//                 imagePath![mapKey] = imageFileTemp.path;
//               }).toList(growable: false);
//               setState(() {});
//             }
//           } catch (e) {
//             debugPrint('$e');
//           }
//           Navigator.pop(context1);
//         },
//         selectedCameraImageCallBack: (fileList) {
//           try {
//             if (fileList != null && fileList.path!.isNotEmpty) {
//               File imageFileTemp = File(fileList.path!);
//               selectedProfilePhoto = imageFileTemp;
//               selectedProfilePhotoPath = selectedProfilePhoto!.path;
//               isImageSelected = true;
//               imageFile = {};
//               imagePath = {};
//               imageErrorMessage = '';
//               String mapKey = DateTime.now().microsecondsSinceEpoch.toString();
//               imageFile![mapKey] = imageFileTemp;
//               imagePath![mapKey] = imageFileTemp.path;
//               setState(() {});
//             }
//           } catch (e) {
//             debugPrint('$e');
//           }
//           Navigator.pop(context1);
//         },
//       ),
//       isScrollControlled: false,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//             top: Radius.circular(photoPickerBottomSheetCardRadius)),
//       ),
//     );
//   }
//
//   void _removeImage() {
//     setState(() {
//       selectedProfilePhoto = null;
//       isImageSelected = false;
//     });
//   }
//
//   Future<void> _pickDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData().copyWith(
//             colorScheme: const ColorScheme.dark(
//               primary: AppColors.textBlueColor,
//               onSurface: Colors.black,
//               onPrimary: Colors.white,
//               surface: AppColors.white,
//               brightness: Brightness.light,
//             ),
//             dialogBackgroundColor: AppColors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         // Update formattedDate when a new date is picked
//         formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);
//       });
//     }
//   }
//
//   Future<void> _pickTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//     );
//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//         // Update formattedTime when a new time is picked
//         formattedTime = '${_selectedTime.hour % 12}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.hour >= 12 ? 'PM' : 'AM'}';
//       });
//     }
//   }
//   Widget topCalendarAndTime() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Display Date with Edit Option
//         GestureDetector(
//           onTap: _pickDate,
//           child: Row(
//             children: [
//               const Icon(
//                 Icons.calendar_month,
//                 size: 20,
//                 color: Color(0xFF464646),
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 formattedDate.isNotEmpty ? formattedDate : DateFormat('dd MMM yyyy').format(_selectedDate), // Use current date if formattedDate is empty
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF464646),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(width: 6),
//               GestureDetector(
//                 onTap: _pickDate,
//                 child: const Icon(
//                   Icons.edit,
//                   size: 18,
//                   color: Color(0xFF707070),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         // Display Time with Edit Option
//         GestureDetector(
//           onTap: _pickTime,
//           child: Row(
//             children: [
//               const Icon(
//                 Icons.access_time,
//                 size: 20,
//                 color: Color(0xFF464646),
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 formattedTime.isNotEmpty ? formattedTime : '${_selectedTime.hour % 12}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.hour >= 12 ? 'PM' : 'AM'}', // Use current time if formattedTime is empty
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF464646),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(width: 6),
//               GestureDetector(
//                 onTap: _pickTime,
//                 child: const Icon(
//                   Icons.edit,
//                   size: 18,
//                   color: Color(0xFF707070),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // // Format date
//   // String get formattedDate => DateFormat('d MMM, yyyy').format(_selectedDate);
//   // // Format time
//   // String get formattedTime => _selectedTime.format(context);
//
//   bool validateFields({isButtonClicked = false}) {
//     if (controllers['amount']?.text == null ||
//         controllers['amount']?.text == '') {
//       setState(() {
//         if (isButtonClicked) {
//           FocusScope.of(context).requestFocus(focusNodes['amount']);
//           errorMessages['amount'] = AppString.errorForEnterAmount;
//         }
//       });
//       return false;
//     } else if (!Validation.isNotEmpty(controllers['amount']?.text ?? '')) {
//       setState(() {
//         if (isButtonClicked) {
//           FocusScope.of(context).requestFocus(focusNodes['amount']);
//           errorMessages['amount'] = AppString.enterValidAddress;
//         }
//       });
//       return false;
//     }
//
//     if (selectedPaymentMethod == 'Online' ){
//       if (!isImageSelected && selectedProfilePhoto == null) {
//         setState(() {
//           if (isButtonClicked) {
//             imageErrorMessage = AppString.errorMessageUploadReceipt;
//           }
//         });
//         return false;
//       } else {
//         setState(() {
//           imageErrorMessage = '';
//         });
//         return true;
//       }
//     } else {
//       // Offline payment ke case me validation skip karna hai
//       return true;
//     }
//
//   }
//
//   void _clearReceiptData() {
//     setState(() {
//       // selectedProfilePhoto = null;
//       // selectedProfilePhotoPath = null;
//       isImageSelected = false;
//       imageErrorMessage = '';
//       imageFile = null;
//       imagePath = null;
//       controllers['remark']?.clear();
//       isVerifyButtonEnabled = false;
//       addTransactionReceiptBloc.pendingInvoicesData!.clear();
//     });
//   }
//
//   void _onUnitSelected(int index) {
//     setState(() {
//       selectedUnit = houses[index];
//       controllers['selectUnit']?.text = houses[index].title!;
//       errorMessages['selectUnit'] = "";
//       _clearReceiptData();
//
//       // controllers['amount']?.clear(); // Clear the amount field
//     });
//   }
//
//
//
//   void _processImage(String imagePath) async {
//     if (!File(imagePath).existsSync()) {
//       setState(() {
//         recognizedText = AppString.invalidImagePath;
//       });
//       return;
//     }
//
//     setState(() {
//       isRecognizing = true;
//     });
//     try {
//       final inputImage = InputImage.fromFilePath(imagePath);
//       final RecognizedText recognisedText =
//       await textRecognizer.processImage(inputImage);
//
//       String text = "";
//       for (TextBlock block in recognisedText.blocks) {
//         for (TextLine line in block.lines) {
//           text += "${line.text}\n";
//         }
//       }
//
//       // Define regex patterns
//       final amountRegex = RegExp(r'₹\s*([\d,]+\.?\d*)');
//       final transactionIdRegex = RegExp(r'Transaction ID[:\s]*([A-Za-z0-9]+)');
//
//       final fallbackAmountRegex = RegExp(r'^\s*([\d,]+\.?\d*)\s*$');
//       final upiIdRegex =
//       RegExp(r'UPI ID[:\s]+([\w\d\.-]+@[\w\d\.-]+)'); // Updated regex
//       final upiTransactionIdRegex = RegExp(r'\b\d{12}\b');
//       final googleTransactionIdRegex = RegExp(r'[A-Z]{4}[a-z][A-Za-z0-9]{8,}');
//       // Updated regex patterns for date and time
//       final dateRegex = RegExp(r'(\d{1,2}\s\w{3}\s\d{4})'); // Matches "25 Apr 2024"
//       final timeRegex = RegExp(r'(\d{1,2}:\d{2}\s?[APMapm]{2})'); // Matches "12:17 PM"
//
//       amount = amountRegex.firstMatch(text)?.group(1);
//       transactionId = transactionIdRegex.firstMatch(text)?.group(1);
//       upiId = upiIdRegex.firstMatch(text)?.group(1);
//       upiTransactionId = upiTransactionIdRegex.firstMatch(text)?.group(0);
//       googleTransactionId = googleTransactionIdRegex.firstMatch(text)?.group(0);
//       date = dateRegex.firstMatch(text)?.group(1);
//       time = timeRegex.firstMatch(text)?.group(1);
//
//       // If date or time is not recognized, set to current date and time
//       if (date == null || time == null) {
//         final now = DateTime.now();
//         date = "${now.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][now.month - 1]} ${now.year}";
//         time = "${now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'pm' : 'am'}";
//       } else {
//         // Set formattedDate and formattedTime to recognized values
//         formattedDate = date!;
//         formattedTime = time!;
//       }
//
//      DateFormat format = DateFormat("dd MMM yyyy");
//       try {
//         _selectedDate = format.parse(date!);
//         print(_selectedDate); // Output: 2024-12-05 00:00:00.000
//       } catch (e) {
//         print("Error parsing date: $e");
//       }
//
//
//       // try {
//       //   format = DateFormat("dd MMM yyyy");
//       //   _selectedTime = format.parse(time!);
//       //   print(_selectedDate); // Output: 2024-12-05 00:00:00.000
//       // } catch (e) {
//       //   print("Error parsing date: $e");
//       // }
//
//       // Fallback for standalone numeric value
//       if (amount == null) {
//         for (String line in text.split('\n')) {
//           if (fallbackAmountRegex.hasMatch(line.trim())) {
//             amount = line.trim();
//             break;
//           }
//         }
//       }
//       // Update the text controller with the recognized amount
//       // Update the text controller with the recognized amount
//       if (amount != null) {
//         setState(() {
//           controllers['amount']?.text =
//           amount!; // Set the recognized amount into the text controller
//           fetchedAmount = amount !=null ? double.parse(amount!):0.0;
//         });
//         callFetchInvoiceApi();
//       } else {
//         setState(() {
//           controllers['amount']?.text =
//           ""; // Set text to empty string if amount is null
//           fetchedAmount = 0.0;
//         });
//       }
//
//
//       if(fetchedAmount! <=0 ){
//         isDisplayingInvoice = false;
//       }
//       // Build the result and update the UI
//       String result = '';
//       result += 'Amount: ${amount ?? ""}\n';
//       result += 'Transaction ID: ${transactionId ?? ""}\n';
//       result += 'UPI ID: ${upiId ?? ""}\n';
//       result += 'UPI Transaction ID: ${upiTransactionId ?? ""}\n';
//       result += 'Google Transaction ID: ${googleTransactionId ?? ""}\n';
//       result += 'Date: ${date ?? ""}\n'; // Add recognized date
//       result += 'Time: ${time ?? ""}\n'; // Add recognized time
//
//
//       if (result.isEmpty) {
//         result = AppString.errorMessageNoDataFound;
//       }
//
//       setState(() {
//         recognizedText = result;
//         formattedDate = date!;
//         formattedTime = time!;
//       });
//       print("Recognized Data:");
//       print("Text: $text");
//       print("Amount: ${amount ?? ""}");
//       print("Transaction ID: ${transactionId ?? ""}");
//       print("UPI ID: ${upiId ?? ""}");
//       print("UPI Transaction ID: ${upiTransactionId ?? ""}");
//       print("Google Transaction ID: ${googleTransactionId ?? ""}");
//     } catch (e) {
//       setState(() {
//         recognizedText = 'Error recognizing text: $e';
//       });
//     } finally {
//       setState(() {
//         isRecognizing = false;
//       });
//     }
//   }
//
//   List<Widget> actions() {
//     return List.generate(
//       houses.length,
//       (index) {
//         return CupertinoActionSheetAction(
//           onPressed: () {
//             Navigator.of(context).pop();
//             _onUnitSelected(index); // Use the new method
//           },
//           child: Text(
//             '${houses[index].title}',
//             style: const TextStyle(color: Colors.black),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//      void checkSelectedUnitNumber(String value, String fieldEmail,
//         {bool onchange = false}) {
//       if (Validation.isNotEmpty(value.trim())) {
//         setState(() {
//           errorMessages[fieldEmail] = "";
//         });
//       } else {
//         setState(() {
//           if (!onchange) {
//             errorMessages[fieldEmail] =
//                 AppString.trans(context, AppString.emailHintError);
//           }
//         });
//       }
//     }
//
//     Widget amountField() {
//       return Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CommonTextFieldWithError(
//               inputFormatter: [
//                 ThousandsSeparatorInputFormatter(), // Use the custom formatter
//               ],
//               inputKeyboardType:
//                   InputKeyboardTypeWithError.number, // Ensure correct type
//               focusNode: focusNodes['amount'],
//               isShowBottomErrorMsg: true,
//               errorMessages: errorMessages['amount']?.toString() ?? '',
//               controllerT: controllers['amount'],
//               borderRadius: 8,
//               inputHeight: 50,
//               errorLeftRightMargin: 0,
//
//               maxCharLength: 500,
//               errorMsgHeight: 18,
//               maxLines: 1,
//               autoFocus: false,
//               showError: true,
//               showCounterText: false,
//               displayKeyBordDone: false,
//               capitalization: CapitalizationText.sentences,
//               cursorColor: Colors.grey,
//               enabledBorderColor: Colors.white,
//               focusedBorderColor: Colors.white,
//               backgroundColor: AppColors.white,
//               textInputAction: TextInputAction.newline,
//               borderStyle: BorderStyle.solid,
//               hintText: AppString.amountHint,
//               placeHolderTextWidget: Padding(
//                 padding: const EdgeInsets.only(left: 3.0, bottom: 3),
//                 child: Text.rich(
//                   TextSpan(
//                     text: AppString.amountHint,
//                     style: appStyles.texFieldPlaceHolderStyle(),
//                     children: [
//                       TextSpan(
//                         text: '*',
//                         style: appStyles
//                             .texFieldPlaceHolderStyle()
//                             .copyWith(color: Colors.red),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.start,
//                 ),
//               ),
//               hintStyle: appStyles.textFieldTextStyle(
//                 fontWeight: FontWeight.w400,
//                 texColor: Colors.grey.shade600,
//                 fontSize: 14,
//               ),
//               textStyle: appTextStyle.appLargeTitleStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Arial',
//               ),
//               contentPadding: const EdgeInsets.only(
//                   left: 15, right: 15, top: 10, bottom: 10),
//               onTextChange: (value) {
//                 if(value==null || value!.toString().isEmpty || double.parse("$value")<=0){
//                   setState(() {
//                     isVerifyButtonEnabled = false; // Disable verify button when text changes
//                     isDisplayingInvoice =  false;
//                   });
//                   return;
//                 }
//
//       setState(() {
//                 if(value!=null && double.parse("$value")>0 && double.parse("$value")!=fetchedAmount){
//                   isVerifyButtonEnabled = true; // Disable verify button when text changes
//                   isDisplayingInvoice =  false;
//                 }
//                 else
//                 {
//                   isVerifyButtonEnabled = false; // Disable verify button when text changes
//                   isDisplayingInvoice = true;
//                 }
//       });
//
//               },
//               onEndEditing: (value) {},
//
//               onTapCallBack: () {
//                 // _clearReceiptData();
//                 // setState(() {
//                 //   isVerifyButtonEnabled =
//                 //       false; // Hide next section when amount changes
//                 //   addTransactionReceiptBloc.pendingInvoicesData
//                 //       .clear(); // Clear pending invoices
//                 // });
//               },
//             ),
//           ],
//         ),
//       );
//     }
//
//     checkParty(value, fieldEmail, {onchange = false}) {
//       if (Validation.isNotEmpty(value.trim())) {
//         setState(() {
//           if (Validation.isNotEmpty(value.trim())) {
//             errorMessages[fieldEmail] = "";
//           } else {
//             if (!onchange) {
//               errorMessages[fieldEmail] =
//                   AppString.trans(context, AppString.emailHintError1);
//             }
//           }
//         });
//       } else {
//         setState(() {
//           if (!onchange) {
//             if (fieldEmail == 'party') {
//               errorMessages[fieldEmail] =
//                   AppString.trans(context, AppString.emailHintError);
//             }
//           }
//         });
//       }
//     }
//
//     checkPaymentMethod(String value, {bool onchange = false}) {
//       if (Validation.isNotEmpty(value.trim())) {
//         setState(() {
//           errorMessages['paymentMethod'] = "";
//         });
//       } else {
//         setState(() {
//           if (!onchange) {
//             errorMessages['paymentMethod'] = AppString.paymentMethod;
//           }
//         });
//       }
//     }
//
//     void showHouseSelectionSheet() {
//       if (housesData != null && housesData!.length > 1) {
//         showCupertinoModalPopup(
//           context: context,
//           builder: (BuildContext context1) {
//             return CupertinoActionSheet(
//               title: const Text(
//                 AppString.selectHouse,
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87),
//               ),
//               actions: housesData!
//                   .map((house) => CupertinoActionSheetAction(
//                         onPressed: () {
//                           setState(() {
//                             _clearReceiptData();
//                             _showNextSection = false;
//                             selectedHouseId =
//                                 house.id; // Assuming Houses has an 'id' field
//                             selectedHouseTitle = house
//                                 .title; // Assuming Houses has a 'title' field
//                           });
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           house.title ?? '',
//                           style: TextStyle(
//                             color: house.title == selectedHouseTitle
//                                 ? AppColors.textBlueColor
//                                 : Colors.black,
//                             fontWeight: house.title == selectedHouseTitle
//                                 ? FontWeight.w600
//                                 : FontWeight.normal,
//                           ),
//                         ),
//                       ))
//                   .toList(),
//               cancelButton: CupertinoActionSheetAction(
//                 onPressed: () => Navigator.pop(context1),
//                 child: const Text(
//                   AppString.cancel,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     }
//
//     memberField() {
//       return CommonTextFieldWithError(
//         onTapCallBack: () {
//           _clearReceiptData();
//           Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const MemberScreen()))
//               .then((value) {
//             print(value);
//             controllers['party']?.text = value.name.toString() ?? '';
//             checkParty(value.name.toString(), 'party', onchange: true);
//
//             if (widget.title != 'Online Details') {
//               User user = value;
//               housesData = user.houses;
//               if (user.houses != null || user.houses?.isNotEmpty == true) {
//                 houseList = List.generate(user.houses?.length ?? 0, (index) {
//                   return user.houses?[index].title ?? '';
//                 });
//
//                 houseId = List.generate(user.houses?.length ?? 0, (index) {
//                   return user.houses?[index].id ?? 0;
//                 });
//
//                 selectedHouseId = houseId.first;
//                 selectedHouseTitle = houseList.first;
//               }
//             }
//           });
//           setState(() {
//             _showNextSection =
//                 false; // Hide next section when amount changes// Assuming Houses has a 'title' field
//           });
//         },
//         readOnly: true,
//         focusNode: focusNodes['party'],
//         isShowBottomErrorMsg: true,
//         errorMessages: errorMessages['party']?.toString() ?? '',
//         controllerT: controllers['party'],
//         borderRadius: 8,
//         inputHeight: 45,
//         errorLeftRightMargin: 0,
//         maxCharLength: 500,
//         errorMsgHeight: 18,
//         maxLines: 1,
//         autoFocus: false,
//         showError: true,
//         showCounterText: false,
//         capitalization: CapitalizationText.sentences,
//         cursorColor: Colors.grey,
//         enabledBorderColor: Colors.white,
//         focusedBorderColor: Colors.white,
//         backgroundColor: AppColors.white,
//         textInputAction: TextInputAction.newline,
//         borderStyle: BorderStyle.solid,
//         inputKeyboardType: InputKeyboardTypeWithError.multiLine,
//         placeHolderTextWidget: Padding(
//           padding: const EdgeInsets.only(left: 3.0, bottom: 3),
//           child: Text.rich(
//             TextSpan(
//               text: AppString.nameCapital,
//               style: appStyles.texFieldPlaceHolderStyle(),
//               children: [
//                 TextSpan(
//                   text: '*',
//                   style: appStyles
//                       .texFieldPlaceHolderStyle()
//                       .copyWith(color: Colors.red),
//                 ),
//               ],
//             ),
//             textAlign: TextAlign.start,
//           ),
//         ),
//         hintText: AppString.partyHint,
//         // labelText: 'Owner',
//         // labelStyle: const TextStyle(
//         //     fontWeight: FontWeight.w500, color: AppColors.black),
//         hintStyle: appStyles.textFieldTextStyle(
//             fontWeight: FontWeight.w400,
//             texColor: Colors.grey.shade600,
//             fontSize: 14),
//         textStyle: appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
//         contentPadding:
//             const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
//
//         onTextChange: (value) {
//           checkParty(value, 'party', onchange: true);
//         },
//         onEndEditing: (value) {
//           checkParty(value, 'party');
//           FocusScope.of(context).requestFocus(focusNodes['']);
//         },
//       );
//     }
//
//     Widget buildHouseSelector() {
//       bool isSingleHouse = housesData != null && housesData!.length == 1;
//
//       // Automatically select the house if there's only one
//       // if (isSingleHouse && selectedHouseTitle == null) {
//       //   final singleHouse = housesData!.first;
//       //   selectedHouseId = singleHouse.id;
//       //   selectedHouseTitle = singleHouse.title;
//       //
//       // }
//       if(userProfileBloc.selectedUnit != null )
//
//         {
//           selectedHouseId = userProfileBloc.selectedUnit?.id;
//           selectedHouseTitle = userProfileBloc.selectedUnit?.title;
//         }
//
//       return Container(
//         width: double.infinity,
//         margin: const EdgeInsets.only(bottom: 20, top: 5),
//         child: CupertinoButton(
//           padding: EdgeInsets.zero,
//           onPressed: isSingleHouse ? null : showHouseSelectionSheet,
//           child: Container(
//             height: 45,
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             decoration: BoxDecoration(
//                 color: AppColors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 3,
//                       offset: const Offset(0, 1),
//                       blurRadius: 3)
//                 ]),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   selectedHouseTitle ?? AppString.selectUnit,
//                   style: TextStyle(
//                     color: selectedHouseTitle != null
//                         ? Colors.black
//                         : Colors.grey.shade600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 if (!isSingleHouse)
//                   Icon(
//                     CupertinoIcons.chevron_down,
//                     size: 16,
//                     color: Colors.grey.shade600,
//                   )
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//
//     Widget selectUnit() {
//       return Container(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CommonTextFieldWithError(
//               onTapCallBack: () {
//                 _clearReceiptData();
//
//                 if (houses.length > 1) {
//                   // Check if there is more than one house
//                   showCupertinoModalPopup(
//                     barrierDismissible: false,
//                     context: context,
//                     builder: (context) {
//                       return CupertinoActionSheet(
//                         title: const Text(
//                           AppString.selectUnit,
//                           style: TextStyle(fontSize: 18, color: Colors.black87),
//                         ),
//                         actions: actions(),
//                         cancelButton: CupertinoActionSheetAction(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text(
//                             AppString.cancel,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 } else if (houses.length == 1) {
//                   // If there is only one house, select it directly
//                   _onUnitSelected(0); // Or handle it differently as needed
//                 } else {
//                   print(AppString.noHousesAvailable);
//                 }
//               },
//               inputFormatter: [
//                 FilteringTextInputFormatter.allow(
//                   RegExp(r'^\d*\.?\d*$'),
//                 ),
//               ],
//               inputKeyboardType: InputKeyboardTypeWithError.number,
//               focusNode: focusNodes['selectUnit'],
//               isShowBottomErrorMsg: true,
//               displayKeyBordDone: false,
//               errorMessages: errorMessages['selectUnit']?.toString() ?? '',
//               controllerT: controllers['selectUnit'],
//               borderRadius: 8,
//               inputHeight: 50,
//               errorLeftRightMargin: 0,
//               maxCharLength: 500,
//               errorMsgHeight: 18,
//               maxLines: 1,
//               autoFocus: false,
//               readOnly: true,
//               showError: true,
//               showCounterText: false,
//               capitalization: CapitalizationText.sentences,
//               cursorColor: Colors.grey,
//               enabledBorderColor: Colors.white,
//               focusedBorderColor: Colors.white,
//               backgroundColor: AppColors.white,
//               textInputAction: TextInputAction.newline,
//               borderStyle: BorderStyle.solid,
//               inputFieldSuffixIcon: houses.length > 1 ?   Icon(
//                 CupertinoIcons.chevron_down,
//                 size: 16,
//                 color: Colors.grey.shade600,
//               ): const SizedBox(),
//               hintText: AppString.selectUnitNumberHint,
//               placeHolderTextWidget: Padding(
//                 padding: const EdgeInsets.only(left: 3.0, bottom: 3),
//                 child: Text.rich(
//                   TextSpan(
//                     text: AppString.selectUnitHint,
//                     style: appStyles.texFieldPlaceHolderStyle(),
//                     children: [
//                       TextSpan(
//                         text: '*',
//                         style: appStyles
//                             .texFieldPlaceHolderStyle()
//                             .copyWith(color: Colors.red),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.start,
//                 ),
//               ),
//               hintStyle: appStyles.textFieldTextStyle(
//                 fontWeight: FontWeight.w400,
//                 texColor: Colors.grey.shade600,
//                 fontSize: 14,
//               ),
//               textStyle:
//                   appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
//               contentPadding: const EdgeInsets.only(
//                   left: 15, right: 15, top: 10, bottom: 10),
//               onTextChange: (value) {
//                 checkSelectedUnitNumber(value, 'selectUnit', onchange: true);
//               },
//               onEndEditing: (value) {
//                 checkSelectedUnitNumber(value, 'selectUnit');
//                 FocusScope.of(context).requestFocus(focusNodes['']);
//               },
//             ),
//           ],
//         ),
//       );
//     }
//
//     Widget imageUpload() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text.rich(
//             TextSpan(
//               text: AppString.transactionReceiptUpload,
//               style: appStyles.texFieldPlaceHolderStyle(),
//               children: [
//                 TextSpan(
//                   text: '*',
//                   style: appStyles
//                       .texFieldPlaceHolderStyle()
//                       .copyWith(color: Colors.red),
//                 ),
//               ],
//             ),
//             textAlign: TextAlign.start,
//           ),
//           const SizedBox(height: 10),
//           GestureDetector(
//             onTap: () => photoPickerBottomSheet(),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 border: Border.all(width: 0.8, color: Colors.transparent),
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade200,
//                     spreadRadius: 3,
//                     offset: const Offset(0, 1),
//                     blurRadius: 3,
//                   ),
//                 ],
//               ),
//               padding:
//                   const EdgeInsets.all(8).copyWith(top: 0, bottom: 0, left: 0),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       border: Border.all(width: 0.8, color: Colors.transparent),
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade200,
//                           spreadRadius: 3,
//                           offset: const Offset(0, 1),
//                           blurRadius: 3,
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       children: [
//                         if (selectedProfilePhoto != null)
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Stack(
//                               children: [
//                                 Image.file(
//                                   selectedProfilePhoto!,
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 Positioned(
//                                   top: 4,
//                                   right: 4,
//                                   child: GestureDetector(
//                                     onTap: _removeImage,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.black.withOpacity(0.6),
//                                       ),
//                                       padding: const EdgeInsets.all(4),
//                                       child: const Icon(
//                                         Icons.close,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         else
//                           Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(15),
//                                   margin: const EdgeInsets.only(bottom: 5),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade200,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(Icons.image,
//                                       size: 24, color: Colors.grey),
//                                 ),
//                                 Text(
//                                   AppString.upload,
//                                   style: appStyles.userJobTitleTextStyle(
//                                     fontSize: 14,
//                                     texColor: Colors.grey.shade600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Flexible(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           AppString.uploadHint,
//                           style: appStyles.userJobTitleTextStyle(
//                             fontSize: 14,
//                             texColor: Colors.grey.shade600,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           AppString.uploadSizeHint,
//                           style: appStyles.userJobTitleTextStyle(
//                             fontSize: 14,
//                             texColor: Colors.grey.shade600,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           AppString.uploadMaxImageHint,
//                           style: appStyles.userJobTitleTextStyle(
//                             fontSize: 14,
//                             texColor: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (imageErrorMessage.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text(
//                 imageErrorMessage,
//                 style: appStyles.errorStyle(),
//               ),
//             ),
//         ],
//       );
//     }
//
//     Widget paymentMethodField() {
//       List<String> paymentMethods = [];
//
//       // Add payment methods based on permissions
//       if (AppPermission.instance.canPermission(AppString.accountCash, context: context)) {
//         paymentMethods.add('Cash');
//       }
//       if (AppPermission.instance.canPermission(AppString.accountOnline, context: context)) {
//         paymentMethods.add('Online');
//       }
//       if (AppPermission.instance.canPermission(AppString.accountCheque, context: context)) {
//         paymentMethods.add('Check');
//       }
//
//       // Add "Other" option unconditionally
//       paymentMethods.add('Other');
//
//       return Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CommonTextFieldWithError(
//               readOnly: true,
//               inputFormatter: <TextInputFormatter>[],
//               inputKeyboardType: InputKeyboardTypeWithError.text,
//               focusNode: focusNodes['paymentMethod'],
//               isShowBottomErrorMsg: true,
//               errorMessages: errorMessages['paymentMethod']?.toString() ?? '',
//               controllerT: controllers['paymentMethod'],
//               borderRadius: 8,
//               onTapCallBack: () {
//                 // _clearReceiptData();
//                 showCupertinoModalPopup(
//                   context: context,
//                   builder: (BuildContext context) => CupertinoActionSheet(
//                     title: const Text(
//                       AppString.selectPaymentMethod,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     actions: paymentMethods.map((method) {
//                       return CupertinoActionSheetAction(
//                         onPressed: () {
//                           setState(() {
//                             controllers['paymentMethod']?.text = method;
//                             selectedPaymentMethod = method; // Update the
//                             // Clear the error message when a selection is made
//                             errorMessages['paymentMethod'] = '';
//                           });
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           method,
//                           style: TextStyle(
//                             color: controllers['paymentMethod']?.text == method
//                                 ? AppColors.textBlueColor
//                                 : Colors.black,
//                             fontWeight:
//                             controllers['paymentMethod']?.text == method
//                                 ? FontWeight.w600
//                                 : FontWeight.normal,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     cancelButton: CupertinoActionSheetAction(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       isDefaultAction: false,
//                       child: const Text(
//                         AppString.cancel,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   ),
//                 );
//
//                 setState(() {
//                   _showNextSection = false; // Hide next section when amount changes
//                 });
//               },
//               inputHeight: 50,
//               errorLeftRightMargin: 0,
//               maxCharLength: 500,
//               errorMsgHeight: 18,
//               maxLines: 1,
//               autoFocus: false,
//               showError: true,
//               showCounterText: false,
//               displayKeyBordDone: false,
//               capitalization: CapitalizationText.sentences,
//               cursorColor: Colors.grey,
//               enabledBorderColor: Colors.white,
//               focusedBorderColor: Colors.white,
//               backgroundColor: AppColors.white,
//               textInputAction: TextInputAction.none,
//               borderStyle: BorderStyle.solid,
//               hintText: AppString.paymentMethod,
//               placeHolderTextWidget: Padding(
//                 padding: const EdgeInsets.only(left: 3.0, bottom: 3),
//                 child: Text.rich(
//                   TextSpan(
//                     text: AppString.paymentMethodLabelNew,
//                     style: appStyles.texFieldPlaceHolderStyle(),
//                     children: [
//                       TextSpan(
//                         text: '*',
//                         style: appStyles
//                             .texFieldPlaceHolderStyle()
//                             .copyWith(color: Colors.red),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.start,
//                 ),
//               ),
//               hintStyle: appStyles.textFieldTextStyle(
//                 fontWeight: FontWeight.w400,
//                 texColor: Colors.grey.shade600,
//                 fontSize: 14,
//               ),
//               textStyle:
//               appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
//             inputFieldSuffixIcon:   Icon(
//               CupertinoIcons.chevron_down,
//               size: 16,
//               color: Colors.grey.shade600,
//             ),
//               contentPadding: const EdgeInsets.only(
//                   left: 15, right: 15, top: 10, bottom: 10),
//               onTextChange: (value) {
//                 setState(() {
//                   _showNextSection = false; // Hide next section when payment method changes
//                 });
//                 checkPaymentMethod(value, onchange: true);
//               },
//               onEndEditing: (value) {
//                 checkPaymentMethod(value);
//               },
//
//             ),
//           ],
//         ),
//       );
//     }
//
//     Widget remarksField() {
//       return Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CommonTextFieldWithError(
//               focusNode: focusNodes['remark'],
//               isShowBottomErrorMsg: true,
//               errorMessages: errorMessages['remark']?.toString() ?? '',
//               controllerT: controllers['remark'],
//               borderRadius: 8,
//               inputHeight: 50, // Adjust height as needed
//               errorLeftRightMargin: 0,
//               maxCharLength: 500,
//               errorMsgHeight: 18,
//               minLines: 1,
//               // maxLines: 5, // Allow up to 5 lines
//               autoFocus: false,
//               showError: true,
//               showCounterText: false,
//               capitalization: CapitalizationText.sentences,
//               cursorColor: Colors.grey,
//               enabledBorderColor: Colors.white,
//               focusedBorderColor: Colors.white,
//               backgroundColor: AppColors.white,
//               textInputAction: TextInputAction.done,
//               // keyboardType: TextInputType.multiline, // Ensure this is set
//               borderStyle: BorderStyle.solid,
//               hintText: AppString.remarksHint,
//               placeHolderTextWidget: Padding(
//                 padding: const EdgeInsets.only(left: 3.0, bottom: 3),
//                 child: Text.rich(
//                   TextSpan(
//                     text: AppString.remarksHint,
//                     style: appStyles.texFieldPlaceHolderStyle(),
//                   ),
//                   textAlign: TextAlign.start,
//                 ),
//               ),
//               hintStyle: appStyles.textFieldTextStyle(
//                 fontWeight: FontWeight.w400,
//                 texColor: Colors.grey.shade600,
//                 fontSize: 14,
//               ),
//               textStyle:
//                   appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
//               contentPadding: const EdgeInsets.only(
//                   left: 15, right: 15, top: 10, bottom: 10),
//               onEndEditing: (value) {
//                 checkSelectedUnitNumber(value, 'selectUnit');
//                 FocusScope.of(context).requestFocus(focusNodes['']);
//               },
//               onTextChange: (value) {
//                 checkSelectedUnitNumber(value, 'selectUnit', onchange: true);
//               },
//             ),
//           ],
//         ),
//       );
//     }
//
//     Widget pendingInvoices({
//       required String durations,
//       required String invoiceNumber,
//       required String invoiceAmountLabel,
//       required String status,
//       required bool isChecked,
//       Function(bool?)? onCheckboxChanged,
//     }) {
//       return LayoutBuilder(
//         builder: (context, constraints) {
//           double width = constraints.maxWidth;
//
//           return Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                 child: Padding(
//                   padding:
//                   const EdgeInsets.all(16.0).copyWith(bottom: 5, left: 0,top: 0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Row(
//                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         // crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             width: 13,
//                           ),
//                           Text(
//                             durations,
//                             style: appStyles.userNameTextStyle(
//                               texColor: Colors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             '($invoiceNumber)',
//                             style: appStyles.userNameTextStyle(
//                               texColor: Colors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.18, // 25% of screen width
//                           ),
//                           Expanded(
//                             child: Checkbox(
//                               value: isChecked,
//                               onChanged: onCheckboxChanged,
//                               checkColor: Colors.white,
//                               fillColor: MaterialStateProperty.resolveWith((states) {
//                                 return isChecked ? Colors.green : Colors.transparent;
//                               }),
//                               side: BorderSide(color: isChecked ? Colors.green : Colors.white),
//                             ),
//                           ),
//                           // Expanded(
//                           //   child: Text(
//                           //     invoiceAmountLabel,
//                           //     textAlign: TextAlign.end,
//                           //     style: appStyles.amountTextStyle(),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 13),
//                             child: Text(
//                               invoiceAmountLabel,
//                               textAlign: TextAlign.end,
//                               style: appStyles.amountTextStyle(),
//                             ),
//                           ),
//                           Text(
//                             status,
//                             style: appStyles.userNameTextStyle(
//                               texColor: status == "Fully Paid" || status == "Partially Paid"
//                                   ? Colors.green
//                                   : Colors.grey,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       // const SizedBox(height: 10),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //   // crossAxisAlignment: CrossAxisAlignment.start,
//                       //   children: [
//                       //     Checkbox(
//                       //       value: isChecked,
//                       //       onChanged: onCheckboxChanged,
//                       //       checkColor: Colors.white,
//                       //       fillColor: MaterialStateProperty.resolveWith((states) {
//                       //         return isChecked ? Colors.green : Colors.transparent;
//                       //       }),
//                       //       side: BorderSide(color: isChecked ? Colors.green : Colors.white),
//                       //     ),
//                       //
//                       //     Text(
//                       //       status,
//                       //       style: appStyles.userNameTextStyle(
//                       //         texColor: status == "Fully Paid" || status == "Partially Paid"
//                       //             ? Colors.green
//                       //             : Colors.grey,
//                       //         fontSize: 16,
//                       //         fontWeight: FontWeight.w500,
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                       const SizedBox(height: 10,)
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20,)
//             ],
//           );
//         },
//       );
//     }
//
//     Widget bottomButton() {
//       // Only show the button if the amount field is not empty
//       // if (controllers['amount']?.text.isEmpty ?? true) {
//       //   return const SizedBox.shrink();
//       // }
//       return Container(
//         margin: const EdgeInsets.only(top: 20, bottom: 20),
//         child: AppButton(
//           buttonColor: !isDisplayingInvoice
//               ? Colors.grey
//               : AppColors.textBlueColor,
//           buttonName: AppString.submit,
//           backCallback: () {
//
//             // if(!isVerifyButtonEnabled){
//             //   return ;
//             // }
//
//             // String selectedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
//             // String selectedTime = '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'; // Format time as HH:mm
//             formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
//             formattedTime = projectUtil.convertTo24HourFormat('${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}');
//             // String currentDate =
//             // DateFormat('yyyy-MM-dd').format(DateTime.now());
//             if (validateFields(isButtonClicked: true)) {
//               addTransactionReceiptBloc.add(SubmitTransactionReceipt(
//                   houseId: (AppPermission.instance.canPermission(
//                           AppString.accountPaymentAdd,
//                           context: context))
//                       ? selectedHouseId ?? 0 // Use 0 if selectedHouseId is null
//                       : selectedUnit?.id ??
//                           0, // Use 0 if selectedUnit?.id is null
//                   amount: controllers['amount']?.text.replaceAll(',', '') ?? '',
//                   filePath: selectedProfilePhotoPath ?? '',
//                   comments:
//                       controllers['remark']?.text.replaceAll(',', '') ?? '',
//                   paymentMethod: controllers['paymentMethod']!.text.isEmpty? "Online":controllers['paymentMethod']!.text.toString(),
//                   transactionDate: formattedDate, // Use recognized date
//                   transactionTime: formattedTime,
//                   mContext: context));
//             } else {
//               print('error');
//             }
//           },
//         ),
//       );
//     }
//
//     Widget title({required String text}) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 4),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               text,
//               style: appStyles.texFieldPlaceHolderStyle(),
//             ),
//           ],
//         ),
//       );
//     }
//
//     closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
//
//     Widget nextButton() {
//       if(!isVerifyButtonEnabled){
//         return const SizedBox();
//       }
//       return Container(
//         margin: const EdgeInsets.only(top: 20, bottom: 20),
//         child: AppButton(
//           // Disable the button if amount is empty OR if submit button is visible
//           buttonColor:
//                   !isVerifyButtonEnabled
//               ? Colors.grey
//               : AppColors.textBlueColor,
//           buttonName: AppString.fetchDues,
//           backCallback: () {
//             // Only allow the callback if the button is not disabled
//             if ((controllers['amount']?.text.isNotEmpty ?? false) &&
//                 isVerifyButtonEnabled) {
//               fetchedAmount = double.parse("${controllers['amount']?.text}");
//               isVerifyButtonEnabled = false;
//               callFetchInvoiceApi();
//               closeKeyboard();
//             }
//           },
//         ),
//       );
//     }
//
//     return ContainerFirst(
//       contextCurrentView: context,
//       isSingleChildScrollViewNeed: true,
//       isFixedDeviceHeight: true,
//       isListScrollingNeed: false,
//       isOverLayStatusBar: false,
//       appBarHeight: 56,
//       appBar: const CommonAppBar(
//         title: AppString.transactionReceiptUpload,
//         icon: WorkplaceIcons.backArrow,
//       ),
//       containChild:
//           BlocListener<AddTransactionReceiptBloc, AddTransactionReceiptState>(
//         bloc: addTransactionReceiptBloc,
//         listener: (context, state) {
//           if (state is AddTransactionReceiptErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text(state.message),
//               backgroundColor: Colors.red,
//             ));
//           } else if (state is TransactionReceiptSubmitSuccessState) {
//             bool hasPermission = AppPermission.instance
//                 .canPermission(AppString.accountPaymentAdd, context: context);
//
//             if (hasPermission) {
//               // Navigate to home if permission exists
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         const TransactionReceiptDetailScreen()),
//               );
//               Fluttertoast.showToast(
//                   backgroundColor: Colors.green.shade500,
//                   msg: AppString
//                       .receiptsUploadedSuccessfully); // Replace '/home' with your actual home route
//             } else {
//               // Pop if no permission
//               Navigator.pop(context, true);
//               Fluttertoast.showToast(
//                   backgroundColor: Colors.green.shade500,
//                   msg: AppString.receiptsUploadedSuccessfully);
//             }
//           }
//           else if (state is AddTransactionReceiptSuccessState) {
//            setState(() {
//              isDisplayingInvoice = true;
//            });
//           }
//         },
//         child:
//             BlocBuilder<AddTransactionReceiptBloc, AddTransactionReceiptState>(
//           bloc: addTransactionReceiptBloc,
//           builder: (context, state) {
//
//
//
//             return Stack(
//               children: [
//
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 20, left: 15, right: 18, bottom: 0),
//                   child: Column(
//                     children: [
//
//                       topCalendarAndTime(),
//                       const SizedBox(height: 20),
//                       if (AppPermission.instance.canPermission(
//                           AppString.accountPaymentAdd,
//                           context: context))
//                         Column(
//                           children: [
//                             memberField(),
//                             if (houseList.isNotEmpty) ...[
//                               title(text: AppString.selectUnitWithStar),
//                               buildHouseSelector(),
//                             ],
//                           ],
//                         )
//                       else
//                         selectUnit(),
//                       const SizedBox(height: 5),
//                       amountField(),
//                       nextButton(),
//
//                         // if (addTransactionReceiptBloc.pendingInvoicesData.isNotEmpty ||
//                         //   state is AddTransactionReceiptSuccessState ||
//                         //   state is AddTransactionReceiptLoadingState)
//                       if(isDisplayingInvoice)
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppString.invoices,
//                               style: appStyles.texFieldPlaceHolderStyle(),
//                             ),
//                             const SizedBox(height: 10,),
//                             addTransactionReceiptBloc.pendingInvoicesData!.isNotEmpty ?
//                             ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 padding: const EdgeInsets.only(top: 8),
//                                 itemCount: addTransactionReceiptBloc
//                                     .pendingInvoicesData!.length,
//                                 itemBuilder: (context, index) {
//                                   return pendingInvoices(
//                                     durations: addTransactionReceiptBloc
//                                         .pendingInvoicesData![index].durations!,
//                                     invoiceNumber: addTransactionReceiptBloc
//                                         .pendingInvoicesData![index]
//                                         .invoiceNumber!,
//                                     status: addTransactionReceiptBloc
//                                         .pendingInvoicesData![index].status!,
//                                     isChecked: addTransactionReceiptBloc
//                                         .pendingInvoicesData![index].isChecked!,
//                                     invoiceAmountLabel:
//                                         addTransactionReceiptBloc
//                                             .pendingInvoicesData![index]
//                                             .invoiceAmountLabel!,
//                                     // onCheckboxChanged: (bool? ) {  },
//                                   );
//                                 }): state is AddTransactionReceiptLoadingState? const SizedBox():
//                             Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.2),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                                 child:  Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                                     child: Text(
//                                       AppString.noPendingDues,
//                                       textAlign: TextAlign.center,
//                                       style: appStyles.userNameTextStyle(
//                                         texColor: AppColors.appBlueColor,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//
//                             ),
//                             SizedBox(
//                                 height: addTransactionReceiptBloc
//                                         .pendingInvoicesData!.isNotEmpty
//                                     ? 8
//                                     : 25),
//                             if (AppPermission.instance
//                                 .canPermission(AppString.accountBookList, context: context))
//                             paymentMethodField(),
//                             remarksField(),
//                             const SizedBox(height: 8),
//                             if (selectedPaymentMethod == 'Online' || AppPermission.instance
//                                 .canPermission(AppString.unitList, context: context))
//                               imageUpload(),
//                             // if (selectedPaymentMethod == 'Online')
//                             // imageUpload(),
//                             bottomButton(),
//                           ],
//                         ),
//
//                       // const SizedBox(height: 5),
//                     ],
//                   ),
//                 ),
//                 if (state is AddTransactionReceiptLoadingState)
//                   WorkplaceWidgets.progressLoader(context),
//               ],
//             );
//             //  }
//           },
//         ),
//       ),
//     );
//   }
//
//   /// Calling API to fetch amount
//   void callFetchInvoiceApi() {
//
//     addTransactionReceiptBloc.add(
//       GetPandingReceipt(
//           houseId: selectedUnit?.id.toString() ?? '',
//           amount:
//           controllers['amount']?.text.replaceAll(',', '') ?? '',
//           mContext: context),
//     );
//   }
// }
//
// class ThousandsSeparatorInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     String newText = newValue.text.replaceAll(',', '');
//
//     // Restrict the length to a maximum of 5 digits
//     if (newText.length > 5) {
//       newText = newText.substring(0, 5);
//     }
//
//     String formatted = _formatNumber(newText);
//
//     return newValue.copyWith(
//       text: formatted,
//       selection: TextSelection.collapsed(offset: formatted.length),
//     );
//   }
//
//   String _formatNumber(String s) {
//     return s.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))$'), ',');
//   }
// }
//
