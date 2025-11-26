import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../app_global_components/common_floating_add_button.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../../imports.dart';
import '../../my_unit/bloc/my_unit_bloc.dart';
import '../bloc/add_transaction_receipt_bloc.dart';
import '../bloc/add_transaction_receipt_event.dart';
import '../bloc/add_transaction_receipt_state.dart';
import '../widget/common_transaction_receiptList_widget.dart';
import 'add_new_transaction_receipt.dart';
import 'add_transaction_form.dart';

class TransactionReceiptDetailScreen extends StatefulWidget {
  final bool isShowPayNow;
  final  bool? isDue;

  const TransactionReceiptDetailScreen({super.key, this.isShowPayNow = false,this.isDue});

  @override
  State<TransactionReceiptDetailScreen> createState() =>
      _TransactionReceiptDetailScreen();
}

class _TransactionReceiptDetailScreen
    extends State<TransactionReceiptDetailScreen> {
  late AddTransactionReceiptBloc addTransactionReceiptBloc;
  bool isPullToRefresh2 = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController scrollController = ScrollController();
  bool isLoadMore = false;
  late MyUnitBloc myUnitBloc;
  String? selectedProfilePhotoPath;
  bool isImageSelected = false;
  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  String imageErrorMessage = '';
  String recognizedText = '';
  bool isRecognizing = false;
  String? transactionId;
  String? amount;
  String? upiId;
  String? upiTransactionId;
  String? googleTransactionId;
  late TextRecognizer textRecognizer;
  File? selectedProfilePhoto;
  int? receiptID;
  bool isShowDeleteForTransactionReceipts = false;
  int? selectedReceiptID; // Add this variable to track long-pressed vehicle
  bool isShowLoader = true;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void _onScroll() {
    if (scrollController.hasClients) {
      /// Code for load more data from API
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      final triggerScroll = maxScroll * 0.5; // 50% of scrollable area
      if (currentScroll >= triggerScroll) {
        // Trigger your onLoad or any other function
        _onLoading();
      }
    }
  }
  void showNoDuesPopups(BuildContext context) {
    WorkplaceWidgets.errorPopUp(
      context: context,
      isShowIcon: true,
      // iconColor: Colors.green,
      // icon: Icons.verified, // ✅ No dues icon
      content: AppString.showNoDuesPopup,
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  void showNoDuesPopup(
      BuildContext context,
      ) {
    showDialog(
      context: context,
      builder: (ctx) => SuccessPopup(
        buttonName2: AppString.ok,
        content: AppString.showNoDuesPopup,
        onPressedButton2: () {
          Navigator.pop(context);
        },
        onPressedButton2Color: Colors.blue,
        onPressedButton2TextColor: Colors.white,
      ),
    );
  }

  void receivedANewMessage(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => SuccessPopup(
        buttonName2: AppString.ok,
        content: AppString.receiptsStatusAlertContent,
        onPressedButton2: () {
          Navigator.pop(context);
        },
        onPressedButton2Color: Colors.blue,
        onPressedButton2TextColor: Colors.white,
      ),
    );
  }


  void fetchInitialData(){
    if (addTransactionReceiptBloc.getListOfReceipts.isEmpty) {
      isShowLoader = true; // Show loader only when data is empty
    } else {
      isShowLoader = false; // No loader if data exists
    }
    addTransactionReceiptBloc.add(GetListOfReceiptsEvent(mContext: context));
  }



  void _onRefresh() async {
    print("Refresh started");
    setState(() {
      isShowLoader = false;
    });
    addTransactionReceiptBloc.setPostPageEnded = false;
    addTransactionReceiptBloc.add(GetListOfReceiptsEvent(mContext: context));
    await Future.delayed(const Duration(milliseconds: 1000)); // Simulate API
    refreshController.refreshCompleted(); // End refresh
    print("Refresh completed");
  }

  void _onLoading() async {
    // Handle pagination or infinite scrolling
    if (!addTransactionReceiptBloc.getPostPageEnded && !isLoadMore) {
      addTransactionReceiptBloc.add(GetListOfReceiptsOnLoadEvent(
        mContext: context,
      ));
      await Future.delayed(const Duration(milliseconds: 1000));
      //await Future.delayed(const Duration(seconds: 5));
    }

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);

    addTransactionReceiptBloc =
        BlocProvider.of<AddTransactionReceiptBloc>(context);
    scrollController.addListener(_onScroll);
    addTransactionReceiptBloc.setPostPageEnded = false;
    fetchInitialData();
    // _processImage(selectedProfilePhotoPath ??
    //     ''); // Automatically process the image on screen load

    super.initState();
    OneSignalNotificationsHandler.instance.refreshPage = refreshDataOnNotificationComes;
  }

  Future<void> refreshDataOnNotificationComes() async {
    _onRefresh();
  }


  @override
  void dispose() {
    refreshController.dispose();
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void deletePaymentReceipt(BuildContext context, int houseMemberID) {
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
              setState(() {
                selectedReceiptID = null; // Reset on tap
                isShowDeleteForTransactionReceipts = false;
              });
              Navigator.pop(context);
            },
            onPressedButton2: () async {
              addTransactionReceiptBloc.add(
                DeleteDuplicateEntryReceiptsEvent(
                    id: houseMemberID ?? 0, mContext: context),
              );
              setState(() {
                selectedReceiptID = null; // Reset on tap
                isShowDeleteForTransactionReceipts = false;
              });
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            title: AppString.deleteReceipt,
            content: AppString.deleteReceiptContent,
          );
        },
      );
    }

    double screenHeight =
        MediaQuery.of(context).size.height; // Get screen height
    double imageHeight =
        screenHeight * 0.22; // Set image height as 30% of the screen height

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      isOverLayAppBar: true,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.paymentScreenshots,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild:
          BlocListener<AddTransactionReceiptBloc, AddTransactionReceiptState>(
        bloc: addTransactionReceiptBloc,
        listener: (context, state) {
          if (state is AddTransactionReceiptErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.message);
          }
          if (state is DeleteDuplicateEntryReceiptsDoneState) {
            WorkplaceWidgets.successToast(AppString.receiptDeletedSuccessfully,durationInSeconds: 1);
          }
          if (state is DeleteDuplicateEntryReceiptsErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.message);
          }
          if (state is AddTransactionReceiptOnLoadingState) {
            setState(() {
              isLoadMore = true;
            });
          }
          if (state is getListOfReceiptsDoneState) {
            setState(() {
              isLoadMore = false;
            });
            _refreshController.refreshCompleted(); // Notify success
            _refreshController.loadComplete(); // Notify
          }
        },
        child:
            BlocBuilder<AddTransactionReceiptBloc, AddTransactionReceiptState>(
          bloc: addTransactionReceiptBloc,
          builder: (context, state) {
            if (state is AddTransactionReceiptLoadingState && isShowLoader) {
              return WorkplaceWidgets.progressLoader(context);
            }

            if (state is DeleteDuplicateEntryReceiptsDoneState) {
              isShowLoader = false;
              addTransactionReceiptBloc
                  .add(GetListOfReceiptsEvent(mContext: context));
            }

            if (state is AddTransactionReceiptInitialState) {
              addTransactionReceiptBloc
                  .add(GetListOfReceiptsEvent(mContext: context));
            }

            // Check if the list is empty
            if (addTransactionReceiptBloc.getListOfReceipts.isEmpty) {
              return const Center(
                child: Text(
                  AppString.noReceiptsAvailable,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            // Show list of receipts
            return SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              enablePullUp: !addTransactionReceiptBloc.getPostPageEnded,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              footer: const ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: addTransactionReceiptBloc.getListOfReceipts.length,
                itemBuilder: (context, index) {
                  final currentReceipt =
                      addTransactionReceiptBloc.getListOfReceipts[index];
                  final currentDate = currentReceipt.createdAt ?? '';
                  final previousDate = index > 0
                      ? addTransactionReceiptBloc
                              .getListOfReceipts[index - 1].createdAt ??
                          ''
                      : null;

                  final shouldShowDate = currentDate != previousDate;

                  final int id = currentReceipt.id!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (shouldShowDate)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Colors.grey, // Divider color
                                    thickness: 0.3, // Divider thickness
                                    endIndent:
                                        3, // Space between the divider and the container
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.textBlueColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    currentDate,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 0.3,
                                    indent:
                                        3, // Space between the container and the divider
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      TransactionReceiptList(
                          onLongPress: () async {
                            setState(() {
                              receiptID = id;
                              selectedReceiptID =
                                  id; // Store the selected vehicle ID
                            });

                            showCupertinoModalPopup(
                              barrierDismissible: true,
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
                                        if (receiptID != null) {
                                          deletePaymentReceipt(
                                              context, receiptID!);
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
                                        selectedReceiptID = null;
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
                          },
                          onTab: isShowDeleteForTransactionReceipts == false
                              ? null
                              : () {
                                  setState(() {
                                    selectedReceiptID = null; // Reset on tap
                                    isShowDeleteForTransactionReceipts = false;
                                  });
                                },
                          cardColor: selectedReceiptID == id
                              ? Colors.blue.shade100 // Change color if selected
                              : Colors.white,
                          amount: currentReceipt.amount ?? '',
                          description: currentReceipt.description ?? '',
                          unitNumber: currentReceipt.title ?? '',
                          createdAt: currentDate,
                          imageHeight: imageHeight,
                          accountComments: currentReceipt.accountComments,
                          imagePath: currentReceipt.imagePath ?? '',
                          duplicateEntryMessage:
                              currentReceipt.duplicateEntryMessage ?? '',
                          isDuplicateEntry:
                              currentReceipt.duplicateEntry ?? false,
                          paymentMethod: currentReceipt.paymentMethod ?? '',
                          status: currentReceipt.status ?? ''),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomMenuView: AppPermission.instance.canPermission(
              AppString.unitTransactionReceiptUpload,
              context: context)
          ? CommonFloatingAddButton(onPressed: () {
        bool? isDue = widget.isDue;

        isDue ??= myUnitBloc.summaryData?.isDue??false;

            isDue==true?Navigator.push(
              MainAppBloc.getDashboardContext,
              SlideLeftRoute(
                  widget: const AddTransactionForm(
                    comeWithPermission: [
                      AppString.unitTransactionReceiptUpload
                    ],
                  )),
            ).then((value) {
              if (value != null && value == true) {
                addTransactionReceiptBloc
                    .add(GetListOfReceiptsEvent(mContext: context));
                receivedANewMessage(context);
              }
            }):showNoDuesPopup(context);
              // photoPickerBottomSheet();
            })
          : const SizedBox(),
    );
  }
}
