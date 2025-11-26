import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/util/local_constant.dart';
import '../../../core/util/pref_util.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import '../bloc/my_unit_bloc.dart';

class RazorpayService {
  final BuildContext context;
  late Razorpay _razorpay;
  final MyUnitBloc myUnitBloc; // Add reference to MyUnitBloc

  double fee = 0.0;
  double gst = 0.0;
  double totalAmount = 0.0;

  RazorpayService(this.context,this.myUnitBloc) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  /// Calculate Razorpay Fee + GST
  void calculateCharges(double amount, gstPercentage, feePercentage) {
    fee = amount * feePercentage;
    gst = fee * gstPercentage;
    totalAmount = amount + fee + gst;
  }

  /// Open Razorpay Checkout with all fields and custom notes
  void openCheckout({
    required double baseAmount,
    required String name,
    required String description,
    required String contact,
    required String email,
    required String paymentAttemptId,
    required String houseId,
    required String houseName,
    required double gst,
    required double platformFee,
  }) {
    calculateCharges(baseAmount, gst, platformFee);

    int amountInPaise = (totalAmount * 100).round(); // Razorpay accepts amount in paise

    var options = {
      'key': 'rzp_test_kCBitoAJmUO98c',
      // TODO: Replace with live key for production
      'amount': amountInPaise,
      'name': name,
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'notes': {
        'payment_attempt_id': paymentAttemptId,
        'house_id': houseId,
        'house_name': houseName,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e, stack) {
      _showDialog(
        title: 'Payment Error',
        message: 'Unable to open Razorpay checkout. Please try again.',
        isSuccess: false,
      );
    }
  }



  void openCheckout2({
    required double baseAmount,
    required String name,
    required String razorPayKey,
    required String description,
    required String contact,
    required String email,
    required String paymentAttemptId,
    required String houseId,
    required String houseName,
    required double gst,
    required double platformFee,
    bool upi = false,
    bool card = false,
    bool netBanking = false,
    bool wallet = false,
    bool emi = false,
    bool payLater = false,

  }) async {
    calculateCharges(baseAmount, gst, platformFee);
    int amountInPaise = (totalAmount * 100).round(); // Razorpay accepts amount in paise

    var options = {
      'key': razorPayKey,
      'amount': amountInPaise,
      'name': name,
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'notes': {
        'payment_attempt_id': paymentAttemptId,
        'house_id': houseId,
        'house_name': houseName,
      },
      'method': {
        'upi': upi,
        'card': card,
        'netbanking': netBanking,
        'wallet': wallet,
        'emi': emi,
        'paylater': payLater,
      },
    };

    // ✅ Show loader dialog
    showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.35),
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(milliseconds: 300)); // Small delay for UI smoothness

    try {
      _razorpay.open(options);
    } catch (e, stack) {
      Navigator.of(context).pop(); // ❌ Hide loader on error
      _showDialog(
        title: 'Payment Error',
        message: 'Unable to open Razorpay checkout. Please try again.',
        isSuccess: false,
      );
    }

    // ✅ Always close the loader (even if Razorpay loads in-app browser)
    Future.delayed(const Duration(seconds: 1), () {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }



  /// Handle payment success callback
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    int paymentAttemptId = await PrefUtils().readInt(WorkplaceNotificationConst.paymentAttemptId);
    String responseMessage = "Payment successful with Payment ID: ${response.paymentId}";

    myUnitBloc.add(OnPaymentSuccessEvent(
      gatewayTransactionId:response.paymentId.toString(),
      id: paymentAttemptId,
      mContext: context,
      responseMessage: responseMessage?? "Unknown error",
    ));


    // TODO: Send success data to backend if needed
  }

  /// Handle payment failure callback
  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    int paymentAttemptId = await PrefUtils().readInt(WorkplaceNotificationConst.paymentAttemptId);

    myUnitBloc.add(OnPaymentCancelEvent(
      id: paymentAttemptId,
      mContext: context,
      responseMessage: response.message ?? "Unknown error",
    ));

    // TODO: Optionally log or retry
  }

  /// Handle external wallet selection
  void _handleExternalWallet(ExternalWalletResponse response) {

    WorkplaceWidgets.errorSnackBar(context, 'External Wallet Selected: ${response.walletName}');
  }

  /// Show Alert Dialog for feedback
  void _showDialog({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
