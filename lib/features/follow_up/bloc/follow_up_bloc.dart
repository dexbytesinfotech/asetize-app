import 'package:asetize/features/follow_up/bloc/follow_up_event.dart';
import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../models/get_comment_list_model.dart';
import '../models/get_follow_up_list_model.dart';
import '../models/get_quotation_list_model.dart';
import '../models/get_task_detail_model.dart';
import '../models/get_task_filters_list_model.dart';
import '../models/get_task_list_model.dart';
import '../models/task_history_list_model.dart';
import '../models/generate_title_description_model.dart';
import 'follow_up_state.dart';
import 'package:http/http.dart' as http;

class FollowUpBloc extends Bloc<FollowUpEvent, FollowUpState> {

  List<TaskListData> taskListData = [];
  List<TaskListData> completeTaskListData = [];
  List<GetFollowUpListData> getFollowUpListData = [];
  List<TaskHistoryListData>? taskHistoryListData;
  List<GetQuotationListData>? getQuotationListData = [];

  List<GetFollowUpListData> getFollowUpHistoryData = [];

  GetTaskDetailData? getTaskDetailData ;

  GenerateTitleDescriptionData? generateTitleDescriptionData ;

  List<GetTaskCommentData>? getTaskCommentData = [];

  List<String> taskTypes = [];
  List<String> statuses = [];
  List<Assignees> assignees =[];
  List<String> datePresets=[];
  List<String> priorities=[];

  bool isPaginateLoading = false;
  String nextPageUrl = '';
  int currentPage = 1;

  bool isCompletePaginateLoading = false;
  String nextPageCompleteUrl = '';
  int currentCompletePage = 1;

  // SingalData? singalNocRequestData;

