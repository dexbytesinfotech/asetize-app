import '../../../imports.dart';


class ShareUpdateBottomSheet extends StatefulWidget {
  const ShareUpdateBottomSheet({super.key});

  @override
  State<ShareUpdateBottomSheet> createState() => _ShareUpdateBottomSheetState();
}

class _ShareUpdateBottomSheetState extends State<ShareUpdateBottomSheet> {

  Map<String, TextEditingController> controllers = {
    'complaint': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'complaint': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'complaint': "",
  };

  @override
  Widget build(BuildContext context) {


    bool validateFields({isButtonClicked = false}) {
      if (controllers['complaint']?.text == null || controllers['complaint']?.text == '') {
        setState(() {
          if (isButtonClicked) {
            FocusScope.of(context).requestFocus(focusNodes['complaint']);
            errorMessages['complaint'] = 'Please enter update';
          }
        });
        return false;
      }  else {
        return true;
      }
    }

    checkReason(value, fieldEmail, {onchange = false}) {
      if (Validation.isNotEmpty(value.trim())) {
        setState(() {
          if (Validation.isNotEmpty(value.trim())) {
            errorMessages[fieldEmail] = "";
          } else {
            if (!onchange) {
              errorMessages[fieldEmail] =
                  AppString.trans(context, AppString.emailHintError1);
            }
          }
        });
      } else {
        setState(() {
          if (!onchange) {
            if (fieldEmail == 'complaint') {
              errorMessages[fieldEmail] =
                  AppString.trans(context, AppString.emailHintError);
            }
          }
        });
      }
    }

    return  BottomSheetOnlyCardView(
      cardBackgroundColor: Colors.white,
      topLineShow: true,
      child: Padding(
         padding : MediaQuery.of(context).viewInsets,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Share Update',style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.black,
                  ),),
                  const SizedBox(height: 14,),
                  CommonTextFieldWithError(
                    focusNode: focusNodes['complaint'],
                    isShowBottomErrorMsg: true,
                    errorMessages: errorMessages['complaint']?.toString() ?? '',
                    controllerT: controllers['complaint'],
                    borderRadius: 8,
                    inputHeight: 140,
                    errorLeftRightMargin: 0,
                    maxCharLength: 500,
                    errorMsgHeight: 18,
                    maxLines: 5,
                    autoFocus: false,
                    showError: true,
                    showCounterText: false,
                    capitalization: CapitalizationText.sentences,
                    cursorColor: Colors.black,
                    enabledBorderColor: Colors.white,
                    focusedBorderColor: Colors.white,
                    backgroundColor: AppColors.white,
                    textInputAction: TextInputAction.newline,
                    borderStyle: BorderStyle.solid,
                    inputKeyboardType: InputKeyboardTypeWithError.multiLine,
                    hintText: "Share Update",
                    hintStyle: appStyles.textFieldTextStyle(
                        fontWeight: FontWeight.w400,
                        texColor: Colors.grey.shade600,
                        fontSize: 14),
                    textStyle:
                    appStyles.textFieldTextStyle(fontWeight: FontWeight.w400),
                    contentPadding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    onTextChange: (value) {
                      checkReason(value, 'complaint', onchange: true);
                    },
                    onEndEditing: (value) {
                      checkReason(value, 'complaint');
                      // FocusScope.of(context).requestFocus(focusNodes['password']);
                    },
                  ),
                  const SizedBox(height: 5,),
                  AppButton(
                    buttonName: "Submit",
                    backCallback: () {
                      if (validateFields(isButtonClicked: true)) {
                        WorkplaceWidgets.successToast('Shared your update successfully',durationInSeconds: 1);
                        Navigator.pop(context);


                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



