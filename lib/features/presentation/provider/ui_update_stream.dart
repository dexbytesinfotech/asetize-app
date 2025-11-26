import 'dart:async';

enum NotifyFor { HideShowBottomMenu, RefreshData }

class DataRefreshStream {
  DataRefreshStream._internal();
  static final DataRefreshStream instance = DataRefreshStream._internal();
  StreamController<dynamic> _dataRefreshStreamController =
      StreamController<dynamic>();

  StreamController<dynamic> get notificationsStream {
    _dataRefreshStreamController = StreamController<dynamic>();
    return _dataRefreshStreamController;
  }

  void refreshDataOnUi(NotifyFor notification) {
    _dataRefreshStreamController.sink.add(notification);
  }

  void showHideBottomMenu(NotifyFor notification) {
    _dataRefreshStreamController.sink.add(notification);
  }

  void itemClicked(NotifyFor notification) {
    _dataRefreshStreamController.sink.add(notification);
  }

  void dispose() {
    if (_dataRefreshStreamController != null) {
      _dataRefreshStreamController.close();
    }
  }
}
