import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:asetize/features/noc_list/bloc/noc_request_event.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../../../widgets/download_button_widget.dart';
import '../../my_unit/widgets/common_image_view.dart';
import '../../my_unit/widgets/common_pdf_view.dart';
import '../bloc/noc_request_bloc.dart';
import '../bloc/noc_request_state.dart';
import '../models/noc_request_model.dart';
import '../widgets/noc_request_detail_card.dart';

class NocRequestDetailScreen extends StatefulWidget {
  final NocRequestData nocRequestData;

  const NocRequestDetailScreen({super.key, required this.nocRequestData});

  @override
  State<NocRequestDetailScreen> createState() => _NocRequestDetailScreenState();
}

class _NocRequestDetailScreenState extends State<NocRequestDetailScreen> {
  late NocRequestBloc nocRequestBloc;
  File? selectedFile;
  String? selectedFilePath;
  String? selectedFileType;
  bool isShowLoader = true;

  @override
  void initState() {
    nocRequestBloc = BlocProvider.of<NocRequestBloc>(context);
    nocRequestBloc.singalNocRequestData = null;
    nocRequestBloc.nocRequestData.clear();
    nocRequestBloc.add(OnGetSingalNocRecordEvent(mContext: context, id: widget.nocRequestData.id));
    super.initState();
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }

  Future<void> refreshDataOnNotificationComes() async {
    isShowLoader = false;
    nocRequestBloc.add(OnGetSingalNocRecordEvent(mContext: context, id: widget.nocRequestData.id));
  }


  Future<void> pickFile(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text(
          AppString.selectNOC,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            child: const Text(AppString.camera,
                style: TextStyle(color: Colors.black)),
            onPressed: () async {
              final picked =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (picked != null) {
                if (!mounted) return;
                setState(() {
                  selectedFile = File(picked.path);
                  selectedFilePath = picked.path;
                  selectedFileType = "image";
                });
                Navigator.pop(context);
                // Navigate to ImageViewPage with fromFilePicker: true
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    widget: ImageViewPage(
                      imageUrl: selectedFilePath!,
                      title: 'Image Preview',
                      subTitle: AppString.nocReport,
                      fromFilePicker: true, // Use existing AppBar logic
                    ),
                  ),
                ).then((result) {
                  // Handle the result from ImageViewPage (e.g., uploaded file path)
                  if (result != null && selectedFile!.existsSync()) {
                    nocRequestBloc.add(
                      OnNOCReportUploadEvent(
                        mContext: context,
                        id: widget.nocRequestData.id ?? 0,
                        filePath: selectedFilePath!,
                      ),
                    );
                  }
                });
              }
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(AppString.gallery,
                style: TextStyle(color: Colors.black)),
            onPressed: () async {
              final picked =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (picked != null) {
                if (!mounted) return;
                setState(() {
                  selectedFile = File(picked.path);
                  selectedFilePath = picked.path;
                  selectedFileType = "image";
                });
                Navigator.pop(context);
                // Navigate to ImageViewPage with fromFilePicker: true
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    widget: ImageViewPage(
                      imageUrl: selectedFilePath!,
                      title: 'Image Preview',
                      subTitle: AppString.nocReport,
                      fromFilePicker: true, // Use existing AppBar logic
                    ),
                  ),
                ).then((result) {
                  if (result != null && selectedFile!.existsSync()) {
                    nocRequestBloc.add(
                      OnNOCReportUploadEvent(
                        mContext: context,
                        id: widget.nocRequestData.id ?? 0,
                        filePath: selectedFilePath!,
                      ),
                    );
                  }
                });
              }
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(AppString.uploadPDF,
                style: TextStyle(color: Colors.black)),
            onPressed: () async {
              try {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );
                if (result != null && result.files.single.path != null) {
                  final file = File(result.files.single.path!);
                  if (await file.exists()) {
                    if (!mounted) return;
                    setState(() {
                      selectedFile = file;
                      selectedFilePath = result.files.single.path!;
                      selectedFileType = "pdf";
                    });
                    Navigator.pop(context);
                    // Navigate to PdfCommonViewPage with fromFilePicker: true
                    Navigator.push(
                      context,
                      SlideLeftRoute(
                        widget: PdfCommonViewPage(
                          pdfUrl: selectedFilePath!,
                          title: 'PDF Preview',
                          subTitle: AppString.nocReport,
                          fromFilePicker: true, // Use existing AppBar logic
                        ),
                      ),
                    ).then((result) {
                      if (result != null && selectedFile!.existsSync()) {
                        nocRequestBloc.add(
                          OnNOCReportUploadEvent(
                            mContext: context,
                            id: widget.nocRequestData.id ?? 0,
                            filePath: selectedFilePath!,
                          ),
                        );
                      }
                    });
                  } else {
                    WorkplaceWidgets.errorSnackBar(context, "Invalid PDF file");
                  }
                }
              } catch (e) {
                WorkplaceWidgets.errorSnackBar(
                    context, "Error picking PDF: $e");
              }
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppString.cancel,
              style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  void callIssuedStatusApi() {
    if (selectedFilePath != null) {
      nocRequestBloc.add(
        OnNOCReportUploadEvent(
          mContext: context,
          id: widget.nocRequestData.id,
          filePath: selectedFilePath!,
        ),
      );
    }
  }

