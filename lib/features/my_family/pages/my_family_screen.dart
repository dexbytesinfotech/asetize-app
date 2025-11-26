import 'package:flutter/cupertino.dart';
import '../../../app_global_components/common_floating_add_button.dart';
import '../../../app_global_components/no_units_error_screen.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_state.dart';

import '../widgets/family_member_common_card_view.dart';
import 'add_family_phone_verify_screen.dart';

class MyFamilyScreen extends StatefulWidget {
  const MyFamilyScreen({super.key});

  @override
  State<MyFamilyScreen> createState() => MyFamilyScreenState();
}

class MyFamilyScreenState extends State<MyFamilyScreen> {
  late AddVehicleManagerBloc addVehicleManagerBloc;
  late UserProfileBloc userProfileBloc;
  List<Houses> houses = [];
  int? houseMemberId;
  int? selectedVehicleId;
  bool isShowDeleteIcon = false;
  bool isShowLoader = true;

  bool  isPrimaryMemberSet =false;

  @override
  void initState() {
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);


    if (userProfileBloc.user.houses != null &&
        userProfileBloc.user.houses!.isNotEmpty) {
      houses = userProfileBloc.user.houses ?? [];
      // onUnitSelect(userProfileBloc.selectedUnit);
    }
    // if (userProfileBloc.user.houses != null &&
    //     userProfileBloc.user.houses!.isNotEmpty) {
    //   houses = userProfileBloc.user.houses ?? [];
    //   selectedUnit = userProfileBloc.user.houses?[0];
    //   addVehicleManagerBloc.add(OnGetHouseDetailEvent(mContext: context, houseId: selectedUnit?.id.toString()?? '' ));
    // }

