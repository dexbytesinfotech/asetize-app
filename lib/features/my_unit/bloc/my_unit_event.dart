part of 'my_unit_bloc.dart';

abstract class MyUnitEvent extends Equatable {
  const MyUnitEvent();

  @override
  List<Object> get props => [];
}

class OnChangeFlatNumberEvent extends MyUnitEvent {
  final Houses? selectedUnit;
  final String? houseId;
  const OnChangeFlatNumberEvent({required this.selectedUnit,this.houseId});
}
class ResetMyUnitEvent extends MyUnitEvent {}

class ResetPaymentStateEvent extends MyUnitEvent {}




class OnShowMoreAndLessEvent extends MyUnitEvent {
  final bool? showFullList;
  const OnShowMoreAndLessEvent({this.showFullList});
}

class FetchInvoicesEvent extends MyUnitEvent {
  final Houses? selectedUnit;
  final BuildContext? mContext;
  final String? houseId;
  const FetchInvoicesEvent({this.houseId,this.selectedUnit,this.mContext});
}


class FetchInvoiceSummaryEvent extends MyUnitEvent {
  final BuildContext mContext;
  final String houseId;
  const FetchInvoiceSummaryEvent({required this.houseId,required this.mContext});
}

class FetchMonthlySummaryEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int houseId;
  final int year;
  const FetchMonthlySummaryEvent({required this.houseId,required this.year,required this.mContext});
}

class OnReLoadMyUnitUiEvent extends MyUnitEvent {
  final BuildContext? mContext;
  const OnReLoadMyUnitUiEvent({this.mContext});
}

class FetchInvoiceStatementEvent extends MyUnitEvent {
  final BuildContext mContext;
  final String houseId;
  const FetchInvoiceStatementEvent({required this.houseId,required this.mContext});
}


class FetchInvoiceHistoryDetailEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int? id;
  final String? tableName;
  final ComeFromForDetails comeFrom;
  final String? houseId;
  const FetchInvoiceHistoryDetailEvent({required this.mContext,required this.comeFrom,this.id,this.tableName,this.houseId});
}

class FetchManagerInvoiceSummaryEvent extends MyUnitEvent {
  final BuildContext mContext;
  final String houseId;
  const FetchManagerInvoiceSummaryEvent({required this.houseId,required this.mContext});
}

class FetchManagerInvoiceStatementEvent extends MyUnitEvent {
  final BuildContext mContext;
  final String houseId;
  const FetchManagerInvoiceStatementEvent({required this.houseId,required this.mContext});
}


class FetchManagerInvoiceHistoryDetailEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int id;
  final String tableName;
  const FetchManagerInvoiceHistoryDetailEvent({required this.mContext,required this.id, required this.tableName});
}

class FetchInvoiceTransactionEvent extends MyUnitEvent {
  final BuildContext mContext;
  final String houseId;
  const FetchInvoiceTransactionEvent({required this.houseId,required this.mContext});
}

class FetchInvoiceManagerTransactionEvent extends MyUnitEvent {
  final BuildContext mContext;
  final String houseId;
  const FetchInvoiceManagerTransactionEvent({required this.houseId,required this.mContext});
}

class FetchPaymentReceiptEvent extends MyUnitEvent {
  final BuildContext mContext;
  final String paymentId;
  const FetchPaymentReceiptEvent({required this.paymentId,required this.mContext});
}


class FetchInvoiceTransactionDetailEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int houseId;
  const FetchInvoiceTransactionDetailEvent({required this.mContext,required this.houseId,});
}

class OnCheckStatusOfNOCSubmissionEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int houseId;
  const OnCheckStatusOfNOCSubmissionEvent({required this.mContext,required this.houseId,});
}

class OnDeleteRequestForNOCEvent  extends MyUnitEvent {
  final BuildContext mContext;
  final int id;
  const OnDeleteRequestForNOCEvent({required this.mContext,required this.id,});
}
class OnPaymentGatewayDetailEvent  extends MyUnitEvent {
  final BuildContext mContext;
  final String gatewayName;
  const OnPaymentGatewayDetailEvent({required this.mContext,required this.gatewayName,});
}

class OnGetNOCAppliedListEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int houseId;
  const OnGetNOCAppliedListEvent({required this.mContext,required this.houseId,});
}

class OnPaymentsInitiateEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int houseId;
  final double amount;
  final double gatewayAmount;
  final double gstAmount;
  final double totalAmount;
  const OnPaymentsInitiateEvent({required this.mContext,required this.houseId, required this.amount,required this.gatewayAmount,required this.gstAmount,required this.totalAmount,});
}

class OnNocPaymentReceiptSubmitEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int id;
  final String filePath;
  const OnNocPaymentReceiptSubmitEvent({required this.mContext,required this.id, required this.filePath});
}


class OnGetCreatedVisitorPassDetailEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int? visitorEntryId;
  const OnGetCreatedVisitorPassDetailEvent({required this.mContext,required this.visitorEntryId,});
}

class OnSubmitRequestForNOCEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int houseId;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? phoneNumber;
  final String? brokerId;
  final int? isCompletedPoliceVerification;
  final String? reason;
  final String? remark;
  const OnSubmitRequestForNOCEvent( {required this.mContext,required this.houseId,required this.reason, this.remark, this.firstName, this.lastName, this.address, this.isCompletedPoliceVerification,this.brokerId, this.phoneNumber});

}
class OnUpdateRequestForNOCEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int houseId;
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? phoneNumber;
  final String? brokerId;
  final int? isCompletedPoliceVerification;
  final String? reason;
  final String? remark;
  const OnUpdateRequestForNOCEvent( {required this.mContext,required this.houseId,required this.reason, this.remark, this.firstName, this.lastName, this.address, this.isCompletedPoliceVerification,this.brokerId, this.phoneNumber, this.id});

}

class OnPaymentCancelEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int id;
  final String responseMessage;
  const OnPaymentCancelEvent({required this.mContext,required this.id, required this.responseMessage});
}


class OnPaymentSuccessEvent extends MyUnitEvent {
  final BuildContext mContext;
  final int id;
  final String responseMessage;
  final String gatewayTransactionId;
  const OnPaymentSuccessEvent({required this.mContext,required this.id, required this.responseMessage, required this.gatewayTransactionId,});
}

class OnCancelVisitorPassEvent  extends MyUnitEvent {
  final BuildContext mContext;
  final int id;
  const OnCancelVisitorPassEvent({required this.mContext,required this.id,});
}

class OnHowToPayGetListEvent  extends MyUnitEvent {
  const OnHowToPayGetListEvent();
}