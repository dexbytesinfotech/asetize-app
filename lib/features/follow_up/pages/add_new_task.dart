import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../imports.dart';
import '../../booking/widgets/label_widget.dart';
import '../../commitee_member_tab/bloc/commitee_member_bloc.dart';
import '../../commitee_member_tab/bloc/commitee_member_event.dart';
import '../../commitee_member_tab/models/commitee_member_model.dart';
import '../bloc/follow_up_bloc.dart';
import '../bloc/follow_up_event.dart';
import '../bloc/follow_up_state.dart';
import '../models/get_task_detail_model.dart';
import 'new_follow_up_list_screen.dart';

class AddTaskScreen extends StatefulWidget {
  final bool isComingFrom;
  final String? moduleName;
  final String description;
  final int? houseId;
  final int? complaintId;
  final bool isEditMode;
  final bool isShowTaskType;
  final GetTaskDetailData?  getTaskDetailData;

  const AddTaskScreen({super.key, this.isComingFrom = false, this.moduleName, this.houseId, this.getTaskDetailData, this.isEditMode=false, this.complaintId, this.description = "", this.isShowTaskType = false});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? dueDate;
  String? selectedModule;
  String? selectedPriority;
  String? selectedAssignee;
  int? selectedAssigneeId;
  late FollowUpBloc followUpBloc;
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  List<File> selectedTaskImages = [];
  late List<String> taskImagePaths = selectedTaskImages.map((file) => file.path).toList();


  late CommitteeMemberBloc committeeMemberBloc;
  final List<String> moduleOptions = ['Module A', 'Module B', 'Module C'];
  final List<String> priorityOptions = ['High', 'Medium', 'Low'];
  final List<String> assigneeOptions = ['John Doe', 'Jane Smith', 'Alex Brown'];


  void setData() {
    if(widget.isEditMode == false){

      return ;
    }
    controllers['title']?.text = (widget.getTaskDetailData?.title ?? '').capitalize();
    controllers['description']?.text = widget.getTaskDetailData?.description ?? '';
    controllers['dueDate']?.text = widget.getTaskDetailData?.dueDateDisplay ?? '';
    controllers['priority']?.text =  (widget.getTaskDetailData?.priority ?? '').capitalize();
    controllers['assignee']?.text =  (widget.getTaskDetailData?.assignee?.name ?? '').capitalize();
    selectedAssigneeId = widget.getTaskDetailData?.assignee?.id?? 0;
  }


