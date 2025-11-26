import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_dimens.dart';
import '../../../core/util/app_theme/app_fonts.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/app_style.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../presentation/widgets/app_button_common.dart';
import '../bloc/account_book_bloc.dart';
import '../bloc/account_book_state.dart';

class OtpPopup extends StatefulWidget {
  final String? emailID;
  final String? mobileNumber;
  final VoidCallback onEdit;
  final Function(String otp) onVerify;
  final VoidCallback onResend;

  const OtpPopup({
    super.key,
    this.emailID,
    this.mobileNumber,
    required this.onEdit,
    required this.onVerify,
    required this.onResend,
  });

  @override
  State<OtpPopup> createState() => _OtpPopupState();
}

class _OtpPopupState extends State<OtpPopup> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final int _resendTimeStart = 60;

  bool isError = false;
  late ValueNotifier<int> _resendTimeNotifier;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _resendTimeNotifier = ValueNotifier<int>(_resendTimeStart);
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _countdownTimer?.cancel();
    _resendTimeNotifier.dispose();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimeNotifier.value > 0) {
        _resendTimeNotifier.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Widget verifyButton(bool isLoading) {
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: AppButton(
        isLoader: isLoading, // Use dynamic isLoading value from BlocBuilder
        buttonName: AppString.verify,
        buttonColor: (_controller.text.length == 6)
            ? AppColors.textBlueColor
            : Colors.grey,
        textStyle: appStyles.buttonTextStyle1(
          texColor: AppColors.white,
        ),
        backCallback: () async {
          if (_controller.text.length == 6) {
            await widget.onVerify(_controller.text);
          } else {
            setState(() => isError = true);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<AccountBookBloc, AccountBookState>(
          builder: (context, state) {
            // Determine isLoading based on the current state
            bool isLoading = state is OtpVerificationLoadingState;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "OTP Verification",
                  style: appStyles.titleStyle(
                    fontSize: AppDimens().fontSize(value: 24),
                    fontWeight: FontWeight.w500,
                    texColor: AppColors.black,
                    fontFamily: AppFonts().defaultFont,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.mobileNumber == null
                      ? "Enter the 6-digit code sent to your email"
                      : "Enter the 6-digit code sent to your mobile",
                  style: appStyles.subTitleStyle(
                    fontSize: AppDimens().fontSize(value: 16),
                    fontWeight: FontWeight.w200,
                    texColor: AppColors.black,
                    fontFamily: AppFonts().defaultFont,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.mobileNumber ?? widget.emailID ?? "",
                      style: appStyles.subTitleStyle(
                        fontSize: AppDimens().fontSize(value: 16),
                        fontWeight: FontWeight.w500,
                        texColor: AppColors.black,
                        fontFamily: AppFonts().defaultFont,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                const SizedBox(height: 20),
                PinCodeTextField(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  appContext: context,
                  length: 6,
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    setState(() {
                      isError = value.length < 6;
                    });
                  },
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 50,
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
                ),
                if (isError)
                  const Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      "Please enter a 6-digit code",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 5),
                const Text("Didn’t receive the code?"),
                const SizedBox(height: 2),
                ValueListenableBuilder<int>(
                  valueListenable: _resendTimeNotifier,
                  builder: (context, value, child) {
                    return value > 0
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "You can resend code in ",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          "$value s",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF01B763),
                          ),
                        ),
                      ],
                    )
                        : InkWell(
                      onTap: () {
                        widget.onResend();
                        _controller.clear();
                        _resendTimeNotifier.value = _resendTimeStart;
                        _startTimer();
                      },
                      child: Text(
                        "Resend OTP",
                        style: appTextStyle.appLargeTitleStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                verifyButton(isLoading), // Pass the dynamic isLoading value
              ],
            );
          },
        ),
      ),
    );
  }
}