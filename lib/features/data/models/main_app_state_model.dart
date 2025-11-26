import 'logged_in_user_data_model.dart';

class MainAppStateModel {
  String loggedInUserAuth = "";
/*  SignInModel loggedInUserDetails;
  UserProfileDetailModel loggedInUserProfile;*/
  int tapedBottomBarIndex = 0;
  String tapedBottomBarPageId = "";
  String? statusBarColor;
  bool isLoggedIn = false;
  LoggedInUserInfoModel? loggedInUserInfoModel = LoggedInUserInfoModel();

/*  Map<String, dynamic> profileSetUpStep = {
    // "${ProfileSetUpScreens.PROFILE_SETUP}": Map(),
    "${ProfileSetUpScreens.PRONOUNS}": Map(),
    "${ProfileSetUpScreens.PARTY_QUESTIONS}": Map(),
    "${ProfileSetUpScreens.PARTY_QUESTIONS2}": Map(),
    "${ProfileSetUpScreens.KIDS_OS}": Map(),
    "${ProfileSetUpScreens.FUN_FACT}": Map(),
    "${ProfileSetUpScreens.GROUP_GIFT}": Map(),
    "${ProfileSetUpScreens.PHOTO_PROFILE}": Map(),
  };*/
}
