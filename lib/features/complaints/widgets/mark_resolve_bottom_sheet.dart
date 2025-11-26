import '../../../imports.dart';


class MarkResolveBottomSheet extends StatefulWidget {
  const MarkResolveBottomSheet({super.key});

  @override
  State<MarkResolveBottomSheet> createState() => _MarkResolveBottomSheetState();
}

class _MarkResolveBottomSheetState extends State<MarkResolveBottomSheet> {

  Map<String, TextEditingController> controllers = {
    'complaint': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'complaint': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'complaint': "",
  };
  String imageErrorMessage = '';
  File? selectProfilePhoto;
  String? selectProfilePhotoPath;
  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  bool isImageSelected = false;
  @override
  Widget build(BuildContext context) {

    void photoPickerBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context1) => PhotoPickerBottomSheet(
          isRemoveOptionNeeded: false,
          removedImageCallBack: () {
            Navigator.pop(context1);
            setState(() {
              selectProfilePhotoPath = "";
              isImageSelected = false;
            });
          },
          selectedImageCallBack: (fileList) {
            try {
              if (fileList != null && fileList.isNotEmpty) {
                fileList.map((fileDataTemp) {
                  File imageFileTemp = File(fileDataTemp.path);
                  selectProfilePhoto = imageFileTemp;
                  selectProfilePhotoPath = selectProfilePhoto!.path;
                  isImageSelected = true;
                  if (imageFile == null) {
                    imageFile = <String, File>{};
                  } else {
                    imageFile!.clear();
                  }
                  if (imagePath == null) {
                    imagePath = <String, String>{};
                  } else {
                    imagePath!.clear();
                  }
                  imageErrorMessage = '';
                  String mapKey = DateTime.now().microsecondsSinceEpoch.toString();
                  imageFile![mapKey] = imageFileTemp;
                  imagePath![mapKey] = imageFileTemp.path;
                }).toList(growable: false);
                setState(() {});
              }
            } catch (e) {
              debugPrint('$e');
            }
            Navigator.pop(context1);
          },
          selectedCameraImageCallBack: (fileList) {
            try {
              if (fileList != null && fileList.path!.isNotEmpty) {
                File imageFileTemp = File(fileList.path!);
                selectProfilePhoto = imageFileTemp;
                selectProfilePhotoPath = selectProfilePhoto!.path;
                isImageSelected = true;
                if (imageFile == null) {
                  imageFile = {};
                } else {
                  imageFile!.clear();
                }
                if (imagePath == null) {
                  imagePath = {};
                } else {
                  imagePath!.clear();
                }
                imageErrorMessage = '';
                String mapKey = DateTime.now().microsecondsSinceEpoch.toString();
                imageFile![mapKey] = imageFileTemp;
                imagePath![mapKey] = imageFileTemp.path;
                setState(() {});
              }
            } catch (e) {
              debugPrint('$e');
            }
            Navigator.pop(context1);
          },
        ),
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(photoPickerBottomSheetCardRadius)),
        ),
      );
    }

    void removeImage() {
      setState(() {
        selectProfilePhoto = null;
      });
    }

    imageUpload() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => photoPickerBottomSheet(),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                      width: 0.8, color:Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 3,
                        offset: const Offset(0, 1),
                        blurRadius: 3)
                  ]
              ),
              padding: const EdgeInsets.all(8).copyWith(top: 0, bottom: 0, left: 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                            width: 0.8, color:Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              spreadRadius: 3,
                              offset: const Offset(0, 1),
                              blurRadius: 3)
                        ]),
                    child: Stack(
                      children: [
                        if (selectProfilePhoto != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                Image.file(
                                  selectProfilePhoto!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: removeImage,
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
                            ),
                          )
                        else
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(15),
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(color: Colors.grey.shade200,shape: BoxShape.circle),
                                    child: const Icon(Icons.image, size: 24, color: Colors.grey)),
                                Text('Upload',style: appStyles.userJobTitleTextStyle(fontSize: 14, texColor: Colors.grey.shade600),),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Allowed types: jpeg, png, jpg', style: appStyles.userJobTitleTextStyle(fontSize: 14, texColor: Colors.grey.shade600)),
                        const SizedBox(height: 2,),
                        Text('Up to 5MB size', style: appStyles.userJobTitleTextStyle(fontSize: 14, texColor: Colors.grey.shade600)),
                        const SizedBox(height: 2,),
                        Text('Maximum of 1 image', style: appStyles.userJobTitleTextStyle(fontSize: 14, texColor: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget imageErrorText() => Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (imageErrorMessage != '')
            ? Container(
            padding: const EdgeInsets.only(left: 2, top: 2),
            height: 18,
            child: Text(
              imageErrorMessage,
              style: appStyles.errorStyle(),
            ))
            : Container(height: 0.5),
      ],
    );

    bool validateFields({isButtonClicked = false}) {
      if (selectProfilePhoto == null) {
        if (isButtonClicked) {
          setState(() {
            imageErrorMessage = "Please select upload image";
          });
        }
        return false;
      } else if (controllers['complaint']?.text == null || controllers['complaint']?.text == '') {
        setState(() {
          if (isButtonClicked) {
            FocusScope.of(context).requestFocus(focusNodes['complaint']);
            errorMessages['complaint'] = 'Please enter update message';
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
                  imageUpload(),
                  imageErrorText(),
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
                    hintText: "Update message",
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
                        WorkplaceWidgets.successToast('Submitted complaint update successfully',durationInSeconds: 1);
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