    super.initState();
  }


  List<Widget> actions() {
    return List.generate(houses.length, (index) {
      return CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
          onUnitSelect(houses[index]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Remove the SvgPicture and make color blank
            Text(
              '${houses[index].title}',
              style: TextStyle(
                color: userProfileBloc.selectedUnit?.title == houses[index].title
                    ? AppColors.buttonBgColor3 // Selected color
                    : Colors.black,            // Default color
                fontWeight: userProfileBloc.selectedUnit?.title == houses[index].title
                    ? FontWeight.w600          // Selected font weight
                    : FontWeight.normal,       // Default font weight
              ),
            ),

          ],
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      bottomSafeArea: true,
      isOverLayAppBar: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(
          title: AppString.myFamily,
          icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
        listener: (context, state) {
          if (state is OnGetHouseDetailErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is AddVehicleManagerErrorState) {

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

          if(state is OnSetPrimaryMemberDoneState)
          {
            isShowLoader =false;
            onUnitSelect(userProfileBloc.selectedUnit);
            // addVehicleManagerBloc.add(OnGetHouseDetailEvent(mContext: context, houseId: userProfileBloc.selectedUnit?.id.toString()?? '' ));
          }
          if(state is DeleteMemberDoneState)
          {
            isShowLoader =false;
            onUnitSelect(userProfileBloc.selectedUnit);
            // addVehicleManagerBloc.add(OnGetHouseDetailEvent(mContext: context, houseId: userProfileBloc.selectedUnit?.id.toString()?? '' ));
            WorkplaceWidgets.successToast('Member deleted successfully',durationInSeconds: 1);

          }


          if (state is EnableDisableContactDoneState) {
            isShowLoader = false;
            onUnitSelect(userProfileBloc.selectedUnit);

            WorkplaceWidgets.successToast(
                 state.isDisableContact
                    ? AppString.disableContactDetail
                    : AppString.enableContactDetail);
          }


        },
        child: BlocBuilder<AddVehicleManagerBloc, AddVehicleManagerState>(
          builder: (context, state) {
            if (state is AddVehicleManagerInitialState) {
              onUnitSelect(userProfileBloc.selectedUnit);
             // addVehicleManagerBloc.add(OnGetHouseDetailEvent(mContext: context, houseId: userProfileBloc.selectedUnit?.id.toString()?? '' ));
            }
            if(userProfileBloc.selectedUnit==null){
              return const Center(child: NoUnitsErrorScreen());
            }

            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: (){
                        if (userProfileBloc.user.houses!.length > 1) {
                          showCupertinoModalPopup(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CupertinoActionSheet(
                                  title: const Text(
                                    AppString.selectUnit,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                  ),
                                  actions: actions(),
                                  cancelButton: CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      AppString.cancel,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.apartment,
                            color: AppColors.textBlueColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppString.unitNoWithColon,
                            style: appTextStyle.appTitleStyle(),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Text(
                                userProfileBloc.selectedUnit?.title ?? AppString.selectUnit,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                              userProfileBloc.user.houses!.length > 1
                                  ? const Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.textBlueColor,
                                size: 30,
                              )
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    getDateScreen(state)
                  ],
                ),
                if (state is SetPrimaryMemberLoadingState || state is  AddVehicleManagerLoadingState ||
                state is EnableDisableContactLoadingState && isShowLoader)
                  WorkplaceWidgets.progressLoader(context),

              ],
            );
          },
        ),
      ),

      bottomMenuView: AppPermission.instance.canPermission(AppString.familyAdd, context: context)?
      BlocBuilder<AddVehicleManagerBloc, AddVehicleManagerState>(
          builder: (context, state) {
            if(userProfileBloc.selectedUnit==null || userProfileBloc.selectedUnit!.status!="active"){
              return const SizedBox();
            }
            return CommonFloatingAddButton(onPressed: () {
              Navigator.push(
                context,
                SlideLeftRoute(
                    widget:  AddFamilyPhoneVerifyScreen(
                        houseId: userProfileBloc.selectedUnit?.id.toString())),
              ).then((value) {
                if (value != null) {
                  onUnitSelect(userProfileBloc.selectedUnit);
                }
              });
            },);
          })
       :const SizedBox()
    );
  }
  void deleteMember(BuildContext context, int houseMemberID ) {
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
            addVehicleManagerBloc.add(DeleteMemberEvent(houseMemberId : houseMemberID.toString() , mContext: context,),);
            Navigator.of(ctx).pop();
            Navigator.of(ctx).pop();
          },
          title: AppString.deleteFamilyTitle,
          content: AppString.deleteFamilyContent,
        );
      },
    );
  }


  Widget memberList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 5),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: addVehicleManagerBloc.myFamilyListData?.members?.length ?? 0,
      itemBuilder: (context, index) {
        var member = addVehicleManagerBloc.myFamilyListData!.members![index];

        final int id = member.id!;
        return FamilyMemberCommonCardView(
          onLongPress: ()
          {
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
                    if (member.isPrimary==false)
                      CupertinoActionSheetAction(
                        onPressed: () {
                          addVehicleManagerBloc.add(OnSetPrimaryMemberEvent(
                            mContext: context, houseMemberId: addVehicleManagerBloc.myFamilyListData!.members![index].houseMemberId,
                          ));
                          Navigator.of(context).pop();
                          selectedVehicleId = null; // Reset selected member ID on cancel
                        },
                        child:   const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.person_fill,
                                color: Colors.black,size: 20,),
                              SizedBox(width: 10),
                              Text(
                                AppString.setPrimaryMember,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ]
                      ),),



                    CupertinoActionSheetAction(
                      onPressed: () {
                        addVehicleManagerBloc
                            .add(OnEnableDisableContactEvent(
                          mContext: context,
                          isDisableContact:
                          member.isPublicContact!,
                          houseMemberId: addVehicleManagerBloc
                              .myFamilyListData!
                              .members![index]
                              .houseMemberId, itsMe: addVehicleManagerBloc
                            .myFamilyListData!
                            .members![index].itsMe??false
                        ));
                        Navigator.of(context).pop();
                        selectedVehicleId =
                        null; // Reset selected member ID on cancel
                        isPrimaryMemberSet = true;
                      },
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            member.isPublicContact!
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            color: Colors.black,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            member.isPublicContact!
                                ? AppString.disableContactDetailLabel
                                : AppString.enableContactDetailLabel,
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
                        if (houseMemberId != null) deleteMember(context, houseMemberId!);
                        selectedVehicleId = null; // Reset selected member ID on cancel
                      },
                      isDestructiveAction: true, // Makes text red for delete action
                      child: const Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.delete,size:  20,
                              color:
                              CupertinoColors.destructiveRed),
                          SizedBox(width: 10),
                          Text(AppString.delete, style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),),
                        ],
                      ),
                    ),



                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      setState(() {
                        selectedVehicleId =null;
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
              isShowDeleteIcon = AppPermission.instance.canPermission(
                  AppString.familyDelete,
                  context: context) ? true : false ;
              houseMemberId = member.houseMemberId ;
              selectedVehicleId = member.houseMemberId ;
            });

            // projectUtil.vibrationOnLongClick();

          },

          onTab: () {
            setState(() {
              selectedVehicleId = null; // Reset on tap
              isShowDeleteIcon = false ;
            });
          },


          imageUrl: member.profilePhoto ?? "",
          userName: member.name ?? "Unknown",
          jobTitle: member.shortDescription ?? "No description available",
          isPrimary: member.isPrimary,
          isPublicContact: member.isPublicContact!,

          cardColor: selectedVehicleId ==member.houseMemberId
              ?Colors.blue.shade100  // Change color if selected
              : Colors.white,

        );
      },
    );
  }

 Widget getDateScreen(state) {
   // double height = MediaQuery.of(context).size.height / 1.5;
   // if (state is AddVehicleManagerLoadingState) {
   //   return WorkplaceWidgets.progressLoader(context);
   // }

   /// Selected Unit not Active
   if(userProfileBloc.selectedUnit != null && userProfileBloc.selectedUnit!.status!="active") {
     return SizedBox(
         // height: height,
         child:  Center(
             child: Padding(
               padding: const EdgeInsets.all(8.0).copyWith(left: 20,right: 20),
               child: Text(
                 textAlign: TextAlign.center,
                 AppString.joinHouseRequest
                 , style: appStyles.noDataTextStyle(),),
             )));
   }

   else if(addVehicleManagerBloc.members.isNotEmpty ==
            true){
     return memberList();
    }

   else if(state is SetPrimaryMemberLoadingState || state is  AddVehicleManagerLoadingState ||
   state is EnableDisableContactLoadingState){
     return const SizedBox();
   }
    else{
     return  Center(
       child: SizedBox(
         height: MediaQuery.of(context).size.height / 1.3,
         child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               const SizedBox(height: 10),
               Text(
                 AppString.noMembersFound,
                 textAlign: TextAlign.center,
                 style: appTextStyle.appNormalSmallTextStyle(fontSize: 16),
               ),
               const SizedBox(height: 10),
             ],
           ),
         ),
       ),
     );


       // NoMemberInUnitsErrorScreen(onAddMemberClicked: (){
       // Navigator.push(
       //   context,
       //   MaterialPageRoute(
       //     builder: (context) => AddFamilyPhoneVerifyScreen(
       //       houseId: userProfileBloc.selectedUnit?.id.toString() ?? '',
       //     ),
       //   ),
       // ).then((value) {
       //   if (value != null) {
       //     onUnitSelect(userProfileBloc.selectedUnit);
       //   }
       // });});
    }
  }


  void onUnitSelect(Houses? house) {
    if(house!=null){
      userProfileBloc.add(OnChangeCurrentUnitEvent(selectedUnit: house));
      if(house.status=="active"){
        addVehicleManagerBloc.add(OnGetMyFamilyList(mContext: context, houseId:  house.id.toString()?? '' ));
      }
      else
      {
        /// Reset the member list if
        addVehicleManagerBloc.members = [];
        addVehicleManagerBloc.add(OnReLoadUiEvent(mContext: context));
      }
    }

  }
}
