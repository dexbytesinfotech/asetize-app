// import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
// import 'package:asetize/widgets/common_card_view.dart';
// import '../../core/util/app_theme/text_style.dart';
// import '../../imports.dart';
// import '../booking/widgets/label_widget.dart';
// import 'follow_up_list_screen.dart';
//
// class AddFollowUpScreen extends StatefulWidget {
//   final List<Houses> houses;
//   const AddFollowUpScreen({super.key, required this.houses});
//
//   @override
//   State<AddFollowUpScreen> createState() => _AddFollowUpScreenState();
// }
//
// class _AddFollowUpScreenState extends State<AddFollowUpScreen> {
//   late UserProfileBloc userProfileBloc;
//   DateTime? dateSingle;
//   String dateErrorMessage = '';
//   String? selectedAmenity;
//   closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
//   final List<String> amenityType = ['Confirmed to Pay','Didn\'t Pick the Call','Follow Up',];
//
//   Map<String, TextEditingController> controllers = {
//     'complaint': TextEditingController(),
//     'amenityType': TextEditingController(),
//   };
//
//   Map<String, FocusNode> focusNodes = {
//     'complaint': FocusNode(),
//     'amenityType': FocusNode(),
//   };
//
//   Map<String, String> errorMessages = {
//     'complaint': "",
//     'amenityType': "",
//   };
//   Houses? selectedUnit;
//   String? status;
//   int? id;
//   String? title;
//
//   @override
//   void initState() {
//     userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
//     if (widget.houses.isNotEmpty) {
//       selectedUnit = widget.houses[0];
//       status = widget.houses[0].status;
//       id = widget.houses[0].id;
//       title = widget.houses[0].title;
//
//     }
//     super.initState();
//   }
//
//   List<Widget> actions() {
//     return List.generate(widget.houses.length, (index) {
//       return CupertinoActionSheetAction(
//         onPressed: () {
//           Navigator.of(context).pop();
//           setState(() {
//             selectedUnit = widget.houses[index];
//             status = widget.houses[index].status;
//             id = widget.houses[index].id;
//             title = widget.houses[index].title;
//           });
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Remove the SvgPicture and make color blank
//             Text(
//               '${widget.houses[index].title}',
//               style: TextStyle(
//                 color: selectedUnit?.title == widget.houses[index].title
//                     ? AppColors.buttonBgColor3 // Selected color
//                     : Colors.black,            // Default color
//                 fontWeight: selectedUnit?.title == widget.houses[index].title
//                     ? FontWeight.w600          // Selected font weight
//                     : FontWeight.normal,       // Default font weight
//               ),
//             ),
//
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget followUpCardView()
//   {
//     return  CommonCardView(
//       child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     AppString.houseNumber,
//                     style:  appStyles.texFieldPlaceHolderStyle(),
//                   ),
//                   Text(
//                     AppString.houseOwner,
//                     style:  appStyles.texFieldPlaceHolderStyle(),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: (){
//                       if (widget.houses.length > 1) {
//                         showCupertinoModalPopup(
//                             barrierDismissible: false,
//                             context: context,
//                             builder: (context) {
//                               return CupertinoActionSheet(
//                                 title: const Text(
//                                   AppString.selectUnit,
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black87),
//                                 ),
//                                 actions: actions(),
//                                 cancelButton: CupertinoActionSheetAction(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text(
//                                     AppString.cancel,
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ),
//                               );
//                             });
//                       }
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                                 selectedUnit?.title ?? AppString.selectUnit,
//                                 style:  appTextStyle.appTitleStyle()
//                             ),
//                             widget.houses.length > 1
//                                 ? const Icon(
//                               Icons.arrow_drop_down,
//                               color: AppColors.textBlueColor,
//                               size: 30,
//                             )
//                                 : const SizedBox(),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                       userProfileBloc.user.name ?? '',
//                       style:  appTextStyle.appTitleStyle()
//                   ),
//                 ],
//               ),
//             ],
//           )
//
//       ),
//     );
//   }
//
//   void singleDate(BuildContext context) async {
//     final newDate = await showDatePicker(
//         context: context,
//         fieldLabelText: "DOB",
//         initialDate: dateSingle ?? DateTime.now(),
//         initialEntryMode: DatePickerEntryMode.calendarOnly,
//         firstDate: DateTime.now(),
//         lastDate: DateTime(
//             DateTime.now().year, DateTime.now().month + 12, DateTime.now().day),
//         builder: (context, child) {
//           return Theme(
//               data: ThemeData().copyWith(
//                   colorScheme: const ColorScheme.dark(
//                       primary: AppColors.appBlueColor,
//                       onSurface: Colors.black,
//                       onPrimary: Colors.white,
//                       surface: AppColors.white,
//                       brightness: Brightness.light),
//                   dialogBackgroundColor: AppColors.white),
//               child: child!);
//         });
//     if (newDate == null) return;
//
//     setState(() {
//       dateSingle = newDate;
//       if (dateSingle != null) {
//         dateErrorMessage = "";
//       }
//     });
//   }
//
//   String singleDateText() {
//     if (dateSingle == null) {
//       return AppString.pickADate;
//     } else {
//       return projectUtil.uiShowDateFormat(dateSingle!);
//     }
//   }
//   Widget singleDateWidget() => Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       Flexible(
//         child: Container(
//           height: 45,
//           padding: const EdgeInsets.only(
//               left: 12, right: 15, top: 5, bottom: 5),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey.shade200,
//                     spreadRadius: 3,
//                     offset: const Offset(0, 1),
//                     blurRadius: 3)
//               ]),
//           child: InkWell(
//             onTap: () {
//               singleDate(context);
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 6),
//                   child: Text(
//                     singleDateText().toString(),
//                     style: dateSingle != null? appStyles.textFieldTextStyle(): appStyles.hintTextStyle(),
//                   ),
//                 ),
//                 WorkplaceWidgets.calendarIcon(),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
//
//
//
//   checkReason(value, fieldEmail, {onchange = false}) {
//     if (Validation.isNotEmpty(value.trim())) {
//       setState(() {
//         if (Validation.isNotEmpty(value.trim())) {
//           errorMessages[fieldEmail] = "";
//         } else {
//           if (!onchange) {
//             errorMessages[fieldEmail] =
//                 AppString.trans(context, AppString.emailHintError1);
//           }
//         }
//       });
//     } else {
//       setState(() {
//         if (!onchange) {
//           if (fieldEmail == 'complaint') {
//             errorMessages[fieldEmail] =
//                 AppString.trans(context, AppString.emailHintError);
//           }
//         }
//       });
//     }
//   }
//
//   reasonField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       margin: const EdgeInsets.only( top: 20, bottom: 0),
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CommonTextFieldWithError(
//             focusNode: focusNodes['complaint'],
//             isShowBottomErrorMsg: true,
//             errorMessages: errorMessages['complaint']?.toString() ?? '',
//             controllerT: controllers['complaint'],
//             borderRadius: 8,
//             inputHeight: 140,
//             hintStyle: appStyles.hintTextStyle(),
//             textStyle: appStyles.textFieldTextStyle(),
//             errorLeftRightMargin: 0,
//             maxCharLength: 500,
//             errorMsgHeight: 18,
//             minLines: 3,
//             maxLines: 3,
//             autoFocus: false,
//             showError: true,
//             showCounterText: false,
//             capitalization: CapitalizationText.sentences,
//             cursorColor: Colors.grey,
//             enabledBorderColor: Colors.white,
//             focusedBorderColor: Colors.white,
//             backgroundColor: AppColors.white,
//             textInputAction: TextInputAction.newline,
//             borderStyle: BorderStyle.solid,
//             inputKeyboardType: InputKeyboardTypeWithError.multiLine,
//             hintText: "Add any additional note here...",
//             placeHolderTextWidget: LabelWidget(labelText:'Remark',isRequired: false, ),
//             contentPadding: const EdgeInsets.only(
//                 left: 15, right: 15, top: 10, bottom: 10),
//             onTextChange: (value) {
//               checkReason(value, 'complaint', onchange: true);
//             },
//             onEndEditing: (value) {
//               checkReason(value, 'complaint');
//               FocusScope.of(context).requestFocus(focusNodes['password']);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//   Widget starDateErrorText() {
//     String errorText =  dateErrorMessage;
//     if (errorText.isNotEmpty) {
//       return Row(
//         mainAxisAlignment: (errorText == "Please select end date")
//             ? MainAxisAlignment.end
//             : MainAxisAlignment.start,
//         children: [
//           Container(
//             color: Colors.transparent,
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.only(left: 4, top: 2,right: 50),
//             height: 20,
//             child: Text(
//               errorText,
//               style: appStyles.errorStyle(),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Container(
//           color: Colors.transparent,
//           height: 18);
//     }
//   }
//   checkAmenityType(value, vehicleType, {onchange = false}) {
//     if (Validation.isNotEmpty(value.trim())) {
//       setState(() {
//         if (Validation.isNotEmpty(value.trim())) {
//           errorMessages[vehicleType] = "";
//         } else {
//           if (!onchange) {
//             errorMessages[vehicleType] = AppString.trans(
//               context,'Please select amenity type',
//             );
//           }
//         }
//       });
//     } else {
//       setState(() {
//         if (!onchange) {
//           if (vehicleType == 'amenityType') {
//             errorMessages[vehicleType] = AppString.trans(
//               context,
//               'Please select amenity type',
//             );
//           }
//         }
//       });
//     }
//   }
//   void showAmenityTypeBottomSheet(BuildContext context) {
//     WorkplaceWidgets.showCustomAndroidBottomSheet(
//       context: context,
//       title:'Select Status',
//       valuesList: amenityType,
//       selectedValue: controllers['amenityType']?.text ?? "",
//       onValueSelected: (value) {
//         setState(() {
//           controllers['amenityType']?.text = value;
//           selectedAmenity = value;
//           errorMessages['amenityType'] = "";
//         });
//       },
//     );
//   }
//   Widget followUpStatusTypeField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//
//       width: MediaQuery.of(context).size.width,
//       child: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//           showAmenityTypeBottomSheet(context);
//           closeKeyboard();
//
//         },
//         child: AbsorbPointer(
//           child: CommonTextFieldWithError(
//             key: ValueKey(controllers['amenityType']?.text),
//             focusNode: focusNodes['amenityType'],
//             isShowBottomErrorMsg: true,
//             errorMessages: errorMessages['amenityType']?.toString() ?? '',
//             controllerT: controllers['amenityType'],
//             borderRadius: 8,
//             inputHeight: 50,
//             hintStyle: appStyles.hintTextStyle(),
//             textStyle: appStyles.textFieldTextStyle(),
//             errorLeftRightMargin: 0,
//             maxCharLength: 50,
//             readOnly: true,
//             errorMsgHeight: 18,
//             autoFocus: false,
//             inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
//             enabledBorderColor: Colors.white,
//             focusedBorderColor: Colors.white,
//
//             showError: true,
//             capitalization: CapitalizationText.none,
//             backgroundColor: AppColors.white,
//             textInputAction: TextInputAction.done,
//             borderStyle: BorderStyle.solid,
//             cursorColor: Colors.grey,
//             hintText:AppString.selectStatus,
//             placeHolderTextWidget: const LabelWidget(labelText: AppString.followUpStatus),
//             contentPadding: const EdgeInsets.only(left: 15, right: 15),
//             onTextChange: (value) {
//               selectedAmenity = value;
//             },
//             onEndEditing: (value) {
//               FocusScope.of(context).unfocus();
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   bool validateFields({bool isButtonClicked = false}) {
//     if (controllers['amenityType']?.text == null ||
//         controllers['amenityType']?.text == '') {
//       if (isButtonClicked) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) {
//             setState(() {
//               errorMessages['amenityType'] = 'Please select follow up status';
//             });
//           }
//         });
//       }
//       return false;
//     }  else if ( dateSingle == null) {
//       if (isButtonClicked) {
//         setState(() {
//           dateErrorMessage = "Please select the date";
//         });
//       }
//       return false;
//     }
//     else {
//       return true;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return ContainerFirst(
//         contextCurrentView: context,
//         isSingleChildScrollViewNeed: true,
//         isFixedDeviceHeight: false,
//         isListScrollingNeed: false,
//         isOverLayStatusBar: false,
//         appBarHeight: 56,
//         appBar:  CommonAppBar(
//           title: 'Follow Up with ${userProfileBloc.selectedUnit?.title}',
//         ),
//
//         containChild: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6),
//           child: Column(
//             children: [
//               followUpCardView(),
//               const SizedBox(height: 10),
//               followUpStatusTypeField(),
//               const LabelWidget(labelText:AppString.nextFollowUpDate,isRequired: true, ),
//               const SizedBox(height: 5,),
//               singleDateWidget(),
//               reasonField(),
//               const SizedBox(height: 18,),
//               AppButton(
//                 buttonName: 'Submit Follow-up',
//                 buttonColor: (validateFields()) ? AppColors.textBlueColor : Colors.grey,
//                 // buttonColor: AppColors.textBlueColor,
//                 backCallback:(validateFields()) ? () {
//                   if (validateFields(isButtonClicked: true)) {
//                     Navigator.of(context).pop();
//                   }
//
//                 }:null,
//               ),
//             ],
//           ),
//         ));
//
//   }
// }
//
//
