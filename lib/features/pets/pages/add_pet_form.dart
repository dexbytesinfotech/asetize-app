import '../../../imports.dart';
import 'package:intl/intl.dart';
import '../bloc/pet_bloc.dart';
import '../bloc/pet_event.dart';
import '../bloc/pet_state.dart';
import '../models/pet_data_model.dart';
import 'add_pet_vacination_detail_screen.dart';

class AddPetForm extends StatefulWidget {
  final String appTitle;
  final PetData? petData;

  const AddPetForm({
    super.key,
    required this.appTitle,
    this.petData,
  });

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  late PetBloc petBloc;
  final List<String> genderOptions = ['Male', 'Female'];
  Map<String, TextEditingController> controllers = {
    'petName': TextEditingController(),
    'petType': TextEditingController(),
    'petBreed': TextEditingController(),
    'gender': TextEditingController(),
    'dob': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'petName': FocusNode(),
    'petType': FocusNode(),
    'petBreed': FocusNode(),
    'gender': FocusNode(),
    'dob': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'petName': "",
    'petType': "",
    'petBreed': "",
    'gender': "",
    'dob': "",
  };
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  List petTypesData = [];

  List<String> petTypeList = [];

  List<String> breedType = [];

  @override
  void initState() {
    petBloc = BlocProvider.of<PetBloc>(context);
    petTypesData = MainAppBloc.systemSettingData['pet_types'] ?? [];
    petTypeList = petTypesData.map((item) => item['name'].toString()).toList();

    setData();

    super.initState();
  }

  String? selectProfilePhotoPath;
  String? uploadedFileName;
  File? selectProfilePhoto;
  Map<String, File>? imageFile;
  Map<String, String>? imagePath;

