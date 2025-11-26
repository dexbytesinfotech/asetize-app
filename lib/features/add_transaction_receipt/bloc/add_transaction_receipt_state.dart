abstract class AddTransactionReceiptState {}

class AddTransactionReceiptInitialState extends AddTransactionReceiptState {}
class FormEditingState extends AddTransactionReceiptState {}
class FormEditDoneState extends AddTransactionReceiptState {}

class AddTransactionReceiptLoadingState extends AddTransactionReceiptState {}

class SuspenseEntryLoadingState extends AddTransactionReceiptState {}
class SuspenseHistoryLoadingState extends AddTransactionReceiptState {}
class SuspenseHouseAssignLoadingState extends AddTransactionReceiptState {}



class DeleteDuplicateEntryReceiptsLoadingState extends AddTransactionReceiptState {}

class AddTransactionReceiptOnLoadingState extends AddTransactionReceiptState {}

class AddTransactionReceiptSuccessState extends AddTransactionReceiptState {

  AddTransactionReceiptSuccessState();
}

class AddTransactionReceiptErrorState extends AddTransactionReceiptState {
  final String message;

  AddTransactionReceiptErrorState( {required this.message,});
}

class SuspenseEntryErrorState extends AddTransactionReceiptState {
  final String errorMessage;
  SuspenseEntryErrorState( {required this.errorMessage,});
}class SuspenseHistoryErrorState extends AddTransactionReceiptState {
  final String errorMessage;
  SuspenseHistoryErrorState( {required this.errorMessage,});
}
class SuspenseHouseAssignErrorState extends AddTransactionReceiptState {
  final String errorMessage;
  SuspenseHouseAssignErrorState( {required this.errorMessage,});
}


class DeleteDuplicateEntryReceiptsErrorState extends AddTransactionReceiptState {
  final String message;

  DeleteDuplicateEntryReceiptsErrorState( {required this.message,});
}

class SuspenseEntryDoneState extends AddTransactionReceiptState {}

class SuspenseHouseAssignDoneState extends AddTransactionReceiptState {}
class SuspenseHistoryDoneState extends AddTransactionReceiptState {}

class TransactionReceiptSubmitSuccessState extends AddTransactionReceiptState {

  TransactionReceiptSubmitSuccessState();
}
class getImagePathDoneState extends AddTransactionReceiptState {

  getImagePathDoneState();
}

class getListOfReceiptsDoneState extends AddTransactionReceiptState {

  getListOfReceiptsDoneState();
}class DeleteDuplicateEntryReceiptsDoneState extends AddTransactionReceiptState {

  DeleteDuplicateEntryReceiptsDoneState();
}