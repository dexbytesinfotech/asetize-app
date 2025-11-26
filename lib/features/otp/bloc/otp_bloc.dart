import '../../../core/util/app_navigator/app_navigator.dart';
import '../../../imports.dart';
import '../../domain/usecases/get_resend_otp.dart';
import '../../domain/usecases/post_verify_otp.dart';
import '../models/resend_otp_model.dart';
import '../models/verify_otp_model.dart';
part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent,OtpState>{

  PostVerifyOtp verifyOtp = PostVerifyOtp(RepositoryImpl(WorkplaceDataSourcesImpl()));
  GetResendOtp resendOtp = GetResendOtp(RepositoryImpl(WorkplaceDataSourcesImpl()));

  OtpBloc() : super(OtpInitialState()){

   on<SendOtpEvent>((event ,emit) async {
     await projectUtil.deviceInfo();

     String fcmToken = await PrefUtils().readStr(WorkplaceNotificationConst.deviceTokenC);  //FCM tokes
     String deviceId = await PrefUtils().readStr(WorkplaceNotificationConst.deviceIdC);
     String deviceName = await PrefUtils().readStr(WorkplaceNotificationConst.deviceNameC);
     String deviceVersion = await PrefUtils().readStr(WorkplaceNotificationConst.deviceOsVersionC);
     String deviceType = Platform.isAndroid ? "android" : "ios";

     emit(OtpLoadingState());

     Either<Failure, VerifyOtpModel> response =
         await verifyOtp.call( VerifyOtpParams(
         otp: event.otp,
         deviceId: deviceId,
         deviceName: deviceName,
         deviceType: deviceType,
         deviceVersion: deviceVersion,
         fcmToken: fcmToken,
     ));
     response.fold((left) {
       if (left is UnauthorizedFailure) {
         appNavigator.tokenExpireUserLogout(event.context);
       }else if (left is NoDataFailure) {
         emit(OtpErrorState(error: left.errorMessage));
       } else if (left is NetworkFailure) {
         emit( OtpErrorState(error : 'Network not available'));
       } else if (left is NoDataFailure) {
         emit(OtpErrorState(error : left.errorMessage));
       } else if (left is ServerFailure) {
         emit(OtpErrorState(error : 'Server Failure'));
       } else {
         emit(OtpErrorState(error : 'Something went wrong'));
       }
     }, (right) async {
       if (right.data != null) {
         PrefUtils()
             .saveBool(WorkplaceNotificationConst.isUserLoggedInC, true);
         PrefUtils()
             .saveBool(WorkplaceNotificationConst.isUserFirstTime, true);
         PrefUtils().saveBool(WorkplaceNotificationConst.globalNotificationC,
             (right.data!.globalNotifications) ?? false);
         PrefUtils().saveStr(WorkplaceNotificationConst.userFirstName,
             right.data!.firstName);

         String? apiToken = right.data!.token;

         await PrefUtils()
             .saveStr(WorkplaceNotificationConst.accessTokenC, apiToken);
         WorkplaceDataSourcesImpl().updateApiToken(apiToken);
         //emit(SendOtpDoneState());
        appNavigator.launchDashBoardScreen(event.context);
       }
       else{
         emit(OtpErrorState(
             error: right.message));
       }
     });
   });

   on<GetOtpEvent>((event ,emit) async {
    // emit(OtpLoadingState());
     Either<Failure, ResendOtpModel> response = await resendOtp.call('');
     response.fold((left) {
       if (left is UnauthorizedFailure) {
         appNavigator.tokenExpireUserLogout(event.context);
       } else if (left is NoDataFailure) {
         emit(OtpErrorState(error: left.errorMessage));
       } else if (left is NetworkFailure) {
         emit( OtpErrorState(error : 'Network not available'));
       } else if (left is NoDataFailure) {
         emit(OtpErrorState(error : left.errorMessage));
       } else if (left is ServerFailure) {
         emit(OtpErrorState(error : 'Server Failure'));
       } else {
         emit(OtpErrorState(error : 'Something went wrong'));
       }
     }, (right) {
       emit(GetOtpDoneState());
     });
   });
  }


}