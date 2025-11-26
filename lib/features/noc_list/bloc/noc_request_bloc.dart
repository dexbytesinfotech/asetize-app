import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../models/noc_request_model.dart';
import '../models/noc_singal_request_model.dart';
import 'noc_request_event.dart';
import 'noc_request_state.dart';
import 'package:http/http.dart' as http;

class NocRequestBloc extends Bloc<NocRequestEvent, NocRequestState> {

  List<NocRequestData> nocRequestData = [];

  SingalData? singalNocRequestData;

  NocRequestBloc() : super(NocRequestInitialState()) {

    on<OnGetNocListEvent>((event, emit) async {

      emit(NocRequestLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.nocList),
          ApiBaseHelpers.headers(),);
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(NocRequestListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(NocRequestListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(NocRequestListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(NocRequestListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(NocRequestListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(NocRequestListErrorState(errorMessage: error));
          } else {
            nocRequestData = NocRequestHistoryModel.fromJson(right).data ?? [];
            emit(NocRequestListDoneState());
          }
        });
      } catch (e) {
        emit(NocRequestListErrorState(errorMessage: '$e'));
      }
    });

    on<OnUpdateNocListEvent>((event, emit) async {
      emit(UpdateNocListLoadingState());

      Map<String, dynamic> queryParameters = {
        // 'id': event.id,
        'status': event.status,
        "action_remark": event.rejectReason
      };

      try {
        String url = '${ApiConst.nocListUpdate}/${event.id}/status';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );

        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(UpdateNocListErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(UpdateNocListErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(UpdateNocListErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(UpdateNocListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(UpdateNocListErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              emit(UpdateNocListErrorState(errorMessage: right['error']));
            } else {
              final message = right['message'] ?? 'Operation completed successfully.';
              emit(UpdateNocListDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(UpdateNocListErrorState(errorMessage: "$e"));
      }
    });


    on<OnGetSingalNocRecordEvent>((event, emit) async {
      // Map<String, String> queryParams = {
      //   'id': event.id.toString()
      //
      // };

      emit(SingalNocRecordLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(ApiConst.isProduction ? ApiConst.baseUrlNonProdHttpC : ApiConst.baseUrlNonHttpC, "/api/nocs/${event.id}",),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(SingalNocRecordErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(SingalNocRecordErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(SingalNocRecordErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SingalNocRecordErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(SingalNocRecordErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(SingalNocRecordErrorState(errorMessage: error));
          } else {
            singalNocRequestData = SingalDataModel.fromJson(right).data;
            emit(SingalNocRecordDoneState());
          }
        });
      } catch (e) {
        emit(SingalNocRecordErrorState(errorMessage: '$e'));
      }
    });


    on<OnNOCReportUploadEvent>((event, emit) async {
      String filePath = "";

      if (event.filePath?.isNotEmpty == true) {
        Map<String, dynamic> queryParameters = {
          "collection_name": 'photo',
          "file_path": event.filePath,
        };

        emit(NOCReportUploadLoadingState());

        try {
          Either<Failure, dynamic> response = await postUploadMedia(
            queryParameters: queryParameters,
            headers: ApiBaseHelpers.headersMultipart(),
            apiUrl: ApiConst.updateProfilePhotos,
          );

          bool hasError = false;

          response.fold((left) {
            hasError = true;

            if (left is UnauthorizedFailure) {
              emit(NOCReportUploadErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(NOCReportUploadErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(NOCReportUploadErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(NOCReportUploadErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(NOCReportUploadErrorState(errorMessage: 'Something went wrong'));
            }
          }, (right) {
            if (right != null && right.containsKey('error')) {
              hasError = true;
              emit(NOCReportUploadErrorState(errorMessage: right['error']));
            } else {
              filePath = UploadMediaModel.fromJson(right).data?.fileName ?? "";
            }
          });

          if (hasError || filePath.isEmpty) {
            return; // Do not proceed to second API call
          }
        } catch (e) {
          debugPrint('$e');
          emit(NOCReportUploadErrorState(errorMessage: '$e'));
          return; // Do not proceed to second API call
        }
      }

      // Proceed only if media upload was successful
      Map<String, dynamic> queryParameters = {
        "file_path": filePath,
      };

      try {
        String url = '${ApiConst.nocListUpdate}/${event.id}/nocupload';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );

        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(NOCReportUploadErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(NOCReportUploadErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(NOCReportUploadErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(NOCReportUploadErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(NOCReportUploadErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              emit(NOCReportUploadErrorState(errorMessage: right['error']));
            } else {
              emit(NOCReportUploadDoneState());
            }
          },
        );
      } catch (e) {
        emit(NOCReportUploadErrorState(errorMessage: "$e"));
      }




    });



  }



  Future<Either<Failure, dynamic>> postUploadMedia(
      {required Map<String, dynamic> queryParameters,
        required Map<String, String> headers,
        required String apiUrl}) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);
    try {
      request.files.add(await http.MultipartFile.fromPath(
          'file', queryParameters['file_path']));
    } catch (e) {
      debugPrint('$e');
    }
    try {
      request.fields['collection_name'] = queryParameters['collection_name'];
    } catch (e) {
      debugPrint('$e');
    }
    var rawResponse = await request.send();

    var response = await http.Response.fromStream(rawResponse);

    if (rawResponse.statusCode == 200) {
      //return jsonDecode(response.body);
      return Right(jsonDecode(response.body));
    } else if (rawResponse.statusCode == 404) {
      // throw DataNotFoundException(errorMessage: jsonDecode(response.body)['error']);
      return Left(
          NoDataFailure(errorMessage: jsonDecode(response.body)['error']));
    } else if (rawResponse.statusCode == 401) {
      // throw UnauthorizedException();
      return Left(UnauthorizedFailure());
    } else {
      // throw ServerException();
      return Left(ServerFailure());
    }
  }
}
