import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/core/core.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../app_global_components/common_floating_add_button.dart';
import '../../../core/util/app_permission.dart';
import '../../../imports.dart';
import '../../../widgets/common_search_bar.dart';
import '../../data/models/user_response_model.dart';
import '../../my_unit/widgets/common_image_view.dart';
import '../widgets/assign_bottomSheet.dart';
import '../widgets/common_filter_bottomSheet.dart';
import '../widgets/complete_common_popup.dart';
import '../widgets/filter_chip_widget.dart' hide CommonFilterBottomSheet;
import '../widgets/follow_up_card_view.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import '../../presentation/widgets/common_text_field_with_error.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import '../bloc/follow_up_bloc.dart';
import '../bloc/follow_up_event.dart';
import '../bloc/follow_up_state.dart';
import '../widgets/task_shimmer.dart';
import 'add_follow_up_screen.dart';
import 'add_new_task.dart';
import 'new_add_follow_up_screen.dart';
import 'new_follow_up_detail_screen.dart';
import 'new_two_follow_up_detail_screen.dart';

class FollowUpTasksScreen extends StatefulWidget {
  final List<Houses>? houses;
  final bool isComingFromMyTask;

  const FollowUpTasksScreen({super.key, this.houses, this.isComingFromMyTask = false});

  @override
  State<FollowUpTasksScreen> createState() => _FollowUpTasksScreenState();
}

