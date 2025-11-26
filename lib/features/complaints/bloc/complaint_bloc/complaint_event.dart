import '../../../../imports.dart';

abstract class ComplaintEvent {}

class FetchComplaintCategoryListEvent extends ComplaintEvent {
  final BuildContext mContext;
  FetchComplaintCategoryListEvent({required this.mContext});
}

class FetchComplaintOpenDataEvent extends ComplaintEvent {
  final BuildContext mContext;
  final String status;
  FetchComplaintOpenDataEvent({required this.mContext, required this.status});
}

class FetchComplaintOpenOnLoadEvent extends ComplaintEvent {
  final BuildContext mContext;
  final String status;
  FetchComplaintOpenOnLoadEvent({required this.mContext, required this.status});
}

class FetchComplaintInProgressDataEvent extends ComplaintEvent {
  final BuildContext mContext;
  final String status;
  FetchComplaintInProgressDataEvent({required this.mContext, required this.status});
}
class FetchComplaintInProgressOnLoadEvent extends ComplaintEvent {
  final BuildContext mContext;
  final String status;
  FetchComplaintInProgressOnLoadEvent({required this.mContext, required this.status});
}

class FetchComplaintCompletedDataEvent extends ComplaintEvent {
  final BuildContext mContext;
  final String status;
  FetchComplaintCompletedDataEvent({required this.mContext, required this.status});
}

class FetchComplaintCompletedOnLoadEvent extends ComplaintEvent {
  final BuildContext mContext;
  final String status;
  FetchComplaintCompletedOnLoadEvent({required this.mContext, required this.status});
}

class RaiseComplaintEvent extends ComplaintEvent {
  final BuildContext mContext;
  final int? userId;
  final String content;
  final int categoryId;
  final String blockName;
  final int? floorNumber;
  final String? filePath;

  RaiseComplaintEvent({required this.content, required this.categoryId, required this.blockName, this.floorNumber, this.userId, this.filePath,required this.mContext});
}

class FetchComplaintDetailEvent extends ComplaintEvent {
  final BuildContext mContext;
  final int complaintId;
  FetchComplaintDetailEvent({required this.mContext,required this.complaintId});
}

class ChangeComplaintStatusEvent extends ComplaintEvent {
  final BuildContext mContext;
  final String status;
  final int id;
  ChangeComplaintStatusEvent({required this.mContext, required this.status,required this.id,});
}

class PostComplaintCommentEvent extends ComplaintEvent
{
  final BuildContext mContext;
  final String comment;
  final String status;
  final int complaintId;
  PostComplaintCommentEvent({required this.mContext, required this.comment, required this.complaintId,required this.status,});
}

class DeleteComplaintCommentEvent extends ComplaintEvent
{
  final BuildContext mContext;
  final int complaintId;
  final int commentId;
  final String status;
  DeleteComplaintCommentEvent({required this.mContext,required this.complaintId,required this.commentId,required this.status});
}