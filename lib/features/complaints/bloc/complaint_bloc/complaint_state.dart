import '../../models/complaint_data_model.dart';

abstract class ComplaintState {}

class ComplaintInitialState extends ComplaintState {}

class ComplaintLoadingState extends ComplaintState {}

class OpenDataMoreLoadingState extends ComplaintState {}
class InProgressDataMoreLoadingState extends ComplaintState {}
class CompletedMoreLoadingState extends ComplaintState {}

class ComplaintErrorState extends ComplaintState {
  final String errorMessage;
  ComplaintErrorState({required this.errorMessage});
}

class ComplaintCategoryDoneState extends ComplaintState {}

class FetchedComplaintOpenDataDoneState extends ComplaintState {}

class FetchedComplaintOpenOnLoadDoneState extends ComplaintState {}

class FetchedComplaintInProgressDoneState extends ComplaintState {}

class FetchedComplaintDInProgressOnLoadDoneState extends ComplaintState {}

class FetchedComplaintCompletedDataDoneState extends ComplaintState {}

class FetchedComplaintCompletedOnLoadDoneState extends ComplaintState {}

class FetchedComplaintDetailDoneState extends ComplaintState {}

class ComplaintRaisedDoneState extends ComplaintState {}

class ChangeComplaintStatusDoneState extends ComplaintState {
  final String status;
  ChangeComplaintStatusDoneState({required this.status});
}

class ComplaintCommentDoneState extends ComplaintState {
}

class ComplaintCommentDeleteDoneState extends ComplaintState {
}