class _FollowUpTasksScreenState extends State<FollowUpTasksScreen>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  ScrollController completeScrollController = ScrollController();

  bool isFirstLoad = true;
  final RefreshController _refreshControllerForActiveTask =
      RefreshController(initialRefresh: false);
  final RefreshController _refreshControllerForCompletedTask =
      RefreshController(initialRefresh: false);
  TextEditingController controller = TextEditingController();
  String selectedTaskType = "All Task";
  String selectedDate = "All Dates";
  int? selectedAssigneeId;
  String assignTo = "All Assign";
  String selectedAllStatus = "All Status";
  String selectedAllPriorities = "All Priorities";
  String? selectedAction; // keep this as state in your widget

  Map<String, TextEditingController> controllers = {
    'amenityType': TextEditingController(),
  };
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  Map<String, FocusNode> focusNodes = {
    'amenityType': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'amenityType': "",
  };

  Set<int> _loadingTaskIds = {}; // Track tasks in loading state
  File? selectProfilePhoto;
  String? selectProfilePhotoPath;
  String imageErrorMessage = '';

  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  OverlayEntry? overlayEntry;
  bool isImageSelected = false;

  void _onRefreshForActiveTask() async {
    isLoader = false;
    _applyFiltersForActiveTasks();
    await Future.delayed(const Duration(milliseconds: 100));
    _refreshControllerForActiveTask.refreshCompleted();
  }

  void _resetImageState() {
    setState(() {
      isLoader = true;
      selectProfilePhotoPath = null;
      isImageSelected = false;
      selectProfilePhoto = null;
    });
  }

  void _onRefreshForCompletedTask() async {
    isLoader = false;
    _applyFiltersForCompletedTasks();
    await Future.delayed(const Duration(milliseconds: 100));
    _refreshControllerForCompletedTask.refreshCompleted();
  }

  void _onLoadCompletedTask() async {
      if (followUpBloc.nextPageCompleteUrl.isNotEmpty) {
        // Next page call
        isLoader = false;
        followUpBloc.isCompletePaginateLoading = true;
        _applyFiltersForCompletedTasks(pageKey: followUpBloc.currentCompletePage + 1);
        await Future.delayed(const Duration(milliseconds: 100));
        _refreshControllerForCompletedTask.loadComplete();
      }
  }

  String getInitials(String name) {
    if (name.trim().isEmpty) return "Assign"; // when name is empty
    final parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts[0][0].toUpperCase(); // single word
    } else {
      return (parts.first[0] + parts.last[0]).toUpperCase(); // first + last initial
    }
  }


  addNewItemBottomSheet() {
    return showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CupertinoActionSheet(
              title: const Text(
                "Select Action",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() => selectedAction = "create");

                    // ✅ Close bottom sheet before navigating
                    Navigator.pop(context);

                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                          widget: AddTaskScreen(
                            isComingFrom: true,
                            moduleName: "",
                          ),
                        ),
                      ).then((value) {
                        if (value == true) {
                          setState(() {
                            isLoader = false;
                          });

                          if (tabInitialIndex == 0) {
                            _applyFiltersForActiveTasks();
                          } else {
                            _applyFiltersForCompletedTasks();
                          }
                        }
                      });
                    });
                  },
                  child: Text(
                    "Create a Task",
                    style: TextStyle(
                      color: selectedAction == "create"
                          ? AppColors.buttonBgColor3
                          : Colors.black,
                      fontWeight: selectedAction == "create"
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() => selectedAction = "add");

                    // ✅ Close bottom sheet before navigating
                    Navigator.pop(context);

                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                          widget: AddTaskScreen(
                            isComingFrom: true,
                            moduleName: "",
                            isShowTaskType: true,
                          ),
                        ),
                      ).then((value) {
                        if (value == true) {
                          setState(() {
                            isLoader = false;
                          });

                          if (tabInitialIndex == 0) {
                            _applyFiltersForActiveTasks();
                          } else {
                            _applyFiltersForCompletedTasks();
                          }
                        }
                      });
                    });
                  },
                  child: Text(
                    "Word Order Request",
                    style: TextStyle(
                      color: selectedAction == "add"
                          ? AppColors.buttonBgColor3
                          : Colors.black,
                      fontWeight: selectedAction == "add"
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _onLoadActiveTask() async {
      if (followUpBloc.nextPageUrl.isNotEmpty) {
        // Next page call
        isLoader = false;
        followUpBloc.isPaginateLoading = true;
        _applyFiltersForActiveTasks(pageKey: followUpBloc.currentPage + 1);
        await Future.delayed(const Duration(milliseconds: 100));
        _refreshControllerForActiveTask.loadComplete();
      }
  }


  String _toApiFormat(String? value) {
    if (value == null || value.isEmpty) return "";
    if (value.toLowerCase().startsWith("all")) return ""; // Handle "All Status" etc.

    // Special case for "Work order"
    if (value.toLowerCase().replaceAll(" ", "_") == "work_order") {
      return "work_order";
    }

    // Default: convert snake_case
    return value.toLowerCase().replaceAll(" ", "_");
  }


  void _applyFiltersForActiveTasks({int pageKey = 1}) {
    bool todayFlag = false;
    if (selectedDate.toLowerCase() == "today") {
      todayFlag = true;
    }
    followUpBloc.add(OnGetTaskListEvent(
      mContext: context,
      fromDate: "", // handle if needed
      toDate: "",   // handle if needed
      today: todayFlag,
      moduleName: _toApiFormat(selectedTaskType),
      status: "active",
      followupStatus: _toApiFormat(selectedAllStatus),
      assignee: selectedAssigneeId,
      priority: _toApiFormat(selectedAllPriorities),
      search: controller.text.trim(),
      myTask: widget.isComingFromMyTask,
      nextPageKey: pageKey

      // ✅ will always use latest value
    ));
  }

  void _applyFiltersForCompletedTasks({int pageKey = 1}) {
    bool todayFlag = false;
    if (selectedDate.toLowerCase() == "today") {
      todayFlag = true;
    }
    followUpBloc.add(OnGetCompleteTaskListEvent(
      mContext: context,
      today: todayFlag,
      status: 'completed', // Changed to 'completed' as requested
      moduleName: _toApiFormat(selectedTaskType),
      assignee: selectedAssigneeId,
      priority: _toApiFormat(selectedAllPriorities),
      search: controller.text.trim(),
      myTask: widget.isComingFromMyTask,
      pageKey: pageKey

      // ✅ will always use latest value


      // Note: followupStatus omitted for completed tasks, as they don't have follow-up statuses
    ));
  }

  Future<String?> photoPickerBottomSheet() async {
    return await showModalBottomSheet<String>(
      context: context,
      builder: (context1) => PhotoPickerBottomSheet(
        isRemoveOptionNeeded: false,
        removedImageCallBack: () {
          Navigator.pop(context1, null); // return null
        },
        selectedImageCallBack: (fileList) {
          if (fileList != null && fileList.isNotEmpty) {
            File imageFileTemp = File(fileList.first.path);

            Navigator.pop(context1, imageFileTemp.path);
            closeKeyboard(); // return path
          }
        },
        selectedCameraImageCallBack: (fileData) {
          if (fileData != null && fileData.path != null) {
            File imageFileTemp = File(fileData.path!);
            Navigator.pop(context1, imageFileTemp.path);
            closeKeyboard(); // return path
          }
        },
      ),
    );
  }

  String? selectedAmenity;
  bool showTodayOnly = false;
  bool isLoader = true;
  late FollowUpBloc followUpBloc;
  late TabController tabController;
  int tabInitialIndex = 0;

  @override
  void initState() {
    super.initState();
    isFirstLoad = true;
    followUpBloc = BlocProvider.of<FollowUpBloc>(context);
    followUpBloc.taskListData.clear();
    controllers['amenityType']?.text = 'All Statuses';
    _applyFiltersForActiveTasks();
    _applyFiltersForCompletedTasks();
    _resetImageState();


if(followUpBloc.datePresets.isEmpty){
  followUpBloc.add(OnGetTaskFiltersListEvent());
}

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabInitialIndex = tabController.index;
      });
    });


    scrollController.addListener(_scrollListener);
    completeScrollController.addListener(_completeScrollListener);


  }

  void _scrollListener() {
    if (scrollController.hasClients) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      final triggerScroll = maxScroll * 0.4; // 50% of scrollable area
      if (currentScroll >= triggerScroll) {
        _onLoadActiveTask();
      }
    }
  }

  void _completeScrollListener() {
    if (scrollController.hasClients) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      final triggerScroll = maxScroll * 0.4; // 50% of scrollable area
      if (currentScroll >= triggerScroll) {
        _onLoadCompletedTask();
      }
    }
  }


  Color getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFFD3D3D3); // Light Grey
      case "Didn't Pick":
        return const Color(0xFFFFE0B2); // Light Orange
      case 'Agreed':
        return const Color(0xFFC8E6C9); // Light Green
      case 'Follow Up':
        return const Color(0xFFBBDEFB); // Light Blue
      case 'Open':
        return const Color(0xFFFFCDD2); // Light Red
      case 'All Status':
        return const Color(0xFFE0F7FA); // Light Cyan
      case 'Cancelled':
        return const Color(0xFFF8BBD0); // Light Pink
      default:
        return const Color(0xFFE0E0E0); // Default Light Grey
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.black87;
      case "Didn't Pick":
        return Colors.orange;
      case 'Agreed':
        return Colors.green;
      case 'Follow Up':
        return Colors.blue;
      case 'Open':
        return Colors.red;
      case 'All Status':
        return Colors.teal;
      case 'Cancelled':
        return Colors.pink;
      default:
        return Colors.black87;
    }
  }


  @override
  Widget build(BuildContext context) {
    final canManageTaskAdd =
    AppPermission.instance.canPermission(AppString.manageTaskAdd, context: context);
    final canTaskAdd =
    AppPermission.instance.canPermission(AppString.taskAdd, context: context)  ;

    final canShowAdd =widget.isComingFromMyTask?canTaskAdd : canManageTaskAdd;






    Widget searchBar() {
      return CommonSearchBar(
        controller: controller,
        onChangeTextCallBack: (searchText) {

          if (tabInitialIndex == 0) {
            _applyFiltersForActiveTasks();
          } else {
            _applyFiltersForCompletedTasks();
          }
        },
        onClickCrossCallBack: () {
          controller.clear();
          FocusScope.of(context).unfocus();
          if (controller.text.isEmpty) {

            if (tabInitialIndex == 0) {
              _applyFiltersForActiveTasks();
            } else {
              _applyFiltersForCompletedTasks();
            }
          }
        },
        hintText: AppString.searchTask,
      );
    }

    activeTabView(state) {
      return SmartRefresher(
        controller: _refreshControllerForActiveTask,
        enablePullDown: true,
        enablePullUp: followUpBloc.nextPageUrl.isNotEmpty == true,
        footer: const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        onRefresh: _onRefreshForActiveTask,
        onLoading: _onLoadActiveTask,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  followUpBloc.taskListData.isEmpty &&
                          state is! GetTaskListLoadingState &&
                          state is! GetCompleteTaskListLoadingState
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 2.3,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  (state is GetTaskListLoadingState)
                                      ? ''
                                      : AppString.noTaskFound,
                                  style: appStyles.noDataTextStyle(),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 15),
                        itemCount: followUpBloc.taskListData.length,
                        itemBuilder: (context, index) {
                          final taskListData = followUpBloc.taskListData[index];
                          final name = taskListData.houseOwner?.name ?? '';
                          final flat = taskListData.houseNumber ?? '';
                          final title = taskListData.title ?? '';
                          final unit = "$name, $flat";
                          final created = taskListData.createdAt ?? '';
                          final dueDate = taskListData.dueDate ?? '';
                          final status = taskListData.status ?? '';
                          final priority = taskListData.priority ?? '';
                          final note = taskListData.description ?? '';
                          final assign = taskListData.assignee?.name ?? '';
                          final phoneNumber = taskListData
                                  .houseOwner?.additionalInfo?.phone ??
                              '';
                          final taskId = taskListData.id ?? 0;

                          return FollowUpCardView(
                            assignButtonName: getInitials(assign),

                            unit: unit,
                            name: name,
                            title: title,
                            createdDate: created,
                            dueDate: dueDate,
                            isComingFromMyTask: widget.isComingFromMyTask,
                            status: status,
                            priority: priority.capitalize(),
                            statusTag: status,
                            // assign:assign ,
                            phoneNumber: phoneNumber,
                            note: note,
                            tagColor: getStatusColor(status),
                            tagTextColor: getStatusTextColor(status),
                            // isLoading: _loadingTaskIds
                            //     .contains(taskId),
                            // isLoadingForComplete: ,// Pass loading state
                            onMarkComplete: () {
                              TextEditingController commentsTextController = TextEditingController();
                              WorkplaceWidgets.showDialogForCompleted(
                                context: context,
                                title: AppString.markTaskComplete,
                                content:
                                "Are you sure you want to reject this expense? This action cannot be undone.",
                                buttonName1: AppString.completeTaskButton,
                                buttonName2: AppString.cancelButton,
                                disableButtonColor: AppColors.textDarkGreenColor.safeOpacity(0.5),
                                unableButtonColor: AppColors.textDarkGreenColor,
                                textController: commentsTextController,
                                hintText: AppString.enterReasonHint,
                                maxLine: 2,
                                selectedPhotoPath: selectProfilePhotoPath, // 👈 pass current photo
                                onPressedButton1: () {
                                  if (commentsTextController.text.trim().isNotEmpty) {
                                    followUpBloc.add(
                                      OnMarkTaskAsCompleteEvent(
                                        mContext: context,
                                        taskId: taskId,
                                        remark: commentsTextController.text.toString(),
                                        completedImages: selectProfilePhotoPath,
                                      ),
                                    );
                                    _resetImageState();
                                    Navigator.pop(context);
                                  }
                                },
                                onPressedButton2: () {
                                  Navigator.of(context).pop();
                                },
                                onSelectPhoto: () async {
                                  closeKeyboard();
                                  final path = await photoPickerBottomSheet(); // Returns image path
                                  if (path != null) {
                                    setState(() {
                                      selectProfilePhotoPath = path; // Update parent state
                                      isImageSelected = true;
                                    });
                                  }
                                  return selectProfilePhotoPath;
                                },
                                onRemovePhoto: () {
                                  setState(() {
                                    selectProfilePhotoPath = null; // 👈 clear photo in parent
                                    isImageSelected = false;
                                  });
                                },
                                label: 'Remark',
                              );
                            },

                            onAddFollowUp: () {
                              Navigator.push(
                                context,
                                SlideLeftRoute(
                                  widget: AddFollowUpScreen(
                                    houses: widget.houses ?? [],
                                    taskId: taskId,
                                  ),
                                ),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    isLoader = false;
                                  });
                                  _applyFiltersForActiveTasks();
                                }
                              });
                            },
                            onTab: () {
                              Navigator.push(
                                context,
                                SlideLeftRoute(
                                  widget: NewFollowUpDetailScreen(
                                                          isComingFromMyTask: widget.isComingFromMyTask,

                                      taskListData:
                                          followUpBloc.taskListData[index]

                                      ),
                                ),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    isLoader = false;
                                  });
                                    _applyFiltersForActiveTasks();
                                    _applyFiltersForCompletedTasks();

                                }
                              });
                            },
                            onAssign: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                ),
                                builder: (ctx) => SizedBox(
                                  height:
                                      MediaQuery.of(ctx).size.height * 0.6,
                                  child: AssignBottomSheet(
                                    title: "Assign To",
                                    people: [
                                      {
                                        "name": "All Assign",
                                        "role": "", // optional, can be empty
                                      },
                                      ...followUpBloc.assignees.map((e) {
                                        if (e.id == 0) {
                                          return {
                                            "name": e.name ?? "Unassigned",
                                            // "role": e.role ?? "", // if role exists
                                          };
                                        } else {
                                          return {
                                            "name": "${e.firstName ?? ''} ${e.lastName ?? ''}".trim(),
                                            // "role": e.role ?? "", // if role exists
                                          };
                                        }
                                      }).toList(),
                                    ],
                                    selectedName: "All Assign",
                                    onAssign: (val) {
                                      print("Selected Option: $val");

                                      if (val == "All Assign") {
                                        selectedAssigneeId = null;
                                      } else {
                                        final selected = followUpBloc
                                            .assignees
                                            .firstWhere((e) {
                                          if (e.id == 0) {
                                            return e.name == val;
                                          } else {
                                            return "${e.firstName ?? ''} ${e.lastName ?? ''}"
                                                .trim() ==
                                                val;
                                          }
                                        });
                                        selectedAssigneeId = selected.id;
                                      }

                                      print(
                                          "Selected Assignee Id: $selectedAssigneeId");

                                      setState(() {
                                        assignTo = val;
                                      });

                                      followUpBloc.add(OnAssignTaskEvent(
                                        assignToId: selectedAssigneeId,
                                        taskId: taskId, mContext: context,

                                      ));

                                      /// event ke baad reset
                                      //
                                      //

                                      setState(() {
                                        selectedAssigneeId = null;
                                        assignTo = "All Assign";
                                      });

                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    completeTabView(state) {
      return followUpBloc.completeTaskListData.isEmpty &&
              state is! GetTaskListLoadingState &&
              state is! GetCompleteTaskListLoadingState
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 2.3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (state is GetCompleteTaskListLoadingState)
                          ? ''
                          : AppString.noTaskFound,
                      style: appStyles.noDataTextStyle(),
                    ),
                  ],
                ),
              ),
            )
          : SmartRefresher(
              controller: _refreshControllerForCompletedTask,
              enablePullDown: true,
              enablePullUp: followUpBloc.nextPageCompleteUrl.isNotEmpty == true,
              footer: const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
              onRefresh: _onRefreshForCompletedTask,
              onLoading: _onLoadCompletedTask,
              child: ListView(
                controller: completeScrollController,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  ListView.builder(
                    key: PageStorageKey('completedTaskList'),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 4, bottom: 15),
                    itemCount: followUpBloc.completeTaskListData.length,
                    itemBuilder: (context, index) {
                      final taskListData = followUpBloc.completeTaskListData[index];
                      final name = taskListData.houseOwner?.name ?? '';
                      final flat = taskListData.houseNumber ?? '';
                      final title = taskListData.title ?? '';
                      final unit = "$name, $flat";
                      final created = taskListData.createdAt ?? '';
                      final dueDate = taskListData.dueDate ?? '';
                      final status = taskListData.status ?? '';
                      final priority = taskListData.priority ?? '';
                      final note = taskListData.description ?? '';
                      final assign = taskListData.assignee?.name ?? '';
                      final phoneNumber = taskListData
                          .houseOwner?.additionalInfo?.phone ??
                          '';
                      final taskId = taskListData.id ?? 0;









                      return FollowUpCardView(
                        unit: unit,
                        priority: priority.capitalize(),
                        name: name,
                        assign: assign,
                        createdDate: created,
                        dueDate: dueDate,
                        status: status,
                        statusTag: status,
                        note: note,
                        title: title,
                        phoneNumber: phoneNumber,
                        tagColor: getStatusColor(status),
                        tagTextColor: getStatusTextColor(status),
                        isLoading:
                            _loadingTaskIds.contains(taskId), // Pass loading state
                        onMarkComplete: () {
                          WorkplaceWidgets.successToast(
                            'Follow up completed successfully',
                            durationInSeconds: 1,
                          );
                        },
                        onAddFollowUp: () {
                          Navigator.push(
                            context,
                            SlideLeftRoute(
                              widget: AddFollowUpScreen(
                                houses: widget.houses ?? [],
                                taskId: taskId,
                              ),
                            ),
                          );
                        },
                        onAssign: () {},
                        onTab: () {
                          Navigator.push(
                            context,
                            SlideLeftRoute(
                              widget: NewFollowUpDetailScreen(
                                isComingFromMyTask: widget.isComingFromMyTask,
                                  taskListData:
                                  followUpBloc.completeTaskListData[index]

                              ),
                            ),
                          ).then((value) {
                            if (value == true) {
                              setState(() {
                                isLoader = false;
                              });
                              if (tabInitialIndex == 0) {
                                _applyFiltersForActiveTasks();
                              } else {
                                _applyFiltersForCompletedTasks();
                              }
                            }
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            );
    }

    return BlocBuilder<FollowUpBloc, FollowUpState>(
      bloc: followUpBloc,
  builder: (context, state) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: false,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar:  CommonAppBar(
        title: widget.isComingFromMyTask ? "My Tasks":'Tasks',
        isHideBorderLine: true,
      ),
      containChild: BlocListener<FollowUpBloc, FollowUpState>(
        listener: (context, state) {
          if (state is GetTaskListErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          // if (state is MarkTaskAsCompleteErrorState) {
          //   setState(() {
          //     _loadingTaskIds.remove(
          //         state.taskId); // Remove task from loading state on error
          //   });
          //   WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          // }
          if (state is GetCompleteTaskListErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is GetTaskListDoneState) {
            WorkplaceWidgets.successToast(state.message);
          }

          if (state is AssignTaskErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is AssignTaskDoneState) {
            followUpBloc.taskListData.clear();

            _applyFiltersForActiveTasks();

              _applyFiltersForCompletedTasks();

            WorkplaceWidgets.successToast(state.message);
          }


          if (state is MarkTaskAsCompleteDoneState) {
            // Navigator.pop(context, true);
            WorkplaceWidgets.successToast(state.message,
                durationInSeconds: 1);

          }
          // BlocBuilder ke andar
          if (state is GetTaskListDoneState || state is GetCompleteTaskListDoneState) {
            if (isFirstLoad) {
              setState(() {
                isFirstLoad = false; // Sirf ek baar
              });
            }
          }
          if (state is MarkTaskAsCompleteErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          // if (state is MarkTaskAsCompleteDoneState) {
          //   setState(() {
          //     _loadingTaskIds.remove(
          //         state.taskId); // Remove task from loading state on success
          //   });
          //   WorkplaceWidgets.successToast(state.message);
          // }
          // if (state is MarkTaskAsCompleteLoadingState) {
          //   setState(() {
          //     _loadingTaskIds
          //         .add(state.taskId ?? 0); // Add task to loading state
          //   });
          // }
        },
        child: BlocBuilder<FollowUpBloc, FollowUpState>(
          bloc: followUpBloc,
          builder: (context, state) {



            if (state is MarkTaskAsCompleteDoneState) {
              isLoader = false;

                _applyFiltersForActiveTasks();

                _applyFiltersForCompletedTasks();




              // followUpBloc.add(OnGetTaskListEvent(
              //     mContext: context, today: showTodayOnly, status: 'open'));
              // followUpBloc.add(OnGetCompleteTaskListEvent(
              //     mContext: context, today: showTodayOnly, status: 'closed'));
            }

            return Stack(
              children: [
                Column(
                  children: [
                    searchBar(),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            /// Task Type Filter
                            FilterChipWidget(
                              label: selectedTaskType,
                              icon: Icons.assignment,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                  ),
                                  builder: (ctx) => SizedBox(
                                    height:
                                        MediaQuery.of(ctx).size.height * 0.6,
                                    child: CommonFilterBottomSheet(
                                      title: "Choose Task Type",
                                      options: [
                                        "All Task",
                                        ...followUpBloc.taskTypes
                                            .map((e) =>
                                                projectUtil.formatForDisplay(e))
                                            .toList(),
                                      ],
                                      selectedOption: selectedTaskType,
                                      icon: Icons.assignment,
                                      onApply: (val) {
                                        setState(() {
                                          selectedTaskType = val;
                                        });
                                        if (tabInitialIndex == 0) {
                                          _applyFiltersForActiveTasks();
                                        } else {
                                          _applyFiltersForCompletedTasks();
                                        }
                                        print("Selected Task Type: $val");
                                        // setState(() => selectedTaskType = val);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            FilterChipWidget(
                              label: assignTo,
                              icon: Icons.person_2_outlined,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                  ),
                                  builder: (ctx) => SizedBox(
                                    height:
                                        MediaQuery.of(ctx).size.height * 0.6,
                                    child: CommonFilterBottomSheet(
                                      title: "Assign To",
                                      options: [
                                        "All Assign",
                                        ...followUpBloc.assignees.map((e) {
                                          if (e.id == 0) {
                                            return e.name ??
                                                "Unassigned"; // special case
                                          } else {
                                            return "${e.firstName ?? ''} ${e.lastName ?? ''}"
                                                .trim();
                                          }
                                        }).toList(),
                                      ],
                                      selectedOption: assignTo,
                                      icon: Icons.assignment,
                                      onApply: (val) {
                                        print("Selected Option: $val");

                                        if (val == "All Assign") {
                                          selectedAssigneeId = null;
                                        } else {
                                          final selected = followUpBloc
                                              .assignees
                                              .firstWhere((e) {
                                            if (e.id == 0) {
                                              return e.name == val;
                                            } else {
                                              return "${e.firstName ?? ''} ${e.lastName ?? ''}"
                                                      .trim() ==
                                                  val;
                                            }
                                          });
                                          selectedAssigneeId = selected.id;
                                        }

                                        print(
                                            "Selected Assignee Id: $selectedAssigneeId");

                                        setState(() {
                                          assignTo = val;
                                        });
                                        if (tabInitialIndex == 0) {
                                          _applyFiltersForActiveTasks();
                                        } else {
                                          _applyFiltersForCompletedTasks();
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),

                            /// Date Filter
                            FilterChipWidget(
                              label: selectedDate,
                              icon: Icons.calendar_month,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                  ),
                                  builder: (ctx) => SizedBox(
                                    height:
                                        MediaQuery.of(ctx).size.height * 0.6,
                                    child: CommonFilterBottomSheet(
                                      title: "Choose Date",
                                      options: [
                                        ...followUpBloc.datePresets
                                            .map((e) =>
                                                projectUtil.formatForDisplay(e))
                                            .toList(),
                                      ],
                                      icon: Icons.calendar_today,
                                      selectedOption: selectedDate,
                                      onApply: (val) {
                                        setState(() {
                                          selectedDate = val;
                                        });
                                        if (tabInitialIndex == 0) {
                                          _applyFiltersForActiveTasks();
                                        } else {
                                          _applyFiltersForCompletedTasks();
                                        }
                                        print("Selected Date: $val");
                                        // setState(() => selectedDate = val);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            FilterChipWidget(
                              label: selectedAllPriorities,
                              icon: Icons.priority_high,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                  ),
                                  builder: (ctx) => SizedBox(
                                    height:
                                    MediaQuery.of(ctx).size.height * 0.6,
                                    child: CommonFilterBottomSheet(
                                      title: "Choose Priorities",
                                      options: [
                                        "All Priorities", // 👈 Add this at the top
                                        ...followUpBloc.priorities
                                            .map((e) =>
                                            projectUtil.formatForDisplay(e))
                                            .toList(),
                                      ],
                                      icon: Icons.priority_high,
                                      selectedOption: selectedAllPriorities,
                                      onApply: (val) {
                                        setState(() {
                                          selectedAllPriorities = val;
                                        });
                                        print("Selected Status: $val");
                                        if (tabInitialIndex == 0) {
                                          _applyFiltersForActiveTasks();
                                        } else {
                                          _applyFiltersForCompletedTasks();
                                        }
                                        // setState(() => selectedStatus = val);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            /// Status Filter
                            FilterChipWidget(
                              label: selectedAllStatus,
                              icon: Icons.flag,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                  ),
                                  builder: (ctx) => SizedBox(
                                    height:
                                        MediaQuery.of(ctx).size.height * 0.6,
                                    child: CommonFilterBottomSheet(
                                      title: "Choose Status",
                                      options: [
                                        "All Status", // 👈 Add this at the top
                                        ...followUpBloc.statuses
                                            .map((e) =>
                                                projectUtil.formatForDisplay(e))
                                            .toList(),
                                      ],
                                      icon: Icons.flag,
                                      selectedOption: selectedAllStatus,
                                      onApply: (val) {
                                        setState(() {
                                          selectedAllStatus = val;
                                        });
                                        print("Selected Status: $val");
                                        if (tabInitialIndex == 0) {
                                          _applyFiltersForActiveTasks();
                                        } else {
                                          _applyFiltersForCompletedTasks();
                                        }
                                        // setState(() => selectedStatus = val);
                                      },
                                    ),
                                  ),
                                );
                              },
                            )


                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 2),
                      color: Colors.transparent,
                      child: TabBar(
                        onTap: (int index) {
                          setState(() {
                            tabInitialIndex = index;
                          });
                        },
                        labelColor: AppColors.appBlueColor,
                        labelPadding: const EdgeInsets.only(bottom: 10),
                        indicatorColor: AppColors.appBlueColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 4,
                        unselectedLabelColor: AppColors.greyUnselected,
                        controller: tabController,
                        tabs: [
                          Text('Open', style: appStyles.tabTextStyle()),
                          Text('Closed', style: appStyles.tabTextStyle()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          activeTabView(state),
                          completeTabView(state),
                        ],
                      ),
                    ),
                  ],
                ),
                // Full page shimmer only on first load
                if (isFirstLoad && (state is GetTaskListLoadingState || state is GetCompleteTaskListLoadingState))
                  TaskFullPageShimmer()
                else if (!isFirstLoad &&
                    (state is GetTaskListLoadingState ||
                        state is GetCompleteTaskListLoadingState ||
                        state is MarkTaskAsCompleteLoadingState ||
                        state is AssignTaskLoadingState))
                  WorkplaceWidgets.progressLoader(context)
              ],
            );
          },
        ),
      ),
      bottomMenuView:
      canShowAdd && followUpBloc.taskListData.isNotEmpty?
    CommonFloatingAddButton(
        onPressed: () {
          addNewItemBottomSheet();
        },
      ): SizedBox()
    );
  },
);
  }
}
