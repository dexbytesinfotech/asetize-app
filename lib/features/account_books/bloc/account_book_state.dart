
abstract class AccountBookState {}

class AccountBookInitialState extends AccountBookState {}


class AccountBookLoadingState extends AccountBookState {
  final String? loadingButton;
  AccountBookLoadingState({this.loadingButton,});
}
class ExpensesRejectLoadingState extends AccountBookState {}
class UploadVoucherImageLoadingState extends AccountBookState {}
class VoucherNumberLoadingState extends AccountBookState {}
class ExpensesApprovedLoadingState extends AccountBookState {}

class FetchGeneratedVoucherLoadingState extends AccountBookState {}


class SentOtpForMobileNumberVerificationLoadingState extends AccountBookState {}
class OnResendOtpForMobileNumberVerificationLoadingState extends AccountBookState {}
class OtpVerificationLoadingState extends AccountBookState {}
class DeletePayeeLoadingState extends AccountBookState {}
class GetExpenseDetailLoadingState extends AccountBookState {}

class DeleteExpenseLoadingState extends AccountBookState {}

class PaymentReceiptForAccountedLoadingState extends AccountBookState {}


class AccountBookOnLoadLoadingState extends AccountBookState {
  final String? isVerified;
  AccountBookOnLoadLoadingState({ this.isVerified,});
}


class AddExpensesLoadingState extends AccountBookState {}
class AccountBookErrorState extends AccountBookState {
  final String errorMessage;
  AccountBookErrorState({required this.errorMessage,});
}class FetchGeneratedVoucherErrorState extends AccountBookState {
  final String errorMessage;
  FetchGeneratedVoucherErrorState({required this.errorMessage,});
}
class UploadVoucherImageErrorState extends AccountBookState {
  final String errorMessage;
  UploadVoucherImageErrorState({required this.errorMessage,});
}

class GetExpenseDetailErrorState extends AccountBookState {
  final String errorMessage;
  GetExpenseDetailErrorState({required this.errorMessage,});
}
class DeleteExpenseErrorState extends AccountBookState {
  final String errorMessage;
  DeleteExpenseErrorState({required this.errorMessage,});
}
class ExpensesRejectErrorState extends AccountBookState {
  final String errorMessage;
  ExpensesRejectErrorState({required this.errorMessage,});
}class ExpensesApprovedErrorState extends AccountBookState {
  final String errorMessage;
  ExpensesApprovedErrorState({required this.errorMessage,});
}
class OtpVerificationErrorState extends AccountBookState {
  final String errorMessage;
  OtpVerificationErrorState({required this.errorMessage,});
}
class OnResendOtpForMobileNumberVerificationErrorState extends AccountBookState {
  final String errorMessage;
  OnResendOtpForMobileNumberVerificationErrorState({required this.errorMessage,});
}
class SentOtpForMobileNumberVerificationErrorState extends AccountBookState {
  final String errorMessage;
  SentOtpForMobileNumberVerificationErrorState({required this.errorMessage,});
}


class PrintStatementLoadingState extends AccountBookState {}

class PayeeListLoadingState extends AccountBookState {}

class UpdatePreExpenseLoadingState extends AccountBookState {}

class UpdatePreExpenseErrorState extends AccountBookState {
  final String errorMessage;
  UpdatePreExpenseErrorState({required this.errorMessage});
}

class UpdatePreExpenseDoneState extends AccountBookState {
  final String message;
  UpdatePreExpenseDoneState({required this.message});
}class FetchGeneratedVoucherDoneState extends AccountBookState {
  final String message;
  FetchGeneratedVoucherDoneState({required this.message});
}

class AddNewPayeeLoadingState extends AccountBookState {}

class UpdatePayeeLoadingState extends AccountBookState {}

class PayeeListErrorState extends AccountBookState {
  final String errorMessage;
  PayeeListErrorState({required this.errorMessage});
}
class DeletePayeeErrorState extends AccountBookState {
  final String errorMessage;
  DeletePayeeErrorState({required this.errorMessage});
}

class AddNewPayeeErrorState extends AccountBookState {
  final String errorMessage;
  AddNewPayeeErrorState({required this.errorMessage});
}
class UpdatePayeeErrorState extends AccountBookState {
  final String errorMessage;
  UpdatePayeeErrorState({required this.errorMessage});
}

class VoucherNumberErrorState extends AccountBookState {
  final String errorMessage;
  VoucherNumberErrorState({required this.errorMessage});
}

