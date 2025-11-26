import 'package:asetize/imports.dart';
import '../../domain/usecases/delete_comment.dart';
import '../../domain/usecases/delete_spotlight_comment.dart';
import '../../domain/usecases/delete_user_post.dart';
import '../../domain/usecases/delete_user_spotlight.dart';
import '../../domain/usecases/get_policy_data_by_id.dart';
import '../../domain/usecases/get_spotlight_like.dart';
import '../../domain/usecases/get_user_post_data.dart';
import '../../domain/usecases/post_comment.dart';
import '../../domain/usecases/post_create_post.dart';
import '../../domain/usecases/post_guest_customer_login.dart';
import '../../domain/usecases/post_new_profile_update.dart';
import '../../domain/usecases/post_update_token.dart';
import '../../domain/usecases/post_verify_otp.dart';

abstract class WorkplaceDataSources {
  Future<Map<String, dynamic>> loinUser({required UserLoginParams userDetails});
  Future<Map<String, dynamic>> getUserProfile({Map<String, dynamic>? param});
  Future<Map<String, dynamic>> getUserLogout(
      {required UserLogoutParams userLogoutParams});
  Future<Map<String, dynamic>> getTeamDetails();
  Future<Map<String, dynamic>> getBusinessDetails();

  Future<Map<String, dynamic>> deleteUser();
  Future<Map<String, dynamic>> profileUpdate(
      {required ProfileUpdateParams profileUpdateParams});

  Future<Map<String, dynamic>> newProfileUpdate(
      {required NewProfileUpdateParams newProfileUpdateParams});

  Future<Map<String, dynamic>> getFaq();

  Future<Map<String, dynamic>> getNotification();

  Future<Map<String, dynamic>> getAboutUs();

  Future<Map<String, dynamic>> postChangePassword(
      {required ChangePasswordParams changePasswordParams});

  Future<Map<String, dynamic>> postUploadMedia(
      {required UploadMediaParams params});

  Future<Map<String, dynamic>> getHomeData();

  Future<Map<String, dynamic>> getBirthdayData();

  Future<Map<String, dynamic>> getWorkAnniversaryData();

  Future<Map<String, dynamic>> getMarriageAnniversaryData();

  Future<Map<String, dynamic>> getEventData();

  Future<Map<String, dynamic>> getHolidayData();

  Future<Map<String, dynamic>> getFeedData({required FeedParams feedParams});


  Future<Map<String, dynamic>> getLeaveType();

  Future<Map<String, dynamic>> getLeaveData({required LeaveParams leaveParams});

  Future<Map<String, dynamic>> postLeaveApply(
      {required LeaveApplyParams leaveApplyParams});

  Future<Map<String, dynamic>> postLikeRequest(
      {required PostLikeParams postLikeParams});

  Future<Map<String, dynamic>> getSinglePost(
      {required SinglePostParams singlePostParams});

  Future<Map<String, dynamic>> getLeaveDetailById(
      {required LeaveDetailParams leaveDetailParams});

  Future<Map<String, dynamic>> getTeamLeaveData();

  Future<Map<String, dynamic>> postLeaveStatusApply(
      {required LeaveStatusChangeParams leaveStatusChangeParams});

  Future<Map<String, dynamic>> getTeamLeaveDetailById(
      {required TeamLeaveDetailParams teamLeaveDetailParams});

  Future<Map<String, dynamic>> putMarkNotificationDisplayed();

  Future<Map<String, dynamic>> putMarkNotificationRead(
      {required MarkNotificationReadParams markNotificationReadParams});

  Future<Map<String, dynamic>> putMarkNotificationReadDisplay(
      {required MarkNotificationReadDisplayParams
          markNotificationReadDisplayParams});

  Future<Map<String, dynamic>> getFamilyDataList();

  Future<Map<String, dynamic>> deleteFamilyMember(
      {required FamilyParams familyParams});

  Future<Map<String, dynamic>> postFamilyMemberDetails(
      {required AddFamilyMemberParams addFamilyMemberParams});

  Future<Map<String, dynamic>> putFamilyMemberDetails(
      {required EditFamilyMemberParams editFamilyMemberParams});

  void updateApiToken(final String? apiToken);
  void cleanAllInstance();

  Future<Map<String, dynamic>> getPolicyData();

  Future<Map<String, dynamic>> getPolicyDataById(
      {required PolicyDetailParams policyDetailParams});

  Future<Map<String, dynamic>> postComment(
      {required PostCommentParams postCommentParams});

  Future<Map<String, dynamic>> postCreate(
      {required CreatePostParams createPostParams});

  Future<Map<String, dynamic>> getUserPostData(
      {required UserPostParams userPostParams});

  Future<Map<String, dynamic>> deleteUserPost(
      {required DeleteUserPostParams deleteUserParams});

  Future<Map<String, dynamic>> deleteComment(
      {required DeleteCommentParams deleteCommentParams});

  Future<Map<String, dynamic>> getSpotlightRecentData();

  Future<Map<String, dynamic>> spotlightLikeRequest(
      {required SpotlightLikeParams spotlightLikeParams});

  Future<Map<String, dynamic>> deleteSpotlightComment(
      {required DeleteSpotlightCommentParams params});

  Future<Map<String, dynamic>> deleteSpotlight(
      {required DeleteUserSpotlightParams deleteUserSpotlightParams});


  Future<Map<String, dynamic>> postGuestCustomerLogin(
      {required GuestCustomerLoginParams params});

  Future<Map<String, dynamic>> postVerifyOtp(
      {required VerifyOtpParams params});

  Future<Map<String, dynamic>> getResendOtp();

  Future<Map<String, dynamic>> updateToken({required UpdateTokeParams params});

}
