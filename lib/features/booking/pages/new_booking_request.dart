import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:country_code_picker/country_code_picker.dart'; // Add this package for CountryCodePicker
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_card_view.dart';
import '../../booking/widgets/label_widget.dart';
import '../widgets/amenity_type_widget.dart';
import 'amenity_details_and_terms_screen.dart';
import 'booking_confirmed_screen.dart';

class NewBookingRequest extends StatefulWidget {
  const NewBookingRequest({super.key});

  @override
  State<NewBookingRequest> createState() => _NewBookingRequestState();
}

class _NewBookingRequestState extends State<NewBookingRequest> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int? _numberOfGuests;
  String? _contactNumber;
  String? _purposeOfBooking;
  String _bookingType = 'Single Day'; // Default to Single Day

  final List<String> _timeOptions = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];
  final List<String> _bookingTypeOptions = ['Single Day', 'Multiple Days'];

  final Map<String, TextEditingController> controllers = {
    'startDate': TextEditingController(),
    'endDate': TextEditingController(),
    'startTime': TextEditingController(),
    'endTime': TextEditingController(),
    'numberOfGuests': TextEditingController(),
    'contactNumber': TextEditingController(),
    'purposeOfBooking': TextEditingController(),
    'bookingType': TextEditingController(), // Added controller for booking type
  };

  final Map<String, FocusNode> focusNodes = {
    'startDate': FocusNode(),
    'endDate': FocusNode(),
    'startTime': FocusNode(),
    'endTime': FocusNode(),
    'numberOfGuests': FocusNode(),
    'contactNumber': FocusNode(),
    'purposeOfBooking': FocusNode(),
    'bookingType': FocusNode(), // Added focus node for booking type
  };

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    focusNodes.forEach((key, focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controllers['bookingType']!.text = _bookingType; // Initialize booking type controller
    _updateDateControllers();
  }

  void _updateDateControllers() {
    controllers['startDate']!.text = _startDate != null ? projectUtil.uiShowDateFormat(_startDate!) : '';
    controllers['endDate']!.text = _endDate != null ? projectUtil.uiShowDateFormat(_endDate!) : '';
  }

  bool areMandatoryFieldsFilled() {
    final startDate = controllers['startDate']?.text.isNotEmpty ?? false;
    final endDate = _bookingType == 'Multiple Days' ? (controllers['endDate']?.text.isNotEmpty ?? false) : true;
    final startTime = controllers['startTime']?.text.isNotEmpty ?? false;
    final endTime = controllers['endTime']?.text.isNotEmpty ?? false;
    final contactNumber = controllers['contactNumber']?.text.isNotEmpty ?? false;
    final bookingType = controllers['bookingType']?.text.isNotEmpty ?? false;
    return startDate && endDate && startTime && endTime && contactNumber && bookingType;
  }

  void selectDate(BuildContext context, bool isStartDate) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.appBlueColor,
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
    if (newDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = newDate;
          if (_bookingType == 'Single Day') {
            _endDate = newDate; // Set end date same as start date for single day
          }
        } else {
          _endDate = newDate;
        }
        _updateDateControllers();
      });
    }
  }

  void selectTime(BuildContext context, bool isStartTime) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? (_startTime ?? TimeOfDay.now()) : (_endTime ?? TimeOfDay.now()),
    );
    if (newTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = newTime;
          controllers['startTime']!.text = newTime.format(context);
        } else {
          _endTime = newTime;
          controllers['endTime']!.text = newTime.format(context);
        }
      });
    }
  }

  void showBottomSheet(BuildContext context, String title, List<String> options, String controllerKey, Function(String) onSelected) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: title,
      valuesList: options,
      selectedValue: controllers[controllerKey]!.text,
      onValueSelected: (value) {
        setState(() {
          controllers[controllerKey]!.text = value.capitalize();
          onSelected(value);
        });
      },
    );
  }
