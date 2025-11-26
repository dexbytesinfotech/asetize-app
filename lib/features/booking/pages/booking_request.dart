import 'package:intl/intl.dart';

import '../../../imports.dart';
import '../models/booking_rules_screen.dart';
import '../widgets/drop_down_widget.dart';
import '../widgets/label_widget.dart';

class BookingRequest extends StatefulWidget {
  const BookingRequest({super.key});

  @override
  State<BookingRequest> createState() => _BookingRequestState();
}

class _BookingRequestState extends State<BookingRequest> {
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  final List<String> amenityType = ['Community Hall','Garden','Swimming Pool','Indoor Games Room',
    'Terrace Area','Meeting Room'];

  final List<String> eventType = ['Birthday Party','Anniversary Celebration',
    'Wedding Reception','Community Get-togethers'] ;

  final Map<String, TextEditingController> controllers = {
    'amenityType': TextEditingController(),
    'eventType': TextEditingController(),
    'eventDetail': TextEditingController(),
    'inHouseGuest': TextEditingController(),
    'outSideGuest': TextEditingController(),
  };
  final Map<String, FocusNode> focusNodes = {
    'amenityType': FocusNode(),
    'eventType': FocusNode(),
    'eventDetail': FocusNode(),
    'inHouseGuest': FocusNode(),
    'outSideGuest': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'amenityType': "",
    'eventType': "",
    'eventDetail': "",
    'inHouseGuest': "",
    'outSideGuest': "",
  };

  String? selectedAmenity;
  String? selectedEventType;
  DateTime? dateStart;
  DateTime? dateEnd;
  DateTime? dateSingle;
  String startDateErrorMessage = '';
  String dateErrorMessage = '';
  String selectDayErrorMessage = '';
  String selectSingleMultipleDay = '';
  int difference = -1;


