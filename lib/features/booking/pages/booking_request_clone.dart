/*
import '../../../core/app_themes/app_color.dart';
import '../../../core/app_themes/app_style.dart';
import '../../../global_components/common_appbar.dart';
import '../../../global_components/common_button/app_button_common.dart';
import '../../../global_components/container_first.dart';
import '../../../imports.dart';
import '../widgets/drop_down_widget.dart';

class BookingRequest extends StatefulWidget {
  const BookingRequest({super.key});

  @override
  State<BookingRequest> createState() => _BookingRequestState();
}

class _BookingRequestState extends State<BookingRequest> {

  String? selectedAmenity;
  String? selectedEventType;

  final List<String> amenityType = ['Community Hall','Garden','Swimming Pool','Indoor Games Room',
    'Terrace Area','Meeting Room'];
  final List<String> eventType = ['Birthday Party','Anniversary Celebration',
    'Wedding Reception','Community Get-togethers'] ;
  Widget amenityTypeField() {
    return CommonDropdown<String>(
      value: selectedAmenity,
      hintText: 'Select Amenity Type',
      items: amenityType.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedAmenity = value;
        });
      },
    );
  }

  Widget eventTypeField()
  {
    return CommonDropdown<String>(
      value: selectedEventType,
      hintText: 'Select Event Type',
      items: eventType.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedEventType = value;
        });
      },
    );
  }

  button() {
    return AppButton(
      buttonName: 'View Rules & Continue',
      buttonColor: AppColors.textBlueColor, //(validateFields()) ? AppColors.textBlueColor : Colors.grey,
      // buttonColor: (validateFields(isButtonClicked: true))
      //     ? AppColors.textBlueColor
      //     : Colors.grey, // Button color based on validation
      textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
      backCallback: () {
        // if (validateFields(isButtonClicked: true)) {
        // }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isListScrollingNeed: true,
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
              SizedBox(height: 20,),
              eventTypeField(),
              SizedBox(height: 40,),
              button()
            ],
          ),
        )


    );
  }
}
*/
