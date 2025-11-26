import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../vehicle_identification_form/pages/vehicle_from_screen.dart';
import '../bloc/add_vehicle_manager_bloc.dart';
import '../bloc/add_vehicle_manager_event.dart';
import '../bloc/add_vehicle_manager_state.dart';
import '../widgets/member_card_widget.dart';
import 'add_member_phone_new_screen.dart';
import 'add_vehicle_for_manager_form_screen.dart';

class NewMemberListScreen extends StatefulWidget {
  final String? houseId;
  const NewMemberListScreen({super.key, this.houseId});

  @override
  State<NewMemberListScreen> createState() => NewMemberListScreenState();
}

class NewMemberListScreenState extends State<NewMemberListScreen> {
  late AddVehicleManagerBloc addVehicleManagerBloc;
  bool isShowLoader = true;
  static String? currentHouseId;
  int? houseMemberId;
  bool isShowDeleteIcon = false;

  @override
  void initState() {
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    if (currentHouseId != widget.houseId ||
        addVehicleManagerBloc.memberListData == null ||
        (addVehicleManagerBloc.memberListData != null &&
            (addVehicleManagerBloc.memberListData!.members == null ||
                addVehicleManagerBloc.memberListData!.members!.isEmpty))) {
      currentHouseId = widget.houseId;

      addVehicleManagerBloc.add(OnGetHouseDetailEvent(mContext: context, houseId: widget.houseId));
    } else {
      isShowLoader = false;
    }
    super.initState();
  }

  Widget emptyState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.person_add_alt_1, size: 60, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              AppString.noMembersFound,
              textAlign: TextAlign.center,
              style: appTextStyle.noDataTextStyle(),
            ),
            const SizedBox(height: 15),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       SlideLeftRoute(
            //         widget: AddMemberPhoneNumberScreen(
            //           houseId: widget.houseId,
            //         ),
            //       ),
            //     ).then((value) {
            //       if (value != null) {
            //         addVehicleManagerBloc.add(OnGetHouseDetailEvent(
            //             mContext: context, houseId: widget.houseId));
            //         setState(() {
            //           isShowLoader = false;
            //         });
            //       }
            //     });
            //   },
            //   icon: const Icon(Icons.add, size: 25, color: Colors.white),
            //   label: Text(
            //     AppString.addMember,
            //     style: appTextStyle.appNormalSmallTextStyle(
            //       color: AppColors.white,
            //     ),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     elevation: 0,
            //     backgroundColor: AppColors.textBlueColor,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void deleteMember(BuildContext context, int houseMemberID , int index) {
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
              addVehicleManagerBloc.add(DeleteMemberEvent(houseMemberId :  houseMemberID.toString() ,
                mContext: context,
              ),
              );
              Navigator.of(ctx).pop();
            },
            title: AppString.deleteMemberTitle,
            content: AppString.deleteMemberContent,
          );
        },
      );
    }

    Widget memberList() {
      return SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 5),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: addVehicleManagerBloc.memberListData?.members?.length ?? 0,
          itemBuilder: (context, index) {
            var member = addVehicleManagerBloc.memberListData!.members![index];
            return Slidable(
              enabled: AppPermission.instance
                  .canPermission(AppString.managerMemberDelete,context: context)
                  ? true  : false,
              key: UniqueKey(),
                endActionPane: ActionPane(
                  extentRatio: 0.22,
                  dragDismissible: true,
                  //openThreshold: 0.60,
                  motion: const ScrollMotion(),
                  children: [
                    WorkplaceWidgets.sliderChildren(
                      bgColor: Colors.transparent,
                      onTap: () {
                        deleteMember(context,member.houseMemberId?? 0 , index);
                      },
                      icon: Icons.delete,
                      text: AppString.delete,
                      iconColor: Colors.red,
                    ),
                  ],
                ),
                child: MemberCardWidget(
                  onLongPress: ()
                  {

                  },
                  imageUrl: member.profilePhoto ?? "",
                  title: member.name ?? "",
                  subTitle: member.shortDescription ?? "",
                  onClickCallBack: () {
                    Navigator.push(
                      context,
                      SlideLeftRoute(
                        widget:  AddVehicleForm(
                          houseId: int.parse(widget.houseId ?? ''),
                          userId: member.id,
                          ownerName: member.name,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          isShowLoader =
                              false; // Show loader before making the API call
                        });
                        addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                          mContext: context,
                          houseId: widget.houseId,
                        ));
                      }
                    });
                  },
                ));
          },
        ),
      );
    }

    return BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
      listener: (context, state) {
        if (state is OnGetHouseDetailErrorState) {

          WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
        }
        if (state is DeleteMemberErrorState) {
          WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
        }
        if(state is DeleteMemberDoneState)
          {
            addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                mContext: context, houseId: widget.houseId));
            isShowLoader = false;
            WorkplaceWidgets.successToast('Memeber deleted successfully',durationInSeconds: 1);
          }
      },
      child: BlocBuilder<AddVehicleManagerBloc, AddVehicleManagerState>(
        builder: (context, state) {
          if (state is AddVehicleManagerInitialState) {
            addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                mContext: context, houseId: widget.houseId));
          }
          if (state is AddVehicleManagerLoadingState && isShowLoader) {
            return WorkplaceWidgets.progressLoader(context);
          }
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  addVehicleManagerBloc.memberListData?.members!.isEmpty == true
                      ? emptyState()
                      : memberList()
                ],
              ),
              if (state is AddVehicleManagerLoadingState && isShowLoader)
                WorkplaceWidgets.progressLoader(context)
            ],
          );
        },
      ),
    );
  }
}
