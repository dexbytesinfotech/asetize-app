import 'package:http/http.dart' as http;
import '../../../../core/network/api_base_helpers.dart';
import '../../../../imports.dart';
import '../../models/complaint_category_model.dart';
import '../../models/complaint_data_model.dart';
import '../../models/complaint_detail_model.dart';
import '../../models/post_complaint_comment_model.dart';
import '../../models/put_complaint_comment_model.dart';
import '../../models/raise_complaint_model.dart';
import 'complaint_event.dart';
import 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  ComplaintData? compliantDetailData;
  List<CategoryData> categoryList = [];
  List<ComplaintData> complaintOpenData = [];
  List<ComplaintData> complaintInProgressData = [];
  List<ComplaintData> complaintCompletedData = [];
  ComplaintData? raiseCompliantData;
  ComplaintComments? postCommentData;
  CommentData? commentData;
  int pageNew = 2;
  int pageInProgress = 2;
  int pageCompleted = 2;
  bool? _isPostPageEnded;
  bool? _isPostPageEnded2;
  bool? _isPostPageEnded3;

  set setPostPageEnded(bool value) {
    _isPostPageEnded = value;
  }
  bool get getPostPageEnded => _isPostPageEnded ?? false;

  set setPostPageEnded2(bool value) {
    _isPostPageEnded2 = value;
  }
  bool get getPostPageEnded2 => _isPostPageEnded2 ?? false;

  set setPostPageEnded3(bool value) {
    _isPostPageEnded3 = value;
  }

  bool get getPostPageEnded3 => _isPostPageEnded3 ?? false;

  ComplaintBloc() : super(ComplaintInitialState()) {

    on<FetchComplaintDetailEvent>((event,emit) async {
    emit(ComplaintLoadingState());
    try {
      Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse("${ApiConst.complaintDetail}/${event.complaintId}"),
          ApiBaseHelpers.headers());
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
        } else if (left is NoDataFailure) {
          emit(ComplaintErrorState(errorMessage: left.errorMessage));
        } else if (left is ServerFailure) {
          emit(ComplaintErrorState(errorMessage: 'Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(ComplaintErrorState(errorMessage: left.errorMessage));
        } else {
          emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
        }
      }, (right) {
        compliantDetailData = ComplaintDetail.fromJson(right).data;
        emit(FetchedComplaintDetailDoneState());
      });
    } catch (e) {
      emit(ComplaintErrorState(errorMessage: '$e'));
    }

  });

    on<FetchComplaintCategoryListEvent>((event, emit) async {
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.parse(ApiConst.complaintCategoryList),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          categoryList = ComplaintCategoryModel.fromJson(right).data ?? [];
          emit(ComplaintCategoryDoneState());

        });
      } catch (e) {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

    on<FetchComplaintOpenDataEvent>((event, emit) async {

      emit(ComplaintLoadingState());
      try {
        String url = '${ApiConst.complaintList}/${event.status}';
        Either<Failure, dynamic> response = await ApiBaseHelpers()
            .get(Uri.parse(url), ApiBaseHelpers.headers());

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          }
         else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          print(complaintOpenData);
          complaintOpenData = ComplaintDataModel.fromJson(right).data ?? [];
          pageNew = 2;
          emit(FetchedComplaintOpenDataDoneState());
        });
      } catch (e) {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

    ///Open Complaint On Load
    on<FetchComplaintOpenOnLoadEvent>((event, emit) async {
      emit(OpenDataMoreLoadingState());
      try {
        String url = '${ApiConst.complaintList}/${event.status}?page=$pageNew';
        Either<Failure, dynamic> response = await ApiBaseHelpers()
            .get(Uri.parse(url), ApiBaseHelpers.headers());

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is TooManyAttemptFailure) {
            emit(ComplaintErrorState(errorMessage: 'Too Many Attempt'));
          } else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          List<ComplaintData> complaintOpenOnLoadData = ComplaintDataModel.fromJson(right).data  ?? [];
          if (complaintOpenOnLoadData.isNotEmpty == true) {
            complaintOpenData.addAll(complaintOpenOnLoadData);
          }
          if(complaintOpenOnLoadData.isEmpty == true)
            {
              setPostPageEnded = true;
            }
          pageNew += 1;
          // emit(FetchedComplaintOpenOnLoadDoneState());
          emit(FetchedComplaintOpenDataDoneState());
        });
      } catch (e) {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

    on<FetchComplaintInProgressDataEvent>((event, emit) async {
      emit(ComplaintLoadingState());
      try {
        String url = '${ApiConst.complaintList}/${event.status}';
        Either<Failure, dynamic> response = await ApiBaseHelpers()
            .get(Uri.parse(url), ApiBaseHelpers.headers());

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          complaintInProgressData = ComplaintDataModel.fromJson(right).data ?? [];
          pageInProgress = 2;
          emit(FetchedComplaintInProgressDoneState());
        });
      } catch (e) {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

    ///In progress complaint On Load
    on<FetchComplaintInProgressOnLoadEvent>((event, emit) async {
      emit(InProgressDataMoreLoadingState());
      try {
        String url =
            '${ApiConst.complaintList}/${event.status}?page=$pageInProgress';
        Either<Failure, dynamic> response = await ApiBaseHelpers()
            .get(Uri.parse(url), ApiBaseHelpers.headers());

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          List<ComplaintData> inProgressOnLoadData = ComplaintDataModel.fromJson(right).data  ?? [];
          if (inProgressOnLoadData.isNotEmpty == true) {
            complaintInProgressData.addAll(inProgressOnLoadData);
          }
          if(inProgressOnLoadData.isEmpty == true)
          {
            setPostPageEnded2 = true;
          }
          pageInProgress += 1;
         // emit(FetchedComplaintDInProgressOnLoadDoneState());
          emit(FetchedComplaintInProgressDoneState());
        });
      } catch (e) {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

    on<FetchComplaintCompletedDataEvent>((event, emit) async {
      emit(ComplaintLoadingState());
      try {
        String url = '${ApiConst.complaintList}/${event.status}';
        Either<Failure, dynamic> response = await ApiBaseHelpers()
            .get(Uri.parse(url), ApiBaseHelpers.headers());

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          complaintCompletedData =
              ComplaintDataModel.fromJson(right).data ?? [];
          pageCompleted = 2;
          emit(FetchedComplaintCompletedDataDoneState());
        });
      } catch (e) {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

    ///Completed complaint On Load
    on<FetchComplaintCompletedOnLoadEvent>((event, emit) async {
      emit(CompletedMoreLoadingState());
      try {
        String url =
            '${ApiConst.complaintList}/${event.status}?page=$pageCompleted';
        Either<Failure, dynamic> response = await ApiBaseHelpers()
            .get(Uri.parse(url), ApiBaseHelpers.headers());

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        },
                (right) {
          List<ComplaintData> completedOnLoadData = ComplaintDataModel.fromJson(right).data  ?? [];
          if (completedOnLoadData.isNotEmpty == true) {
            complaintCompletedData.addAll(completedOnLoadData);
          }
          if(completedOnLoadData.isEmpty == true)
          {
            setPostPageEnded3 = true;
          }
          pageCompleted += 1;
          //emit(FetchedComplaintCompletedOnLoadDoneState());
          emit(FetchedComplaintCompletedDataDoneState());
        });
      } catch (e) {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

    ///Apply complaint
    on<RaiseComplaintEvent>((event, emit) async {
      String filePath = "";
      if (event.filePath?.isNotEmpty == true || event.filePath != null) {
        Map<String, dynamic> queryParameters = {
          "collection_name": 'photo',
          "file_path": event.filePath,
        };
        emit(ComplaintLoadingState());
        try {
          Either<Failure, dynamic> response = await postUploadMedia(
            queryParameters: queryParameters,
            headers: ApiBaseHelpers.headersMultipart(),
            apiUrl: ApiConst.updateProfilePhotos,
          );
          /*   Either<Failure, dynamic> response = await ApiBaseHelpers().multipartRequest(
                      Uri.parse(ApiConst.updateProfilePhotos),
                ApiBaseHelpers.headersMultipart(),
                queryParameters
            );

            var data = json.encode(response);*/

          response.fold((left) {
            if (left is UnauthorizedFailure) {
              emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(ComplaintErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(ComplaintErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(ComplaintErrorState(errorMessage: left.errorMessage));
            } else {
              emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
            }
          }, (right) {
            filePath = UploadMediaModel.fromJson(right).data?.fileName ?? " ";
            debugPrint(right.data);
            emit(ComplaintCategoryDoneState());
          });
        } catch (e) {
          debugPrint('$e');
        }
      }
      Map<String, dynamic> queryParameters = {
        "user_id" : event.userId,
        "content": event.content,
        "block_name": event.blockName,
        "floor_number": event.floorNumber,
        "category_id": event.categoryId,
        "file_path": filePath,
      };
      emit(ComplaintLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.applyComplaint),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          try{
            raiseCompliantData = RaiseComplaintModel.fromJson(right).data;
            complaintListUpdateOnApply(raiseCompliantData!);
            emit(ComplaintRaisedDoneState());
          }catch(e)
          {
            emit(ComplaintErrorState(errorMessage: '$e'));
          }

        });
      } catch (e) {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

    ///Update status of complaint
    on<ChangeComplaintStatusEvent>((event,emit) async {
      Map<String, dynamic> queryParameters = {
        "status" : event.status,
      };

      try{
        // Either<Failure, dynamic> response = await ApiBaseHelpers().put(
        //     Uri.parse("${ApiConst.updateStatus}/${event.id}/status"),
        //     ApiBaseHelpers.headersPut(),
        //  queryParameters,
        // );
        Either<Failure, dynamic> response = await putUpdateStatus(queryParameters: queryParameters,
          headers:  ApiBaseHelpers.headersPut(),
          apiUrl: "${ApiConst.updateStatus}/${event.id}/status", );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          commentData = PutComplaintCommentModel.fromJson(right).data;
          updateStatus(commentData);
          emit(ChangeComplaintStatusDoneState(status: commentData?.status ?? ''));
        });
      }
      catch(e)
      {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

    /// Post comment
    on<PostComplaintCommentEvent>((event,emit) async {
     Map<String, dynamic> queryParameters = {
       "comment": event.comment,
       "ticket_id": event.complaintId,
     };
    // emit(ComplaintLoadingState());
     try {
       Either<Failure, dynamic> response = await ApiBaseHelpers().post(
         Uri.parse(ApiConst.postComplaintComment),
         ApiBaseHelpers.headers(),
         body: queryParameters,
       );
       response.fold((left) {
         if (left is UnauthorizedFailure) {
           emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
         } else if (left is NoDataFailure) {
           emit(ComplaintErrorState(errorMessage: left.errorMessage));
         } else if (left is ServerFailure) {
           emit(ComplaintErrorState(errorMessage: 'Server Failure'));
         } else if (left is InvalidDataUnableToProcessFailure) {
           emit(ComplaintErrorState(errorMessage: left.errorMessage));
         } else {
           emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
         }
       }, (right) {
         try{
           postCommentData = ComplaintCommentModel.fromJson(right).data;

           //ComplaintData data = updateComplaintComment(postCommentData!, event.complaintId, event.status);
           updateComplaintComment2(postCommentData!, event.complaintId);
           emit(ComplaintCommentDoneState());
         }catch(e)
         {
           emit(ComplaintErrorState(errorMessage: '$e'));
         }

       });
     } catch (e) {
       emit(ComplaintErrorState(errorMessage: '$e'));
     }
   });

    /// Delete comment
    on<DeleteComplaintCommentEvent>((event,emit) async {
     // emit(ComplaintLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse('${ApiConst.postComplaintComment}/${event.commentId}'),
          ApiBaseHelpers.deleteHeaders(),{}
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(ComplaintErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(ComplaintErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(ComplaintErrorState(errorMessage: left.errorMessage));
          } else {
            emit(ComplaintErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          try{
           deleteCommentUpdateList2(commentId: event.commentId);
            //ComplaintData data =  deleteCommentUpdateList(complaintId: event.complaintId, commentId: event.commentId, status: event.status);
            emit(ComplaintCommentDeleteDoneState());
          }catch(e)
          {
            emit(ComplaintErrorState(errorMessage: '$e'));
          }

        });
      } catch (e) {
        emit(ComplaintErrorState(errorMessage: '$e'));
      }
    });

  }
  ///Update status on detail
  void updateStatus(CommentData? commentData)
  {
    try {
      if(compliantDetailData != null)
      {
        compliantDetailData?.status = commentData?.status;
      }
    } catch (e) {
      print(e);
    }
  }
  /// We are updating complaint list after applied new complaint
  void complaintListUpdateOnApply(ComplaintData data) {
    try {
      data.status = "Open";
      data.isMyComplain = true ;
      complaintOpenData.insert(0, data);
      print(data);
    } catch (e) {
      debugPrint('$e');
    }
  }

  /// Update comment in the detail
  void updateComplaintComment2(ComplaintComments postCommentData,int complaintId)
  {
    try {
      if(compliantDetailData != null)
          {
            compliantDetailData?.comments?.add(postCommentData);
          }
    } catch (e) {
      print(e);
    }
  }


/// Update comment in the list
  ComplaintData updateComplaintComment(ComplaintComments postCommentData,int complaintId, String status)
  {
    ComplaintData? data;
    try{
      if(status.toLowerCase() == "open")
        {
          if(complaintOpenData.isNotEmpty)
          {
            final index = complaintOpenData.indexWhere((data) => data.id == complaintId);
            if (index > -1) {
              try {
                data = complaintOpenData[index];
                data.commentCount = data.commentCount! + 1;
                data.comments = data.comments ?? [];
                data.comments!.add(postCommentData);
                complaintOpenData[index] = data;
              } catch (e) {
                print(e);
              }
            }
          }
        }
      else if(status.toLowerCase() == "inprogress")
        {
          if(complaintInProgressData.isNotEmpty)
          {
            final index = complaintInProgressData.indexWhere((data) => data.id == complaintId);
            if (index > -1) {
              data = complaintInProgressData[index];
              data.commentCount = data.commentCount! + 1;
              data.comments = data.comments ?? [];
              data.comments!.add(postCommentData);
              complaintInProgressData[index] = data;
            }
          }
        }
      else if(status.toLowerCase() == "completed")
        {
          if(complaintCompletedData.isNotEmpty)
          {
            final index = complaintCompletedData.indexWhere((data) => data.id == complaintId);
            if (index > -1) {
              data = complaintCompletedData[index];
              data.commentCount = data.commentCount! + 1;
              data.comments = data.comments ?? [];
              data.comments!.add(postCommentData);
              complaintCompletedData[index] = data;
            }
          }
        }
    }
    catch(e)
    {
     debugPrint('$e');
    }
    return data!;
  }

  /// Update delete comment in the detail
  void deleteCommentUpdateList2({required int commentId})

  {
    try {
      if(compliantDetailData != null)
      {
        final commentIndex = compliantDetailData?.comments!
            .indexWhere((data) => data.commentId == commentId);
        if (commentIndex! > -1) {
          compliantDetailData?.comments!.removeAt(commentIndex);
        }
      }
    } catch (e) {
      print(e);
    }
  }
  /// Update delete comment in the list
  ComplaintData deleteCommentUpdateList({required int complaintId, required int commentId, required String status})
  {
    ComplaintData? data;

    if (status.toLowerCase() == "open") {
      if(complaintOpenData.isNotEmpty)
          {
            final index = complaintOpenData.indexWhere((data) => data.id == complaintId);
            if (index > -1) {
              data = complaintOpenData[index];
              data.comments = data.comments ?? [];
              final commentIndex = data.comments!
                  .indexWhere((data) => data.commentId == commentId);
              if (commentIndex > -1) {
                data.comments!.removeAt(commentIndex);
              }
               data.commentCount = data.commentCount! - 1;
              complaintOpenData[index] = data;
            }
          }
    }
    if (status.toLowerCase() == "inprogress") {
      if(complaintInProgressData.isNotEmpty)
          {
            final index = complaintInProgressData.indexWhere((data) => data.id == complaintId);
            if (index > -1) {
              data = complaintInProgressData[index];
              data.comments = data.comments ?? [];
              final commentIndex = data.comments!
                  .indexWhere((data) => data.commentId == commentId);
              if (commentIndex > -1) {
                data.comments!.removeAt(commentIndex);
              }
               data.commentCount = data.commentCount! - 1;
              complaintInProgressData[index] = data;
            }
          }
    }
    if (status.toLowerCase() == "completed") {
      if(complaintCompletedData.isNotEmpty)
          {
            final index = complaintCompletedData.indexWhere((data) => data.id == complaintId);
            if (index > -1) {
              data = complaintCompletedData[index];
              data.comments = data.comments ?? [];
              final commentIndex = data.comments!
                  .indexWhere((data) => data.commentId == commentId);
              if (commentIndex > -1) {
                data.comments!.removeAt(commentIndex);
              }
               data.commentCount = data.commentCount! - 1;
              complaintCompletedData[index] = data;
            }
          }
    }
    return data!;

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

    debugPrint('URL ======== $apiUrl STATUS = ${rawResponse.statusCode}');
    debugPrint('response=====${json.decode(response.body)}');

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

  Future<Either<Failure, dynamic>> putUpdateStatus({required Map<String, dynamic> queryParameters,
    required Map<String, String> headers,
    required String apiUrl})
  async{
    http.Response response = await http.put(Uri.parse(apiUrl), headers: headers, body: queryParameters);

    if (response.statusCode == 200) {
      return Right(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return Left(NoDataFailure(errorMessage: jsonDecode(response.body)['error']));
    } else if (response.statusCode == 401) {
      return Left(UnauthorizedFailure());
    } else {
      return Left(ServerFailure());
    }
  }

}
