import 'package:flutter/material.dart';

abstract class NotificationState {
  NotificationState();
}

class NotificationInitStat extends NotificationState {}

class NotificationInProgressState extends NotificationState {
  NotificationInProgressState();
}

class AllNotificationBadgeZeroState extends NotificationState {
  AllNotificationBadgeZeroState();
}

class AllNotificationBadgeRefreshState extends NotificationState {
  AllNotificationBadgeRefreshState();
}

class NotificationErrorState extends NotificationState {
  NotificationErrorState(
      {required BuildContext context, String? errorMessage, String? emailId}) {
    /* ErrorAlert(
        context: context,
        message: errorMessage,
        callBackYes: (mContext) {
          appNavigator.popBackStack(mContext);
        });*/
  }
}

class NotificationNoDataState extends NotificationState {
  String? message;
  NotificationNoDataState({this.message = ""}) : super();
  @override
  String toString() => ' }';
}

class NotificationRedirectToState extends NotificationState {
  final notificationData;
  NotificationRedirectToState({this.notificationData = ""}) : super();
  @override
  String toString() => ' }';
}

class NotificationDeleteState extends NotificationState {
  dynamic notificationResponse;
  NotificationDeleteState({this.notificationResponse = ""}) : super();
  @override
  String toString() => ' }';
}

class NotificationReadState extends NotificationState {
  dynamic notificationResponse;
  NotificationReadState({this.notificationResponse = ""}) : super();
  @override
  String toString() => ' }';
}

/*class NotificationListGetDoneState extends NotificationState {
  NotificationListModel? notificationResponse;
  NotificationListGetDoneState({this.notificationResponse}) : super();
  @override
  String toString() => ' }';
}*/

class ShowerUpdateDoneState extends NotificationState {
  bool? newShowerAdded;
  ShowerUpdateDoneState({this.newShowerAdded}) : super();
  @override
  String toString() => ' }';
}
