import '../../../imports.dart';

abstract class AddTransactionReceiptEvent {}



class GetPandingReceipt extends AddTransactionReceiptEvent {
  final String houseId;
  final String amount;
  final bool? isForSelf;
  final BuildContext? mContext;

  GetPandingReceipt({required this.houseId, required this.amount, this.mContext,this.isForSelf = false});
}

class SubmitTransactionReceipt extends AddTransactionReceiptEvent {
  final int houseId;
  final String amount;
  final String filePath;
  final String comments;
  final String paymentMethod;
  final String? transactionDate;
  final String? transactionTime;
  final BuildContext? mContext;
  final bool? isForSelf;

  SubmitTransactionReceipt({required this.houseId, required this.amount, required this.filePath, required this.comments, required this.paymentMethod,this.mContext, this.transactionDate, this.transactionTime,this.isForSelf = true});
}

class GetListOfReceiptsEvent extends AddTransactionReceiptEvent {
  final BuildContext? mContext;

  GetListOfReceiptsEvent({ this.mContext,});
}
class OnSuspenseEntryEvent extends AddTransactionReceiptEvent {
  final BuildContext? mContext;
  final String amount;
  final String paymentMethod;final String transactionDate;

  OnSuspenseEntryEvent({ this.mContext, required this.amount,required this.paymentMethod,required this.transactionDate, });
}
class OnSuspenseHistoryEvent extends AddTransactionReceiptEvent {
  final BuildContext? mContext;
  OnSuspenseHistoryEvent({ this.mContext, });
}

class OnSuspenseHouseAssignEvent extends AddTransactionReceiptEvent {
  final BuildContext? mContext;
  final int? invoiceId;
  final int? assignToHouseId;
  OnSuspenseHouseAssignEvent({ this.mContext, required this.invoiceId,  required this.assignToHouseId, });
}

class DeleteDuplicateEntryReceiptsEvent extends AddTransactionReceiptEvent {
  final BuildContext? mContext;
  final int id;
  DeleteDuplicateEntryReceiptsEvent({ required this.id, this.mContext});
}


class GetListOfReceiptsOnLoadEvent extends AddTransactionReceiptEvent {
  final BuildContext? mContext;

  GetListOfReceiptsOnLoadEvent({ this.mContext,});
}

class OnFormEditEvent extends AddTransactionReceiptEvent {
  final bool? resetAll;
  final bool? isReadyToSubmit;
  final bool? isDisplayFetchInvoiceBtn;
  final Map<String, File>? imageFile;
  final Map<String, String>? imagePath;
  final double? finalAmount;
  final int? selectedUnitId;


  OnFormEditEvent({ this.isReadyToSubmit,this.imagePath,this.imageFile,this.isDisplayFetchInvoiceBtn,this.finalAmount,this.selectedUnitId,this.resetAll = false});
}