Widget amenityOpenTime(){

    return AmenityTypeWidget(
        horizontalPadding: 0,
      horizontalMargin: 2,
      isShowIcon: false,
      horizontalImagePadding: 10,
      onTab: () {
        // Navigator.push(
        //   context,
        //   SlideLeftRoute(
        //     widget: const AmenityDetailsAndTermsScreen(),
        //   ),
        // );
      },
      imageUrl: "https://m.media-amazon.com/images/I/71fEvvr2k1S.jpg",
      amenityName: "Swimming Pool",
      description: "Open 10AM - 6PM",
    );
}
  Widget bookingTypeWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['bookingType'],
      controllerT: controllers['bookingType'],
      borderRadius: 8,
      inputHeight: 50,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 50,
      errorMsgHeight: 20,
      showError: true,
      readOnly: true,
      autoFocus: false,
      inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: 'Select booking type',
      placeHolderTextWidget: const LabelWidget(labelText: 'Booking Type', isRequired: true),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () {
        FocusScope.of(context).unfocus();
        showBottomSheet(context, 'Select Booking Type', _bookingTypeOptions, 'bookingType', (value) {
          setState(() {
            _bookingType = value;
            if (_bookingType == 'Single Day') {
              _endDate = _startDate; // Set end date same as start date
              _updateDateControllers();
            }
          });
        });
      },
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  Widget startDateWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['startDate'],
      controllerT: controllers['startDate'],
      borderRadius: 8,
      inputHeight: 50,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 10,
      errorMsgHeight: 20,
      showError: true,
      readOnly: true,
      autoFocus: false,
      inputFieldSuffixIcon: WorkplaceWidgets.calendarIcon(),
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: 'D MMM, YYYY',
      placeHolderTextWidget: LabelWidget(
        labelText: _bookingType == 'Single Day' ? 'Select Date' : 'Start Date',
        isRequired: true,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () => selectDate(context, true),
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  Widget endDateWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['endDate'],
      controllerT: controllers['endDate'],
      borderRadius: 8,
      inputHeight: 50,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 10,
      errorMsgHeight: 20,
      showError: true,
      readOnly: true,
      autoFocus: false,
      inputFieldSuffixIcon: WorkplaceWidgets.calendarIcon(),
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: 'D MMM, YYYY',
      placeHolderTextWidget: const LabelWidget(labelText: 'End Date', isRequired: true),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () => selectDate(context, false),
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  Widget startTimeWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['startTime'],
      controllerT: controllers['startTime'],
      borderRadius: 8,
      inputHeight: 50,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 5,
      errorMsgHeight: 20,
      showError: true,
      readOnly: true,
      autoFocus: false,
      inputFieldSuffixIcon: WorkplaceWidgets.clockIcon(),
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: 'Select time',
      placeHolderTextWidget: const LabelWidget(labelText: 'Start Time', isRequired: true),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () => selectTime(context, true),
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  Widget endTimeWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['endTime'],
      controllerT: controllers['endTime'],
      borderRadius: 8,
      inputHeight: 50,

      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 5,
      errorMsgHeight: 20,
      showError: true,
      readOnly: true,
      autoFocus: false,
      inputFieldSuffixIcon: WorkplaceWidgets.clockIcon(),
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: 'Select time',
      placeHolderTextWidget: const LabelWidget(labelText: 'End Time', isRequired: true),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () => selectTime(context, false),
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  Widget numberOfGuestsWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['numberOfGuests'],
      controllerT: controllers['numberOfGuests'],
      borderRadius: 8,
      inputHeight: 50,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 3,
      errorMsgHeight: 20,
      showError: true,
      autoFocus: false,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: 'Enter number of guests',
      placeHolderTextWidget: const LabelWidget(labelText: 'Number of Guests', isRequired: false),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTextChange: (value) {
        setState(() {
          _numberOfGuests = int.tryParse(value);
        });
      },
      onEndEditing: (value) {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  Widget contactNumberWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['contactNumber'],
        isShowBottomErrorMsg: false,
        controllerT: controllers['contactNumber'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        errorMsgHeight: 20,
        autoFocus: false,
        showError: true,
        maxLines: 1,
        capitalization: CapitalizationText.none,
        cursorColor: Colors.grey,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(10), // Restrict to 10 digits
        ],
        placeHolderTextWidget: Padding(
          padding: const EdgeInsets.only(left: 3.0, bottom: 3),
          child: Text.rich(
            TextSpan(
              text: 'Contact Number',
              style: appStyles.texFieldPlaceHolderStyle(),
              children: [
                TextSpan(
                  text: ' *',
                  style: appStyles.texFieldPlaceHolderStyle().copyWith(color: Colors.red),
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
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: 'Enter your contact number',
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldPrefixIcon: CountryCodePicker(
          showFlag: false,
          enabled: false,
          textStyle: appStyles.textFieldTextStyle(),
          padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 10),
          initialSelection: 'IN',
          onChanged: (value) {},
          onInit: (value) {},
        ),
        onTextChange: (value) {
          setState(() {
            _contactNumber = value;
          });
        },
        onEndEditing: (value) {
          FocusScope.of(context).nextFocus();
        },
      ),
    );
  }

  Widget purposeOfBookingWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['purposeOfBooking'],
      controllerT: controllers['purposeOfBooking'],
      borderRadius: 8,
      inputHeight: 100,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 500,
      minLines: 3,
      maxLines: 3,
      autoFocus: false,
      showCounterText: false,
      cursorColor: Colors.grey,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.newline,
      borderStyle: BorderStyle.solid,
      inputKeyboardType: InputKeyboardTypeWithError.multiLine,
      hintText: 'Describe the purpose of your booking...',
      placeHolderTextWidget: const LabelWidget(labelText: 'Purpose of Booking', isRequired: true),
      contentPadding: const EdgeInsets.all(10),
      onTextChange: (value) {
        setState(() {
          _purposeOfBooking = value;
        });
      },
      onEndEditing: (value) {},
    );
  }


  Widget bookingGuidelines(){
    return CommonCardView(
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.grey),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          initiallyExpanded: true,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Booking Guidelines',
              style: appTextStyle.appTitleStyle2(),
            ),
          ),
          childrenPadding: const EdgeInsets.only(bottom: 20,left: 0,),
          children: [
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Bookings must be made at least 24 hours in advance',
              style: appTextStyle.appSubTitleStyle3(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• All bookings are subject to approval by management',
              style: appTextStyle.appSubTitleStyle3(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Cancellations must be made 12 hours before booking time',
              style: appTextStyle.appSubTitleStyle3(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Additional charges may apply for extended usage',
              style: appTextStyle.appSubTitleStyle3(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        )

        ],
        ),
      ),
    );
  }


  Widget submitButtonWidget() {
    return AppButton(
      buttonName: 'Submit Booking Request',
      isLoader: false,
      buttonColor: areMandatoryFieldsFilled() ? AppColors.textBlueColor : Colors.grey,
      backCallback: (){

            Navigator.push(
              context,
              SlideRightRoute(widget: const BookingConfirmedScreen()),
            );
      },
      // backCallback: areMandatoryFieldsFilled()
      //     ? () {
      //
      //   if (_formKey.currentState!.validate()) {
      //     // Add submission logic here
      //     Navigator.push(
      //       context,
      //       SlideRightRoute(widget: const BookingConfirmedScreen()),
      //     );
      //
      //   }
      // }
      //     : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: false,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(title: 'Add Booking Request'),
      containChild: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              amenityOpenTime(),
              SizedBox(height: 5,),
              bookingTypeWidget(),
              const SizedBox(height: 10),
              _bookingType == 'Single Day'
                  ?
              startDateWidget()
                  : Row(
                children: [
                  Expanded(child: startDateWidget()),
                  const SizedBox(width: 10),
                  Expanded(child: endDateWidget()),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: startTimeWidget()),
                  const SizedBox(width: 10),
                  Expanded(child: endTimeWidget()),
                ],
              ),
              const SizedBox(height: 10),
              numberOfGuestsWidget(),
              const SizedBox(height: 10),







              contactNumberWidget(),
              const SizedBox(height: 10),
              purposeOfBookingWidget(),
              const SizedBox(height: 10),
              bookingGuidelines(),
              const SizedBox(height: 40),
              submitButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to add capitalize method to String
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
