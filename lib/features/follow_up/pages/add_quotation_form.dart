import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../my_unit/widgets/common_image_view.dart';
import '../bloc/follow_up_bloc.dart';
import '../bloc/follow_up_event.dart';
import '../bloc/follow_up_state.dart';

class AddQuotationForm extends StatefulWidget {
  final int taskId;
  const AddQuotationForm({super.key, required this.taskId});

  @override
  State<AddQuotationForm> createState() => _AddQuotationFormState();
}

class _AddQuotationFormState extends State<AddQuotationForm> {
  late FollowUpBloc followUpBloc;

  // controllers & focus nodes
  final Map<String, TextEditingController> controllers = {
    'amount': TextEditingController(),
    'vendorName': TextEditingController(),
  };
  final Map<String, FocusNode> focusNodes = {
    'amount': FocusNode(),
    'vendorName': FocusNode(),
  };

  // image selection
  String? selectProfilePhotoPath;
  File? selectProfilePhoto;
  String imageErrorMessage = '';

  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  OverlayEntry? overlayEntry;
  bool isImageSelected = false;
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  @override
  void initState() {
    super.initState();
    followUpBloc = BlocProvider.of<FollowUpBloc>(context);
  }

  @override
  void dispose() {
    controllers.forEach((key, c) => c.dispose());
    focusNodes.forEach((key, f) => f.dispose());
    super.dispose();
  }
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

              /// 👉 Instead of only closing, navigate to ImageViewPage
              Navigator.pop(context1); // close bottom sheet first
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: ImageViewPage(
                    imageUrl: selectProfilePhotoPath!,
                    title: 'Image Preview',
                    subTitle: AppString.nocReport,
                    fromFilePicker: true,
                    onUploadCallback: (imageUrl) {
                      // Do something specific for Screen A
                      // accountBloc.add(OnUploadVoucherImageEvent(filePath: selectProfilePhotoPath ?? ''));
                    },
                  ),
                ),
              );
            }
          } catch (e) {
            debugPrint('$e');
          }
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

              /// 👉 Close bottom sheet + navigate
              Navigator.pop(context1);
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: ImageViewPage(
                    imageUrl: selectProfilePhotoPath!,
                    title: 'Image Preview',
                    subTitle: AppString.nocReport,
                    fromFilePicker: true,
                    onUploadCallback: (imageUrl) {
                      // Do something specific for Screen A
                      // accountBloc.add(OnUploadVoucherImageEvent(filePath: selectProfilePhotoPath ?? ''));
                    },
                  ),
                ),
              );
            }
          } catch (e) {
            debugPrint('$e');
          }
        },
      ),
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(photoPickerBottomSheetCardRadius)),
      ),
    );
  }
  /// ----- Voucher Image Upload -----
  Widget quotationImageUpload(state) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, bottom: 0, top: 20, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: AppString.quotationImage,
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
          const SizedBox(height: 12),

          GestureDetector(
            onTap: () {
              if (!isImageSelected) {
                photoPickerBottomSheet();
                closeKeyboard();
              } else {
                Navigator.of(context).push(FadeRoute(
                    widget: FullPhotoView(
                      title: "Quotation",
                      localProfileImgUrl: selectProfilePhotoPath ?? '',
                    )));
              }
            },
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue.shade600,
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              child: isImageSelected && selectProfilePhotoPath != null
                  ? Stack(
                children: [
                  if (state is DeleteCommentDoneState)
                    Center(child: WorkplaceWidgets.progressLoader(context))
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(selectProfilePhotoPath!),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  /// Remove button
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
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cloud_upload_outlined,
                      color: AppColors.appBlueColor, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "Click to upload Quotation image",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Supports JPG, PNG, GIF up to 5MB",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeImage() {
    setState(() {
      isImageSelected = false;
      selectProfilePhotoPath = null;
    });
  }

  /// ----- Amount Field -----
  Widget amountField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: CommonTextFieldWithError(
        focusNode: focusNodes['amount'],
        controllerT: controllers['amount'],
        borderRadius: 8,
        inputHeight: 50,
        maxCharLength: 10,
        showError: true,
        cursorColor: Colors.grey,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        placeHolderTextWidget: Text.rich(
          TextSpan(
            text: AppString.amount,
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
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.numberWithDecimal,
        hintText: AppString.enterAmount,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        onTextChange: (value) => setState(() {}),
        onEndEditing: (value) {
          FocusScope.of(context).requestFocus(focusNodes['vendorName']);
        },
      ),
    );
  }

  /// ----- Vendor Name Field -----
  Widget vendorNameField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: CommonTextFieldWithError(
        focusNode: focusNodes['vendorName'],
        controllerT: controllers['vendorName'],
        borderRadius: 8,
        inputHeight: 50,
        maxCharLength: 50,
        showError: true,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Text.rich(
          TextSpan(
            text: "Vendor Name",
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
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.text,
        hintText: "Enter Vendor Name",
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        onTextChange: (value) => setState(() {}),
        onEndEditing: (value) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  bool areMandatoryFieldsFilled() {
    return isImageSelected &&
        controllers['amount']!.text.isNotEmpty &&
        controllers['vendorName']!.text.isNotEmpty;
  }

  Widget submitButton(state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),      child: AppButton(
        buttonName: "Submit Quotation",

        buttonColor:
        areMandatoryFieldsFilled() ? AppColors.textBlueColor : Colors.grey,
        backCallback: areMandatoryFieldsFilled()
            ? () {
          followUpBloc.add(OnAddQuotationEvent(
            taskId: widget.taskId, // pass proper taskId
            vendorName: controllers['vendorName']!.text,
            amount: int.parse(controllers['amount']!.text),
            attachment: selectProfilePhotoPath,
            mContext: context, // not needed, but required by event
          ));
        }
            : null,
        isLoader: state is AddQuotationLoadingState ? true: false
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      appBar: const CommonAppBar(title: "Add Quotation"),
      containChild: BlocListener<FollowUpBloc, FollowUpState>(
        bloc: followUpBloc,
        listener: (context, state) {
          if (state is AddQuotationErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is AddQuotationDoneState) {
            Navigator.pop(context, true);
            WorkplaceWidgets.successToast(state.message);
          }
        },
        child: BlocBuilder<FollowUpBloc, FollowUpState>(
          bloc: followUpBloc,
          builder: (context, state) {
            return Column(
              children: [
                vendorNameField(),
                amountField(),
                quotationImageUpload(state),
                const SizedBox(height: 40),
                submitButton(state),
              ],
            );
          },
        ),
      ),
    );
  }
}
