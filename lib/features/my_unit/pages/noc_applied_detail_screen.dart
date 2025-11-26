// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:asetize/features/my_unit/pages/request_for_noc_screen.dart';
import 'package:asetize/widgets/common_detail_view_row.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../../../widgets/common_card_view.dart';
import '../../../widgets/download_button_widget.dart';
import '../../my_visitor/pages/pre_register_visitor.dart';
import '../../noc_list/bloc/noc_request_bloc.dart';
import '../../noc_list/bloc/noc_request_event.dart';
import '../../noc_list/bloc/noc_request_state.dart';
import '../bloc/my_unit_bloc.dart';
import '../widgets/common_image_view.dart';
import '../widgets/common_pdf_view.dart';

class NocAppliedDetailScreen extends StatefulWidget {
  final int id;
  final int? houseId;
  final String? title;

  const NocAppliedDetailScreen(
      {super.key, required this.id, this.title, this.houseId});

  @override
  State<NocAppliedDetailScreen> createState() => _NocAppliedDetailScreenState();
}

class _NocAppliedDetailScreenState extends State<NocAppliedDetailScreen> {
  bool isLoading = true;
  bool isShowLoader = true;
  late UserProfileBloc userProfileBloc;

  late MyUnitBloc myUnitBloc;
  Houses? selectedUnit;

  late NocRequestBloc nocRequestBloc;

  @override
  void initState() {
    super.initState();

    nocRequestBloc = BlocProvider.of<NocRequestBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    // nocRequestBloc.singalNocRequestData == null;
    nocRequestBloc.add(OnGetSingalNocRecordEvent(mContext: context, id: widget.id));
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }

