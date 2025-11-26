import 'package:asetize/widgets/common_card_view.dart';

import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/commonTitleRowWithIcon.dart';
import '../widgets/label_widget.dart';
import 'booking_confirmed_screen.dart';

class BookingDetailsAndPaymentScreen extends StatefulWidget {
  final String date;
  final String time;
  const BookingDetailsAndPaymentScreen({super.key, required this.date, required this.time});

  @override
  State<BookingDetailsAndPaymentScreen> createState() =>
      _BookingDetailsAndPaymentScreenState();
}

class _BookingDetailsAndPaymentScreenState
    extends State<BookingDetailsAndPaymentScreen> {
  String? selectedDuration;
  String _selectedOption = '';
  final List<String> durationList = [
    '30 mins',
    '1 hour',
    '1.5 hours',
    '2 hours',
    '2.5 hours',
    '3 hours',
    'Half Day',
    'Full Day',
  ];

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
  Map<String, TextEditingController> controllers = {
    'member': TextEditingController(),
    'duration': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'member': FocusNode(),
    'duration': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'member': "",
    'duration': "",
  };

  Widget memberField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        inputFormatter: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        focusNode: focusNodes['member'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['member']?.toString() ?? '',
        controllerT: controllers['member'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 18,
        autoFocus: false,
        readOnly: false,
        showError: true,
        capitalization: CapitalizationText.characters,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: 'Number of members',
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
            )),
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.number,
        hintText: 'Enter number of members',
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          setState(() {});
        },
        onEndEditing: (value) {},
      ),
    );
  }

  Widget selectedDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 22, bottom: 5),
            child: Text.rich(
              TextSpan(
                text: 'Selected Date',
                style: appStyles.texFieldPlaceHolderStyle(),
              ),
              textAlign: TextAlign.start,
            )),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 0.5,color: Colors.grey.shade200)
          ),
          padding: const EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          child: Text('${widget.date}  ${widget.time}',style: appStyles.textFieldTextStyle(),),
        ),
      ],
    );
  }

  void showAmenityTypeBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: 'Select Duration',
      valuesList: durationList,
      selectedValue: controllers['duration']!.text,
      onValueSelected: (value) {
        setState(() {
          controllers['duration']?.text = value;
          selectedDuration = value;
          errorMessages['duration'] = "";
        });
      },
    );
  }

  Widget durationField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          showAmenityTypeBottomSheet(context);
          closeKeyboard();
        },
        child: AbsorbPointer(
          child: CommonTextFieldWithError(
            key: ValueKey(controllers['duration']?.text),
            focusNode: focusNodes['duration'],
            isShowBottomErrorMsg: true,
            errorMessages: errorMessages['duration']?.toString() ?? '',
            controllerT: controllers['duration'],
            borderRadius: 8,
            inputHeight: 50,
            errorLeftRightMargin: 0,
            maxCharLength: 50,
            readOnly: true,
            errorMsgHeight: 18,
            autoFocus: false,
            inputFieldSuffixIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
            enabledBorderColor: Colors.white,
            focusedBorderColor: Colors.white,
            showError: true,
            capitalization: CapitalizationText.none,
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.done,
            borderStyle: BorderStyle.solid,
            cursorColor: Colors.grey,
            hintText: 'Select Duration',
            hintStyle: appStyles.hintTextStyle(),
            placeHolderTextWidget: const LabelWidget(labelText: 'Duration Needed'),
            textStyle:
                appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
            contentPadding: const EdgeInsets.only(left: 15, right: 15),
            onTextChange: (value) {
              selectedDuration = value;
            },
            onEndEditing: (value) {
              checkAmenityType(value, 'duration', onchange: true);
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  checkAmenityType(value, vehicleType, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.isNotEmpty(value.trim())) {
          errorMessages[vehicleType] = "";
        } else {
          if (!onchange) {
            errorMessages[vehicleType] = AppString.trans(
              context,
              'Please select duration',
            );
          }
        }
      });
    } else {
      setState(() {
        if (!onchange) {
          if (vehicleType == 'duration') {
            errorMessages[vehicleType] = AppString.trans(
              context,
              'Please select duration',
            );
          }
        }
      });
    }
  }

  Widget _buildRadioTile({List listValue = const []}) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listValue.length,
      itemBuilder: (context, index) {
        final item = listValue[index];

        return CommonCardView(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          side: BorderSide(
            width: 1.5,
            color: _selectedOption == item ? AppColors.appBlueColor : Colors.transparent,
          ),
          child: Center(
            child: RadioListTile<String>(
              value: item,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
              title: Text(item,style: appTextStyle.appTitleStyle(fontWeight: FontWeight.w500),),
              contentPadding: const EdgeInsets.symmetric(vertical: 12).copyWith(left: 12),
              activeColor: AppColors.textBlueColor,
              dense: true,
              visualDensity: VisualDensity.compact,
            ),
          ),
        );
      },
    );
  }


  Widget amountDetailViews(){
    return CommonCardView(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount Details', style: appTextStyle.appTitleStyle2(fontWeight: FontWeight.w500, fontSize: 16)),
            const SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Base Charge', style: appTextStyle.appSubTitleStyle2(fontWeight: FontWeight.w400, fontSize: 14),),
                Text('₹400', style: appTextStyle.appTitleStyle2(fontSize: 14,fontWeight: FontWeight.w400),),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Service Fee', style: appTextStyle.appSubTitleStyle2(fontWeight: FontWeight.w400, fontSize: 14),),
                Text('₹100', style: appTextStyle.appTitleStyle2(fontSize: 14,fontWeight: FontWeight.w400),),
              ],
            ),
            const SizedBox(height: 6),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount', style: appTextStyle.appTitleStyle2(fontWeight: FontWeight.w500, fontSize: 16)),
                Text('₹500', style: appTextStyle.appTitleStyle2(fontWeight: FontWeight.w500, fontSize: 16)),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
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
      appBar: const CommonAppBar(
        title: 'Booking Information',
      ),
      containChild: Padding(
        padding: const EdgeInsets.only(bottom: 85),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selectedDateField(),
            const SizedBox(height: 15),
            memberField(),
            durationField(),
            amountDetailViews(),
            const Padding(
              padding: EdgeInsets.only(left: 16,top: 14,bottom: 12),
              child: CommonTitleRowWithIcon(title: 'Payment Details',icon: Icons.payment,),
            ),
            _buildRadioTile(listValue: ['Online Payment','Offline Payment']),

          ],
        ),
      ),
      bottomMenuView: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFf9fafb),
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 0.5,
                ),
              ),
            ),
            child: AppButton(
              buttonName: 'Submit & Pay',
              buttonColor: controllers['member']?.text.isNotEmpty == true &&
                      controllers['duration']?.text.isNotEmpty == true
                  ? AppColors.textBlueColor
                  : Colors.grey,
              backCallback:controllers['member']?.text.isNotEmpty == true &&
                  controllers['duration']?.text.isNotEmpty == true
                  ? () {
                Navigator.push(
                  context,
                  FadeRoute(widget: const BookingConfirmedScreen()),
                );
              }:null,
            ),
          ),
        ],
      ),
    );
  }
}
