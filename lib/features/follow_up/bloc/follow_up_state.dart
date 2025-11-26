abstract class FollowUpState {}

class FollowUpInitialState extends FollowUpState {}

class GetTaskListLoadingState extends FollowUpState {}
class GetCompleteTaskListLoadingState extends FollowUpState {}
// class MarkTaskAsCompleteLoadingState extends FollowUpState {}
class CreateFollowUpLoadingState extends FollowUpState {}
class UpdateFollowUpLoadingState extends FollowUpState {}
class GenerateTitleDescriptionLoadingState extends FollowUpState {}
class AddQuotationLoadingState extends FollowUpState {}


class GetQuotationListLoadingState extends FollowUpState {}
class DeleteQuotationLoadingState extends FollowUpState {


}
class ApprovedQuotationLoadingState extends FollowUpState {}
class RejectedQuotationLoadingState extends FollowUpState {}
















class GetTaskFollowUpListLoadingState extends FollowUpState {}
class OnCommentOnTaskLoadingState extends FollowUpState {}
class FollowUpListLoadingState extends FollowUpState {}
class OnDeleteTaskFollowUpLoadingState extends FollowUpState {}

class OnUpdateTaskCommentLoadingState extends FollowUpState {}
class DeleteTaskLoadingState extends FollowUpState {}

class  OnDeleteTaskCommentLoadingState extends FollowUpState {}

class GetTaskCommentListLoadingState extends FollowUpState {}

class TaskFiltersListLoadingState extends FollowUpState {}
class AssignTaskLoadingState extends FollowUpState {}

class GetTaskDetailLoadingState extends FollowUpState {}
class CreateTaskLoadingState extends FollowUpState {}
class UpdateTaskLoadingState extends FollowUpState {}
class GetTaskHistoryListLoadingState extends FollowUpState {}

class GetTaskListErrorState extends FollowUpState {
  final String errorMessage;
  GetTaskListErrorState({required this.errorMessage});
}

class AddQuotationErrorState extends FollowUpState {
  final String errorMessage;
  AddQuotationErrorState({required this.errorMessage});
}

class GenerateTitleDescriptionErrorState extends FollowUpState {
  final String errorMessage;
  GenerateTitleDescriptionErrorState({required this.errorMessage});
}


class GetTaskHistoryListErrorState extends FollowUpState {
  final String errorMessage;
  GetTaskHistoryListErrorState({required this.errorMessage});
}

class OnDeleteTaskFollowUpErrorState extends FollowUpState {
  final String errorMessage;
  OnDeleteTaskFollowUpErrorState({required this.errorMessage});
}

class OnDeleteTaskErrorState extends FollowUpState {
  final String errorMessage;
  OnDeleteTaskErrorState({required this.errorMessage});
}class UpdateFollowUpErrorState extends FollowUpState {
  final String errorMessage;
  UpdateFollowUpErrorState({required this.errorMessage});
}
class GetTaskFollowUpListErrorState extends FollowUpState {
  final String errorMessage;
  GetTaskFollowUpListErrorState({required this.errorMessage});
}class DeleteTaskErrorState extends FollowUpState {
  final String errorMessage;
  DeleteTaskErrorState({required this.errorMessage});
}

class GetTaskCommentListErrorState extends FollowUpState {
  final String errorMessage;
  GetTaskCommentListErrorState({required this.errorMessage});
}

class UpdateTaskErrorState extends FollowUpState {
  final String errorMessage;
  UpdateTaskErrorState({required this.errorMessage});
}
class OnCommentOnTaskErrorState extends FollowUpState {
  final String errorMessage;
  OnCommentOnTaskErrorState({required this.errorMessage});
}class OnDeleteTaskCommentErrorState extends FollowUpState {
  final String errorMessage;
  OnDeleteTaskCommentErrorState({required this.errorMessage});
}
class OnUpdateTaskCommentErrorState extends FollowUpState {
  final String errorMessage;
  OnUpdateTaskCommentErrorState({required this.errorMessage});
}


class TaskFiltersListLoadingErrorState extends FollowUpState {
  final String errorMessage;
  TaskFiltersListLoadingErrorState({required this.errorMessage});
}
class MarkTaskAsCompleteErrorState extends FollowUpState {
  final String errorMessage;
  final int? taskId;
  MarkTaskAsCompleteErrorState({required this.errorMessage,  this.taskId});
}
class MarkTaskAsCompleteLoadingState extends FollowUpState {
  final int? taskId;
  MarkTaskAsCompleteLoadingState({this.taskId});
}

