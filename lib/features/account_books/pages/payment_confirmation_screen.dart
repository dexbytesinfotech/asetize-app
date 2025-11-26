import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_detail_view_row.dart';
import '../../add_transaction_receipt/bloc/add_transaction_receipt_state.dart';
import '../bloc/account_book_bloc.dart';
import '../bloc/account_book_event.dart';
import '../bloc/account_book_state.dart';

class PaymentConfirmation extends StatefulWidget {
  final int? id;
  final String? name;
  final String? paymentMethod;
  final String? amount;
  final String? selectUnit;
  final String? description;
  final String? imagePath;
  final String? duplicateEntryMessage;
  final bool? duplicateEntry;
  final bool? isHomePendingConfirmation;
  const PaymentConfirmation(
      {super.key,
      this.name,
      this.paymentMethod,
      this.amount,
      this.selectUnit,
      this.description,
      this.imagePath,
      this.duplicateEntry,
      this.id,
      this.duplicateEntryMessage,
      this.isHomePendingConfirmation});

  @override
  State<PaymentConfirmation> createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  late AccountBookBloc accountBloc;
  TextEditingController commentsTextController = TextEditingController();
  TextEditingController receiptNumberTextController = TextEditingController();

  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'paymentMethod': TextEditingController(),
    'amount': TextEditingController(),
    'selectUnit': TextEditingController(),
    'description': TextEditingController(),
  };

  final Map<String, FocusNode> focusNodes = {
    'name': FocusNode(),
    'paymentMethod': FocusNode(),
    'amount': FocusNode(),
    'selectUnit': FocusNode(),
    'description': FocusNode(),
  };

  final Map<String, String> errorMessages = {
    'name': '',
    'paymentMethod': '',
    'amount': '',
    'selectUnit': '',
    'description': '',
  };

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    controllers['name']?.text = widget.name ?? '';
    controllers['paymentMethod']?.text = widget.paymentMethod ?? '';
    controllers['amount']?.text = widget.amount ?? '';
    controllers['selectUnit']?.text = widget.selectUnit ?? '';
    controllers['description']?.text = widget.description ?? '';
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    focusNodes.values.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    Widget buildTextField({
      required String fieldKey,
      required String label,
      bool isRequired = true,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 0),
        child: CommonTextFieldWithError(
          focusNode: focusNodes[fieldKey],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages[fieldKey] ?? '',
          controllerT: controllers[fieldKey],
          readOnly: true,
          isTextFieldEnabled: false,
          textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 500,
          errorMsgHeight: 12,
          maxLines: 1,
          focusedBorderWidth: 0.0,
          autoFocus: false,
          showError: true,
          showCounterText: false,
          capitalization: CapitalizationText.sentences,
          cursorColor: Colors.grey,
          enabledBorderColor: Colors.white,
          focusedBorderColor: Colors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: label,
                style: appStyles.texFieldPlaceHolderStyle(),
                children: isRequired ? [] : null,
              ),
            ),
          ),
          contentPadding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          onTextChange: (value) {  }, onEndEditing: (value) {  },
        ),
      );
    }

    Widget imageDisplay() {
      if (widget.imagePath == null || widget.imagePath!.isEmpty) {
        return const SizedBox();
      }
      return Container(
        margin: const EdgeInsets.only(bottom: 0),
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
                Text("Receipt Image",
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
                      title: widget.selectUnit!,
                      profileImgUrl: widget.imagePath!,
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
                      imageUrl: widget.imagePath!,
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
                  content:
                      'Are you sure you want to credit ${widget.amount} to ${widget.selectUnit} house?\n This action cannot be undone.' ?? "",
                  buttonName1:
                      AppString.buttonConfirm ?? AppString.confirmButton,
                  hintText: AppString.enterReceiptNumber,
                  buttonName2: AppString.cancelButton,
                  unableButtonColor: AppColors.textDarkGreenColor,
                  disableButtonColor: Colors.green.withOpacity(0.5),
                  onPressedButton1: () {
                    // Handle Confirm action
                    accountBloc.add(
                      ReceiptSharedConfirmEvent(
                        mContext: context,
                        id: widget.id ?? 0,
                        receiptNumber: receiptNumberTextController.text ?? '',
                        status: AppString.approvedStatus,
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
                  content: "",
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
                        ReceiptSharedRejectEvent(
                          mContext: context,
                          id: widget.id ?? 0,
                          accountComments: commentsTextController.text,
                          status: AppString.rejectedStatus,
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
    }

    Widget warningMessage() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade300, width: 0.4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.duplicateEntryMessage ?? '',
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.paymentConfirmation,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AccountBookBloc, AccountBookState>(
        bloc: accountBloc,
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is AccountBookErrorStateForPaymentConfirmation) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          else if (state is AccountBookErrorStateForPaymentReject) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);

          }
          else if (state is ApprovedSharedConfirmDoneState) {
            if (widget.isHomePendingConfirmation! == false) {

              WorkplaceWidgets.successToast(AppString.paymentConfirmed,durationInSeconds: 1);
              Navigator.pop(context, true);
            } else {

              WorkplaceWidgets.successToast(AppString.paymentConfirmed,durationInSeconds: 1);
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            }

          }
          else if (state is RejectSharedConfirmDoneState) {
            if (widget.isHomePendingConfirmation! == false) {
              WorkplaceWidgets.successToast(AppString.paymentRejected,durationInSeconds: 1);

              Navigator.pop(context, true);
            } else {
              WorkplaceWidgets.successToast(AppString.paymentRejected,durationInSeconds: 1);
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            }
          }
        },
        child: BlocBuilder<AccountBookBloc, AccountBookState>(
          bloc: accountBloc,
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding:  const EdgeInsets.all(16.0).copyWith(top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     CommonCardView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.duplicateEntry ?? false ?
                              warningMessage(): const SizedBox(),

                              SizedBox(height: 10,),

                              CommonDetailViewRow(
                                icons: CupertinoIcons.person_alt_circle,
                                title: projectUtil.capitalize(AppString.nameFieldKey),
                                value: widget.name ?? "",
                              ),

                              CommonDetailViewRow(
                                icons: Icons.payment,
                                title: AppString.paymentMethodFieldKey,
                                value: widget.paymentMethod ?? "",
                              ),

                              CommonDetailViewRow(
                                icons: Icons.currency_rupee_outlined,
                                title: projectUtil.capitalize(AppString.amountFieldKey),
                                value: widget.amount ?? "",
                              ),

                              CommonDetailViewRow(
                                icons: CupertinoIcons.building_2_fill,
                                title: AppString.selectUnitFieldKey,
                                value: widget.selectUnit ?? "",
                              ),

                              if (widget.description != null && widget.description!.isNotEmpty)
                              CommonDetailViewRow(
                                icons: CupertinoIcons.person_alt_circle,
                                title: projectUtil.capitalize(AppString.descriptionFieldKey),
                                value: widget.description ?? "",
                              ),

                              imageDisplay(),
                              SizedBox(height: 10,),
                            ],
                          )
                        ),
                      ),
                     const SizedBox(height: 20,),
                     bottomButton()
                    ],
                  ),
                ),
                if (state is AddTransactionReceiptLoadingState)
                  WorkplaceWidgets.progressLoader(context),
              ],

            );
          },
        ),
      ),
    );
  }
}
