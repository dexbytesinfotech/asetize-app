import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:intl/intl.dart';
import 'package:asetize/features/my_visitor/models/visitor_model.dart' as VisitorModel;
import 'package:permission_handler/permission_handler.dart';
import 'package:asetize/features/my_visitor/bloc/my_visitor_event.dart';
import '../../../imports.dart';
import '../../my_unit/models/created_visitor_pass_detail_model.dart';
import '../../presentation/widgets/new_button_for_preApproval.dart';
import '../bloc/my_visitor_bloc.dart';
import '../bloc/my_visitor_state.dart';
import 'add_pre_register_visitor_manually.dart';
import 'my_mobile_fetch_contact_list.dart';

class PreRegisterVisitorForm extends StatefulWidget {
  final int? houseId;
  final int? nocId;
  final int? visitorEntryId;
  final String? visitorType;
  final String? visitPurpose;
  final String? selectHouseNumber;
  final String? visitorName;
  final String? visitorNumber;
  final bool isComingFromNoc;
  final bool isShowContactList;
  final bool isBottomSheetDisable;
  final CreatedVisitorPassDetailData? createdVisitorPassDetailData;


  final List<VisitorModel.VisitorData>? editUpComingVisitorsData ;
   const PreRegisterVisitorForm({super.key, this.visitorType, this.selectHouseNumber='', this.visitPurpose, this.visitorName, this.visitorNumber, this.houseId, this.isComingFromNoc=false, this.isBottomSheetDisable = true, this.editUpComingVisitorsData, this.nocId, this.visitorEntryId, this.createdVisitorPassDetailData, this.isShowContactList= true});
  @override
  State<PreRegisterVisitorForm> createState() => _PreRegisterVisitorFormState();
}
class _PreRegisterVisitorFormState extends State<PreRegisterVisitorForm> {
  String? verificationCode;
  int? visitorId;
  String? _visitingType;
  Houses? selectedUnit;
  List<Houses> houses = [];
  late HomeBloc homeBloc;
  List<Houses>? housesData;
  List<int> houseId = [];
  late UserProfileBloc userProfileBloc;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<String> availableTimeSlots = [];
  Map<String, String> timeSlots = {};
  String? _selectedTimeSlot;



  List<String> organizationList = [];
  bool isFormValid = false;

  void parseAndAssignEntryTime(String? entryTime) {
    String input = entryTime?.trim() ?? "Today, ${DateTime.now().hour}:${DateTime.now().minute}";

    String datePart = "Today";
    String timePart = "00:00";

    if (input.toLowerCase().startsWith("today")) {
      List<String> parts = input.split(', ');
      datePart = parts[0];
      timePart = parts.length > 1 ? parts[1] : "00:00";
    } else if (input.contains(" at ")) {
      List<String> parts = input.split(" at ");
      datePart = parts[0];
      timePart = parts.length > 1 ? parts[1] : "00:00";
    } else {
      List<String> parts = input.split(', ');
      datePart = parts[0];
      timePart = parts.length > 1 ? parts[1] : "00:00";
    }

    String formattedDate;
    DateTime now = DateTime.now();

    if (datePart.toLowerCase() == "today") {
      formattedDate = DateFormat('d MMMM, yyyy').format(now);
    } else {
      try {
        DateTime parsedDate = DateFormat('d MMMM, yyyy').parse('$datePart, ${now.year}');
        formattedDate = DateFormat('d MMMM, yyyy').format(parsedDate);
      } catch (e) {
        try {
          DateTime parsedDate = DateFormat('d MMMM').parse(datePart);
          parsedDate = DateTime(now.year, parsedDate.month, parsedDate.day);
          formattedDate = DateFormat('d MMMM, yyyy').format(parsedDate);
        } catch (e) {
          formattedDate = DateFormat('d MMMM, yyyy').format(now);
        }
      }
    }

    String? selectedSlot;
    try {
      DateTime parsedTime = DateFormat('H:mm').parse(timePart);
      int hour = parsedTime.hour;
      for (var slot in timeSlots.keys) {
        int slotHour = int.parse(slot.split(':')[0]);
        if (hour >= slotHour && hour < slotHour + 3) {
          selectedSlot = timeSlots[slot];
          break;
        }
      }
    } catch (e) {
      selectedSlot = timeSlots.isNotEmpty ? timeSlots.values.first : "";
    }

    controllers['date']?.text = formattedDate;
    controllers['time']?.text = selectedSlot ?? "";
    _selectedTimeSlot = selectedSlot;
  }


  final Map<String, TextEditingController> controllers = {
    'visitorType': TextEditingController(),
    'visitPurpose': TextEditingController(),
    'selectHouseNumber': TextEditingController(),
    'date': TextEditingController(),
    'time': TextEditingController(),
  };