  void showStatusChangeSheet(BuildContext context) {
    final currentStatus =
        nocRequestBloc.singalNocRequestData?.status?.toLowerCase() ?? "";
    List<String> statuses = [];

    // Define statuses based on current status
    if (currentStatus == "pending") {
      statuses = ["approved", "rejected"];
    } else if (currentStatus == "approved") {
      // Directly call pickFile for approved status
      pickFile(context);
      return; // Exit the method to avoid showing the action sheet
    }

    // Map API statuses to display-friendly names
    final statusDisplayMap = {
      "approved": "Approve",
      "rejected": "Reject",
      "issued": "Issued NOC",
    };

    if (statuses.isEmpty) return;

    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context1) {
        return CupertinoActionSheet(
          message: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              AppString.updateStatus,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          actions: statuses.map((status) {
            // Use the display-friendly name from the map
            String displayStatus = statusDisplayMap[status] ?? status;
            return CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                if (status == "rejected") {
                  // Show rejection reason dialog
                  TextEditingController commentsTextController =
                      TextEditingController();
                  WorkplaceWidgets.showRequestDialogForRejected(
                    context: context,
                    title: AppString.rejectRequestTitle,
                    content: "",
                    buttonName1: AppString.submitButton,
                    buttonName2: AppString.cancelButton,
                    disableButtonColor: Colors.redAccent.withOpacity(0.5),
                    unableButtonColor: AppColors.red,
                    textController: commentsTextController,
                    hintText: AppString.enterReasonHint,
                    maxLine: 3,
                    onPressedButton1: () {
                      if (commentsTextController.text.trim().isNotEmpty) {
                        // Dispatch the event with the rejection reason
                        nocRequestBloc.add(
                          OnUpdateNocListEvent(
                            mContext: context,
                            status: status,
                            // Original status for API ("rejected")
                            id: widget.nocRequestData.id ?? 0,
                            rejectReason: commentsTextController.text,
                            // comments: commentsTextController.text, // Pass the rejection reason
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    onPressedButton2: () {
                      Navigator.of(context).pop();
                    },
                  );
                } else {
                  // For non-rejected statuses (e.g., "approved"), dispatch the event directly
                  nocRequestBloc.add(
                    OnUpdateNocListEvent(
                      mContext: context,
                      status: status, // Original status for API
                      id: widget.nocRequestData.id ?? 0,
                    ),
                  );
                  FocusScope.of(context).unfocus();
                }
              },
              child: Text(
                displayStatus, // Show display-friendly status in UI
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
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
    Widget issuedNOCReport(String? nocFile) {
      if (nocFile == null || nocFile.isEmpty) {
        return const SizedBox.shrink();
      }

      bool isPdf = nocFile.toLowerCase().endsWith('.pdf');

      return BlocBuilder<NocRequestBloc, NocRequestState>(
        builder: (context, state) {
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
        },
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      resizeToAvoidBottomInset: false,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: BlocBuilder<NocRequestBloc, NocRequestState>(
        bloc: nocRequestBloc,
        builder: (context, state) {
          final currentStatus =
              nocRequestBloc.singalNocRequestData?.status?.toLowerCase() ?? "";
          return CommonAppBar(
            title: AppString.nOCRequestDetail,
            isThen: false,
            icon: WorkplaceIcons.backArrow,
            action: (currentStatus == "approved" ||
                    currentStatus == "pending" &&
                        AppPermission.instance.canPermission(
                            AppString.nocAction,
                            context: context))
                ? IconButton(
                    padding: const EdgeInsets.only(left: 20),
                    onPressed: () => showStatusChangeSheet(context),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                  )
                : null,
          );
        },
      ),
      containChild: BlocListener<NocRequestBloc, NocRequestState>(
        listener: (context, state) {
          if (state is UpdateNocListErrorState ||
              state is SingalNocRecordErrorState) {
            WorkplaceWidgets.errorSnackBar(
                context, (state as dynamic).errorMessage);
          }
          if (state is NOCReportUploadErrorState) {
            WorkplaceWidgets.errorSnackBar(
                context, (state as dynamic).errorMessage);
          }

          if (state is NOCReportUploadDoneState) {
            nocRequestBloc.add(OnUpdateNocListEvent(
              mContext: context,
              status: "issued",
              id: widget.nocRequestData.id ?? 0,
            ));
          }
          if (state is SingalNocRecordDoneState) {
            nocRequestBloc.add(OnGetNocListEvent(mContext: context));
          }
          if (state is UpdateNocListDoneState) {
            WorkplaceWidgets.successToast(state.message, durationInSeconds: 2);
            // nocRequestBloc.add(OnGetSingalNocRecordEvent(mContext: context, id: widget.nocRequestData.id));
            Navigator.pop(context, true);

            // nocRequestBloc.add(OnGetSingalNocRecordEvent(mContext: context, id: widget.nocRequestData.id));
          }
        },
        child: BlocBuilder<NocRequestBloc, NocRequestState>(
          builder: (context1, state) {
            if (state is SingalNocRecordDoneState) {
              // nocRequestBloc.add(OnGetNocListEvent(mContext: context));
            }
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      nocRequestBloc.singalNocRequestData != null
                          ? NocRequestDetailCard(
                              nocRequestData:
                                  nocRequestBloc.singalNocRequestData!)
                          : const SizedBox(),
                      if (nocRequestBloc.singalNocRequestData?.nocFile !=
                              null ||
                          nocRequestBloc.singalNocRequestData?.nocFile != "" &&
                              nocRequestBloc.singalNocRequestData?.status ==
                                  'issued' ||
                          nocRequestBloc.singalNocRequestData?.status ==
                              'approved')
                        issuedNOCReport(
                            nocRequestBloc.singalNocRequestData!.nocFile),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                  if (state is UpdateNocListLoadingState || state is SingalNocRecordLoadingState || state is NOCReportUploadLoadingState)
                    if(isShowLoader == true)
                    Center(child: WorkplaceWidgets.progressLoader(context)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
