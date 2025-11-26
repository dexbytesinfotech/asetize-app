import '../../../imports.dart';

abstract class AccountBookEvent {}

class FetchExpensesCategoryEvent extends AccountBookEvent {
  final BuildContext mContext;
  FetchExpensesCategoryEvent({required this.mContext});
}
class FetchPaymentMethodEvent extends AccountBookEvent {
  final BuildContext mContext;
  FetchPaymentMethodEvent({required this.mContext});
}


class OnGetPayeeListEvent extends AccountBookEvent {
  final BuildContext mContext;
  OnGetPayeeListEvent({required this.mContext});
}


class OnGetVoucherNumberEvent extends AccountBookEvent {
  final BuildContext mContext;
  OnGetVoucherNumberEvent({required this.mContext});
}
class AddExpenseEvent extends AccountBookEvent {
  final BuildContext mContext;
  final int categoryId;
  final bool isSave;
  final String description;
  final String amount;
  final String expenseDate;
  final String paymentMode;
  final int? beneficiaryId;
  final String voucherNumber;
  final String? otherDetails;
  final String? chequeNumber;
  final String? triggeredBy;
  final String? filePath;
  final bool? isComingFromAccountBook;


  AddExpenseEvent({
    required this.mContext,
    required this.categoryId,
    required this.description,
    this.isSave = false,
    required this.amount,
    required this.expenseDate,
    required this.paymentMode,
    required this.beneficiaryId,
    this.voucherNumber = '',
    this.otherDetails,
    this.chequeNumber,
    this.triggeredBy,
    this.filePath,
    this.isComingFromAccountBook
  });
}


class OnUpdateExpenseEvent extends AccountBookEvent {
  final BuildContext mContext;
  final int id;
  final int categoryId;
  final bool isSave;
  final String description;
  final String amount;
  final String expenseDate;
  final String paymentMode;
  final int? beneficiaryId;
  final String voucherNumber;
  final String? otherDetails;
  final String? chequeNumber;
  final String? triggeredBy;
  final String? filePath;


  OnUpdateExpenseEvent({
    required this.mContext,
    required this.id,
    required this.categoryId,
    required this.description,
    this.isSave = false,
    required this.amount,
    required this.expenseDate,
    required this.paymentMode,
    required this.beneficiaryId,
    this.voucherNumber = '',
    this.otherDetails,
    this.chequeNumber,
    this.triggeredBy,
    this.filePath
  });
}

class FetchAccountBookSummaryEvent extends AccountBookEvent {
  final BuildContext mContext;
  final String filterName;
  final String startDate;
  final String endDate;

  FetchAccountBookSummaryEvent({required this.mContext, required this.filterName,required this.startDate, required this.endDate,});
}
class FetchAccountBookHistoryEvent extends AccountBookEvent {
  final BuildContext mContext;
  final String filterName;
  final String startDate;
  final String endDate;
  final String? paymentType;
  final String isVerified;
  FetchAccountBookHistoryEvent({required this.mContext, required this.filterName,required this.startDate, required this.endDate, this.paymentType,this.isVerified = '1'});
}
class OnPrintStatementEvent extends AccountBookEvent {
  final BuildContext mContext;
  final String? startDate;
  final String? endDate;
  OnPrintStatementEvent({required this.mContext, this.startDate,  this.endDate,});
}
class FetchAccountBookHistoryOnLoadEvent extends AccountBookEvent {
  final BuildContext mContext;
  final String filterName;
  final String startDate;
  final String endDate;
  final String? paymentType;
  final String isVerified;
  FetchAccountBookHistoryOnLoadEvent({required this.mContext, required this.filterName,required this.startDate, required this.endDate,this.paymentType, this.isVerified = '1'});
}
class FetchAccountBookHistoryDetailEvent extends AccountBookEvent {
  final BuildContext mContext;
  final int id;
  final String tableName;
  FetchAccountBookHistoryDetailEvent({required this.mContext,required this.id, required this.tableName});
}
class SubmitCasePaymentEvent extends AccountBookEvent {
  final BuildContext? mContext;
  final String? houseId;
  final String? amount;
  final String? paymentMethod;
  final String? receiptNumber;
  final String? transactionDate;
  final String? transactionTime;
  final int? isSentReceipt;
  SubmitCasePaymentEvent({this.mContext, required this.houseId,required this.amount,this.paymentMethod,this.receiptNumber,this.transactionDate,this.isSentReceipt, this.transactionTime});
}
class SubmitTransactionReceipt extends AccountBookEvent {
  final String houseId;
  final String amount;

