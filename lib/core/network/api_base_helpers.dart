import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asetize/core/error/exceptions.dart';
import 'package:asetize/core/util/api_constant.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../imports.dart';
import '../error/failures.dart';
import 'base_model.dart';
import 'failures.dart';
import 'network_info.dart';
export 'failures.dart';
export 'package:either_dart/either.dart';

enum RequestType { GET, POST, PUT, DELETE, PATCH, MULTIPART }

class ApiBaseHelpers {



  static SharedPreferences? prefs; // Declare this as static so it can be accessed in static methods
  static String selectedCompanySaveId = ''; // Default value
  // static String? saveGuestUserToken; // Default value
  // static String? saveTokenForProject; // Default value



  // static Future<void> initializePrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   selectedCompanySaveId = prefs?.getInt('selected_company_id') ?? 1;
  // } // Default to 1 if not found

  static const String baseUrlDevC =
      'gjkoimqlywnvajymlsyh.supabase.co'; //Development

  static const String baseUrlProC =
      'gjkoimqlywnvajymlsyh.supabase.co'; // Production

  static String baseUrl = ApiConst.isProduction ? baseUrlProC : baseUrlDevC;
  static set updateAppBaseUrl(String value) {
    baseUrl = value;
  }

  static String accessToken = "";
  static String refreshToken = "";

  static set setAccessToken (String? value){
    accessToken = value??"";
  }
  static set setCompanyId (String? value){
    selectedCompanySaveId = value??"";
  }
  static String get getAccessToken => accessToken;

  static set setrefreshToken (String? value){
    refreshToken = value??"";
  }
  static String get getrefreshToken => refreshToken;

