import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:asetize/imports.dart';
import '../../../core/network/api_base_helpers.dart';
import '../../domain/usecases/post_new_profile_update.dart';

class WorkplaceDataSourcesImpl implements WorkplaceDataSources {
  static String? token;
  static String? selectedCompanySaveId;
  static String? guestUserToken;
  String? deviceTypeName;
  static List<dynamic> teamDataList = [];
  static List<dynamic> businessDataList = [];
  static List<dynamic> homeTodayLeaveList = [];
  static List<dynamic> homeTodayWFHList = [];
  static List<dynamic> homeBirthdayList = [];
  static List<dynamic> homeMarriageAnniversaryList = [];
  static List<dynamic> homeWorkAnniversaryList = [];
  static List<dynamic> spotlightUserList = [];
  static Map<String, dynamic> profileList = {};
  static Map<String, dynamic> profileAdditionalInfo = {};

  WorkplaceDataSourcesImpl() {
    deviceTypeName = Platform.isAndroid ? "android" : "ios";
    // ApiBaseHelpers.setAccessToken = WorkplaceDataSourcesImpl.token;
     ApiBaseHelpers.setCompanyId = WorkplaceDataSourcesImpl.selectedCompanySaveId;
    // ApiBaseHelpers.setGuestUserToken = WorkplaceDataSourcesImpl.guestUserToken;
    // PrefUtils()
    //     .readStr(WorkplaceNotificationConst.accessTokenC)
    //     .then((value) { token = value;
    // ApiBaseHelpers.setAccessToken = token;
    //     }
    // );
  }

  @override
  Future<Map<String, dynamic>> loinUser(
      {required UserLoginParams userDetails}) async {
    http.Response response = await http.post(
      Uri.parse(ApiConst.userLogin),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': userDetails.email,
        'password': userDetails.password,
        'deviceId': userDetails.deviceId,
        'deviceName': userDetails.deviceName,
        // 'fcmToken': userDetails.fcmToken,
        'deviceVersion': userDetails.deviceVersion,
        'deviceType': userDetails.deviceType,
      }),
    );


    if (response.statusCode == 200) {
      //parse your modal here
      await PrefUtils().saveStr(WorkplaceNotificationConst.accessTokenC,
          json.decode(response.body)["data"]["token"]);
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getUserProfile({Map<String, dynamic>? param}) async {
    // await PrefUtils()
    //     .readStr(WorkplaceNotificationConst.accessTokenC)
    //     .then((value) => token = value);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // int? selectedCompanyId = prefs.getInt('selected_company_id') ?? 1; // Default to 1 if not found
    //
    // selectedCompanySaveId=selectedCompanyId.toString();
 String profileUrl = ApiConst.userProfile;
 try {
   if(param!["isCompanySwitched"]==true && selectedCompanySaveId!=null && selectedCompanySaveId!.isNotEmpty){
      profileUrl = "$profileUrl/$selectedCompanySaveId";
    }
 } catch (e) {
   print(e);
 }
    http.Response response = await http.get(
      Uri.parse(profileUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );



    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      try {
        WorkplaceDataSourcesImpl.profileList = data['data'];
        WorkplaceDataSourcesImpl.profileAdditionalInfo =
            data['data']['additional_info'];

      } catch (e) {
        debugPrint('$e');
      }

      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getUserLogout(
      {required UserLogoutParams userLogoutParams}) async {
    String url = "${ApiConst.userLogout}/${userLogoutParams.deviceId}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getTeamDetails() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.teamDetails),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      // Map<String, dynamic> _additionalInfo = {};
      // _additionalInfo = data['data'][0]['additional_info'];
      try {
        WorkplaceDataSourcesImpl.teamDataList = data['data'];
      } catch (e) {
        debugPrint('$e');
      }

      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }


  @override
  Future<Map<String, dynamic>> getBusinessDetails() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.businessDetails),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      // Map<String, dynamic> _additionalInfo = {};
      // _additionalInfo = data['data'][0]['additional_info'];
      try {
        WorkplaceDataSourcesImpl.businessDataList = data['data'];
      } catch (e) {
        debugPrint('$e');
      }

      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }


  @override
  Future<Map<String, dynamic>> deleteUser() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.deleteProfile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }
