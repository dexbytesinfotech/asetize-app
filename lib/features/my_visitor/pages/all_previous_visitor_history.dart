import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:asetize/features/my_visitor/pages/today_my_visitor_detail_screen.dart';
import 'package:asetize/widgets/common_search_bar.dart';

import '../../../core/enum/app_enums.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../bloc/my_visitor_bloc.dart';
import '../bloc/my_visitor_event.dart';
import '../bloc/my_visitor_state.dart';
import '../widgets/visitor_card_widget.dart';
import 'package:asetize/features/data/models/user_response_model.dart' as userResponse;


class VisitorHistoryDetailScreen extends StatefulWidget {
  const VisitorHistoryDetailScreen({super.key});

  @override
  State<VisitorHistoryDetailScreen> createState() =>
      _VisitorHistoryDetailScreenState();
}

class _VisitorHistoryDetailScreenState
    extends State<VisitorHistoryDetailScreen> {
  final TextEditingController controller = TextEditingController();
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  // late ProfileBloc profileBloc;
  late HomeBloc homeBloc;
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
  bool isShowLoader = true;
  List<userResponse.Houses> houses = [];
  String status =
      "${VisitorStatus.checkedIn.value}, ${VisitorStatus.checkedOut.value}";
  DateTime? startDate;
  late UserProfileBloc userProfileBloc;
  DateTime? endDate;
  bool showStartDateError = false;
  bool showEndDateError = false;
  String endDateErrorMessage = "";
  bool isFilterApplied = false;

  void apiCall() {
    onUnitSelect(userProfileBloc.selectedUnit);
  }

  void filterApiCall(String? startTime,String? endTime)
  {
    setState(() {
      isShowLoader = false;
    });
    try {
      homeBloc.add(OnGetVisitorHistoryListEvent(
        mContext: context,
        endTime: endTime ?? projectUtil.formatEndDateTime(startDate!),
        startTime: startTime,
          houseId: userProfileBloc.selectedUnit!.id
      ));
    } catch (e) {
      print(e);
    }
  }
  void onUnitSelect(userResponse.Houses? house) {
    if(house!=null){
      userProfileBloc.add(OnChangeCurrentUnitEvent(selectedUnit: house));
      homeBloc.add(OnGetVisitorHistoryListEvent(
          houseId:  house.id,
          mContext: context,
          // status: VisitorStatus.checkedIn.value,
        endTime: projectUtil.getYesterdayEndTime(),

      ));
      // addVehicleManagerBloc.add(OnGetMyFamilyList(mContext: context, houseId:  house.id.toString()?? '' ));


    }

  }

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    if (userProfileBloc.user.houses != null &&
        userProfileBloc.user.houses!.isNotEmpty) {
      houses = userProfileBloc.user.houses ?? [];
    }
    if (homeBloc.visitorHistoryData.isEmpty) {
      apiCall();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    refreshController.dispose();
    super.dispose();
  }
  Future<void> onRefresh() async {
    setState(() {
      isShowLoader = false;
    });
    startDate == null ? apiCall() : filterApiCall( projectUtil.formatStartDateTime(startDate!),endDate != null
        ? projectUtil.formatEndDateTime(endDate!)
        : null );
    await Future.delayed(const Duration(milliseconds: 2000));
    refreshController.refreshCompleted();
  }
  void visitorCheckout(BuildContext context, int entryId) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WorkplaceWidgets.titleContentPopup(
          buttonName1: "Cancel",
          buttonName2: "Confirm",
          onPressedButton1TextColor: AppColors.black,
          onPressedButton2TextColor: AppColors.white,
          onPressedButton1Color: Colors.grey.shade200,
          onPressedButton2Color: Colors.green,
          onPressedButton1: () => Navigator.pop(context),
          onPressedButton2: () async {
            homeBloc.add(OnVisitorCheckoutEvent(mContext: context,entryHouseId: entryId, status: "approved"));
            Navigator.pop(context);
          },
          title: "Allow Visitor",
          content: "Do you want to allow the guard to check in this visitor?",
        );
      },
    );
  }
  void visitorDeny(BuildContext context, int entryId) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WorkplaceWidgets.titleContentPopup(
          buttonName1: "Cancel",
          buttonName2: "Confirm",
          onPressedButton1TextColor: AppColors.black,
          onPressedButton2TextColor: AppColors.white,
          onPressedButton1Color: Colors.grey.shade200,
          onPressedButton2Color: AppColors.red,
          onPressedButton1: () => Navigator.pop(context),
          onPressedButton2: () async {
            homeBloc.add(OnVisitorCheckoutEvent(mContext: context,entryHouseId: entryId, status: "denied"));
            Navigator.pop(context);
          },
          title: "Deny Visitor",
          content: "Do you want to deny the guard permission to check in this visitor?",
        );
      },
    );
  }
  Future<void> selectDate(BuildContext context, bool isStartDate,
      void Function(void Function()) setState) async {
    DateTime now = DateTime.now();
    DateTime fiveYearsAgo = now.subtract(const Duration(days: 5 * 365));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: fiveYearsAgo,
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.appBlueColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        setState(() {
          try {
            if (isStartDate) {
              startDate = pickedDate;
              showStartDateError = false;
              showEndDateError = false;
              if (endDate != null) {
                if (endDate!.isBefore(startDate!)) {
                  endDate = null;
                  endDateErrorMessage = "End date must be after start date.";
                  showEndDateError = true;
                } else if (endDate!.difference(startDate!).inDays > 7) {
                  endDate = null;
                  endDateErrorMessage =
                  "Difference between dates should not exceed 7 days.";
                  showEndDateError = true;
                }
              }
            } else {
              if (startDate == null) {
                showStartDateError = true;
                return;
              }

              if (pickedDate.isBefore(startDate!)) {
                endDate = null;
                endDateErrorMessage = "End date must be after start date.";
                showEndDateError = true;
              } else if (pickedDate.difference(startDate!).inDays > 7) {
                endDate = null;
                endDateErrorMessage =
                "Difference between dates should not exceed 7 days.";
                showEndDateError = true;
              } else {
                endDate = pickedDate;
                showEndDateError = false;
              }
            }
          } catch (e) {
            debugPrint('$e');
          }
        });
      });
    }
  }


  void showFilterPopup(BuildContext context) {
    showMenu(
      context: context,
      color: Colors.white,
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: const RelativeRect.fromLTRB(130, 130, 30, 0),
      items: [
        PopupMenuItem(
          enabled: false,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Filter by Date",
                            style: appTextStyle.appTitleStyle()),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              showStartDateError = false;
                              showEndDateError = false;
                              endDateErrorMessage = "";
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            color: Colors.transparent,
                            child:
                            const Icon(Icons.clear, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Start Date
                    Text("Start Date",
                        style: appTextStyle.appNormalSmallTextStyle()),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => selectDate(context, true, setState),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: showStartDateError
                                ? Colors.red
                                : Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                startDate == null
                                    ? 'dd/mm/yyyy'
                                    : projectUtil.formatDate(startDate),
                                style: appTextStyle.appNormalSmallTextStyle(
                                    fontSize: 16)),
                            const Icon(Icons.calendar_today,
                                size: 18, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                    if (showStartDateError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Please select start date",
                          style: appTextStyle.appNormalSmallTextStyle(
                              color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 12),
                    Text("End Date (Optional)",
                        style: appTextStyle.appNormalSmallTextStyle()),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        if (startDate == null) {
                          setState(() {
                            showStartDateError = true;
                          });
                          return;
                        }
                        selectDate(context, false, setState);
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: showEndDateError
                                ? Colors.red
                                : Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                endDate == null
                                    ? 'dd/mm/yyyy'
                                    : projectUtil.formatDate(endDate),
                                style: appTextStyle.appNormalSmallTextStyle(
                                    fontSize: 16)),
                            const Icon(Icons.calendar_today,
                                size: 18, color: Colors.black),
                          ],
                        ),
                      ),
                    ),

                    if (showEndDateError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          endDateErrorMessage,
                          style: appTextStyle.appNormalSmallTextStyle(
                              color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Apply Filter Button
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        buttonHeight: 40,
                        buttonName: 'Apply Filter',
                        buttonColor: AppColors.appBlueColor,
                        textStyle: appTextStyle.buttonTextStyle1(
                          texColor: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        backCallback: () {
                          setState(() {
                            if (startDate == null) {
                              showStartDateError = true;
                              return;
                            }
                            if (endDate != null) {
                              if (endDate!.isBefore(startDate!)) {
                                endDate = null;
                                endDateErrorMessage =
                                "End date must be after start date.";
                                showEndDateError = true;
                                return;
                              } else if (endDate!
                                  .difference(startDate!)
                                  .inDays >
                                  7) {
                                endDate = null;
                                endDateErrorMessage =
                                "Difference between dates should not exceed 7 days.";
                                showEndDateError = true;
                                return;
                              }
                            }
                          });

                          // Apply filter logic
                          if (startDate != null) {
                            String formattedStartDate =
                            projectUtil.formatStartDateTime(startDate!);
                            String? formattedEndDate = endDate != null
                                ? projectUtil.formatEndDateTime(endDate!)
                                : null;

                            //Clear error msg
                            showEndDateError = false;
                            endDateErrorMessage = "";
                            isFilterApplied = true;
                            // Close popup after applying the filter
                            Navigator.pop(context);
                            //Call API
                            filterApiCall(formattedStartDate,formattedEndDate);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar() {
      return Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        child: Row(
          children: [
            Flexible(
              child: CommonSearchBar(
             padding: EdgeInsets.zero,
             controller: controller,
             hintText: 'Search visitor',
            onChangeTextCallBack:(searchText) {
              setState(() {
                controller.text = searchText;
                homeBloc.add(OnGetVisitorHistoryListEvent(
                    mContext: context,
                    endTime: projectUtil.getYesterdayEndTime(),
                    search: searchText,
                    houseId: userProfileBloc.selectedUnit!.id
                ));
              });
            },
          onClickCrossCallBack: () {
            controller.clear();
            FocusScope.of(context).unfocus();
            setState(() {
              isShowLoader = false;
            });
            apiCall();
          },

        )



            ),
            GestureDetector(
              onTap: () {
                showFilterPopup(context);
                closeKeyboard();
              },
              child: Stack(
                clipBehavior: Clip
                    .none, // Allows the dot to be positioned outside the container
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10,top: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black.withOpacity(0.7)),
                    ),
                    child: Icon(Icons.filter_list,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                  // Blue dot indicator when a filter is applied
                  if (isFilterApplied) // startDate != null || endDate != null
                    Positioned(
                      right: 2, // Adjust position
                      top: 2, // Adjust position
                      child: Container(
                        width: 10, // Size of the dot
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.appBlueColor, // Blue dot color
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget showStartEndDateCard(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${startDate != null ? projectUtil.formatDate(startDate!) : ''}"
                    "${endDate != null ? ' - ${projectUtil.formatDate(endDate!)}' : ''}",
                style: appTextStyle.appNormalSmallTextStyle(),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    //Remove Filter
                    startDate = null;
                    endDate = null;
                    isFilterApplied = false;
                    apiCall();
                  });
                },
                child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.clear, size: 18, color: Colors.black)),
              ),
            ],
          ),
        ),
      );
    }


    return BlocListener<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {
        if (state is VisitorHistoryErrorState) {
          WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
        }
        if (state is VisitorHistoryDoneState) {}
        if (state is VisitorCheckoutDoneState) {
          setState(() {
            isShowLoader = false;
          });
          apiCall();
          if (state.status != "denied") {
            WorkplaceWidgets.successToast(AppString.visitorAllowSuccessfully);
          } else{
            WorkplaceWidgets.errorSnackBar(context, AppString.visitorDenySuccessfully);
          }
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: homeBloc,
        builder: (context, state) {
          if (state is VisitorHistoryErrorState) {
            return WorkplaceWidgets.noDataWidget(context, state.errorMessage);
          }
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  searchBar(),
                  // Display Start Date & End Date if at least one exists
                  if (startDate != null || endDate != null)
                    showStartEndDateCard(),
                  Expanded(
                    child: SmartRefresher(
                      onRefresh: onRefresh,
                      controller: refreshController,
                      child: homeBloc.visitorHistoryData.isEmpty
                          ? WorkplaceWidgets.noDataWidget(
                        context,
                        state is VisitorHistoryLoadingState
                            ? ''
                            : 'No data found',
                      )
                          : ListView.builder(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15)
                            .copyWith(bottom: 40),
                        itemCount: homeBloc.visitorHistoryData.length,
                        itemBuilder: (context, index) {
                          final visitor =
                          homeBloc.visitorHistoryData[index];
                          return VisitorCardWidget(
                            isComingFrom: false,
                            visitorData: visitor,
                            onTab: () {
                              Navigator.push(
                                context,
                                SlideLeftRoute(
                                  widget:
                                      VisitorDetailScreen(
                                        isComingFrom: false,
                                        visitorData: visitor,
                                      ),
                                ),
                              ).then((value) {
                                closeKeyboard();
                              });
                            },
                            onInfoTab: () {
                              Navigator.push(
                                context,
                                SlideLeftRoute(
                                  widget:
                                      VisitorDetailScreen(
                                        isComingFrom: false,
                                        visitorData: visitor,
                                      ),
                                ),
                              ).then((value) {
                                closeKeyboard();
                              });
                            },
                            onCheckOutTab: () {
                              visitorCheckout(context, homeBloc.visitorHistoryData[index].houses!.first.entryHouseId ?? 0);
                            },
                            onDenyTab: (){
                              visitorDeny(context, homeBloc.visitorHistoryData[index].houses!.first.entryHouseId ?? 0);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (state is VisitorHistoryLoadingState&& state is VisitorLoadingState && isShowLoader)
                WorkplaceWidgets.progressLoader(context),
            ],
          );
        },
      ),
    );
  }
}
