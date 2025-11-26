
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asetize/imports.dart';
import '../../../../core/network/api_base_helpers.dart';
import '../../../../core/util/app_navigator/app_navigator.dart';
import '../../../complaints/models/house_bloc_model.dart';
import '../../../data/models/broker_list_model.dart';
import '../../../data/models/post_update_token_model.dart';
import '../../../data/models/system_setting_model.dart';
import '../../../domain/usecases/post_update_token.dart';
import '../../../login/pages/sign_in_new_screen.dart';
import '../../../my_unit/bloc/my_unit_bloc.dart';
import '../../../new_sign_up/pages/new_login_with_email_screen.dart';
part '../../../../global_repository/global_data_provider/main_app_data_provider.dart';

class MainAppBloc extends Bloc<MainAppEvent, MainAppState> {
  bool isShowSpotlightContainer = false;
  final MainAppDataProvider? mainAppDataProvider;
  static Map<String, dynamic> configTheme = <String, dynamic>{};
  static Map<String, dynamic> homeOptions = <String, dynamic>{};
  static BuildContext? dashboardContext;
  static List<HouseData> houseBlockList = [];
  static get getDashboardContext => dashboardContext;
  int currentIndex = 0;
  static Map<dynamic, dynamic> systemSettingData = {};
  static  List<BrokerListData> brokerListData = [];