///Update global notification
  @override
  Future<Map<String, dynamic>> profileUpdate(
      {required ProfileUpdateParams profileUpdateParams}) async {
    Map<String, dynamic> parameters = {};
    http.Response? response;

    parameters.clear();
    if (profileUpdateParams.globalNotifications != null) {
      parameters['global_notifications'] =
          profileUpdateParams.globalNotifications;
    }
    if (profileUpdateParams.profilePhoto != null) {
      parameters['profile_photo'] = profileUpdateParams.profilePhoto;
    }


    response = await http.post(Uri.parse(ApiConst.profileUpdate),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(parameters));
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  ///Update profile photo
  @override
  Future<Map<String, dynamic>> newProfileUpdate(
      {required NewProfileUpdateParams newProfileUpdateParams}) async {
    Map<String, dynamic> parameters = {};

    http.Response? response;

    parameters.clear();
    if (newProfileUpdateParams.profilePhoto != null) {
      parameters['profile_photo'] = newProfileUpdateParams.profilePhoto;
    }
   if (newProfileUpdateParams.firstName != null) {
      parameters['first_name'] = newProfileUpdateParams.firstName;
    }
   if (newProfileUpdateParams.lateName != null) {
      parameters['last_name'] = newProfileUpdateParams.lateName;
    }
   // if (newProfileUpdateParams.email != null) {
   //    parameters['email'] = newProfileUpdateParams.email;
   //  }

    response = await http.post(Uri.parse(ApiConst.newProfileUpdate),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(parameters));
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }


  @override
  Future<Map<String, dynamic>> getFaq() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.faqUser),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );


    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getNotification() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.notificationDataList),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getAboutUs() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.aboutUs),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> postChangePassword(
      {required ChangePasswordParams changePasswordParams}) async {
    http.Response response = await http.post(
      Uri.parse(ApiConst.changePasswords),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'old_password': changePasswordParams.oldPassword,
        'password': changePasswordParams.newPassword,
        'password_confirmation': changePasswordParams.confirmPassword
      }),
    );


    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> postUploadMedia(
      {required UploadMediaParams params}) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiConst.updateProfilePhotos));
    Map<String, String> headers = {
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'X-CSRF-TOKEN': ' ',
      'Authorization': 'Bearer $token'
    };

    request.headers.addAll(headers);
    try {
      request.files.add(await http.MultipartFile.fromPath('file', params.filePath));
    } catch (e) {
      debugPrint('$e');
    }
    try {
      request.fields['collection_name'] = params.collectionName;
    } catch (e) {
      debugPrint('$e');
    }
    var rawResponse = await request.send();

    var response = await http.Response.fromStream(rawResponse);

    try {
    } catch (e) {
      print(e);
    }

    if (rawResponse.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (rawResponse.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (rawResponse.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getHomeData() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.homeData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      try {
        Map<String, dynamic> data2 = data['data'];
        WorkplaceDataSourcesImpl.homeTodayLeaveList = data2['today_leaves'];
        WorkplaceDataSourcesImpl.homeTodayWFHList = data2['today_wfh'];
        WorkplaceDataSourcesImpl.homeBirthdayList = data2['birthday'];
        WorkplaceDataSourcesImpl.homeWorkAnniversaryList =
            data2['work_anniversary'];
        WorkplaceDataSourcesImpl.homeMarriageAnniversaryList =
            data2['marriage_anniversary'];
      } catch (e) {
        debugPrint('$e');
      }
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getBirthdayData() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.birthdayData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getMarriageAnniversaryData() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.marriageAnniversaryData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getWorkAnniversaryData() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.workAnniversaryData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );


    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getEventData() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.eventData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getHolidayData() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.holidayData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );


    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getFeedData({required feedParams}) async {
    http.Response response = await http.get(
      Uri.parse(feedParams.url ?? ApiConst.feedPostData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getHomeAnnouncementData({required homeAnnouncementParams}) async {
    http.Response response = await http.get(
      Uri.parse(homeAnnouncementParams.url ?? ApiConst.announcementPostData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getLeaveType() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.leaveType),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> postLeaveApply(
      {required leaveApplyParams}) async {
    http.Response response = await http
        .post(
          Uri.parse(ApiConst.leaveApply),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            'leave_type_id': leaveApplyParams.leaveTypeID,
            'reason': leaveApplyParams.reason,
            'duration': leaveApplyParams.duration,
            'start_date': leaveApplyParams.startDate,
            'end_date': leaveApplyParams.endDate
          }),
        )
        .timeout(const Duration(seconds: 10));


    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getLeaveData({required leaveParams}) async {
    http.Response response = await http.get(
      Uri.parse(leaveParams.url ?? ApiConst.leaveDataList),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> postLikeRequest(
      {required PostLikeParams postLikeParams}) async {
    String url = "${ApiConst.postLikeApi}/${postLikeParams.postId.toString()}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getSinglePost(
      {required singlePostParams}) async {
    String url =
        "${ApiConst.singleNotificationPostApi}/${singlePostParams.postId.toString()}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getLeaveDetailById(
      {required LeaveDetailParams leaveDetailParams}) async {
    String url =
        "${ApiConst.leaveDataByID}/${leaveDetailParams.postId.toString()}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getTeamLeaveData() async {
    http.Response response = await http.get(
      Uri.parse(ApiConst.teamLeaveData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> postLeaveStatusApply(
      {required LeaveStatusChangeParams leaveStatusChangeParams}) async {
    http.Response response = await http
        .post(
          Uri.parse(ApiConst.leaveStatusChange),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            'id': leaveStatusChangeParams.leaveId,
            'status': leaveStatusChangeParams.status,
          }),
        )
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getTeamLeaveDetailById(
      {required TeamLeaveDetailParams teamLeaveDetailParams}) async {
    String url =
        "${ApiConst.teamLeaveDataByID}/${teamLeaveDetailParams.postId.toString()}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> putMarkNotificationDisplayed() async {
    http.Response response = await http.put(
      Uri.parse(ApiConst.notificationDisplay),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> putMarkNotificationRead(
      {required MarkNotificationReadParams markNotificationReadParams}) async {
    String url =
        "${ApiConst.notificationRead}/${markNotificationReadParams.messageID.toString()}";
    http.Response response = await http.put(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> putMarkNotificationReadDisplay(
      {required MarkNotificationReadDisplayParams
          markNotificationReadDisplayParams}) async {
    String url =
        "${ApiConst.notificationReadDisplay}/${markNotificationReadDisplayParams.messageID.toString()}";
    http.Response response = await http.put(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getFamilyDataList() async {
    http.Response response =
        await http.get(Uri.parse(ApiConst.familyApi), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> deleteFamilyMember(
      {required FamilyParams familyParams}) async {
    String url = "${ApiConst.familyApi}/${familyParams.familyId.toString()}";
    http.Response response = await http.delete(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> postFamilyMemberDetails(
      {required AddFamilyMemberParams addFamilyMemberParams}) async {
    http.Response response =
        await http.post(Uri.parse(ApiConst.familyApi), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Company-ID': selectedCompanySaveId??'',

    }, body: {
      'name': addFamilyMemberParams.name,
      'dob': addFamilyMemberParams.dob,
      'relation': addFamilyMemberParams.relation,
      'photo': addFamilyMemberParams.photo,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> putFamilyMemberDetails(
      {required EditFamilyMemberParams editFamilyMemberParams}) async {
    String url =
        "${ApiConst.familyApi}/${editFamilyMemberParams.familyId.toString()}";
    http.Response response = await http.put(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'name': editFamilyMemberParams.name,
      'dob': editFamilyMemberParams.dob,
      'relation': editFamilyMemberParams.relation,
      'photo': editFamilyMemberParams.photo,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  void updateApiToken(String? apiToken) {
    // TODO: implement updateApiToken

    WorkplaceDataSourcesImpl.token = apiToken;
    ApiBaseHelpers.setAccessToken = apiToken;

    PrefUtils()
        .saveStr(WorkplaceNotificationConst.accessTokenC, apiToken);
  }

  @override
  void cleanAllInstance() {
    // TODO: implement updateApiTocken
    WorkplaceDataSourcesImpl.token = null;
    ApiBaseHelpers.setAccessToken = null;

    PrefUtils()
        .saveStr(WorkplaceNotificationConst.accessTokenC, null);
  }

  @override
  Future<Map<String, dynamic>> getPolicyData() async {
    http.Response response =
        await http.get(Uri.parse(ApiConst.policyData), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });


    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getPolicyDataById(
      {required PolicyDetailParams policyDetailParams}) async {
    String url =
        "${ApiConst.policyData}/${policyDetailParams.postId.toString()}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> postComment(
      {required PostCommentParams postCommentParams}) async {
    http.Response response = await http.post(Uri.parse(ApiConst.postComment),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Company-ID': selectedCompanySaveId??'',
        },
        body: jsonEncode(<String, dynamic>{
          'comment': postCommentParams.commentText,
          'post_id': postCommentParams.postId,
        }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> postCreate(
      {required CreatePostParams createPostParams}) async {
    Map<String, dynamic> requestData = {};
    if (createPostParams.title != null && createPostParams.title!.isNotEmpty) {
      requestData["title"] = createPostParams.title;
    }

    if (createPostParams.content != null &&
        createPostParams.content!.isNotEmpty) {
      requestData["content"] = createPostParams.content;
    }

    if (createPostParams.media != null && createPostParams.media!.isNotEmpty) {
      requestData["media"] = createPostParams.media;
    }

    if (createPostParams.status != null &&
        createPostParams.status!.isNotEmpty) {
      requestData["status"] = createPostParams.status;
    }

    http.Response response = await http.post(Uri.parse(ApiConst.postCreate),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Company-ID': selectedCompanySaveId??'',
        },
        body: jsonEncode(requestData));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 422) {
      throw InvalidDataUnableToProcessException(
          errorMessage: jsonDecode(response.body)['error']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getUserPostData(
      {required UserPostParams userPostParams}) async {
    http.Response response = await http.get(
      Uri.parse(userPostParams.url ?? ApiConst.userPostData),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> deleteUserPost(
      {required DeleteUserPostParams deleteUserParams}) async {
    String url =
        "${ApiConst.deleteUserPost}/${deleteUserParams.postId.toString()}";
    http.Response response = await http.delete(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Company-ID': selectedCompanySaveId??'',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> deleteComment(
      {required DeleteCommentParams deleteCommentParams}) async {
    String url =
        "${ApiConst.deleteComment}/${deleteCommentParams.commentId.toString()}";
    http.Response response = await http.delete(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Company-ID': selectedCompanySaveId??'',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }


  @override
  Future<Map<String, dynamic>> getSpotlightRecentData() async {
    http.Response response =
        await http.get(Uri.parse(ApiConst.spotlightRecentData), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Company-ID': selectedCompanySaveId??'',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }


  @override
  Future<Map<String, dynamic>> spotlightLikeRequest(
      {required SpotlightLikeParams spotlightLikeParams}) async {
    String url =
        "${ApiConst.likeSpotlight}/${spotlightLikeParams.spotlightId.toString()}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Company-ID': selectedCompanySaveId??'',
      },
    );
    if (response.statusCode == 200) {
      //parse your modal here
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: json.decode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> deleteSpotlightComment(
      {required DeleteSpotlightCommentParams params}) async {
    String url = "${ApiConst.spotlightComment}/${params.commentId.toString()}";
    http.Response response = await http.delete(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Company-ID': selectedCompanySaveId??'',

    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> deleteSpotlight(
      {required DeleteUserSpotlightParams deleteUserSpotlightParams}) async {
    String url =
        "${ApiConst.userSpotlight}/${deleteUserSpotlightParams.spotlightId.toString()}";
    http.Response response = await http.delete(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Company-ID': selectedCompanySaveId??'',

    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> postGuestCustomerLogin({required GuestCustomerLoginParams params}) async {
    http.Response response =
        await http.post(Uri.parse(ApiConst.guestCustomerLogin),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'email': params.email,
          'name': params.name,
        }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }


  @override
  Future<Map<String, dynamic>> postVerifyOtp({required VerifyOtpParams params}) async {
    http.Response response =
        await http.post(Uri.parse(ApiConst.verifyOtp),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'otp': params.otp,
          'deviceId': params.deviceId,
          'deviceName': params.deviceName,
          'fcmToken': params.fcmToken,
          'deviceVersion': params.deviceVersion,
          'deviceType': params.deviceType,
        }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getResendOtp() async {
    http.Response response =
    await http.get(Uri.parse(ApiConst.resendOtp), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> updateToken({required UpdateTokeParams params}) async {
    http.Response response =
        await http.post(Uri.parse(ApiConst.updateToken),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'deviceId': params.deviceId,
          'deviceName': params.deviceName,
          'fcmToken': params.fcmToken,
          'deviceVersion': params.deviceVersion,
          'deviceType': params.deviceType,
          'app_version': params.appVersion,
        }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw DataNotFoundException(
          errorMessage: jsonDecode(response.body)['error']);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  }

}