class CreateTaskErrorState extends FollowUpState {
  final String errorMessage;
  CreateTaskErrorState({required this.errorMessage});
}class GetTaskDetailErrorState extends FollowUpState {
  final String errorMessage;
  GetTaskDetailErrorState({required this.errorMessage});
}
class AssignTaskErrorState extends FollowUpState {
  final String errorMessage;
  AssignTaskErrorState({required this.errorMessage});
}


class GetCompleteTaskListErrorState extends FollowUpState {
  final String errorMessage;
  GetCompleteTaskListErrorState({required this.errorMessage});
}

class CreateFollowUpErrorState extends FollowUpState {
  final String errorMessage;
  CreateFollowUpErrorState({required this.errorMessage});
}
class FollowUpListErrorState extends FollowUpState {
  final String errorMessage;
  FollowUpListErrorState({required this.errorMessage});
}

class GetQuotationListErrorState extends FollowUpState {
  final String errorMessage;
  GetQuotationListErrorState({required this.errorMessage});
}


class DeleteQuotationErrorState extends FollowUpState {
  final String errorMessage;
  DeleteQuotationErrorState({required this.errorMessage});
}

class ApprovedQuotationErrorState extends FollowUpState {
  final String errorMessage;
  ApprovedQuotationErrorState({required this.errorMessage});
}


class RejectQuotationErrorState extends FollowUpState {
  final String errorMessage;
  RejectQuotationErrorState({required this.errorMessage});
}
















class GetTaskListDoneState extends FollowUpState {
  final String message;
  GetTaskListDoneState({required this.message});
}
class GetTaskHistoryListDoneState extends FollowUpState {
  final String message;
  GetTaskHistoryListDoneState({required this.message});
}


class AddQuotationDoneState extends FollowUpState {
  final String message;
  AddQuotationDoneState({required this.message});
}


class UpdateTaskDoneState extends FollowUpState {
  final String message;
  UpdateTaskDoneState({required this.message});
}

class UpdateFollowUpDoneState extends FollowUpState {
  final String message;
  UpdateFollowUpDoneState({required this.message});
}


class OnDeleteTaskFollowUpDoneState extends FollowUpState {
  final String message;
  OnDeleteTaskFollowUpDoneState({required this.message});
}

class GetTaskFollowUpListDoneState extends FollowUpState {
  final String message;
  GetTaskFollowUpListDoneState({required this.message});
}
class OnUpdateTaskCommentDoneState extends FollowUpState {
  final String message;
  OnUpdateTaskCommentDoneState({required this.message});
}

class OnDeleteTaskCommentDoneState extends FollowUpState {
  final String message;
  OnDeleteTaskCommentDoneState({required this.message});
}class GenerateTitleDescriptionDoneState extends FollowUpState {
  final String message;
  GenerateTitleDescriptionDoneState({required this.message});
}

class OnCommentOnTaskDoneState extends FollowUpState {
  final String message;
  OnCommentOnTaskDoneState({required this.message});
}class OnDeleteTaskDoneState extends FollowUpState {
  final String message;
  OnDeleteTaskDoneState({required this.message});
}

class TaskFiltersListDoneState extends FollowUpState {
  final String message;
  TaskFiltersListDoneState({required this.message});
}
class DeleteTaskDoneState extends FollowUpState {
  final String message;
  DeleteTaskDoneState({required this.message});
}

class GetTaskCommentListDoneState extends FollowUpState {
  final String message;
  GetTaskCommentListDoneState({required this.message});
}

class GetTaskDetailDoneState extends FollowUpState {
  final String message;
  GetTaskDetailDoneState({required this.message});
}

class CreateTaskDoneState extends FollowUpState {
  final String message;
  final bool isComing;
  CreateTaskDoneState({required this.message, required this.isComing});
}

class GetCompleteTaskListDoneState extends FollowUpState {
  final String message;
  GetCompleteTaskListDoneState({required this.message});
}

class MarkTaskAsCompleteDoneState extends FollowUpState {
  final String message;
  MarkTaskAsCompleteDoneState({required this.message,});
}

class CreateFollowUpDoneState extends FollowUpState {
  final String message;
  CreateFollowUpDoneState({required this.message});
}

class AssignTaskDoneState extends FollowUpState {
  final String message;
  AssignTaskDoneState({required this.message});
}

class FollowUpListDoneState extends FollowUpState {
  final String message;
  FollowUpListDoneState({required this.message});
}
class GetQuotationListDoneState extends FollowUpState {
  final String message;
  GetQuotationListDoneState({required this.message});
}
class DeleteQuotationDoneState extends FollowUpState {
  final String message;
  DeleteQuotationDoneState({required this.message});
}

class RejectQuotationDoneState extends FollowUpState {
  final String message;
  RejectQuotationDoneState({required this.message});
}


class ApprovedQuotationDoneState extends FollowUpState {
  final String message;
  ApprovedQuotationDoneState({required this.message});
}





