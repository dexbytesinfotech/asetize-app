abstract class NocRequestState {}

class NocRequestInitialState extends NocRequestState {}

class NocRequestLoadingState extends NocRequestState {}

class SingalNocRecordLoadingState extends NocRequestState {}

class UpdateNocListLoadingState extends NocRequestState {}

class NOCReportUploadLoadingState extends NocRequestState {}

class NOCReportUploadDoneState extends NocRequestState {}

class NOCReportUploadErrorState extends NocRequestState {
  final String errorMessage;
  NOCReportUploadErrorState({required this.errorMessage});
}

// class UpdateNocListDoneState extends NocRequestState {}

class UpdateNocListDoneState extends NocRequestState {
  final String message;
  UpdateNocListDoneState({required this.message});
}

class SingalNocRecordDoneState extends NocRequestState {}

class NocRequestListDoneState extends NocRequestState {}

class NocRequestListErrorState extends NocRequestState {
  final String errorMessage;
  NocRequestListErrorState({required this.errorMessage});
}

class SingalNocRecordErrorState extends NocRequestState {
  final String errorMessage;
  SingalNocRecordErrorState({required this.errorMessage});
}

class UpdateNocListErrorState extends NocRequestState {
  final String errorMessage;
  UpdateNocListErrorState({required this.errorMessage});
}
