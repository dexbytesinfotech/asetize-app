import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../models/visitor_model.dart';
import 'my_visitor_event.dart';
import 'my_visitor_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<VisitorData> checkInData = [];
  List<VisitorData> checkOutData = [];
  List<VisitorData> visitorHistoryData = [];
  List<VisitorData> upComingVisitorsData = [];

  HomeBloc() : super(HomeInitialState()) {
    on<OnGetVisitorCheckedInListEvent>((event, emit) async {
      Map<String, String> queryParams = {
        'start_time': event.startTime ?? '',
        'house_id': event.houseId.toString(),
        'status': event.status ?? '',
      };

      emit(VisitorLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(ApiConst.isProduction ? ApiConst.baseUrlNonProdHttpC : ApiConst.baseUrlNonHttpC, "api/house/visitors",
                queryParams),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(VisitorListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(VisitorListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(VisitorListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(VisitorListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(VisitorListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(VisitorListErrorState(errorMessage: error));
          } else {
            checkInData = VisitorModel.fromJson(right).data ?? [];
            emit(VisitorListDoneState());
          }
        });
      } catch (e) {
        emit(VisitorListErrorState(errorMessage: '$e'));
      }
    });

    on<OnGetVisitorCheckedOutListEvent>((event, emit) async {
      Map<String, String> queryParams = {
        'start_time': event.startTime ?? '',
        'status': event.status ?? '',
      };

      emit(VisitorLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(
                ApiConst.isProduction
                    ? ApiConst.baseUrlNonProdHttpC
                    : ApiConst.baseUrlNonHttpC,
                "api/visitors",
                queryParams),
            ApiBaseHelpers.headersForVisitor());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(VisitorListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(VisitorListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(VisitorListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(VisitorListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(VisitorListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(VisitorListErrorState(errorMessage: error));
          } else {
            checkOutData = VisitorModel.fromJson(right).data ?? [];
            emit(VisitorListDoneState());
          }
        });
      } catch (e) {
        emit(VisitorListErrorState(errorMessage: '$e'));
      }
    });

    on<OnVisitorCheckoutEvent>((event, emit) async {
      emit(VisitorCheckoutLoadingState());
      try {
        String url = '${ApiConst.visitorCheckoutAPi}/${event.entryHouseId}/${event.status}';
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(VisitorCheckoutErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(VisitorCheckoutErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(VisitorCheckoutErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(VisitorCheckoutErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(VisitorCheckoutErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(VisitorCheckoutErrorState(errorMessage: error));
          } else {
            emit(VisitorCheckoutDoneState(status: event.status?? ''));
          }
        });
      } catch (e) {
        emit(VisitorCheckoutErrorState(errorMessage: '$e'));
      }
    });

    on<OnGetVisitorHistoryListEvent>((event, emit) async {
      Map<String, String> queryParams = {
        'start_time': event.startTime ?? '',
        'end_time': event.endTime ?? '',
        'search': event.search ?? '',
        'house_id': event.houseId.toString()

        // 'status': event.status?? '',
      };
      emit(VisitorHistoryLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(
                ApiConst.isProduction
                    ? ApiConst.baseUrlNonProdHttpC
                    : ApiConst.baseUrlNonHttpC,
                "api/house/visitors",
                queryParams),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(
                VisitorHistoryErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(VisitorHistoryErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(VisitorHistoryErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(VisitorHistoryErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(
                VisitorHistoryErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(VisitorHistoryErrorState(errorMessage: error));
          } else {
            visitorHistoryData = VisitorModel.fromJson(right).data ?? [];
            emit(VisitorHistoryDoneState());
          }
        });
      } catch (e) {
        emit(VisitorHistoryErrorState(errorMessage: '$e'));
      }
    });

    on<OnGetUpcomingVisitorsListEvent>((event, emit) async {
      Map<String, String> queryParams = {
        'start_time': event.startTime ?? '',
        'end_time': event.endTime ?? '',
        'search': event.search ?? '',
        'house_id': event.houseId.toString(),
        'status': event.status?? '',
      };
      emit(UpcomingVisitorsListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(
                ApiConst.isProduction
                    ? ApiConst.baseUrlNonProdHttpC
                    : ApiConst.baseUrlNonHttpC,
                "api/house/visitors",
                queryParams),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(
                UpcomingVisitorsListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(UpcomingVisitorsListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(UpcomingVisitorsListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(UpcomingVisitorsListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(
                UpcomingVisitorsListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(UpcomingVisitorsListErrorState(errorMessage: error));
          } else {
            upComingVisitorsData = VisitorModel.fromJson(right).data ?? [];
            emit(UpcomingVisitorsListDoneState());
          }
        });
      } catch (e) {
        emit(UpcomingVisitorsListErrorState(errorMessage: '$e'));
      }
    });


    on<OnCreatedNocPassEvent>((event, emit) async {
      emit(CreatedNocPassLoadingState());
      try {
        final uri = Uri.https(
          ApiConst.isProduction
              ? ApiConst.baseUrlNonProdHttpC
              : ApiConst.baseUrlNonHttpC,
          "/api/nocs/pass/create/${event.id}/${event.visitorEntryId}",
        );

        print("API URI: $uri");

        Either<Failure, dynamic> response =
        await ApiBaseHelpers().get(uri, ApiBaseHelpers.headers());

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(CreatedNocPassErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(CreatedNocPassErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(CreatedNocPassErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(CreatedNocPassErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(CreatedNocPassErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(CreatedNocPassErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(CreatedNocPassDoneState(message: message));
          }
        });
      } catch (e) {
        emit(CreatedNocPassErrorState(errorMessage: '$e'));
      }
    });



    on<OnPreRegisterVisitorEvent>((event, emit) async {
      emit(PreRegisterVisitorLoadingState());
      Map<String, dynamic> queryParameters = {
        "visitor_type": event.visitorType,
        "organization": event.organization,
        "house_id": event.houseId,
        'guests' :event.guests,
        'date' :event.date,
        'time' :event.time,
        "remark": event.remark,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.preVisitorSubmitApi),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(PreRegisterVisitorErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(PreRegisterVisitorErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(PreRegisterVisitorErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(PreRegisterVisitorErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(PreRegisterVisitorErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(PreRegisterVisitorErrorState(errorMessage: error));
          } else {
            // Safely extract the value at index 0 from the "data" list
            final dataList = right['data'];
            if (dataList is List && dataList.isNotEmpty) {
              final int firstValue = dataList[0];
              emit(PreRegisterVisitorDoneState(data: firstValue));
            } else {
              emit(PreRegisterVisitorDoneState(data:0 )); // Handle empty or invalid list
            }
          }

        }


        );
      } catch (e) {
        emit(PreRegisterVisitorErrorState(errorMessage: '$e'));
      }
    });


    on<OnUpdatePreRegisterVisitorEvent>((event, emit) async {
      emit(UpdatePreRegisterVisitorLoadingState());

      Map<String, dynamic> queryParameters = {
        "visitor_type": event.visitorType,
        "organization": event.organization,
        "house_id": event.houseId,
        'guests' :event.guests,
        'date' :event.date,
        'time' :event.time,
        "remark": event.remark,
      };
      try{
        String url = '${ApiConst.updatePreVisitor}/${event.id.toString()}';
        print(url);
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(UpdatePreRegisterVisitorErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(UpdatePreRegisterVisitorErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(UpdatePreRegisterVisitorErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(UpdatePreRegisterVisitorErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(UpdatePreRegisterVisitorErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(UpdatePreRegisterVisitorErrorState(errorMessage : error));
            }
            else {
              final message = right['message'] ?? 'Operation completed successfully.';
              emit(UpdatePreRegisterVisitorDoneState(message: message));
              // emit(UpdatePreRegisterVisitorDoneState());
            }
          },
        );
      }catch(e)
      {
        emit(UpdatePreRegisterVisitorErrorState(errorMessage: "$e"));
      }
    });


    on<OnDeleteUpComingVisitorEvent>((event, emit) async {
      emit(DeleteUpComingVisitorLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(ApiConst.deleteUpcomingVisitor + event.id.toString()),
          ApiBaseHelpers.headers(),
          null,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(DeleteUpComingVisitorErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(DeleteUpComingVisitorErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(DeleteUpComingVisitorErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(DeleteUpComingVisitorErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(DeleteUpComingVisitorErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(DeleteUpComingVisitorErrorState(errorMessage : error));
            }
            else {
              emit(DeleteUpComingVisitorDoneState());
            }
          },
        );
      } catch (e) {
        emit(DeleteUpComingVisitorErrorState(errorMessage: "$e"));
      }
    });



  }
}
