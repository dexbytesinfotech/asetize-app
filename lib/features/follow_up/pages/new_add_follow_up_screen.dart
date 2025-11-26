import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../booking/widgets/label_widget.dart';
import '../bloc/follow_up_bloc.dart';
import '../bloc/follow_up_event.dart';
import '../bloc/follow_up_state.dart';
import '../models/get_follow_up_list_model.dart';

class AddFollowUpScreen extends StatefulWidget {
  final List<Houses>? houses;
  final bool isComeFromDetail;
  final int? taskId;
  final bool isEditMode;
  final GetFollowUpListData? getFollowUpListData;
  const AddFollowUpScreen(
      {super.key,
       this.houses,
        this.getFollowUpListData,
        this.isEditMode = false,
      this.isComeFromDetail = false,
      this.taskId});

  @override
  State<AddFollowUpScreen> createState() => _AddFollowUpScreenState();
}

class _AddFollowUpScreenState extends State<AddFollowUpScreen> {
  late UserProfileBloc userProfileBloc;
  DateTime? nextFollowUpDate;
  String? selectedFollowUpStatus;
  late FollowUpBloc followUpBloc;

  final List<String> followUpStatusOptions = [
    'Follow Up',
    'Agreed',
    "Didn't Pick",
    'Completed',
  ];
  Houses? selectedUnit;
  String? status;
  int? id;
  String? title;
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController followUpStatusController =
      TextEditingController();
  final TextEditingController nextFollowUpDateController =
      TextEditingController();
  final FocusNode remarkFocusNode = FocusNode();
  final FocusNode followUpStatusFocusNode = FocusNode();
  final FocusNode nextFollowUpDateFocusNode = FocusNode();


  void setData() {
    if(widget.isEditMode == false){
      return ;
    }
    remarkController.text = widget.getFollowUpListData?.remark ?? '';
    followUpStatusController.text = widget.getFollowUpListData?.status ?? '';
    nextFollowUpDateController.text = widget.getFollowUpListData?.followupDate ?? '';

    if (widget.getFollowUpListData?.followupDate != null &&
        widget.getFollowUpListData!.followupDate!.isNotEmpty) {
      nextFollowUpDate = projectUtil.parseDisplayDate(
        widget.getFollowUpListData!.followupDate!,
      );
    }
  }


  @override
  void initState() {
    super.initState();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    followUpBloc = BlocProvider.of<FollowUpBloc>(context);
    setData();

  }

