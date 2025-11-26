part of 'my_unit_bloc.dart';

abstract class MyUnitState {
  MyUnitState();
  List<Object> get props => [];
}

class MyUnitInitialState extends MyUnitState {}

class ReloadUiDoneState extends MyUnitState {}
class SubmitRequestForNOCLoadingState extends MyUnitState {}

class NOCAppliedListLoadingState extends MyUnitState {}
class HowToPayGetListLoadingState extends MyUnitState {}

class CancelVisitorPassLoadingState extends MyUnitState {}

class CreatedVisitorPassDetailLoadingState extends MyUnitState {}

class CreatedVisitorPassDetailErrorState extends MyUnitState {
  final String errorMessage;
  CreatedVisitorPassDetailErrorState({required this.errorMessage});
}
class CancelVisitorPassErrorState extends MyUnitState {
  final String errorMessage;
  CancelVisitorPassErrorState({required this.errorMessage});
}class HowToPayGetListErrorState extends MyUnitState {
  final String errorMessage;
  HowToPayGetListErrorState({required this.errorMessage});
}

class CreatedVisitorPassDetailDoneState extends MyUnitState {
  final String message;
  CreatedVisitorPassDetailDoneState({required this.message});
}

class CancelVisitorPassDoneState extends MyUnitState {
  final String message;
  CancelVisitorPassDoneState({required this.message});
}

class NOCAppliedListDoneState extends MyUnitState {}
class NOCAppliedListErrorState extends MyUnitState {
  final String errorMessage;
  NOCAppliedListErrorState({required this.errorMessage});
}
class CheckStatusOfNOCSubmissionLoadingState extends MyUnitState {}

class PaymentsInitiateLoadingState extends MyUnitState {}
class PaymentGatewayDetailLoadingState extends MyUnitState {}
class PaymentGatewayDetailErrorState extends MyUnitState {
  final String errorMessage;
  PaymentGatewayDetailErrorState({required this.errorMessage});
}
class PaymentGatewayDetailDoneState extends MyUnitState {
  final String message;
  PaymentGatewayDetailDoneState({required this.message});
}

class PaymentsInitiateDoneState extends MyUnitState {
  final String message;
  final int paymentAttemptId;
  final int houseId;
  final String houseName;
  final String? totalAmount;

  PaymentsInitiateDoneState({required this.message, required this.paymentAttemptId,required this.houseId,required this.houseName, this.totalAmount });
}
class PaymentsInitiateErrorState extends MyUnitState {
  final String errorMessage;
  PaymentsInitiateErrorState({required this.errorMessage});
}


class PaymentCancelLoadingState extends MyUnitState {}

class PaymentCancelDoneState extends MyUnitState {
  final String message;
  PaymentCancelDoneState({required this.message,});
}
class PaymentCancelErrorState extends MyUnitState {
  final String errorMessage;
  PaymentCancelErrorState({required this.errorMessage});
}


class PaymentSuccessLoadingState extends MyUnitState {}

class PaymentSuccessDoneState extends MyUnitState {
  final String message;
  PaymentSuccessDoneState({required this.message,});
}class HowToPayGetListDoneState extends MyUnitState {
  final String message;
  HowToPayGetListDoneState({required this.message,});
}
class PaymentSuccessErrorState extends MyUnitState {
  final String errorMessage;
  PaymentSuccessErrorState({required this.errorMessage});
}





class OnNocPaymentReceiptLoadingState extends MyUnitState {}

class UpdateRequestForNOCLoadingState extends MyUnitState {}
class DeleteRequestForNOCLoadingState extends MyUnitState {}

// class UpdateRequestForNOCDoneState extends MyUnitState {}

class UpdateRequestForNOCDoneState extends MyUnitState {
  final String message;
  UpdateRequestForNOCDoneState({required this.message});
}

// class DeleteRequestForNOCDoneState extends MyUnitState {}

class DeleteRequestForNOCDoneState extends MyUnitState {
  final String message;
  DeleteRequestForNOCDoneState({required this.message});
}


class UpdateRequestForNOCErrorState extends MyUnitState {
  final String errorMessage;
  UpdateRequestForNOCErrorState({required this.errorMessage});
}
class DeleteRequestForNOCErrorState extends MyUnitState {
  final String errorMessage;
  DeleteRequestForNOCErrorState({required this.errorMessage});
}

class OnNocPaymentReceiptDoneState extends MyUnitState {}


class OnNocPaymentReceiptErrorState extends MyUnitState {
  final String errorMessage;
  OnNocPaymentReceiptErrorState({required this.errorMessage});
}

class SubmitRequestForNOCDoneState extends MyUnitState {
  final int? requestedNocId;
  SubmitRequestForNOCDoneState({required this.requestedNocId});
}

class CheckStatusOfNOCSubmissionDoneState extends MyUnitState {}

class SubmitRequestForNOCErrorState extends MyUnitState {
  final String errorMessage;
  SubmitRequestForNOCErrorState({required this.errorMessage});
}

class CheckStatusOfNOCSubmissionErrorState extends MyUnitState {
  final String errorMessage;
  CheckStatusOfNOCSubmissionErrorState({required this.errorMessage});
}



class OnChangeFlatNumberState extends MyUnitState {
  final Houses? selectedUnit;
  final int? houseId;
  OnChangeFlatNumberState({required this.selectedUnit,this.houseId});


}
class OnShowMoreAndLessEventState extends MyUnitState {
  final bool? showFullList;
  OnShowMoreAndLessEventState({this.showFullList});}


class MyUnitLoadingState extends MyUnitState {}

class MyMonthlySummeryLoadingState extends MyUnitState {}
class MyMonthlySummeryDoneState extends MyUnitState {}

class MyUnitPdfLoadingState extends MyUnitState {}

class MyUnitLoadedState extends MyUnitState {
  final Houses? selectedUnit;
  MyUnitLoadedState({required this.selectedUnit});
}

class MyUnitErrorState extends MyUnitState {
  final String message;
  MyUnitErrorState(this.message);
}


class MyUnitErrorState2 extends MyUnitState {
  final String message;
  MyUnitErrorState2(this.message);
}

class MyMonthlySummeryErrorState extends MyUnitState {
  final String message;
  MyMonthlySummeryErrorState(this.message);
}


class InvoiceSummaryDoneState extends MyUnitState {}

class InvoiceStatementDoneState extends MyUnitState {}

class FetchInvoiceHistoryDetailDoneState extends MyUnitState {}

class MyUnitInvoiceManagerErrorState extends MyUnitState {
  final String message;
  MyUnitInvoiceManagerErrorState(this.message);
}

class InvoiceManagerSummaryDoneState extends MyUnitState {}

class InvoiceManagerStatementDoneState extends MyUnitState {}

class FetchManagerInvoiceHistoryDetailDoneState extends MyUnitState {}

class InvoiceTransactionDoneState extends MyUnitState {}

class InvoiceManagerTransactionDoneState extends MyUnitState {}

class PaymentReceiptDoneState extends MyUnitState {
  // final String pdfUrl;
  // PaymentReceiptDoneState({required this.pdfUrl});

}

class FetchInvoiceTransactionDetailDoneState extends MyUnitState {}

