import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asetize/core/util/app_navigator/app_navigator.dart';
import 'package:asetize/imports.dart';
import '../../../../core/network/api_base_helpers.dart';
import '../../../../core/util/app_permission.dart';
import '../../../../core/util/app_theme/text_style.dart';
import '../../../approval_pending_screen/bloc/approval_pending_bloc.dart';
import '../../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../../add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import '../../../find_helper/bloc/find_helper_bloc.dart';
import '../../../home_screen/bloc/home_new_bloc.dart';
import '../../../home_screen/pages/all_notice_screen.dart';
import '../../../member/bloc/team_member/team_member_bloc.dart';
import '../../../my_unit/bloc/my_unit_bloc.dart';
import '../../../my_vehicle/bloc/my_vehicle_bloc.dart';
import '../../../my_vehicle/bloc/my_vehicle_event.dart';
import '../notification_bell_widget.dart';

class HomeScreenAppBar extends StatefulWidget {
const HomeScreenAppBar({
    Key? key,
    this.notificationCount,
    required this.isShow,
    this.itemsLength,
    this.onCompanySelect,
    this.onOtherOptionSelect,
    this.selectedCompanyName,
    this.selectedCompanyId,
    required this.listOfCompanies, // Required parameter
  }) : super(key: key);


  final int? notificationCount;
  final bool isShow;
  final int? itemsLength;
  final Function(int companyId, bool isApprovalPending, bool onChangCompany)?
  onCompanySelect;
  final Function(String selectedOptionTitle)? onOtherOptionSelect;
  final List<Companies> listOfCompanies; // Updated to List of Maps
  final String? selectedCompanyName;
  final int? selectedCompanyId;

  @override
  State<HomeScreenAppBar> createState() =>
      _HomeScreenAppBarState(this.listOfCompanies);
}

class _HomeScreenAppBarState extends State<HomeScreenAppBar> {
  late UserProfileBloc userProfileBloc;
  String? selectedCompanyName;
  int? selectedCompanyId;
  bool isApprovalPending = false;
  late FeedBloc feedBloc;
  late MyUnitBloc myUnitBloc;
  late TeamMemberBloc teamMemberBloc;
  late MyVehicleListBloc myVehicleListBloc;
  late FindHelperBloc findHelperBloc;
  late HomeNewBloc homeNewBloc;
  late AddVehicleManagerBloc addVehicleManagerBloc;
  late List<Companies> listOfCompanies = [];
  _HomeScreenAppBarState(this.listOfCompanies) {
    onCompanyTap("");
  }

  @override
  void initState() {
    super.initState();

    selectedCompanyId ??= widget.selectedCompanyId;
    selectedCompanyName ??= widget.selectedCompanyName;

    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    feedBloc = BlocProvider.of<FeedBloc>(context);
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    teamMemberBloc = BlocProvider.of<TeamMemberBloc>(context);
    myVehicleListBloc = BlocProvider.of<MyVehicleListBloc>(context);
    findHelperBloc = BlocProvider.of<FindHelperBloc>(context);
    homeNewBloc = BlocProvider.of<HomeNewBloc>(context);
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
  }

  @override
  void didUpdateWidget(covariant HomeScreenAppBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    listOfCompanies = widget.listOfCompanies;
    if(widget.selectedCompanyId!=null && widget.selectedCompanyName!=null) {
      selectedCompanyId = widget.selectedCompanyId;
      selectedCompanyName = widget.selectedCompanyName;
    }

    // setState(() {
    onCompanyTap("");
    // });
  }