  void photoPickerBottomSheet() {
    showModalBottomSheet(
        context: MainAppBloc.getDashboardContext,
        builder: (context1) => PhotoPickerBottomSheet(
              cropEnable: true,
              isRemoveOptionNeeded: false,
              removedImageCallBack: () {
                Navigator.pop(context1);
                setState(() {
                  selectProfilePhotoPath = "";
                });
              },
              selectedImageCallBack: (fileList) {
                Navigator.pop(context1);
                try {
                  if (fileList != null && fileList.length > 0) {
                    fileList.map((fileDataTemp) {
                      File imageFileTemp = File(fileDataTemp.path);
                      selectProfilePhoto = imageFileTemp;
                      selectProfilePhotoPath = selectProfilePhoto!.path;
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
                      String mapKey =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      imageFile![mapKey] = imageFileTemp; // = imageFileTemp;
                      imagePath![mapKey] = imageFileTemp.path;
                    }).toList(growable: false);
                    setState(() {});
                    BlocProvider.of<UserProfileBloc>(context).add(
                        UploadMediaEvent(
                            imagePath: imagePath!.values.first,
                            mContext: context));
                  }
                } catch (e) {
                  debugPrint('$e');
                }
              },
              selectedCameraImageCallBack: (fileList) {
                Navigator.pop(context1);
                try {
                  if (fileList != null && fileList.path!.isNotEmpty) {
                    File imageFileTemp = File(fileList.path!);
                    selectProfilePhoto = imageFileTemp;
                    selectProfilePhotoPath = selectProfilePhoto!.path;
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
                    String mapKey =
                        DateTime.now().microsecondsSinceEpoch.toString();
                    imageFile![mapKey] = imageFileTemp; // = imageFileTemp;
                    imagePath![mapKey] = imageFileTemp.path;
                    setState(() {});
                    BlocProvider.of<UserProfileBloc>(context).add(
                        UploadMediaEvent(
                            imagePath: imagePath!.values.first,
                            mContext: context));
                  }
                } catch (e) {
                  debugPrint('$e');
                }
              },
            ),
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(photoPickerBottomSheetCardRadius))));
  }

  Widget profilePhoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appBlueColor.withOpacity(0.5),
              ),
              child: CircularImage(
                height: 110,
                width: 110,
                image: (selectProfilePhotoPath != null &&
                        selectProfilePhotoPath?.isNotEmpty == true)
                    ? selectProfilePhotoPath
                    : "assets/images/dog_image.png",
                name: "",
                isClickToFullView: true,
              ),
            ),
            InkWell(
              onTap: () {
                photoPickerBottomSheet();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 1, left: 55),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    shape: BoxShape.circle,
                    color: AppColors.appBlueColor.withOpacity(0.9)),
                child: WorkplaceIcons.iconImage(
                  iconSize: const Size(20, 20),
                  imageColor: Colors.white,
                  imageUrl: WorkplaceIcons.editIcon,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  checkPetName(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_nameRegex.hasMatch(value.trim())) {
            errorMessages['petName'] = "";
          } else {
            if (!onchange) {
              errorMessages['petName'] = 'Please enter valid pet name';
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['petName'] = 'Please enter pet name';
          }
        });
      });
    }
  }

  Widget petNameField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['petName'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['petName']?.toString() ?? '',
        controllerT: controllers['petName'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 20,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.characters,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: 'Pet Name',
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
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.text,
        hintText: 'Pet Name',
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          checkPetName(value, onchange: true);
        },
        onEndEditing: (value) {
          checkPetName(value);
          FocusScope.of(context).requestFocus(focusNodes['petType']);
        },
      ),
    );
  }

  void showPetTypeBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: 'Select Pet Type',
      valuesList: petTypeList,
      selectedValue: controllers['petType']?.text ?? "",
      onValueSelected: (value) {
        //clear field when user select pet type
        controllers['petBreed']?.text = '';
        controllers['petType']?.text = value;
        //get breed type list from pet type
        breedType = getDataByName(value);
      },
    );
  }

  List<String> getDataByName(String selectedName) {
    var pet = petTypesData.firstWhere(
      (item) => item['name'] == selectedName,
      orElse: () => {'data': []},
    );

    return List<String>.from(pet['data']);
  }

  Widget petTypeField() => Container(
        margin: const EdgeInsets.only(left: 20, right: 20,),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: () {
            showPetTypeBottomSheet(context);
          },
          focusNode: focusNodes['petType'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['petType']?.toString() ?? '',
          readOnly: true,
          controllerT: controllers['petType'],
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
                  text: 'Pet Type',
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
          isShowShadow: false,
          enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
          errorBorderColor: AppColors.appErrorTextColor,
          focusedBorderColor: AppColors.appBlueColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.done,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.phone,
          hintText: 'Select the Pet Type',
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),


            onTextChange: (value) {},
          onEndEditing: (value) {},
        ),
      );

  void showBreedTypeBottomSheet(BuildContext context) {
    if (breedType.isNotEmpty) {
      WorkplaceWidgets.showCustomAndroidBottomSheet(
        context: context,
        title: 'Select Breed Type',
        valuesList: breedType,
        selectedValue: controllers['petBreed']?.text ?? "",
        onValueSelected: (value) {
          setState(() {
            controllers['petBreed']?.text = value;
          });
        },
      );
    }
  }

  Widget breedTypeField() => Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: () {
            showBreedTypeBottomSheet(context);
          },
          focusNode: focusNodes['petBreed'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['petBreed']?.toString() ?? '',
          readOnly: true,
          controllerT: controllers['petBreed'],
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
                  text: 'Breed Type',
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
          isShowShadow: false,
          enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
          errorBorderColor: AppColors.appErrorTextColor,
          focusedBorderColor: AppColors.appBlueColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.done,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.phone,
          hintText: 'Select the Breed Type',
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),


            onTextChange: (value) {},
          onEndEditing: (value) {},
        ),
      );

  void showGenderBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: AppString.selectGender,
      valuesList: genderOptions,
      selectedValue: controllers['gender']?.text.toString() ?? "",
      onValueSelected: (value) {
        controllers['gender']?.text = value;
      },
    );
  }

  Widget genderField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        onTapCallBack: () {
          showGenderBottomSheet(context);
        },
        focusNode: focusNodes['gender'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['gender']?.toString() ?? '',
        readOnly: true,
        controllerT: controllers['gender'],
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
                text: 'Gender',
                style: appStyles.texFieldPlaceHolderStyle(),
                children: const [
                  // TextSpan(
                  //   text: ' *',
                  //   style: appStyles
                  //       .texFieldPlaceHolderStyle()
                  //       .copyWith(color: Colors.red),
                  // ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: 'Select the Gender',
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),


          onTextChange: (value) {
          //  checkPhoneNumber(value, onchange: true);
        },
        onEndEditing: (value) {
          // checkPhoneNumber(value);
          // FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget dobField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20,),
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
              controllers['dob']?.text = formattedDate; // Update the text field
            });
          }
        },
        focusNode: focusNodes['dob'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['dob']?.toString() ?? '',
        readOnly: true,
        controllerT: controllers['dob'],
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
              text: 'Date of Birth',
              style: appStyles.texFieldPlaceHolderStyle(),
              children: const [
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
        isShowShadow: false,
        enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
        errorBorderColor: AppColors.appErrorTextColor,
        focusedBorderColor: AppColors.appBlueColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: 'Select the DOB',
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
    );
  }

  bool validateFields({isButtonClicked = false}) {
    if (controllers['petName']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['petName']);
            setState(() {
              errorMessages['petName'] = 'Please enter pet name';
            });
          }
        });
      }
      return false;
    } else if (controllers['petType']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['petType']);
            setState(() {
              errorMessages['petType'] = 'Please select pet type';
            });
          }
        });
      }
      return false;
    } else if (controllers['petBreed']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['petBreed']);
            setState(() {
              errorMessages['petBreed'] = 'Please select breed type';
            });
          }
        });
      }
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget submitButton(state) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          isLoader: state is StorePetInformationLoadingState ?  true : false,
          buttonName: AppString.submit,
          buttonColor: controllers['petName']?.text.isNotEmpty == true &&
                  controllers['petType']?.text.isNotEmpty == true &&
                  controllers['petBreed']?.text.isNotEmpty == true
              ? AppColors.textBlueColor
              : Colors.grey,
          backCallback: () {
            if (validateFields()) {
              DateTime? dob = projectUtil.parseDisplayDate(controllers['dob']?.text ?? '');

              String formattedPetDob = '';

              if (dob != null) {
                formattedPetDob = projectUtil.submitDateFormat(dob); // e.g., '2025-05-30'
              }




              // String petDob = projectUtil.submitDateFormat(
              //     DateTime.parse(controllers['dob']?.text ?? '')
              // );
              /// In this case we will call Update profile URL
              if (widget.petData != null) {
                if (widget.petData!.id != null) {

                  petBloc.add(OnUpdatePetDetailEvent(
                    mContext: context,
                    name: controllers['petName']?.text,
                    type: controllers['petType']?.text,
                    breed: controllers['petBreed']?.text,
                    gender: controllers['gender']?.text.toLowerCase(),
                    dob: formattedPetDob,
                    photo: selectProfilePhotoPath,
                    fileName: uploadedFileName,
                    petId: widget.petData!.id,
                  ));
                } else {}
              } else {
                petBloc.add(OnStorePetInformationEvent(
                  mContext: context,
                  name: controllers['petName']?.text,
                  type: controllers['petType']?.text,
                  breed: controllers['petBreed']?.text,
                  gender: controllers['gender']?.text.toLowerCase(),
                  dob: formattedPetDob,
                  photo: selectProfilePhotoPath,
                ));
              }
            }
          },
        ),
      );
    }



    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isListScrollingNeed: false,
      appBar: CommonAppBar(
        title: widget.appTitle,
      ),
      containChild: BlocListener<PetBloc, PetState>(
        listener: (context, state) {
          if (state is StorePetInformationErrorState) {
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

          if (state is StorePetInformationDoneState) {
            WorkplaceWidgets.successToast(
                 AppString.petAddedSuccessfully);
            Navigator.push(
                context,
                SlideLeftRoute(
                    widget: AddPetVaccinationDetailScreen(
                          petData: state.petId != null
                              ? PetData(id: state.petId)
                              : null,
                          appTitle: AppString.petVaccinationInfo,
                        )));
          }
          if (state is UpdatePetDetailDoneState) {
            Navigator.pop(context);
            WorkplaceWidgets.successToast(AppString.updatePetInfoSuccessfully);
          }
        },
        child: BlocBuilder<PetBloc, PetState>(
          bloc: petBloc,
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 5),
                    profilePhoto(),
                    petNameField(),
                    petTypeField(),
                    breedTypeField(),
                    genderField(),
                    dobField(context),
                    submitButton(state),
                  ],
                ),
                // if (state is StorePetInformationLoadingState)
                //   WorkplaceWidgets.progressLoader(context),
              ],
            );
          },
        ),
      ),
    );
  }

  void setData() {
    if (widget.petData == null) {
      return;
    }
    controllers['petName']?.text = widget.petData!.name ?? '';
    controllers['petType']?.text = widget.petData!.type ?? '';
    controllers['petBreed']?.text = widget.petData!.breed ?? '';
    controllers['gender']?.text = widget.petData!.gender ?? '';
    String? dobString = widget.petData!.dob;
    DateTime? dobDateTime;

    if (dobString != null && dobString.isNotEmpty) {
      dobDateTime = DateTime.tryParse(dobString);
    }

    controllers['dob']?.text = dobDateTime != null
        ? projectUtil.uiShowDateFormat(dobDateTime)
        : '';
    uploadedFileName = widget.petData!.photo == null
        ? ""
        : (widget.petData!.photo!.isNotEmpty
            ? (widget.petData!.filename ?? "")
            : "");
    selectProfilePhotoPath = widget.petData!.photo ?? "";
  }
}