  GetUserLogout getUserLogout =
      GetUserLogout(RepositoryImpl(WorkplaceDataSourcesImpl()));
  PostUpdateToken updateToken =
      PostUpdateToken(RepositoryImpl(WorkplaceDataSourcesImpl()));
  MainAppBloc(this.mainAppDataProvider) : super(MainAppInitStat()) {
    on<OnMenuClick>(
      (event, emit) {
        emit(
          MenuClickChangingStatusState(),
        );
        currentIndex = event.currentIndex;

        emit(
          MenuClickChangedStatusState(currentIndex: currentIndex),
        );
      },
    );

    on<UpdateLoggedInUserAuth>(
      (event, emit) => emit(
        UserAuthState(loggedInUserAuth: event.apiAuth),
      ),
    );

    on<LoggedInEvent>(
      (event, emit) => emit(
        LoggedInState(isLoggedInUser: event.isLoggedIn),
      ),
    );
    on<HomeBottomNavigationBarTapedEvent>(
      (event, emit) => emit(
        HomeBottomNavigationBarTapedState(
            tapedBottomBarIndex: event.tapedBottomBarIndex,
            tapedBottomBarPageId: event.tapedBottomBarPageId,
            statusBarColor: event.statusBarColor),
      ),
    );

    on<UpdateLoggedInUserDetailsEvent>((event, emit) => emit(
        UserLoggedInDetailState(
            loggedInUserDetails: event.loggedInUserDetails)));
    on<LoggedInUserInfoUpdateEvent>((event, emit) async {
      MainAppState.mainAppStateModel.loggedInUserInfoModel!.name = event.name ??
          MainAppState.mainAppStateModel.loggedInUserInfoModel!.name;
      MainAppState.mainAppStateModel.loggedInUserInfoModel!.email =
          event.email ??
              MainAppState.mainAppStateModel.loggedInUserInfoModel!.email;
      MainAppState.mainAppStateModel.loggedInUserInfoModel!.id = event.userId ??
          MainAppState.mainAppStateModel.loggedInUserInfoModel!.id;
      MainAppState.mainAppStateModel.loggedInUserInfoModel!.phone =
          event.mobileNumber ??
              MainAppState.mainAppStateModel.loggedInUserInfoModel!.phone;
      MainAppState.mainAppStateModel.loggedInUserInfoModel!.countryCode =
          event.countryCode ??
              MainAppState.mainAppStateModel.loggedInUserInfoModel!.countryCode;

      String loggedInUserData = json.encode(
          MainAppState.mainAppStateModel.loggedInUserInfoModel!.toJson());
      //Store logged in jason
      await PrefUtils().saveStr(
          WorkplaceNotificationConst.loggedInUserDetails, loggedInUserData);
      emit(LoggedUserInfoUpdatedState());
    });

    on<LogOutEvent>((event, emit) async {
      emit(LogOutUserState());
      try {
        LoadingWidget2.startLoadingWidget(event.context);
        //add logout api
        Either<Failure, bool> response = await getUserLogout
            .call(UserLogoutParams(deviceId: event.deviceId));
        response.fold((left) {
          LoadingWidget2.endLoadingWidget(event.context);
          emit(LogOutErrorState(
              context: event.context, errorMessage: "Something went wrong"));
        }, (right) async {
          if (right) {
            PrefUtils()
                .readBool(WorkplaceNotificationConst.isShowSpotlightContainer)
                .then((value) {
              isShowSpotlightContainer = value;
            });

            /// Clean all local instance from application it is related to API token and all
            WorkplaceDataSourcesImpl().cleanAllInstance();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('selected_company_id');

            await PrefUtils().clearAll();
            PrefUtils().saveBool(WorkplaceNotificationConst.isTutorialScreenSeen, true);
            await PrefUtils()
                .saveBool(WorkplaceNotificationConst.isUserLoggedInC, false);
            BlocProvider.of<UserProfileBloc>(event.context).user = User();

            BlocProvider.of<MyUnitBloc>(event.context).clearData();
            BlocProvider.of<UserProfileBloc>(event.context).clearData();



            LoadingWidget2.endLoadingWidget(event.context);
            //emit(MainLogoutUser());
            appNavigator.launchSignInPage(event.context);
            // Navigator.pushAndRemoveUntil(
            //     event.context,
            //     SlideRightRoute(widget: const SignInScreen()),
            //     (route) => false);

            PrefUtils().saveBool(
                WorkplaceNotificationConst.isShowSpotlightContainer, true);
            isShowSpotlightContainer = true;
          }

          // LoadingWidget2.endLoadingWidget(event.context);
        });

        // if (response.status || !response.status) {
        //   bool isNotFirstTimeBool = await PrefUtils()
        //       .readBool(WorkplaceNotificationConst.isNotFirstTime);
      } catch (e) {
        // ignore: use_build_context_synchronously
        emit(LogOutErrorState(
            context: event.context, errorMessage: "Something went wrong"));
      }
    });

    on<ExpireTokenEvent>((event, emit) {
      PrefUtils().clearAll();
      Navigator.of(event.context).pushAndRemoveUntil(
          SlideLeftRoute(widget:  const NewLoginWithEmail()),
          (Route<dynamic> route) => false);
    });

    on<BottomMenuShowHideEvent>(
      (event, emit) => emit(BottomMenuShowHideState(
          isMenuShow: event.isMenuShow,
          scrollController: event.scrollController)),
    );

    on<UpdateTokenEvent>((event, emit) async {
      await projectUtil.deviceInfo();

      String deviceToken =
          await PrefUtils().readStr(WorkplaceNotificationConst.deviceTokenC);
      if(deviceToken.isNotEmpty){
        String deviceId =
        await PrefUtils().readStr(WorkplaceNotificationConst.deviceIdC);
        String deviceName =
        await PrefUtils().readStr(WorkplaceNotificationConst.deviceNameC);
        String deviceVersion = await PrefUtils()
            .readStr(WorkplaceNotificationConst.deviceOsVersionC);
        String appVersion = await PrefUtils()
            .readStr(WorkplaceNotificationConst.appVersionVersionC);
        String deviceType = Platform.isAndroid ? "android" : "ios";

        Either<Failure, UpdateTokenModel> response = await updateToken.call(
            UpdateTokeParams(
                deviceId: deviceId,
                deviceName: deviceName,
                deviceType: deviceType,
                deviceVersion: deviceVersion,
                fcmToken: deviceToken,
                appVersion: appVersion));

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            appNavigator.tokenExpireUserLogout(event.mContext!);
          }else if (left is NoDataFailure) {
            emit(UpdateTokenErrorState(error: left.errorMessage, context: getDashboardContext ));
          } else if (left is NetworkFailure) {
            emit(UpdateTokenErrorState(error:'Network not available', context: getDashboardContext ));
          } else if (left is NoDataFailure) {
            emit(UpdateTokenErrorState(error: left.errorMessage, context: getDashboardContext ));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(UpdateTokenErrorState(error:left.errorMessage, context: getDashboardContext ));
          }else if (left is ServerFailure) {
            emit(UpdateTokenErrorState(error:'Server Failure', context: getDashboardContext ));
          } else {
            emit(UpdateTokenErrorState(error:'Something went wrong', context: getDashboardContext ));
          }
        }, (right) {
          emit(UpdateTokenState());
        });
      }
      else{
        //emit(UpdateTokenErrorState(error:'Server Failure', context: getDashboardContext ));
      }


    });


    on<SystemSettingEvent>((event, emit) async {

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
                  Uri.parse(ApiConst.systemSettings),
                  ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(SystemSettingErrorState(error: left.errorMessage  ?? 'Unauthorized Failure'));
          }else if (left is NoDataFailure) {
            emit(SystemSettingErrorState(error: left.errorMessage ));
          } else if (left is NetworkFailure) {
            emit(SystemSettingErrorState(error:'Network not available' ));
          } else if (left is NoDataFailure) {
            emit(SystemSettingErrorState(error: left.errorMessage ));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SystemSettingErrorState(error:left.errorMessage ));
          }else if (left is ServerFailure) {
            emit(SystemSettingErrorState(error:'Server Failure'));
          } else {
            emit(SystemSettingErrorState(error:'Something went wrong' ));
          }
        }, (right) {
          MainAppBloc.systemSettingData = right['data'];
          // SystemSettingData? systemSettingData = SystemSettingModel.fromJson(right).systemSettingData;
          emit(SystemSettingDoneState());
        });

      } catch (e) {
         emit(SystemSettingErrorState(error: '$e'));
      }
    });

    on<OnGetBrokerListEvent>((event, emit) async {

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.parse(ApiConst.brokerList),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(BrokerListErrorState(error: left.errorMessage  ?? 'Unauthorized Failure'));
          }else if (left is NoDataFailure) {
            emit(BrokerListErrorState(error: left.errorMessage ));
          } else if (left is NetworkFailure) {
            emit(BrokerListErrorState(error:'Network not available' ));
          } else if (left is NoDataFailure) {
            emit(BrokerListErrorState(error: left.errorMessage ));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(BrokerListErrorState(error:left.errorMessage ));
          }else if (left is ServerFailure) {
            emit(BrokerListErrorState(error:'Server Failure'));
          } else {
            emit(BrokerListErrorState(error:'Something went wrong' ));
          }
        }, (right) {

          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(BrokerListErrorState(error: error));
          } else {
            MainAppBloc.brokerListData = BrokerListModel.fromJson(right).data ?? [];
            emit(BrokerListDoneState());
          }
          // MainAppBloc.systemSettingData = right['data'];

        });

      } catch (e) {
        emit(BrokerListErrorState(error: '$e'));
      }
    });

  }
}
