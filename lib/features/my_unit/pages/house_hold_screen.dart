// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:asetize/features/my_unit/pages/request_for_noc_screen.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../../../widgets/commonTitleRowWithIcon.dart';
import '../../../widgets/common_card_view.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_state.dart';
import '../../add_vehicle_for_manager/pages/add_member_phone_new_screen.dart';
import '../../add_vehicle_for_manager/widgets/vehicle_card_widget.dart';
import '../../my_family/widgets/family_member_common_card_view.dart';
import '../../my_vehicle/bloc/my_vehicle_bloc.dart';
import '../../my_vehicle/bloc/my_vehicle_event.dart';
import '../../my_vehicle/bloc/my_vehicle_state.dart';
import '../../noc_list/pages/noc_request_detail_screen.dart';
import '../../pets/bloc/pet_bloc.dart';
import '../../pets/bloc/pet_event.dart';
import '../../pets/bloc/pet_state.dart';
import '../../pets/pages/add_pet_form.dart';
import '../../pets/pages/add_pet_vacination_detail_screen.dart';
import '../../pets/widgets/pet_card_widget.dart';
import '../../vehicle_identification_form/pages/vehicle_from_screen.dart';
import '../bloc/my_unit_bloc.dart';
import '../widgets/house_hold_top_card_widget.dart';
import '../widgets/noc_applied_common_widget.dart';
import 'noc_applied_detail_screen.dart';

class HouseHoldScreen extends StatefulWidget {
  final String title;
  final int houseId;
  final bool? isComingFromViewStatement;

  const HouseHoldScreen(
      {super.key,
      required this.title,
      required this.houseId,
      this.isComingFromViewStatement = false});

  @override
  State<HouseHoldScreen> createState() => _HouseHoldScreenState();
}

class _HouseHoldScreenState extends State<HouseHoldScreen> {
  late AddVehicleManagerBloc addVehicleManagerBloc;
  late MyVehicleListBloc myVehicleListBloc;
  late UserProfileBloc userProfileBloc;
  late PetBloc petBloc;
  bool isShowLoader = true;
  bool isShowDeleteForVehicleIcon = false;
  bool isShowDeleteForMemberIcon = false;
  bool isPrimaryMemberSet = false;
  bool isNotificationDismissed = false;
  late MyUnitBloc myUnitBloc;

  bool isDisableContact = false;
  int? vehicleId;
  int? memberId;
  int? petId;
  int? selectedVehicleId; // Add this variable to track long-pressed vehicle
  int? selectedMemberId;

  bool _isInitialDataEmpty() {
    return petBloc.petList.isEmpty &&
        (addVehicleManagerBloc.memberListData == null) &&
        addVehicleManagerBloc.vehicles.isEmpty &&
        addVehicleManagerBloc.members.isEmpty &&
        myUnitBloc.nocAppliedListData.isEmpty;
  }

  void fetchInitialData() {
    isShowLoader = _isInitialDataEmpty();

    petBloc.add(OnGetListOfPetsEvent(mContext: context));
    addVehicleManagerBloc.add(OnGetHouseDetailEvent(
      mContext: context,
      houseId: widget.houseId.toString(),
    ));
    myUnitBloc.add(OnGetNOCAppliedListEvent(
      mContext: context,
      houseId: widget.houseId,
    ));
  }

  // Add this variable to track long-pressed vehicle
  @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    myVehicleListBloc = BlocProvider.of<MyVehicleListBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    petBloc = BlocProvider.of<PetBloc>(context);

    fetchInitialData();
    PrefUtils()
        .readBool(WorkplaceNotificationConst.isNotificationDismissed)
        .then((value) {
      isNotificationDismissed = value;
    });

