import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../imports.dart';
import '../bloc/pet_bloc.dart';
import '../bloc/pet_event.dart';
import '../bloc/pet_state.dart';
import '../models/pet_data_model.dart';

class AddPetVaccinationDetailScreen extends StatefulWidget {
  final String appTitle;
  final PetData? petData;
  const AddPetVaccinationDetailScreen({
    super.key,
    this.petData,
    required this.appTitle,
  });

  @override
  State<AddPetVaccinationDetailScreen> createState() =>
      _AddPetVaccinationDetailScreenState();
}

class _AddPetVaccinationDetailScreenState
    extends State<AddPetVaccinationDetailScreen> {
  late PetBloc petBloc;
  bool isVaccinated = false;
  bool isRemindMe = false;
  Map<String, TextEditingController> controllers = {
    'vaccinationDate': TextEditingController(),
    'nextVaccinationDate': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'vaccinationDate': FocusNode(),
    'nextVaccinationDate': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'vaccinationDate': "",
    'nextVaccinationDate': "",
  };

 // File? selectedFile;
  String? uploadedFileName;
  File? selectProfilePhoto;
  String? selectProfilePhotoPath;
  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  OverlayEntry? overlayEntry;
  bool isImageSelected = false;
  String imageErrorMessage = '';

  void setData() {
    if (widget.petData?.name == null) {
      return;
    }
    String? vaccinationDateString = widget.petData!.vaccinationDate;
    String? nextVaccinationDateString = widget.petData!.nextVaccinationDate;

    DateTime? vaccinationDateTime;
    DateTime? nextVaccinationDateTime;

    if (vaccinationDateString != null && vaccinationDateString.isNotEmpty) {
      vaccinationDateTime = DateTime.tryParse(vaccinationDateString);
    }

    if (nextVaccinationDateString != null && nextVaccinationDateString.isNotEmpty) {
      nextVaccinationDateTime = DateTime.tryParse(nextVaccinationDateString);
    }

    controllers['vaccinationDate']?.text = vaccinationDateTime != null
        ? projectUtil.uiShowDateFormat(vaccinationDateTime)
        : '';

    controllers['nextVaccinationDate']?.text = nextVaccinationDateTime != null
        ? projectUtil.uiShowDateFormat(nextVaccinationDateTime)
        : '';

    isVaccinated = widget.petData!.vaccinated ?? false;
    isRemindMe = widget.petData!.remindMe ?? false;
    uploadedFileName = widget.petData?.document?.isNotEmpty == true
        ? (widget.petData!.documentFilename ?? "")
        : "";
    selectProfilePhotoPath = widget.petData!.document ?? '';
  }

  @override
  void initState() {
    petBloc = BlocProvider.of<PetBloc>(context);
    super.initState();
    setData();
  }

  Widget isVaccinatedField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        onTapCallBack: () {
          setState(() {
            isVaccinated = !isVaccinated;
          });
        },
        focusNode: focusNodes[''],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['']?.toString() ?? '',
        readOnly: true,
        controllerT: controllers[''],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 10,
        errorMsgHeight: 20,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.none,
        cursorColor: Colors.grey,
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: 'Vaccinated',
        hintStyle: appStyles.textFieldTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldSuffixIcon: Padding(
          padding: const EdgeInsets.all(4), // Fallback padding
          child: SizedBox(
            width: 10,
            height: 10,
            child: Checkbox(
              checkColor: AppColors.white,
              fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xff077FC8); // When checked
                  }
                  return Colors.transparent; // When not checked
                },
              ),
              side: BorderSide(
                color: isVaccinated
                    ? const Color(0xff077FC8)
                    : Colors.black.withOpacity(0.8), // Border color
                width: 1,
              ),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(8), // Border radius
              // ),
              value: isVaccinated,
              onChanged: (value) {
                setState(() {
                  isVaccinated = value ?? false;
                });
              },
            ),
          ),
        ),
        onTextChange: (value) {
          // Handle text changes if needed
        },
        onEndEditing: (value) {
          // Handle end editing if needed
        },
      ),
    );
  }

  Widget vaccinationDateField(BuildContext context) {
    return Visibility(
      visible: isVaccinated,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData(
                    primaryColor:
                        const Color(0xff077FC8), // Header background color
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xff077FC8), // Confirm button color
                      onPrimary: Colors.white, // Confirm button text color
                      onSurface: Colors.black, // Date text color
                    ),
                    dialogBackgroundColor: Colors.white, // Background color
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              String formattedDate = projectUtil.uiShowDateFormat(pickedDate);
              setState(() {
                controllers['vaccinationDate']?.text =
                    formattedDate; // Update the text field
              });
            }
          },
          focusNode: focusNodes['vaccinationDate'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['vaccinationDate']?.toString() ?? '',
          readOnly: true,
          controllerT: controllers['vaccinationDate'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 10,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: 'Vaccination Date',
                style: appStyles.texFieldPlaceHolderStyle(),
                children: [
                  // TextSpan(
                  //   text: ' *',
                  //   style: appStyles
                  //       .texFieldPlaceHolderStyle()
                  //       .copyWith(color: Colors.red),
                  // ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.done,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.phone,
          hintText: 'Select the Vaccination Date',
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon:  WorkplaceWidgets.calendarIcon(),
          onTextChange: (value) {
            // Handle text changes if needed
          },
          onEndEditing: (value) {
            // Handle end editing if needed
          },
        ),
      ),
    );
  }

  Widget nextVaccinationDateField(BuildContext context) {
    return Visibility(
      visible: isVaccinated,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData(
                    primaryColor:
                        const Color(0xff077FC8), // Header background color
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xff077FC8), // Confirm button color
                      onPrimary: Colors.white, // Confirm button text color
                      onSurface: Colors.black, // Date text color
                    ),
                    dialogBackgroundColor: Colors.white, // Background color
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              String formattedDate =
              projectUtil.uiShowDateFormat(pickedDate);
              setState(() {
                controllers['nextVaccinationDate']?.text =
                    formattedDate; // Update the text field
              });
            }
          },
          focusNode: focusNodes['nextVaccinationDate'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['nextVaccinationDate']?.toString() ?? '',
          readOnly: true,
          controllerT: controllers['nextVaccinationDate'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 10,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: 'Next Vaccination Date',
                style: appStyles.texFieldPlaceHolderStyle(),
                children: [
                  // TextSpan(
                  //   text: ' *',
                  //   style: appStyles
                  //       .texFieldPlaceHolderStyle()
                  //       .copyWith(color: Colors.red),
                  // ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.done,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.phone,
          hintText: 'Select the next Vaccination Date',
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon:  WorkplaceWidgets.calendarIcon(),
          onTextChange: (value) {
            // Handle text changes if needed
          },
          onEndEditing: (value) {
            // Handle end editing if needed
          },
        ),
      ),
    );
  }

  Widget remindMe() {
    return Visibility(
      visible: isVaccinated,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: () {
              setState(() {
                isRemindMe = !isRemindMe;
              });
            },
          focusNode: focusNodes[''],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['']?.toString() ?? '',
          readOnly: true,
          controllerT: controllers[''],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 10,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: 'Remind Me',
                style: appStyles.texFieldPlaceHolderStyle(),
                children: [
                  // TextSpan(
                  //   text: ' *',
                  //   style: appStyles
                  //       .texFieldPlaceHolderStyle()
                  //       .copyWith(color: Colors.red),
                  // ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.done,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.phone,
          hintText: 'Remind Me',
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon: Padding(
            padding: const EdgeInsets.all(4), // Fallback padding
            child: SizedBox(
              width: 10,
              height: 10,
              child: Checkbox(
                checkColor: AppColors.white,
                fillColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Color(0xff077FC8); // When checked
                    }
                    return Colors.transparent; // When not checked
                  },
                ),
                side: BorderSide(
                  color: isRemindMe
                      ? const Color(0xff077FC8)
                      : Colors.black.withOpacity(0.8), // Border color
                  width: 1,
                ),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(8), // Border radius
                // ),
                value: isRemindMe,
                onChanged: (value) {
                  setState(() {
                    isRemindMe = value ?? false;
                  });
                },
              ),
            ),
          ),
          onTextChange: (value) {
            // Handle text changes if needed
          },
          onEndEditing: (value) {
            // Handle end editing if needed
          },
        ),
      ),
    );
  }

  bool validateFields({isButtonClicked = false}) {
    if (controllers['vaccinationDate']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['vaccinationDate']);
            setState(() {
              errorMessages['vaccinationDate'] =
                  'Please select vaccination date';
            });
          }
        });
      }
      return false;
    } else if (controllers['nextVaccinationDate']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context)
                .requestFocus(focusNodes['nextVaccinationDate']);
            setState(() {
              errorMessages['nextVaccinationDate'] =
                  'Please select next vaccination date';
            });
          }
        });
      }
      return false;
    } else {
      return true;
    }
  }