  static Map<String, String> getJsonHeaders() {
    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Company-ID': '1',
    };
    return headers;
  }

  static Map<String, String> headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'X-Company-ID': selectedCompanySaveId,

    };
  }

  static Map<String, String> headersForVisitor() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNzM0MTQ3MjRkOWNiOGExNTRmM2NlYTJkYjVjNGJlZWU5MWUyZmRhZjA4MDcwMjJlNTAwODFmMjUzYjdmNGRjZjdmNDc1MGIxMTUxZTRjOGIiLCJpYXQiOjE3NDQyMDA1ODEuODU5MjA5LCJuYmYiOjE3NDQyMDA1ODEuODU5MjExLCJleHAiOjE3NzU3MzY1ODEuODU0ODM0LCJzdWIiOiIxODgiLCJzY29wZXMiOlsic2VjdXJpdHktZ3VhcmQiXX0.sQuhogm6WyWNUsFYLkg9PrGRNULMYvuNFQeSjR4FecslI0V7PrwWXdxdPNVipQjKFNjL9GC-lNgGykmTLareGz2xl5EPZkKxDB5Goq479sutHV88HvL2kqvUAG9n_0Y7LplAQL_YpW5SZ-jXGHcARS7REtXC4HMBHjd90Md5GkF3eeVanh_d1STKXDnY95uH4Pd_X849gk54CiFCCYHNmP7WiED5aJTKxUk_QDvxAjokOYiltiftiL72GKAJK7Fr5sk367InsG2EH2IMHSUZ2D0pHaqiIoy32P4Jbu7njE7x6_PCTj-H_KDcz-gU1rYlyTAM41VuyqRtTs5bvhanB5NXS5wYhPJXDu0rTLDeXzgcquNnY0LMd-zBwDgWaFuzPIRk1kn4qoI9aczKw786I69rueHMoZhptp3XQ-goM3WdJCO8Q7z6VrelJ1k7Ds5f9CREXfkydmtNdeWL6wlqaEw_3apWt4d9ewPulP05jfnF4s9MF4uush_yddbS7pmrGG7y2IC-mF7Y-rPVgFO1qk9p10RNOYv2WMYXzaKCcag-bR7bq220tK0tx0XpNIduGETnfCwzdrppQe9RoGMg7sB_3IAlhIhldkj8sVRnj7OvUjifnoHXwza8VT6OAoT1aSbagDlS0DeW_rSfNjXvkH2MwyI_TmcBKWKvN9QArMM',
      'X-Company-ID': "1",

    };
  }

  static Map<String, String> guestHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }



  static Map<String, String> guestOtpVerifyHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token!=null?'Bearer $token':'Bearer $accessToken',
    };
  }

  static Map<String, String> guestProfileUpdateHeaders({String? accessTokenStr}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': accessTokenStr!=null?'Bearer $accessTokenStr':'Bearer $accessToken',
    };
  }



  static Map<String, String> deleteHeaders() => {
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken'
  };

  static Map<String, String> headersRefresh() => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
    'Cookie': 'jwt-refresh-token=$refreshToken'
  };

  /*  static Map<String, String> headersMultipart() => {
    'Content-Type': 'multipart/form-data',
    'Authorization': 'Bearer $accessToken'
  };*/

  static Map<String, String> headersMultipart() => {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
    'X-CSRF-TOKEN': ' ',
    'Authorization': 'Bearer $accessToken'
  };

  static Map<String, String> headersPut() => {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    'X-CSRF-TOKEN': ' ',
    'Authorization': 'Bearer $accessToken',
    'X-Company-ID': selectedCompanySaveId,
  };

  final NetworkInfo networkInfo = NetworkInfoImpl();

  Future<Either<Failure, dynamic>> get(
      Uri url,
      Map<String, String>? headers,
      ) async {
    Map body = {};
    return await _request(url, RequestType.GET, headers, body);
  }

  Future<Either<Failure, dynamic>> post<T extends BaseModel>(
      Uri url, Map<String, String>? headers,
      {Map? body}) async {
    return await _request(url, RequestType.POST, headers, body);
  }

  Future<Either<Failure, dynamic>> patch<T extends BaseModel>(
      Uri url, Map<String, String>? headers, Map? body) async {
    return await _request(url, RequestType.PATCH, headers, body);
  }

  Future<Either<Failure, dynamic>> put<T extends BaseModel>(
      Uri url, Map<String, String>? headers, Map? body) async {
    return await _request(url, RequestType.PUT, headers, body);
  }

  Future<Either<Failure, dynamic>> delete<T extends BaseModel>(
      Uri url, Map<String, String>? headers, Map? body) async {
    return await _request(url, RequestType.DELETE, headers, body);
  }


  Future<dynamic> multipartRequest<T extends BaseModel>(
      Uri url, Map<String, String>? headers, Map? body) async {
    return await _request(url, RequestType.MULTIPART, headers, body);
  }

  Future<Either<Failure, dynamic>> _request<T extends BaseModel>(Uri url, RequestType type,
      Map<String, String>? headers, Map? body) async {

    /// Check internet connection before calling API
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    /// Call APIs
    var actualHeaders = getJsonHeaders();
    if (headers != null) {
      actualHeaders.addAll(headers);
    }
    try {
      final jsonString = jsonEncode(body);
      switch (type) {
        case RequestType.GET:
          var response = await http.get(url, headers: actualHeaders);

          /// Check Token validation here
          String? accessToken = await isTokenValid(response);
          if (accessToken != null && accessToken.trim().isNotEmpty) {
            if (actualHeaders.containsKey("Authorization")) {
              actualHeaders["Authorization"] = "Bearer $accessToken";
            }
            response = await http.get(url, headers: actualHeaders);
          }

          return returnResponse(response);
        case RequestType.POST:
          var response =
          await http.post(url, headers: actualHeaders, body: jsonString);
          /// Check Token validation here
          String? accessToken = await isTokenValid(response);
          if (accessToken != null && accessToken.trim().isNotEmpty) {
            if (actualHeaders.containsKey("Authorization")) {
              actualHeaders["Authorization"] = "Bearer $accessToken";
            }
            response =
            await http.post(url, headers: actualHeaders, body: jsonString);
          }
          return returnResponse(response);

        case RequestType.MULTIPART:

          var request = http.MultipartRequest("POST", url)
            ..headers.addAll(actualHeaders);
          request.files.add(await http.MultipartFile.fromPath("file", jsonDecode(jsonString)["file"]));

          final response = await request.send();

          if(response.statusCode ==200){
            final responseString =
            await response.stream.transform(utf8.decoder).join();
            // return responseString;

            // return returnResponse(responseString);
          }

          // final s3Path = resultValue['file_url'];
          // var response =
          //     await http.post(url, headers: actualHeaders, body: jsonString);
          // /// Check Token validation here
          // String? accessToken = await isTokenValid(response);
          // if (accessToken != null && accessToken.trim().isNotEmpty) {
          //   if (actualHeaders.containsKey("Authorization")) {
          //     actualHeaders["Authorization"] = "Bearer $accessToken";
          //   }
          //   response =
          //       await http.post(url, headers: actualHeaders, body: jsonString);
          // }
          return  throw BadRequestException("File Not Uploaded Failed");
        case RequestType.PATCH:
          var response =
          await http.patch(url, headers: actualHeaders, body: jsonString);

          /// Check Token validation here
          String? accessToken = await isTokenValid(response);
          if (accessToken != null && accessToken.trim().isNotEmpty) {
            if (actualHeaders.containsKey("Authorization")) {
              actualHeaders["Authorization"] = "Bearer $accessToken";
            }
            response =
            await http.patch(url, headers: actualHeaders, body: jsonString);
          }
          return returnResponse(response);
        case RequestType.PUT:
          var response = await http.put(url, headers: actualHeaders, body: jsonString);
          /// Check Token validation here
          String? accessToken = await isTokenValid(response);
          if (accessToken != null && accessToken.trim().isNotEmpty) {
            if (actualHeaders.containsKey("Authorization")) {
              actualHeaders["Authorization"] = "Bearer $accessToken";
            }
            response = await http.put(url, headers: actualHeaders, body: jsonString);
          }
          return returnResponse(response);

        case RequestType.DELETE:
          var response = await http.delete(url, headers: actualHeaders, body: jsonString);
          /// Check Token validation here
          String? accessToken = await isTokenValid(response);
          if (accessToken != null && accessToken.trim().isNotEmpty) {
            if (actualHeaders.containsKey("Authorization")) {
              actualHeaders["Authorization"] = "Bearer $accessToken";
            }
            response = await http.delete(url,
                headers: actualHeaders, body: jsonString);
          }

          return returnResponse(response);
      }
    }
    on ServerException {
      return Left(ServerFailure());
    }
    on SocketException {
      return Left(ServerFailure());
    }

  }

  /// Check Access token and call refresh token API
  Future<String?>? isTokenValid(http.Response response) async {
    return null;

    /// This function will return null in cass of refresh token API failed
    /// Return empty ("") in case of old token is valid
    /// Return updated token in case of old token is valid
    if (response.statusCode == 403) {
      Map<String, dynamic> responseJson = json.decode(response.body.toString());
      if (responseJson.containsKey("code") &&
          responseJson["code"] == "token_not_valid") {
        Map<String, String> header = {
          'Content-Type': 'application/json',
          // 'X-Dts-Schema': '${UserProfileManager.instance.xDtsSchema}',
          'Authorization': 'Bearer $accessToken',
          'Cookie':
          'jwt-auth=$accessToken; jwt-refresh-token=$refreshToken'
        };
        final response = await http.post(
            Uri.parse("https://$baseUrl/auth/token/refresh/"),
            headers: header);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          Map<String, dynamic>? responseJson =
          json.decode(response.body.toString());
          if (responseJson != null &&
              responseJson.containsKey("access") &&
              responseJson["access"].toString().isNotEmpty) {
            String accessToken = responseJson["access"].toString();
            // SharedPreferencesFile().saveStr(accessTokenC, accessToken);
            // SharedPreferencesFile().saveStr(refreshTokenC, respModel.refreshToken);
            // SharedPreferencesFile().saveStr(xDtsSchemaC, respModel.user.tenants.first.schemaName);
            accessToken = accessToken;
            return accessToken;
            // DashboardDataProvider.refreshToken = respModel.refreshToken;
          }
          return null;
        }
      }
      return null;
    }
    return "";
  }

  Either<Failure, dynamic> returnResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var responseJson = json.decode(response.body.toString());
      // return responseJson;

      return Right(responseJson);
    }
    switch (response.statusCode) {
      case 400:
      // throw BadRequestException(response.body.toString());
        return Left(
            InvalidDataUnableToProcessFailure(errorMessage: response.body.toString()));
      case 422:
      // throw BadRequestException(response.body.toString());
        return Left(
            InvalidDataUnableToProcessFailure(errorMessage: response.body.toString()));
      case 401:
      // DashboardDataProvider.logoutAction();
        var responseJson = json.decode(response.body.toString());
        var result = AppExceptionResult.fromJSON(responseJson);
        return Left(UnauthorizedFailure(errorMessage: responseJson));
      case 404:
      // DashboardDataProvider.logoutAction();
        var responseJson = json.decode(response.body.toString());
        var result = AppExceptionResult.fromJSON(responseJson);
        return Left(UnauthorizedFailure(errorMessage: result.message));
    // throw UnauthorisedException(
    //     message: response.body.toString(), result: result);
      case 403:
        var responseJson = json.decode(response.body.toString());
        var result = AppExceptionResult.fromJSON(responseJson);
        // throw UnauthorisedException(
        //     message: response.body.toString(), result: result);
        return Left(UnauthorizedFailure(errorMessage: responseJson));
      case 429:
        return Left(TooManyAttemptFailure());
      case 500:
        return Left(ServerFailure());
      default:
      // DashboardDataProvider.logoutAction();
        return Left(ServerFailure());
    // throw FetchDataException(
    //     message:
    //         'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }



  Future<String> uploadPicture(String filePath) async {
    try {
      final response = await ApiBaseHelpers().multipartRequest(
          Uri.https(
              ApiBaseHelpers.baseUrl, "/api/file/upload/dynamic/"),
          ApiBaseHelpers.headersMultipart(),{"file":filePath});
      final resultValue = jsonDecode(response);
      final s3Path = resultValue['file_url'];
      return s3Path;
    } catch (e) {
      return '';
    }
  }


  Future<Map<String,dynamic>?> uploadPictureDynamicResponse(String filePath) async {
    try {
      final response = await ApiBaseHelpers().multipartRequest(
          Uri.https(
              ApiBaseHelpers.baseUrl, "/api/file/upload/dynamic/"),
          ApiBaseHelpers.headersMultipart(),{"file":filePath});
      final resultValue = jsonDecode(response);
      // final s3Path = resultValue['file_url'];
      return resultValue;
    } catch (e) {
      return null;
    }
  }

}

class AppException implements Exception {
  String message;
  String prefix;
  AppExceptionResult? result;

  AppException({required this.message, required this.prefix, this.result});

  String toString() {
    return "$message";
  }
}

class AppExceptionResult {
  String message;
  AppExceptionResult({required this.message});

  static AppExceptionResult fromJSON(Map<String, dynamic> json) {
    String message = "";
    if(json.containsKey('error')){
      message = json['error'];
    }
    else if(json.containsKey('details')){
      message = json['details'];
    }
    else {
      message = json['detail'];
    }
    return AppExceptionResult(
        message: message);
  }
}

class FetchDataException extends AppException {
  String message;
  FetchDataException({required this.message})
      : super(message: message, prefix: "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message])
      : super(message: message, prefix: "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  String message;
  AppExceptionResult? result;
  UnauthorisedException({required this.message, this.result})
      : super(message: message, prefix: "Unauthorised: ", result: result);
}

class InvalidInputException extends AppException {
  InvalidInputException([message])
      : super(message: message, prefix: "Invalid Input: ");
}