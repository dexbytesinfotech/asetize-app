part of '../../features/presentation/bloc/main_app_bloc/main_app_bloc.dart';

class MainAppDataProvider {
  List<User>? _teamMemberList;
  List<User>? _businessList;
  MainAppDataProvider();
  List<User> getTeamMemberList() => _teamMemberList ?? [];
  List<User> setTeamMemberList(List<User>? list) {
    try {
      _teamMemberList = _teamMemberList ?? [];
      _teamMemberList!.clear();
      _teamMemberList!.addAll(list ?? []);
    } catch (e) {
      projectUtil.printP("$e");
    }
    return _teamMemberList!;
  }
  List<User> getBusinessList() => _businessList ?? [];
  List<User> setBusinessList(List<User>? list) {
    try {
      _businessList = _businessList ?? [];
      _businessList!.clear();
      _businessList!.addAll(list ?? []);
    } catch (e) {
      projectUtil.printP("$e");
    }
    return _businessList!;
  }
}
