import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppNotificationEvent extends Equatable {
  const AppNotificationEvent();
  @override
  List<Object> get props => [];
}

class GetAppNotificationListEvent extends AppNotificationEvent {
  final BuildContext? mContext;
  const GetAppNotificationListEvent({this.mContext});
}

/// Get Add new notification when user in app
class OnNotificationReceivedEvent extends AppNotificationEvent {
    const OnNotificationReceivedEvent();
}

class MarkNotificationDisplayedEvent extends AppNotificationEvent {
  final BuildContext? mContext;
  const MarkNotificationDisplayedEvent({this.mContext});
}

// NotificationEnabledStatusEvent
class OnNotificationStatusChangeEvent extends AppNotificationEvent {
  final bool enabledState;
  const OnNotificationStatusChangeEvent({this.enabledState = false});
}

class OnGetNotificationCountEvent extends AppNotificationEvent {
  final BuildContext? mContext;
  const OnGetNotificationCountEvent({this.mContext});
}

class MarkNotificationReadEvent extends AppNotificationEvent {
  final BuildContext? mContext;
  final int? messageID;
  final int? leaveId;
  const MarkNotificationReadEvent(
      {this.mContext,
      this.messageID,
      this.leaveId});
}

class MarkNotificationRedirectReadDisplayEvent extends AppNotificationEvent {
  final BuildContext? mContext;
  final int? msgId;
  const MarkNotificationRedirectReadDisplayEvent({this.mContext, this.msgId});
}