  // Define controllers using a Map
  final Map<String, TextEditingController> controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
    'module': TextEditingController(),
    'dueDate': TextEditingController(),
    'priority': TextEditingController(),
    'assignee': TextEditingController(),
  };

  // Define focus nodes using a Map
  final Map<String, FocusNode> focusNodes = {
    'title': FocusNode(),
    'description': FocusNode(),
    'module': FocusNode(),
    'dueDate': FocusNode(),
    'priority': FocusNode(),
    'assignee': FocusNode(),
  };

  @override
  void dispose() {
    // Dispose all controllers
    controllers.forEach((key, controller) => controller.dispose());
    // Dispose all focus nodes
    focusNodes.forEach((key, focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  void initState() {
    committeeMemberBloc = BlocProvider.of<CommitteeMemberBloc>(context);
    followUpBloc = BlocProvider.of<FollowUpBloc>(context);

    if (widget.moduleName != null && widget.moduleName!.isNotEmpty) {
      followUpBloc.add(
        OnGenerateTitleDescriptionEvent(
          complaintIdOrHouseId: widget.complaintId ?? widget.houseId ?? 0,
          taskType: widget.moduleName!.toLowerCase(),
        ),
      );
    }




    setData();

    if (committeeMemberBloc.committeeMemberList.isEmpty) {
      committeeMemberBloc.add(FetchCommitteeMembers(mContext: context));
    }
    if (widget.moduleName != null) {
      controllers['module']?.text = (widget.moduleName ?? "").capitalize();
    }

    if (!widget.isEditMode && (controllers['priority']?.text.isEmpty ?? true)) {
      controllers['priority']?.text = "Medium";
      selectedPriority = "Medium";
    }
    super.initState();
  }
  bool areMandatoryFieldsFilled({required bool isEditMode}) {
    final title = controllers['title']?.text.isNotEmpty ?? false;
    final dueDate = controllers['dueDate']?.text.isNotEmpty ?? false;
    final priority = controllers['priority']?.text.isNotEmpty ?? false;
    final assignee = controllers['assignee']?.text.isNotEmpty ?? false;

    if (isEditMode) {
      // Assignee not mandatory in edit mode
      return title  && priority;
    } else {
      // Assignee mandatory in add mode
      return title  && priority ;
    }
  }
  void selectDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 12, DateTime.now().day),
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
        dueDate = newDate;
        controllers['dueDate']!.text = projectUtil.uiShowDateFormat(newDate);

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

  Widget titleWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['title'],
      controllerT: controllers['title'],
      borderRadius: 8,
      inputHeight: 50,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 100,
      errorMsgHeight: 20,
      showError: true,
      autoFocus: false,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: 'Enter task title',
      placeHolderTextWidget: const LabelWidget(labelText: 'Task Title', isRequired: true),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTextChange: (value) {
        // controllers['title']!.text = value;
setState(() {
  areMandatoryFieldsFilled(isEditMode: widget.isEditMode);

});
      },
      onEndEditing: (value) {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  Widget taskTypeWidget({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }



  Widget descriptionWidget() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextFieldWithError(
              focusNode: focusNodes['description'],
              controllerT: controllers['description'],
              borderRadius: 8,
              inputHeight: 140,
              hintStyle: appStyles.hintTextStyle(),
              textStyle: appStyles.textFieldTextStyle(),
              maxCharLength: 500,
              minLines: 3,
              maxLines: 3,
              autoFocus: false,
              showCounterText: false, // hide default
              capitalization: CapitalizationText.sentences,
              cursorColor: Colors.grey,
              enabledBorderColor: Colors.white,
              focusedBorderColor: Colors.white,
              backgroundColor: AppColors.white,
              textInputAction: TextInputAction.newline,
              borderStyle: BorderStyle.solid,
              inputKeyboardType: InputKeyboardTypeWithError.multiLine,
              hintText: 'Enter task description',
              placeHolderTextWidget: const LabelWidget(
                labelText: 'Description',
                isRequired: false,
              ),
              contentPadding: const EdgeInsets.all(10),
              onTextChange: (value) {
                setState(() {}); // update counter
              },
              onEndEditing: (value) {},
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, right: 8),
                child: Text(
                  "${controllers['description']?.text.length ?? 0}/500",
                  style: appStyles.hintTextStyle().copyWith(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Widget moduleWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['module'],
      controllerT: controllers['module'],
      borderRadius: 8,
      inputHeight: 50,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 50,
      errorMsgHeight: 20,
      showError: true,
      readOnly:  true,
      autoFocus: false,
      inputFieldSuffixIcon: widget.isComingFrom?SizedBox():WorkplaceWidgets.downArrowIcon() ,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.done,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: 'Select module',
      placeHolderTextWidget: const LabelWidget(labelText: 'Module Name', isRequired: true),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () {
        FocusScope.of(context).unfocus();
        if (widget.isComingFrom == false) {
          showBottomSheet(context, 'Select Module', moduleOptions, 'module', (value) => selectedModule = value);
        }
      },
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget dueDateWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['dueDate'],
      controllerT: controllers['dueDate'],
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
      hintText: 'Select due date',
      placeHolderTextWidget: const LabelWidget(labelText: 'Due Date', isRequired: false),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () => selectDate(context),
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }



  Widget taskImage(state) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isShowTaskType? AppString.workOrderImage: AppString.taskImage,
            style: appStyles.texFieldPlaceHolderStyle(),
          ),
          const SizedBox(height: 10),

          /// --- Show selected images in GRID view (3 per row) ---
          if (selectedTaskImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 15,top: 0,left: 1.5,right: 3),
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedTaskImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 images per row
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1, // square shape
                ),
                itemBuilder: (context, index) {
                  final imageFile = selectedTaskImages[index];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            FadeRoute(
                              widget: FullPhotoView(
                                title: widget.isShowTaskType? "Work Order Image${index + 1}":  "Task Image${index + 1}",
                                localProfileImgUrl: imageFile.path,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTaskImages.removeAt(index);
                            });
                          },
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
                  );
                },
              ),
            ),

          /// --- Upload container ---
          GestureDetector(
            onTap: () async {
              closeKeyboard();
              final pickedFiles = await ImagePicker().pickMultiImage(
                imageQuality: 80,
              );

              if (pickedFiles.isNotEmpty) {
                setState(() {
                  selectedTaskImages.addAll(
                    pickedFiles.map((e) => File(e.path)),
                  );
                });
              }
            },
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(
                  color: AppColors.textBlueColor,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cloud_upload_outlined,
                      color: AppColors.appBlueColor, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "Click to upload images",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Supports JPG, PNG, GIF up to 5MB each",
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


  Widget priorityWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['priority'],
      controllerT: controllers['priority'],
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
      hintText: 'Select priority',
      placeHolderTextWidget: const LabelWidget(labelText: 'Priority', isRequired: true),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () {
        FocusScope.of(context).unfocus();
        showBottomSheet(context, 'Select Priority', followUpBloc.priorities
            .map((e) =>
            projectUtil.formatForDisplay(e))
            .toList(), 'priority', (value) => selectedPriority = value);
      },
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget assigneeWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['assignee'],
      controllerT: controllers['assignee'],
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
      hintText: 'Select assignee',
      placeHolderTextWidget: const LabelWidget(labelText: 'Assigned To', isRequired: false),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        onTapCallBack: () {
          FocusScope.of(context).unfocus();

          // Build list of assignees (exclude All Assign and Unassigned)
          List<Map<String, dynamic>> assigneeList = followUpBloc.assignees
              .where((e) => e.id != 0) // 🚫 remove Unassigned
              .map((e) {
            return {
              "id": e.id,
              "name": "${e.firstName ?? ''} ${e.lastName ?? ''}".trim(),
            };
          }).toList();

          // Extract just names for bottom sheet
          List<String> names = assigneeList.map((e) => e["name"] as String).toList();

          showBottomSheet(
            context,
            'Select Assignee',
            names.isNotEmpty ? names : ['No assignees available'],
            'assignee',
                (selectedName) {
              final selected = assigneeList.firstWhere(
                    (member) => member["name"] == selectedName,
              );

              controllers['assignee']?.text = selected["name"];
              selectedAssigneeId = selected["id"];

              print('Selected Assignee ID: $selectedAssigneeId');
            },
          );
        },

        onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }


  Widget submitButtonWidget(state) {
    return AppButton(
      buttonName: widget.isShowTaskType? "Submit Work Order" :widget.isEditMode?"Update Task ": 'Submit Task',
      isLoader: state is CreateTaskLoadingState  || state is UpdateTaskLoadingState? true:false,
      buttonColor: areMandatoryFieldsFilled(isEditMode: widget.isEditMode) ? AppColors.textBlueColor : Colors.grey,
      backCallback: areMandatoryFieldsFilled(isEditMode: widget.isEditMode)
          ? () {
        DateTime? dueDate = projectUtil.parseDisplayDate(controllers['dueDate']!.text?? '');
        String formattedDueDate = '';
        if (dueDate != null) {
          formattedDueDate = projectUtil.submitDateFormat(dueDate); // e.g., '2025-05-30'
        }


        if (widget.isEditMode == false){
          followUpBloc.add(
            OnCreateTaskEvent(
              isComing: widget.isComingFrom,
              title: controllers['title']!.text,
              description: controllers['description']!.text,
                moduleName: (widget.moduleName != null && widget.moduleName!.isNotEmpty)
                    ? widget.moduleName!.toLowerCase()
                    : widget.isShowTaskType ? "work_order":"miscellaneous",
                dueDate: formattedDueDate,
              priority: controllers['priority']!.text.toLowerCase(),
              assignedTo: selectedAssigneeId,
                houseId: widget.complaintId != null ? null : widget.houseId,
              moduleId: widget.complaintId?? widget.houseId,
              taskImages: taskImagePaths
            ),
          );
        } else {
          followUpBloc.add(
            OnUpdateTaskEvent(
              isComing: widget.isComingFrom,
              title: controllers['title']!.text,
              description: controllers['description']!.text,
              moduleName: "miscellaneous",
              dueDate: formattedDueDate,
              priority: controllers['priority']!.text.toLowerCase(),
              assignedTo: selectedAssigneeId,
              taskId: widget.getTaskDetailData?.id,
              // houseId:  widget.houseId,
              // moduleId: widget.houseId
            ),
          );
        }



        // Add task submission logic here
      }
          : null,
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
      appBar:  CommonAppBar(
        title:  widget.isShowTaskType? "Work Order Request": widget.isEditMode ? "Edit Task":'Add New Task'

      ),
      containChild: BlocListener<FollowUpBloc, FollowUpState>(
        bloc: followUpBloc,
        listener: (context, state) {
          if (state is CreateTaskErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is UpdateTaskErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }

          if (state is GenerateTitleDescriptionErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }


          if (state is UpdateTaskDoneState) {
            Navigator.pop(context, true);
            WorkplaceWidgets.successToast(state.message);

          }

          if (state is CreateTaskDoneState) {
            if(state.isComing == false) {
              Navigator.pop(context, true);
            }

            if (state.isComing == true) {
              Navigator.pushReplacement(
                  context,
                  SlideLeftRoute(
                      widget: FollowUpTasksScreen()
                  ));
            }
            WorkplaceWidgets.successToast(state.message);
          }  },
        child: BlocBuilder<FollowUpBloc, FollowUpState>(
          bloc: followUpBloc,
          builder: (context, state) {
            if (state is GenerateTitleDescriptionDoneState) {
                controllers['title']?.text = followUpBloc.generateTitleDescriptionData?.title ?? '';
                controllers['description']?.text = followUpBloc.generateTitleDescriptionData?.description ?? '';
              // WorkplaceWidgets.successToast(state.message);

            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Stack(
                children: [
                  Column(
                    children: [
                      // moduleWidget(),
                      if (widget.isShowTaskType)

                        taskTypeWidget(
                          label: "Type",
                          value: "Work Order",
                          icon: Icons.assignment,
                        ),
                      SizedBox(height: 10),
                      titleWidget(),
                      const SizedBox(height: 10),
                      descriptionWidget(),
                      const SizedBox(height: 15),

                      priorityWidget(),
                      const SizedBox(height: 10),
                      if(widget.isEditMode==false)
                        assigneeWidget(),
                      const SizedBox(height: 10),
                      dueDateWidget(),
                       SizedBox(height: widget.isEditMode ?0:10),
                      if(widget.isEditMode==false)

                        taskImage(state),
                      const SizedBox(height: 40),
                      submitButtonWidget(state),
                    ],
                  ),
                  if (state is GenerateTitleDescriptionLoadingState )
                    WorkplaceWidgets.progressLoader(context),
                ],
              ),
            );
          },
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


