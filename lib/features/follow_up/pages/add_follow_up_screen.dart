// import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
// import 'package:asetize/widgets/common_card_view.dart';
// import '../../core/util/app_theme/text_style.dart';
// import '../../imports.dart';
// import '../booking/widgets/label_widget.dart';
//
// class AddFollowUpScreen extends StatefulWidget {
//   final List<Houses> houses;
//   final bool isComeFromDetail;
//   const AddFollowUpScreen({super.key, required this.houses, this.isComeFromDetail = false});
//
//   @override
//   State<AddFollowUpScreen> createState() => _AddFollowUpScreenState();
// }
//
// class _AddFollowUpScreenState extends State<AddFollowUpScreen> {
//   late UserProfileBloc userProfileBloc;
//   DateTime? nextFollowUpDate;
//   String? selectedFollowUpStatus;
//   final List<String> followUpStatusOptions = ['Confirmed to Pay', 'Didn\'t Pick the Call', 'Follow Up'];
//   Houses? selectedUnit;
//   String? status;
//   int? id;
//   String? title;
//
//   final TextEditingController remarkController = TextEditingController();
//   final TextEditingController followUpStatusController = TextEditingController();
//   final TextEditingController nextFollowUpDateController = TextEditingController();
//   final FocusNode remarkFocusNode = FocusNode();
//   final FocusNode followUpStatusFocusNode = FocusNode();
//   final FocusNode nextFollowUpDateFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
//     if (widget.houses.isNotEmpty) {
//       selectedUnit = widget.houses[0];
//       status = widget.houses[0].status;
//       id = widget.houses[0].id;
//       title = widget.houses[0].title;
//     }
//   }
//
//   @override
//   void dispose() {
//     remarkController.dispose();
//     followUpStatusController.dispose();
//     nextFollowUpDateController.dispose();
//     remarkFocusNode.dispose();
//     followUpStatusFocusNode.dispose();
//     nextFollowUpDateFocusNode.dispose();
//     super.dispose();
//   }
//
//   List<Widget> actions() {
//     return widget.houses.map((house) {
//       return CupertinoActionSheetAction(
//         onPressed: () {
//           Navigator.of(context).pop();
//           setState(() {
//             selectedUnit = house;
//             status = house.status;
//             id = house.id;
//             title = house.title;
//           });
//         },
//         child: Text(
//           house.title.toString(),
//           style: TextStyle(
//             color: selectedUnit?.title == house.title
//                 ? AppColors.buttonBgColor3
//                 : Colors.black,
//             fontWeight: selectedUnit?.title == house.title
//                 ? FontWeight.w600
//                 : FontWeight.normal,
//           ),
//         ),
//       );
//     }).toList();
//   }
//
//   Widget followUpCardView() {
//     return CommonCardView(
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   AppString.houseNumber,
//                   style: appStyles.texFieldPlaceHolderStyle(),
//                 ),
//                 Text(
//                   AppString.houseOwner,
//                   style: appStyles.texFieldPlaceHolderStyle(),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: widget.houses.length > 1
//                       ? () {
//                     showCupertinoModalPopup(
//                       barrierDismissible: false,
//                       context: context,
//                       builder: (context) => CupertinoActionSheet(
//                         title: const Text(
//                           AppString.selectUnit,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         actions: actions(),
//                         cancelButton: CupertinoActionSheetAction(
//                           onPressed: () => Navigator.of(context).pop(),
//                           child: const Text(
//                             AppString.cancel,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                       : null,
//                   child: Row(
//                     children: [
//                       Text(
//                         selectedUnit?.title ?? AppString.selectUnit,
//                         style: appTextStyle.appTitleStyle(),
//                       ),
//                       if (widget.houses.length > 1)
//                         const Icon(
//                           Icons.arrow_drop_down,
//                           color: AppColors.textBlueColor,
//                           size: 30,
//                         ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   userProfileBloc.user.name ?? '',
//                   style: appTextStyle.appTitleStyle(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void selectDate(BuildContext context) async {
//     final newDate = await showDatePicker(
//       context: context,
//       initialDate: nextFollowUpDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(DateTime.now().year, DateTime.now().month + 12, DateTime.now().day),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData().copyWith(
//             colorScheme: const ColorScheme.dark(
//               primary: AppColors.appBlueColor,
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
//     if (newDate != null) {
//       setState(() {
//         nextFollowUpDate = newDate;
//         nextFollowUpDateController.text = projectUtil.uiShowDateFormat(newDate);
//       });
//     }
//   }
//
//   Widget nextFollowUpDateWidget() {
//     return CommonTextFieldWithError(
//       focusNode: nextFollowUpDateFocusNode,
//       controllerT: nextFollowUpDateController,
//       borderRadius: 8,
//       errorMsgHeight: 20,
//       showError: true,
//       inputHeight: 50,
//       hintStyle: appStyles.hintTextStyle(),
//       textStyle: appStyles.textFieldTextStyle(),
//       maxCharLength: 50,
//       readOnly: true,
//       autoFocus: false,
//       inputFieldSuffixIcon: WorkplaceWidgets.calendarIcon(),
//       enabledBorderColor: Colors.white,
//       focusedBorderColor: Colors.white,
//       backgroundColor: AppColors.white,
//       textInputAction: TextInputAction.done,
//       borderStyle: BorderStyle.solid,
//       cursorColor: Colors.grey,
//       hintText: AppString.pickADate,
//       placeHolderTextWidget: const LabelWidget(labelText: AppString.nextFollowUpDate, isRequired: true),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//       onTapCallBack: () => selectDate(context),
//       onTextChange: (value) {
//       },
//       onEndEditing: (value) {
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
//
//   void showStatusBottomSheet(BuildContext context) {
//     WorkplaceWidgets.showCustomAndroidBottomSheet(
//       context: context,
//       title: 'Select Status',
//       valuesList: followUpStatusOptions,
//       selectedValue: followUpStatusController.text,
//       onValueSelected: (value) {
//         setState(() {
//           followUpStatusController.text = value;
//           selectedFollowUpStatus = value;
//         });
//       },
//     );
//   }
//
//   Widget followUpStatusWidget() {
//     return CommonTextFieldWithError(
//       key: ValueKey(followUpStatusController.text),
//       focusNode: followUpStatusFocusNode,
//       controllerT: followUpStatusController,
//       borderRadius: 8,
//       inputHeight: 50,
//       hintStyle: appStyles.hintTextStyle(),
//       textStyle: appStyles.textFieldTextStyle(),
//       maxCharLength: 50,
//       errorMsgHeight: 20,
//       showError: true,
//       readOnly: true,
//       autoFocus: false,
//       inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
//       enabledBorderColor: Colors.white,
//       focusedBorderColor: Colors.white,
//       backgroundColor: AppColors.white,
//       textInputAction: TextInputAction.done,
//       borderStyle: BorderStyle.solid,
//       cursorColor: Colors.grey,
//       hintText: AppString.selectStatus,
//       placeHolderTextWidget: const LabelWidget(labelText: AppString.followUpStatus),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//       onTapCallBack: () {
//         FocusScope.of(context).unfocus();
//         showStatusBottomSheet(context);
//       },
//       onTextChange: (value) {
//         selectedFollowUpStatus = value;
//       },
//       onEndEditing: (value) {
//         FocusScope.of(context).unfocus();
//       },
//     );}
//
//   Widget remarkWidget() {
//     return CommonTextFieldWithError(
//       focusNode: remarkFocusNode,
//       controllerT: remarkController,
//       borderRadius: 8,
//       inputHeight: 140,
//       hintStyle: appStyles.hintTextStyle(),
//       textStyle: appStyles.textFieldTextStyle(),
//       maxCharLength: 500,
//       minLines: 3,
//       maxLines: 3,
//       autoFocus: false,
//       showCounterText: false,
//       capitalization: CapitalizationText.sentences,
//       cursorColor: Colors.grey,
//       enabledBorderColor: Colors.white,
//       focusedBorderColor: Colors.white,
//       backgroundColor: AppColors.white,
//       textInputAction: TextInputAction.newline,
//       borderStyle: BorderStyle.solid,
//       inputKeyboardType: InputKeyboardTypeWithError.multiLine,
//       hintText: AppString.writeAdditionalNote,
//       placeHolderTextWidget: const LabelWidget(labelText: AppString.remark, isRequired: false),
//       contentPadding: const EdgeInsets.all(10),
//       onTextChange: (value){},
//       onEndEditing: (value) {},
//     );
//   }
//
//   bool areMandatoryFieldsFilled() {
//     return widget.isComeFromDetail == true?nextFollowUpDate != null:followUpStatusController.text.isNotEmpty && nextFollowUpDate != null;
//   }
//
//   Widget submitButtonWidget() {
//     return AppButton(
//       buttonName: AppString.submitFollowUp,
//       buttonColor: areMandatoryFieldsFilled() ? AppColors.textBlueColor : Colors.grey,
//       backCallback: areMandatoryFieldsFilled()
//           ? () {
//         Navigator.of(context).pop();
//       }
//           : null,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ContainerFirst(
//       contextCurrentView: context,
//       isSingleChildScrollViewNeed: true,
//       isFixedDeviceHeight: false,
//       isListScrollingNeed: false,
//       isOverLayStatusBar: false,
//       appBarHeight: 56,
//       appBar: CommonAppBar(
//         title: 'Follow Up with ${userProfileBloc.selectedUnit?.title}',
//       ),
//       containChild: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           children: [
//             widget.isComeFromDetail == true?SizedBox():followUpCardView(),
//              SizedBox(height: widget.isComeFromDetail == true?0:10,),
//             widget.isComeFromDetail == true?SizedBox():followUpStatusWidget(),
//              SizedBox(height: widget.isComeFromDetail == true?0:10,),
//             nextFollowUpDateWidget(),
//             const SizedBox(height: 10,),
//             remarkWidget(),
//             const SizedBox(height: 40,),
//             submitButtonWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }