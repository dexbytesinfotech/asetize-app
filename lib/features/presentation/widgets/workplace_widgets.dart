import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:asetize/imports.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import '../../../app_global_components/cupertino_custom_picker.dart';
import '../../../app_global_components/gradient_linear_progress_indicator.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../assets_management/model/assets_member_list_model.dart';
import '../../member/pages/user_detail_bottom_sheet.dart';

abstract class WorkplaceWidgets {
  static Widget errorContentPopup({
    required String buttonName,
    required String content,
    Function()? onPressedButton,
  }) =>
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(
          content,
          textAlign: TextAlign.center,
        ),
        contentTextStyle: appStyles.subTitleStyle(
          fontSize: AppDimens().fontSize(value: 16),
          fontWeight: FontWeight.w200,
          texColor: AppColors.black,
          fontFamily: AppFonts().defaultFont,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onPressedButton,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: AppColors.appBlue,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      buttonName,
                      style: appStyles.subTitleStyle(
                        fontSize: AppDimens().fontSize(value: 15),
                        fontWeight: FontWeight.w500,
                        texColor: AppColors.appWhite,
                        fontFamily: AppFonts().defaultFont,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  static void successToast(String message, {int? durationInSeconds}) {
    if (message.trim().isEmpty) return;

    Fluttertoast.showToast(
        msg: message,
        backgroundColor: AppColors.textDarkGreenColor.safeOpacity(0.85));
  }

  static Widget calendarIcon({
    double size = 20,
    Color? color,
  }) {
    return Icon(
      Icons.calendar_month,
      size: size,
      color: color ?? Colors.grey.shade500,
    );
  }

  static Widget downArrowIcon({
    double size = 24,
    Color color = Colors.grey,
  }) {
    return Icon(
      Icons.keyboard_arrow_down,
      size: size,
      color: color,
    );
  }

  static Widget clockIcon({
    double size = 21,
    Color color = Colors.grey,
  }) {
    return Icon(
      Icons.access_time, // ⏰ Clock icon
      size: size,
      color: color,
    );
  }

  static void errorSnackBar(BuildContext context, String message) {
    if (message.trim().isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      backgroundColor: AppColors.textDarkRedColor,
    ));
  }

  static Widget iconTextRowWidget(
          {required IconData icon,
          required String title,
          Color? color,
          double? width}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            icon,
            size: 15.sp,
            color: color ?? AppColors.textBlueColor.withOpacity(0.5),
          ),
          SizedBox(
            width: 5.sp,
          ),
          SizedBox(
            width: width,
            child: Text(title,
                textAlign: TextAlign.start,
                style: appStyles.userJobTitleTextStyle(
                    fontSize: 12.sp, texColor: color)),
          ),
        ],
      );

  AppStyle appStyle = AppStyle();

  static Widget titleContentPopup({
    required String buttonName1,
    required String buttonName2,
    required String title,
    required String content,
    Color? onPressedButton1TextColor,
    Color? onPressedButton2TextColor,
    Color? onPressedButton1Color,
    Color? onPressedButton2Color,
    Function()? onPressedButton1,
    Function()? onPressedButton2,
  }) =>
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, textAlign: TextAlign.center),
        titleTextStyle: appStyles.titleStyle(
          fontSize: AppDimens().fontSize(value: 22),
          fontWeight: FontWeight.w500,
          texColor: AppColors.black,
          fontFamily: AppFonts().defaultFont,
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
        ),
        contentTextStyle: appStyles.subTitleStyle(
          fontSize: AppDimens().fontSize(value: 16),
          fontWeight: FontWeight.w200,
          texColor: AppColors.black,
          fontFamily: AppFonts().defaultFont,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: onPressedButton1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: onPressedButton1Color ?? AppColors.appBlue,
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        buttonName1,
                        style: appStyles.subTitleStyle(
                          fontSize: AppDimens().fontSize(value: 15),
                          fontWeight: FontWeight.w500,
                          texColor:
                              onPressedButton1TextColor ?? AppColors.appWhite,
                          fontFamily: AppFonts().defaultFont,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: GestureDetector(
                  onTap: onPressedButton2,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: onPressedButton2Color ?? Colors.grey.shade200),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        buttonName2,
                        style: appStyles.subTitleStyle(
                          fontSize: AppDimens().fontSize(value: 15),
                          fontWeight: FontWeight.w500,
                          texColor:
                              onPressedButton2TextColor ?? AppColors.black,
                          fontFamily: AppFonts().defaultFont,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );


  static Widget productNotFound({
    required String buttonName1,
    required String buttonName2,
    required String buttonName3,
    required String title,
    required String content,
    Color? onPressedButton1TextColor,
    Color? onPressedButton2TextColor,
    Color? onPressedButton3TextColor,
    Color? onPressedButton1Color,
    Color? onPressedButton2Color,
    Color? onPressedButton3Color,
    Function()? onPressedButton1,
    Function()? onPressedButton2,
    Function()? onPressedButton3,
  }) =>
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, textAlign: TextAlign.center),
        titleTextStyle: appStyles.titleStyle(
          fontSize: AppDimens().fontSize(value: 22),
          fontWeight: FontWeight.w500,
          texColor: AppColors.black,
          fontFamily: AppFonts().defaultFont,
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
        ),
        contentTextStyle: appStyles.subTitleStyle(
          fontSize: AppDimens().fontSize(value: 16),
          fontWeight: FontWeight.w200,
          texColor: AppColors.black,
          fontFamily: AppFonts().defaultFont,
        ),
        actions: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: onPressedButton1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: onPressedButton1Color ??  Colors.grey.shade200,
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            buttonName1,
                            style: appStyles.subTitleStyle(
                              fontSize: AppDimens().fontSize(value: 15),
                              fontWeight: FontWeight.w500,
                              texColor:
                              onPressedButton2TextColor ?? AppColors.black,
                              fontFamily: AppFonts().defaultFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: onPressedButton2,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: onPressedButton2Color ??AppColors.textBlueColor),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            buttonName2,
                            style: appStyles.subTitleStyle(
                              fontSize: AppDimens().fontSize(value: 15),
                              fontWeight: FontWeight.w500,
                              texColor:
                              onPressedButton2TextColor ?? AppColors.white,
                              fontFamily: AppFonts().defaultFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: onPressedButton3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: onPressedButton3Color ?? AppColors.textDarkGreenColor,
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                          buttonName3,
                            style: appStyles.subTitleStyle(
                              fontSize: AppDimens().fontSize(value: 15),
                              fontWeight: FontWeight.w500,
                              texColor:
                              onPressedButton3TextColor ?? AppColors.appWhite,
                              fontFamily: AppFonts().defaultFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  static void showCustomBottomSheet({
    required BuildContext context,
    required String title,
    bool? isNavigation = true,
    TextStyle? titleTextStyle,
    required List valuesList,
    required String selectedValue,
    required ValueChanged<String> onValueSelected,
  }) {
    String tempSelectedValue = selectedValue;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 15),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            title,
                            style: titleTextStyle ??
                                const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: TextButton(
                            onPressed: () {
                              onValueSelected(tempSelectedValue);
                              isNavigation! ? Navigator.pop(context) : false;
                            },
                            child: const Text(
                              AppString.done,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 6),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: valuesList.length * 60.0 > 240
                          ? 240
                          : valuesList.length * 60.0,
                    ),
                    child: CupertinoCustomPicker(
                      valuesList: valuesList,
                      selected: tempSelectedValue,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          tempSelectedValue = valuesList[index];
                        });
                      },
                      onItemClicked: (item) {
                        if (tempSelectedValue == item) {
                          onValueSelected(item);
                          isNavigation! ? Navigator.pop(context) : false;
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // static void showCustomAndroidBottomSheet({
  //   required BuildContext context,
  //   required String title,
  //   TextStyle? titleTextStyle,
  //   required List valuesList,
  //   bool isNavigation = true,
  //   required String selectedValue,
  //   required ValueChanged<String> onValueSelected,
  // }) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) {
  //       return Container(
  //         decoration: const BoxDecoration(
  //           color: AppColors.white,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(15),
  //             topRight: Radius.circular(15),
  //           ),
  //         ),
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               title,
  //               style: titleTextStyle ??
  //                   const TextStyle(
  //                     fontSize: 17,
  //                     color: AppColors.black,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //               textAlign: TextAlign.center,
  //             ),
  //             const Divider(height: 20, thickness: 1),
  //             Flexible(
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: valuesList.length,
  //                 itemBuilder: (context, index) {
  //                   final item = valuesList[index];
  //                   final isSelected = item == selectedValue;
  //                   return ListTile(
  //                     title: Text(
  //                       item,
  //                       style: TextStyle(
  //                         color: isSelected ? Colors.green : AppColors.black,
  //                         fontWeight:
  //                             isSelected ? FontWeight.bold : FontWeight.normal,
  //                       ),
  //                     ),
  //                     trailing: isSelected
  //                         ? const Icon(Icons.check, color: Colors.green)
  //                         : null,
  //                     onTap: () {
  //                       onValueSelected(item);
  //                       isNavigation ? Navigator.pop(context) : false;
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  static void showCustomAndroidBottomSheet({
    required BuildContext context,
    required String title,
    TextStyle? titleTextStyle,
    required List valuesList,
    bool isNavigation = true,
    required String selectedValue,
    required ValueChanged<String> onValueSelected,
  }) {
    Divider divider = Divider(
      thickness: 0.4,
      height: 1,
      color: Colors.grey.shade300,
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 0).copyWith(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 55,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12, top: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: titleTextStyle ??
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              divider,
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: ClampingScrollPhysics(),
                  itemCount: valuesList.length,
                  separatorBuilder: (_, __) => divider,
                  itemBuilder: (context, index) {
                    final item = valuesList[index];
                    final isSelected = item == selectedValue;
                    return ListTile(
                      contentPadding: const EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      title: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            //isSelected ? Colors.black : Colors.black87,
                            fontWeight: FontWeight
                                .w500 //isSelected ? FontWeight.w500 : FontWeight.normal,
                            ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                              color: AppColors.appBlueColor, size: 24)
                          : null,
                      onTap: () {
                        onValueSelected(item);
                        if (isNavigation) Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              // divider,
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              //   child: AppButton(
              //     buttonName: 'Cancel',
              //     buttonColor: AppColors.white,
              //     buttonBorderColor: Colors.grey.shade400,
              //     textStyle: appStyles.buttonTextStyle1(texColor: Colors.black,fontWeight: FontWeight.w500),
              //     backCallback: () {
              //       Navigator.pop(context);
              //     },
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  static Widget commonSignalOkPopup({
    String? buttonName1,
    required String buttonName2,
    required String title,
    required String content,
    Color? onPressedButton1TextColor,
    Color? onPressedButton2TextColor,
    Color? onPressedButton1Color,
    Color? onPressedButton2Color,
    Function()? onPressedButton1,
    Function()? onPressedButton2,
  }) =>
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, textAlign: TextAlign.center),
        titleTextStyle: appStyles.titleStyle(
          fontSize: AppDimens().fontSize(value: 22),
          fontWeight: FontWeight.w500,
          texColor: AppColors.black,
          fontFamily: AppFonts().defaultFont,
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
        ),
        contentTextStyle: appStyles.subTitleStyle(
          fontSize: AppDimens().fontSize(value: 16),
          fontWeight: FontWeight.w200,
          texColor: AppColors.black,
          fontFamily: AppFonts().defaultFont,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onPressedButton2,
                child: Container(
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: onPressedButton2Color ?? Colors.grey.shade200),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      buttonName2,
                      textAlign: TextAlign.center,
                      style: appStyles.subTitleStyle(
                        fontSize: AppDimens().fontSize(value: 15),
                        fontWeight: FontWeight.w500,
                        texColor: onPressedButton2TextColor ?? AppColors.black,
                        fontFamily: AppFonts().defaultFont,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  static Widget titleContentPopupWithInput({
    required String buttonName1,
    required String buttonName2,
    required String title,
    required String hintText,
    required Function(String input)? onConfirm,
    Color? onPressedButton1TextColor,
    Color? onPressedButton2TextColor,
    Color? onPressedButton1Color,
    Color? onPressedButton2Color,
    Function()? onPressedButton1,
  }) {
    final TextEditingController textController = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      titleTextStyle: appStyles.titleStyle(
        fontSize: AppDimens().fontSize(value: 22),
        fontWeight: FontWeight.w500,
        texColor: AppColors.black,
        fontFamily: AppFonts().defaultFont,
      ),
      content: SizedBox(
        width: 400, // Set a fixed width to increase the dialog's width
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hintText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                // width: MediaQuery.of(context).size.width,
              ),
              child: TextField(
                controller: textController,
                maxLines: null, // Allow text to wrap to the next line
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  // Enables the background color
                  fillColor: AppColors.white,
                  // Sets the background color
                  hintText: 'Enter receipt number',
                ),
              ),
            ),
          ],
        ),
      ),
      contentTextStyle: appStyles.subTitleStyle(
        fontSize: AppDimens().fontSize(value: 16),
        fontWeight: FontWeight.w200,
        texColor: AppColors.black,
        fontFamily: AppFonts().defaultFont,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  if (onConfirm != null) {
                    onConfirm(textController.text);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: onPressedButton1Color ?? Colors.green,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      buttonName1,
                      style: appStyles.subTitleStyle(
                        fontSize: AppDimens().fontSize(value: 15),
                        fontWeight: FontWeight.w500,
                        texColor: onPressedButton1TextColor ?? AppColors.white,
                        fontFamily: AppFonts().defaultFont,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
            Flexible(
              child: GestureDetector(
                onTap: onPressedButton1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: onPressedButton2Color ?? Colors.grey.shade200,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      buttonName2,
                      style: appStyles.subTitleStyle(
                        fontSize: AppDimens().fontSize(value: 15),
                        fontWeight: FontWeight.w500,
                        texColor: onPressedButton2TextColor ?? AppColors.black,
                        fontFamily: AppFonts().defaultFont,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

// Usage

  static userDetailBottomSheet(
      {required User userData, Map<String, dynamic>? map}) {
    showSlidingBottomSheet(MainAppBloc.getDashboardContext, builder: (context) {
      return SlidingSheetDialog(
        elevation: 0,
        color: Colors.transparent,
        cornerRadius: 16,
        duration: const Duration(milliseconds: 400),
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.5, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return UserDetailBottomSheet(
            userData: userData,
            map: map,
          );
        },
      );
    });

    // showModalBottomSheet(
    //     barrierColor: Colors.transparent.withOpacity(.2),
    //     context: MainAppBloc.getDashboardContext,
    //     // is used to remove Bottom Navigation Bar
    //     builder: (context) => UserDetailBottomSheet(
    //           userData: userData,
    //           map: map,
    //         ),
    //     isScrollControlled: true,
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //     shape: const RoundedRectangleBorder(
    //         //borderRadius: BorderRadius.vertical(top: Radius.circular(20))
    //         borderRadius: BorderRadius.only(
    //             topRight: Radius.circular(20), topLeft: Radius.circular(20))));
  }

  static Widget userDetailListCard(
      {required User? user,
      required String description,
      Map<String, dynamic>? map}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      child: InkWell(
        onTap: () => WorkplaceWidgets.userDetailBottomSheet(
          map: map,
          userData: user ?? User(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50), //18
              child: CachedNetworkImage(
                  placeholder: (context, url) => const ImageLoader(),
                  height: 40,
                  width: 40,
                  imageUrl: user!.profilePhoto ?? "",
                  fit: BoxFit.cover,
                  errorWidget: (
                    BuildContext context,
                    String url,
                    Object error,
                  ) {
                    return Container(color: Colors.grey);
                  }),
            ),
            SizedBox(
              width: 20.sp,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(user.name ?? '',
                      textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontSize: 16.sp)),
                  HtmlWidget(
                    description,
                    textStyle: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black.withOpacity(.6),
                      fontSize: 14,
                    ),
                  ),
                  // Text(user.name ?? '',
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: TextStyle(color: Colors.black, fontSize: 16.sp)),
                  // Text(
                  //   doc.documentElement!.text,
                  //   overflow: TextOverflow.ellipsis,
                  //   maxLines: 2,
                  //   style: TextStyle(color: Colors.black.withOpacity(.6),  fontSize: 14,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget eventListCard(
      {required String startDate,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.sp,
            width: 40.sp,
            decoration: BoxDecoration(
                color: AppColors.textBlueColor,
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  startDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 12.sp,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(title.trim(),
                //     textAlign: TextAlign.start,
                //     overflow: TextOverflow.ellipsis,
                //     style: TextStyle(
                //       height: 0.8,
                //       color: Colors.black,
                //       fontSize: 16.sp,
                //     )),
                HtmlWidget(title,
                    textStyle: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      height: 0.8,
                      color: Colors.black,
                      fontSize: 16.sp,
                    )),
                const SizedBox(
                  height: 2,
                ),
                // Text(
                //   description.trim(),
                //   textAlign: TextAlign.start,
                //   maxLines: 3,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(
                //       //height: 1.5,
                //       color: Colors.black.withOpacity(.6)),
                // ),
                HtmlWidget(description,
                    textStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        color: Colors.black.withOpacity(.6))),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget progressLoader(BuildContext context,
          {Color? color, double? height}) =>
      Container(
        width: MediaQuery.of(context).size.width,
        height: height ?? MediaQuery.of(context).size.height,
        color: color ?? Colors.transparent,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppColors.textBlueColor,
              ),
              SizedBox(height: 16), // Adjusted the spacing to a fixed height
            ],
          ),
        ),
      );

  static Widget noDataWidget(BuildContext context, String message) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message,
            style: appStyles.noDataTextStyle(),
          )
        ],
      ),
    );

    //   Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Center(child: Text( message,textAlign: TextAlign.center, style: appStyles.noDataTextStyle())),
    //   ],
    // );
  }

  static Widget linearProgressIndicatorLoader(BuildContext context,
          {Color? bgColor, Color? loaderColor}) =>
      const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GradientLinearProgressIndicator(
              strokeWidth: 1.0,
              speed: 1500,
              colors: [Color(0xffF7B500), Color(0xffB620E0), Colors.blueAccent],
            )
            // LinearProgressIndicator(minHeight: 1,
            //     backgroundColor: bgColor ?? Colors.grey.withOpacity(.4),
            //     color: loaderColor ?? Colors.blueAccent)
          ],
        ),
      );

  static Widget sliderChildren({
    Function()? onTap,
    required IconData icon,
    required String text,
    required Color iconColor,
    required Color bgColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 6, left: 10),
        height: 70,
        width: 50,
        color: bgColor,
        //const Color(0xFFe5e5e5).withOpacity(0.5),
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            Text(
              text,
              style: TextStyle(color: iconColor),
            )
          ],
        ),
      ),
    );
  }

  static Widget floatingActionButtonSection({
    required BuildContext context,
    required Function() onPressed,
    required String label,
    IconData? icon = Icons.add,
    Color? backgroundColor = AppColors.textBlueColor,
    Color? foregroundColor = Colors.white,
    double width = 130.0,
    double height = 50.0,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25, right: 16),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30), // Adjust for rounded corners
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: foregroundColor,
                  size: 20,
                ),
              if (icon != null) const SizedBox(width: 5),
              Text(
                label,
                style: appTextStyle.floatingActionButtonStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget errorPage(
      {Function()? onPressed,
      required String title,
      required String subTitle,
      String? imageUrl}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imageUrl ?? 'assets/images/wifi_logo.svg',
              height: 200,
              width: 200,
              color: Colors.black87,
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xFF191D21),
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF656F77),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      foregroundColor: AppColors.white),
                  onPressed: onPressed,
                  child: const Text(
                    'Retry',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  static Widget commonButton(
      {required Function() onClickCallBack,
      required String? title,
      Color? fontColor,
      Color? bgColor,
      Color? borderColor,
      double? height,
      double? width,
      EdgeInsetsGeometry? padding}) {
    return Material(
      borderRadius: BorderRadius.circular(4),
      color: bgColor ?? Colors.grey.shade100,
      child: InkWell(
        onTap: onClickCallBack,
        child: Container(
          width: width,
          height: height,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: borderColor ?? Colors.grey.shade300),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            title ?? "Cancel",
            style: appStyles.buttonTextStyle1(
                texColor: fontColor ?? Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
        ),
      ),
    );
  }

  static Widget cancelButton(
      {required Function() onClickCallBack,
      required String? title,
      Color? fontColor,
      Color? bgColor,
      Color? borderColor,
      double? height,
      double? width,
      EdgeInsetsGeometry? padding}) {
    return Material(
      borderRadius: BorderRadius.circular(4),
      // color: bgColor ?? Colors.grey.shade100,
      child: InkWell(
        onTap: onClickCallBack,
        child: Text(
          title ?? "Cancel",
          style: appStyles.buttonTextStyle1(
              texColor: fontColor ?? AppColors.textBlueColor,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
      ),
    );
  }

  static String parseDate(String inputDate) {
    final inputFormat = DateFormat('dd/MM/yyyy');
    final outputFormat = DateFormat('yyyy-MM-dd');
    try {
      final parsedDate = inputFormat.parse(inputDate);
      return outputFormat.format(parsedDate);
    } catch (e) {
      print('Error parsing date: $e');
      return '';
    }
  }

  static String formatDates(String inputString) {
    if (inputString.isNotEmpty) {
      DateTime dateTime = DateTime.parse(inputString);

      String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
      return formattedDate;
    } else {
      return inputString;
    }
  }

  static Widget policyWidget({
    Function()? onTap,
    String? title,
    String? content,
    int? fileCount,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10)
            .copyWith(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    HtmlWidget(
                      '$content',
                      textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                          color: Colors.black.withOpacity(.6)),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '$fileCount',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const Icon(
                      Icons.attach_file,
                      color: Colors.black,
                      size: 18,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showRequestDialog({
    required BuildContext context,
    required String title,
    String? content = '',
    Widget? customContent, // <-- for advanced formatting
    required String buttonName1,
    required String buttonName2,
    required Color disableButtonColor,
    required Color unableButtonColor,
    required Function() onPressedButton1,
    required Function() onPressedButton2,
    bool isConfirmEnabled = true,
    TextEditingController? textController,
    String? hintText,
    int maxLine = 1,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // If customContent is provided and content is empty, use customContent
                if (content!.isNotEmpty)
                  Text(
                    content,
                    textAlign: TextAlign.center,
                  )
                else if (customContent != null)
                  customContent,
                if (textController != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: textController,
                      maxLines: maxLine,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: hintText,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          contentTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: onPressedButton1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isConfirmEnabled
                            ? unableButtonColor
                            : disableButtonColor,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          buttonName1,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Flexible(
                  child: GestureDetector(
                    onTap: onPressedButton2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          buttonName2,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  static void showDynamicQuestionBottomSheet({
    required BuildContext context,

    /// Title
    required String title,
    TextStyle? titleTextStyle,

    /// Q1
    required String question1,
    required String question1RequiredSymbol,
    required List<String> question1Options,
    required Map<String, Color> question1OptionColors,

    /// Q2
    required String question2,
    required String question2RequiredSymbol,
    required List<String> question2Options,
    required Map<String, Color> question2OptionColors,

    /// Condition for showing Q2
    required bool Function(String q1Selected) showQuestion2When,

    /// Submit Callback
    required Function(String q1, String? q2) onSubmit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String? selectedQ1;
        String? selectedQ2;
        bool showingQ2 = false;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            /// Custom button
            Widget buildOptionButton({
              required String text,
              required bool isSelected,
              required Color color,
              required VoidCallback onTap,
            }) {
              return GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? color : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? color : Colors.grey.shade400,
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    /// Drag handle
                    Container(
                      width: 55,
                      height: 5,
                      margin: const EdgeInsets.only(top: 12, bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),

                    Text(
                      title,
                      style: titleTextStyle ??
                          const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// --------------------
                              /// QUESTION 1
                              /// --------------------
                              if (!showingQ2) ...[
                                Text.rich(
                                  TextSpan(
                                    text: question1,
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: question1RequiredSymbol,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),

                                Column(
                                  children: question1Options.map((opt) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: buildOptionButton(
                                        text: opt,
                                        isSelected: selectedQ1 == opt,
                                        color: question1OptionColors[opt] ??
                                            Colors.blue,
                                        onTap: () {
                                          setSheetState(() {
                                            selectedQ1 = opt;
                                          });

                                          /// If Q2 is required (e.g No)
                                          if (showQuestion2When(opt)) {
                                            setSheetState(() {
                                              showingQ2 = true;
                                            });
                                          } else {
                                            /// Return immediately and pop
                                            Navigator.pop(context);
                                            onSubmit(opt, null);
                                          }
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],

                              /// --------------------
                              /// QUESTION 2
                              /// --------------------
                              if (showingQ2) ...[
                                Text.rich(
                                  TextSpan(
                                    text: question2,
                                    style: const TextStyle(fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text: question2RequiredSymbol,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),

                                Column(
                                  children: question2Options.map((opt) {
                                    return buildOptionButton(
                                      text: opt,
                                      isSelected: selectedQ2 == opt,
                                      color: question2OptionColors[opt] ??
                                          Colors.blue,
                                      onTap: () {
                                        setSheetState(() {
                                          selectedQ2 = opt;
                                        });

                                        /// Pop and return instantly
                                        Navigator.pop(context);
                                        onSubmit(selectedQ1!, selectedQ2);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }








  static Future<void> showPrintOptionDialog({
    required BuildContext context,
    required Function({
      required String selectedOption,
      DateTime? startDate,
      DateTime? endDate,
    }) onConfirm,
  }) {
    String selectedOption = 'all';
    DateTime? startDate;
    DateTime? endDate;

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text(
                "Payment Receipt",
                textAlign: TextAlign.center,
              ),
              titleTextStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption = 'all';
                              startDate = null;
                              endDate = null;
                            });
                          },
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'all',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                    startDate = null;
                                    endDate = null;
                                  });
                                },
                                visualDensity: VisualDensity(horizontal: 4),
                                activeColor: AppColors.textBlueColor,
                              ),
                              const Text(
                                'All',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption = 'custom';
                              });
                            },
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'custom',
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                  },
                                  activeColor: AppColors.textBlueColor,
                                  visualDensity: VisualDensity(horizontal: 4),
                                ),
                                const Text(
                                  'Custom',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    //
                    // RadioListTile<String>(
                    //   title: const Text("All", style: TextStyle(color: Colors.black)),
                    //   value: 'all',
                    //   groupValue: selectedOption,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       selectedOption = value!;
                    //       startDate = null;
                    //       endDate = null;
                    //     });
                    //   },
                    //   controlAffinity: ListTileControlAffinity.platform,
                    //   activeColor: AppColors.textBlueColor,
                    //   visualDensity: const VisualDensity(vertical: -3), // Decrease vertical spacing
                    //
                    // ),
                    // RadioListTile<String>(
                    //   title: const Text("Custom"),
                    //   value: 'custom',
                    //   groupValue: selectedOption,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       selectedOption = value!;
                    //     });
                    //   },
                    //   controlAffinity: ListTileControlAffinity.platform,
                    //   activeColor: AppColors.textBlueColor,
                    //   visualDensity: const VisualDensity(vertical: -3), // Decrease vertical spacing
                    //
                    // ),
                    if (selectedOption == 'custom') ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: startDate ?? DateTime.now(),
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
                                if (picked != null) {
                                  setState(() {
                                    startDate = picked;
                                    endDate = null; // Reset endDate
                                  });
                                }
                              },
                              child: _buildDateBox(
                                label: 'Start Date',
                                value: startDate,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: startDate == null
                                  ? null
                                  : () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: endDate ??
                                            startDate!
                                                .add(const Duration(days: 1)),
                                        firstDate: startDate!,
                                        lastDate: DateTime(2100),
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData().copyWith(
                                              colorScheme:
                                                  const ColorScheme.dark(
                                                primary:
                                                    AppColors.textBlueColor,
                                                onSurface: Colors.black,
                                                onPrimary: Colors.white,
                                                surface: AppColors.white,
                                                brightness: Brightness.light,
                                              ),
                                              dialogBackgroundColor:
                                                  AppColors.white,
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          endDate = picked;
                                        });
                                      }
                                    },
                              child: AbsorbPointer(
                                absorbing: startDate == null,
                                child: _buildDateBox(
                                  label: 'End Date',
                                  value: endDate,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              contentTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: (selectedOption == 'custom' &&
                                (startDate == null || endDate == null))
                            ? null
                            : () {
                                onConfirm(
                                  selectedOption: selectedOption,
                                  startDate: startDate,
                                  endDate: endDate,
                                );
                                Navigator.pop(context);
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: (selectedOption == 'custom' &&
                                    (startDate == null || endDate == null))
                                ? Colors.grey
                                : AppColors.textBlueColor,
                          ),
                          alignment: Alignment.center,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Print",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Flexible(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          alignment: Alignment.center,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Widget _buildDateBox({required String label, DateTime? value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value != null ? projectUtil.uiShowDateFormat(value) : label,
              style: value != null
                  ? appStyles.textFieldTextStyle()
                  : appStyles.hintTextStyle(),
            ),
          ),
          const SizedBox(width: 10),
          WorkplaceWidgets.calendarIcon(),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  static void successPopup({
    required BuildContext context,
    required String content,
    required String buttonName,
    Color buttonColor = Colors.blue,
    Color buttonTextColor = Colors.white,
    VoidCallback? onButtonPressed,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => SuccessPopup(
        buttonName2: buttonName,
        content: content,
        onPressedButton2: onButtonPressed ?? () => Navigator.pop(context),
        onPressedButton2Color: buttonColor,
        onPressedButton2TextColor: buttonTextColor,
      ),
    );
  }

  static void showDeleteConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String? buttonName1,
    String? buttonName2,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WorkplaceWidgets.titleContentPopup(
          buttonName1: buttonName1 ?? AppString.cancel,
          buttonName2: buttonName2 ?? AppString.delete,
          onPressedButton1TextColor: AppColors.black,
          onPressedButton2TextColor: AppColors.white,
          onPressedButton1Color: Colors.grey.shade200,
          onPressedButton2Color: Colors.red,
          onPressedButton1: () {
            Navigator.pop(ctx);
          },
          onPressedButton2: () {
            Navigator.of(ctx).pop();
            onConfirm();
          },
          title: title,
          content: content,
        );
      },
    );
  }

  static void commonEditDeleteBottomSheet({
    required BuildContext context,
    required VoidCallback onEdit,
    bool isEdit = true,
    required VoidCallback onDeleteConfirmed,
    String deleteTitle = "Delete Item",
    String editTitle = "Edit",
    String deleteMessage = "Are you sure you want to delete this?",
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return CupertinoActionSheet(
          title: const Text(
            "Choose an Option",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          actions: [
            if (isEdit)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(ctx);
                  onEdit();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WorkplaceIcons.iconImage(
                      imageUrl: WorkplaceIcons.editIcon,
                      imageColor: AppColors.black,
                      iconSize: const Size(25, 25),
                    ),
                    SizedBox(width: 10),
                    Text(editTitle,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
              ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(ctx);
                showDeleteConfirmation(
                  context: context,
                  title: deleteTitle,
                  content: deleteMessage,
                  onConfirm: onDeleteConfirmed,
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.delete,
                      color: CupertinoColors.destructiveRed, size: 20),
                  SizedBox(width: 10),
                  Text("Delete",
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("Cancel",
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        );
      },
    );
  }

  static Future<void> showRequestDialogForRejected({
    required BuildContext context,
    required String title,
    required String content,
    required String buttonName1,
    required String buttonName2,
    required Color disableButtonColor,
    required Color unableButtonColor,
    required Function() onPressedButton1,
    required Function() onPressedButton2,
    TextEditingController? textController,
    String? hintText,
    int maxLine = 1,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          // Add StatefulBuilder for real-time UI updates
          builder: (context, setState) {
            bool isConfirmEnabled =
                textController?.text.trim().isNotEmpty ?? false;

            return AlertDialog(
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              titlePadding: const EdgeInsets.only(
                  top: 20, left: 24, right: 24, bottom: 0),
              // Adjusted padding

              titleTextStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   content,
                    //   textAlign: TextAlign.center,
                    // ),
                    if (textController != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: textController,
                          textCapitalization: TextCapitalization.sentences,
                          // <-- Added this line
                          textInputAction: TextInputAction.done,
                          maxLines: maxLine,
                          onChanged: (value) {
                            setState(() {
                              isConfirmEnabled = value.trim().isNotEmpty;
                            });
                          },
                          style: appStyles.textFieldTextStyle(),
                          // <-- Added text style

                          decoration: InputDecoration(
                            hintStyle: appStyles.hintTextStyle(),
                            // <-- Added hint style

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: hintText,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              contentTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: isConfirmEnabled ? onPressedButton1 : null,
                        // Disable tap when empty
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isConfirmEnabled
                                ? unableButtonColor
                                : disableButtonColor,
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              buttonName1,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Flexible(
                      child: GestureDetector(
                        onTap: onPressedButton2,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                              border: Border.all(
                                  width: 0.2, color: Colors.grey.shade300)),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              buttonName2,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Future<void> showDialogForCompleted({
    required BuildContext context,
    required String title,
    String? label,
    required String content,
    required String buttonName1,
    required String buttonName2,
    required Color disableButtonColor,
    required Color unableButtonColor,
    required Function() onPressedButton1,
    required Future<String?> Function() onSelectPhoto,
    required Function() onPressedButton2,
    required VoidCallback onRemovePhoto, // 👈 added
    String? selectedPhotoPath, // 👈 added
    TextEditingController? textController,
    String? hintText,
    int maxLine = 1,
    bool isLoader = false,
  }) {
    closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isConfirmEnabled =
                textController?.text.trim().isNotEmpty ?? false;

            return Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              backgroundColor: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Expanded(
                          child: Center(
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/cross_icon.svg',
                              width: 18,
                              height: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Optional text field
                    if (textController != null) ...[
                      if (label != null && label.isNotEmpty) ...[
                        Text.rich(
                          TextSpan(
                            text: label,
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
                        ),
                        const SizedBox(height: 6),
                      ],
                      TextField(
                        controller: textController,
                        maxLines: maxLine,
                        onChanged: (value) {
                          setState(() {
                            isConfirmEnabled = value.trim().isNotEmpty;
                          });
                        },
                        style: appStyles.textFieldTextStyle(),
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: appStyles.hintTextStyle(),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 0.9,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.textBlueColor,
                              width: 0.9,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    /// Photo Section
                    Text("Photo (Optional)",
                        style: appStyles.texFieldPlaceHolderStyle()),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: () async {
                        closeKeyboard();
                        if (selectedPhotoPath != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FullPhotoView(
                                title: "Photo",
                                localProfileImgUrl: selectedPhotoPath!,
                              ),
                            ),
                          );
                        } else {
                          final path = await onSelectPhoto();
                          if (path != null) {
                            setState(() {
                              selectedPhotoPath = path;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.textBlueColor,
                            width: 1,
                          ),
                        ),
                        child: selectedPhotoPath != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(selectedPhotoPath!),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        onRemovePhoto(); // 👈 update parent
                                        setState(() {
                                          selectedPhotoPath = null;
                                        });
                                      },
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
                                  Icon(Icons.add_a_photo_outlined,
                                      color: AppColors.textBlueColor, size: 28),
                                  SizedBox(height: 6),
                                  Text("Select Photo",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 2),
                                  Text("JPG, PNG, GIF (max 5MB)",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      )),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: onPressedButton2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                                border: Border.all(
                                  width: 0.2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          child: GestureDetector(
                            onTap: isConfirmEnabled && !isLoader
                                ? onPressedButton1
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isConfirmEnabled
                                    ? unableButtonColor
                                    : disableButtonColor,
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: isLoader
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      buttonName1,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> addNewItem({
    required BuildContext context,
    required TextEditingController controller,
    required VoidCallback onAddItem,
    String title = "Add New Item",
    String labelText = "Item Name",
    String hintText = "Enter item name",
    String confirmButtonText = "Add Item",
    bool isLoader = false,
  }) {
    closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isConfirmEnabled = controller.text.trim().isNotEmpty;

            return Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              backgroundColor: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Expanded(
                          child: Center(
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/cross_icon.svg',
                              width: 18,
                              height: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Label
                    Text.rich(
                      TextSpan(
                        text: labelText,
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
                    ),
                    const SizedBox(height: 6),

                    /// Text field
                    TextField(
                      controller: controller,
                      onChanged: (value) {
                        setState(() {
                          isConfirmEnabled = value.trim().isNotEmpty;
                        });
                      },
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: appStyles.hintTextStyle(),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 0.9,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: AppColors.textBlueColor,
                            width: 0.9,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                                border: Border.all(
                                  width: 0.2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          child: GestureDetector(
                            onTap: isConfirmEnabled && !isLoader
                                ? () {
                                    onAddItem();
                                  }
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isConfirmEnabled
                                    ? AppColors.textBlueColor
                                    : Colors.grey.shade400,
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: isLoader
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      confirmButtonText,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// ----------------------------------------------------------------------
// -------------------------- DIALOG FUNCTION ---------------------------
// ----------------------------------------------------------------------

  static Future<void> updateAssetStatus({
    required BuildContext context,
    required String currentStatus,
    required List<String> statusList,
    required String selectedStatus,
    required List<AssetsMemberListData> userList,
    required int? selectedUser,
    required Function(String newStatus, int? assignedUserId) onUpdate,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        String newStatus = selectedStatus;
        int? assignUser = selectedUser;

        /// ----------------- Status Color Logic -----------------
        Color getStatusColor(String status) {
          switch (status.toLowerCase()) {
            case 'completed':
              return const Color(0xFFD3D3D3);
            case "didn't pick":
              return const Color(0xFFFFE0B2);
            case 'agreed':
              return const Color(0xFFC8E6C9);
            case 'follow up':
              return const Color(0xFFBBDEFB);
            case 'open':
              return const Color(0xFFFFCDD2);
            case 'all status':
              return const Color(0xFFE0F7FA);
            case 'cancelled':
              return const Color(0xFFF8BBD0);
            case 'approved':
              return const Color(0xFFC8E6C9);
            case 'rejected':
              return const Color(0xFFFFCDD2);
            case 'pending':
              return const Color(0xFFFFF9C4);
            case 'available':
              return const Color(0xFFBBDEFB);
            case 'not available':
              return const Color(0xFFFFCDD2);
            case 'assigned':
              return const Color(0xFFD1C4E9);
            case 'defected':
              return const Color(0xFFFFAB91);
            case 'under maintenance':
              return const Color(0xFFFFF59D);
            case 'lost':
              return const Color(0xFFB3E5FC);
            case 'non functional':
              return const Color(0xFFBDBDBD);
            default:
              return const Color(0xFFE0E0E0);
          }
        }

        /// ----------------- Status Text Color Logic -----------------
        Color getStatusTextColor(String status) {
          switch (status.toLowerCase()) {
            case 'completed':
              return Colors.black87;
            case "didn't pick":
              return Colors.orange;
            case 'agreed':
              return Colors.green;
            case 'follow up':
              return Colors.blue;
            case 'open':
              return Colors.red;
            case 'all status':
              return Colors.teal;
            case 'cancelled':
              return Colors.pink;
            case 'approved':
              return Colors.green;
            case 'rejected':
              return Colors.red.shade700;
            case 'pending':
              return Colors.amber.shade700;
            case 'available':
              return Colors.blue.shade700;
            case 'not available':
              return Colors.red.shade700;
            case 'assigned':
              return Colors.deepPurple.shade700;
            case 'defected':
              return Colors.deepOrange.shade700;
            case 'under maintenance':
              return Colors.amber.shade800;
            case 'lost':
              return Colors.lightBlue.shade900;
            case 'non functional':
              return Colors.grey.shade900;
            default:
              return Colors.black87;
          }
        }

        return StatefulBuilder(
          builder: (context, setState) {
            bool isUpdateEnabled = newStatus.isNotEmpty &&
                (newStatus != "assigned" || assignUser != null);

            return Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              backgroundColor: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Update Asset Status",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/cross_icon.svg',
                              width: 18,
                              height: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Center(
                      child: Text(
                        "Change the status of this asset.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Current Status
                    Text("Current Status",
                        style: appStyles.texFieldPlaceHolderStyle()),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: getStatusColor(currentStatus),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              currentStatus.isNotEmpty
                                  ? currentStatus[0].toUpperCase() +
                                      currentStatus.substring(1)
                                  : '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: getStatusTextColor(currentStatus),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// New Status Dropdown
                    Text("New Status",
                        style: appStyles.texFieldPlaceHolderStyle()),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      focusColor: Colors.white,
                      // hintStyle: appStyles.hintTextStyle(),
                      // textStyle: appStyles.textFieldTextStyle(),
                      dropdownColor: Colors.white,
                          hint: Text("Select new status",    style: appStyles.hintTextStyle(),),
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.grey),
                      value: statusList.contains(newStatus)
                          ? newStatus
                          : null, // ✅ safe check
                      items: statusList.map((status) {
                        final display =
                            status[0].toUpperCase() + status.substring(1);
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(display,
                              style: appStyles.textFieldTextStyle()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          newStatus = val ?? "";
                          if (newStatus != "assigned") assignUser = null;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 0.9),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: AppColors.textBlueColor, width: 1.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 0.9),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Assign to User Dropdown (only when status = "Assigned")
                    if (newStatus.toLowerCase() == "assign") ...[
                      Text.rich(
                        TextSpan(
                          text: "Assign to User",
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
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        focusColor: Colors.white,
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey),
                        value: assignUser,
                        hint: Text("Select a User",
                          style: appStyles.hintTextStyle(),),
                        items: userList.map((user) {
                          return DropdownMenuItem<int>(
                            value: user.id,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage: user.profilePhoto != null &&
                                          user.profilePhoto!.isNotEmpty
                                      ? NetworkImage(user.profilePhoto!)
                                      : const AssetImage(
                                              'assets/images/default_user.png')
                                          as ImageProvider,
                                ),
                                const SizedBox(width: 10),
                                Text(user.name ?? "Unknown",
                                    style: appStyles.textFieldTextStyle()),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => assignUser = val);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.grey.shade400, width: 0.9),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: AppColors.textBlueColor, width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.grey.shade400, width: 0.9),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    /// Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                                border: Border.all(
                                  width: 0.2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          child: GestureDetector(
                            onTap: isUpdateEnabled
                                ? () {
                                    onUpdate(newStatus, assignUser);
                                  }
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isUpdateEnabled
                                    ? AppColors.textBlueColor
                                    : Colors.grey.shade400,
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                "Update Status",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static errorPopUp({
    required BuildContext context,
    required String content,
    required Function() onTap,
    bool isShowIcon = false,
    IconData? icon,
    Color? iconColor, // ✅ NEW PARAMETER
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(vertical: 28, horizontal: 25)
            .copyWith(bottom: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: isShowIcon,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Icon(
                  icon ?? Icons.error_outline,
                  color: iconColor ?? Colors.red,
                  // ✅ Use passed color or default red
                  size: 48,
                ),
              ),
            ),
            Text(
              content,
              textAlign: TextAlign.center,
              style: appStyles.subTitleStyle(
                fontSize: AppDimens().fontSize(value: 16),
                fontWeight: FontWeight.w200,
                texColor: AppColors.black,
                fontFamily: AppFonts().defaultFont,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        actions: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: AppColors.textBlueColor,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppString.ok,
                      style: appStyles.subTitleStyle(
                        fontSize: AppDimens().fontSize(value: 15),
                        fontWeight: FontWeight.w500,
                        texColor: AppColors.appWhite,
                        fontFamily: AppFonts().defaultFont,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget floatingActionButtonWidget({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
    double? width,
    double? height,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 25, right: 16),
        child: SizedBox(
          width: width ?? 125.0,
          height: height ?? 60.0,
          child: FloatingActionButton(
            backgroundColor: backgroundColor ?? AppColors.textBlueColor,
            foregroundColor: textColor ?? Colors.white,
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor ?? AppColors.white,
                  size: 28,
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: appStyles.hStyle11().copyWith(
                        color: textColor ?? Colors.white,
                      ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      );
}

class SuccessPopup extends StatefulWidget {
  final String buttonName2;
  final String? title;
  final String content;
  final Color? onPressedButton2TextColor;
  final Color? onPressedButton2Color;
  final Function()? onPressedButton2;

  const SuccessPopup({
    Key? key,
    required this.buttonName2,
    this.title,
    required this.content,
    this.onPressedButton2TextColor,
    this.onPressedButton2Color,
    this.onPressedButton2,
  }) : super(key: key);

  @override
  _SuccessPopupState createState() => _SuccessPopupState();
}

class _SuccessPopupState extends State<SuccessPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: const EdgeInsets.symmetric(vertical: 28, horizontal: 25)
          .copyWith(bottom: 20),
      actionsPadding: const EdgeInsets.only(bottom: 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: const Icon(
              Icons.check_circle,
              size: 55,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: widget.onPressedButton2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: widget.onPressedButton2Color ?? Colors.grey.shade200,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.buttonName2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: widget.onPressedButton2TextColor ?? Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
