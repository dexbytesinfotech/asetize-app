import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class NotificationListGetEvent extends NotificationEvent {
  final Map? requestData;
  final BuildContext? context;
  NotificationListGetEvent({this.requestData, this.context});
  @override
  String toString() => 'RemoveProduct { index: $requestData }';
}

class NotificationReadEvent extends NotificationEvent {
  final Map? requestData;
  final BuildContext? context;
  NotificationReadEvent({this.requestData, this.context});
  @override
  String toString() => 'RemoveProduct { index: $requestData }';
}

class ShowerUpdateEvent extends NotificationEvent {
  final bool anyNewShowerAdded;
  final BuildContext? context;
  ShowerUpdateEvent({required this.anyNewShowerAdded, this.context});
  @override
  String toString() => 'RemoveProduct { index: $anyNewShowerAdded }';
}

class AllNotificationBadgeZeroEvent extends NotificationEvent {
  final BuildContext? context;
  final bool? removeMenuNotificationDot;
  AllNotificationBadgeZeroEvent(
      {this.context, this.removeMenuNotificationDot = false});
  @override
  String toString() => 'RemoveProduct { }';
}

class AllNotificationBadgeRefreshEvent extends NotificationEvent {
  final BuildContext? context;

  AllNotificationBadgeRefreshEvent({this.context});
  @override
  String toString() => 'RemoveProduct { }';
}

class NotificationRedirectEvent extends NotificationEvent {
  final notificationData;
  NotificationRedirectEvent({this.notificationData});
  @override
  String toString() => 'RemoveProduct { }';
}

class NotificationDeletedEvent extends NotificationEvent {
  final Map? requestData;
  final BuildContext? context;
  NotificationDeletedEvent({this.requestData, this.context});
  @override
  String toString() => 'RemoveProduct { index: $requestData }';
}
