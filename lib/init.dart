import 'package:asetize/features/new_sign_up/bloc/new_signup_bloc.dart';

import 'core/network/api_base_helpers.dart';
import 'core/util/app_localizations.dart';
import 'core/util/one_signal_notification/one_signal_notification_handler.dart';
import 'features/new_sign_up/bloc/new_signup_event.dart';
import 'features/new_sign_up/bloc/new_signup_state.dart';
import 'imports.dart';

Future<InitVar> workplaceInit({BuildContext? context}) async {

  // if you are using await in main function then add this line
  WidgetsFlutterBinding.ensureInitialized();
  // Restrict for portrait mode only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //Firebase Crashlytics
  await ScreenUtil.ensureScreenSize();
  String? token = OneSignalNotificationsHandler.instance.getToken();
  // Pass all uncaught errors to Crashlytics.
  Provider.debugCheckInvalidValueType = null;
  projectUtil.logEventTime("SplashScreen Build Started 1 ");

   OneSignalNotificationsHandler.instance.refreshToken();
  projectUtil.logEventTime("SplashScreen Build Started 1.1");

  String jsonString =
  await rootBundle.loadString('assets/app_theme/config_theme.json');
  MainAppBloc.configTheme = json.decode(jsonString);

  ///Get token
  String? appApiToken = await PrefUtils().readStr(WorkplaceNotificationConst.tokenForCompleteProfile);
  String? selectedCompanyId  = await PrefUtils().readStr(WorkplaceNotificationConst.selectedCompanyId);
  bool? isCompleteProfile  = false;
  bool? isApprovalPending = true;
  bool? isNetConnected = true;

  String? loggedInUserDetailsStr;
  if (appApiToken.isNotEmpty) {
    // ApiConst.setBaseUrl = !isDemoLoggedIn;
    // MainAppBloc mainAppBloc = MainAppBloc(MainAppDataProvider());
    // loggedInUserDetailsStr = await PrefUtils()
    //     .readStr(WorkplaceNotificationConst.loggedInUserDetails);
    // if (loggedInUserDetailsStr.trim().isNotEmpty) {
    //   LoggedInUserInfoModel? loggedInUserInfoModel;
    //   try {
    //     loggedInUserInfoModel =
    //         LoggedInUserInfoModel.fromJson(json.decode(loggedInUserDetailsStr));
    //     mainAppBloc.add(UpdateLoggedInUserDetailsEvent(loggedInUserInfoModel));
    //   } catch (e) {
    //   }
    // }
    // mainAppBloc.add(LoggedInEvent(appApiToken.isNotEmpty));

    WorkplaceDataSourcesImpl.token = appApiToken;
    ApiBaseHelpers.setAccessToken = appApiToken;
    NewSignupBloc newSignupBloc = NewSignupBloc();

    newSignupBloc.add(OnGetProfileBackgroundEvent(mContext: context,appApiToken:appApiToken,selectedCompanyId:selectedCompanyId));
    await for (final state in newSignupBloc.stream) {
      if (state is GuestProfileBackgroundDoneState) {
        selectedCompanyId = state.selectedCompanyId;
        // appApiToken = ;
        isCompleteProfile = state.isCompleteProfile;
        await PrefUtils().saveInt(
          WorkplaceNotificationConst.selectedCompanyId,
          int.tryParse(selectedCompanyId??"0") ?? 0,
        );
        break;
      }
      else if (state is GuestProfileBackgroundErrorState) {
        if(state.errorMessage.contains("NetworkFailure")){
          String newSelectedCompanyIdStr = selectedCompanyId.toString();
          WorkplaceDataSourcesImpl.selectedCompanySaveId = newSelectedCompanyIdStr;
          ApiBaseHelpers.selectedCompanySaveId = newSelectedCompanyIdStr;
          isNetConnected = false;
        }
        else{
          WorkplaceDataSourcesImpl.token = "";
          ApiBaseHelpers.setAccessToken = "";
          appApiToken = "";
        }

        break;
      }

    }

  }

  bool isFingerprintEnabled = await PrefUtils().readBool(WorkplaceNotificationConst.isFingerprintEnabledC);
  bool isTutorialScreenSeen = await PrefUtils().readBool(WorkplaceNotificationConst.isTutorialScreenSeen);
  print(isTutorialScreenSeen);
  Locale? mLocale = appApiToken!.isNotEmpty ? await lang() : null;
  Provider.debugCheckInvalidValueType = null;
  return InitVar(
      token: appApiToken,
      mLocale: mLocale,
      isCompleteProfile: isCompleteProfile,
      selectedCompanyId: selectedCompanyId,isNetConnected:isNetConnected,
      isTutorialScreenSeen:isTutorialScreenSeen,
      isFingerprintEnabled: isFingerprintEnabled,isApprovalPending:isApprovalPending
  );
}

Future<Locale?> lang() async {
  Locale? mLocale = const Locale('en', 'US');
  String languageCode, countryCode;
  String value =
  await PrefUtils().readStr(WorkplaceNotificationConst.languageCodeC);

  if (value != '') {
    Map localDetails = json.decode(value);
    languageCode = localDetails["languageCode"];
    countryCode = localDetails["countryCode"];
    if (languageCode != '' && countryCode != '') {
      mLocale = Locale(languageCode, countryCode);
    } else {
      mLocale = null;
    }
  }
  //First Time User
  else {
    mLocale = null;
    PrefUtils().saveStr(WorkplaceNotificationConst.selectedLanguageC,
        WorkplaceNotificationConst.selectedLanguageKoreanC);
    PrefUtils().saveBool(WorkplaceNotificationConst.isNotFirstTime, true);
  }
  return mLocale;
}
