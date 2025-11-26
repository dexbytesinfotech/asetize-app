// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:asetize/imports.dart';
// import 'dart:async';
// import 'package:flutter/material.dart';
//
// import '../../presentation/pages/new_password_screen.dart';
//
// class OtpScreen extends StatefulWidget {
//   const OtpScreen({Key? key}) : super(key: key);
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   final TextEditingController controller =TextEditingController();
//   bool isError=false;
//   int resendTime=60;
//   late Timer countdownTimer;
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//   @override
//   void initState() {
//     startTimer();
//     super.initState();
//   }
//   startTimer()
//   {
//     countdownTimer=Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         resendTime=resendTime-1;
//       });
//       if(resendTime<1)
//       {
//         countdownTimer.cancel();
//       }
//
//     });
//   }
//   stopTimer()
//   {
//     if(countdownTimer.isActive)
//     {
//       countdownTimer.cancel();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor:const Color(0xFFFFFFFF),
//       appBar: AppBar(
//         backgroundColor:const Color(0xFFFFFFFF) ,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 24,right: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 24,),
//               const Text('OTP code verification 🔐',
//                   style: TextStyle(
//                     fontSize:28,
//                     fontFamily: 'Urbanist',
//                     fontWeight:FontWeight.w700,
//                     color:Color(0xFF212121),
//                   )
//               ),
//               const SizedBox(height: 16,),
//               const Text('We have sent an OTP code to phone number●●● ●●● ●●● ●99. Enter the OTP code below to continue.',
//                   style: TextStyle(
//                       fontFamily: 'Urbanist',
//                       fontSize: 16,
//                       fontWeight:FontWeight.w400,
//                       color:Color(0xFF212121),
//                       letterSpacing: .2
//                   )
//               ),
//               const SizedBox(height:55),
//               PinCodeTextField(
//                 appContext: context,
//                 length: 4,
//                 onChanged: (value)
//                 {
//                 },
//                 controller: controller,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value)
//                 {
//                   if(controller.text.length<4) isError=true;
//                   if(controller.text.length==4) isError=false;
//                   return null;
//
//                 },
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.digitsOnly
//                 ],
//                 pinTheme: PinTheme(
//                   shape: PinCodeFieldShape.box,
//                   borderRadius: BorderRadius.circular(16),
//                   inactiveColor: Colors.grey,
//                   activeColor:  const Color(0xFF01B763),
//                   // activeFillColor: const Color(0x1412D18E),
//                   selectedBorderWidth: 1,
//                   activeBorderWidth: 1,
//                   inactiveBorderWidth: 0,
//                   inactiveFillColor: Colors.black, // Background color of inactive fields
//                   activeFillColor: Colors.black,  // Background color of active fields
//                   selectedFillColor: Colors.black,
//                   selectedColor: const Color(0xFF01B763),
//                   fieldHeight: 50,
//                   fieldWidth: 60,
//                 ),
//                 pastedTextStyle: const TextStyle(
//                   fontSize: 24,
//                   fontFamily: 'Urbanist',
//                   color: Color(0xFF212121),
//                   fontWeight: FontWeight.w700,
//                 ),
//                 keyboardType: TextInputType.number,
//                 animationType: AnimationType.none,
//
//               ),
//               isError ? const Center(
//                 child: Text('Enter 4 digit code',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.red
//                   ),
//                 ),
//               ):const SizedBox(),
//
//               const SizedBox(height:20,),
//               const Center(
//                 child: Text('Didn\'t receive email?',
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF212121),
//                       fontFamily: 'Urbanist'
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               resendTime!=0?Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       const Text('You can resend code in ',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF212121), fontFamily: 'Urbanist'),),
//                       Text('$resendTime ',style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF01B763), fontFamily: 'Urbanist'),),
//                       const Text('s',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF212121), fontFamily: 'Urbanist'),),
//                     ],
//                   ),
//                 ],
//               ):const SizedBox(),
//               resendTime==0?InkWell(
//                 onTap: ()
//                 {
//                   setState(() {
//                     resendTime=60;
//                     controller.text.isEmpty;
//                     startTimer();
//                   });
//                 },
//                 child: const Center(child: Text('Resend',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.red),)),):const SizedBox(),
//               SizedBox(height: screenHeight <= 640 ? 105: 180),
//               Container(
//                 padding: const EdgeInsets.only(top:20,bottom: 20),
//                 decoration: const BoxDecoration(
//                     border: Border(
//                       top: BorderSide(
//                           color: Color(0xFFF5F5F5)
//                       ),
//                     )
//                 ),
//                 child: SizedBox(
//                   height: 50,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                       onPressed: (){
//                         if(controller.text.length==4) {
//                           // Navigator.push(context, MaterialPageRoute(builder: (
//                           //     context) => const ProfileScreen()));
//                         }
//                       },
//                       style:ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF01B763),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30)
//                           )
//                       ),
//                       child: const Text('Continue',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize:16,
//                           fontFamily: 'Urbanist',
//                           fontWeight:FontWeight.w700,
//                           color:Color(0xFFFFFFFF),
//                           letterSpacing: 0.2,
//                         ),
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// }
//
// class OtpVerificationScreen extends StatefulWidget {
//   final String email;
//
//   const OtpVerificationScreen({Key? key, this.email = "example@gmail.com"})
//       : super(key: key);
//   @override
//   State createState() => _OtpVerificationScreenState();
// }
//
// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   TextEditingController inputController = TextEditingController();
//   Map<String, FocusNode> focusNodes = {
//     'otp': FocusNode(),
//   };
//   String verificationCodeStr = "";
//
//   int otpLength = 4;
//   OverlayEntry? overlayEntry;
//   String errorMessage = '';
//   bool isHeight = true;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     focusNodes['otp']!.addListener(() {
//       if (Platform.isIOS) {
//         bool hasFocus = focusNodes['otp']!.hasFocus;
//         if (hasFocus) {
//           showOverlay(context);
//         } else {
//           removeOverlay();
//         }
//       }
//     });
//     // projectUtil.statusBarColor(
//     //     statusBarColor: AppColors.appStatusBarColor,
//     //     isNavigationBarDarkBrightness: true,
//     //     isAppStatusDarkBrightness: true);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     inputController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AppDimens appDimens = AppDimens();
//     appDimens.appDimensFind(context: context);
//
//     Widget resendCode = Container(
//       margin: const EdgeInsets.only(bottom: 0, top: 0),
//       child: AlreadyHaveAccountRow(
//         leftText: "Resend code in",
//         leftTextStyle: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey.shade500),
//         rightTextStyle: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: AppColors.black,
//         ),
//         rightText: " 00:48",
//         isSubtitleTextVisible: false,
//         isRightTextVisible: true,
//         subtitleTextCallBack: () {
//           // print("Hello");
//           // inputController.clear();
//         },
//       ),
//     );
//
//     verificationCode() {
//       Color fieldBackgroundColor = AppColors.textFiledColor.withOpacity(0.1);
//       Color activeBorderColor = const Color(0xff5F9DFB);
//       Color activeBackgroundColor = AppColors.textFiledColor.withOpacity(0.1);
//       Color borderColor = AppColors.textFiledColor.withOpacity(0.1);
//       Color disableBackgroundColor = AppColors.textFiledColor.withOpacity(0.1);
//
//       return Container(
//         // color: Colors.red,
//           margin: const EdgeInsets.only(bottom: 0, top: 0),
//           padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
//           child: PinCodeFields(
//             controller: inputController,
//             length: otpLength,
//             margin: const EdgeInsets.only(left: 3, right: 3),
//             fieldBorderStyle: FieldBorderStyle.Square,
//             responsive: false,
//             fieldHeight: 52.0,
//             focusNode: focusNodes['otp'],
//             fieldWidth: 52.0,
//             disableBackgroundColor: disableBackgroundColor,
//             borderWidth: 1.0,
//             padding: const EdgeInsets.only(top: 1),
//             activeBorderColor: activeBorderColor,
//             activeBackgroundColor: activeBackgroundColor,
//             borderRadius: BorderRadius.circular(10.0),
//             keyboardType: TextInputType.number,
//             autoHideKeyboard: true,
//             autofocus: false,
//             fieldBackgroundColor: fieldBackgroundColor,
//             borderColor: borderColor,
//             textStyle: const TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black),
//             onChange: (value) {
//               verificationCodeStr = value;
//               // print("$value### $verificationCodeStr");
//             },
//             onComplete: (output) {
//               //setState(() {
//               verificationCodeStr = output;
//               if (verificationCodeStr != "" &&
//                   verificationCodeStr.length == otpLength) {
//                 setState(() {
//                   errorMessage = '';
//                 });
//                 FocusScope.of(context).requestFocus(FocusNode());
//               }
//               // });
//               // Your logic with pin code
//               //print("${output}Final $verificationCodeStr");
//             },
//           ));
//     }
//
//     Widget otpErrorMsg = (errorMessage != '')
//         ? Container(
//         alignment: Alignment.center,
//         height: 16,
//         child: Text(
//           errorMessage,
//           style: appStyles.errorStyle(),
//         ))
//         : Container(
//       height: 5,
//     );
//
//     Widget topText() {
//       return Container(
//         margin: const EdgeInsets.only(left: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Verify Code",
//               textAlign: TextAlign.center,
//               style: appStyles.onBoardingTitleStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 texColor: Colors.black,
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               "Please enter the code we just sent to email ${widget.email}",
//               textAlign: TextAlign.start,
//               style: appStyles.onBoardingTitleStyle(
//                 fontSize: 16,
//                 height: 1.3,
//                 fontWeight: FontWeight.w400,
//                 texColor: Colors.grey.shade500,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     // continue button
//     continueButton() {
//       return Container(
//         margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
//         child: AppButton(
//           buttonName: AppString.trans(context, AppString.continueBt),
//           backCallback: () {
//             if (verificationCodeStr != '' &&
//                 verificationCodeStr.trim().length == otpLength) {
//               FocusScope.of(context).requestFocus(FocusNode());
//               setState(() {
//                 errorMessage = '';
//               });
//
//               Navigator.push(
//                   context,
//                   SlideRightRoute(
//                     widget: const NewPasswordScreen(),
//                   ));
//
//             } else {
//               setState(() {
//                 if (verificationCodeStr == '') {
//                   errorMessage =
//                       AppString.trans(context, AppString.pleaseEnterOtp);
//                 } else {
//                   errorMessage =
//                       AppString.trans(context, AppString.pleaseEnterCorrectOtp);
//                 }
//               });
//             }
//           },
//         ),
//       );
//     }
//
//     return ContainerFirst(
//       reverse: false,
//       contextCurrentView: context,
//       isSingleChildScrollViewNeed: true,
//       isFixedDeviceHeight: true,
//       appBarHeight: 50,
//       appBar: const CommonAppBar(
//         title: "",
//         icon: WorkplaceIcons.backArrow,
//       ),
//       containChild: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           topText(),
//           const SizedBox(height: 30),
//           verificationCode(),
//           otpErrorMsg,
//           resendCode,
//           const SizedBox(
//             height: 10,
//           ),
//           continueButton(),
//         ],
//       ),
//     );
//   }
//
//   //for ios done button callback
//   onPressCallback() {
//     removeOverlay();
//     FocusScope.of(context).requestFocus(FocusNode());
//   }
//
//   //for keyboard done button
//   showOverlay(BuildContext context) {
//     if (overlayEntry != null) return;
//     OverlayState overlayState = Overlay.of(context);
//     overlayEntry = OverlayEntry(builder: (context) {
//       return Positioned(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           right: 0.0,
//           left: 0.0,
//           child: InputDoneView(
//             onPressCallback: onPressCallback,
//             buttonName: "Done",
//           ));
//     });
//
//     overlayState.insert(overlayEntry!);
//   }
//
//   removeOverlay() {
//     if (overlayEntry != null) {
//       overlayEntry!.remove();
//       overlayEntry = null;
//     }
//   }
// }
