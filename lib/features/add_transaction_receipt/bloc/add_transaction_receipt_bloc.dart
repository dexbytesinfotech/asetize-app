import '../../../core/network/api_base_helpers.dart';
import '../../../core/util/app_permission.dart';
import '../../../imports.dart';
import '../models/add_transaction_receipt_model.dart';
import '../models/get_list_receipts_model.dart';
import '../models/suspense_history_model.dart';
import 'add_transaction_receipt_event.dart';
import 'add_transaction_receipt_state.dart';
import 'package:http/http.dart' as http;


class AddTransactionReceiptBloc extends Bloc<AddTransactionReceiptEvent, AddTransactionReceiptState> {
  List<PendingInvoices>? pendingInvoicesData;
  List<GetListOfReceipts> getListOfReceipts = []; // Your list initialization
  List<SuspiciousHistoryData> suspenseHistory = [];
  bool? _isPostPageEnded;
  int pageNew = 2;

  set setPostPageEnded(bool value) {
    _isPostPageEnded = value;
  }
  bool get getPostPageEnded => _isPostPageEnded ?? false;

  bool isReadyToSubmit = false;
  // bool invoiceFetched = false;
  bool isDisplayFetchInvoiceBtn = false;
  Map<String, File>? imageFile = {};
  Map<String, String>? imagePath = {};
  double? finalAmount = 0.0;
  int? selectedUnitId ;