  final Map<String, FocusNode> focusNodes = {
    'visitorType': FocusNode(),
    'visitPurpose': FocusNode(),
    'selectHouseNumber': FocusNode(),
    'date': FocusNode(),
    'time': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'visitorType': "",
    'visitPurpose': "",
    'selectHouseNumber': "",
    'date': "",
    'time': "",
  };

  List visitorTypeData = [];
  List<String> visitorTypeList = [];
  void assignVisitorValuesToControllers() {
    controllers['visitorType']?.text = widget.visitorType ?? "";
    controllers['visitPurpose']?.text = widget.visitPurpose ?? "";
    controllers['selectHouseNumber']?.text = widget.selectHouseNumber ?? selectedUnit?.title ?? "";
    widget.visitorName ?? "";
    widget.visitorNumber??'';

  }


  void setData() {
    if(widget.editUpComingVisitorsData==null){
      return ;
    }
    controllers['visitorType']?.text = formatVisitingType(widget.editUpComingVisitorsData?.first.visitorType ?? "");
    controllers['visitPurpose']?.text = widget.editUpComingVisitorsData?.first.organization?? "";
    controllers['selectHouseNumber']?.text = widget.editUpComingVisitorsData?.first.housesNames ?? "";
    String? entryTime = widget.editUpComingVisitorsData?.first.entryTime ?? "";
    parseAndAssignEntryTime(entryTime);
    preFillContact(
        visitorName:  widget.editUpComingVisitorsData?.first.name ?? "",
        visitorNumber:widget.editUpComingVisitorsData?.first.phone ?? "",
      selectedContacts: selectedContacts,
    );
  }
  void setVisitorPassDetailData() {
    if (widget.createdVisitorPassDetailData == null) {
      return;
    }

    // Prefill form fields
    controllers['visitorType']?.text =
        formatVisitingType(widget.createdVisitorPassDetailData?.visitorType ?? "");
    controllers['visitPurpose']?.text =
        widget.createdVisitorPassDetailData?.organization ?? "";
    controllers['selectHouseNumber']?.text =
        widget.createdVisitorPassDetailData?.housesNames ?? "";
    preFillContact(
      visitorName: widget.visitorName ?? "",
      visitorNumber: widget.visitorNumber ?? "",
      selectedContacts: selectedContacts,
    );

    // Handle date parsing
    final originalEntryTime = widget.createdVisitorPassDetailData?.originalEntryTime;
    DateTime parsedDate;

    if (originalEntryTime != null && originalEntryTime.isNotEmpty) {
      try {
        // Assuming originalEntryTime is in ISO 8601 format (e.g., "2025-06-06T10:00:00Z")
        parsedDate = DateTime.parse(originalEntryTime);
      } catch (e) {
        // Log parsing error for debugging
        print('Error parsing originalEntryTime: $e');
        parsedDate = DateTime.now(); // Fallback to current date
      }
    } else {
      parsedDate = DateTime.now(); // Fallback to current date
    }

    setState(() {
      _selectedDate = parsedDate; // Update _selectedDate for the calendar
      controllers['date']?.text = DateFormat('d MMM, yyyy').format(parsedDate);
      updateAvailableTimeSlots(); // Update time slots based on the selected date
      checkDate(controllers['date']!.text, 'date', onchange: true);
    });
  }  // void setVisitorPassDetailData() {
  //   if(widget.createdVisitorPassDetailData==null){
  //     return ;
  //   }
  //   controllers['visitorType']?.text = formatVisitingType(widget.createdVisitorPassDetailData?.visitorType ?? "");
  //   controllers['visitPurpose']?.text = widget.createdVisitorPassDetailData?.organization?? "";
  //   controllers['selectHouseNumber']?.text = widget.createdVisitorPassDetailData?.housesNames ?? "";
  //   String? entryTime = widget.createdVisitorPassDetailData?.originalEntryTime?? "";
  //   parseAndAssignEntryTime(entryTime);
  //   preFillContact(
  //     visitorName:  widget.visitorName ?? "",
  //     visitorNumber:widget.visitorNumber ?? "",
  //     selectedContacts: selectedContacts,
  //   );
  // }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // This ensures the date is highlighted
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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
        String formattedDate = DateFormat('d MMM, yyyy').format(_selectedDate);
        updateAvailableTimeSlots();
        controllers['date']?.text = formattedDate;
        checkDate(formattedDate, 'date', onchange: true);
        _selectedTimeSlot = null;
        controllers['time']?.clear();
        updateFormValidity();
      });
    }
  }
  Future<void> _pickTime() async {
    DateTime now = DateTime.now();
    TimeOfDay initialTime;
    bool isToday = _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;

    if (isToday) {
      DateTime minTime = now.add(const Duration(minutes: 5));
      initialTime = TimeOfDay.fromDateTime(minTime);
    } else {
      initialTime = _selectedTime;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
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
      DateTime selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        picked.hour,
        picked.minute,
      );
      DateTime minTime = now.add(const Duration(minutes: 5));
      if (selectedDateTime.isBefore(minTime)) {

        WorkplaceWidgets.errorSnackBar(context, AppString.selectTimeInFuture);
        return;
      }

      setState(() {
        _selectedTime = picked;
        final formattedTime = DateFormat('hh:mm a').format(selectedDateTime);
        controllers['time']?.text = formattedTime;
        checkTime(formattedTime, 'time', onchange: true);
        updateFormValidity();
      });
    }
  }


  List<ContactInfo> selectedContacts = [];
  Future<void> _getPermission() async {
    if (await Permission.contacts.isGranted) {
      Navigator.push(
        context,
        SlideLeftRoute(
          widget: MyMobileFetchContactList(
            onContactsSelected: (selected) {
              setState(() {
                for (var contact in selected) {
                  if (!selectedContacts
                      .any((c) => c.identifier == contact.identifier)) {
                    selectedContacts.add(contact);
                  }
                }
                updateFormValidity();
              });
            },
          ),
        ),
      );
    } else if (await Permission.contacts.request().isGranted) {
      Navigator.push(
        context,
        SlideLeftRoute(
          widget: MyMobileFetchContactList(
            onContactsSelected: (selected) {
              setState(() {
                for (var contact in selected) {
                  if (!selectedContacts
                      .any((c) => c.identifier == contact.identifier)) {
                    selectedContacts.add(contact);
                  }
                }
                updateFormValidity();
              });
            },
          ),
        ),
      );
    } else {

      WorkplaceWidgets.errorSnackBar(context, AppString.contactPermissionRequired);
      openAppSettings();
    }
  }

  void preFillContact({
    required String? visitorName,
    required String? visitorNumber,
    required List<ContactInfo> selectedContacts,
  }) {
    if (visitorName != null &&
        visitorName.isNotEmpty &&
        visitorNumber != null &&
        visitorNumber.isNotEmpty) {
      ContactInfo preFilledContact = ContactInfo(
        displayName: visitorName,
        phones: [
          ValueItem(
            label: 'mobile',
            value: visitorNumber.startsWith('+91')
                ? visitorNumber
                : '+91$visitorNumber',
          ),
        ],
      );

      // Avoid duplicates
      bool isDuplicate = selectedContacts.any((c) =>
      c.displayName == preFilledContact.displayName &&
          c.phones != null &&
          c.phones!.isNotEmpty &&
          c.phones!.first.value == preFilledContact.phones!.first.value);

      if (!isDuplicate) {
        selectedContacts.add(preFilledContact);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    homeBloc = BlocProvider.of<HomeBloc>(context);
    if (userProfileBloc.user.houses != null &&
        userProfileBloc.user.houses!.isNotEmpty) {
      houses = userProfileBloc.user.houses ?? [];
      if (houses.isNotEmpty && widget.selectHouseNumber!.isEmpty) {
        selectedUnit = houses[0];
        controllers['selectHouseNumber']?.text = selectedUnit?.title ?? "";
      }
    }

    assignVisitorValuesToControllers();
    timeSlots = Map<String, String>.from(MainAppBloc.systemSettingData['timeSlots'] ?? {});
    updateAvailableTimeSlots();


    setData();
    setVisitorPassDetailData();

    visitorTypeData = MainAppBloc.systemSettingData['visitor_types'] ?? [];
    visitorTypeList = visitorTypeData
        .map((item) => formatVisitingType(item['name'].toString()))
        .toList();
    preFillContact(
      visitorName: widget.visitorName,
      visitorNumber: widget.visitorNumber,
      selectedContacts: selectedContacts,
    );

    // _selectedDate = DateTime.now();
    String formattedDate = DateFormat('d MMM, yyyy').format(_selectedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateFormValidity();
    });
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    focusNodes.forEach((key, focusNode) {
      focusNode.dispose();
    });
    super.dispose();
  }

  String formatVisitingType(String? visitorType) {
    if (visitorType == null || visitorType.isEmpty) {
      return '';
    }
    String formatted = visitorType.replaceAll('_', ' ').toLowerCase();
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  String formatVisitingTypeForSubmission(String visitorType) {
    return visitorType.toLowerCase().replaceAll(' ', '_');
  }

  void checkVisitingType(value, field, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        errorMessages[field] = "";
      });
    } else {
      setState(() {
        if (!onchange) {
          errorMessages[field] =
              AppString.trans(context, AppString.visitorTypeRequired);
        }
      });
    }
    updateFormValidity();
  }

  void checkSelectedUnitNumber(String value, String field,
      {bool onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        errorMessages[field] = "";
      });
    } else {
      setState(() {
        if (!onchange) {
          errorMessages[field] =
              AppString.trans(context, AppString.errorSelectTheUnit);
        }
      });
    }
    updateFormValidity();
  }

  void checkDate(String value, String field, {bool onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      DateTime selected = DateFormat('d MMM, yyyy').parse(value);
      DateTime today = DateTime.now();
      DateTime todayStart = DateTime(today.year, today.month, today.day);
      if (selected.isBefore(todayStart)) {
        setState(() {
          if (!onchange) {
            errorMessages[field] =
                AppString.trans(context, 'pastTimeNotAllowed');
          }
        });
      } else {
        setState(() {
          errorMessages[field] = "";
        });
      }
    } else {
      setState(() {
        if (!onchange) {
          errorMessages[field] =
              AppString.trans(context, AppString.dateRequired);
        }
      });
    }
    updateFormValidity();
  }

  void checkTime(String value, String field, {bool onchange = false}) {
    if (value.isEmpty) {
      setState(() {
        errorMessages[field] = "";
      });
      return; // Empty time is valid since it's optional
    }

    try {
      DateTime now = DateTime.now();
      DateTime minTime = now.add(const Duration(minutes: 5));
      DateFormat format = DateFormat('hh:mm a');
      DateTime selected = format.parse(value);

      DateTime selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        selected.hour,
        selected.minute,
      );

      bool isToday = _selectedDate.year == now.year &&
          _selectedDate.month == now.month &&
          _selectedDate.day == now.day;

      if (isToday && selectedDateTime.isBefore(minTime)) {
        setState(() {
          if (!onchange) {
            errorMessages[field] =
                AppString.trans(context, AppString.timeMustBeFuture);
          }
        });
      } else if (selectedDateTime.isBefore(now)) {
        setState(() {
          if (!onchange) {
            errorMessages[field] =
                AppString.trans(context, 'pastTimeNotAllowed');
          }
        });
      } else {
        setState(() {
          errorMessages[field] = "";
        });
      }
    } catch (e) {
      setState(() {
        if (!onchange) {
          errorMessages[field] =
              AppString.trans(context, AppString.invalidTimeFormat);
        }
      });
    }
    updateFormValidity();
  }

  void updateFormValidity() {
    bool valid = true;

    if (controllers['selectHouseNumber']?.text.isEmpty ?? true) {
      valid = false;
    }

    if (controllers['visitorType']?.text.isEmpty ?? true) {
      valid = false;
    }

    if (controllers['visitPurpose']?.text.isEmpty ?? true) {
      valid = false;
    }

    if (controllers['date']?.text.isEmpty ?? true) {
      valid = false;
    } else {
      DateTime selected = DateFormat('d MMM, yyyy').parse(controllers['date']!.text);
      DateTime today = DateTime.now();
      DateTime todayStart = DateTime(today.year, today.month, today.day);
      if (selected.isBefore(todayStart)) {
        valid = false;
      }
    }

    // Remove mandatory time check
    if (controllers['time']?.text.isNotEmpty ?? false) {
      try {
        DateTime now = DateTime.now();
        DateTime minTime = now.add(const Duration(minutes: 5));
        DateFormat format = DateFormat('hh:mm a');
        DateTime selected = format.parse(controllers['time']!.text);

        DateTime selectedDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          selected.hour,
          selected.minute,
        );

        bool isToday = _selectedDate.year == now.year &&
            _selectedDate.month == now.month &&
            _selectedDate.day == now.day;

        if (isToday && selectedDateTime.isBefore(minTime)) {
          valid = false;
        } else if (selectedDateTime.isBefore(now)) {
          valid = false;
        }
      } catch (e) {
        valid = false;
      }
    }

    if (selectedContacts.isEmpty) {
      valid = false;
    }

    setState(() {
      isFormValid = valid;
    });
  }

  bool validateFields({bool isButtonClicked = false}) {
    bool isValid = true;

    if (controllers['selectHouseNumber']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        setState(() {
          errorMessages['selectHouseNumber'] = AppString.errorSelectTheUnit;
        });
      }
      isValid = false;
    }

    if (controllers['visitorType']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        setState(() {
          errorMessages['visitorType'] = AppString.visitorTypeRequired;
        });
      }
      isValid = false;
    }

    if (controllers['visitPurpose']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        setState(() {
          errorMessages['visitPurpose'] = AppString.visitTypeRequired;
        });
      }
      isValid = false;
    }

    if (controllers['date']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        setState(() {
          errorMessages['date'] = AppString.dateRequired;
        });
      }
      isValid = false;
    } else {
      checkDate(controllers['date']!.text, 'date', onchange: isButtonClicked);
      if (errorMessages['date']!.isNotEmpty) {
        isValid = false;
      }
    }

    // Validate time only if provided
    if (controllers['time']?.text.isNotEmpty ?? false) {
      checkTime(controllers['time']!.text, 'time', onchange: isButtonClicked);
      if (errorMessages['time']!.isNotEmpty) {
        isValid = false;
      }
    }

    if (selectedContacts.isEmpty) {
      if (isButtonClicked) {

        WorkplaceWidgets.errorSnackBar(context, AppString.oneGuestMustBeSelected);
      }
      isValid = false;
    }

    return isValid;
  }

  void showVisitingTypeBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectTheVisitorType,
      valuesList: visitorTypeList,
      selectedValue: controllers['visitorType']!.text,
      onValueSelected: (value) {
        setState(() {
          controllers['visitorType']?.text = formatVisitingType(value);
          _visitingType = value;
          errorMessages['visitorType'] = "";
          updateOrganizationList(value);
          updateFormValidity();
        });
      },
    );
  }

  void updateOrganizationList(String visitorType) {
    organizationList.clear();
    controllers['visitPurpose']?.clear();

    for (var type in visitorTypeData) {
      if (type['name'] == formatVisitingTypeForSubmission(visitorType)) {
        organizationList = List<String>.from(type['data']);
        break;
      }
    }
    updateFormValidity();
  }

  void visitPurposeBottomSheet(BuildContext context) {
    if (organizationList.isNotEmpty) {
      WorkplaceWidgets.showCustomAndroidBottomSheet(
        context: context,
        title: AppString.selectTheVisitPurpose,
        valuesList: organizationList,
        selectedValue: controllers['visitPurpose']!.text,
        onValueSelected: (value) {
          setState(() {
            controllers['visitPurpose']?.text = value;
            errorMessages['visitPurpose'] = "";
            updateFormValidity();
          });
        },
      );
    }
  }

  void unitSelectionPopUpSheet() {
    if (houses.isEmpty) {

      WorkplaceWidgets.errorSnackBar(context, AppString.noHousesAvailable);
      return;
    }

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

  void _onUnitSelected(int index) {
    if (selectedUnit == houses[index]) {
      return;
    }
    setState(() {
      selectedUnit = houses[index];
      controllers['selectHouseNumber']?.text = selectedUnit!.title!;
      errorMessages['selectHouseNumber'] = "";
      updateFormValidity();
    });
  }

  Widget visitorTypeField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          widget.isBottomSheetDisable?showVisitingTypeBottomSheet(context): null;
        },
        child: AbsorbPointer(
          child: CommonTextFieldWithError(
            focusNode: focusNodes['visitorType'],
            isShowBottomErrorMsg: true,
            errorMessages: errorMessages['visitorType']?.toString() ?? '',
            controllerT: controllers['visitorType'],
            borderRadius: 8,
            inputHeight: 50,
            enabledBorderColor: AppColors.white,
            focusedBorderColor: AppColors.white,
            backgroundColor: AppColors.white,
            errorLeftRightMargin: 0,
            maxCharLength: 50,
            readOnly: true,
            errorMsgHeight: 20,
            autoFocus: false,
            hintStyle: appStyles.hintTextStyle(),
            inputFieldSuffixIcon: widget.isBottomSheetDisable? WorkplaceWidgets.downArrowIcon():const SizedBox(),
            showError: true,
            capitalization: CapitalizationText.none,
            textInputAction: TextInputAction.done,
            borderStyle: BorderStyle.solid,
            cursorColor: Colors.grey,
            hintText: AppString.selectTheVisitorType,
            inputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.visitorType,
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
            textStyle: appStyles.textFieldTextStyle(),
            contentPadding: const EdgeInsets.only(left: 15, right: 15),
            onTextChange: (value) {
              _visitingType = value;
              checkVisitingType(value, 'visitorType', onchange: true);
            },
            onEndEditing: (value) {
              checkVisitingType(value, 'visitorType');
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  Widget visitPurpose() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          widget.isBottomSheetDisable? visitPurposeBottomSheet(context):null;
        },
        child: AbsorbPointer(
          child: CommonTextFieldWithError(
            focusNode: focusNodes['visitPurpose'],
            isShowBottomErrorMsg: true,
            errorMessages: errorMessages['visitPurpose']?.toString() ?? '',
            controllerT: controllers['visitPurpose'],
            borderRadius: 8,
            inputHeight: 50,
            errorLeftRightMargin: 0,
            maxCharLength: 50,
            errorMsgHeight: 20,
            autoFocus: false,
            showError: true,
            readOnly: true,
            capitalization: CapitalizationText.characters,
            cursorColor: Colors.grey,
            textStyle: appStyles.textFieldTextStyle(),
            inputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.visitPurpose,
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
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.next,
            borderStyle: BorderStyle.solid,
            enabledBorderColor: AppColors.white,
            focusedBorderColor: AppColors.white,
            inputFieldSuffixIcon: widget.isBottomSheetDisable? WorkplaceWidgets.downArrowIcon(): const SizedBox(),
            inputKeyboardType: InputKeyboardTypeWithError.text,
            hintText: AppString.selectTheVisitPurpose,
            contentPadding: const EdgeInsets.only(left: 15, right: 15),
            hintStyle: appStyles.hintTextStyle(),
            onTextChange: (value) {
              checkVisitingType(value, 'visitPurpose', onchange: true);
            },
            onEndEditing: (value) {
              checkVisitingType(value, 'visitPurpose');
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  void showHouseSelectionBottomSheet(BuildContext context) {
    if (houses.isEmpty) {

      WorkplaceWidgets.errorSnackBar(context, AppString.noHousesAvailable);
      return;
    }

    List<String> houseTitles =
    houses.map((house) => house.title ?? '').toList();

    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectUnit,
      valuesList: houseTitles,
      selectedValue: controllers['selectHouseNumber']!.text,
      onValueSelected: (value) {
        setState(() {
          selectedUnit = houses.firstWhere((house) => house.title == value);
          controllers['selectHouseNumber']?.text = value;
          errorMessages['selectHouseNumber'] = "";
          updateFormValidity();
        });
      },
    );
  }

  void updateAvailableTimeSlots() {
    DateTime now = DateTime.now();
    bool isToday = _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;

    setState(() {
      if (isToday) {
        int currentHour = now.hour;
        availableTimeSlots = timeSlots.entries
            .where((entry) => int.parse(entry.key.split(':')[0]) > currentHour)
            .map((entry) => entry.value)
            .toList();
      } else {
        availableTimeSlots = timeSlots.values.toList();
      }
    });
  }


  void showTimeSlotBottomSheet(BuildContext context) {
    if (availableTimeSlots.isEmpty) {
      WorkplaceWidgets.errorSnackBar(context,'No time slots available for the selected date');
      return;
    }

    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectVisitTime,
      valuesList: availableTimeSlots,
      selectedValue: controllers['time']!.text,
      onValueSelected: (value) {
        setState(() {
          controllers['time']?.text = value;
          _selectedTimeSlot = value;
          errorMessages['time'] = "";
          updateFormValidity();
        });
      },
    );
  }


  Widget selectHouseNumber() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();

          widget.isBottomSheetDisable?showHouseSelectionBottomSheet(context):null;
        },
        child: AbsorbPointer(
          child: CommonTextFieldWithError(
            focusNode: focusNodes['selectHouseNumber'],
            isShowBottomErrorMsg: true,
            errorMessages: errorMessages['selectHouseNumber']?.toString() ?? '',
            controllerT: controllers['selectHouseNumber'],
            borderRadius: 8,
            inputHeight: 50,
            enabledBorderColor: AppColors.white,
            focusedBorderColor: AppColors.white,
            backgroundColor: AppColors.white,
            errorLeftRightMargin: 0,
            maxCharLength: 50,
            readOnly: true,
            errorMsgHeight: 20,
            autoFocus: false,
            hintStyle: appStyles.hintTextStyle(),
            inputFieldSuffixIcon:  widget.isBottomSheetDisable? WorkplaceWidgets.downArrowIcon(): const SizedBox(),
            showError: true,
            capitalization: CapitalizationText.none,
            textInputAction: TextInputAction.done,
            borderStyle: BorderStyle.solid,
            cursorColor: Colors.grey,
            hintText: AppString.selectHouseNumberHint,
            inputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
            ],
            placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.houseNumberHint,
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
            textStyle: appStyles.textFieldTextStyle(),
            contentPadding: const EdgeInsets.only(left: 15, right: 15),
            onTextChange: (value) {
              checkSelectedUnitNumber(value, 'selectHouseNumber',
                  onchange: true);
            },
            onEndEditing: (value) {
              checkSelectedUnitNumber(value, 'selectHouseNumber');
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  Widget rowDatePayment() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: dateField(),
    );
  }

  Widget dateField() {
    return CommonTextFieldWithError(
      onTapCallBack: _pickDate,
      readOnly: true,
      inputFieldSuffixIcon: WorkplaceWidgets.calendarIcon(),
      focusNode: focusNodes['date'],
      isShowBottomErrorMsg: true,
      errorMessages: errorMessages['date']?.toString() ?? '',
      controllerT: controllers['date'],
      borderRadius: 8,
      inputHeight: 50,
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
      hintStyle:  appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      hintText: AppString.selectVisitDateHint,
      inputFormatter: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      ],
      placeHolderTextWidget: Padding(
        padding: const EdgeInsets.only(left: 3.0, bottom: 3),
        child: Text.rich(
          TextSpan(
            text: AppString.selectVisitDate,
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
      contentPadding:
      const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      onTextChange: (value) {
        checkDate(value, 'date', onchange: true);
      },
      onEndEditing: (value) {
        checkDate(value, 'date');
        FocusScope.of(context).requestFocus(focusNodes['']);
      },
    );
  }

  Widget timeField() {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          showTimeSlotBottomSheet(context);
        },
        child: AbsorbPointer(
          child: CommonTextFieldWithError(
            focusNode: focusNodes['time'],
            isShowBottomErrorMsg: true,
            errorMessages: errorMessages['time']?.toString() ?? '',
            controllerT: controllers['time'],
            borderRadius: 8,
            inputHeight: 50,
            errorLeftRightMargin: 0,
            maxCharLength: 50,
            errorMsgHeight: 18,
            autoFocus: false,
            showError: true,
            readOnly: true,
            capitalization: CapitalizationText.none,
            cursorColor: Colors.grey,
            enabledBorderColor: Colors.white,
            focusedBorderColor: Colors.white,
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.done,
            borderStyle: BorderStyle.solid,
            inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
            hintText: AppString.selectVisitTimeHint,
            inputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s:-]')),
            ],
            placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text(
                AppString.selectVisitTime,
                style: appStyles.texFieldPlaceHolderStyle(),
                textAlign: TextAlign.start,
              ),
            ),
            hintStyle: appStyles.textFieldTextStyle(
                fontWeight: FontWeight.w400, texColor: Colors.grey.shade600, fontSize: 14),
            textStyle: appStyles.textFieldTextStyle(),
            contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            onTextChange: (value) {
              checkTime(value, 'time', onchange: true);
            },
            onEndEditing: (value) {
              checkTime(value, 'time');
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  Widget guestDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: AppString.selectVisitor,
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: CommonElevatedIconButton(
                  onPressed: _getPermission,
                  icon: const Icon(Icons.contacts),
                  label: AppString.selectFromContacts,
                  textStyle: appStyles.textFieldTextStyle(texColor: AppColors.textBlueColor),
                  backgroundColor: Colors.white,
                  borderColor: Colors.grey.shade300,
                  foregroundColor: AppColors.textBlueColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CommonElevatedIconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      SlideLeftRoute(widget:  const AddGuest()),
                    ).then((result) {
                      if (result != null && result is Map<String, String>) {
                        setState(() {
                          ContactInfo newContact = ContactInfo(
                            displayName: result['name'],
                            phones: [
                              ValueItem(
                                label: 'mobile',
                                value: '+91${result['phone']}',
                              ),
                            ],
                          );
                          bool isDuplicate = selectedContacts.any((c) =>
                          c.displayName == newContact.displayName &&
                              c.phones != null &&
                              c.phones!.isNotEmpty &&
                              c.phones!.first.value == newContact.phones!.first.value);
                          if (!isDuplicate) {
                            selectedContacts.add(newContact);
                          }
                          updateFormValidity();
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.add_box_outlined,size: 20,color: Colors.black,),
                  label: AppString.addManually,
                  textStyle: appStyles.textFieldTextStyle(texColor: AppColors.black),
                  backgroundColor: Colors.white,
                  borderColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget selectedContactList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedContacts.isNotEmpty)

          Padding(
              padding:  EdgeInsets.only(left: 25, top:widget.isShowContactList?20: 0, bottom: 10),
              child: Text.rich(
                TextSpan(
                  text: AppString.selectedGuest,
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


              // Text(
              // AppString.selectedGuest,
              //   style: appStyles.texFieldPlaceHolderStyle(),
              // )
              //

          ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectedContacts.length,
          itemBuilder: (context, index) {
            final contact = selectedContacts[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2)),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 10,right: 1),
                minTileHeight: 10,
                leading: const Icon(CupertinoIcons.person_crop_circle),
                title: Text(contact.displayName ?? 'No Name'),
                subtitle: Text(contact.phones?.isNotEmpty == true
                    ? contact.phones!.first.value ?? 'No Phone'
                    : 'No Phone'),
                trailing: widget.isShowContactList ?IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      selectedContacts.removeAt(index);
                      updateFormValidity();
                    });
                  },
                ): SizedBox()
              ),
            );
          },
        ),
      ],
    );
  }




  Widget submitButton(state) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: AppButton(
        buttonName: AppString.submit,
        buttonColor: isFormValid ? AppColors.textBlueColor : Colors.grey,
        textStyle: appStyles.buttonTextStyle1(
          texColor: AppColors.white,
        ),
        isLoader: state is PreRegisterVisitorLoadingState || state is UpdatePreRegisterVisitorLoadingState ,
        backCallback: () {
          if (validateFields()) {
            String formattedDate =
            DateFormat('yyyy-MM-dd').format(_selectedDate);
            final selectedDateTime = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              _selectedTime.hour,
              _selectedTime.minute,
            );
            String formattedTime = DateFormat('HH:mm').format(selectedDateTime);
            if (_selectedTimeSlot != null) {
              String? slotKey = timeSlots.entries
                  .firstWhere((entry) => entry.value == _selectedTimeSlot, orElse: () => MapEntry("", ""))
                  .key;
              if (slotKey.isNotEmpty) {
                formattedTime = slotKey; // e.g., "12:01"
              }
            }
            List<Map<String, dynamic>> guestsList =
            selectedContacts.map((contact) {
              String phone = contact.phones?.isNotEmpty == true
                  ? contact.phones!.first.value ?? ''
                  : '';
              phone = phone
                  .replaceAll('+91', '')
                  .replaceAll(' ', '')
                  .replaceAll('(', '')
                  .replaceAll(')', '')
                  .replaceAll('-', ''); // Remove hyphens
              return {
                'name': contact.displayName ?? '',
                'phone_number': int.parse(phone)
              };
            }).toList();


            if(widget.editUpComingVisitorsData!=null)
            {
              if(widget.editUpComingVisitorsData?.first.entryId!=null) {
                homeBloc.add(
                  OnUpdatePreRegisterVisitorEvent(
                    id:widget.editUpComingVisitorsData!.first.entryId?? 0,
                    visitorType: formatVisitingTypeForSubmission(
                        controllers['visitorType']!.text.toLowerCase()),
                    organization: controllers['visitPurpose']!.text,
                    houseId: selectedUnit?.id ??widget.houseId ?? 0,
                    guests: guestsList,
                    date: formattedDate,
                    time: formattedTime,
                    remark: '',
                  ),
                );
              }
              else{

              }
            }
            else if (widget.visitorEntryId != null && widget.visitorEntryId != 0){
              homeBloc.add(
                OnUpdatePreRegisterVisitorEvent(
                  id:widget.visitorEntryId?? 0,
                  visitorType: formatVisitingTypeForSubmission(
                      controllers['visitorType']!.text.toLowerCase()),
                  organization: controllers['visitPurpose']!.text,
                  houseId: selectedUnit?.id ??widget.houseId ?? 0,
                  guests: guestsList,
                  date: formattedDate,
                  time: formattedTime,
                  remark: '',
                ),
              );
            }

            else if (widget.createdVisitorPassDetailData != null&& widget.isShowContactList == false){
              homeBloc.add(
                OnUpdatePreRegisterVisitorEvent(
                  id:widget.createdVisitorPassDetailData?.entryId?? 0,
                  visitorType: formatVisitingTypeForSubmission(
                      controllers['visitorType']!.text.toLowerCase()),
                  organization: controllers['visitPurpose']!.text,
                  houseId: selectedUnit?.id ??widget.houseId ?? 0,
                  guests: guestsList,
                  date: formattedDate,
                  time: formattedTime,
                  remark: '',
                ),
              );
            }
            else
            {
              homeBloc.add(
                OnPreRegisterVisitorEvent(
                  visitorType: formatVisitingTypeForSubmission(
                      controllers['visitorType']!.text.toLowerCase()),
                  organization: controllers['visitPurpose']!.text,
                  houseId: selectedUnit?.id ??widget.houseId ?? 0,
                  guests: guestsList,
                  date: formattedDate,
                  time: formattedTime,
                  remark: '',
                ),
              );
            }


          }
        },
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
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.createVisitorPass,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<HomeBloc, HomeState>(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is PreRegisterVisitorErrorState) {

            WorkplaceWidgets.errorSnackBar(context,state.errorMessage);
          }
          if (state is UpdatePreRegisterVisitorErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is CreatedNocPassErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is PreRegisterVisitorDoneState) {

            homeBloc.add(
              OnCreatedNocPassEvent(
                mContext: context,
                id:widget.nocId ?? 0,
                visitorEntryId: state.data
              ),
            );

            if (widget.isComingFromNoc){
              Navigator.pop(context, true);
              WorkplaceWidgets.successToast(AppString.visitorInvitedSuccessfully);

            }
            else {
              Navigator.pop(context, true);
              WorkplaceWidgets.successToast(AppString.visitorInvitedSuccessfully);
            }

          }

          if (state is UpdatePreRegisterVisitorDoneState) {
            WorkplaceWidgets.successToast(state.message);
           Navigator.pop(context, true);
           // Navigator.pop(context, true);
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: homeBloc,
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 10),
                selectHouseNumber(),
                visitorTypeField(),
                visitPurpose(),
                rowDatePayment(),
                if(widget.isShowContactList == true)
                guestDetails(),
                selectedContactList(),
                const SizedBox(height: 20),
                submitButton(state),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