  Future<void> saveSelectedCompany(
      int companyId, bool isApprovalPending) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_company_id', companyId);
    ApiBaseHelpers.selectedCompanySaveId = companyId.toString();
    WorkplaceDataSourcesImpl.selectedCompanySaveId = companyId.toString();
    WorkplaceDataSourcesImpl();
    BlocProvider.of<FeedBloc>(context).add(ResetFeedEvent());
    BlocProvider.of<MyUnitBloc>(context).add(ResetMyUnitEvent());
    BlocProvider.of<TeamMemberBloc>(context).add(ResetTeamBlocEvent());
    BlocProvider.of<MyVehicleListBloc>(context).add(ResetMyVehicleBlocEvent());
    BlocProvider.of<FindHelperBloc>(context).add(ResetFindHelperEvent());
    BlocProvider.of<AddVehicleManagerBloc>(context).add(ResetBlockListEvent());
    // BlocProvider.of<HomeNewBloc>(context).add(ResetNoticeBoardEvent());
    print("✅ Company ID saved: $companyId");
  }

  Future showTopBottomSheet(BuildContext context) async {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter, // Show at the top
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: Platform.isIOS ? 42 :  18, left: 6, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '$selectedCompanyName',
                                  style: appTextStyle.appTitleStyle(),
                                ),
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 32, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            if (AppPermission.instance
                                .canPermission(AppString.noticeList, context: context))
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.pop(context);
                              //   },
                              //   child: SvgPicture.asset(
                              //     'assets/images/announcement_icon.svg',
                              //     color: widget.isShow
                              //         ? Colors.black
                              //         : AppColors.black.withOpacity(0.7),
                              //     height: 27,
                              //     width: 27,
                              //   ),
                              // ),
                            NotificationBal2(
                              // notificationCount: widget.notificationCount,
                              rightIconBoxSize: 50,
                              onTap: () {
                                appNavigator.launchNotificationPage(context);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // List of Companies
                  Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: listOfCompanies.length +
                          1, // Extra item for "Add Flat/Villa/Office"
                      itemBuilder: (context, index) {
                        if (index == listOfCompanies.length) {
                          return Column(
                            children: [
                              // const Divider(),
                              // ListTile(
                              //   onTap: () {
                              //     widget.onOtherOptionSelect
                              //         ?.call('Add Flat/Villa/Office');
                              //     Navigator.pop(context);
                              //   },
                              //   leading: Container(
                              //     padding: const EdgeInsets.all(4),
                              //     decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: Border.all(
                              //             color: Colors.black.withOpacity(0.8))),
                              //     child: Icon(
                              //       Icons.add,
                              //       color: Colors.black.withOpacity(0.8),
                              //     ),
                              //   ),
                              //   title: Text(
                              //     "Add Flat/Villa/Office",
                              //     style: TextStyle(
                              //         fontWeight: FontWeight.w500,
                              //         color: Colors.black.withOpacity(0.8)),
                              //   ),
                              // ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.pop(context);
                              //   },
                              //   child: Align(
                              //     alignment: Alignment.center,
                              //     child: Container(
                              //       color: Colors.transparent,
                              //       child: Container(
                              //         height: 4,
                              //         width: 60,
                              //         margin: const EdgeInsets.only(
                              //             top: 12, bottom: 4, left: 12, right: 12),
                              //         alignment: Alignment.center,
                              //         padding: const EdgeInsets.symmetric(vertical: 10),
                              //         decoration: BoxDecoration(
                              //             color: Colors.grey.shade200,
                              //             borderRadius: BorderRadius.circular(5)),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          );
                        }
                        final company = listOfCompanies[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                String newValue = company.name.toString().trim();
                                onCompanyTap(newValue.trim());
                                Navigator.pop(context);
                              },
                              child: Container(color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        company.name.toString().trim(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.black.withOpacity(0.8)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1), // Start from top
            end: const Offset(0, 0), // Move to center
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget homeAppBar() {
     return  BlocListener<UserProfileBloc, UserProfileState>(
        bloc: userProfileBloc,
        listener: (context, state) {
          if (state is CompanyChangeBackgroundDoneState) {
            /// Update company
            if(state.companyName!=null && state.companyId!=null){
              listOfCompanies = userProfileBloc.user.companies ?? [];
              Companies company = listOfCompanies
                  .firstWhere((company) => company.id == state.companyId);

              onCompanyTap(company.name);
            }
          }
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
            bloc: userProfileBloc,
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.only(left: 10, right: 8),
                decoration:  const BoxDecoration(
                  color: Color(0xFFF5F5F5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showTopBottomSheet(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '$selectedCompanyName',
                              style: appTextStyle.appTitleStyle(),
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                size: 32, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                    // DropdownButtonHideUnderline(
                    //   child:  DropdownButton<String>(
                    //   alignment: AlignmentDirectional.center,
                    //   dropdownColor: Colors.white,
                    //   isDense: false,
                    //   isExpanded: false,
                    //
                    //   padding: const EdgeInsets.symmetric(horizontal: 0),
                    //   borderRadius: BorderRadius.circular(8),
                    //   value: selectedCompanyName ?? "",
                    //   icon: const Icon(Icons.keyboard_arrow_down, size: 32, color: Colors.black),
                    //   style: appTextStyle.appBarTitleStyle(),
                    //   onChanged: (String? newValue) {
                    //     if (newValue == "Add Flat/Villa/Office") {
                    //       widget.onOtherOptionSelect?.call('Add Flat/Villa/Office');
                    //     } else {
                    //       onCompanyTap(newValue);
                    //     }
                    //   },
                    //   items: [
                    //     ...listOfCompanies.map<DropdownMenuItem<String>>(
                    //           (Map<String, dynamic> company) {
                    //         return DropdownMenuItem<String>(
                    //
                    //           value: company['name'].toString().trim(),
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(right: 0),
                    //             child: Text(
                    //               company['name'].toString().trim(),
                    //               overflow: TextOverflow.ellipsis,
                    //               maxLines: 1,
                    //               style: appTextStyle.appTenancyTitleStyle(
                    //                 fontWeight: FontWeight.w700,
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ).toList(),
                    //      DropdownMenuItem<String>(
                    //       value: "Add Flat/Villa/Office",
                    //       child: Text(
                    //         "Add Flat/Villa/Office",
                    //         style: appTextStyle.appTenancyTitleStyle(
                    //           fontWeight: FontWeight.w700,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    //
                    //             ),

                    Row(
                      children: [
                        // if (AppPermission.instance.canPermission(
                        //     AppString.noticeList,
                        //     context: context))
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(
                          //       MainAppBloc.getDashboardContext,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //           const AllNoticeScreen()),
                          //     );
                          //   },
                          //   child: SvgPicture.asset(
                          //     'assets/images/announcement_icon.svg',
                          //     color: widget.isShow
                          //         ? Colors.black
                          //         : AppColors.black.withOpacity(0.7),
                          //     height: 27,
                          //     width: 27,
                          //   ),
                          // ),
                        NotificationBal2(
                          // notificationCount: widget.notificationCount,
                          rightIconBoxSize: 50,
                          onTap: () {
                            appNavigator.launchNotificationPage(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      );
    }

    return homeAppBar();
  }

  void onCompanyTap(String? newValue) {
    if (selectedCompanyName == newValue) {
      return;
    }
    if (newValue != null &&
        newValue.isNotEmpty &&
        selectedCompanyName != newValue) {
      setState(() {
        selectedCompanyName = newValue;
        Companies company = listOfCompanies
            .firstWhere((company) => company.name == newValue);
        selectedCompanyId = company.id;
        try {
          isApprovalPending = company.status == "approved"
              ? false
              : true;
        } catch (e) {
          print(e);
        }
      });
    }
    else {
      if (listOfCompanies.isNotEmpty) {
        final savedCompanyId = WorkplaceDataSourcesImpl.selectedCompanySaveId;
        isApprovalPending = false;
        if (savedCompanyId != null) {
          // A company ID was already saved, retrieve the company name
          selectedCompanyId = int.parse(savedCompanyId);
          Companies company = listOfCompanies
              .firstWhere((company) => company.id == selectedCompanyId);
          try {
            isApprovalPending = company.status == "approved"
                ? false
                : true;
          } catch (e) {
            print(e);
          }
          selectedCompanyName = company.name;
        } else {
          // No company selected before, set the first company's details
          Companies company = listOfCompanies.first;
          try {
            isApprovalPending = company.status == "approved";
          } catch (e) {
            print(e);
          }
          selectedCompanyName = company.name;
          selectedCompanyId = company.id;
        }
      }
    }
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      BlocProvider.of<ApprovalPendingBloc>(context).add(OnApprovalStateChangeEvent(isApprovalPending: isApprovalPending));
      widget.onCompanySelect!(selectedCompanyId!, isApprovalPending,
          newValue != null && newValue.isNotEmpty ? true : false);
    });
  }
}
