import 'package:flutter/cupertino.dart';
import 'package:asetize/imports.dart';
import '../../../app_global_components/common_floating_add_button.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import '../../add_vehicle_for_manager/widgets/vehicle_card_widget.dart';
import '../../vehicle_identification_form/pages/vehicle_from_screen.dart';
import '../bloc/my_vehicle_bloc.dart';
import '../bloc/my_vehicle_event.dart';
import '../bloc/my_vehicle_state.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen({super.key});

  @override
  State createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen>
    with TickerProviderStateMixin {
  late MyVehicleListBloc myVehicleListBloc;
  late AddVehicleManagerBloc addVehicleManagerBloc;
  bool isShowLoader = true;
  bool isShowDeleteIcon = false;
  int? selectedVehicleId; // Add this variable to track long-pressed vehicle

  int? vehicleId;

  @override
  void initState() {
    super.initState();
    myVehicleListBloc = BlocProvider.of<MyVehicleListBloc>(context);
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    // myVehicleListBloc.add(MyVehicleEvent(mContext: context, vsync: this));
    addVehicleManagerBloc.add(OnGetBlockListEvent(mContext: context));
  }

  @override
  Widget build(BuildContext context1) {
    void deleteVehicle(BuildContext context, int vehicle) {
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
                    id: vehicle, mContext: context1),
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            title: AppString.deleteVehicleTitle,
            content: AppString.deleteVehicleContent,
          );
        },
      );
    }

    Widget buildNoVehicleContent() {
      if (AppPermission.instance
          .canPermission(AppString.vehicleAdd, context: context)) {
        // If permission is granted, show the UI for adding a vehicle.
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/no-caravoid-travelling.svg',
                height: 55,
                width: 55,
              ),
              const SizedBox(height: 30),
              Text(
                AppString.addVehiclePrompt,
                textAlign: TextAlign.center,
                style: appTextStyle.appNormalSmallTextStyle(fontSize: 16),
              ),
              // const SizedBox(height: 20),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const AddVehicleForm(),
              //       ),
              //     ).then((value) {
              //       if (value != null) {
              //         myVehicleListBloc
              //             .add(MyVehicleEvent(mContext: context, vsync: this));
              //         setState(() {
              //           isShowLoader = false;
              //         });
              //       }
              //     });
              //   },
              //   icon: const Icon(Icons.add, size: 25, color: Colors.white),
              //   label: Text(
              //     AppString.addVehicle,
              //     style: appTextStyle.appNormalSmallTextStyle(
              //       color: AppColors.white,
              //     ),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     elevation: 0,
              //     backgroundColor: AppColors.appBlueColor,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              //   ),
              // ),
              // const SizedBox(height: 50),
            ],
          ),
        );
      } else {
        // If permission is denied, show a message or fallback UI.
        return Center(
          child: Text(
            AppString.noVehicleAdded,
            style: appTextStyle.noDataTextStyle(),
          ),
        );
      }
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayAppBar: true,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar:  const CommonAppBar(
        title: AppString.myVehicles,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener(
        bloc: myVehicleListBloc,
        listener: (BuildContext context, state) {
          if (state is MyVehicleErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is DeleteMyVehicleLoadedState) {
            myVehicleListBloc
                .add(MyVehicleEvent(mContext: context1, vsync: this));
            isShowLoader = false;

            WorkplaceWidgets.successToast("Vehicle deleted successfully");
          }
        },
        child: BlocBuilder<MyVehicleListBloc, MyVehicleListState>(
          builder: (context, state) {
            if (state is MyVehicleInitialState) {
              myVehicleListBloc
                  .add(MyVehicleEvent(mContext: context, vsync: this));
            }
            if (state is DeleteMyVehicleLoadedState) {
              myVehicleListBloc.add(MyVehicleEvent(mContext: context1));
              return WorkplaceWidgets.progressLoader(context);
            }

            return Stack(
              children: [
            ListView.builder(
            shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 15, top: 60),
              itemCount: myVehicleListBloc.myVehicleListData.length,
              itemBuilder: (context, index) {
                final vehicle = myVehicleListBloc.myVehicleListData[index];
                final int id = vehicle.id!;

                return InkWell(
                  onLongPress: () async {
                      bool hasPermission = AppPermission.instance
                          .canPermission(AppString.vehicleDelete, context: context);
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.delete,
                                        size: 20,
                                        color: CupertinoColors.destructiveRed,
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
                    isParkingAllotted: vehicle.isParkingAllotted ?? 0,
                    registrationNumber: vehicle.registrationNumber,
                    ownerName: vehicle.ownerName,
                    vehicleType: vehicle.vehicleType,
                    blockName:vehicle.blockName,
                    cardColor: selectedVehicleId == id
                        ? Colors.blue.shade100 // Change color if selected
                        : Colors.white, // Default color
                  ),
                );
              },
            ),

            if (state is MyVehicleLoadingState && isShowLoader)
                  WorkplaceWidgets.progressLoader(context),
                if (state is DeleteMyVehicleLoadingState && isShowLoader)
                  WorkplaceWidgets.progressLoader(context),
                if (state is MyVehicleEmptyState) buildNoVehicleContent(),
              ],
            );

            // If data is loading, show a loading indicator
            return const SizedBox();
          },
        ),
      ),
      bottomMenuView: AppPermission.instance.canPermission(AppString.vehicleAdd,context: context)?
      CommonFloatingAddButton(onPressed: () {
        Navigator.push(
          context,
          SlideLeftRoute(
              widget:  const AddVehicleForm()),
        ).then((value) {
          if (value != null) {
            setState(() {
              isShowLoader = false;
            });
            myVehicleListBloc.add(
                MyVehicleEvent(mContext: context, vsync: this));
          }
        });
      },) :const SizedBox(),
    );
  }
}
