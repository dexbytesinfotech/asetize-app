import '../../../imports.dart';

abstract class HomeEvent {}

class OnGetVisitorCheckedInListEvent extends HomeEvent {
  final BuildContext mContext;
  final String? status;
  final String? startTime;
  final String? endTime;
  final int? houseId;
  OnGetVisitorCheckedInListEvent({required this.mContext, this.status, this.endTime,this.startTime,  this.houseId});
}

class OnGetVisitorCheckedOutListEvent extends HomeEvent {
  final BuildContext mContext;
  final String status;
  final String? startTime;
  final String? endTime;
  OnGetVisitorCheckedOutListEvent({required this.mContext,required this.status, this.endTime,this.startTime});
}

class OnGetVisitorHistoryListEvent extends HomeEvent {
  final BuildContext mContext;
  final String? status;
  final String? startTime;
  final String? endTime;
  final int? houseId;
  final String? search;
  OnGetVisitorHistoryListEvent({required this.mContext, this.status, this.endTime,this.startTime, this.search,this.houseId});

}

class OnGetUpcomingVisitorsListEvent extends HomeEvent {
  final BuildContext mContext;
  final String? status;
  final String? startTime;
  final String? endTime;
  final int? houseId;
  final String? search;
  OnGetUpcomingVisitorsListEvent({required this.mContext, this.status, this.endTime,this.startTime, this.search,this.houseId});

}

class OnVisitorCheckoutEvent extends HomeEvent {
  final BuildContext mContext;
  final int entryHouseId;
  final String? status;
  OnVisitorCheckoutEvent( {required this.mContext,required this.entryHouseId,required this.status,});

}

class OnCreatedNocPassEvent extends HomeEvent {
  final BuildContext mContext;
  final int id;
  final int? visitorEntryId;
  OnCreatedNocPassEvent( {required this.mContext,required this.id, this.visitorEntryId});
}

class OnPreRegisterVisitorEvent extends HomeEvent {
  final String visitorType;
  final String? organization;
  final int houseId;
  final List<Map<String, dynamic>> guests;
  final String date;
  final String time;
  final String? remark;
  OnPreRegisterVisitorEvent({
    required this.visitorType,
    this.organization,
    required this.houseId,
    required this.guests,
    required this.date,
    required this.time,
    this.remark,
  });
}

class OnUpdatePreRegisterVisitorEvent extends HomeEvent {
  final int id;
  final String visitorType;
  final String? organization;
  final int houseId;
  final List<Map<String, dynamic>> guests;
  final String date;
  final String time;
  final String? remark;
  OnUpdatePreRegisterVisitorEvent({
    required this.id,
    required this.visitorType,
    this.organization,
    required this.houseId,
    required this.guests,
    required this.date,
    required this.time,
    this.remark,
  });
}

class OnDeleteUpComingVisitorEvent  extends HomeEvent {
  final BuildContext mContext;
  final int id;
  OnDeleteUpComingVisitorEvent({required this.mContext,required this.id,});
}
