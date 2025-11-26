import 'dart:async';

enum NotificationFor {
  anyNotification,
  newPosNotification,
  acceptance,
  production,
  RefreshData
}

class NotificationStream {
  NotificationStream._internal();
  static final NotificationStream instance = NotificationStream._internal();
  StreamController<dynamic> _notificationsStreamController =
      StreamController<dynamic>();
  StreamController<dynamic> get notificationsStream {
    _notificationsStreamController = StreamController<dynamic>();
    return _notificationsStreamController;
  }

  void newNotification(NotificationFor notification) {
    _notificationsStreamController.sink.add(notification);
  }

  void dispose() {
    _notificationsStreamController.close();

    //_notificationsStreamController?.close();
  }
}
