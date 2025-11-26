import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:asetize/core/util/app_theme/text_style.dart';
import 'package:asetize/features/my_visitor/pages/pre_register_visitor.dart';
import 'package:asetize/widgets/common_card_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../imports.dart';
import '../../../widgets/common_detail_view_row.dart';
import '../bloc/my_visitor_bloc.dart';
import '../bloc/my_visitor_event.dart';
import '../bloc/my_visitor_state.dart';
import '../models/visitor_model.dart';

class VisitorDetailScreen extends StatefulWidget {
  final bool isComingFrom;
  final bool preApprovedStatus;
  final bool isShowDeleteMenu;
  final VisitorData visitorData;const VisitorDetailScreen({super.key, required this.visitorData,    this.isComingFrom = true, this.preApprovedStatus=false, this.isShowDeleteMenu= false

  });
  @override
  State<VisitorDetailScreen> createState() => _VisitorDetailScreenState();
}

class _VisitorDetailScreenState extends State<VisitorDetailScreen> {
  late HomeBloc homeBloc;


  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
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
          content: "Do you want to allow the guard to check out this visitor?",
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
          content: "Do you want to deny the guard permission to check out this visitor?",
        );
      },
    );
  }

  String vehicleTypeImage(String? vehicleType) {
    if (vehicleType == null || vehicleType.isEmpty) {
      return WorkplaceIcons.carVehicle;
    }
    switch (vehicleType.toLowerCase()) {
      case "car":
        return WorkplaceIcons.carVehicle;
      case "bike":
        return WorkplaceIcons.bikeVehicle;
      case "scooty":
        return WorkplaceIcons.scooty;
      case "bus":
        return WorkplaceIcons.busNewIcon;
      case "e-rickshaw":
        return WorkplaceIcons.autoRickshaw;
      case "auto-rickshaw":
        return WorkplaceIcons.autoRickshaw;
      case "tempo":
        return WorkplaceIcons.vanNewIcon;
      case "van":
        return WorkplaceIcons.vanNewIcon;
      default:
        return WorkplaceIcons.carVehicle;
    }
  }

  makingPhoneCall(String phoneNumber) async {
    var url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Map<String, Color> visitorTypeColors = {






    'guest': Colors.teal,
    'visitor': Colors.teal,
    'delivery_boy': Colors.deepPurple,
    'helper': Colors.green,
    'technician': Colors.purple,
    'government_official': Colors.teal,
    'salesperson': Colors.deepPurple,
    'security_staff': Colors.brown,
    'healthcare_worker': Colors.pink,
    'contractor': Colors.amber,
    'cab_driver': Colors.indigo,
    'others': Colors.grey,
  };

  String formatStatus(String? status) {
    if (status == null || status.isEmpty) return "";

    return status
        .replaceAll('-', ' ') // Replace dashes with spaces
        .split(' ') // Split into words
        .map((word) =>
            word[0].toUpperCase() + word.substring(1)) // Capitalize each word
        .join(' '); // Join back into a sentence
  }


  void showOptionsPopup({
    required BuildContext context,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
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
              color: Colors.black87,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: onEdit,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WorkplaceIcons.iconImage(
                      imageUrl: WorkplaceIcons.editIcon,
                      imageColor: AppColors.black,
                      iconSize: const Size(25, 25)),
                  const SizedBox(width: 10),
                  const Text(
                    AppString.editVisitorDetail,
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
              onPressed: onDelete,
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
                      color: CupertinoColors.destructiveRed,
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


  @override
  Widget build(BuildContext context) {
    bool isTablet = ProjectUtil.isTablet(context);
    Size size = MediaQuery.of(context).size;
    Color visitorColor = visitorTypeColors[widget.visitorData.visitorType] ?? Colors.blue;
    String? status = widget.visitorData.status?.toLowerCase();
    final visitorPhoneNumber = projectUtil.formatPhoneNumberWithCountryCode(
      countryCode:widget.visitorData.countryCode!, // or from dynamic user input or data
      phoneNumber: widget.visitorData.phone!,
    );

    void deleteNocRequest(BuildContext context, int vehicleID) {
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
              homeBloc.add(
                OnDeleteUpComingVisitorEvent(
                  id: vehicleID,
                  mContext: context,
                ), // Use the correct property for vehicle ID
              );
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            title: AppString.deleteUpcomingVisitor,
            content: AppString.deleteUpcomingVisitorMessage,
          );
        },
      );
    }
    Widget topNameAndStatusCard(){
      return    Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.visitorData.name ?? "",
                        style: appTextStyle.appTitleStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.visitorData.status == "checked-out")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                formatStatus(widget.visitorData.status) ?? "",
                                style: appTextStyle.appNormalSmallTextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (widget.visitorData.visitorTypeName?.isNotEmpty == true)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: visitorColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.visitorData.visitorTypeName ?? "",
                        style: appTextStyle.appNormalSmallTextStyle(
                          color: visitorColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (widget.visitorData.phone?.isNotEmpty == true)
                    Container(
                      color: Colors.transparent,
                      padding:
                      const EdgeInsets.only(top: 10, bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            '${widget.visitorData.phone}',
                            style: appTextStyle.appNormalTextStyle(
                                color: Colors.black, fontSize: 16,fontWeight :FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          AppButton(
                            buttonHeight:isTablet?40: 25,
                            buttonWidth: isTablet?95:65,
                            isShowIcon: true,
                            iconSize:  Size(isTablet?20:16, isTablet?20:16),
                            icon: WorkplaceIcons.callIcon,
                            buttonName: 'Call',
                            buttonColor: AppColors.appBlueColor,
                            textStyle: appStyles.buttonTextStyle1(
                                texColor: AppColors.white,
                                fontSize: isTablet?16:14,
                                fontWeight: FontWeight.normal),
                            backCallback: () {
                              if (widget.visitorData.phone
                                  ?.isNotEmpty ==
                                  true) {
                                makingPhoneCall(
                                    widget.visitorData.phone ?? "");
                              }
                            },
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget totalVisitorsCard(){
      return  CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10).copyWith(top: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  WorkplaceIcons.iconImage(
                      imageUrl: WorkplaceIcons.groupIcon,
                      iconSize: const Size(22, 22),
                      imageColor: Colors.black.withOpacity(0.7)),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Total Visitors',
                    style: appTextStyle.appNormalTextStyle(),
                  ),
                ],
              ),
              Text(
                widget.visitorData.totalVisitors ?? "",
                style: appTextStyle.appNormalTextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    Widget purposeOfVisitorCard(){
      return CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12).copyWith(top: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  WorkplaceIcons.iconImage(
                    imageUrl: WorkplaceIcons.bagIcon,
                    iconSize: const Size(22, 22),
                    imageColor: Colors.black.withOpacity(0.7),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Purpose',
                    style: appTextStyle.appNormalTextStyle(),
                  ),
                ],
              ),
              const SizedBox(width: 14,),
              Expanded( // Ensures text fits within available space
                child: Text(
                  '${widget.visitorData.visitorTypeName} (${widget.visitorData.organization})',
                  style: appTextStyle.appNormalTextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis, // Truncates if content exceeds 3 lines
                  maxLines: 3, // Allows up to 3 lines
                  softWrap: true, // Ensures text wraps naturally
                ),
              ),
            ],
          ),
        ),

      );
    }

    Widget checkInCard(){
      return CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12).copyWith(top: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_filled,
                      color: Colors.black.withOpacity(0.7)),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                     widget.preApprovedStatus?"Check-in" : 'Visit Date' '',
                    style: appTextStyle.appNormalTextStyle(),
                  ),
                ],
              ),
              Text(
                widget.visitorData.entryTime ?? "",
                style: appTextStyle.appNormalTextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    Widget checkOutCard(){
      return  Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 4, vertical: 12)
            .copyWith(top: 6),
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color:  Colors.white,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.access_time_filled,
                    color: Colors.black.withOpacity(0.7)),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "Check-out",
                  style: appTextStyle.appNormalTextStyle(),
                ),
              ],
            ),
            Text(
              widget.visitorData.exitTime ?? "",
              style: appTextStyle.appNormalTextStyle(
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }


    Widget vehicleNumberCard(){
      return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 4, vertical: 12)
            .copyWith(top: 6),
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color:  Colors.white,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                WorkplaceIcons.iconImage(
                  imageUrl: vehicleTypeImage(
                      widget.visitorData.vehicle?.vehicleType),
                  iconSize: const Size(22, 22),
                  imageColor: Colors.black.withOpacity(0.7),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "Vehicle No.",
                  style: appTextStyle.appNormalTextStyle(),
                ),
              ],
            ),
            Text(
              widget.visitorData.vehicle?.vehicleNumber ?? "",
              style: appTextStyle.appNormalTextStyle(
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    Widget allowAndDenyButtonCard(){
      return  Row(
        children: [
          Expanded(
            child: AppButton(
                buttonHeight: 45,
                isShowIcon: true,
                iconSize: const Size(20, 20),
                icon: WorkplaceIcons.deniedIcon,
                buttonName: 'Deny',
                buttonColor:AppColors.textDarkRedColor,
                textStyle: appStyles.buttonTextStyle1(
                    texColor: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                backCallback: (){
                  visitorDeny(
                      context, widget.visitorData.houses?.first.entryHouseId ?? 0 ?? 0);

                }
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: AppButton(
                buttonHeight: 45,
                isShowIcon: true,
                iconSize: const Size(18, 18),
                icon: WorkplaceIcons.allowedIcon,
                buttonName: 'Allow',
                buttonColor: AppColors.textDarkGreenColor,
                textStyle: appStyles.buttonTextStyle1(
                    texColor: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                backCallback: (){
                  visitorCheckout(
                      context, widget.visitorData.houses?.first.entryHouseId ?? 0);

                }
            ),
          ),
        ],
      );
    }
    return ContainerFirst(

      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isListScrollingNeed: false,
      isFixedDeviceHeight: false,
      appBarHeight: 56,
      appBar:  CommonAppBar(
        title: AppString.visitingDetail,
        action: (status == "pre-approved" && widget.isShowDeleteMenu == true
        ) ? IconButton(
          padding: const EdgeInsets.only(left: 20),
          onPressed: (){
            showOptionsPopup(
              context: context,
              onEdit: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    widget:  PreRegisterVisitorForm(
                      editUpComingVisitorsData: [
                        widget.visitorData,
                      ],),
                  ),
                ).then((value) {
                  if (value == true) {
                    setState(() {
                      // isShowLoader = false;
                    });
                    // nocRequestBloc.add(OnGetSingalNocRecordEvent(mContext: context, id: widget.id));
                  }
                });
                // Handle edit action here
              },
              onDelete: () {
                deleteNocRequest(context, widget.visitorData.entryId ?? 0);
                // Navigator.of(context).pop();
                // Handle delete action here
              },
            );

          },
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
        )
            : null,
      ),
      containChild: BlocListener<HomeBloc, HomeState>(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is VisitorCheckoutDoneState) {
            Navigator.pop(context);
            if (state.status != "denied") {
              WorkplaceWidgets.successToast(AppString.visitorAllowSuccessfully);
            } else{
              WorkplaceWidgets.errorSnackBar(context, AppString.visitorDenySuccessfully);
            }
          }
          if (state is VisitorCheckoutErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is DeleteUpComingVisitorErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is DeleteUpComingVisitorDoneState) {
            WorkplaceWidgets.successToast(AppString.upcomingVisitorDeletedSuccessfully,durationInSeconds: 1);
            Navigator.pop(context, true);
          }
        },
        child: Column(
          children: [
            CommonCardView(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              // color: AppColors.white,
              child: Padding(
                padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10
                ),
                child: Column(
                  children: [
                CommonDetailViewRow(
                title: projectUtil.capitalizeFullName("Visitor Name"),
                          value: widget.visitorData.name ?? '',
                          icons:  CupertinoIcons.person_alt_circle,
                    number:  visitorPhoneNumber ?? '',
                    isShowBt: true
                        ),
                    CommonDetailViewRow(
                      title: projectUtil.capitalizeFullName("Visitor Status"),
                      value:formatStatus(widget.visitorData.status ?? '') ,
                      icons:  Icons.badge,
                    ),
                    if (widget.visitorData.totalVisitors?.isNotEmpty == true)
                    CommonDetailViewRow(
                      title: projectUtil.capitalizeFullName("Total Visitors"),
                      value:formatStatus(widget.visitorData.totalVisitors ?? '') ,
                      icons:  Icons.groups,
                    ),
                    if (widget.visitorData.visitorTypeName?.isNotEmpty == true)
                    CommonDetailViewRow(
                      title: projectUtil.capitalizeFullName("Purpose"),
                      value:formatStatus(widget.visitorData.organization,) ,
                      icons:  Icons.assignment	,
                    ),

                    if (widget.visitorData.entryTime?.isNotEmpty == true)
                    CommonDetailViewRow(
                      title: projectUtil.capitalizeFullName("Visit Date"),
                      value:formatStatus(widget.visitorData.entryTime) ,
                      icons:   Icons.calendar_month	,
                    ),

                   if (widget.visitorData.exitTime?.isNotEmpty == true)
                    CommonDetailViewRow(
                      title: projectUtil.capitalizeFullName("Check-out"),
                      value:formatStatus(widget.visitorData.exitTime) ,
                      icons:  Icons.access_time_filled	,
                    ),
                    if (widget.visitorData.vehicle?.vehicleNumber?.isNotEmpty ==
                        true)
                    CommonDetailViewRow(
                      title: projectUtil.capitalizeFullName("Vehicle Number"),
                      value:formatStatus( widget.visitorData.vehicle?.vehicleNumber ) ,
                      icons:  Icons.directions_car
                      ,
                    ),

                    // topNameAndStatusCard(),
                    // if (widget.visitorData.totalVisitors?.isNotEmpty == true)
                    //   totalVisitorsCard(),

                    // if (widget.visitorData.visitorTypeName?.isNotEmpty == true)
                    //   purposeOfVisitorCard(),
                    // if (widget.visitorData.entryTime?.isNotEmpty == true)
                    //   checkInCard(),
                    // if (widget.visitorData.exitTime?.isNotEmpty == true)
                    //   checkOutCard(),
                    // if (widget.visitorData.vehicle?.vehicleNumber?.isNotEmpty ==
                    //     true)
                    //   vehicleNumberCard(),


                  ],
                ),
              ),
            ),
            if (widget.visitorData.houses!.first.approvalStatus == "pending" && widget.isComingFrom)
              Padding(
                padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: allowAndDenyButtonCard(),
              )

          ],
        ),
      ),
    );
  }
}

