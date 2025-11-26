// import 'package:asetize/features/new_sign_up/pages/sign_up_otp_screen.dart';
// import '../../../core/util/app_theme/text_style.dart';
// import '../../../imports.dart';
// import '../bloc/new_signup_bloc.dart';
// import '../bloc/new_signup_event.dart';
// import '../bloc/new_signup_state.dart';
// import 'new_login_with_email_screen.dart';
//
// class LoginWithMobileNumberScreen extends StatefulWidget {
//   const LoginWithMobileNumberScreen({super.key});
//
//   @override
//   State<LoginWithMobileNumberScreen> createState() =>
//       _LoginWithMobileNumberScreenState();
// }
//
// class _LoginWithMobileNumberScreenState
//     extends State<LoginWithMobileNumberScreen> {
//   bool isShowLoader = true;
//   late NewSignupBloc newSignupBloc;
//   String countryCode = "";
//
//
//   Map<String, TextEditingController> controllers = {
//     'phoneNumber': TextEditingController(),
//   };
//
//   Map<String, FocusNode> focusNodes = {
//     'phoneNumber': FocusNode(),
//   };
//
//   Map<String, String> errorMessages = {
//     'phoneNumber': "",
//   };
//
//   final RegExp _phoneNumberRegex = RegExp(r'^\d{10}$');
//
//   @override
//   void initState() {
//     newSignupBloc = BlocProvider.of<NewSignupBloc>(context);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     controllers['phoneNumber']?.dispose();
//     super.dispose();
//   }
//
//   Widget topIcon() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.asset(WorkplaceIcons.appLogoImage,
//             width: MediaQuery.of(context).size.shortestSide * 0.62)
//       ],
//     );
//   }
//
//   checkPhoneNumber(value, {onchange = false}) {
//     if (Validation.isNotEmpty(value.trim())) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           if (_phoneNumberRegex.hasMatch(value.trim())) {
//             errorMessages['phoneNumber'] = "";
//           } else {
//             if (!onchange) {
//               errorMessages['phoneNumber'] =
//                   AppString.phoneNumberMustBe10Digits;
//             }
//           }
//         });
//       });
//     } else {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           if (!onchange) {
//             errorMessages['phoneNumber'] = AppString.phoneNumberRequired;
//           }
//         });
//       });
//     }
//   }
//
//   //Phone field
//   phoneNumber() {
//     return Container(
//       margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
//       width: MediaQuery.of(context).size.width,
//       child: CommonTextFieldWithError(
//         focusNode: focusNodes['phoneNumber'],
//         isShowBottomErrorMsg: true,
//         errorMessages: errorMessages['phoneNumber']?.toString() ?? '',
//         controllerT: controllers['phoneNumber'],
//         borderRadius: 8,
//         inputHeight: 50,
//         errorLeftRightMargin: 0,
//         maxCharLength: 10,
//         errorMsgHeight: 24,
//         autoFocus: false,
//         showError: true,
//         capitalization: CapitalizationText.none,
//         cursorColor: Colors.grey,
//         inputFormatter: [
//           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//         ],
//         placeHolderTextWidget: Padding(
//             padding: const EdgeInsets.only(left: 3.0,
//               bottom: 10,
//               top: 5,),
//             child: Text.rich(
//               TextSpan(
//                 text: AppString.pleaseEnterYourPhoneNumber,
//                 style: appStyles.texFieldPlaceHolderStyle(),
//                 children: [
//                   TextSpan(
//                     text: ' *',
//                     style: appStyles
//                         .texFieldPlaceHolderStyle()
//                         .copyWith(color: Colors.red),
//                   ),
//                 ],
//               ),
//               textAlign: TextAlign.start,
//             )),
//         enabledBorderColor: AppColors.white,
//         focusedBorderColor: AppColors.white,
//         backgroundColor: AppColors.white,
//         textInputAction: TextInputAction.done,
//         borderStyle: BorderStyle.solid,
//         inputKeyboardType: InputKeyboardTypeWithError.phone,
//         hintText: AppString.enterYourPhoneNumber,
//         hintStyle: appStyles.hintTextStyle(),
//         textStyle: appStyles.textFieldTextStyle(),
//         contentPadding: const EdgeInsets.only(left: 15, right: 15),
//         inputFieldPrefixIcon: CountryCodePicker(
//           showFlag: false,
//           enabled: false,
//           textStyle: appStyles.textFieldTextStyle(),
//           padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 10),
//           initialSelection: 'IN',
//           onChanged: (value) {
//             // countryCode = value.dialCode!.trim();
//           },
//           onInit: (value) {
//            // countryCode = value!.dialCode!.trim();
//           },
//         ),
//         onTextChange: (value) {
//           checkPhoneNumber(value, onchange: true);
//         },
//         onEndEditing: (value) {
//           checkPhoneNumber(value);
//           FocusScope.of(context).unfocus();
//         },
//       ),
//     );
//   }
//
//
//   bool validateFields({bool isButtonClicked = false}) {
//     // bool isValid = true;
//     // if (controllers['email']!.text.isEmpty ||
//     //     controllers['email']!.text == '') {
//     //   if (isButtonClicked) {
//     //     errorMessages['email'] =
//     //         AppString.trans(context, AppString.emailHintError);
//     //   }
//     //   isValid = false;
//     // }
//     if (controllers['phoneNumber']?.text.length != 10) {
//       if (isButtonClicked) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) {
//             FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
//             setState(() {
//               errorMessages['phoneNumber'] =
//                   AppString.phoneNumberMustBe10Digits;
//             });
//           }
//         });
//       }
//       return false;
//     } else {
//       return true;
//     }
//   }
//
//   Widget sendOTPButton() {
//     return Container(
//       margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
//       child: AppButton(
//         buttonName: AppString.sendOtp,
//         buttonColor: (validateFields(isButtonClicked: true))
//             ? AppColors.textBlueColor
//             : Colors.grey, // Button color based on validation
//         textStyle: appStyles.buttonTextStyle1(
//           texColor: AppColors.white,
//         ),
//         backCallback: () {
//           FocusScope.of(context).unfocus();
//           if (validateFields(isButtonClicked: true)) {
//             newSignupBloc.add(LoginUsingMobileEvent(
//                 mobileNumber: controllers['phoneNumber']!.text.toString(),
//                 mContext: context, countryCode: "91"));
//           } else {
//
//           }
//         },
//       ),
//     );
//   }
//   Widget divider() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10, bottom: 18, left: 20, right: 20),
//       child: Row(
//         children: [
//           const Expanded(
//               child: Divider(
//                 thickness: 0,
//               )),
//           const SizedBox(
//             width: 6,
//           ),
//           Text(
//             AppString.or,
//             style: appTextStyle.appSubTitleStyle(
//                 color: Colors.black.withOpacity(0.6),
//                 fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(
//             width: 6,
//           ),
//           const Expanded(
//               child: Divider(
//                 thickness: 0,
//               )),
//         ],
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return ContainerFirst(
//       appBackgroundColor: AppColors.white,
//       contextCurrentView: context,
//       isSingleChildScrollViewNeed: true,
//       isFixedDeviceHeight: false,
//       appBarHeight: 50,
//       containChild: BlocListener<NewSignupBloc, NewSignupState>(
//           listener: (context, state) {
//             if (state is LoginUsingMobileDoneState) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => OtpScreen(
//                       state.token,
//                       mobileNumber: controllers['phoneNumber']?.text.toString(),
//                     )),
//               );
//             }
//             if (state is LoginUsingMobileErrorState) {
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text(state.errorMessage),
//                 backgroundColor: Colors.red,
//               ));
//             }
//           },
//           child: BlocBuilder<NewSignupBloc, NewSignupState>(
//             bloc: newSignupBloc,
//             builder: (context, state) {
//               return SingleChildScrollView(
//                 child: Stack(
//                   children: [
//                     Column(
//                       children: [
//                         topIcon(),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         phoneNumber(),
//                         divider(),
//                         InkWell(
//                             onTap: () {
//                               FocusScope.of(context).unfocus();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const NewLoginWithEmail()),
//                               );
//                             },
//                             child: Text(
//                               AppString.loginWithEmail,
//                               style: appStyles.highlightTextStyle(),
//                             )),
//                         const SizedBox(
//                           height: 50,
//                         ),
//                         sendOTPButton(),
//                       ],
//                     ),
//                     if (state is SignupLoadingState)
//                       Center(
//                         child: WorkplaceWidgets.progressLoader(context),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           )),
//     );
//   }
// }