  SubmitTransactionReceipt({required this.houseId, required this.amount});
}

class OnDeletePayeeEvent extends AccountBookEvent {

  final int id;
  OnDeletePayeeEvent({required this.id,});
}
class OnUploadVoucherImageEvent extends AccountBookEvent {
  final int? expenseId;
  final bool? isUploadFromDetail;
  final String filePath;
  OnUploadVoucherImageEvent({this.expenseId ,required this.filePath, this.isUploadFromDetail = false});
}

class OnGetExpenseDetailEvent extends AccountBookEvent {
  final int id;
  OnGetExpenseDetailEvent({required this.id,});
}
class OnDeleteExpenseEvent extends AccountBookEvent {

  final int id;
  OnDeleteExpenseEvent({required this.id,});
}

class OnUpdatePayeeEvent extends AccountBookEvent {
  final int id;
  final String firstName;
  final String? lastName;
  final String mobileNumber;
  final int expenseCategoryId;
  OnUpdatePayeeEvent({required this.id,    required this.firstName, this.lastName,
    required this.mobileNumber,
    required this.expenseCategoryId,});
}


class GetPendingListEvent extends AccountBookEvent {
  final String? method;
  final String? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final BuildContext mContext;
  GetPendingListEvent({required this.mContext, this.method,
    this.status,
    this.dateFrom,
    this.dateTo,});
}
class ReceiptSharedConfirmEvent extends AccountBookEvent {
  final int id;
  final String receiptNumber;
  final String status;
  final BuildContext mContext;
  ReceiptSharedConfirmEvent({required this.id,required this.mContext, required this.receiptNumber,required this.status});
}
class ReceiptSharedRejectEvent extends AccountBookEvent {
  final int id;
  final String accountComments;
  final String status;
  final BuildContext mContext;
  ReceiptSharedRejectEvent({required this.id,required this.mContext, required this.accountComments,required this.status});
}
class ExpensesRejectEvent extends AccountBookEvent {
  final int id;
  final String status;
  ExpensesRejectEvent({required this.id,required this.status});
}
class ExpensesApprovedEvent extends AccountBookEvent {
  final int id;
  final String status;
  ExpensesApprovedEvent({required this.id,required this.status});
}
class ApplyFilterOnPendingConfirmationEvent extends AccountBookEvent {
  final String? method;
  final String? status;
  final String? dateFrom;
  final String? dateTo;
  final BuildContext mContext;

  ApplyFilterOnPendingConfirmationEvent({
    this.method,
    this.status,
    this.dateFrom,
    this.dateTo,
    required this.mContext,
  });
}
class GetListOfPandingReceiptsOnLoadEvent extends AccountBookEvent {
  final BuildContext? mContext;

  GetListOfPandingReceiptsOnLoadEvent({ this.mContext,});
}
class FetchPaymentReceiptForAccountedEvent extends AccountBookEvent {
  final BuildContext mContext;
  final String paymentId;
  FetchPaymentReceiptForAccountedEvent({required this.paymentId,required this.mContext});
}

class OnFetchGeneratedVoucherEvent extends AccountBookEvent {
  final BuildContext mContext;
  final String expenseId ;
  OnFetchGeneratedVoucherEvent({required this.expenseId,required this.mContext});
}

class OnSentOtpForMobileNumberVerificationEvent extends AccountBookEvent {
  final BuildContext mContext;
  final String mobileNumber;
  final bool isMobileNumberUpdate;
  OnSentOtpForMobileNumberVerificationEvent({required this.mobileNumber,required this.mContext, this.isMobileNumberUpdate=false});
}

class OnResendOtpForMobileNumberVerificationEvent extends AccountBookEvent {
  final BuildContext mContext;
  final String mobileNumber;
  OnResendOtpForMobileNumberVerificationEvent({required this.mobileNumber,required this.mContext, });
}
class OnOtpVerificationEvent extends AccountBookEvent {
  final BuildContext mContext;
  final String mobileNumber;
  final bool isMobileNumberUpdate;
  final String otp;
  OnOtpVerificationEvent({required this.otp,required this.mobileNumber, required this.mContext, this.isMobileNumberUpdate=false});
}

class AddNewPayeeEvent extends AccountBookEvent {
  final BuildContext context;
  final String firstName;
  final String? lastName;
  final String mobileNumber;
  final int expenseCategoryId;
  AddNewPayeeEvent({
    required this.context,
    required this.firstName, this.lastName,
    required this.mobileNumber,
    required this.expenseCategoryId,
  });
}
