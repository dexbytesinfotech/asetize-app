import 'package:flutter/material.dart';
import 'package:asetize/features/presentation/provider/ui_update_stream.dart';

class AppState extends ChangeNotifier {
  bool? _isBusy;
  bool? get isbusy => _isBusy;
  set loading(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  int _pageIndex = 0;
  int get pageIndex {
    return _pageIndex;
  }

  set setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  void refreshDataOnUi() {
    DataRefreshStream.instance.showHideBottomMenu(NotifyFor.RefreshData);
  }
}