  Future<void> refreshDataOnNotificationComes() async {
    isShowLoader = false;
    nocRequestBloc.add(OnGetSingalNocRecordEvent(mContext: context, id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
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
              myUnitBloc.add(
                OnDeleteRequestForNOCEvent(
                  id: vehicleID,
                  mContext: context,
                ), // Use the correct property for vehicle ID
              );
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            title: AppString.deleteNocRequestTitle,
            content: AppString.deleteNocRequestMessage,
          );
        },
      );
    }

    Widget downloadNOCReport(String? nocFile) {
      if (nocFile == null || nocFile.isEmpty) {
        return const SizedBox.shrink();
      }
      bool isPdf = nocFile.toLowerCase().endsWith('.pdf');
      return DownloadButtonWidget(
        margin: EdgeInsets.symmetric(horizontal: 21),
        borderRadius: 4,
        buttonName: "Download NOC Report",
        onTapCallBack: () {
          if (isPdf) {
            Navigator.push(
              context,
              SlideLeftRoute(
                widget: PdfCommonViewPage(
                    pdfUrl: nocFile,
                    title: nocRequestBloc.singalNocRequestData?.title,
                    subTitle: AppString.nocReport),
              ),
            );
          } else {
            Navigator.push(
              context,
              SlideLeftRoute(
                widget: ImageViewPage(
                    imageUrl: nocFile,
                    title: nocRequestBloc.singalNocRequestData?.title,
                    subTitle: AppString.nocReport),
              ),
            );
          }
        },
      );
    }

    void cancelRequest(BuildContext context, int entryId) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return WorkplaceWidgets.titleContentPopup(
            buttonName1: AppString.yes,
            buttonName2: AppString.no,
            onPressedButton2TextColor: AppColors.black,
            onPressedButton1TextColor: AppColors.white,
            onPressedButton2Color: Colors.grey.shade200,
            onPressedButton1Color: Colors.red,
            onPressedButton2: () {
              Navigator.pop(context);
            },
            onPressedButton1: () async {
              myUnitBloc.add(
                OnCancelVisitorPassEvent(
                  id: entryId,
                  mContext: context,
                ),
              );
              Navigator.of(ctx).pop();
            },
            title: AppString.cancelVisitorPass,
            content: AppString.cancelVisitorPassContent,
          );
        },
      );
    }

    Widget createVisitorPassButton(purpose) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
        child: AppButton(
          buttonHeight: 45,
          buttonName: AppString.createVisitorPass,
          buttonColor: AppColors.textBlueColor,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          backCallback: () {
            Navigator.pushReplacement(
                context,
                SlideLeftRoute(
                  widget: PreRegisterVisitorForm(
                    houseId: widget.houseId ?? userProfileBloc.selectedUnit?.id,
                    nocId: widget.id,
                    visitorEntryId: 0,
                    isBottomSheetDisable: false,
                    selectHouseNumber:
                        nocRequestBloc.singalNocRequestData?.title,
                    isComingFromNoc: true,
                    visitorName:
                        '${nocRequestBloc.singalNocRequestData?.firstName ?? ''} ${nocRequestBloc.singalNocRequestData?.lastName ?? ''}',
                    visitorType:
                        nocRequestBloc.singalNocRequestData?.visitorType,
                    visitPurpose: nocRequestBloc
                        .singalNocRequestData?.visitorTypePurposes,
                    visitorNumber: nocRequestBloc.singalNocRequestData?.phone,
                  ),
                ));
          },
        ),
      );
    }

    Widget updateVisitorPass(purpose) {
      return BlocBuilder<MyUnitBloc, MyUnitState>(
        bloc: myUnitBloc,
        builder: (context, state) {
          return Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
            child: AppButton(
              buttonHeight: 45,
              isLoader:
                  state is CreatedVisitorPassDetailLoadingState ? true : false,
              buttonName: AppString.updateVisitorPass,
              buttonColor: AppColors.textBlueColor,
              textStyle: appStyles.buttonTextStyle1(
                texColor: AppColors.white,
              ),
              backCallback: () {
                myUnitBloc.add(OnGetCreatedVisitorPassDetailEvent(
                  mContext: context,
                  visitorEntryId:
                      nocRequestBloc.singalNocRequestData?.visitorEntryId,
                ));

                // Navigator.pushReplacement(
                //     context,
                //     SlideLeftRoute(
                //       widget: PreRegisterVisitorForm(
                //         houseId: widget.houseId,
                //         nocId: widget.id,
                //         visitorEntryId:  nocRequestBloc.singalNocRequestData?.visitorEntryId,
                //         isBottomSheetDisable: false,
                //         selectHouseNumber:
                //         nocRequestBloc.singalNocRequestData?.title,
                //         isComingFromNoc: true,
                //         visitorName:
                //         '${nocRequestBloc.singalNocRequestData?.firstName ?? ''} ${nocRequestBloc.singalNocRequestData?.lastName ?? ''}',
                //         visitorType:
                //         nocRequestBloc.singalNocRequestData?.visitorType,
                //         visitPurpose: nocRequestBloc
                //             .singalNocRequestData?.visitorTypePurposes,
                //         visitorNumber: nocRequestBloc.singalNocRequestData?.phone,
                //       ),
                //     ));
              },
            ),
          );
        },
      );
    }

    Widget cancelVisitorPass() {
      return GestureDetector(
        onTap: () {
          cancelRequest(context,
              nocRequestBloc.singalNocRequestData?.visitorEntryId ?? 0);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                AppString.cancelVisitorPass,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textBlueColor,
                  color: AppColors.textBlueColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget titleText(title) {
      return Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 12),
        child: Text(
          title,
          style: appTextStyle.appTitleStyle2(
              fontSize: 18, fontWeight: FontWeight.w700),
        ),
      );
    }

    Widget nocDetailCard(String purpose, Color statusColor, String status) {
      String? contactNumberForOnwerTenant;
      String? contactNumberForBroker;
      if (nocRequestBloc.singalNocRequestData != null) {
         contactNumberForOnwerTenant =
            projectUtil.formatPhoneNumberWithCountryCode(
          countryCode: nocRequestBloc.singalNocRequestData!
              .countryCode!, // or from dynamic user input or data
          phoneNumber: nocRequestBloc.singalNocRequestData!.phone!,
        );
      }
      if (nocRequestBloc.singalNocRequestData != null) {
         contactNumberForBroker =
            projectUtil.formatPhoneNumberWithCountryCode(
          countryCode: nocRequestBloc.singalNocRequestData?.broker?.countryCode ?? "", // or from dynamic user input or data
          phoneNumber: nocRequestBloc.singalNocRequestData?.broker?.phone ?? '',
        );
      }

      return CommonCardView(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
            .copyWith(top: 10),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText('Owner Details'),
              if ((nocRequestBloc.singalNocRequestData?.requestedBy ?? '')
                  .trim()
                  .isNotEmpty)
                CommonDetailViewRow(
                    title: "Owner Name",
                    icons: CupertinoIcons.person_alt_circle,
                    value:
                        nocRequestBloc.singalNocRequestData?.requestedBy ?? ''),
              if ((nocRequestBloc.singalNocRequestData?.title ?? '')
                  .trim()
                  .isNotEmpty)
                CommonDetailViewRow(
                    title: AppString.sellerHouseNumber,
                    value: nocRequestBloc.singalNocRequestData?.title ?? ''),
              Divider(
                height: 0,
                thickness: 0.35,
              ),
              if (purpose == 'Sale of Property') ...[
                titleText('Buyer Details'),
                if ((nocRequestBloc.singalNocRequestData?.firstName ?? '')
                        .trim()
                        .isNotEmpty ||
                    (nocRequestBloc.singalNocRequestData?.lastName ?? '')
                        .trim()
                        .isNotEmpty)
                  CommonDetailViewRow(
                      title: AppString.buyerName,
                      value:
                          '${projectUtil.capitalize(nocRequestBloc.singalNocRequestData?.firstName ?? "")} ${projectUtil.capitalize(nocRequestBloc.singalNocRequestData?.lastName ?? "")}',
                      isShowBt: true,
                      number: contactNumberForOnwerTenant ?? "",
                      icons: CupertinoIcons.person_alt_circle),
                if ((nocRequestBloc.singalNocRequestData?.address ?? '')
                    .trim()
                    .isNotEmpty)
                  CommonDetailViewRow(
                      title: AppString.buyerAddress,
                      value:
                          nocRequestBloc.singalNocRequestData?.address ?? ""),
                Divider(
                  height: 0,
                  thickness: 0.35,
                ),
              ] else if (purpose == 'Rental Agreement') ...[
                titleText('Tenant Details'),
                if ((nocRequestBloc.singalNocRequestData?.firstName ?? '')
                        .trim()
                        .isNotEmpty ||
                    (nocRequestBloc.singalNocRequestData?.lastName ?? '')
                        .trim()
                        .isNotEmpty)
                  CommonDetailViewRow(
                      title: AppString.tenantName,
                      value:
                          '${projectUtil.capitalize(nocRequestBloc.singalNocRequestData?.firstName ?? "")} ${projectUtil.capitalize(nocRequestBloc.singalNocRequestData?.lastName ?? "")}',
                      isShowBt: true,
                      number: contactNumberForOnwerTenant ?? "",
                      icons: CupertinoIcons.person_alt_circle),
                if ((nocRequestBloc.singalNocRequestData?.address ?? '')
                    .trim()
                    .isNotEmpty)
                  CommonDetailViewRow(
                      title: AppString.tenantAddress,
                      value:
                          nocRequestBloc.singalNocRequestData?.address ?? ""),
                if (nocRequestBloc
                        .singalNocRequestData?.isCompletedPoliceVerification !=
                    null)
                  CommonDetailViewRow(
                    icons: CupertinoIcons.person_alt_circle,
                    title: AppString.policeVerificationStatus,
                    isShowStatus: true,
                    value: (nocRequestBloc.singalNocRequestData
                                    ?.isCompletedPoliceVerification ==
                                true ||
                            nocRequestBloc.singalNocRequestData
                                    ?.isCompletedPoliceVerification ==
                                '1')
                        ? 'Completed'
                        : 'Pending',
                  ),
                Divider(
                  height: 0,
                  thickness: 0.35,
                ),
              ],
              titleText('Request Details'),
              CommonDetailViewRow(
                  title: AppString.purpose,
                  value: purpose,
                  icons: CupertinoIcons.doc_text),
              if ((nocRequestBloc.singalNocRequestData?.broker?.name ?? '')
                  .trim()
                  .isNotEmpty)
                CommonDetailViewRow(
                    title: AppString.brokerNameKey,
                    value:
                        nocRequestBloc.singalNocRequestData?.broker?.name ?? '',
                    number: contactNumberForBroker ?? '',
                    isShowBt: true,
                    icons: CupertinoIcons.person_alt_circle),
              if ((nocRequestBloc.singalNocRequestData?.title ?? '')
                      .trim()
                      .isNotEmpty &&
                  nocRequestBloc.singalNocRequestData?.firstName == "")
                CommonDetailViewRow(
                    title: AppString.houseNumber,
                    value: nocRequestBloc.singalNocRequestData?.title ?? '',
                    icons: CupertinoIcons.person_alt_circle),
              if ((nocRequestBloc.singalNocRequestData?.createdAt ?? '')
                  .trim()
                  .isNotEmpty)
                CommonDetailViewRow(
                    title: AppString.submissionDate,
                    value: nocRequestBloc.singalNocRequestData?.createdAt ?? '',
                    icons: Icons.calendar_month),
              if ((nocRequestBloc.singalNocRequestData?.issueDate ?? '')
                  .trim()
                  .isNotEmpty)
                CommonDetailViewRow(
                    title: AppString.approvedDate,
                    value: nocRequestBloc.singalNocRequestData?.issueDate ?? '',
                    icons: Icons.calendar_month),
              if ((nocRequestBloc.singalNocRequestData?.approvedBy ?? '')
                  .trim()
                  .isNotEmpty)
                CommonDetailViewRow(
                    title: nocRequestBloc.singalNocRequestData?.status
                                ?.toLowerCase() ==
                            'rejected'
                        ? AppString.rejectedBy
                        : AppString.approvedBy,
                    value:
                        nocRequestBloc.singalNocRequestData?.approvedBy ?? '',
                    icons: CupertinoIcons.person_alt_circle),
              if ((nocRequestBloc.singalNocRequestData?.remarks ?? '')
                  .trim()
                  .isNotEmpty)
                CommonDetailViewRow(
                    title: AppString.remarks,
                    value: nocRequestBloc.singalNocRequestData?.remarks ?? '',
                    icons: CupertinoIcons.text_bubble),
            ],
          ),
        ),
      );
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WorkplaceIcons.iconImage(
                        imageUrl: WorkplaceIcons.editIcon,
                        imageColor: AppColors.black,
                        iconSize: const Size(25, 25)),
                    const SizedBox(width: 10),
                    const Text(
                      AppString.editNOCRequest,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<MyUnitBloc, MyUnitState>(
                bloc: myUnitBloc,
                builder: (context, state) {
                  return CupertinoActionSheetAction(
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
                  );
                },
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

    Widget topStatusCard(status, purpose) {
      return CommonCardView(
          cardColor: _getStatusColor(status).safeOpacity(0.02),
          elevation: 1.5,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ).copyWith(top: 5),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: _getStatusColor(status).safeOpacity(0.2),
                        shape: BoxShape.circle),
                    child: Icon(
                      CupertinoIcons.doc_text,
                      size: 18,
                      color: Colors.black,
                    )),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$status",
                        style: appTextStyle.appTitleStyle2(
                            fontWeight: FontWeight.w500),
                      ),
                      Text("NOC Request for $purpose",
                          style: appTextStyle.appSubTitleStyle2(
                              color: Colors.grey.shade700)),
                      if (nocRequestBloc.singalNocRequestData
                              ?.remarkForRejection?.isNotEmpty ??
                          false)
                        Text(
                          nocRequestBloc
                                  .singalNocRequestData?.remarkForRejection ??
                              '',
                          style: appTextStyle.appSubTitleStyle2(
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ));
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      bottomSafeArea: true,
      appBarHeight: 56,
      appBar: BlocBuilder<NocRequestBloc, NocRequestState>(
        bloc: nocRequestBloc,
        builder: (context1, state) {
          final currentStatus =
              nocRequestBloc.singalNocRequestData?.status?.toLowerCase() ?? "";
          return CommonAppBar(
            title: AppString.nocTitleFor(
              nocRequestBloc.singalNocRequestData?.title ?? '',
              nocRequestBloc.singalNocRequestData?.status?.toLowerCase(),
            ),
            icon: WorkplaceIcons.backArrow,
            action: (currentStatus == "pending")
                ? IconButton(
                    padding: const EdgeInsets.only(left: 20),
                    onPressed: () {
                      showOptionsPopup(
                        context: context,
                        onEdit: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            SlideLeftRoute(
                              widget: RequestForNocScreen(
                                nocEditData:
                                    nocRequestBloc.singalNocRequestData,
                              ),
                            ),
                          ).then((value) {
                            if (value == true) {
                              nocRequestBloc.add(OnGetSingalNocRecordEvent(
                                  mContext: context, id: widget.id));
                              setState(() {
                                isShowLoader = false;
                              });
                            }
                          });
                          // Handle edit action here
                        },
                        onDelete: () {
                          deleteNocRequest(context,
                              nocRequestBloc.singalNocRequestData?.id ?? 0);
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
          );
        },
      ),
      containChild: BlocListener<MyUnitBloc, MyUnitState>(
        bloc: myUnitBloc,
        listener: (context, state) {
          if (state is DeleteRequestForNOCDoneState) {
            WorkplaceWidgets.successToast(state.message);
            Navigator.pop(context, true);
            // Navigator.pop(context, true);
          }
          if (state is CancelVisitorPassDoneState) {
            WorkplaceWidgets.successToast(AppString.canceledSuccessfully);
            Navigator.pop(context, true);
            // Navigator.pop(context, true);
          }
          if (state is CreatedVisitorPassDetailErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is CreatedVisitorPassDetailDoneState) {
            Navigator.pushReplacement(
                context,
                SlideLeftRoute(
                  widget: PreRegisterVisitorForm(
                    createdVisitorPassDetailData:
                        myUnitBloc.createdVisitorPassDetailData,
                    isComingFromNoc: true,
                    isBottomSheetDisable: false,
                    isShowContactList: false,

                    // houseId: widget.houseId,
                    // nocId: widget.id,
                    // visitorEntryId:  nocRequestBloc.singalNocRequestData?.visitorEntryId,
                    // isBottomSheetDisable: false,
                    // selectHouseNumber:
                    // nocRequestBloc.singalNocRequestData?.title,
                    // isComingFromNoc: true,

                    visitorName:
                        '${nocRequestBloc.singalNocRequestData?.firstName ?? ''} ${nocRequestBloc.singalNocRequestData?.lastName ?? ''}',
                    // visitorType:
                    // nocRequestBloc.singalNocRequestData?.visitorType,
                    // visitPurpose: nocRequestBloc
                    //     .singalNocRequestData?.visitorTypePurposes,
                    visitorNumber: nocRequestBloc.singalNocRequestData?.phone,
                  ),
                ));

            // WorkplaceWidgets.successToast(state.message);
            // Navigator.pop(context, true);
          }
        },
        child: BlocListener<NocRequestBloc, NocRequestState>(
          bloc: nocRequestBloc,
          listener: (context, state) {
            if (state is SingalNocRecordErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            if (state is DeleteRequestForNOCErrorState) {
              WorkplaceWidgets.errorSnackBar(
                  context, (state as dynamic).errorMessage);
            }
            if (state is SingalNocRecordDoneState) {}
          },
          child: BlocBuilder<NocRequestBloc, NocRequestState>(
            bloc: nocRequestBloc,
            builder: (BuildContext context, state) {
              final rawStatus =
                  nocRequestBloc.singalNocRequestData?.status ?? '';
              final status = rawStatus.isNotEmpty
                  ? rawStatus
                      .replaceAll('_', ' ')
                      .split(' ')
                      .map((word) => word.isNotEmpty
                          ? word[0].toUpperCase() +
                              word.substring(1).toLowerCase()
                          : '')
                      .join(' ')
                  : '';
              final statusColor = _getStatusColor(status);
              final purpose =
                  nocRequestBloc.singalNocRequestData?.purpose ?? '';
              return SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    if (isShowLoader == false ||
                        (state is! SingalNocRecordLoadingState &&
                            isShowLoader == true))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          topStatusCard(status, purpose),
                          nocDetailCard(purpose, statusColor, status),
                          if (nocRequestBloc.singalNocRequestData?.status ==
                                  "issued" &&
                              nocRequestBloc.singalNocRequestData?.nocFile !=
                                  null)
                            downloadNOCReport(
                                nocRequestBloc.singalNocRequestData?.nocFile),
                          if ((nocRequestBloc.singalNocRequestData?.status ==
                                      "issued" ||
                                  nocRequestBloc.singalNocRequestData?.status ==
                                      "approved") &&
                              nocRequestBloc.singalNocRequestData
                                      ?.visitorEntryStatus ==
                                  "" &&
                              nocRequestBloc.singalNocRequestData?.purpose!
                                      .toLowerCase() !=
                                  "sale of property")
                            createVisitorPassButton(purpose),
                          if (nocRequestBloc.singalNocRequestData
                                      ?.isEntryPassCreated ==
                                  true &&
                              nocRequestBloc
                                      .singalNocRequestData?.visitorEntryStatus
                                      ?.toLowerCase() ==
                                  "pre-approved" &&
                              (nocRequestBloc.singalNocRequestData
                                          ?.visitorEntryId !=
                                      null ||
                                  nocRequestBloc.singalNocRequestData
                                          ?.visitorEntryId !=
                                      0))
                            updateVisitorPass(purpose),
                          if (nocRequestBloc.singalNocRequestData
                                      ?.isEntryPassCreated ==
                                  true &&
                              nocRequestBloc
                                      .singalNocRequestData?.visitorEntryStatus
                                      ?.toLowerCase() ==
                                  "pre-approved" &&
                              (nocRequestBloc.singalNocRequestData
                                          ?.visitorEntryId !=
                                      null ||
                                  nocRequestBloc.singalNocRequestData
                                          ?.visitorEntryId !=
                                      0))
                            cancelVisitorPass(),
                          if (nocRequestBloc.singalNocRequestData
                                      ?.isEntryPassCreated ==
                                  true &&
                              (nocRequestBloc.singalNocRequestData
                                          ?.visitorEntryStatus
                                          ?.toLowerCase() !=
                                      "pre-approved" &&
                                  nocRequestBloc.singalNocRequestData
                                          ?.visitorEntryStatus
                                          ?.toLowerCase() !=
                                      ""))
                            Center(
                              child: Text(
                                "You are a visitor already ${nocRequestBloc.singalNocRequestData?.visitorEntryStatus?.toLowerCase()}.",
                                textAlign: TextAlign.center,
                                style: appStyles.textFieldTextStyle(
                                  fontWeight: FontWeight.w400,
                                  texColor: AppColors.textBlueColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    if ((state is SingalNocRecordLoadingState ||
                            state is DeleteRequestForNOCLoadingState) ||
                        state is CancelVisitorPassLoadingState && isShowLoader)
                      Center(
                        child: WorkplaceWidgets.progressLoader(context),
                      ),
                    // if (state is SingalNocRecordLoadingState || state is  DeleteRequestForNOCLoadingState && isShowLoader)
                    //   Center(
                    //     child: WorkplaceWidgets.progressLoader(context),
                    //   ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'rejected':
      return Colors.red;
    case 'approved':
      return Colors.green;
    case 'submitted':
      return Colors.green;
    case 'cancelled':
      return Colors.grey;
    case 'issued':
      return Colors.green;
    case 'completed':
      return Colors.green;
    default:
      return Colors.black12;
  }
}
