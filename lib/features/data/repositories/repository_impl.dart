import 'package:asetize/features/data/models/get_policy_data_by_id_model.dart';
import 'package:asetize/features/data/models/get_policy_data_model.dart';
import 'package:asetize/features/data/models/post_comment_model.dart';
import 'package:asetize/features/data/models/post_create_post_model.dart';
import 'package:asetize/features/data/models/post_update_token_model.dart';
import 'package:asetize/features/domain/usecases/delete_comment.dart';
import 'package:asetize/features/domain/usecases/delete_spotlight_comment.dart';
import 'package:asetize/features/domain/usecases/delete_user_post.dart';
import 'package:asetize/features/domain/usecases/delete_user_spotlight.dart';
import 'package:asetize/features/domain/usecases/get_policy_data_by_id.dart';
import 'package:asetize/features/domain/usecases/get_spotlight_like.dart';
import 'package:asetize/features/domain/usecases/get_user_post_data.dart';
import 'package:asetize/features/domain/usecases/post_comment.dart';
import 'package:asetize/features/domain/usecases/post_create_post.dart';
import 'package:asetize/features/domain/usecases/post_guest_customer_login.dart';
import 'package:asetize/features/domain/usecases/post_update_token.dart';
import 'package:asetize/features/domain/usecases/post_verify_otp.dart';
import 'package:asetize/features/otp/models/resend_otp_model.dart';
import 'package:asetize/features/otp/models/verify_otp_model.dart';
import 'package:asetize/features/sign_up/models/post_sign_up_model.dart';
import 'package:asetize/imports.dart';
import '../../domain/usecases/post_new_profile_update.dart';
import '../../my_post/models/get_feed_data_model.dart';
import '../models/business_detail_module.dart';

class RepositoryImpl implements Repository {
  final WorkplaceDataSources workplaceDataSources;
  final NetworkInfo networkInfo = NetworkInfoImpl();

  RepositoryImpl(this.workplaceDataSources);