class PayeeListDoneState extends AccountBookState {
  final String message;
  PayeeListDoneState({required this.message});
}
class UploadVoucherImageDoneState extends AccountBookState {
  final String filePath;
  UploadVoucherImageDoneState({required this.filePath});
}

class UploadVoucherFromDetailDoneState extends AccountBookState {
  final String message;
  UploadVoucherFromDetailDoneState({required this.message});
}

class VoucherNumberDoneState extends AccountBookState {
  final String message;
  VoucherNumberDoneState({required this.message});
}
class GetExpenseDetailDoneState extends AccountBookState {
  final String message;
  GetExpenseDetailDoneState({required this.message});
}

class ExpensesRejectDoneState extends AccountBookState {
  final String message;
  ExpensesRejectDoneState({required this.message});
}class DeleteExpenseDoneState extends AccountBookState {
  final String message;
  DeleteExpenseDoneState({required this.message});
}

class ExpensesApprovedDoneState extends AccountBookState {
  final String message;
  ExpensesApprovedDoneState({required this.message});
}

class OnResendOtpForMobileNumberVerificationDoneState extends AccountBookState {
  final String message;
  OnResendOtpForMobileNumberVerificationDoneState({required this.message});
}
class OtpVerificationDoneState extends AccountBookState {
  final String message;
  final bool? isMobileNumberUpdate;
  OtpVerificationDoneState({required this.message, this.isMobileNumberUpdate });
}

class SentOtpForMobileNumberVerificationDoneState extends AccountBookState {
  final String message;
  final String mobileNumber;
  final bool? isMobileNumberUpdate;


  SentOtpForMobileNumberVerificationDoneState({required this.message, required this.mobileNumber,this.isMobileNumberUpdate });
}
class DeletePayeeDoneState extends AccountBookState {
  final String message;
  DeletePayeeDoneState({required this.message});
}

class UpdatePayeeDoneState extends AccountBookState {
  final String message;
  UpdatePayeeDoneState({required this.message});
}


class AddNewPayeeDoneState extends AccountBookState {
  final String message;
  final int id; // or String, depending on API

  AddNewPayeeDoneState({required this.message, required this.id});
}



class PrintStatementErrorState extends AccountBookState {
  final String errorMessage;
  PrintStatementErrorState({required this.errorMessage});
}
class PrintStatementDoneState extends AccountBookState {
  final String message;
  PrintStatementDoneState({required this.message});
}
class AddExpensesDoneState extends AccountBookState {
  final String message;
  final bool isSave;
  AddExpensesDoneState({required this.message, this.isSave = false});
}

class PaymentReceiptForAccountedErrorState extends AccountBookState {
  final String errorMessage;
  PaymentReceiptForAccountedErrorState({required this.errorMessage,});
}
class AccountBookErrorStateForPaymentConfirmation extends AccountBookState {
  final String errorMessage;
  AccountBookErrorStateForPaymentConfirmation({required this.errorMessage});
}
class AccountBookErrorStateForPaymentReject extends AccountBookState {
  final String errorMessage;
  AccountBookErrorStateForPaymentReject({required this.errorMessage});
}
class AccountBookErrorAddPaymentState extends AccountBookState {
  final String errorMessage;
  AccountBookErrorAddPaymentState({required this.errorMessage});
}
class SubmitCasePaymentError extends AccountBookState {
  final String errorMessage;
  SubmitCasePaymentError({required this.errorMessage});
}
class FetchedExpensesCategoryDoneState extends AccountBookState {}
class FetchedPaymentMethodDoneState extends AccountBookState {}
// class AddExpensesDoneState extends AccountBookState {}
class FetchAccountBookSummaryDoneState extends AccountBookState {}
// class FetchAccountBookHistoryDoneState extends AccountBookState {}



class FetchAccountBookHistoryDoneState extends AccountBookState {
  final String? isVerified;
  FetchAccountBookHistoryDoneState({ this.isVerified,});
}
class FetchAccountBookHistoryDetailDoneState extends AccountBookState {}
class CasePaymentDoneState extends AccountBookState {}
class PaymentReceiptForAccountedDoneState extends AccountBookState {}
class AddTransactionReceiptDoneState extends AccountBookState {}
class GetPendingListDoneState extends AccountBookState {}
class ApprovedSharedConfirmDoneState extends AccountBookState {}
class RejectSharedConfirmDoneState extends AccountBookState {}
class ApplyFilterOnPendingDoneState extends AccountBookState {}

