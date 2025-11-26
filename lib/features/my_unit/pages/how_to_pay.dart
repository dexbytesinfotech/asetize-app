import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/commonTitleRowWithIcon.dart';
import '../../../widgets/common_card_view.dart';
import '../../../widgets/common_detail_view_row.dart';
import '../../../widgets/download_button_widget.dart';
import '../bloc/my_unit_bloc.dart';
import '../widgets/common_image_view.dart';

class HowToPayScreen extends StatefulWidget {
  const HowToPayScreen({super.key});

  @override
  State<HowToPayScreen> createState() => _HowToPayScreenState();
}

class _HowToPayScreenState extends State<HowToPayScreen> {
  final TextEditingController controller = TextEditingController();
  late MyUnitBloc myUnitBloc;

  @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> shareContent({
    required BuildContext context,
    String? textToShare,
    String? imageUrl,
  }) async {
    try {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Download image from URL and share it
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode != 200) {
          throw Exception('Failed to download image');
        }

        final tempDir = await getTemporaryDirectory();
        final fileName = path.basename(imageUrl);
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        await Share.shareXFiles([XFile(file.path)], text: textToShare ?? '');
      } else if (textToShare != null) {
        await Share.share(textToShare);
      } else {
        WorkplaceWidgets.errorSnackBar(context, 'Nothing to share.');
      }
    } catch (e) {
      WorkplaceWidgets.errorSnackBar(context, 'Error: $e');
    }
  }

  Widget importantNote() {
    return CommonCardView(
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.grey),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          initiallyExpanded: true,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                CommonTitleRowWithIcon(
                  title: 'Important Note',
                  icon: Icons.event_note,
                ),
              ],
            ),
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  myUnitBloc.howToPayData?.paymentNotes ?? '',
                  style: appTextStyle.appSubTitleStyle3(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isFixedDeviceHeight: false,
        isListScrollingNeed: false,
        isOverLayStatusBar: false,
        appBarHeight: 56,
        appBar: CommonAppBar(
          title: AppString.howToPay,
        ),
        containChild: BlocListener<MyUnitBloc, MyUnitState>(
          bloc: myUnitBloc,
          listener: (BuildContext context, MyUnitState state) {
            if (state is MyUnitErrorState2) {
              WorkplaceWidgets.errorSnackBar(context, state.message);
            }
            if (state is PaymentSuccessDoneState) {
              WorkplaceWidgets.successToast(state.message);
            }
          },
          child: BlocBuilder<MyUnitBloc, MyUnitState>(
            bloc: myUnitBloc,
            builder: (BuildContext context, state) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------------- Bank Account Transfer -------------------
                    if (myUnitBloc.howToPayData?.upiQrCode != null)
                      CommonCardView(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10)
                              .copyWith(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTitleRowWithIcon(
                                    title: 'UPI Payment',
                                    icon: Icons.payment,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share,
                                        size: 25, color: Colors.black),
                                    onPressed: () {
                                      shareContent(
                                        context: context,
                                        textToShare:
                                            "Scan and pay using UPI.\nUse GPay, PhonePe, Paytm or any UPI app.",
                                        imageUrl: myUnitBloc
                                                .howToPayData?.upiQrCode ??
                                            '',
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              if (myUnitBloc.howToPayData?.upiQrCode != null)
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Scan and pay',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600),
                                      ),
                                      const SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            FadeRoute(
                                              widget: FullPhotoView(
                                                title: "Upi Qr Code Image",
                                                profileImgUrl: myUnitBloc
                                                    .howToPayData?.upiQrCode,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  const ImageLoader(),
                                              imageUrl: myUnitBloc.howToPayData
                                                      ?.upiQrCode ??
                                                  "",
                                              fit: BoxFit.cover,
                                              height: 150,
                                              width: 150,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Colors.grey.shade50,
                                                child: const Center(
                                                  child: Text(
                                                    AppString.couldNotLoadError,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // DownloadButtonWidget(
                                      //   borderRadius: 5,
                                      //   height: 35,
                                      //   horizontalRadius: 0,
                                      //   buttonName: 'Download/Share Qr Code',
                                      //   onTapCallBack: () {
                                      //     Navigator.push(
                                      //       context,
                                      //       SlideLeftRoute(
                                      //         widget: ImageViewPage(
                                      //           imageUrl: myUnitBloc.howToPayData
                                      //               ?.upiQrCode ??
                                      //               "",
                                      //           title: "Download/Share Qr Code",
                                      //           subTitle: "Qr Code",
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                              Text(
                                'Use GPay, PhonePe, Paytm or any UPI app to transfer funds',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    if (myUnitBloc.howToPayData?.bankAccountNumber != null)
                      CommonCardView(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10)
                              .copyWith(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTitleRowWithIcon(
                                    title: 'Bank Account Transfer',
                                    icon: Icons.account_balance,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share,
                                        size: 25, color: Colors.black),
                                    onPressed: () {
                                      final data = myUnitBloc.howToPayData;
                                      final details = '''
Bank Account Transfer Details:

🏦 Account Name: ${data?.accountName ?? ''}
💳 Account Number: ${data?.bankAccountNumber ?? ''}
🏢 Branch Name: ${data?.branchName ?? ''}
🔢 IFSC Code: ${data?.ifscCode ?? ''}

Use any banking app or UPI to transfer funds.
''';
                                      shareContent(
                                          context: context,
                                          textToShare: details);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              CommonDetailViewRow(
                                isShowCopyIcon: true,
                                title: 'Account Number',
                                icons: Icons.account_balance,
                                value: myUnitBloc
                                        .howToPayData?.bankAccountNumber ??
                                    "",
                              ),
                              CommonDetailViewRow(
                                isShowCopyIcon: true,
                                title: 'IFSC Code',
                                icons: Icons.code,
                                value: myUnitBloc.howToPayData?.ifscCode ?? "",
                              ),
                              CommonDetailViewRow(
                                isShowCopyIcon: true,
                                title: 'Account Name',
                                icons: Icons.person,
                                value:
                                    myUnitBloc.howToPayData?.accountName ?? "",
                              ),
                              CommonDetailViewRow(
                                isShowCopyIcon: true,
                                title: 'Branch Name',
                                icons: Icons.store,
                                value:
                                    myUnitBloc.howToPayData?.branchName ?? "",
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                    // ------------------- UPI Payment -------------------

                    if (myUnitBloc.howToPayData?.chequePayableName != null)
                      // ------------------- Payment by Cheque -------------------
                      CommonCardView(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20)
                              .copyWith(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTitleRowWithIcon(
                                title: 'Payment by Cheque',
                                icon: Icons.receipt,
                              ),
                              const SizedBox(height: 20),
                              CommonDetailViewRow(
                                title: 'Cheque in favor of',
                                icons: Icons.receipt,
                                value: myUnitBloc
                                        .howToPayData?.chequePayableName ??
                                    '',
                              ),
                              Text(
                                myUnitBloc.howToPayData?.chequeSubmissionNote ??
                                    '',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                    // ------------------- Important Notes -------------------
                    if (myUnitBloc.howToPayData?.paymentNotes != null)
                      importantNote(),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