  FollowUpBloc() : super(FollowUpInitialState()) {


    // on<OnGetTaskListEvent>((event, emit) async {
    //   Map<String, String> queryParams = {
    //     'from_date': event.fromDate ?? '',
    //     'to_date': event.toDate ?? '',
    //     'today': (event.today ?? false).toString(), // Convert bool to string
    //     'module_name': event.moduleName ?? '',
    //     'status': event.status ?? '',
    //     'followup_status': event.followupStatus ?? '',
    //   };
    //
    //   emit(GetTaskListLoadingState());
    //   try {
    //     Either<Failure, dynamic> response = await ApiBaseHelpers().get(
    //         Uri.https(ApiConst.isProduction ? ApiConst.baseUrlNonProdHttpC : ApiConst.baseUrlNonHttpC, "api/tasks",
    //             queryParams),
    //         ApiBaseHelpers.headers());
    //     response.fold((left) {
    //       if (left is UnauthorizedFailure) {
    //         emit(GetTaskListErrorState(errorMessage: 'Unauthorized Failure'));
    //       } else if (left is NoDataFailure) {
    //         emit(GetTaskListErrorState(
    //             errorMessage: jsonDecode(left.errorMessage)['error']));
    //       } else if (left is ServerFailure) {
    //         emit(GetTaskListErrorState(errorMessage: 'Server Failure'));
    //       } else if (left is InvalidDataUnableToProcessFailure) {
    //         emit(GetTaskListErrorState(
    //             errorMessage: jsonDecode(left.errorMessage)['error']));
    //       } else {
    //         emit(GetTaskListErrorState(errorMessage: 'Something went wrong'));
    //       }
    //     }, (right) {
    //       if (right != null && right.containsKey('error')) {
    //         String error = "${right['error']}";
    //         emit(GetTaskListErrorState(errorMessage: error));
    //       } else {
    //         taskListData = TaskListModel.fromJson(right).data ?? [];
    //         emit(GetTaskListDoneState(message: ''));
    //       }
    //     });
    //   } catch (e) {
    //     emit(GetTaskListErrorState(errorMessage: '$e'));
    //   }
    // });


    String _toApiFormat(String? value, {String allKeyword = ""}) {
      if (value == null || value.isEmpty) return "";
      if (value.toLowerCase().startsWith("all")) return ""; // Handle "All Status", "All Priorities" etc.
      return value.toLowerCase().replaceAll("_", " "); // snake_case
    }

    on<OnGetTaskListEvent>((event, emit) async {
      Map<String, String> queryParams = {
        'from_date': event.fromDate ?? '',
        'to_date': event.toDate ?? '',
        'today': (event.today ?? false) ? "true" : "false",
        'module_name': event.moduleName ?? '',
        'status':   _toApiFormat(event.status),
        'followup_status': _toApiFormat(event.followupStatus),
        'assignee': event.assignee?.toString() ?? '',
        'priority': _toApiFormat(event.priority),
        "search": event.search ?? '',
        "my_tasks": event.myTask.toString(),
        "page": event.nextPageKey.toString(),
      };

      emit(GetTaskListLoadingState());

      if (event.nextPageKey == 1) {
        // Clear only on first page
        taskListData.clear();
      }

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.https(
            ApiConst.isProduction
                ? ApiConst.baseUrlNonProdHttpC
                : ApiConst.baseUrlNonHttpC,
            "api/tasks",
            queryParams,
          ),
          ApiBaseHelpers.headers(),
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetTaskListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetTaskListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetTaskListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetTaskListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetTaskListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetTaskListErrorState(errorMessage: error));
          } else {
            nextPageUrl = TaskListModel.fromJson(right).pagination?.nextPageApiUrl ?? '';
            currentPage = TaskListModel.fromJson(right).pagination?.currentPage ?? 1;

            final newItems = TaskListModel.fromJson(right).data ?? [];

            for (final item in newItems) {
              if (!taskListData.any((existing) => existing.id == item.id)) {
                taskListData.add(item);
              }
            }


            // taskListData = TaskListModel.fromJson(right).data ?? [];
            emit(GetTaskListDoneState(message: ''));
          }
        });
      } catch (e) {
        emit(GetTaskListErrorState(errorMessage: '$e'));
      }
    });


    on<OnGetCompleteTaskListEvent>((event, emit) async {
      Map<String, String> queryParams = {
        'from_date': event.fromDate ?? '',
        'to_date': event.toDate ?? '',
        'today': (event.today ?? false) ? "true" : "false",
        'module_name': event.moduleName ?? '',
        'status':   _toApiFormat(event.status),
        'followup_status': _toApiFormat(event.followupStatus),
        'assignee': event.assignee?.toString() ?? '',
        'priority': _toApiFormat(event.priority),
        "search": event.search ?? '',
        "my_tasks": event.myTask.toString(),
        "page": event.pageKey.toString(),

      };

      if (event.pageKey == 1) {
        completeTaskListData.clear(); // only for refresh
        emit(GetCompleteTaskListLoadingState());
      }









      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(ApiConst.isProduction ? ApiConst.baseUrlNonProdHttpC : ApiConst.baseUrlNonHttpC, "api/tasks", queryParams),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            isCompletePaginateLoading = false;
            emit(GetCompleteTaskListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            isCompletePaginateLoading = false;
            emit(GetCompleteTaskListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            isCompletePaginateLoading = false;
            emit(GetCompleteTaskListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            isCompletePaginateLoading = false;
            emit(GetCompleteTaskListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            isCompletePaginateLoading = false;
            emit(GetCompleteTaskListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetCompleteTaskListErrorState(errorMessage: error));
          } else {
            nextPageCompleteUrl = TaskListModel.fromJson(right).pagination?.nextPageApiUrl ?? '';
            currentCompletePage = TaskListModel.fromJson(right).pagination?.currentPage ?? 1;

            final newItems = TaskListModel.fromJson(right).data ?? [];

            for (final item in newItems) {
              if (!completeTaskListData.any((existing) => existing.id == item.id)) {
                completeTaskListData.add(item);
              }
            }



            isCompletePaginateLoading = false;
            // completeTaskListData = TaskListModel.fromJson(right).data ?? [];
            emit(GetTaskListDoneState(message: ''));
          }
        });
      } catch (e) {
        emit(GetCompleteTaskListErrorState(errorMessage: '$e'));
      }
    });


    on<OnAssignTaskEvent>((event, emit) async {
      emit(AssignTaskLoadingState());

      Map<String, dynamic> queryParameters = {
        'assigned_to': event.assignToId,
      };

      try {
        String url = '${ApiConst.assignTask}/${event.taskId}/assign';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );

        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(AssignTaskErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(AssignTaskErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(AssignTaskErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(AssignTaskErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(AssignTaskErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              emit(AssignTaskErrorState(errorMessage: right['error']));
            } else {
              final message = right['message'] ?? 'Operation completed successfully.';
              emit(AssignTaskDoneState(message: message,));
            }
          },
        );
      } catch (e) {
        emit(AssignTaskErrorState(errorMessage: "$e"));
      }
    });


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



    on<OnMarkTaskAsCompleteEvent>((event, emit) async {
      emit(MarkTaskAsCompleteLoadingState());

      String filePath = "";
      if (event.completedImages?.isNotEmpty == true) {
        Map<String, dynamic> queryParameters = {
          "collection_name": 'photo',
          "file_path": event.completedImages,
        };
        emit(MarkTaskAsCompleteLoadingState());

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
              emit(MarkTaskAsCompleteErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(MarkTaskAsCompleteErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(MarkTaskAsCompleteErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(MarkTaskAsCompleteErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(MarkTaskAsCompleteErrorState(errorMessage: 'Something went wrong'));
            }
          }, (right) {
            if (right != null && right.containsKey('error')) {
              hasError = true;
              emit(MarkTaskAsCompleteErrorState(errorMessage: right['error']));
            } else {
              filePath = UploadMediaModel.fromJson(right).data?.fileName ?? "";
              // emit(UploadVoucherImageDoneState(filePath: filePath));
            }
          });

          if (hasError || filePath.isEmpty) {
            return; // Do not proceed to second API call
          }
        } catch (e) {
          debugPrint('$e');
          emit(MarkTaskAsCompleteErrorState(errorMessage: '$e'));
          return; // Do not proceed to second API call
        } }
      emit(MarkTaskAsCompleteLoadingState());

      Map<String, dynamic> queryParameters = {
        'completed_remark': event.remark,
        'completed_images': (filePath.isNotEmpty) ? [filePath] : [],
      };
        try {
          String url = '${ApiConst.markTaskAsComplete}/${event.taskId}/complete';
          Either<Failure, dynamic> response = await ApiBaseHelpers().put(
            Uri.parse(url),
            ApiBaseHelpers.headers(),
            queryParameters,
          );

          response.fold(
                (left) {
              if (left is UnauthorizedFailure) {
                emit(MarkTaskAsCompleteErrorState(errorMessage: left.errorMessage!));
              } else if (left is NoDataFailure) {
                emit(MarkTaskAsCompleteErrorState(errorMessage: left.errorMessage));
              } else if (left is ServerFailure) {
                emit(MarkTaskAsCompleteErrorState(errorMessage: 'Server Failure'));
              } else if (left is InvalidDataUnableToProcessFailure) {
                emit(MarkTaskAsCompleteErrorState(
                    errorMessage: jsonDecode(left.errorMessage)['error']));
              } else {
                emit(MarkTaskAsCompleteErrorState(errorMessage: 'Something went wrong'));
              }
            },
                (right) {
              if (right != null && right.containsKey('error')) {
                emit(MarkTaskAsCompleteErrorState(errorMessage: right['error']));
              } else {
                final message = right['message'] ?? 'Operation completed successfully.';
                emit(MarkTaskAsCompleteDoneState(message: message,));
              }
            },
          );
        } catch (e) {
          emit(MarkTaskAsCompleteErrorState(errorMessage: "$e"));
        }
    });










    on<OnCreateFollowUpEvent>((event, emit) async {
      emit(CreateFollowUpLoadingState());
      Map<String, dynamic> queryParameters = {
        "remark": event.remark,
        'status': event.status,
        'followup_date': event.followupDate,
      };
      try {
        String url = '${ApiConst.createFollowUp}/${event.taskId}/followups';
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          body:  queryParameters,
        );

        // Either<Failure, dynamic> response = await ApiBaseHelpers().post(
        //   Uri.parse(ApiConst.nocSubmit),
        //   ApiBaseHelpers.headers(),
        //   body: queryParameters,
        // );


        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(CreateFollowUpErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(CreateFollowUpErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(CreateFollowUpErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(CreateFollowUpErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(CreateFollowUpErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(CreateFollowUpErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(CreateFollowUpDoneState(message: message));
          }
        });
      } catch (e) {
        emit(CreateFollowUpErrorState(errorMessage: '$e'));
      }
    });



    on<OnCommentOnTaskEvent>((event, emit) async {
      emit(CreateFollowUpLoadingState());
      Map<String, dynamic> queryParameters = {
      "comment" : event.comment
      };
      try {
        String url = '${ApiConst.onCommentOnTask}/${event.taskId}/comments';
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          body:  queryParameters,
        );

        // Either<Failure, dynamic> response = await ApiBaseHelpers().post(
        //   Uri.parse(ApiConst.nocSubmit),
        //   ApiBaseHelpers.headers(),
        //   body: queryParameters,
        // );


        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(OnCommentOnTaskErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(OnCommentOnTaskErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(OnCommentOnTaskErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(OnCommentOnTaskErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(OnCommentOnTaskErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(OnCommentOnTaskErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(OnCommentOnTaskDoneState(message: message));
          }
        });
      } catch (e) {
        emit(OnCommentOnTaskErrorState(errorMessage: '$e'));
      }
    });


    on<OnGetTaskCommentListEvent>((event, emit) async {
      emit(GetTaskCommentListLoadingState());
      Map<String, dynamic> queryParameters = {
      };
      try {
        String url = '${ApiConst.getCommentList}/${event.taskId}/comments';
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          // body:  queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetTaskCommentListErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetTaskCommentListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetTaskCommentListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetTaskCommentListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetTaskCommentListErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetTaskCommentListErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            getTaskCommentData = GetTaskCommentListModel.fromJson(right).data;

            emit(GetTaskCommentListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetTaskCommentListErrorState(errorMessage: '$e'));
      }
    });


    on<OnGetFollowUpListEvent>((event, emit) async {
      getFollowUpListData.clear();
      // Map<String, String> queryParams = {
      //   'id': event.id.toString()
      //
      // };
      emit(FollowUpListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(ApiConst.isProduction ? ApiConst.baseUrlNonProdHttpC : ApiConst.baseUrlNonHttpC, "/api/tasks/${event.taskId}/followups",),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(FollowUpListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(FollowUpListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(FollowUpListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(FollowUpListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(FollowUpListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            getFollowUpListData.clear();
            String error = "${right['error']}";
            emit(FollowUpListErrorState(errorMessage: error));
          } else {
            getFollowUpListData = GetFollowUpListModel.fromJson(right).data ?? [];
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(FollowUpListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(FollowUpListErrorState(errorMessage: '$e'));
      }
    });



    on<OnGetTaskDetailEvent>((event, emit) async {
      // Map<String, String> queryParams = {
      //   'id': event.id.toString()
      //
      // };
      emit(GetTaskDetailLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(ApiConst.isProduction ? ApiConst.baseUrlNonProdHttpC : ApiConst.baseUrlNonHttpC, "/api/tasks/${event.taskId}",),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetTaskDetailErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetTaskDetailErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetTaskDetailErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetTaskDetailErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetTaskDetailErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetTaskDetailErrorState(errorMessage: error));
          } else {

            // if(event.isAssign ==  true){
            //   getTaskDetailData = null;
            // }
            if (event.hasApprovedQuotation){
               getTaskDetailData?.hasApprovedQuotation = null ;

            }

            getTaskDetailData = GetTaskDetailModel.fromJson(right).data;
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(GetTaskDetailDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetTaskDetailErrorState(errorMessage: '$e'));
      }
    });







    on<OnCreateTaskEvent>((event, emit) async {
      emit(CreateTaskLoadingState());

      List<String> uploadedFileNames = [];

      // STEP 1: Upload task images if present
      if (event.taskImages != null && event.taskImages!.isNotEmpty) {
        for (int i = 0; i < event.taskImages!.length; i++) {
          // emit(TaskMediaUploadingState(index: i)); // Optional, if you want progress UI

          Either<Failure, dynamic> response = await postUploadMedia(
            queryParameters: {
              "collection_name": 'task_images',
              "file_path": event.taskImages![i],
            },
            headers: ApiBaseHelpers.headersMultipart(),
            apiUrl: ApiConst.updateProfilePhotos,
          );

          bool hasError = false;

          response.fold((left) {
            hasError = true;
            if (left is UnauthorizedFailure) {
              emit(CreateTaskErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NetworkFailure) {
              emit(CreateTaskErrorState(errorMessage: 'Network not available'));
            } else if (left is ServerFailure) {
              emit(CreateTaskErrorState(errorMessage: 'Server Failure'));
            } else if (left is NoDataFailure) {
              emit(CreateTaskErrorState(errorMessage: left.errorMessage));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(CreateTaskErrorState(errorMessage: left.errorMessage));
            } else {
              emit(CreateTaskErrorState(errorMessage: 'Something went wrong'));
            }
          }, (right) {
            if (right != null && right.containsKey('error')) {
              hasError = true;
              emit(CreateTaskErrorState(errorMessage: right['error']));
            } else {
              String imageName =
                  UploadMediaModel.fromJson(right).data?.fileName ?? '';
              if (imageName.isNotEmpty) {
                uploadedFileNames.add(imageName);
              }
            }
          });

          if (hasError) return; // Stop if upload fails
        }
      }

      // STEP 2: Call Create Task API after all uploads
      emit(CreateTaskLoadingState());

      Map<String, dynamic> queryParameters = {
        "title": event.title,
        "description": event.description,
        "module_name": event.moduleName,
        "module_id": event.moduleId,
        "due_date": event.dueDate,
        "priority": event.priority,
        "assigned_to": event.assignedTo,
        "house_id": event.houseId,
        "task_images": uploadedFileNames, // all uploaded images here
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.createTask),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(CreateTaskErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NetworkFailure) {
            emit(CreateTaskErrorState(errorMessage: 'Network not available'));
          } else if (left is ServerFailure) {
            emit(CreateTaskErrorState(errorMessage: 'Server Failure'));
          } else if (left is NoDataFailure) {
            emit(CreateTaskErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(CreateTaskErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(CreateTaskErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(CreateTaskErrorState(errorMessage: right['error']));
          } else {
            final message = right['message'] ?? 'Task created successfully.';
            emit(CreateTaskDoneState(message: message, isComing: event.isComing));
          }
        });
      } catch (e) {
        emit(CreateTaskErrorState(errorMessage: '$e'));
      }
    });

    on<OnGetTaskFiltersListEvent>((event, emit) async {
      emit(TaskFiltersListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.getTaskFiltersList),
          ApiBaseHelpers.headers(),);
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetTaskListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetTaskListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetTaskListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetTaskListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetTaskListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetTaskListErrorState(errorMessage: error));
          } else {
            final filters = TaskFiltersModel.fromJson(right);

            taskTypes = filters.types ?? [];
            statuses = filters.statuses ?? [];
            assignees = filters.assignees ?? [];
            datePresets = filters.datePresets ?? [];
            priorities = filters.priorities ?? [];

            final message = right['message'] ?? 'Operation completed successfully.';

            emit(TaskFiltersListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetTaskListErrorState(errorMessage: '$e'));
      }
    });


    on<OnUpdateTaskCommentEvent>((event, emit) async {
      emit(OnUpdateTaskCommentLoadingState());

      Map<String, dynamic> queryParameters = {
        "comment":event.comment
      };

      try {
        String url = '${ApiConst.updateTaskComment}/${event.taskId}/comments/${event.commentId}';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );

        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(OnUpdateTaskCommentErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(OnUpdateTaskCommentErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(OnUpdateTaskCommentErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(OnUpdateTaskCommentErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(OnUpdateTaskCommentErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              emit(OnUpdateTaskCommentErrorState(errorMessage: right['error']));
            } else {
              final message = right['message'] ?? 'Operation completed successfully.';
              emit(OnUpdateTaskCommentDoneState(message: message,));
            }
          },
        );
      } catch (e) {
        emit(OnUpdateTaskCommentErrorState(errorMessage: "$e"));
      }
    });


    on<OnDeleteTaskCommentEvent>((event, emit) async {
      emit(OnDeleteTaskCommentLoadingState());
      try {
        String url = '${ApiConst.deleteTaskComment}/${event.taskId}/comments/${event.commentId}';

        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          null,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(OnDeleteTaskCommentErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(OnDeleteTaskCommentErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(OnDeleteTaskCommentErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(OnDeleteTaskCommentErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(OnDeleteTaskCommentErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(OnDeleteTaskCommentErrorState(errorMessage : error));
            }
            else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(OnDeleteTaskCommentDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(OnDeleteTaskCommentErrorState(errorMessage: "$e"));
      }
    });



    on<OnDeleteTaskFollowUpEvent>((event, emit) async {
      emit(OnDeleteTaskFollowUpLoadingState());
      try {
        String url = '${ApiConst.deleteTaskFollowUp}/${event.taskId}/followups/${event.followUpId}';
        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          null,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(OnDeleteTaskFollowUpErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(OnDeleteTaskFollowUpErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(OnDeleteTaskFollowUpErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(OnDeleteTaskFollowUpErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(OnDeleteTaskFollowUpErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(OnDeleteTaskFollowUpErrorState(errorMessage : error));
            }
            else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(OnDeleteTaskFollowUpDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(OnDeleteTaskFollowUpErrorState(errorMessage: "$e"));
      }
    });



    on<OnDeleteTaskEvent>((event, emit) async {
      emit(DeleteTaskLoadingState());
      Map<String, dynamic> queryParameters = {
        "status": "cancelled"
      };

      try {
        String url = '${ApiConst.deleteTask}/${event.taskId}/status';
        print(url);
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
            queryParameters
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(DeleteTaskErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(DeleteTaskErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(DeleteTaskErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(DeleteTaskErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(DeleteTaskErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(DeleteTaskErrorState(errorMessage : error));
            }
            else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(DeleteTaskDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(DeleteTaskErrorState(errorMessage: "$e"));
      }
    });



    on<OnUpdateTaskEvent>((event, emit) async {
      emit(UpdateTaskLoadingState());
      Map<String, dynamic> queryParameters = {
        "title": event.title,
        "description": event.description,
        "module_name": event.moduleName,
        // 'module_id' :event.moduleId,
        'due_date' :event.dueDate,
        'priority' :event.priority,
        "assigned_to": event.assignedTo,
        // "house_id" : event.houseId
      };
      try {
        String url = '${ApiConst.updateTask}/${event.taskId}';
        print("gjelgkjflljdljdfj ${url}");
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(UpdateTaskErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(UpdateTaskErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(UpdateTaskErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(UpdateTaskErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(UpdateTaskErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(UpdateTaskErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(UpdateTaskDoneState(message: message));
          }
        }
        );
      } catch (e) {
        emit(UpdateTaskErrorState(errorMessage: '$e'));
      }
    });



    on<OnUpdateFollowUpEvent>((event, emit) async {
      emit(UpdateFollowUpLoadingState());
      Map<String, dynamic> queryParameters = {
        "remark": event.remark,
        'status': event.status,
        'followup_date': event.followupDate,

      };
      try {

        String url = '${ApiConst.updateFollowUp}/${event.taskId}/followups/${event.followUpId}';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );

        // Either<Failure, dynamic> response = await ApiBaseHelpers().post(
        //   Uri.parse(ApiConst.nocSubmit),
        //   ApiBaseHelpers.headers(),
        //   body: queryParameters,
        // );


        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(UpdateFollowUpErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(UpdateFollowUpErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(UpdateFollowUpErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(UpdateFollowUpErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(UpdateFollowUpErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(UpdateFollowUpErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(UpdateFollowUpDoneState(message: message));
          }
        });
      } catch (e) {
        emit(UpdateFollowUpErrorState(errorMessage: '$e'));
      }
    });


    on<OnGetTaskHistoryListEvent>((event, emit) async {
      emit(GetTaskHistoryListLoadingState());
      Map<String, dynamic> queryParameters = {
      };
      try {
        String url = '${ApiConst.taskHistoryList}/${event.taskId}/activities';
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          // body:  queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetTaskHistoryListErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetTaskHistoryListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetTaskHistoryListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetTaskHistoryListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetTaskHistoryListErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetTaskHistoryListErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            taskHistoryListData = TaskHistoryListModel.fromJson(right).data;

            emit(GetTaskHistoryListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetTaskHistoryListErrorState(errorMessage: '$e'));
      }
    });


    on<OnGenerateTitleDescriptionEvent>((event,emit) async {
      emit(GenerateTitleDescriptionLoadingState());
      Map<String, dynamic> queryParameters = {
          "type": event.taskType,
          "id": event.complaintIdOrHouseId.toString()
      };
      try{
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.generateTitleDescription),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(GenerateTitleDescriptionErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(GenerateTitleDescriptionErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(GenerateTitleDescriptionErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(GenerateTitleDescriptionErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(GenerateTitleDescriptionErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
                if (right != null && right.containsKey('error')) {
                  String error = "${right['error']}";
                  emit(GetTaskHistoryListErrorState(errorMessage: error));
                } else {
                  final message = right['message'] ?? 'Operation completed successfully.';
                  generateTitleDescriptionData = GenerateTitleDescriptionModel.fromJson(right).data;
                  emit(GenerateTitleDescriptionDoneState(message: message));
                }
          },
        );
      }catch(e)
      {
        emit(GenerateTitleDescriptionErrorState(errorMessage:"$e"));
      }
    });




    on<OnAddQuotationEvent>((event, emit) async {
      emit(AddQuotationLoadingState());

      String filePath = "";
      if (event.attachment?.isNotEmpty == true) {
        Map<String, dynamic> queryParameters = {
          "collection_name": 'attachment',
          "file_path": event.attachment,
        };
        emit(AddQuotationLoadingState());

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
              emit(AddQuotationErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(AddQuotationErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(AddQuotationErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(AddQuotationErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(AddQuotationErrorState(errorMessage: 'Something went wrong'));
            }
          }, (right) {
            if (right != null && right.containsKey('error')) {
              hasError = true;
              emit(AddQuotationErrorState(errorMessage: right['error']));
            } else {
              filePath = UploadMediaModel.fromJson(right).data?.fileName ?? "";
              // emit(UploadVoucherImageDoneState(filePath: filePath));
            }
          });

          if (hasError || filePath.isEmpty) {
            return; // Do not proceed to second API call
          }
        } catch (e) {
          debugPrint('$e');
          emit(AddQuotationErrorState(errorMessage: '$e'));
          return; // Do not proceed to second API call
        } }


      emit(AddQuotationLoadingState());



      Map<String, dynamic> queryParameters = {
        'vendor_name': event.vendorName,
        "quotation_date": "2025-09-30",
        "amount": event.amount,
        'attachment': filePath,
      };


      try {
        String url = '${ApiConst.addQuotation}/${event.taskId}/quotations';
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );



        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(AddQuotationErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(AddQuotationErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(AddQuotationErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(AddQuotationErrorState(
                  errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(AddQuotationErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              emit(AddQuotationErrorState(errorMessage: right['error']));
            } else {
              final message = right['message'] ?? 'Operation completed successfully.';
              emit(AddQuotationDoneState(message: message,));
            }
          },
        );
      } catch (e) {
        emit(AddQuotationErrorState(errorMessage: "$e"));
      }
    });


    on<OnGetQuotationListEvent>((event, emit) async {
      emit(GetQuotationListLoadingState());
      Map<String, dynamic> queryParameters = {
      };
      try {
        String url = '${ApiConst.getQuotationsList}/${event.taskId}/quotations';
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          // body:  queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetQuotationListErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetQuotationListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetQuotationListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetQuotationListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetQuotationListErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetQuotationListErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            getQuotationListData = GetQuotationListModel.fromJson(right).data;

            emit(GetQuotationListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetQuotationListErrorState(errorMessage: '$e'));
      }
    });


    on<OnDeleteQuotationEvent>((event, emit) async {
      emit(DeleteQuotationLoadingState());
      try {
        String url = '${ApiConst.deleteQuotation}/${event.id}';

        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          null,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(DeleteQuotationErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(DeleteQuotationErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(DeleteQuotationErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(DeleteQuotationErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(DeleteQuotationErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(DeleteQuotationErrorState(errorMessage : error));
            }
            else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(DeleteQuotationDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(DeleteQuotationErrorState(errorMessage: "$e"));
      }
    });


    on<OnApprovedQuotationEvent>((event, emit) async {
      emit(ApprovedQuotationLoadingState());

      Map<String, dynamic> queryParameters = {
      };

      try {
        String url = '${ApiConst.approvedQuotation}/${event.id}/approve';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          null,
        );

        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(ApprovedQuotationErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(ApprovedQuotationErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(ApprovedQuotationErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(ApprovedQuotationErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(ApprovedQuotationErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              emit(ApprovedQuotationErrorState(errorMessage: right['error']));
            } else {
              final message = right['message'] ?? 'Operation completed successfully.';
              emit(ApprovedQuotationDoneState(message: message,));
            }
          },
        );
      } catch (e) {
        emit(ApprovedQuotationErrorState(errorMessage: "$e"));
      }
    });



    on<OnRejectQuotationEvent>((event, emit) async {
      emit(RejectedQuotationLoadingState());

      Map<String, dynamic> queryParameters = {
      };

      try {
        String url = '${ApiConst.rejectQuotation}/${event.id}/reject';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          null,
        );

        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(RejectQuotationErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(RejectQuotationErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(RejectQuotationErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(RejectQuotationErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(RejectQuotationErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              emit(RejectQuotationErrorState(errorMessage: right['error']));
            } else {
              final message = right['message'] ?? 'Operation completed successfully.';
              emit(RejectQuotationDoneState(message: message,));
            }
          },
        );
      } catch (e) {
        emit(RejectQuotationErrorState(errorMessage: "$e"));
      }
    });







  }
}
