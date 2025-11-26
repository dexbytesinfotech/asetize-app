part of 'approval_pending_bloc.dart';

abstract class ApprovalPendingState{}

class ApprovalPendingLoadingState extends ApprovalPendingState {}

class ApprovalPendingErrorState extends ApprovalPendingState {
 String? error;
 ApprovalPendingErrorState({this.error});
}

class ApprovalPendingInitialState extends ApprovalPendingState {

}

class ApprovalStateChangedState extends ApprovalPendingState {
 bool? isApprovalPending;
 ApprovalStateChangedState({required this.isApprovalPending});
}