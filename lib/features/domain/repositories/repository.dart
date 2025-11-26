import 'package:asetize/imports.dart';
import '../../data/models/business_detail_module.dart';
import '../../data/models/post_update_token_model.dart';
import '../../my_post/models/get_feed_data_model.dart';
import '../../data/models/get_policy_data_by_id_model.dart';
import '../../data/models/get_policy_data_model.dart';
import '../../data/models/post_comment_model.dart';
import '../../data/models/post_create_post_model.dart';
import '../../otp/models/resend_otp_model.dart';
import '../../otp/models/verify_otp_model.dart';
import '../../sign_up/models/post_sign_up_model.dart';
import '../usecases/delete_comment.dart';
import '../usecases/delete_spotlight_comment.dart';
import '../usecases/delete_user_post.dart';
import '../usecases/delete_user_spotlight.dart';
import '../usecases/get_policy_data_by_id.dart';
import '../usecases/get_spotlight_like.dart';
import '../usecases/get_user_post_data.dart';
import '../usecases/post_comment.dart';
import '../usecases/post_create_post.dart';
import '../usecases/post_guest_customer_login.dart';
import '../usecases/post_new_profile_update.dart';
import '../usecases/post_update_token.dart';
import '../usecases/post_verify_otp.dart';

abstract class Repository {
  //Get otp
  Future<Either<Failure, SignInModel>> loinUser(
      {required UserLoginParams userLoginParams});
  Future<Either<Failure, bool>> getUserLogout(
      {required UserLogoutParams userLogoutParams});
  Future<Either<Failure, UserResponseModel>> getUserProfile({Map<String, dynamic>? param});

  Future<Either<Failure, GetLeaveDataModel>> getTeamLeaves();

  Future<Either<Failure, TeamDetailsModel>> getTeamDetails();
  Future<Either<Failure, BusinessDetailsModel>> getBusinessDetails();

  Future<Either<Failure, bool>> deleteUser();

  Future<Either<Failure, UserResponseModel>> profileUpdate(
      {required ProfileUpdateParams profileUpdateParams});

  Future<Either<Failure, UserResponseModel>> newProfileUpdate(
      {required NewProfileUpdateParams newProfileUpdateParams});

  Future<Either<Failure, FaqModal>> getFaq();

  Future<Either<Failure, NotificationDataModel>> getNotification();

  Future<Either<Failure, AboutUsModal>> getAboutUs();

  Future<Either<Failure, bool>> postChangePassword(
      //..
      {required ChangePasswordParams changePasswordParams});

  Future<Either<Failure, UploadMediaModel>> postUploadMedia(
      {required UploadMediaParams params});

  Future<Either<Failure, GetHomeDataModel>> getHomeData();
  Future<Either<Failure, BirthdayDataModel>> getBirthdayData();
  Future<Either<Failure, WorkAnniversaryDataModel>> getWorkAnniversaryData();
  Future<Either<Failure, MarriageAnniversaryDataModel>>
      getMarriageAnniversaryData();
  Future<Either<Failure, EventDataModel>> getEventData();
  Future<Either<Failure, HolidayDataModel>> getHolidayData();
  Future<Either<Failure, FeedDataModel>> getFeedData(
      {required FeedParams feedParams});
  Future<Either<Failure, GetLeaveTypeModel>> getLeaveType();
  Future<Either<Failure, GetLeaveDataModel>> getLeaveData(
      {required LeaveParams leaveParams});
  Future<Either<Failure, PostLeaveApplyModel>> postLeaveApply(
      {required LeaveApplyParams leaveApplyParams});
  Future<Either<Failure, bool>> postLikeUpdate(
      {required PostLikeParams postLikeParams});

  Future<Either<Failure, SinglePostModel>> getSinglePost(
      {required SinglePostParams singlePostParams});

  Future<Either<Failure, GetLeaveDetailModel>> getLeaveDetailById(
      {required LeaveDetailParams leaveDetailParams});
  Future<Either<Failure, PostLeaveApplyModel>> postLeaveStatusChange({
    required LeaveStatusChangeParams leaveStatusChangeParams,
  });

  Future<Either<Failure, GetLeaveDetailModel>> getTeamLeaveDetailById(
      {required TeamLeaveDetailParams teamLeaveDetailParams});

  Future<Either<Failure, bool>> putMarkNotificationDisplayed();
  Future<Either<Failure, bool>> putMarkNotificationRead(
      {required MarkNotificationReadParams markNotificationReadParams});
  Future<Either<Failure, bool>> putMarkNotificationReadDisplay(
      {required MarkNotificationReadDisplayParams
          markNotificationReadDisplayParams});

  Future<Either<Failure, FamilyModel>> getFamilyDataList();
  Future<Either<Failure, bool>> deleteFamilyMember(
      {required FamilyParams familyParams});
  Future<Either<Failure, SingleFamilyMemberModel>> postFamilyMemberDetails(
      {required AddFamilyMemberParams addFamilyMemberParams});

  Future<Either<Failure, SingleFamilyMemberModel>> putFamilyMemberDetails(
      {required EditFamilyMemberParams editFamilyMemberParams});

  Future<Either<Failure, PolicyModel>> getPolicyData();

  Future<Either<Failure, GetPolicyDataByIdModel>> getPolicyDataById(
      {required PolicyDetailParams policyDetailParams});

  Future<Either<Failure, PostCommentModel>> postComment(
      {required PostCommentParams params});

  Future<Either<Failure, CreatePostModel>> postCreate(
      {required CreatePostParams params});


  Future<Either<Failure, FeedDataModel>> getUserPostData(
      {required UserPostParams userPostParams});

  Future<Either<Failure, bool>> deleteUserPost(
      {required DeleteUserPostParams deleteUserParams});

  Future<Either<Failure, bool>> deleteComment(
      {required DeleteCommentParams deleteCommentParams});

  Future<Either<Failure, bool>> spotlightLikeRequest(
      {required SpotlightLikeParams spotlightLikeParams});

  Future<Either<Failure, bool>> deleteSpotlightComment(
      {required DeleteSpotlightCommentParams params});

  Future<Either<Failure, bool>> deleteSpotlight(
      {required DeleteUserSpotlightParams deleteUserSpotlightParams});

  Future<Either<Failure, SignUpModel>> postGuestCustomerLogin(
      {required GuestCustomerLoginParams params});

  Future<Either<Failure, VerifyOtpModel>> postVerifyOtp(
      {required VerifyOtpParams params});

  Future<Either<Failure, ResendOtpModel>> getResendOtp();

  Future<Either<Failure, UpdateTokenModel>> updateToken(
      {required UpdateTokeParams params});

}
