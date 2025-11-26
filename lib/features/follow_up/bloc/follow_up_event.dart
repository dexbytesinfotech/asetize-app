import '../../../imports.dart';

abstract class FollowUpEvent {}


class OnGetTaskListEvent extends FollowUpEvent {
  final BuildContext mContext;
  final String? fromDate;
  final String? toDate;
  final bool? today;
  final String? moduleName;
  final String? status;
  final String? followupStatus;
  final int? assignee;
  final String? priority;
  final String? search;
  final bool? myTask;
  final int? nextPageKey;


  OnGetTaskListEvent({
    required this.mContext,
    this.fromDate,
    this.toDate,
    this.today,
    this.moduleName,
    this.status,
    this.followupStatus,
    this.assignee,
    this.priority,
    this.search,
    this.myTask,
    this.nextPageKey,
  });
}



class OnGetCompleteTaskListEvent extends FollowUpEvent {
  final BuildContext mContext;
  final String? fromDate;
  final String? toDate;
  final bool? today;
  final String? moduleName;
  final String? status;
  final String? followupStatus;
  final int? assignee;
  final String? priority;
  final String? search;
  final bool? myTask;
  final int? pageKey;
  OnGetCompleteTaskListEvent({
    required this.mContext,
    this.fromDate,
    this.toDate,
    this.today = false,
    this.moduleName,
    this.status,
    this.followupStatus,
    this.assignee,
    this.priority,
    this.search,
    this.myTask,
    this.pageKey
  });
}

class OnMarkTaskAsCompleteEvent extends FollowUpEvent {
  final BuildContext? mContext;
  final int? taskId;
  final String? completedImages;
  final String? remark;
  OnMarkTaskAsCompleteEvent({
    required this.mContext,
    required this.taskId,
    this.completedImages,
    required this.remark
  });
}



class OnAddQuotationEvent extends FollowUpEvent {
  final BuildContext? mContext;
  final int? taskId;
  final String? vendorName;
  final String? quotationDate;
  final String? attachment;
  final int? amount;
  OnAddQuotationEvent({
    required this.mContext,
    required this.taskId,
    required this.vendorName,
    required this.amount,
    required this.attachment,
    this.quotationDate
  });
}


class OnGetQuotationListEvent extends FollowUpEvent {
  final int? taskId;
  OnGetQuotationListEvent({
    required this.taskId,
  });
}


class OnAssignTaskEvent extends FollowUpEvent {
  final BuildContext? mContext;
  final int? taskId;
  final int? assignToId;
  OnAssignTaskEvent({
    required this.mContext,
    required this.taskId,
    required this.assignToId,
  });
}


class OnCreateFollowUpEvent extends FollowUpEvent {
  final int taskId;
  final String remark;
  final String status;
  final String followupDate;
  OnCreateFollowUpEvent({
    required this.taskId,
    required this.remark,
    required this.status,
    required this.followupDate,
  });
}

class OnUpdateFollowUpEvent extends FollowUpEvent {
  final int taskId;
  final int followUpId;
  final String remark;
  final String status;
  final String followupDate;
  OnUpdateFollowUpEvent({
    required this.taskId,
    required this.remark,
    required this.followUpId,
    required this.status,
    required this.followupDate,
  });
}


class OnCommentOnTaskEvent extends FollowUpEvent {
  final int taskId;
  final String comment;
  OnCommentOnTaskEvent({
    required this.taskId,
    required this.comment,
  });
}



class OnGetTaskCommentListEvent extends FollowUpEvent {
  final int taskId;
  OnGetTaskCommentListEvent({
    required this.taskId,
  });
}


class OnGetTaskHistoryListEvent extends FollowUpEvent {
  final int taskId;
  OnGetTaskHistoryListEvent({
    required this.taskId,
  });
}

class OnGetFollowUpListEvent extends FollowUpEvent {
  final int taskId;
  OnGetFollowUpListEvent({
    required this.taskId,
  });
}



class OnGetTaskDetailEvent extends FollowUpEvent {
  final int taskId;
  final bool isAssign;
  final bool hasApprovedQuotation;
  OnGetTaskDetailEvent({
    required this.taskId,
    this.isAssign = false,
    this.hasApprovedQuotation = false
  });
}


class OnCreateTaskEvent extends FollowUpEvent {
  final String? title;
  final String? description;
  final String moduleName;
  final int? moduleId;
  final String? dueDate;
  final String? priority;
  final int? assignedTo;
  final int? houseId;
  final bool isComing;
  final List<String>? taskImages;

  OnCreateTaskEvent({
     this.title,
     this.description,
      required this.moduleName,
     this.moduleId,
     this.dueDate,
     this.priority,
     this.assignedTo,
     this.houseId,
    this.taskImages,
    this.isComing = false,
  });
}

class OnUpdateTaskEvent extends FollowUpEvent {
  final String? title;
  final String? description;
  final String moduleName;
  final int? moduleId;
  final String? dueDate;
  final String? priority;
  final int? assignedTo;
  final int? houseId;
  final bool isComing;
  final int? taskId;
  OnUpdateTaskEvent({
    this.title,
    this.description,
    required this.moduleName,
    this.moduleId,
    this.dueDate,
    this.priority,
    this.assignedTo,
    this.houseId,
    this.isComing = false,
    this.taskId
  });
}


class OnGetTaskFiltersListEvent extends FollowUpEvent {
  OnGetTaskFiltersListEvent();
}


class OnUpdateTaskCommentEvent extends FollowUpEvent {
  final int taskId;
  final int commentId;
  final String comment;
  OnUpdateTaskCommentEvent({
    required this.taskId,
    required this.comment,
    required this.commentId,
  });
}

class OnDeleteTaskCommentEvent extends FollowUpEvent {
  final int taskId;
  final int commentId;
  OnDeleteTaskCommentEvent({
    required this.taskId,
    required this.commentId,
  });
}

class OnDeleteQuotationEvent extends FollowUpEvent {
  final int id;
  OnDeleteQuotationEvent({
    required this.id,
  });
}

class OnApprovedQuotationEvent extends FollowUpEvent {
  final int id;
  OnApprovedQuotationEvent({
    required this.id,
  });
}

class OnRejectQuotationEvent extends FollowUpEvent {
  final int id;
  OnRejectQuotationEvent({
    required this.id,
  });
}


class OnDeleteTaskFollowUpEvent extends FollowUpEvent {
  final int taskId;
  final int followUpId;
  OnDeleteTaskFollowUpEvent({
    required this.taskId,
    required this.followUpId,
  });
}


class OnGetTaskFollowUpListEvent extends FollowUpEvent {
  final int taskId;
  OnGetTaskFollowUpListEvent({
    required this.taskId,
  });
}




class OnDeleteTaskEvent extends FollowUpEvent {
  final int taskId;
  OnDeleteTaskEvent({
    required this.taskId,
  });
}



class OnGenerateTitleDescriptionEvent extends FollowUpEvent {
  final int complaintIdOrHouseId;
  final String taskType;
  OnGenerateTitleDescriptionEvent({
    required this.complaintIdOrHouseId,
    required this.taskType,
  });
}