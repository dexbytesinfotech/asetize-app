// ignore_for_file: prefer_const_constructors

import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:asetize/core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../bloc/new_signup_bloc.dart';
import '../bloc/new_signup_event.dart';
import '../bloc/new_signup_state.dart';
import 'add_home_form.dart';
import 'complete_profile_form_screen.dart';

class OtpScreen extends StatefulWidget {
  final String? emailID;
  final String? mobileNumber;
  final String token;
  final bool? isEmailScreen;
  final bool? isSocietyNotFound;

  const OtpScreen(this.token,
      {super.key,
        this.emailID,
        this.mobileNumber,
        this.isEmailScreen,
        this.isSocietyNotFound});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _pinCodeFocusNode = FocusNode(); // Add FocusNode
  bool isError = false;
  int resendTime = 60;
  late Timer countdownTimer;
  late NewSignupBloc newSignupBloc;
  late ValueNotifier<int> resendTimeNotifier;

  @override
  void dispose() {
    try {
      controller.dispose();
      _pinCodeFocusNode.dispose(); // Dispose FocusNode
      countdownTimer.cancel();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  void initState() {
    newSignupBloc = BlocProvider.of<NewSignupBloc>(context);
    super.initState();
    resendTimeNotifier = ValueNotifier<int>(resendTime);
    startTimer();
    // Request focus on the PinCodeTextField after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_pinCodeFocusNode);
    });
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimeNotifier.value > 0) {
        resendTimeNotifier.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    Widget verifyButton(state) {
      return Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: AppButton(
          isLoader: state is SignupLoadingState ? true : false,
          buttonName: AppString.verify,
          buttonColor: (controller.text.length == 4)
              ? AppColors.textBlueColor
              : Colors.grey,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          backCallback: () {
            if (controller.text.length == 4) {
              newSignupBloc.add(OnVerifyOtpEvent(widget.token,
                  otp: controller.text.toString(), mContext: context));
            }
          },
        ),
      );
    }

    return BlocBuilder<NewSignupBloc, NewSignupState>(
      bloc: newSignupBloc,
      builder: (context, state) {
    return AbsorbPointer(
      absorbing: state is SignupLoadingState, // Block interactions when loading
      child: ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        isOverLayStatusBar: false,
        appBarHeight: 56,
        appBar: const CommonAppBar(
          title: '',
          icon: WorkplaceIcons.backArrow,
        ),
        containChild: BlocListener<NewSignupBloc, NewSignupState>(
            listener: (context, state) {

              if (state is GuestOtpVeifyErrorState) {
                WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
              }
              if (state is GuestResendOtpErrorState) {
                WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
              }
              if (state is GuestOtpVerifyDoneState) {
                if (state.isCompleteProfile == false) {
                  PrefUtils().saveBool(WorkplaceNotificationConst.isEmailScreen,
                      widget.isEmailScreen);

                  Navigator.pushReplacement(
                    context,
                    SlideLeftRoute(
                      widget: CompleteProfileScreen(
                        isSocietyNotFound: widget.isSocietyNotFound,
                      ),
                    ),
                  );
                } else {
                  if (state.isCompanyIdSaved == true) {
                    PrefUtils().saveBool(
                        WorkplaceNotificationConst.isUserLoggedInC, true);
                    context.go('/dashBoard');
                  } else {
                    Navigator.push(
                      context,
                      SlideLeftRoute(
                        widget: const SearchYourSocietyForm(),
                      ),
                    );
                  }
                }
                return;
              }

              if (state is GuestResendOtpDoneState) {}
            },
            child: BlocBuilder<NewSignupBloc, NewSignupState>(
              bloc: newSignupBloc,
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 15),
                            const Text(
                              AppString.oTPVerification,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              widget.mobileNumber == null
                                  ? AppString.otpText
                                  : AppString.otpTextForMobile,
                              style: appTextStyle.appTitleStyle(
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.mobileNumber ?? widget.emailID ?? "",
                                  style: appTextStyle.appTitleStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () {
                                    countdownTimer.cancel();
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.edit,
                                      size: 18, color: AppColors.appBlueColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            PinCodeTextField(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              appContext: context,
                              length: 4,
                              controller: controller,
                              focusNode: _pinCodeFocusNode, // Assign FocusNode
                              onChanged: (value) {
                                setState(() {
                                  isError = value.length < 4;
                                });
                                if (value.length == 4) {
                                  newSignupBloc.add(OnVerifyOtpEvent(
                                    widget.token,
                                    otp: value,
                                    mContext: context,
                                  ));
                                }
                              },
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(8),
                                fieldHeight: 60,
                                fieldWidth: 60,
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.white,
                                selectedFillColor: Colors.white,
                                activeColor: AppColors.appBlueColor,
                                inactiveColor: Colors.black54,
                                inactiveBorderWidth: 0.6,
                                activeBorderWidth: 1.3,
                                selectedColor: AppColors.appBlueColor,
                                selectedBorderWidth: 0.8,
                              ),
                              keyboardType: TextInputType.number,
                              enableActiveFill: true,
                              animationType: AnimationType.fade,
                              autovalidateMode: AutovalidateMode.disabled,
                              validator: null,
                            ),
                            const SizedBox(height: 15),
                            if (isError)
                              const Center(
                                child: Text(
                                  AppString.enterDigitCode,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            Text(
                              AppString.didNotReceiveTheCode,
                              style: appTextStyle.appTitleStyle(),
                            ),
                            const SizedBox(height: 2),
                            ValueListenableBuilder<int>(
                              valueListenable: resendTimeNotifier,
                              builder: (context, value, child) {
                                return value > 0
                                    ? Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppString.youCanResendCode,
                                      style:
                                      appTextStyle.appLargeTitleStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      '$value s',
                                      style:
                                      appTextStyle.appLargeTitleStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xFF01B763),
                                      ),
                                    ),
                                  ],
                                )
                                    : InkWell(
                                  onTap: () {
                                    newSignupBloc.add(OnGuestResendOtpEvent(
                                        mContext: context,
                                        token: widget.token));
                                    setState(() {
                                      controller.clear();
                                      resendTimeNotifier = ValueNotifier<
                                          int>(
                                          resendTime); // Reset timer
                                      startTimer();
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      AppString.reSendOtp,
                                      style:
                                      appTextStyle.appLargeTitleStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: screenHeight <= 640 ? 105 : 100),
                            verifyButton(state)
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  },
);
  }
}