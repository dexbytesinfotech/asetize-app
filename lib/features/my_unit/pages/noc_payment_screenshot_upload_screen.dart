// import 'dart:io';
//
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
//
// import '../../../core/util/app_theme/app_color.dart';
// import '../../../core/util/app_theme/app_string.dart';
// import '../../../core/util/app_theme/app_style.dart';
// import '../../../core/util/workplace_icon.dart';
// import '../../../imports.dart';
// import '../../presentation/widgets/app_button_common.dart';
// import '../../presentation/widgets/appbar/common_appbar.dart';
// import '../../presentation/widgets/basic_view_container/container_first.dart';
// import '../../presentation/widgets/full_image_view.dart';
// import '../../presentation/widgets/photo_picker_widget.dart';
// import '../bloc/my_unit_bloc.dart';
// import '../widgets/noc_payment_info_common_card.dart';
//
// class NocPaymentScreenShotUploadScreen extends StatefulWidget {
//   final int id;
//   const NocPaymentScreenShotUploadScreen({super.key, required this.id});
//   @override
//   NocPaymentScreenShotUploadScreenState createState() => NocPaymentScreenShotUploadScreenState();
// }
//
// class NocPaymentScreenShotUploadScreenState extends State<NocPaymentScreenShotUploadScreen> {
//   File? uploadedImageFile; // <-- updated from PlatformFile to File
//   late MyUnitBloc myUnitBloc;
//
//   @override
//   void initState() {
//     myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     void photoPickerBottomSheet({
//       bool? canClose = false,
//       bool? canSkip = false,
//       Function({Map<String, File>? imageFile, Map<String, String>? imagePath})? onSelectedImageCallBack,
//     }) {
//       showModalBottomSheet(
//         context: context,
//         isDismissible: canClose!,
//         builder: (popupContext) {
//           Map<String, File>? imageFile = <String, File>{};
//           Map<String, String>? imagePath = <String, String>{};
//
//           return PhotoPickerBottomSheet(
//             isRemoveOptionNeeded: true,
//             cancelText: "Cancel",
//             cancelIcon: const Padding(
//               padding: EdgeInsets.only(left: 5),
//               child: Icon(
//                 Icons.close,
//                 color: AppColors.textBlueColor,
//                 size: 26,
//               ),
//             ),
//             topLineClickCallBack: () {
//               Navigator.pop(popupContext);
//             },
//             removedImageCallBack: () {
//               Navigator.pop(popupContext);
//               Navigator.pop(context);
//             },
//             onSkipClick: canSkip == false
//                 ? null
//                 : () {
//               Navigator.pop(popupContext);
//             },
//             selectedImageCallBack: (fileList) {
//               try {
//                 if (fileList != null && fileList.isNotEmpty) {
//                   setState(() {
//                     uploadedImageFile = File(fileList.first.path); // take first image
//                   });
//                 }
//               } catch (e) {
//               }
//               Navigator.pop(popupContext);
//             },
//             selectedCameraImageCallBack: (fileData) {
//               try {
//                 if (fileData != null && fileData.path!.isNotEmpty) {
//                   setState(() {
//                     uploadedImageFile = File(fileData.path!);
//                   });
//                 }
//               } catch (e) {
//               }
//               Navigator.pop(popupContext);
//             },
//           );
//         },
//         isScrollControlled: false,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(20),
//           ),
//         ),
//       );
//     }
//
//     Widget submitButton(state) {
//       return Container(
//         margin: const EdgeInsets.only(left: 0, right: 0, top: 20),
//         child: AppButton(
//           buttonName: AppString.submitRequest,
//           buttonColor: uploadedImageFile != null ?AppColors.textBlueColor: Colors.grey,
//           textStyle: appStyles.buttonTextStyle1(
//             texColor: AppColors.white,),
//           isLoader: state is OnNocPaymentReceiptLoadingState,
//           backCallback: uploadedImageFile != null  ?() {
//             myUnitBloc.add(
//               OnNocPaymentReceiptSubmitEvent(
//                 mContext: context,
//                 id: widget.id,
//                   filePath: uploadedImageFile!.path
//               ),
//             );
//           }: null
//         ),
//       );
//     }
//
//     return ContainerFirst(
//       contextCurrentView: context,
//       isSingleChildScrollViewNeed: true,
//       isFixedDeviceHeight: true,
//       isListScrollingNeed: true,
//       isOverLayStatusBar: false,
//       bottomSafeArea: true,
//       appBarHeight: 56,
//       appBar: const CommonAppBar(
//         title: AppString.nocRequestPayment,
//         icon: WorkplaceIcons.backArrow,
//       ),
//       containChild: BlocListener<MyUnitBloc, MyUnitState>(
//         bloc: myUnitBloc,
//         listener: (BuildContext context, MyUnitState state) {
//           if (state is SubmitRequestForNOCErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text(state.errorMessage),
//               backgroundColor: Colors.red,
//             ));
//           }
//           if (state is OnNocPaymentReceiptDoneState) {
//           Navigator.pop(context, true);
//
//           }
//         },
//         child: BlocBuilder<MyUnitBloc, MyUnitState>(
//           bloc: myUnitBloc,
//           builder: (BuildContext context, state) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 child: Column(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 20),
//                         InfoBox(
//                           items: [
//                             InfoItem(
//                               icon: Icons.info_outline,
//                               text: "To process your NOC request, a non-refundable fee of ₹300 is applicable.",
//                             ),
//                             InfoItem(
//                               icon: Icons.payment,
//                               text: "Payment must be made via [Bank/UPI/Online Link].",
//                             ),
//                             InfoItem(
//                               icon: Icons.upload_file,
//                               text: "After successful payment, you are required to upload the payment receipt.",
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 26),
//                         Padding(
//                           padding: const EdgeInsets.all(5.0).copyWith(top: 0, bottom: 0),
//                           child: TextFormField(
//                             readOnly: true,
//                             style: appStyles.textFieldTextStyle(),
//                             decoration: InputDecoration(
//                               prefixIcon: const Padding(
//                                 padding: EdgeInsets.only(left: 18, right: 8, top: 10),
//                                 child: Text(
//                                   "Amount to Pay: ",
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                               suffixIcon: const Padding(
//                                 padding: EdgeInsets.only(right: 18, left: 8, top: 13),
//                                 child: Text(
//                                   "₹300",
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(
//                                   color: Colors.grey.shade500,
//                                   width: 0.7,
//                                 ),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(
//                                   color: Colors.grey.shade500,
//                                   width: 0.7,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(
//                                   color: Colors.grey.shade500,
//                                   width: 0.7,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 26),
//                         GestureDetector(
//                           onTap: uploadedImageFile != null
//                               ? () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => FullPhotoView(
//                                   comeFromTransactionPage: true,
//                                   title: AppString.nocRequestPayment,
//                                   localProfileImgUrl: uploadedImageFile?.path
//                               ),
//                             ));
//                           }
//                               : photoPickerBottomSheet,
//                           child: Card(
//                             elevation: 1.0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             color: Colors.white,
//                             child: Container(
//                               width: double.infinity,
//                               height: 150,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(color: Colors.grey.shade300, width: 0.5),
//                               ),
//                               child: uploadedImageFile == null
//                                   ? DottedBorder(
//                                 color: Colors.grey,
//                                 strokeWidth: 2,
//                                 dashPattern: [6, 4],
//                                 borderType: BorderType.RRect,
//                                 radius: const Radius.circular(8),
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         'Upload Payment Screenshot\nSupported formats: JPG, PNG, PDF',
//                                         textAlign: TextAlign.center,
//                                         style: appStyles.hintTextStyle(texColor: Colors.black54),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                                   : Stack(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.file(
//                                       uploadedImageFile!,
//                                       width: double.infinity,
//                                       height: 150,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           uploadedImageFile = null;
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.black.withOpacity(0.5),
//                                           shape: BoxShape.circle,
//                                         ),
//                                         padding: const EdgeInsets.all(4),
//                                         child: const Icon(Icons.close, color: Colors.white, size: 18),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         submitButton(state),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//
//
//
//
//     );
//   }
// }