  @override
  Future<Either<Failure, SignInModel>> loinUser(
      {required UserLoginParams userLoginParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.loinUser(userDetails: userLoginParams);
        return Right(SignInModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserResponseModel>> getUserProfile({Map<String, dynamic>? param}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getUserProfile(param:param);
        return Right(UserResponseModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getUserLogout(
      {required UserLogoutParams userLogoutParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getUserLogout(
            userLogoutParams: userLogoutParams);
        return Right(
            response['message'] == 'Logout successfully.' ? true : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TeamDetailsModel>> getTeamDetails() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getTeamDetails();
        return Right(TeamDetailsModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, BusinessDetailsModel>> getBusinessDetails() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getBusinessDetails();
        return Right(BusinessDetailsModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.deleteUser();
        return Right(
            response['message'] == 'customer.Account deleted successfully'
                ? true
                : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserResponseModel>> profileUpdate(
      {required ProfileUpdateParams profileUpdateParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.profileUpdate(
            profileUpdateParams: profileUpdateParams);
        return Right(UserResponseModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }


  @override
  Future<Either<Failure, UserResponseModel>> newProfileUpdate(
      {required NewProfileUpdateParams newProfileUpdateParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.newProfileUpdate(newProfileUpdateParams: newProfileUpdateParams);
        return Right(UserResponseModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, FaqModal>> getFaq() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getFaq();
        return Right(FaqModal.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AboutUsModal>> getAboutUs() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getAboutUs();
        return Right(AboutUsModal.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> postChangePassword(
      {required ChangePasswordParams changePasswordParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.postChangePassword(
            changePasswordParams: changePasswordParams);
        return Right(response['message'] == 'Password updated successfully'
            ? true
            : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UploadMediaModel>> postUploadMedia(
      {required UploadMediaParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.postUploadMedia(params: params);
        return Right(UploadMediaModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GetHomeDataModel>> getHomeData() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getHomeData();
        return Right(GetHomeDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, BirthdayDataModel>> getBirthdayData() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getBirthdayData();
        return Right(BirthdayDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, MarriageAnniversaryDataModel>>
      getMarriageAnniversaryData() async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.getMarriageAnniversaryData();
        return Right(MarriageAnniversaryDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, WorkAnniversaryDataModel>>
      getWorkAnniversaryData() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getWorkAnniversaryData();
        return Right(WorkAnniversaryDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, EventDataModel>> getEventData() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getEventData();
        return Right(EventDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, HolidayDataModel>> getHolidayData() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getHolidayData();
        return Right(HolidayDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, FeedDataModel>> getFeedData(
      {FeedParams? feedParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.getFeedData(feedParams: feedParams!);
        return Right(FeedDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }


  @override
  Future<Either<Failure, GetLeaveTypeModel>> getLeaveType() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getLeaveType();
        return Right(GetLeaveTypeModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GetLeaveDataModel>> getLeaveData(
      {LeaveParams? leaveParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.getLeaveData(leaveParams: leaveParams!);
        return Right(GetLeaveDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, PostLeaveApplyModel>> postLeaveApply(
      {required LeaveApplyParams leaveApplyParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.postLeaveApply(
            leaveApplyParams: leaveApplyParams);
        return Right(PostLeaveApplyModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationDataModel>> getNotification() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getNotification();
        return Right(NotificationDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> postLikeUpdate(
      {required PostLikeParams postLikeParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.postLikeRequest(
            postLikeParams: postLikeParams);
        return Right(response['message'] == 'Successfully' ? true : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SinglePostModel>> getSinglePost(
      {required singlePostParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getSinglePost(
            singlePostParams: singlePostParams);
        return Right(SinglePostModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GetLeaveDetailModel>> getLeaveDetailById(
      {required LeaveDetailParams leaveDetailParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getLeaveDetailById(
            leaveDetailParams: leaveDetailParams);
        return Right(GetLeaveDetailModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GetLeaveDataModel>> getTeamLeaves() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getTeamLeaveData();
        return Right(GetLeaveDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, PostLeaveApplyModel>> postLeaveStatusChange(
      {required LeaveStatusChangeParams leaveStatusChangeParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.postLeaveStatusApply(
            leaveStatusChangeParams: leaveStatusChangeParams);
        return Right(PostLeaveApplyModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GetLeaveDetailModel>> getTeamLeaveDetailById(
      {required TeamLeaveDetailParams teamLeaveDetailParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getTeamLeaveDetailById(
            teamLeaveDetailParams: teamLeaveDetailParams);
        return Right(GetLeaveDetailModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> putMarkNotificationDisplayed() async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.putMarkNotificationDisplayed();
        return Right(
            response['message'] == 'Message status updated successfully'
                ? true
                : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> putMarkNotificationRead(
      {required MarkNotificationReadParams markNotificationReadParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.putMarkNotificationRead(
            markNotificationReadParams: markNotificationReadParams);
        return Right(
            response['message'] == 'Message status updated successfully'
                ? true
                : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> putMarkNotificationReadDisplay(
      {required MarkNotificationReadDisplayParams
          markNotificationReadDisplayParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.putMarkNotificationReadDisplay(
                markNotificationReadDisplayParams:
                    markNotificationReadDisplayParams);
        return Right(
            response['message'] == 'Message status updated successfully'
                ? true
                : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, FamilyModel>> getFamilyDataList() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getFamilyDataList();
        return Right(FamilyModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFamilyMember(
      {required FamilyParams familyParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.deleteFamilyMember(
            familyParams: familyParams);
        return Right(response['message'] == "Family deleted Successfully"
            ? true
            : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SingleFamilyMemberModel>> postFamilyMemberDetails(
      {required AddFamilyMemberParams addFamilyMemberParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.postFamilyMemberDetails(
            addFamilyMemberParams: addFamilyMemberParams);
        return Right(SingleFamilyMemberModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SingleFamilyMemberModel>> putFamilyMemberDetails(
      {required EditFamilyMemberParams editFamilyMemberParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.putFamilyMemberDetails(
            editFamilyMemberParams: editFamilyMemberParams);
        return Right(SingleFamilyMemberModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, PolicyModel>> getPolicyData() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getPolicyData();
        return Right(PolicyModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GetPolicyDataByIdModel>> getPolicyDataById(
      {required PolicyDetailParams policyDetailParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getPolicyDataById(
            policyDetailParams: policyDetailParams);
        return Right(GetPolicyDataByIdModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, PostCommentModel>> postComment(
      {required PostCommentParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.postComment(postCommentParams: params);
        return Right(PostCommentModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, CreatePostModel>> postCreate(
      {required CreatePostParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.postCreate(createPostParams: params);
        return Right(CreatePostModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        if (e is InvalidDataUnableToProcessException) {
          return Left(
              InvalidDataUnableToProcessFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }


  @override
  Future<Either<Failure, FeedDataModel>> getUserPostData(
      {required UserPostParams userPostParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getUserPostData(
            userPostParams: userPostParams);
        return Right(FeedDataModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserPost(
      {required DeleteUserPostParams deleteUserParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.deleteUserPost(
            deleteUserParams: deleteUserParams);
        return Right(
            response['message'] == "Post deleted Successfully" ? true : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteComment(
      {required DeleteCommentParams deleteCommentParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.deleteComment(
            deleteCommentParams: deleteCommentParams);
        return Right(response['message'] == "Comment deleted Successfully"
            ? true
            : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> spotlightLikeRequest(
      {required SpotlightLikeParams spotlightLikeParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.spotlightLikeRequest(
            spotlightLikeParams: spotlightLikeParams);
        return Right(response['message'] == 'Successfully.' ? true : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }


  @override
  Future<Either<Failure, bool>> deleteSpotlightComment(
      {required DeleteSpotlightCommentParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await workplaceDataSources.deleteSpotlightComment(params: params);
        return Right(response['message'] == "Comment deleted Successfully"
            ? true
            : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSpotlight(
      {required DeleteUserSpotlightParams deleteUserSpotlightParams}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.deleteSpotlight(
            deleteUserSpotlightParams: deleteUserSpotlightParams);
        return Right(response['message'] == "Spotlight deleted Successfully"
            ? true
            : false);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SignUpModel>> postGuestCustomerLogin({required GuestCustomerLoginParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.postGuestCustomerLogin(params: params);
        return Right(SignUpModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, VerifyOtpModel>> postVerifyOtp({required VerifyOtpParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.postVerifyOtp(params: params);
        return Right(VerifyOtpModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ResendOtpModel>> getResendOtp() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.getResendOtp();
        return Right(ResendOtpModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UpdateTokenModel>> updateToken({required UpdateTokeParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await workplaceDataSources.updateToken(params: params);
        return Right(UpdateTokenModel.fromJson(response));
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } catch (e) {
        if (e is DataNotFoundException) {
          return Left(NoDataFailure(errorMessage: e.errorMessage));
        }  if (e is InvalidDataUnableToProcessException) {
          return Left(
              InvalidDataUnableToProcessFailure(errorMessage: e.errorMessage));
        }
        return Left(ParsingFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }


}
