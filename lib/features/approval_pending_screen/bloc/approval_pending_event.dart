part of 'approval_pending_bloc.dart';

abstract class ApprovalPendingEvent{}

class OnApprovalStateChangeEvent extends ApprovalPendingEvent{
  bool? isApprovalPending;
  OnApprovalStateChangeEvent({required this.isApprovalPending});
}
