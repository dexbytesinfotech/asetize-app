// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:asetize/widgets/commonTitleRowWithIcon.dart';
import 'package:asetize/widgets/common_card_view.dart';
import 'package:asetize/widgets/download_button_widget.dart';

import '../../../app_global_components/unit_statement_card_widget.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_detail_view_row.dart';
import '../../my_unit/bloc/my_unit_bloc.dart';
import '../../my_unit/widgets/common_image_view.dart';
import '../../policy/pages/pdf_view_page.dart';
import '../bloc/account_book_bloc.dart';
import '../bloc/account_book_event.dart';
import '../bloc/account_book_state.dart';

class PaymentHistoryDetailScreen extends StatefulWidget {
  final int id;
  final String? tableName;
  final String? title;
  final String? date;
  final bool isComingFromAccount;
  const PaymentHistoryDetailScreen({super.key,
    required this.id,
     this.tableName,
     this.title,
     this.date,
    this. isComingFromAccount = false,


  });
  @override
  State<PaymentHistoryDetailScreen> createState() =>
      _PaymentHistoryDetailScreenState();
}
class _PaymentHistoryDetailScreenState
    extends State<PaymentHistoryDetailScreen> {
  late AccountBookBloc accountBloc;
  late MyUnitBloc myUnitBloc;
  String unitTitle = '';
  String? redirectionTitle;
  String? voucherPhoto;
  File? selectProfilePhoto;
  bool? isMyExpense;
  String? selectProfilePhotoPath;
  String imageErrorMessage = '';

  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  bool isImageSelected = false;

  @override
  void initState() {
    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    accountBloc.add(FetchAccountBookHistoryDetailEvent(
      mContext: context,
      id: widget.id,
      tableName: widget.tableName ?? '',
    ));
    super.initState();
  }

  IconData _getIcon(String key) {
    switch (key.toLowerCase()) {
      case 'voucher number':
        return Icons.confirmation_number; // Voucher icon
      case 'payee name':
        return Icons.person; // Payee
      case 'profession':
        return Icons.work; // Profession
      case 'description':
        return Icons.description; // Description
      case 'amount':
        return Icons.currency_rupee_outlined; // Amount
      case 'date':
      case 'payment date':
        return Icons.date_range_sharp; // Date
      case 'payment mode':
      case 'payment method':
        return Icons.payment; // Payment Mode
      case 'status':
        return Icons.info_outline; // Status
      case 'voucher image':
      case 'voucher photo':
        return Icons.image; // Voucher Photo
      case 'duration':
      case 'durations':
        return Icons.access_time; // Time
      case 'receipt number':
        return Icons.receipt_long; // Receipt Number
      case 'verified by':
        return Icons.verified_user; // Verified By
      case 'verified at':
        return Icons.verified; // Verified At (date/time)
      default:
        return Icons.receipt_long_sharp; // Default
    }
  }


  Widget imageDisplay() {
    if (voucherPhoto == null || voucherPhoto!.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 0, left: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.image,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
              ),
              SizedBox(width: 7),
              Text("Voucher Photo",
                  style: appTextStyle.appSubTitleStyle2(
                      color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(FadeRoute(
                  widget: FullPhotoView(
                    title: "Voucher",
                    profileImgUrl:voucherPhoto!,
                  ),
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5,),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => const ImageLoader(),
                    imageUrl: voucherPhoto!,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade50,
                      child: const Center(
                        child: Text(
                          AppString.couldNotLoadError,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> detailsRow2() {
    return accountBloc.historyDetail.keys.map((key) {
      final value = accountBloc.historyDetail[key];
      if (key == "house_name") {
        unitTitle = "$value";
        return const SizedBox();
      }
      if (key == 'payments' || key == 'invoices'|| key == '"expense"' || key == "voucher_photo" || key == "not_visible" || key ==  "transaction_reference") {
        return const SizedBox(); // Skip rendering for empty files
      }
      String formattedKey =
      '${key[0].toUpperCase()}${key.substring(1)}'.replaceAll('_', ' ');
      String displayValue = '';
      if (value != null) {
        displayValue = value is String
            ? value
            : value.toString();
      }
      if (displayValue.isEmpty) {
        return const SizedBox();
      }
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 18),
        child: CommonDetailViewRow(
              title: projectUtil.capitalizeFullName(formattedKey),
              value: displayValue,
              icons: _getIcon(formattedKey),
        )
      );
    }).toList();
  }


  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  Color _parseColor(String? colorString, {Color defaultColor = Colors.black}) {
    if (colorString == null || colorString.isEmpty) return defaultColor;
    return Color(int.parse(colorString.replaceFirst("0x", ""), radix: 16));
  }
  /// remove image function
  void _removeImage() {
    setState(() {
      selectProfilePhoto = null;
      selectProfilePhotoPath = null;
      isImageSelected = false;
      imageFile?.clear();
      imagePath?.clear();
    });
  }
  void photoPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context1) => PhotoPickerBottomSheet(
        isRemoveOptionNeeded: false,
        removedImageCallBack: () {
          Navigator.pop(context1);
          setState(() {
            selectProfilePhotoPath = "";
            isImageSelected = false;
          });
        },
        selectedImageCallBack: (fileList) {
          try {
            if (fileList != null && fileList.isNotEmpty) {
              fileList.map((fileDataTemp) {
                File imageFileTemp = File(fileDataTemp.path);
                selectProfilePhoto = imageFileTemp;
                selectProfilePhotoPath = selectProfilePhoto!.path;
                isImageSelected = true;

                if (imageFile == null) {
                  imageFile = <String, File>{};
                } else {
                  imageFile!.clear();
                }
                if (imagePath == null) {
                  imagePath = <String, String>{};
                } else {
                  imagePath!.clear();
                }
                imageErrorMessage = '';
                String mapKey = DateTime.now().microsecondsSinceEpoch.toString();
                imageFile![mapKey] = imageFileTemp;
                imagePath![mapKey] = imageFileTemp.path;
              }).toList(growable: false);

              setState(() {});

              /// 👉 Instead of only closing, navigate to ImageViewPage
              Navigator.pop(context1); // close bottom sheet first
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: ImageViewPage(
                    imageUrl: selectProfilePhotoPath!,
                    isSet: true,
                    title: 'Image Preview',
                    subTitle: AppString.nocReport,
                    fromFilePicker: true,
                    onUploadCallback: (imageUrl) {
                      // Do something specific for Screen A
                      // accountBloc.add(OnUploadVoucherImageEvent(filePath: selectProfilePhotoPath ?? '', isUploadFromDetail: true));
                    },
                  ),
                ),
              );
            }
          } catch (e) {
            debugPrint('$e');
          }
        },
        selectedCameraImageCallBack: (fileList) {
          try {
            if (fileList != null && fileList.path!.isNotEmpty) {
              File imageFileTemp = File(fileList.path!);
              selectProfilePhoto = imageFileTemp;
              selectProfilePhotoPath = selectProfilePhoto!.path;
              isImageSelected = true;
              if (imageFile == null) {
                imageFile = {};
              } else {
                imageFile!.clear();
              }
              if (imagePath == null) {
                imagePath = {};
              } else {
                imagePath!.clear();
              }
              imageErrorMessage = '';
              String mapKey = DateTime.now().microsecondsSinceEpoch.toString();
              imageFile![mapKey] = imageFileTemp;
              imagePath![mapKey] = imageFileTemp.path;
              setState(() {});

              /// 👉 Close bottom sheet + navigate
              Navigator.pop(context1);
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: ImageViewPage(
                    isSet: true,
                    imageUrl: selectProfilePhotoPath!,
                    title: 'Image Preview',
                    subTitle: AppString.nocReport,
                    fromFilePicker: true,
                    onUploadCallback: (imageUrl) {
                      // Do something specific for Screen A
                      // accountBloc.add(OnUploadVoucherImageEvent(filePath: selectProfilePhotoPath ?? '', isUploadFromDetail: true));
                    },
                  ),
                ),
              );
            }
          } catch (e) {
            debugPrint('$e');
          }
        },
      ),
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(photoPickerBottomSheetCardRadius)),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Widget bottomButton() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                WorkplaceWidgets.showRequestDialog(
                  context: context,
                  title:
                  AppString.approveRequest ?? AppString.approveRequestTitle,
                  content: "Are you sure you want to approve this expense? This action cannot be undone.",
                  // 'Are you sure you want to credit ${widget.amount} to ${widget.selectUnit} house?\n This action cannot be undone.' ?? "",
                  buttonName1:
                  AppString.buttonConfirm ?? AppString.confirmButton,
                  hintText: AppString.enterReceiptNumber,
                  buttonName2: AppString.cancelButton,
                  unableButtonColor: AppColors.textDarkGreenColor,
                  disableButtonColor: Colors.green.withOpacity(0.5),
                  onPressedButton1: () {
                    // Handle Confirm action
                    accountBloc.add(
                      ExpensesApprovedEvent(
                        id: widget.id ?? 0,
                        status: "1"
                      ),
                    );
                    Navigator.pop(context);
                  },
                  onPressedButton2: () {
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                    color: AppColors.textDarkGreenColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text(
                      AppString.approved,
                      style: appTextStyle.appTitleStyle(
                        color: AppColors.white,
                      ),
                    )),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                TextEditingController commentsTextController =
                TextEditingController();
                WorkplaceWidgets.showRequestDialogForRejected(
                  context: context,
                  title: AppString.rejectRequestTitle,
                  content: "Are you sure you want to reject this expense? This action cannot be undone.",
                  buttonName1: AppString.submitButton,
                  buttonName2: AppString.cancelButton,
                  disableButtonColor: AppColors.textDarkRedColor.safeOpacity(0.5),
                  unableButtonColor: AppColors.textDarkRedColor,
                  textController: commentsTextController,
                  hintText: AppString.enterReasonHint,
                  maxLine: 3,
                  onPressedButton1: () {
                    if (commentsTextController.text.trim().isNotEmpty) {
                      accountBloc.add(
                        ExpensesRejectEvent(
                            id: widget.id ?? 0,
                            status: "-1"
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  onPressedButton2: () {
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.textDarkRedColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    AppString.reject,
                    style: appTextStyle.appTitleStyle(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    };
    Widget voucherPhotoUpload(state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.image_outlined, color: AppColors.textBlueColor),
              const SizedBox(width: 8),
              Text(
                "Voucher Image",
                style: appStyles.texFieldPlaceHolderStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Upload area with condition
          GestureDetector(
            onTap: () {
              if (!isImageSelected) {
                photoPickerBottomSheet();
              }else {
                Navigator.of(context).push(FadeRoute(
                    widget:  FullPhotoView(
                      title: "Voucher",
                      localProfileImgUrl: selectProfilePhotoPath?? '',
                    )));
              }
            },
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue.shade600,
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              child: isImageSelected && selectProfilePhotoPath != null
                  ? Stack(
                children: [
                  /// Show selected image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(selectProfilePhotoPath!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// Remove button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cloud_upload_outlined,
                      color: AppColors.appBlueColor, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "Click to upload voucher image",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Supports JPG, PNG, GIF up to 5MB",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          /// Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                    isShowIcon: true,
                    flutterIcon:   Icons.upload_file,
                    buttonName: AppString.voucherImage,
                    buttonColor: selectProfilePhotoPath != null ? AppColors.textBlueColor:Colors.grey,
                    iconSize: Size(20, 20),
                    isLoader: state is UploadVoucherImageLoadingState ? true: false,
                    textStyle: appStyles.buttonTextStyle1(texColor: AppColors.white),
                    backCallback: selectProfilePhotoPath != null ?() {


                      closeKeyboard();

                      accountBloc.add(OnUploadVoucherImageEvent(filePath: selectProfilePhotoPath ?? '', isUploadFromDetail: true, expenseId: widget.id));
                    }: null
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  isShowIcon: true,
                  buttonBorderColor: AppColors.textBlueColor,
                  flutterIcon: Icons.auto_fix_high,
                  isLoader: state is FetchGeneratedVoucherLoadingState ? true: false,
                  loaderColor: AppColors.textBlueColor,
                  buttonName: AppString.generateVoucher,
                  iconSize: Size(20, 20),
                  textStyle: appStyles.buttonTextStyle1(
                      texColor: AppColors.textBlueColor),
                  buttonColor: AppColors.white,
                  iconColor: AppColors.textBlueColor,
                  backCallback: () {
                    accountBloc.add(OnFetchGeneratedVoucherEvent(
                        expenseId: widget.id.toString(), mContext: context));




                  },
                ),
              ),
            ],
          ),
        ],
      );
    }




    downloadButton() {
      return DownloadButtonWidget(
        onTapCallBack: (){
          accountBloc.add(FetchPaymentReceiptForAccountedEvent(
              paymentId: widget.id.toString(), mContext: context));
        },
      );
    }

    paymentHistory(state){
      String? status = accountBloc.historyDetail["status"];


      return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
        child: Stack(
          children: [
            Column(
              children: [
                  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CommonCardView(
                    margin:  EdgeInsets.zero,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 20, bottom: 12),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                            detailsRow2(),

                          ),
                          imageDisplay(),
                          if (widget.tableName?.toLowerCase() == "payment")

                            downloadButton()

                        ]
                      ),
                    ),
                  ),
                ),
                SizedBox(height: voucherPhoto == null?10:0,),
                if ((voucherPhoto == null ||  voucherPhoto == "") &&(status != null && status.toLowerCase() == "pending" ) &&  widget.isComingFromAccount == false)
                voucherPhotoUpload(state),
                SizedBox(height: 10,),

                if (status != null && status.toLowerCase() == "pending" &&  AppPermission.instance.canPermission(AppString.expenseAction, context: context )&& voucherPhoto != null &&voucherPhoto != ""  &&
                isMyExpense == false )
                  bottomButton(),


                accountBloc.statementInvoices.isNotEmpty
                    ? CommonTitleRowWithIcon(title: 'Invoices',icon: CupertinoIcons.doc_text_fill,)
                    : SizedBox(),
                if (accountBloc.statementInvoices.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: accountBloc.statementInvoices.length,
                    itemBuilder: (context, index) {
                      return UnitStatementCardWidget(
                        title: accountBloc.statementInvoices[index].title ?? '',
                        description: accountBloc.statementInvoices[index].description ?? '',
                        amount: accountBloc.statementInvoices[index].amount ?? '',
                        type: accountBloc.statementInvoices[index].type ?? '',
                        date: accountBloc.statementInvoices[index].date ?? '',
                        subTitle: accountBloc.statementInvoices[index].subTitle ?? '',
                        table: accountBloc.statementInvoices[index].table ?? '',
                        status: accountBloc.statementInvoices[index].status ?? '',
                        statusColor: _parseColor(accountBloc.statementInvoices[index].statusColor ?? ""),
                        balanceAmount: accountBloc.statementInvoices[index].balanceAmount ?? "",
                        paymentMethod: accountBloc.statementInvoices[index].paymentMethod ?? "",
                      );
                    }),

              ],
            ),
            if (state is PaymentReceiptForAccountedLoadingState || state is ExpensesApprovedLoadingState || state is ExpensesRejectLoadingState )
              WorkplaceWidgets.progressLoader(context)

          ],
        ),
      );
    }

    noDataFound(){
      return Center(
        child: Column(
          children: [
            Text(
              AppString.noDataFound,
              style: appTextStyle.noDataTextStyle(),
            )
          ],
        ),
      );
    }

    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isFixedDeviceHeight: true,
        isListScrollingNeed: false,
        isOverLayStatusBar: false,
        appBarHeight: 50,
        appBar: CommonAppBar(
          isThen: false,
          title: widget.title ?? redirectionTitle,
          icon: WorkplaceIcons.backArrow,
        ),
        containChild: BlocListener<AccountBookBloc, AccountBookState>(
          bloc: accountBloc,
          listener: (context, state) {
            if (state is PaymentReceiptForAccountedDoneState) {
              Navigator.push(
                  context,
                  SlideLeftRoute(
                      widget:  PdfViewPage(
                        title: AppString.paymentReceipt,
                        // subTitle: widget.receiptNumber,
                        pdfUrl: accountBloc.pdfUrlForAccounted ?? '',
                      )));
            }

            if (state is ExpensesApprovedDoneState) {
              WorkplaceWidgets.successToast(state.message,
                  durationInSeconds: 1);
              Navigator.pop(context, true);
            }

            if (state is ExpensesRejectDoneState) {
              WorkplaceWidgets.successToast(state.message,
                  durationInSeconds: 1);
              Navigator.pop(context, true);
            }


            if (state is PaymentReceiptForAccountedErrorState) {

              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            if (state is ExpensesRejectErrorState) {

              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            if (state is UploadVoucherImageErrorState) {


              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            if (state is ExpensesApprovedErrorState) {

              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }   if (state is FetchGeneratedVoucherErrorState) {

              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }

            if (state is UploadVoucherFromDetailDoneState) {

              accountBloc.add(FetchAccountBookHistoryDetailEvent(
                mContext: context,
                id: widget.id,
                tableName: widget.tableName ?? '',
              ));
            }
            if (state is FetchGeneratedVoucherDoneState) {

              Navigator.push(
                  context,
                  SlideLeftRoute(
                      widget:  PdfViewPage(
                        title: AppString.voucher,
                        // subTitle: widget.receiptNumber,
                        pdfUrl: accountBloc.pdfUrlForGeneratedVoucher ?? '',
                      )));
            }




            if (state is FetchAccountBookHistoryDetailDoneState) {

              final payeeName = accountBloc.historyDetail["payee_name"] ?? '';
              final profession = accountBloc.historyDetail["profession"] ?? '';

              if (payeeName.isNotEmpty && profession.isNotEmpty) {
                redirectionTitle = '$payeeName, $profession';
              } else {
                redirectionTitle = payeeName.isNotEmpty ? payeeName : profession;
              }

              if (redirectionTitle!.isNotEmpty) {
                redirectionTitle =
                    redirectionTitle![0].toUpperCase() + redirectionTitle!.substring(1);
              }
              voucherPhoto = accountBloc.historyDetail["voucher_photo"];
              print(voucherPhoto);
              isMyExpense = accountBloc.historyDetail["not_visible"]["is_my_expense"];
              print(isMyExpense); // true
              print(isMyExpense);
              setState(() {
              });
            }
          },
          child: BlocBuilder<AccountBookBloc, AccountBookState>(
              bloc: accountBloc,
              builder: (BuildContext context, state) {
                if (state is AccountBookLoadingState) {
                  return WorkplaceWidgets.progressLoader(context,color: Colors.white.safeOpacity(0.3));
                }

                if (state is UploadVoucherImageErrorState) {

                  selectProfilePhotoPath = null;
                  isImageSelected = false;
                  selectProfilePhoto = null;

                }


                if (state is AccountBookErrorState) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          state.errorMessage,
                          style: appTextStyle.noDataTextStyle(),
                        )
                      ],
                    ),
                  );
                }
                return accountBloc.historyDetail.isEmpty
                    ? noDataFound()
                    : paymentHistory(state);
              }),
        ));
  }
}