    super.initState();
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }


  Future<void> refreshDataOnNotificationComes() async {
    isShowLoader = false;
    myUnitBloc.add(OnGetNOCAppliedListEvent(mContext: context, houseId: widget.houseId,));
  }


  @override
  Widget build(BuildContext context) {
    void deleteMember(BuildContext context, int houseMemberID) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return WorkplaceWidgets.titleContentPopup(
            buttonName1: AppString.cancel,
            buttonName2: AppString.delete,
            onPressedButton1TextColor: AppColors.black,
            onPressedButton2TextColor: AppColors.white,
            onPressedButton1Color: Colors.grey.shade200,
            onPressedButton2Color: Colors.red,
            onPressedButton1: () {
              Navigator.pop(context);
            },
            onPressedButton2: () async {
              addVehicleManagerBloc.add(
                DeleteMemberEvent(
                  houseMemberId: houseMemberID.toString(),
                  mContext: context,
                ),
              );
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            title: AppString.deleteMemberTitle,
            content: AppString.deleteMemberContent,
          );
        },
      );
    }

    void deleteVehicle(BuildContext context, int vehicleID) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return WorkplaceWidgets.titleContentPopup(
            buttonName1: AppString.cancel,
            buttonName2: AppString.delete,
            onPressedButton1TextColor: AppColors.black,
            onPressedButton2TextColor: AppColors.white,
            onPressedButton1Color: Colors.grey.shade200,
            onPressedButton2Color: Colors.red,
            onPressedButton1: () {
              Navigator.pop(context);
            },
            onPressedButton2: () async {
              myVehicleListBloc.add(
                DeleteMyVehicleEvent(
                  id: vehicleID,
                  mContext: context,
                ), // Use the correct property for vehicle ID
              );
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            title: AppString.deleteVehicleTitle,
            content: AppString.deleteVehicleContent,
          );
        },
      );
    }

    void deletePet(BuildContext context, int petId) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return WorkplaceWidgets.titleContentPopup(
            buttonName1: AppString.cancel,
            buttonName2: AppString.delete,
            onPressedButton1TextColor: AppColors.black,
            onPressedButton2TextColor: AppColors.white,
            onPressedButton1Color: Colors.grey.shade200,
            onPressedButton2Color: Colors.red,
            onPressedButton1: () {
              Navigator.pop(context);
            },
            onPressedButton2: () async {
              petBloc
                  .add(OnDeletePetDetailEvent(mContext: context, petId: petId));
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            title: AppString.deletePetTitle,
            content: AppString.deletePetContent,
          );
        },
      );
    }

    Widget rowTextWithAddButton(
        {IconData icon = CupertinoIcons.person_2_fill,
        double iconSize = 20,
        String title = '',
        void Function()? onTapButtonCallBack,
        String permissionName = '',
        Color btColor = AppColors.appBlueColor}) {
      return  Padding(
        padding: const EdgeInsets.only(left: 6, top: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3, right: 5),
                  child: Icon(
                    icon,
                    color: Colors.black,
                    size: iconSize,
                  ),
                ),
                Text(
                  title,
                  style: appTextStyle.appTitleStyle(
                      fontWeight: FontWeight.bold, fontSize: 19,color: AppColors.appBgColor),
                ),
              ],
            ),
            if (permissionName.isNotEmpty
                ? AppPermission.instance.canPermission(permissionName, context: context)
                : true)
              IconButton(
                  onPressed: onTapButtonCallBack,
                  icon: Container(
                    decoration:
                        BoxDecoration(color: btColor.withOpacity(0.15), shape: BoxShape.circle),
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      // blendMode: BlendMode.darken,
                      color: btColor,
                    ),
                  )),
          ],
        ),
      );
    }

    Widget memberList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          rowTextWithAddButton(
              title: AppString.members,
              permissionName: AppString.familyAdd,
              onTapButtonCallBack: () {
                Navigator.push(
                  context,
                    SlideLeftRoute(
                    widget: AddMemberPhoneNumberScreen(
                      houseId: widget.houseId.toString(),
                    ),
                  )).then((value) {
                  if (value != null && value == true) {
                    setState(() {
                      isShowLoader = false;
                    });

                    addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                        mContext: context, houseId: widget.houseId.toString()));
                  }
                });
              }),
          addVehicleManagerBloc.memberListData?.members?.isNotEmpty == true
              ? SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        addVehicleManagerBloc.memberListData?.members?.length ??
                            0,
                    itemBuilder: (context, index) {
                      var member =
                          addVehicleManagerBloc.memberListData!.members![index];
                      final int id = member.id!;

                      return InkWell(
                        onLongPress: () {
                          showCupertinoModalPopup(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                title: const Text(
                                  AppString.chooseAnOption,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                                actions: [
                                  if (member.isPrimary == false)
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        addVehicleManagerBloc
                                            .add(OnSetPrimaryMemberEvent(
                                          mContext: context,
                                          houseMemberId: addVehicleManagerBloc
                                              .memberListData!
                                              .members![index]
                                              .houseMemberId,
                                        ));
                                        Navigator.of(context).pop();
                                        selectedMemberId =
                                            null; // Reset selected member ID on cancel
                                        isPrimaryMemberSet = true;
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.person_fill,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            AppString.setPrimaryMember,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CupertinoActionSheetAction(
                                    onPressed: () {
                                      addVehicleManagerBloc.add(
                                          OnEnableDisableContactEvent(
                                              mContext: context,
                                              isDisableContact:
                                                  member.isPublicContact!,
                                              houseMemberId:
                                                  addVehicleManagerBloc
                                                      .memberListData!
                                                      .members![index]
                                                      .houseMemberId,
                                              itsMe: addVehicleManagerBloc
                                                      .memberListData!
                                                      .members![index]
                                                      .itsMe ??
                                                  false));
                                      Navigator.of(context).pop();
                                      selectedMemberId =
                                          null; // Reset selected member ID on cancel
                                      isPrimaryMemberSet = true;
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        member.isPublicContact!
                                            ? SvgPicture.asset(
                                                'assets/images/disable_contact.svg',
                                                height: 15,
                                                width: 15,
                                                color: Colors.red,
                                              )
                                            : const Icon(
                                                CupertinoIcons.eye_fill,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                        const SizedBox(width: 10),
                                        Text(
                                          member.isPublicContact!
                                              ? AppString
                                                  .disableContactDetailLabel
                                              : AppString
                                                  .enableContactDetailLabel,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                    CupertinoActionSheetAction(
                                    onPressed: () {
                                      if (memberId != null)
                                        deleteMember(context, memberId!);
                                      selectedMemberId =
                                          null; // Reset selected member ID on cancel
                                    },
                                    isDestructiveAction:
                                        true, // Makes text red for delete action
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.delete,
                                            size: 20,
                                            color:
                                                CupertinoColors.destructiveRed),
                                        SizedBox(width: 10),
                                        Text(
                                          AppString.delete,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () {
                                    setState(() {
                                      selectedMemberId = null;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    AppString.cancel,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                          );

                          setState(() {
                            isShowDeleteForMemberIcon = AppPermission.instance
                                .canPermission(AppString.familyDelete,
                                    context: context);
                            memberId = member.houseMemberId;
                            selectedMemberId =
                                id; // Store the selected vehicle ID
                          });
                        },
                        onTap: () {
                          setState(() {
                            selectedMemberId = null; // Reset on tap
                          });
                        },
                        child: FamilyMemberCommonCardView(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 6),
                          imageUrl: member.profilePhoto ?? "",
                          userName: member.name ?? "Unknown",
                          isPublicContact: member.isPublicContact!,
                          jobTitle: member.shortDescription ??
                              "No description available",
                          isPrimary: member.isPrimary,
                          onTabSetPrimary: () {
                            addVehicleManagerBloc.add(OnSetPrimaryMemberEvent(
                              mContext: context,
                              houseMemberId: addVehicleManagerBloc
                                  .memberListData!
                                  .members![index]
                                  .houseMemberId,
                            ));
                          },
                          cardColor: selectedMemberId == id
                              ? Colors.blue.shade100 // Change color if selected
                              : Colors.white,
                        ),
                      );
                    },
                  ),
                )
              : SizedBox(
                  height: 70,
                  child: Center(
                    child: Text(
                      AppString.noMembersFound,
                      textAlign: TextAlign.center,
                      style: appTextStyle.noDataTextStyle(),
                    ),
                  ),
                ),
        ],
      );
    }

    Widget petList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          rowTextWithAddButton(
            icon: Icons.pets,
            title: AppString.pets,
            permissionName: widget.isComingFromViewStatement == true ? AppString.pets : "",
            onTapButtonCallBack: () async {
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: AddPetForm(
                    appTitle: AppString.petBasicInfo,
                  ),
                ),
              ).then((value) {
                if (value != null) {
                  petBloc.add(OnGetListOfPetsEvent(mContext: context));
                }
              });
            },
          ),
          BlocListener<PetBloc, PetState>(
            listener: (context, state) {
              if (state is DeletePetDetailDoneState) {
                WorkplaceWidgets.successToast(AppString.petDeletedSuccessfully, durationInSeconds: 1);
                petBloc.add(OnGetListOfPetsEvent(mContext: context));
              }
              if (state is DeletePetDetailErrorState) {
                WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
              }
              if (state is StorePetInformationDoneState ||
                  state is StorePetVaccinationDetailDoneState ||
                  state is UpdatePetDetailDoneState) {
                petBloc.add(OnGetListOfPetsEvent(mContext: context));
              }
            },
            child: BlocBuilder<PetBloc, PetState>(
              bloc: petBloc,
              builder: (context, state) {
                return petBloc.petList.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: petBloc.petList.length,
                  itemBuilder: (context, index) {
                    var petData = petBloc.petList[index];
                    final int id = petData.id!;

                    return InkWell(
                      onLongPress: () {
                        showCupertinoModalPopup(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              title: Text(
                                '${AppString.chooseAnOption} for ${petData.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                        widget: AddPetVaccinationDetailScreen(
                                          appTitle: AppString.editPetVaccinationInfo,
                                          petData: petData,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        petBloc.add(OnGetListOfPetsEvent(mContext: context));
                                      }
                                      // reset highlight after returning
                                      setState(() {
                                        selectedMemberId = null;
                                      });
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WorkplaceIcons.iconImage(
                                        imageUrl: WorkplaceIcons.editIcon,
                                        imageColor: AppColors.black,
                                        iconSize: const Size(25, 25),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Edit Pet Vaccination Detail',
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                        widget: AddPetForm(
                                          appTitle: AppString.editPetBasicInfo,
                                          petData: petData,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        petBloc.add(OnGetListOfPetsEvent(mContext: context));
                                      }
                                      // reset highlight after returning
                                      setState(() {
                                        selectedMemberId = null;
                                      });
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WorkplaceIcons.iconImage(
                                        imageUrl: WorkplaceIcons.editIcon,
                                        imageColor: AppColors.black,
                                        iconSize: const Size(25, 25),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Edit Pet Information',
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    deletePet(context, petData.id ?? 0);
                                    setState(() {
                                      selectedMemberId = null;
                                    });
                                  },
                                  isDestructiveAction: true,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.delete,
                                          size: 20, color: CupertinoColors.destructiveRed),
                                      SizedBox(width: 10),
                                      Text(
                                        AppString.delete,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() {
                                    selectedMemberId = null;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  AppString.cancel,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        );

                        setState(() {
                          isShowDeleteForMemberIcon =
                              AppPermission.instance.canPermission(AppString.familyDelete, context: context);
                          petId = petData.id;
                          selectedMemberId = id; // highlight selected pet
                        });
                      },
                      onTap: () {},
                      child: PetCardWidget(
                        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        imageUrl: petData.photo ?? "",
                        userName: petData.name ?? "",
                        jobTitle: '${petData.type}/${petData.breed}' ?? "",
                        isVaccinated: petData.vaccinated,
                        cardColor: selectedMemberId == id
                            ? Colors.blue.shade100
                            : Colors.white,
                      ),
                    );
                  },
                )
                    : SizedBox(
                  height: 70,
                  child: Center(
                    child: Text(
                      AppString.noPetsFound,
                      textAlign: TextAlign.center,
                      style: appTextStyle.noDataTextStyle(),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    }


    Widget vehicleList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          rowTextWithAddButton(
            icon: Icons.directions_car,
            title: AppString.vehicles,
            iconSize: 23,
            permissionName: AppString.vehicleAdd,
            onTapButtonCallBack: () {
              Navigator.push(
                  context,
                  SlideLeftRoute(
                      widget: AddVehicleForm()
                  )).then((value) {
                if (value != null && value == true) {
                  isShowLoader = false;
                  addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                      mContext: context, houseId: widget.houseId.toString()));
                }
              });
            },
          ),
          addVehicleManagerBloc.memberListData?.vehicles?.isNotEmpty == true
              ? SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addVehicleManagerBloc
                            .memberListData?.vehicles?.length ??
                        0,
                    itemBuilder: (context, index) {
                      var vehicleData = addVehicleManagerBloc
                          .memberListData!.vehicles![index];
                      final int id = vehicleData.id!;
                      return InkWell(
                        onLongPress: () async {
                          bool hasPermission = await AppPermission.instance
                              .canPermission(AppString.vehicleDelete,
                                  context: context);
                          if (hasPermission) {
                            setState(() {
                              vehicleId = id;
                              selectedVehicleId =
                                  id; // Store the selected vehicle ID
                            });

                            showCupertinoModalPopup(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CupertinoActionSheet(
                                  title: const Text(
                                    AppString.chooseAnOption,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                  ),
                                  actions: [
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        if (vehicleId != null) {
                                          deleteVehicle(context, vehicleId!);
                                        }
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.delete,
                                            size: 20,
                                            color:
                                                CupertinoColors.destructiveRed,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            AppString.delete,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        selectedVehicleId = null;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      AppString.cancel,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        onTap: () {
                          setState(() {
                            selectedVehicleId = null; // Reset on tap
                          });
                        },
                        child: VehicleCardWidget(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          registrationNumber: vehicleData.registrationNumber,
                          ownerName: vehicleData.ownerName,
                          vehicleType: vehicleData.vehicleType,
                          blockName: vehicleData.blockName,
                          isParkingAllotted: vehicleData.isParkingAllotted ?? 0,
                          cardColor: selectedVehicleId == id
                              ? Colors.blue.shade100 // Change color if selected
                              : Colors.white,
                        ),
                      );
                    },
                  ),
                )
              : SizedBox(
                  height: 70,
                  child: Center(
                    child: Text(
                      AppString.noVehiclesFound,
                      textAlign: TextAlign.center,
                      style: appTextStyle.noDataTextStyle(),
                    ),
                  ),
                ),
        ],
      );
    }

    Widget newNOCRequest() {
      return BlocBuilder<MyUnitBloc, MyUnitState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5,),
              rowTextWithAddButton(
                icon: CupertinoIcons.doc_text_fill,
                title: AppString.noc,
                permissionName:  AppString.nocRequestPermission,
                onTapButtonCallBack:
                    (myUnitBloc.nocAppliedListData.isEmpty ?? true) ||
                            (myUnitBloc.nocAppliedListData.first.status ==
                                    'issued' ||
                                myUnitBloc.nocAppliedListData.first.status ==
                                    'rejected' ||
                                myUnitBloc.nocAppliedListData.first.status ==
                                    'approved')
                        ? () {
                      Navigator.push(
                          context,
                          SlideLeftRoute(
                              widget: RequestForNocScreen(
                                  houseId: widget.houseId,
                                  title: widget.title)
                          )).then((value) {
                              if (value == true) {
                                refreshDataOnNotificationComes();
                              }
                            });
                          }
                        : null,
                btColor: (myUnitBloc.nocAppliedListData.isEmpty ?? true) ||
                        (myUnitBloc.nocAppliedListData.first.status == 'issued' ||
                            myUnitBloc.nocAppliedListData.first.status == 'rejected' ||
                            myUnitBloc.nocAppliedListData.first.status == 'approved')
                    ? AppColors.appBlueColor // Enabled state color
                    : Colors.grey,
              ),
              myUnitBloc.nocAppliedListData.isNotEmpty == true
                  ? SlidableAutoCloseBehavior(
                      closeWhenOpened: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myUnitBloc.nocAppliedListData.length ?? 0,
                        itemBuilder: (context, index) {
                          var nocAppliedListData =
                              myUnitBloc.nocAppliedListData[index];
                          final int id = nocAppliedListData?.id ?? 0;
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideLeftRoute(
                                      widget: NocAppliedDetailScreen(
                                        id: nocAppliedListData!.id ?? 1,
                                        title: widget.title ?? '',
                                        houseId: widget.houseId,
                                      )
                                  )).then((value) {
                                if (value == true) {
                                  refreshDataOnNotificationComes();
                                }
                              });
                            },
                            child: NocAppliedCard(
                                name: nocAppliedListData?.firstName,
                                lastName: nocAppliedListData?.lastName ?? '',
                                title: nocAppliedListData?.purpose,
                                purpose: nocAppliedListData?.purpose,
                                status: nocAppliedListData?.status,
                                date: nocAppliedListData?.createdAt),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      height: 70,
                      child: Center(
                        child: Text(
                          AppString.noNOCFound,
                          textAlign: TextAlign.center,
                          style: appTextStyle.noDataTextStyle(),
                        ),
                      ),
                    ),
            ],
          );
        },
      );
    }

    Widget notificationMessage() {
      return Visibility(
        visible: !isNotificationDismissed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5,).copyWith(bottom: 5),
          child: CommonCardView(
            cardColor: const Color(0xFFfef5e7),
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
                          .copyWith(right: 25),
                  child: Text(
                    addVehicleManagerBloc
                            .memberListData?.notificationsMessage ??
                        '',
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 7,
                  child: GestureDetector(
                    onTap: () {
                      PrefUtils().saveBool(
                          WorkplaceNotificationConst.isNotificationDismissed,
                          true);
                      setState(() {
                        isNotificationDismissed = true;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 21,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      bloc: userProfileBloc,
      builder: (context, state) {
        return ContainerFirst(
            contextCurrentView: context,
            isSingleChildScrollViewNeed: false,
            isFixedDeviceHeight: true,
            isListScrollingNeed: true,
            isOverLayStatusBar: false,
            appBarHeight: 50,
            appBar: CommonAppBar(
              title: AppString.houseHold,
              icon: WorkplaceIcons.backArrow,
            ),
            containChild: BlocListener<MyVehicleListBloc, MyVehicleListState>(
              bloc: myVehicleListBloc,
              listener: (context, state) {
                if (state is MyVehicleErrorState) {


                  WorkplaceWidgets.errorSnackBar(context, state.errorMessage);

                }
                if (state is DeleteMyVehicleLoadedState) {
                  isShowLoader = false;
                  addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                      mContext: context, houseId: widget.houseId.toString()));
                }
              },
              child:
                  BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
                bloc: addVehicleManagerBloc,
                listener: (context, state) {
                  if (state is OnGetHouseDetailErrorState) {
                    WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
                  }
                  if (state is DeleteMemberErrorState) {

                    WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
                  }
                  if (state is SetPrimaryMemberErrorState) {

                    WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
                  }
                  if (state is EnableDisableContactErrorState) {

                    WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
                  }
                  if (state is DeleteMemberDoneState) {
                    WorkplaceWidgets.successToast(AppString.memberDeletedSuccessfully,durationInSeconds: 1);


                    isShowLoader = false;
                    addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                        mContext: context, houseId: widget.houseId.toString()));
                  }

                  if (state is OnSetPrimaryMemberDoneState) {
                    isShowLoader = false;
                    addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                        mContext: context, houseId: widget.houseId.toString()));
                  }

                  if (state is EnableDisableContactDoneState) {
                    isShowLoader = false;

                    addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                        mContext: context, houseId: widget.houseId.toString()));

                    WorkplaceWidgets.successToast(state.isDisableContact
                        ? AppString.disableContactDetail
                        : AppString.enableContactDetail,durationInSeconds: 1);

                  }
                },
                child:
                    BlocBuilder<AddVehicleManagerBloc, AddVehicleManagerState>(
                  bloc: addVehicleManagerBloc,
                  builder: (context, state) {
                    if (state is AddVehicleManagerInitialState) {
                      // addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                      //     mContext: context, houseId: widget.houseId.toString()));
                    }

                    if (state is AddVehicleManagerLoadingState ||
                        state is NOCAppliedListLoadingState) {
                      if (isShowLoader == true) {
                        return WorkplaceWidgets.progressLoader(context);
                      }
                    }

                    return Stack(
                      children: [
                        ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          children: [
                            HouseHoldTopCardWidget(
                              openingBalance: addVehicleManagerBloc
                                  .memberListData?.openingBalance,
                              sizeInSqFit: addVehicleManagerBloc
                                  .memberListData?.sizeInSqft,
                              houseNumber: addVehicleManagerBloc
                                  .memberListData?.houseNumber,
                            ),
                            SizedBox(height: 15,),
                            notificationMessage(),
                            if (AppPermission.instance.canPermission(
                                    AppString.familyList,
                                    context: context) ||
                                AppPermission.instance.canPermission(
                                    AppString.houseStatementsList,
                                    context: context))
                              memberList(),
                            // if (widget.isComingFromViewStatement == false)
                              petList(),
                            if (AppPermission.instance.canPermission(
                                    AppString.vehicleList,
                                    context: context) ||
                                AppPermission.instance.canPermission(
                                    AppString.houseStatementsList,
                                    context: context))
                              vehicleList(),
                            const SizedBox(
                              height: 10,
                            ),
                            if (AppPermission.instance.canPermission(AppString.nocRequestPermission, context: context))
                              newNOCRequest(),
                          ],
                        ),
                        if (state is SetPrimaryMemberLoadingState ||
                            state is EnableDisableContactLoadingState &&
                                isShowLoader == true)
                          WorkplaceWidgets.progressLoader(context),
                        NetworkStatusAlertView(onReconnect: (){
                          petBloc.add(OnGetListOfPetsEvent(mContext: context));
                          addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                              mContext: context, houseId: widget.houseId.toString()));
                          myUnitBloc.add(OnGetNOCAppliedListEvent(mContext: context, houseId: widget.houseId));
                        },)
                      ],
                    );
                  },
                ),
              ),
            ));
      },
    );
  }
}