  checkAmenityType(value, vehicleType, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.isNotEmpty(value.trim())) {
          errorMessages[vehicleType] = "";
        } else {
          if (!onchange) {
            errorMessages[vehicleType] = AppString.trans(
              context,'Please select amenity type',
            );
          }
        }
      });
    } else {
      setState(() {
        if (!onchange) {
          if (vehicleType == 'amenityType') {
            errorMessages[vehicleType] = AppString.trans(
              context,
              'Please select amenity type',
            );
          }
        }
      });
    }
  }

  void showAmenityTypeBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title:'Select Amenity Type',
      valuesList: amenityType,
      selectedValue: controllers['amenityType']!.text,
      onValueSelected: (value) {
        setState(() {
          controllers['amenityType']?.text = value;
          selectedAmenity = value;
          errorMessages['amenityType'] = "";
        });
      },
    );
  }

  Widget amenityTypeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          showAmenityTypeBottomSheet(context);
          closeKeyboard();          closeKeyboard();

        },
        child: AbsorbPointer(
          child: CommonTextFieldWithError(
            key: ValueKey(controllers['amenityType']?.text),
            focusNode: focusNodes['amenityType'],
            isShowBottomErrorMsg: true,
            errorMessages: errorMessages['amenityType']?.toString() ?? '',
            controllerT: controllers['amenityType'],
            borderRadius: 8,
            inputHeight: 50,
            errorLeftRightMargin: 0,
            maxCharLength: 50,
            readOnly: true,
            errorMsgHeight: 24,
            autoFocus: false,
            inputFieldSuffixIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
            enabledBorderColor: Colors.white,
            focusedBorderColor: Colors.white,
            hintStyle: appStyles.textFieldTextStyle(
                fontWeight: FontWeight.w400,
                texColor: Colors.grey.shade600,
                fontSize: 14),

            showError: true,
            capitalization: CapitalizationText.none,
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.done,
            borderStyle: BorderStyle.solid,
            cursorColor: Colors.grey,
            hintText:'Select Amenity Type',
            placeHolderTextWidget: LabelWidget(labelText:'Amenity Type'),
            textStyle: appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
            contentPadding: const EdgeInsets.only(left: 15, right: 15),
            onTextChange: (value) {
              selectedAmenity = value;
            },
            onEndEditing: (value) {
              checkAmenityType(value, 'amenityType', onchange: true);
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  Widget selectDayField() => Column(
    children: [
      LabelWidget(labelText:'Select Day' ),
      CommonDropdown(
        hintText: 'Select Day',
        items: const [
          DropdownMenuItem(
            value: 'full_day',
            child: Text('Single Day'),
          ),
          DropdownMenuItem(
            value: 'multiple',
            child: Text('Multiple Days'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectSingleMultipleDay = value.toString();
            if (selectSingleMultipleDay.isEmpty) {
              selectDayErrorMessage = "";
            } else {
              selectDayErrorMessage = "";
            }
          });
        },
        value: selectSingleMultipleDay.isEmpty ? null : selectSingleMultipleDay,
      ),
    ],
  );

  Widget selectDayErrorText() => (selectDayErrorMessage != '')
      ? Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 8, top: 2),
      height: 18,
      child: Text(
        selectDayErrorMessage,
        style: appStyles.errorStyle(),
      ))
      : Container(height: 0.5);

  Widget starDateErrorText() {
    bool isFullDay = selectSingleMultipleDay == "multiple";
    String errorText = isFullDay ? startDateErrorMessage : dateErrorMessage;

    if (errorText.isNotEmpty) {
      return Row(
        mainAxisAlignment: (errorText == "Please select end date")
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 4, top: 2,right: 50),
            height: 18,
            child: Text(
              errorText,
              style: appStyles.errorStyle(),
            ),
          ),
        ],
      );
    } else {
      return Container(height: 0.5);
    }
  }

  String startDateText() {
    if (dateStart == null) {
      return "Start Date";
    } else {
      return DateFormat('dd/MM/yyyy').format(dateStart!);
    }
  }

  String endDateText() {
    if (dateEnd == null && dateStart == null) {
      return "End Date";
    } else {
      //return DateFormat('dd/MM/yyyy').format(dateEnd == null ? dateStart! : dateEnd!);
      if (dateEnd == null) {
        return "End Date";
      } else {
        return DateFormat('dd/MM/yyyy').format(dateEnd!);
      }
    }
  }

  String singleDateText() {
    if (dateSingle == null) {
      return "Select Date";
    } else {
      return DateFormat('dd/MM/yyyy').format(dateSingle!);
    }
  }

  static String parseDate(String inputDate) {
    final inputFormat = DateFormat('dd/MM/yyyy');
    final outputFormat = DateFormat('yyyy-MM-dd');
    try {
      final parsedDate = inputFormat.parse(inputDate);
      return outputFormat.format(parsedDate);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return '';
    }
  }

  void startDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        fieldLabelText: "Start Date",
        initialDate: dateStart ?? DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime.now(),
        //DateTime(DateTime.now().year),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month + 12, DateTime.now().day),
        // confirmText: "Ok",
        builder: (context, child) {
          return Theme(
              data: ThemeData().copyWith(
                // brightness:!isDarkMode? Brightness.light:Brightness.dark,
                  colorScheme: const ColorScheme.dark(
                      primary: AppColors.appBlueColor,
                      onSurface: Colors.black,
                      onPrimary: Colors.white,
                      surface: AppColors.white,
                      brightness: Brightness.light),
                  dialogBackgroundColor: AppColors.white),
              child: child!);
        });
    if (newDate == null) return;

    setState(() {
      dateStart = newDate;
      if (dateEnd != null) {
        String? startDate = DateFormat('dd/MM/yyyy').format(dateStart!);
        try {
          DateTime date = DateFormat("yyyy-MM-dd").parse(parseDate(startDate));
          DateTime newDate = DateTime(date.year, date.month, date.day);
          DateTime nowDate = DateTime(dateEnd!.year, dateEnd!.month, dateEnd!.day);
          Duration diff = nowDate.difference(newDate);
          difference = diff.inDays;
          debugPrint('$difference');
          // If end date smaller than start date ...assign null to end date
          if (difference <= -1) {
            dateEnd = null;
          }
        } catch (e) {
          difference = -1;
        }
      }
      if (dateStart != null) {
        startDateErrorMessage = "";
      }
    });
  }

  void endDate(BuildContext context) async {
    DateTime startDate = dateStart!;
    // Calculate the first valid end date (next Monday if start date is Friday)
    DateTime firstValidEndDate;
      firstValidEndDate = startDate.add(const Duration(days: 1)); // Tomorrow
    final newDate = await showDatePicker(
      context: context,
      fieldLabelText: "DOB",
      initialDate: dateEnd ?? firstValidEndDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: firstValidEndDate,
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month + 12, dateStart!.day),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.dark(
                primary: AppColors.appBlueColor,
                onSurface: Colors.black,
                onPrimary: Colors.white,
                surface: AppColors.white,
                brightness: Brightness.light),
            dialogBackgroundColor: AppColors.white,
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return;

    setState(() {
      dateEnd = newDate;
      if (dateEnd != null) {
        startDateErrorMessage = "";
        dateErrorMessage = "";
      }
    });
  }

  Widget date() => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        child: Container(
          height: 45,
          padding: const EdgeInsets.only(left: 12, right: 15, top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(
              //   width: 1,
              //   color: startDateErrorMessage != ''
              //       ? Colors.red
              //       : Colors.transparent,
              // ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 3,
                    offset: const Offset(0, 1),
                    blurRadius: 3)
              ]),
          child: InkWell(
            onTap: () {
              startDate(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.calendar_month,size: 20,color: Colors.grey,),
                const SizedBox(
                  width: 10,
                ),
                Text(startDateText().toString(),
                    style: appStyles.userJobTitleTextStyle(
                        fontSize: 14,
                        texColor: dateStart != null
                            ? Colors.black
                            : Colors.grey.shade600)),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 15,
      ),
      Flexible(
        child: Container(
          height: 45,
          padding: const EdgeInsets.only(
              left: 12, right: 15, top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 3,
                    offset: const Offset(0, 1),
                    blurRadius: 3)
              ]),
          child: InkWell(
            onTap: () {
              if (dateStart != null) {
                endDate(context);
              } else {
                WorkplaceWidgets.successToast('Please select the start date first',durationInSeconds: 1);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.calendar_month,size: 20,color: Colors.grey,),
                const SizedBox(
                  width: 10,
                ),
                Text(endDateText().toString(),
                    style: appStyles.userJobTitleTextStyle(
                        fontSize: 14,
                        texColor: dateEnd != null || dateStart != null
                            ? Colors.black
                            : Colors.grey.shade600)),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  void singleDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        fieldLabelText: "DOB",
        initialDate: dateSingle ?? DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime.now(),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month + 12, DateTime.now().day),
        builder: (context, child) {
          return Theme(
              data: ThemeData().copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: AppColors.appBlueColor,
                      onSurface: Colors.black,
                      onPrimary: Colors.white,
                      surface: AppColors.white,
                      brightness: Brightness.light),
                  dialogBackgroundColor: AppColors.white),
              child: child!);
        });
    if (newDate == null) return;

    setState(() {
      dateSingle = newDate;
      if (dateSingle != null) {
        dateErrorMessage = "";
      }
    });
  }

  Widget singleDateWidget() => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        child: Container(
          height: 45,
          padding: const EdgeInsets.only(
              left: 12, right: 15, top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 3,
                    offset: const Offset(0, 1),
                    blurRadius: 3)
              ]),
          child: InkWell(
            onTap: () {
              singleDate(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.calendar_month,size: 20,color: Colors.grey,),
                const SizedBox(
                  width: 10,
                ),
                Text(
                   singleDateText().toString(),
                    style: appStyles.userJobTitleTextStyle(
                        fontSize: 14,
                        texColor: dateSingle != null
                            ? Colors.black
                            : Colors.grey.shade600)),
              ],
            ),
          ),
        ),
      ),
    ],
  );
  //event type
  checkEventType(value, vehicleType, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.isNotEmpty(value.trim())) {
          errorMessages[vehicleType] = "";
        } else {
          if (!onchange) {
            errorMessages[vehicleType] = AppString.trans(
              context,
              'Please select event type',
            );
          }
        }
      });
    } else {
      setState(() {
        if (!onchange) {
          if (vehicleType == 'eventType') {
            errorMessages[vehicleType] = AppString.trans(
              context,
              'Please select event type',
            );
          }
        }
      });
    }
  }


  void showEventBottomSheet(BuildContext context) {
    // Similar to showVehicleTypeBottomSheet
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: 'Select Event Type',
      valuesList: eventType, // Example visiting types
      selectedValue: controllers['eventType']!.text,
      onValueSelected: (value) {
        setState(() {
          controllers['eventType']?.text = value;
          errorMessages['eventType'] = ""; // Clear error message
        });
      },
    );
  }

  Widget eventTypeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          eventType.isNotEmpty
              ? showEventBottomSheet(context)
              : null;
          closeKeyboard();
        },
        child: AbsorbPointer(
          child: CommonTextFieldWithError(
            focusNode: focusNodes['eventType'],
            isShowBottomErrorMsg: true,
            errorMessages:
            errorMessages['eventType']?.toString() ?? '',
            controllerT: controllers['eventType'],
            borderRadius: 8,
            inputHeight: 50,
            errorLeftRightMargin: 0,
            maxCharLength: 50,
            errorMsgHeight: 24,
            autoFocus: false,
            showError: true,
            readOnly: true,
            capitalization: CapitalizationText.characters,
            cursorColor: Colors.grey,
            inputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            placeHolderTextWidget: LabelWidget(labelText:'Event Type'),
            enabledBorderColor: Colors.white,
            focusedBorderColor: Colors.white,
            hintStyle: appStyles.textFieldTextStyle(
                fontWeight: FontWeight.w400,
                texColor: Colors.grey.shade600,
                fontSize: 14),
            textStyle:
            appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.next,
            borderStyle: BorderStyle.solid,
            inputFieldSuffixIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
            inputKeyboardType: InputKeyboardTypeWithError.text,
            hintText: 'Select Event Type',
            contentPadding: const EdgeInsets.only(left: 15, right: 15),
            onTextChange: (value) {
              // checkOrganizationName(value, onchange: true);
            },
            onEndEditing: (value) {
              checkEventType(value, 'eventType', onchange: true);
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }
// Event detail
  eventDetailField() {
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
            focusNode: focusNodes['reason'],
            isShowBottomErrorMsg: true,
            errorMessages: errorMessages['reason']?.toString() ?? '',
            controllerT: controllers['reason'],
            borderRadius: 8,
            inputHeight: 100,
            errorLeftRightMargin: 0,
            maxCharLength: 220,
            errorMsgHeight: 18,
            maxLines: 5,
            autoFocus: false,
            showError: true,
            showCounterText: false,
            capitalization: CapitalizationText.sentences,
            cursorColor: Colors.grey,
            enabledBorderColor: Colors.white,
            focusedBorderColor: Colors.white,
            hintStyle: appStyles.textFieldTextStyle(
                fontWeight: FontWeight.w400,
                texColor: Colors.grey.shade600,
                fontSize: 14),
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.newline,
            borderStyle: BorderStyle.solid,
            inputKeyboardType: InputKeyboardTypeWithError.multiLine,
            placeHolderTextWidget: LabelWidget(labelText:'Event Details',isRequired: false, ),
            hintText: "Enter Event Details",
            textStyle:
            appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
            contentPadding: const EdgeInsets.only(
                left: 15, right: 15, top: 10, bottom: 10),
            onTextChange: (value) {
            },
            onEndEditing: (value) {
              FocusScope.of(context).requestFocus(focusNodes['password']);
            },
          ),
        /*  // Character count display
          Padding(
            padding: const EdgeInsets.only(top: 0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${controllers['reason']?.text.length}/220', // Display character count
                  style: appStyles.appNormalSmallTextStyle(
                    color: controllers['reason']!.text.length >= 220
                        ? Colors.red
                        : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
// number of guest

  checkInHouseGuest(value, fieldEmail, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.isNotEmpty(value.trim())) {
          errorMessages[fieldEmail] = "";
        } else {
          if (!onchange) {
            errorMessages[fieldEmail] =
                'Please enter house guest';
          }
        }
      });
    } else {
      setState(() {
        if (!onchange) {
          if (fieldEmail == 'reason') {
            errorMessages[fieldEmail] =
            'Please enter house guest';
          }
        }
      });
    }
  }
  Widget houseGuestField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFf9fafb),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.white, // Set shadow color to transparent
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['inHouseGuest']?.toString() ?? '',
        controllerT: controllers['inHouseGuest'],
        focusNode: focusNodes['inHouseGuest'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 24,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.characters,
        cursorColor: Colors.grey,
        inputFormatter: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        placeHolderTextWidget:LabelWidget(labelText: 'House Guests'),
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.number,
        hintText: 'Enter House Guest',
        enabledBorderColor: Colors.white,
        focusedBorderColor: Colors.white,
        hintStyle: appStyles.textFieldTextStyle(
            fontWeight: FontWeight.w400,
            texColor: Colors.grey.shade600,
            fontSize: 14),
        textStyle:
        appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          checkInHouseGuest(value,'inHouseGuest' ,onchange: true);
        },
        onEndEditing: (value) {
          checkInHouseGuest(value,'inHouseGuest');
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
  checkOutSideGuest(value, fieldEmail, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.isNotEmpty(value.trim())) {
          errorMessages[fieldEmail] = "";
        } else {
          if (!onchange) {
            errorMessages[fieldEmail] =
            'Please enter outside guest';
          }
        }
      });
    } else {
      setState(() {
        if (!onchange) {
          if (fieldEmail == 'reason') {
            errorMessages[fieldEmail] =
            'Please enter outside guest';
          }
        }
      });
    }
  }
  Widget outsideGuestField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFf9fafb),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.white, // Set shadow color to transparent
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['outSideGuest']?.toString() ?? '',
        controllerT: controllers['outSideGuest'],
        focusNode: focusNodes['outSideGuest'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 24,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.characters,
        cursorColor: Colors.grey,
        inputFormatter: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        placeHolderTextWidget:LabelWidget(labelText: 'Outside Guests'),
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.number,
        hintText: 'Enter Outside Guests',
        enabledBorderColor: Colors.white,
        focusedBorderColor: Colors.white,
        hintStyle: appStyles.textFieldTextStyle(
            fontWeight: FontWeight.w400,
            texColor: Colors.grey.shade600,
            fontSize: 14),
        textStyle:
        appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          checkOutSideGuest(value,'outSideGuest' ,onchange: true);
        },
        onEndEditing: (value) {
          checkOutSideGuest(value,'outSideGuest');
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
  //Validation
  bool validateFields({bool isButtonClicked = false}) {
    if (controllers['amenityType']?.text == null ||
        controllers['amenityType']?.text == '') {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              errorMessages['amenityType'] = 'Please select amenity type';
            });
          }
        });
      }
      return false;
    }  else if  (selectSingleMultipleDay.isEmpty) {
      if (isButtonClicked) {
        setState(() {
          selectDayErrorMessage = "Please select day";

        });
      }
      return false;
    }else if (selectSingleMultipleDay == "multiple"
        ? dateStart == null
        : dateSingle == null) {
      if (isButtonClicked) {
        setState(() {
          startDateErrorMessage = "Please select start date";
          // dateErrorMessage = "Please select the date";
          dateErrorMessage = selectSingleMultipleDay == "multiple"
              ? "Please select start date"
              : "Please select the date";
        });
      }
      return false;
    } else if (selectSingleMultipleDay == "multiple" && dateEnd == null) {
      if (isButtonClicked) {
        setState(() {
          startDateErrorMessage = "Please select end date";
          dateErrorMessage = "Please select end date";
        });
      }
      return false;
    } else if (controllers['eventType']?.text == null ||
        controllers['eventType']?.text == '') {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              errorMessages['eventType'] = 'Please select event type';
            });
          }
        });
      }
      return false;
    }else if (controllers['inHouseGuest']?.text == null ||
        controllers['inHouseGuest']?.text == '') {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              errorMessages['inHouseGuest'] = 'Please enter house guest';
            });
          }
        });
      }
      return false;
    }else if (controllers['outSideGuest']?.text == null ||
        controllers['outSideGuest']?.text == '') {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              errorMessages['outSideGuest'] = 'Please enter outside guest';
            });
          }
        });
      }
      return false;
    }

    else {
      return true;
    }
  }


  button() {
    return AppButton(
      buttonName: 'View Rules & Continue',
      buttonColor: (validateFields()) ? AppColors.textBlueColor : Colors.grey,
      // buttonColor: (validateFields(isButtonClicked: true))
      //     ? AppColors.textBlueColor
      //     : Colors.grey, // Button color based on validation
      textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
      backCallback: () {
        if (validateFields(isButtonClicked: true)) {
          Navigator.push(MainAppBloc.getDashboardContext, SlideLeftRoute(widget:  const BookingRules()));
        }

        // Navigator.push(MainAppBloc.getDashboardContext, MaterialPageRoute(builder: (context) => const BookingRules()));

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isListScrollingNeed: false,
        isFixedDeviceHeight: false,
        appBarHeight: 56,
        appBar: CommonAppBar(
          title: 'Booking request',
          isHideIcon: false,
        ),
        containChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
          child: Column(
            children: [
              amenityTypeField(),
              //SizedBox(height: 20,),
              selectDayField(),
              selectDayErrorText(),
              const SizedBox(
                height: 20,
              ),
              LabelWidget(labelText:'Select Date' ),
              selectSingleMultipleDay == 'multiple' ? date() : singleDateWidget(),
              starDateErrorText(),
              SizedBox(height: 20,),
              eventTypeField(),
             // SizedBox(height: 20,),
              eventDetailField(),
              houseGuestField(),
              outsideGuestField(),
              SizedBox(height: 30,),
              button()
            ],
          ),
        )


    );
  }
}
