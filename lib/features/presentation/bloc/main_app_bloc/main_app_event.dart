import 'package:asetize/imports.dart';

abstract class MainAppEvent extends Equatable {
  const MainAppEvent();
  @override
  List<Object> get props => [];
}

class UpdateLoggedInUserDetails extends MainAppEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AddProduct { index: }';
}

class UpdateLoggedInUserAuth extends MainAppEvent {
  final String apiAuth;
  const UpdateLoggedInUserAuth(this.apiAuth);
  @override
  String toString() => 'RemoveProduct { index: $apiAuth }';
}

class UpdateLoggedInUserDetailsEvent extends MainAppEvent {
  final LoggedInUserInfoModel? loggedInUserDetails;
  const UpdateLoggedInUserDetailsEvent(this.loggedInUserDetails);
  @override
  String toString() => 'RemoveProduct { index: $loggedInUserDetails }';
}

class OnMenuClick extends MainAppEvent {
  final int currentIndex;
  const OnMenuClick(this.currentIndex);
}

class LoggedInEvent extends MainAppEvent {
  final bool isLoggedIn;
  const LoggedInEvent(this.isLoggedIn);
  @override
  String toString() => 'RemoveProduct { index: $isLoggedIn }';
}

class ProfileSetUpStepUpdateEvent extends MainAppEvent {
  final Map? screenData;
  final BuildContext? context;
  const ProfileSetUpStepUpdateEvent({this.screenData, this.context});
  @override
  String toString() => 'RemoveProduct { index: }';
}

//It will return next selected screen filled data and not filled screen name
class GetProfileSetUpStepEvent extends MainAppEvent {
  final BuildContext? context;
  const GetProfileSetUpStepEvent({this.context});
  @override
  String toString() => 'RemoveProduct { index: }';
}

//get user profile details in background
class GetUserProfileDetailsApiEvent extends MainAppEvent {
  final BuildContext? context;
  const GetUserProfileDetailsApiEvent({@required this.context});
  @override
  String toString() => 'RemoveProduct { index: }';
}

class LogOutEvent extends MainAppEvent {
  final BuildContext context;
  final String deviceId;
  const LogOutEvent({required this.context, required this.deviceId});
  @override
  String toString() => 'RemoveProduct { index: }';
}

class ExpireTokenEvent extends MainAppEvent {
  final BuildContext context;
  const ExpireTokenEvent({required this.context});
}

class HomeBottomNavigationBarTapedEvent extends MainAppEvent {
  final int tapedBottomBarIndex;
  final String? statusBarColor;
  final String tapedBottomBarPageId;
  const HomeBottomNavigationBarTapedEvent(
      {required this.tapedBottomBarIndex,
      required this.tapedBottomBarPageId,
      this.statusBarColor});
  @override
  String toString() => 'RemoveProduct { index: }';
}

//for logged in user info save event
class LoggedInUserInfoUpdateEvent extends MainAppEvent {
  final String? name, mobileNumber, email;
  final int? countryCode;
  final int? notificationCount, messageCount;
  final int? userId;
  const LoggedInUserInfoUpdateEvent(
      {this.userId,
      this.name,
      this.mobileNumber,
      this.email,
      this.countryCode,
      this.notificationCount,
      this.messageCount});
  @override
  String toString() => 'RemoveProduct { index: }';
}

class BottomMenuShowHideEvent extends MainAppEvent {
  final bool isMenuShow;
  final ScrollController? scrollController;
  const BottomMenuShowHideEvent({this.isMenuShow = true, this.scrollController});
}

class UpdateTokenEvent extends MainAppEvent {
  final BuildContext? mContext;
  const UpdateTokenEvent({this.mContext});
}


class SystemSettingEvent extends MainAppEvent {
  final BuildContext? mContext;
  const SystemSettingEvent({this.mContext});
}

class OnGetBrokerListEvent extends MainAppEvent {
  final BuildContext? mContext;
  const OnGetBrokerListEvent({this.mContext});
}