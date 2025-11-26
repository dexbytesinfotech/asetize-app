import 'package:shared_preferences/shared_preferences.dart';
import 'package:asetize/core/util/app_navigator/app_navigator.dart';
import 'package:asetize/features/login/bloc/sign_in_bloc/sign_in_event.dart';
import 'package:asetize/features/login/bloc/sign_in_bloc/sign_in_state.dart';
import 'package:asetize/imports.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  LoginUser loginUser = LoginUser(RepositoryImpl(WorkplaceDataSourcesImpl()));

  SignInBloc() : super(SignInInitState()) {
    on<SubmitSignInEvent>((event, emit) async {
      await projectUtil.deviceInfo();
      emit(SignInInProgressState());

      Map? data = event.requestData;
      String enteredEmail = event.requestData!["email"];
      try {
        LoadingWidget2.startLoadingWidget(event.mContext!);

        String deviceToken = await PrefUtils().readStr(WorkplaceNotificationConst.deviceTokenC);
        String deviceId = await PrefUtils().readStr(WorkplaceNotificationConst.deviceIdC);
        String deviceName = await PrefUtils().readStr(WorkplaceNotificationConst.deviceNameC);
        String deviceVersion = await PrefUtils().readStr(WorkplaceNotificationConst.deviceOsVersionC);
        String deviceModel = await PrefUtils().readStr(WorkplaceNotificationConst.deviceModelC);
        String appVersion = await PrefUtils().readStr(WorkplaceNotificationConst.appVersionVersionC);
        String deviceTypeName = Platform.isAndroid ? "android" : "ios";

        data!["deviceId"] = deviceId;
        data["deviceName"] = deviceName;
        data["fcmToken"] = deviceToken;
        data["deviceVersion"] = deviceVersion;
        data["deviceType"] = deviceTypeName;
        data["device_model"] = deviceModel;
        data["app_version"] = appVersion;

        Either<Failure, SignInModel> response = await loginUser.call(
            UserLoginParams(
                email: event.requestData!["email"],
                password: event.requestData!["password"],
                deviceId: deviceId,
                deviceName: deviceName,
                deviceType: deviceTypeName,
                deviceVersion: deviceVersion,
                fcmToken: deviceToken));

        response.fold((left) {
          if (left is NoDataFailure) {
            emit(SignInErrorState(
              context: event.mContext!,
              errorMessage: left.errorMessage,
              code: 401,
              okCallBack: () {
                appNavigator.popBackStack(event.mContext!);
              },
            ));
          } else if (left is NetworkFailure) {
            emit(SignInErrorState(
                context: event.mContext!,
                errorMessage: "Network not available"));
          } else {
            emit(SignInErrorState(
                context: event.mContext!,
                errorMessage: "Something went wrong..."));
          }
          LoadingWidget2.endLoadingWidget(event.mContext!);
        }, (right) async {
          if (right.data != null) {
            List<CompaniesNew> companies = right.data!.companiesNew!;
            List<Map<String, dynamic>> companiesList = companies.map((company) {
              return {
                'id': company.id,
                'name': company.name,
                'role_name': company.roleName
              };
            }).toList();

            // Convert to JSON string
            String companiesJson = jsonEncode(companiesList);

            // Save companies data in SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool isCompaniesSaved = await prefs.setString(WorkplaceNotificationConst.companiesData, companiesJson);

            if (isCompaniesSaved) {
              print("✅ Data saved successfully!");
              print("Saved Data: $companiesJson");
            } else {
              print("❌ Failed to save companies data.");
            }

            // Handle nullable company ID
            int selectedCompanyId = right.data!.companiesNew!.isNotEmpty ? (right.data!.companiesNew!.first.id ?? 0) : 0;

            // Save selected company ID in SharedPreferences
            bool isCompanyIdSaved = await prefs.setInt('selected_company_id', selectedCompanyId);
            if (isCompanyIdSaved) {
              print("✅ Selected company ID saved successfully: $selectedCompanyId");
            } else {
              print("❌ Failed to save selected company ID.");
            }

            WorkplaceDataSourcesImpl.selectedCompanySaveId = selectedCompanyId.toString();
            final workplaceDataSources = WorkplaceDataSourcesImpl();
            await workplaceDataSources.getUserProfile();

            print("Selected Company Save ID: ${WorkplaceDataSourcesImpl.selectedCompanySaveId}");

            PrefUtils().saveBool(WorkplaceNotificationConst.isUserLoggedInC, true);
            PrefUtils().saveBool(WorkplaceNotificationConst.isUserFirstTime, true);
            PrefUtils().saveBool(WorkplaceNotificationConst.globalNotificationC, (right.data!.globalNotifications) ?? false);
            PrefUtils().saveStr(WorkplaceNotificationConst.userFirstName, right.data!.firstName);

            String? apiToken = right.data!.token;
            debugPrint('saved<> ${WorkplaceNotificationConst.accessTokenC} $apiToken');

            await PrefUtils().saveStr(WorkplaceNotificationConst.accessTokenC, apiToken);
            WorkplaceDataSourcesImpl().updateApiToken(apiToken);

            UserProfileBloc userProfileBloc = BlocProvider.of<UserProfileBloc>(event.mContext!);
            userProfileBloc.add(FetchProfileDetails(mContext: event.mContext!));

            await for (final state in userProfileBloc.stream) {
              if (state is UserProfileFetched || state is UserProfileError) {
                break;
              }
            }

            appNavigator.launchDashBoardScreen(event.mContext!);
            debugPrint('Token on login: $apiToken');
          } else {
            emit(SignInErrorState(
                context: event.mContext!,
                errorMessage: right.message,
                phone: enteredEmail));
          }
        });
      } catch (e) {
        LoadingWidget2.endLoadingWidget(event.mContext!);
        debugPrint('$e');
        emit(SignInErrorState(context: event.mContext!, errorMessage: "Something went wrong"));
      }
      LoadingWidget2.endLoadingWidget(event.mContext!);
    });
  }
}