  @override
  void dispose() {
    remarkController.dispose();
    followUpStatusController.dispose();
    nextFollowUpDateController.dispose();
    remarkFocusNode.dispose();
    followUpStatusFocusNode.dispose();
    nextFollowUpDateFocusNode.dispose();
    super.dispose();
  }

  
  void selectDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: nextFollowUpDate ?? DateTime.now(),
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
        nextFollowUpDate = newDate;
        nextFollowUpDateController.text = projectUtil.uiShowDateFormat(newDate);
      });
    }
  }

  Widget nextFollowUpDateWidget() {
    return CommonTextFieldWithError(
      focusNode: nextFollowUpDateFocusNode,
      controllerT: nextFollowUpDateController,
      borderRadius: 8,
      errorMsgHeight: 20,
      showError: true,
      inputHeight: 50,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 50,
      readOnly: true,
      autoFocus: false,
      inputFieldSuffixIcon: WorkplaceWidgets.calendarIcon(),
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.done,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: AppString.pickADate,
      placeHolderTextWidget: const LabelWidget(
          labelText: AppString.nextFollowUpDate, isRequired: true),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () => selectDate(context),
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  void showStatusBottomSheet(BuildContext context) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: 'Select Status',
      valuesList: followUpBloc.statuses
          .map((e) =>
          projectUtil.formatForDisplay(e))
          .toList(),
      selectedValue: followUpStatusController.text,
      onValueSelected: (value) {
        setState(() {
          followUpStatusController.text = value;
          selectedFollowUpStatus = value;
        });
      },
    );
  }

  Widget followUpStatusWidget() {
    return CommonTextFieldWithError(
      key: ValueKey(followUpStatusController.text),
      focusNode: followUpStatusFocusNode,
      controllerT: followUpStatusController,
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
      textInputAction: TextInputAction.done,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: AppString.selectStatus,
      placeHolderTextWidget:
          const LabelWidget(labelText: AppString.followUpStatus),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () {
        FocusScope.of(context).unfocus();
        showStatusBottomSheet(context);
      },
      onTextChange: (value) {
        selectedFollowUpStatus = value;
      },
      onEndEditing: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget remarkWidget() {
    return CommonTextFieldWithError(
      focusNode: remarkFocusNode,
      controllerT: remarkController,
      borderRadius: 8,
      inputHeight: 140,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 500,
      minLines: 3,
      maxLines: 3,
      autoFocus: false,
      showCounterText: false,
      capitalization: CapitalizationText.sentences,
      cursorColor: Colors.grey,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.newline,
      borderStyle: BorderStyle.solid,
      inputKeyboardType: InputKeyboardTypeWithError.multiLine,
      hintText: AppString.writeAdditionalNote,
      placeHolderTextWidget:
          const LabelWidget(labelText: AppString.remark, isRequired: false),
      contentPadding: const EdgeInsets.all(10),
      onTextChange: (value) {},
      onEndEditing: (value) {},
    );
  }

  bool areMandatoryFieldsFilled() {
    return widget.isComeFromDetail == true
        ? nextFollowUpDate != null || nextFollowUpDateController.text.isNotEmpty
        : followUpStatusController.text.isNotEmpty &&
        (nextFollowUpDate != null || nextFollowUpDateController.text.isNotEmpty);
  }

  Widget submitButtonWidget(state) {
    DateTime? dob =
        projectUtil.parseDisplayDate(nextFollowUpDateController.text ?? '');

    String formattedPetDob = '';

    if (dob != null) {
      formattedPetDob = projectUtil.submitDateFormat(dob); // e.g., '2025-05-30'
    }
    return AppButton(
      buttonName: widget.isEditMode? "Update Follow-up" : AppString.submitFollowUp,
      buttonColor:
          areMandatoryFieldsFilled() ? AppColors.textBlueColor : Colors.grey,
      backCallback: areMandatoryFieldsFilled()
          ? () {
              if (widget.isEditMode == false){
                followUpBloc.add(OnCreateFollowUpEvent(
                    taskId: widget.taskId ?? 0,
                    remark: remarkController.text,
                    status: followUpStatusController.text,
                    followupDate: formattedPetDob));
              } else {
                followUpBloc.add(OnUpdateFollowUpEvent(
                  followUpId: widget.getFollowUpListData?.id ?? 0,
                    taskId: widget.getFollowUpListData?.taskId?? 0,
                    remark: remarkController.text,
                    status: followUpStatusController.text,
                    followupDate: formattedPetDob));
              }

            }
          : null,
        isLoader: state is CreateFollowUpLoadingState  ||  state is UpdateFollowUpLoadingState? true: false
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
      appBar: CommonAppBar(
        title: widget.isEditMode? "Edit Follow Up with ${userProfileBloc.selectedUnit?.title}": 'Follow Up with ${userProfileBloc.selectedUnit?.title}',
      ),
      containChild: BlocListener<FollowUpBloc, FollowUpState>(
        bloc: followUpBloc,
        listener: (context, state) {
          if (state is CreateFollowUpErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
    if (state is UpdateFollowUpErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }

          if (state is CreateFollowUpDoneState) {
            Navigator.pop(context, true);
            WorkplaceWidgets.successToast(state.message);
          }  if (state is UpdateFollowUpDoneState) {
            Navigator.pop(context, true);
            WorkplaceWidgets.successToast(state.message);
          }
        },
        child: BlocBuilder<FollowUpBloc, FollowUpState>(
          bloc: followUpBloc,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // widget.isComeFromDetail == true?SizedBox():followUpCardView(),
                  //  SizedBox(height: widget.isComeFromDetail == true?0:10,),
                  widget.isComeFromDetail == true
                      ? SizedBox()
                      : followUpStatusWidget(),
                  SizedBox(
                    height: widget.isComeFromDetail == true ? 0 : 10,
                  ),
                  nextFollowUpDateWidget(),
                  const SizedBox(
                    height: 10,
                  ),
                  remarkWidget(),
                  const SizedBox(
                    height: 40,
                  ),
                  submitButtonWidget(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
