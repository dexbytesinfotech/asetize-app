import '../../../imports.dart';

abstract class NocRequestEvent {}


class OnGetNocListEvent extends NocRequestEvent {
  final BuildContext? mContext;
  OnGetNocListEvent({required this.mContext,});
}


class OnUpdateNocListEvent extends NocRequestEvent {
  final BuildContext mContext;
  final int? id;
  final String? status;
  final String? rejectReason;

  OnUpdateNocListEvent({required this.mContext,required this.id, required this.status, this.rejectReason});
}

class OnGetSingalNocRecordEvent extends NocRequestEvent {
  final BuildContext mContext;
  final int? id;
  OnGetSingalNocRecordEvent({required this.mContext,required this.id,});
}


class OnNOCReportUploadEvent extends NocRequestEvent {
  final BuildContext mContext;
  final int? id;
  final String? filePath;
  OnNOCReportUploadEvent({required this.mContext,required this.id, required this.filePath});
}