  AddTransactionReceiptBloc() : super(AddTransactionReceiptInitialState()) {


    on<GetPandingReceipt>((event, emit) async {
      pendingInvoicesData = null;
      emit(AddTransactionReceiptLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
        "amount": event.amount
      };

      try {
        // Check permission and decide which API endpoint to use
        Uri endpointUri = (event.isForSelf!=null && event.isForSelf==true)
            ? Uri.parse(ApiConst.addTransactionReceipt)
            : Uri.parse(ApiConst.addAccountTransactionReceipt);

        // String endpointUri = (event.isForSelf!=null && event.isForSelf==true) ?ApiConst.addTransactionReceipt:ApiConst.addAccountTransactionReceipt;

        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          endpointUri,
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );

        response.fold(
              (left) {
            // Handle various failure types
            if (left is UnauthorizedFailure) {
              emit(AddTransactionReceiptErrorState(message: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(AddTransactionReceiptErrorState(message: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(AddTransactionReceiptErrorState(message: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(AddTransactionReceiptErrorState(message: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(AddTransactionReceiptErrorState(message: 'Something went wrong'));
            }
          },
              (right) {
            try {
              // Parse and handle the response data
              pendingInvoicesData = AddTransactionReceiptModel.fromJson(right).data??[];
              emit(AddTransactionReceiptSuccessState());
            } catch (e) {
              emit(AddTransactionReceiptErrorState(message: "$e"));
            }
          },
        );
      } catch (e) {
        emit(AddTransactionReceiptErrorState(message: "$e"));
      }
    });


    on<OnFormEditEvent>((event, emit) async {
      emit(FormEditingState());
      if(event.resetAll == true){
         isReadyToSubmit = false;
        isDisplayFetchInvoiceBtn = false;
        imageFile = {};
        imagePath = {};
        finalAmount = 0.0;
        selectedUnitId = null;
      }
      else{


        finalAmount = event.finalAmount??finalAmount;
        selectedUnitId = event.selectedUnitId??selectedUnitId;

        imageFile = event.imageFile??imageFile;
        imagePath = event.imagePath??imagePath;

        isReadyToSubmit = event.isReadyToSubmit??isReadyToSubmit;
        isDisplayFetchInvoiceBtn = finalAmount!<=0||selectedUnitId==null?false:event.isDisplayFetchInvoiceBtn??isDisplayFetchInvoiceBtn;
      }
      emit(FormEditDoneState());
      // projectUtil.printP("Current state $currentState");
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


    on<SubmitTransactionReceipt>((event, emit) async {
      String filePath = "";
      if (event.filePath.isNotEmpty == true) {
        Map<String, dynamic> queryParameters = {
          "collection_name": 'photo',
          "file_path": event.filePath,
        };
        emit(AddTransactionReceiptLoadingState());
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
              emit(AddTransactionReceiptErrorState(message: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(AddTransactionReceiptErrorState(message: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(AddTransactionReceiptErrorState(message: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(AddTransactionReceiptErrorState(message: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(AddTransactionReceiptErrorState(message: 'Something went wrong'));
            }
            return ;
          }, (right) {
            filePath = UploadMediaModel.fromJson(right).data?.fileName ?? " ";
            // emit(getImagePathDoneState());
          });
        } catch (e) {
          debugPrint('$e');
          emit(AddTransactionReceiptErrorState(message: '$e'));
          return ;
        }
      }

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
        'amount': event.amount,
        "file_path": filePath,
        "comments": event.comments,
        "payment_method": event.paymentMethod,
        "transaction_date":event.transactionDate,
        "transaction_time": event.transactionTime
      };

      try {

        emit(AddTransactionReceiptLoadingState());
        String url = event.isForSelf==true?ApiConst.submitUploadTransactionReceipt:ApiConst.casePayment;
        emit(AddTransactionReceiptLoadingState());
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AddTransactionReceiptErrorState(message: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AddTransactionReceiptErrorState(message: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(AddTransactionReceiptErrorState(message: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddTransactionReceiptErrorState(message: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddTransactionReceiptErrorState(message: 'Something went wrong'));
          }
        }, (right) {
          try{
            emit(TransactionReceiptSubmitSuccessState());
          }catch(e)
          {
            emit(AddTransactionReceiptErrorState(message: '$e'));
          }

        });
      } catch (e) {
        emit(AddTransactionReceiptErrorState(message: '$e'));
      }
    });

    on<GetListOfReceiptsEvent>((event, emit) async {
      emit(AddTransactionReceiptLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(Uri.parse(ApiConst.getListOfReceipts), ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AddTransactionReceiptErrorState(message: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AddTransactionReceiptErrorState(message: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(AddTransactionReceiptErrorState(message: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddTransactionReceiptErrorState(message:jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddTransactionReceiptErrorState(message: 'Something went wrong'));
          }
        }, (right) {
          getListOfReceipts = GetListOfReceiptsModel.fromJson(right).data ?? [];
          pageNew = 2;
          emit(getListOfReceiptsDoneState());
        });
      } catch (e) {
        emit(AddTransactionReceiptErrorState(message: '$e'));
      }
    });


    on<DeleteDuplicateEntryReceiptsEvent>((event, emit) async {
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(ApiConst.deleteDuplicateEntry + event.id.toString()),
          ApiBaseHelpers.headers(),
          null,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(DeleteDuplicateEntryReceiptsErrorState(message: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(DeleteDuplicateEntryReceiptsErrorState(message: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(DeleteDuplicateEntryReceiptsErrorState(message: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(DeleteDuplicateEntryReceiptsErrorState(message:jsonDecode(left.errorMessage)['error']));
          } else {
            emit(DeleteDuplicateEntryReceiptsErrorState(message: 'Something went wrong'));
          }
        }, (right) {

          if (right.containsKey("error")) {
            emit(DeleteDuplicateEntryReceiptsErrorState(message:right["error"]));
          } else {
            emit(DeleteDuplicateEntryReceiptsDoneState());
          }

        });
      } catch (e) {
        emit(DeleteDuplicateEntryReceiptsErrorState(message: '$e'));
      }
    });


    on<GetListOfReceiptsOnLoadEvent>((event, emit) async {
      emit(AddTransactionReceiptOnLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(   Uri.parse('${ApiConst.getListOfReceipts}?page=$pageNew'), ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AddTransactionReceiptErrorState(message: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AddTransactionReceiptErrorState(message: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(AddTransactionReceiptErrorState(message: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddTransactionReceiptErrorState(message:jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddTransactionReceiptErrorState(message: 'Something went wrong'));
          }
        }, (right) {
          List<GetListOfReceipts> receiptList  = GetListOfReceiptsModel.fromJson(right).data ?? [];
          if (receiptList.isNotEmpty == true) {
            getListOfReceipts.addAll(receiptList);
          }
          if(receiptList.isEmpty == true)
          {
            setPostPageEnded = true;
          }
          pageNew += 1;
          emit(getListOfReceiptsDoneState());
        });
      } catch (e) {
        emit(AddTransactionReceiptErrorState(message: '$e'));
      }
    });

    on<OnSuspenseEntryEvent>((event, emit) async {
      emit(SuspenseEntryLoadingState());

      Map<String, dynamic> queryParameters = {
        "amount": event.amount,
        "payment_method": event.paymentMethod,
        "transaction_date": event.transactionDate,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.suspenseEntry),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(SuspenseEntryErrorState(
                errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(SuspenseEntryErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(SuspenseEntryErrorState(
                errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SuspenseEntryErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(SuspenseEntryErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          if (right.containsKey("error")) {
            emit(SuspenseEntryErrorState(
                errorMessage: right["error"]));
          } else {
            emit(SuspenseEntryDoneState());
          }
        });
      } catch (e) {
        emit(SuspenseEntryErrorState(errorMessage: '$e'));
      }
    });


    on<OnSuspenseHistoryEvent>((event, emit) async {
      emit(SuspenseHistoryLoadingState());

      Map<String, dynamic> queryParameters = {
        // "amount": event.amount,
        // "payment_method": event.paymentMethod,
        // "transaction_date": event.transactionDate,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.suspenseHistoryList),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(SuspenseHistoryErrorState(
                errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(SuspenseEntryErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(SuspenseHistoryErrorState(
                errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SuspenseHistoryErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(SuspenseHistoryErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          if (right.containsKey("error")) {
            emit(SuspenseHistoryErrorState(
                errorMessage: right["error"]));
          } else {
            suspenseHistory = SuspenseHistoryModel.fromJson(right).data ?? [];
            emit(SuspenseHistoryDoneState());
          }
        });
      } catch (e) {
        emit(SuspenseHistoryErrorState(errorMessage: '$e'));
      }
    });


    on<OnSuspenseHouseAssignEvent>((event, emit) async {
      emit(SuspenseHouseAssignLoadingState());

      Map<String, dynamic> queryParameters = {
        "invoice_id": event.invoiceId,
        "assign_to_house_id": event.assignToHouseId,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.suspenseHouseAssign),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(SuspenseHouseAssignErrorState(
                errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(SuspenseHouseAssignErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(SuspenseHouseAssignErrorState(
                errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SuspenseHouseAssignErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(SuspenseHouseAssignErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          if (right.containsKey("error")) {
            emit(SuspenseHouseAssignErrorState(
                errorMessage: right["error"]));
          } else {
            // suspenseHistory = SuspenseHistoryModel.fromJson(right).data ?? [];
            emit(SuspenseHouseAssignDoneState());
          }
        });
      } catch (e) {
        emit(SuspenseHouseAssignErrorState(errorMessage: '$e'));
      }
    });
  }
}