/*  bool isImage(File? selectedFile) {
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp']
        .contains(selectedFile?.path.split('.').last.toLowerCase());
  }

  documentUpload() {
    return Visibility(
      visible: isVaccinated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5),
            child: Text(
              'Upload Document',
              style: appStyles.texFieldPlaceHolderStyle(),
            ),
          ),
          GestureDetector(
            onTap: () {
              pickFile();
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0).copyWith(top: 0, bottom: 0),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(width: 0.8, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 3,
                          offset: const Offset(0, 1),
                          blurRadius: 3)
                    ]),
                padding: const EdgeInsets.all(8)
                    .copyWith(top: 0, bottom: 0, left: 0),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          border:
                              Border.all(width: 0.8, color: Colors.transparent),
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
                          if (selectedFile != null &&
                              selectedFile?.path.isNotEmpty == true)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  isImage(selectedFile)
                                      ? Image.file(
                                          selectedFile!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.picture_as_pdf,
                                            size: 40,
                                            color: Colors.red,
                                          ),
                                        ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: removeFile,
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
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.image,
                                          size: 24, color: Colors.grey)),
                                  Text(
                                    'Upload',
                                    style: appStyles.userJobTitleTextStyle(
                                        fontSize: 14,
                                        texColor: Colors.grey.shade600),
                                  ),
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
                          // Text('Allowed types: jpeg, png, jpg, pdf', style: appStyles.userJobTitleTextStyle(fontSize: 14, texColor: Colors.grey.shade600)),
                          Text('Allowed types: jpeg, png, jpg, svg',
                              style: appStyles.userJobTitleTextStyle(
                                  fontSize: 14,
                                  texColor: Colors.grey.shade600)),
                          const SizedBox(
                            height: 2,
                          ),
                          Text('Up to 5MB size',
                              style: appStyles.userJobTitleTextStyle(
                                  fontSize: 14,
                                  texColor: Colors.grey.shade600)),
                          const SizedBox(
                            height: 2,
                          ),
                          Text('Maximum of 1 document',
                              style: appStyles.userJobTitleTextStyle(
                                  fontSize: 14,
                                  texColor: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/

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

  void _removeImage() {
    setState(() {
      selectProfilePhoto = null;
      selectProfilePhotoPath = null;
    });
  }

  imageUpload() {
    return Visibility(
      visible: isVaccinated,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 10),
              child: Text(
                'Upload Document',
                style: appStyles.texFieldPlaceHolderStyle(),
              ),
            ),
            GestureDetector(
              onTap: () => photoPickerBottomSheet(),
              child: Padding(
                padding: const EdgeInsets.all(18.0).copyWith(top: 0,bottom: 0),
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
                            if (selectProfilePhotoPath != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  children: [
                                    selectProfilePhotoPath!.contains('https')
                                        ? Image.network(
                                      selectProfilePhotoPath!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ):
                                    Image.file(
                                      File(selectProfilePhotoPath!),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: _removeImage,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget submitButton(state) {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18, top: 20),
      child: AppButton(
        buttonName: AppString.submitButton,
        buttonColor: AppColors.appBlueColor,
        isLoader: state is StorePetVaccinationDetailLoadingState? true: false,
        //  buttonColor: validateFields() ? AppColors.textBlueColor : Colors.grey,
        backCallback: () {
          // if (validateFields(isButtonClicked: true)) {}
          //  if(isVaccinated == false)
          //  {
          //    controllers['nextVaccinationDate']?.text =  '';
          //    controllers['vaccinationDate']?.text ='';
          //    selectedFile = null;
          //    isRemindMe = false;
          //  }
          if (widget.petData!.id != null) {

            DateTime? formattedVaccinationDate = projectUtil.parseDisplayDate(controllers['vaccinationDate']?.text ?? '');

            String formattedSubmissionVaccinationDate = '';

            if (formattedVaccinationDate != null) {
              formattedSubmissionVaccinationDate = projectUtil.submitDateFormat(formattedVaccinationDate); // e.g., '2025-05-30'
            }

            DateTime? formattedNextVaccinationDate = projectUtil.parseDisplayDate(controllers['nextVaccinationDate']?.text  ?? '');

            String formattedNextSubmissionVaccinationDate = '';

            if (formattedNextVaccinationDate != null) {
              formattedNextSubmissionVaccinationDate = projectUtil.submitDateFormat(formattedNextVaccinationDate); // e.g., '2025-05-30'
            }



            petBloc.add(OnStorePetVaccinationDetailEvent(
              mContext: context,
              vaccinated: isVaccinated == true ? 1 : 0,
              vaccinationDate: formattedSubmissionVaccinationDate,
              nextVaccinationDate: formattedNextSubmissionVaccinationDate,
              remindMe: isRemindMe == true ? 1 : 0,
              document:  selectProfilePhotoPath ?? '',
              documentFileName: uploadedFileName,
              petId: widget.petData!.id ?? 0,
            ));
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
      isListScrollingNeed: false,
      appBarHeight: 50,
      appBar: CommonAppBar(
        title: widget.appTitle,
      ),
      containChild: BlocListener<PetBloc, PetState>(
        listener: (context, state) {
          if (state is StorePetVaccinationDetailErrorState) {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text(state.errorMessage),
            //   backgroundColor: Colors.red,
            // ));
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return WorkplaceWidgets.errorContentPopup(
                      onPressedButton: () {
                        Navigator.pop(context);
                        FocusScope.of(context).unfocus();
                      },
                      content: state.errorMessage,
                      buttonName: AppString.ok);
                });
          }
          if (state is StorePetVaccinationDetailDoneState) {
            if (widget.appTitle == AppString.petVaccinationInfo)
              Navigator.pop(context);
            Navigator.pop(context);
            widget.appTitle == AppString.editPetVaccinationInfo ?
            WorkplaceWidgets.successToast(

                 AppString.editPetPetVaccinationDetailSuccessfully) :

            WorkplaceWidgets.successToast(AppString.petVaccinationDetailAddedSuccessfully );
          }
        },
        child: BlocBuilder<PetBloc, PetState>(
          bloc: petBloc,
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    isVaccinatedField(),
                    vaccinationDateField(context),
                    nextVaccinationDateField(context),
                    remindMe(),
                   // documentUpload(),
                    imageUpload(),
                    submitButton(state),
                    const SizedBox(height: 10),
                  ],
                ),
                // if (state is StorePetVaccinationDetailLoadingState)
                //   WorkplaceWidgets.progressLoader(context),
              ],
            );
          },
        ),
      ),
    );
  }
}
