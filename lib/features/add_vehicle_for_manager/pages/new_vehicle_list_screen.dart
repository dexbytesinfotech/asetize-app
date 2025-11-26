import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/util/app_permission.dart';
import '../../../imports.dart';
import '../../my_vehicle/bloc/my_vehicle_bloc.dart';
import '../../my_vehicle/bloc/my_vehicle_event.dart';
import '../../my_vehicle/bloc/my_vehicle_state.dart';
import '../bloc/add_vehicle_manager_bloc.dart';
import '../bloc/add_vehicle_manager_event.dart';
import '../bloc/add_vehicle_manager_state.dart';
import '../widgets/vehicle_card_widget.dart';

class NewVehicleListScreen extends StatefulWidget {
  final String? houseId;

  const NewVehicleListScreen({super.key, this.houseId});

  @override
  State<NewVehicleListScreen> createState() => NewVehicleListScreenState();
}

class NewVehicleListScreenState extends State<NewVehicleListScreen> {
  late AddVehicleManagerBloc addVehicleManagerBloc;
  late MyVehicleListBloc myVehicleListBloc;
  bool isShowLoader = true;
  static String? currentHouseId;
  int? vehicleId;
  bool isShowDeleteIcon = false;

  @override
  void initState() {
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    myVehicleListBloc = BlocProvider.of<MyVehicleListBloc>(context);

    if (currentHouseId != widget.houseId ||
        addVehicleManagerBloc.memberListData == null ||
        (addVehicleManagerBloc.memberListData != null &&
            (addVehicleManagerBloc.memberListData!.vehicles == null ||
                addVehicleManagerBloc.memberListData!.vehicles!.isEmpty))) {
      currentHouseId = widget.houseId;
      addVehicleManagerBloc.add(
          OnGetHouseDetailEvent(mContext: context, houseId: widget.houseId));
    } else {
      isShowLoader = false;
    }
    super.initState();
  }

  Widget emptyState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.3,
      child: Center(
        child: Text(
          "Please add a member first to register a vehicle",
          textAlign: TextAlign.center,
          style: appStyles.noDataTextStyle(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void deleteVehicle(BuildContext context, int vehicleID, int index) {
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
            },
            title: AppString.deleteVehicleTitle,
            content: AppString.deleteVehicleContent,
          );
        },
      );
    }

    Widget vehicleList() {
      return BlocListener<MyVehicleListBloc, MyVehicleListState>(
          bloc: myVehicleListBloc,
          listener: (context, state) {
            if (state is MyVehicleErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
            if (state is DeleteMyVehicleLoadedState) {
              addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                  mContext: context, houseId: widget.houseId));
              isShowLoader = false;
              WorkplaceWidgets.successToast('Vehicle deleted successfully',
                  durationInSeconds: 1);
            }
          },
          child: SlidableAutoCloseBehavior(
            closeWhenOpened: true,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 5),
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  addVehicleManagerBloc.memberListData?.vehicles?.length ?? 0,
              itemBuilder: (context, index) {
                var vehicleData =
                    addVehicleManagerBloc.memberListData!.vehicles![index];
                return Slidable(
                  enabled: AppPermission.instance.canPermission(
                          AppString.managerVehicleDelete,
                          context: context)
                      ? true
                      : false,
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
                          deleteVehicle(context, vehicleData.id ?? 0, index);
                        },
                        icon: Icons.delete,
                        text: AppString.delete,
                        iconColor: Colors.red,
                      ),
                    ],
                  ),
                  child: VehicleCardWidget(
                    onLongPress: () {},
                    registrationNumber: vehicleData.registrationNumber,
                    ownerName: vehicleData.ownerName,
                    vehicleType: vehicleData.vehicleType,
                    blockName: vehicleData.blockName,
                    isParkingAllotted: vehicleData.isParkingAllotted ?? 0,
                  ),
                );
              },
            ),
          ));
    }

    return BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
      listener: (context, state) {
        if (state is OnGetHouseDetailErrorState) {
          WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
        }
      },
      child: BlocBuilder<AddVehicleManagerBloc, AddVehicleManagerState>(
        builder: (context, state) {
          if (state is AddVehicleManagerInitialState) {
            addVehicleManagerBloc.add(OnGetHouseDetailEvent(
                mContext: context, houseId: widget.houseId));
          }

          // if (state is AddVehicleManagerLoadingState) {
          //   addVehicleManagerBloc.add(OnGetHouseDetailEvent(
          //       mContext: context, houseId: widget.houseId));
          // }

          if (state is AddVehicleManagerLoadingState && isShowLoader) {
            return WorkplaceWidgets.progressLoader(context);
          }
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  addVehicleManagerBloc.memberListData?.vehicles?.isEmpty ==
                          true
                      ? emptyState()
                      : vehicleList()
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
