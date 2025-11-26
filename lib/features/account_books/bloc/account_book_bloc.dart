import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app_global_components/loading_widget/loading_2_widget.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/api_base_helpers.dart';
import '../../../core/util/api_constant.dart';
import '../../../imports.dart';
import '../../add_transaction_receipt/models/add_transaction_receipt_model.dart';
import '../../my_unit/models/invoice_detail_model.dart';
import '../../my_unit/models/payment_receipt_model.dart';
import '../models/beneficiaries_model.dart';
import '../models/expense_detail_model.dart';
import '../models/expenses_category_model.dart';
import '../models/generate_voucher_model.dart';
import '../models/get_panding_list_model.dart';
import '../models/payment_history_detail_model.dart';
import '../models/payment_history_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_summary_model.dart';
import '../models/voucher_number_model.dart';
import 'account_book_event.dart';
import 'account_book_state.dart';

class AccountBookBloc extends Bloc<AccountBookEvent, AccountBookState>{
  String filterName = "current_month";
  String selectedFilterName = "Current month";
  String selectedPaymentType = 'All';
  String paymentType = 'all';
  String selectedStartDate = "";
  String? uploadedFilePath; // Property to store filePath
  String selectedEndDate = "";
  DateTime? startDate;
  DateTime? endDate;
  List<ExpensesData> expensesList = [];
  List<GetPendingListData> getPendingList = [];
  List<BeneficiariesData> beneficiariesData = [];
  String? pdfUrlForAccounted;
  String? pdfUrlForGeneratedVoucher;
  List<Payments> statementPayment =[];
  List<Invoices> statementInvoices = [];
  List<String> paymentList = [];
  PaymentMethodData? paymentMethods;
  final Map<String, String> methods = {};
  List<HistoryData>
  historyData = [];
  List<PendingInvoices> pendingInvoicesData = [];
  PaymentSummaryData? summaryData;
  VoucherNumberData? voucherNumberData;
  ExpenseDetailData? expenseDetailData;
  HistoryDetailData? historyDetailData;
  Map<String, dynamic> historyDetail = {};
  bool? _isPostPageEnded;
  String nextPendingPageUrl = "";
  String nextPaymentAccountHistoryPageUrl = "";
  set setPostPageEnded(bool value) {
    _isPostPageEnded = value;
  }
  bool get getPostPageEnded => _isPostPageEnded ?? false;




  // In AccountBookBloc, add these properties (assuming HistoryData is the type, but using dynamic as in widget):
  List<dynamic> approvedHistoryData = [];
  List<dynamic> pendingHistoryData = [];
  String approvedNextPaymentAccountHistoryPageUrl = '';
  String pendingNextPaymentAccountHistoryPageUrl = '';
  bool approvedPostPageEnded = false;
  bool pendingPostPageEnded = false;

// Add getters (assuming no setters needed, or add if required):
  bool get getApprovedPostPageEnded => approvedPostPageEnded;
  bool get getPendingPostPageEnded => pendingPostPageEnded;



  AccountBookBloc() : super(AccountBookInitialState()) {
    on<FetchExpensesCategoryEvent>((event, emit) async {
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(Uri.parse(ApiConst.expenseCategory), ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AccountBookErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          expensesList = ExpensesCategoryModel.fromJson(right).data ?? [];
          emit(FetchedPaymentMethodDoneState());
        });
      } catch (e) {
        emit(AccountBookErrorState(errorMessage: '$e'));
      }
    });
    on<FetchPaymentMethodEvent>((event, emit) async {
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.paymentMethod),
          ApiBaseHelpers.headers(),
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AccountBookErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          try {
            if (right is Map<String, dynamic>) {
              final data = right['data'];
              if (data is Map<String, dynamic>) {
                paymentList = data.values.map((e) => e.toString()).toList();
              } else {
                debugPrint('Data is not a valid Map<String, dynamic>');
              }
            }
          } catch (e) {
            debugPrint('Error while processing payment list: $e');
          }
          emit(FetchedExpensesCategoryDoneState());
        });
      } catch (e) {
        emit(AccountBookErrorState(errorMessage: '$e'));
      }
    });
    on<AddExpenseEvent>((event, emit) async {
      Map<String, dynamic> queryParameters = {
        "description": event.description,
        "category_id": event.categoryId,
        "amount": event.amount,
        "expense_date": event.expenseDate,
        "payment_mode": event.paymentMode,
        "beneficiary_id" : event.beneficiaryId,
        "voucher_number" : event.voucherNumber,
        "cheque_number":event.chequeNumber,
        "other_details":event.otherDetails,
        "voucher_photo":event.filePath,
        "action_from" :event.isComingFromAccountBook
      };

      print("Body for false: ${queryParameters}");

      emit(AccountBookLoadingState(loadingButton: event.triggeredBy));

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.postExpenses), ApiBaseHelpers.headers(),
          body: queryParameters,

        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AccountBookErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
          }
        },

                (right) {
              if (right != null && right.containsKey('error')) {
                String error = "${right['error']}";
                emit(AccountBookErrorState(errorMessage: error));
              } else {
                final message =
                    right['message'] ?? 'Operation completed successfully.';
                emit(AddExpensesDoneState(message: message,isSave: event.isSave));
              }
            },




        //         (right) {
        //   updateExpenseInHistoryList();
        //   final message =
        //       right['message'] ?? 'Operation completed successfully.';
        //   emit(AddExpensesDoneState(message: message));
        // }
        //




        );
      } catch (e) {
        emit(AccountBookErrorState(errorMessage: '$e'));
      }
    });


    on<OnUpdateExpenseEvent>((event, emit) async {
      emit(UpdatePreExpenseLoadingState());

      Map<String, dynamic> queryParameters = {
        "description": event.description,
        "category_id": event.categoryId,
        "amount": event.amount,
        "expense_date": event.expenseDate,
        "payment_mode": event.paymentMode,
        "beneficiary_id" : event.beneficiaryId,
        "voucher_number" : event.voucherNumber,
        "cheque_number":event.chequeNumber,
        "other_details":event.otherDetails,
        "voucher_photo":event.filePath
      };
      try{
        String url = '${ApiConst.updateExpenses}/${event.id.toString()}';
        print(url);
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(UpdatePreExpenseErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(UpdatePreExpenseErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(UpdatePreExpenseErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(UpdatePreExpenseErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(UpdatePreExpenseErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(UpdatePreExpenseErrorState(errorMessage : error));
            }
            else {
              final message  = right['message'] ?? 'Operation completed successfully.';
              emit(UpdatePreExpenseDoneState(message: message));
            }
          },
        );
      }catch(e)
      {
        emit(UpdatePreExpenseErrorState(errorMessage: "$e"));
      }
    });




    on<FetchAccountBookSummaryEvent>((event, emit) async{

      Map<String, dynamic> queryParameters = {
        "filter_option": event.filterName,
        "start_date": event.startDate,
        "end_date": event.endDate,
      };
      emit(AccountBookLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.paymentSummary), ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AccountBookErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          try {
            summaryData = PaymentSummaryModel.fromJson(right).data ;

          } catch (e) {
            debugPrint('Error while processing payment list: $e');
          }
          emit(FetchAccountBookSummaryDoneState());
        });
      } catch (e) {
        emit(AccountBookErrorState(errorMessage: '$e'));
      }

    });
    on<OnPrintStatementEvent>((event, emit) async{

      Map<String, dynamic> queryParameters = {
        "from_date": event.startDate,
        "to_date": event.endDate,
      };
      emit(PrintStatementLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.printStatement), ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(PrintStatementErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(PrintStatementErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(PrintStatementErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(PrintStatementErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(PrintStatementErrorState(errorMessage: 'Something went wrong'));
          }
        },    (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(PrintStatementErrorState(errorMessage: error));
          } else {
            final message =
                right['message'] ?? 'Operation completed successfully.';
            emit(PrintStatementDoneState(message: message));
          }
        },


        );
      } catch (e) {
        emit(PrintStatementErrorState(errorMessage: '$e'));
      }

    });


//     on<FetchAccountBookHistoryEvent>((event, emit) async{
//
//       Map<String, dynamic> queryParameters = {
//         "filter_option": event.filterName,
//         "start_date": event.startDate,
//         "end_date": event.endDate,
//         "payment_type": event.paymentType,
//         "is_verified":event.isVerified
//       };
//       emit(AccountBookLoadingState());
//       try {
//         Either<Failure, dynamic> response = await ApiBaseHelpers().post(
//           Uri.parse(ApiConst.paymentHistory), ApiBaseHelpers.headers(),
//           body: queryParameters,
//         );
//         response.fold((left) {
//           if (left is UnauthorizedFailure) {
//             emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
//           } else if (left is NoDataFailure) {
//             emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
//           } else if (left is ServerFailure) {
//             emit(AccountBookErrorState(errorMessage: 'Server Failure'));
//           } else if (left is InvalidDataUnableToProcessFailure) {
//             emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
//           } else {
//             emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
//           }
//         }, (right) {
//           historyData = PaymentHistoryModel.fromJson(right).data ?? [];
//           nextPaymentAccountHistoryPageUrl = right['pagination']['next_page_api_url'];
//           emit(FetchAccountBookHistoryDoneState(isVerified: event.isVerified));
//         });
//       } catch (e) {
//         emit(AccountBookErrorState(errorMessage: '$e'));
//       }
//     });
//     /// onLoad API
//     on<FetchAccountBookHistoryOnLoadEvent>((event, emit) async{
// if(nextPaymentAccountHistoryPageUrl.isEmpty){
//   return ;
// }
//       Map<String, dynamic> queryParameters = {
//         "filter_option": event.filterName,
//         "start_date": event.startDate,
//         "end_date": event.endDate,
//         "payment_type": event.paymentType,
//         "is_verified": event.isVerified
//       };
//       emit(AccountBookOnLoadLoadingState());
//       try {
//         Either<Failure, dynamic> response = await ApiBaseHelpers().post(
//           Uri.parse(nextPaymentAccountHistoryPageUrl), ApiBaseHelpers.headers(),
//           body: queryParameters,
//         );
//         response.fold((left) {
//           if (left is UnauthorizedFailure) {
//             emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
//           } else if (left is NoDataFailure) {
//             emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
//           } else if (left is ServerFailure) {
//             emit(AccountBookErrorState(errorMessage: 'Server Failure'));
//           } else if (left is InvalidDataUnableToProcessFailure) {
//             emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
//           } else {
//             emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
//           }
//         }, (right) {
//           List<HistoryData> historyOnLoadData = PaymentHistoryModel.fromJson(right).data ?? [];
//           nextPaymentAccountHistoryPageUrl = right['pagination']['next_page_api_url'];
//           if (historyOnLoadData.isNotEmpty == true) {
//             historyData.addAll(historyOnLoadData);
//           }
//           if(historyOnLoadData.isEmpty == true)
//           {
//             setPostPageEnded = true;
//           }
//           emit(FetchAccountBookHistoryDoneState(isVerified: event.isVerified));
//         });
//       } catch (e) {
//         emit(AccountBookErrorState(errorMessage: '$e'));
//       }
//     });




    on<FetchAccountBookHistoryEvent>((event, emit) async {
      // Clear the corresponding data before fetching (for initial/refresh)
      if (event.isVerified == '1') {
        approvedHistoryData.clear();
        approvedNextPaymentAccountHistoryPageUrl = '';
        approvedPostPageEnded = false;
      } else if (event.isVerified == '0') {
        pendingHistoryData.clear();
        pendingNextPaymentAccountHistoryPageUrl = '';
        pendingPostPageEnded = false;
      }

      Map<String, dynamic> queryParameters = {
        "filter_option": event.filterName,
        "start_date": event.startDate,
        "end_date": event.endDate,
        "payment_type": event.paymentType,
        "is_verified": event.isVerified
      };
      emit(AccountBookLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.paymentHistory), ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AccountBookErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          List<dynamic> newData = PaymentHistoryModel.fromJson(right).data ?? [];
          String nextUrl = right['pagination']['next_page_api_url'] ?? '';
          if (event.isVerified == '1') {
            approvedHistoryData = newData;
            approvedNextPaymentAccountHistoryPageUrl = nextUrl;
            historyData = PaymentHistoryModel.fromJson(right).data ?? [];
            nextPaymentAccountHistoryPageUrl = right['pagination']['next_page_api_url'];


          } else if (event.isVerified == '0') {
            pendingHistoryData = newData;
            pendingNextPaymentAccountHistoryPageUrl = nextUrl;
          }
          emit(FetchAccountBookHistoryDoneState(isVerified: event.isVerified));
        });
      } catch (e) {
        emit(AccountBookErrorState(errorMessage: '$e'));
      }
    });

    on<FetchAccountBookHistoryOnLoadEvent>((event, emit) async {
      String nextUrl = event.isVerified == '1' ? approvedNextPaymentAccountHistoryPageUrl : pendingNextPaymentAccountHistoryPageUrl;
      if (nextUrl.isEmpty) {
        return;
      }

      if(nextPaymentAccountHistoryPageUrl.isEmpty){
        return ;
      }


      Map<String, dynamic> queryParameters = {
        "filter_option": event.filterName,
        "start_date": event.startDate,
        "end_date": event.endDate,
        "payment_type": event.paymentType,
        "is_verified": event.isVerified
      };
      emit(AccountBookOnLoadLoadingState(isVerified: event.isVerified));
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(nextUrl), ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AccountBookErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          List<HistoryData> historyOnLoadData = PaymentHistoryModel.fromJson(right).data ?? [];
          String nextUrl = right['pagination']['next_page_api_url'] ?? '';
          if (event.isVerified == '1') {
            approvedHistoryData.addAll(historyOnLoadData);
            approvedNextPaymentAccountHistoryPageUrl = nextUrl;
            if (historyOnLoadData.isEmpty) {
              approvedPostPageEnded = true;
            }

            nextPaymentAccountHistoryPageUrl = right['pagination']['next_page_api_url'];


            if (historyOnLoadData.isNotEmpty == true) {
              historyData.addAll(historyOnLoadData);
            }
            if(historyOnLoadData.isEmpty == true)
            {
              setPostPageEnded = true;
            }




          } else if (event.isVerified == '0') {
            pendingHistoryData.addAll(historyOnLoadData);
            pendingNextPaymentAccountHistoryPageUrl = nextUrl;
            if (historyOnLoadData.isEmpty) {
              pendingPostPageEnded = true;
            }
          }







          emit(FetchAccountBookHistoryDoneState(isVerified: event.isVerified));
        });
      } catch (e) {
        emit(AccountBookErrorState(errorMessage: '$e'));
      }
    });
















    on<FetchAccountBookHistoryDetailEvent>((event, emit) async{
      historyDetailData=null;
      statementPayment.clear();
      statementInvoices.clear();
      Map<String, dynamic> queryParameters = {
        "table": event.tableName,
      };
      emit(AccountBookLoadingState());
      try {
        Either<Failure, dynamic> response = await putApiFunction(
          queryParameters: queryParameters,
          headers:  ApiBaseHelpers.headersPut(),
          apiUrl: "${ApiConst.paymentHistoryDetail}/${event.id}/table", );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AccountBookErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          historyDetail = right['data'];
          if (right['data'].containsKey("payments")) {
            statementPayment= InvoiceNewDetail.fromJson(right).data?.payments ?? [];
            print(statementPayment);

          }
          else if (right['data'].containsKey("invoices")) {
            statementInvoices= InvoiceNewDetail.fromJson(right).data?.invoices ?? [];

            print(statementInvoices);
          }
          emit(FetchAccountBookHistoryDetailDoneState());
        });
      } catch (e) {
        emit(AccountBookErrorState(errorMessage: '$e'));
      }
    });
    on<SubmitCasePaymentEvent>((event, emit) async{
      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
        "amount": event.amount,
        "payment_method": event.paymentMethod,
        "receipt_number": event.receiptNumber,
        "transaction_date": event.transactionDate,
        "transaction_time": event.transactionTime,
        "is_sent_receipt": 0,
      };
      emit(AccountBookLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.casePayment), ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(SubmitCasePaymentError(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(SubmitCasePaymentError(errorMessage: jsonDecode(left.errorMessage)['error']));

          } else if (left is ServerFailure) {
            emit(SubmitCasePaymentError(errorMessage: 'Server Failure'));

          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SubmitCasePaymentError(errorMessage: jsonDecode(left.errorMessage)['error']));

          } else {
            emit(SubmitCasePaymentError(errorMessage: 'Something went wrong'));

          }
        }, (right) {

          emit(CasePaymentDoneState());

        });
      } catch (e) {
        emit(SubmitCasePaymentError(errorMessage: '$e'));

      }
    });
    on<SubmitTransactionReceipt>((event,emit) async {
      emit(AccountBookLoadingState());
      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
        "amount":event.amount
      };
      try{
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.addAccountTransactionReceipt),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(AccountBookErrorAddPaymentState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(AccountBookErrorAddPaymentState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else if (left is ServerFailure) {
              emit(AccountBookErrorAddPaymentState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(AccountBookErrorAddPaymentState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(AccountBookErrorAddPaymentState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            try {
              pendingInvoicesData = AddTransactionReceiptModel.fromJson(right).data!;
              emit(AddTransactionReceiptDoneState());
            } catch (e) {
              emit(AccountBookErrorAddPaymentState(errorMessage: "$e"));
            }
          },
        );
      }catch(e)
      {
        emit(AccountBookErrorAddPaymentState(errorMessage: "$e"));
      }
    });
    on<ReceiptSharedConfirmEvent>((event,emit) async {
      emit(AccountBookLoadingState());

      Map<String, dynamic> queryParameters = {
        "receipt_number": event.receiptNumber,
        "status":event.status
      };
      try{
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(ApiConst.rejectReceipt + event.id.toString()),
          ApiBaseHelpers.headers(),
          queryParameters,
        );
        response.fold(
              (left) {
            String errorMessage;
            if (left is UnauthorizedFailure) {
              errorMessage = left.errorMessage!;
            } else if (left is NoDataFailure) {
              errorMessage = jsonDecode(left.errorMessage)['error'];
            } else if (left is ServerFailure) {
              errorMessage = 'Server Failure';
            } else if (left is InvalidDataUnableToProcessFailure) {
              errorMessage = jsonDecode(left.errorMessage)['error'];
            } else {
              errorMessage = 'Something went wrong';
            }
            emit(AccountBookErrorStateForPaymentConfirmation(errorMessage: errorMessage));
          },
              (right){
                try {
                  String errorMessage = right['error'];
                  if(errorMessage.isNotEmpty == true){
                                    emit(AccountBookErrorStateForPaymentConfirmation(errorMessage: errorMessage));
                                  }
                                  else{
                                    emit(ApprovedSharedConfirmDoneState());
                                  }
                } catch (e) {
                  emit(ApprovedSharedConfirmDoneState());
                }

              },
        );
      }catch(e)
      {
        emit(AccountBookErrorStateForPaymentConfirmation(errorMessage: "$e"));
      }
    });



    on<ExpensesApprovedEvent>((event,emit) async {
      emit(ExpensesApprovedLoadingState());

      Map<String, dynamic> queryParameters = {
        "status":event.status
      };
      try{
        String url = '${ApiConst.expenseApproved}/${event.id}/verify';

        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
              (left) {
            String errorMessage;
            if (left is UnauthorizedFailure) {
              errorMessage = left.errorMessage!;
            } else if (left is NoDataFailure) {
              errorMessage = jsonDecode(left.errorMessage)['error'];
            } else if (left is ServerFailure) {
              errorMessage = 'Server Failure';
            } else if (left is InvalidDataUnableToProcessFailure) {
              errorMessage = jsonDecode(left.errorMessage)['error'];
            } else {
              errorMessage = 'Something went wrong';
            }
            emit(ExpensesApprovedErrorState(errorMessage: errorMessage));
          },
              (right){
            try {
              String errorMessage = right['error'];
              if(errorMessage.isNotEmpty == true){
                emit(ExpensesApprovedErrorState(errorMessage: errorMessage));
              }
              else{
                final message =
                    right['message'] ?? 'Operation completed successfully.';
                emit(ExpensesApprovedDoneState(message: message));
              }
            } catch (e) {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(ExpensesApprovedDoneState(message: message));
            }

          },
        );
      }catch(e)
      {
        emit(ExpensesApprovedErrorState(errorMessage: "$e"));
      }
    });
    on<ExpensesRejectEvent>((event,emit) async {
      emit(ExpensesRejectLoadingState());

      Map<String, dynamic> queryParameters = {
        "status":event.status
      };
      try{
        String url = '${ApiConst.expenseApproved}/${event.id}/verify';

        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
              (left) {
            String errorMessage;
            if (left is UnauthorizedFailure) {
              errorMessage = left.errorMessage!;
            } else if (left is NoDataFailure) {
              errorMessage = jsonDecode(left.errorMessage)['error'];
            } else if (left is ServerFailure) {
              errorMessage = 'Server Failure';
            } else if (left is InvalidDataUnableToProcessFailure) {
              errorMessage = jsonDecode(left.errorMessage)['error'];
            } else {
              errorMessage = 'Something went wrong';
            }
            emit(ExpensesRejectErrorState(errorMessage: errorMessage));
          },
              (right){
            try {
              String errorMessage = right['error'];
              if(errorMessage.isNotEmpty == true){
                emit(ExpensesRejectErrorState(errorMessage: errorMessage));
              }
              else{
                final message =
                    right['message'] ?? 'Operation completed successfully.';
                emit(ExpensesRejectDoneState(message: message));
              }
            } catch (e) {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(ExpensesRejectDoneState(message: message));
            }

          },
        );
      }catch(e)
      {
        emit(ExpensesApprovedErrorState(errorMessage: "$e"));
      }
    });









    on<ReceiptSharedRejectEvent>((event,emit) async {
      emit(AccountBookLoadingState());

      Map<String, dynamic> queryParameters = {
        "account_comments": event.accountComments,
        "status":event.status
      };
      try{
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(ApiConst.rejectReceipt + event.id.toString()),
          ApiBaseHelpers.headers(),
          queryParameters,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(AccountBookErrorStateForPaymentReject(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(AccountBookErrorStateForPaymentReject(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else if (left is AccountBookErrorStateForPaymentReject) {
              emit(AccountBookErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(AccountBookErrorStateForPaymentReject(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(AccountBookErrorStateForPaymentReject(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            emit(RejectSharedConfirmDoneState());
          },
        );
      }catch(e)
      {
        emit(AccountBookErrorStateForPaymentReject(errorMessage: "$e"));
      }
    });
    on<GetPendingListEvent>((event, emit) async {
      emit(AccountBookLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(Uri.parse(ApiConst.getPendingList), ApiBaseHelpers.headers());
        response.fold((left) {
          nextPendingPageUrl = '';
          if (left is UnauthorizedFailure) {
            emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AccountBookErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {

          getPendingList = GetPendingListDataModel.fromJson(right).data ?? [];
          nextPendingPageUrl = right['pagination']['next_page_api_url'];

          emit(GetPendingListDoneState());
        });
      } catch (e) {
        nextPendingPageUrl = '';
        emit(AccountBookErrorState(errorMessage: '$e'));
      }
    });


    on<GetListOfPandingReceiptsOnLoadEvent>((event, emit) async {
      if(nextPendingPageUrl.isEmpty){
        return ;
      }
      emit(AccountBookOnLoadLoadingState());

      try {

        Either<Failure, dynamic> response = await ApiBaseHelpers().get(Uri.parse(nextPendingPageUrl), ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AccountBookErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AccountBookErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AccountBookErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AccountBookErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          List<GetPendingListData> getPendingList2 = GetPendingListDataModel.fromJson(right).data ?? [];
          nextPendingPageUrl = right['pagination']['next_page_api_url'];
          if (getPendingList2.isNotEmpty == true) {
            getPendingList.addAll(getPendingList2);
          }
          if(getPendingList2.isEmpty == true)
          {
            setPostPageEnded = true;
          }
          emit(GetPendingListDoneState());
        });
      } catch (e) {
        emit(AccountBookErrorState(errorMessage: '$e'));
      }
    });




    on<FetchPaymentReceiptForAccountedEvent>((event,emit) async {
      emit(PaymentReceiptForAccountedLoadingState());

      Map<String, dynamic> queryParameters = {
        "payment_id": event.paymentId,
      };
      try{
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.paymentReceipt),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(PaymentReceiptForAccountedErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(PaymentReceiptForAccountedErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(PaymentReceiptForAccountedErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(PaymentReceiptForAccountedErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(PaymentReceiptForAccountedErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            try {
              pdfUrlForAccounted = PaymentReceiptModel.fromJson(right).pdfUrl ?? '';
              emit(PaymentReceiptForAccountedDoneState());
            } catch (e) {
              emit(PaymentReceiptForAccountedErrorState(errorMessage:"$e"));
            }
          },
        );
      }catch(e)
      {
        emit(PaymentReceiptForAccountedErrorState(errorMessage:"$e"));
      }
    });



    on<OnFetchGeneratedVoucherEvent>((event,emit) async {
      emit(FetchGeneratedVoucherLoadingState());

      Map<String, dynamic> queryParameters = {
        "expense_id": event.expenseId,
      };
      try{
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.generatedVoucher),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(FetchGeneratedVoucherErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(FetchGeneratedVoucherErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(FetchGeneratedVoucherErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(FetchGeneratedVoucherErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(FetchGeneratedVoucherErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
                if (right != null && right.containsKey('error')) {
                  emit(FetchGeneratedVoucherErrorState(errorMessage: right['error']));
                } else {
                  final message = right['message'] ?? 'Operation completed successfully.';
                  pdfUrlForGeneratedVoucher = GeneratedVoucherModel.fromJson(right).pdfUrl ?? '';
                  emit(FetchGeneratedVoucherDoneState(message: message));
                }
          },
        );
      }catch(e)
      {
        emit(FetchGeneratedVoucherErrorState(errorMessage:"$e"));
      }
    });


    on<OnGetPayeeListEvent>((event, emit) async {
      emit(PayeeListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.payeeList),
          ApiBaseHelpers.headers(),);
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(PayeeListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(PayeeListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(PayeeListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(PayeeListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(PayeeListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(PayeeListErrorState(errorMessage: error));
          } else {
            beneficiariesData = BeneficiariesModel.fromJson(right).data ?? [];
            emit(PayeeListDoneState(message: ''));
          }
        });
      } catch (e) {
        emit(PayeeListErrorState(errorMessage: '$e'));
      }
    });


    on<OnGetVoucherNumberEvent>((event, emit) async {
      emit(VoucherNumberLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.getVoucherNumber),
          ApiBaseHelpers.headers(),);
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(VoucherNumberErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(VoucherNumberErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(VoucherNumberErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(VoucherNumberErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(VoucherNumberErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(VoucherNumberErrorState(errorMessage: error));
          } else {
            voucherNumberData = VoucherNumberModal.fromJson(right).data ;
            final message = right['message'] ?? 'Operation completed successfully.';

            emit(VoucherNumberDoneState(message: message));
          }
        });
      } catch (e) {
        emit(VoucherNumberErrorState(errorMessage: '$e'));
      }
    });


    on<AddNewPayeeEvent>((event, emit) async{

      Map<String, dynamic> queryParameters = {
        "first_name": event.firstName,
        "last_name": event.lastName,
        "mobile_number": event.mobileNumber,
        "expense_category_id": event.expenseCategoryId,
      };

      emit(AddNewPayeeLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.addNewPayee), ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AddNewPayeeErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AddNewPayeeErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AddNewPayeeErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddNewPayeeErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddNewPayeeErrorState(errorMessage: 'Something went wrong'));
          }
        },

              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(AddNewPayeeErrorState(errorMessage: error));
            } else {
              final message = right['message'] ?? 'Operation completed successfully.';
              final id = right['data']?['id'] ?? 0; // Adjust key path based on your API response
              emit(AddNewPayeeDoneState(
                message: message,
                id: id,
              ));
            }
          },



        );
      } catch (e) {
        emit(AddNewPayeeErrorState(errorMessage: '$e'));
      }

    });


    on<OnDeletePayeeEvent>((event, emit) async {
      emit(DeletePayeeLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(ApiConst.deletePayee + event.id.toString()),
          ApiBaseHelpers.headers(),
          null,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(DeletePayeeErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(DeletePayeeErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(DeletePayeeErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(DeletePayeeErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(DeletePayeeErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(DeletePayeeErrorState(errorMessage : error));
            }
            else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(DeletePayeeDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(DeletePayeeErrorState(errorMessage: "$e"));
      }
    });

    on<OnDeleteExpenseEvent>((event, emit) async {
      emit(DeleteExpenseLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(ApiConst.deleteExpenses + event.id.toString()),
          ApiBaseHelpers.headers(),
          null,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(DeleteExpenseErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(DeleteExpenseErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(DeleteExpenseErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(DeleteExpenseErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(DeleteExpenseErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(DeleteExpenseErrorState(errorMessage : error));
            }
            else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(DeleteExpenseDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(DeleteExpenseErrorState(errorMessage: "$e"));
      }
    });


    on<OnGetExpenseDetailEvent>((event, emit) async {
      // Map<String, String> queryParams = {
      //   'id': event.id.toString()
      //
      // };

      emit(GetExpenseDetailLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(ApiConst.isProduction ? ApiConst.baseUrlNonProdHttpC : ApiConst.baseUrlNonHttpC, "/api/expenses/${event.id}",),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetExpenseDetailErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetExpenseDetailErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetExpenseDetailErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetExpenseDetailErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetExpenseDetailErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetExpenseDetailErrorState(errorMessage: error));
          } else {
            expenseDetailData = ExpenseDetailModel.fromJson(right).data ;
            final message = right['message'] ?? 'Operation completed successfully.';

            emit(GetExpenseDetailDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetExpenseDetailErrorState(errorMessage: '$e'));
      }
    });



    on<OnUpdatePayeeEvent>((event, emit) async {
      emit(UpdatePayeeLoadingState());

      Map<String, dynamic> queryParameters = {

        "first_name": event.firstName,
        "last_name": event.lastName,
        "mobile_number": event.mobileNumber,
        "expense_category_id": event.expenseCategoryId,
      };

      try {
        String url = '${ApiConst.updatePayee}/${event.id}';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );

        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(UpdatePayeeErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(UpdatePayeeErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(UpdatePayeeErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(UpdatePayeeErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(UpdatePayeeErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              emit(UpdatePayeeErrorState(errorMessage: right['error']));
            } else {
              final message = right['message'] ?? 'Operation completed successfully.';
              emit(UpdatePayeeDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(UpdatePayeeErrorState(errorMessage: "$e"));
      }
    });


    on<OnSentOtpForMobileNumberVerificationEvent>((event, emit) async {
      Map<String, dynamic> queryParameters = {

        "mobile_number": event.mobileNumber,
        "context": "beneficiary"

      };
      emit(SentOtpForMobileNumberVerificationLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.sentOTPForMobileNumberVerification),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(SentOtpForMobileNumberVerificationErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(SentOtpForMobileNumberVerificationErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(SentOtpForMobileNumberVerificationErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SentOtpForMobileNumberVerificationErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(SentOtpForMobileNumberVerificationErrorState(errorMessage: 'Something went wrong'));
          }
        },  (right) {
          if (right != null && right.containsKey('error')) {
            emit(SentOtpForMobileNumberVerificationErrorState(errorMessage: right['error']));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(SentOtpForMobileNumberVerificationDoneState(message: message, mobileNumber: event.mobileNumber, isMobileNumberUpdate: event.isMobileNumberUpdate));
          }
        },

        );
      } catch (e) {
        emit(SentOtpForMobileNumberVerificationErrorState(errorMessage: '$e'));
      }
    });


    on<OnResendOtpForMobileNumberVerificationEvent>((event, emit) async {
      Map<String, dynamic> queryParameters = {

        "mobile_number": event.mobileNumber,
        "context": "beneficiary"

      };
      emit(OnResendOtpForMobileNumberVerificationLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.sentOTPForMobileNumberVerification),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(OnResendOtpForMobileNumberVerificationErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(OnResendOtpForMobileNumberVerificationErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(OnResendOtpForMobileNumberVerificationErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(OnResendOtpForMobileNumberVerificationErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(OnResendOtpForMobileNumberVerificationErrorState(errorMessage: 'Something went wrong'));
          }
        },  (right) {
          if (right != null && right.containsKey('error')) {
            emit(OnResendOtpForMobileNumberVerificationErrorState(errorMessage: right['error']));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(OnResendOtpForMobileNumberVerificationDoneState(message: message,));
          }
        },

        );
      } catch (e) {
        emit(OnResendOtpForMobileNumberVerificationErrorState(errorMessage: '$e'));
      }
    });


    on<OnOtpVerificationEvent>((event, emit) async {
      Map<String, dynamic> queryParameters = {
        "mobile_number": event.mobileNumber,
        "otp": event.otp,
        "context": "beneficiary"
      };
      emit(OtpVerificationLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.otpVerification),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(OtpVerificationErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(OtpVerificationErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(OtpVerificationErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(OtpVerificationErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(OtpVerificationErrorState(errorMessage: 'Something went wrong'));
          }
        },  (right) {
          if (right != null && right.containsKey('error')) {
            emit(OtpVerificationErrorState(errorMessage: right['error']));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(OtpVerificationDoneState(message: message, isMobileNumberUpdate: event.isMobileNumberUpdate));
          }
        },

        );
      } catch (e) {
        emit(OtpVerificationErrorState(errorMessage: '$e'));
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



    on<OnUploadVoucherImageEvent>((event, emit) async {
      String filePath = "";

      if (event.filePath.isNotEmpty == true) {
        Map<String, dynamic> queryParameters = {
          "collection_name": 'photo',
          "file_path": event.filePath,
        };

        emit(UploadVoucherImageLoadingState());

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
              emit(UploadVoucherImageErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(UploadVoucherImageErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(UploadVoucherImageErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(UploadVoucherImageErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(UploadVoucherImageErrorState(errorMessage: 'Something went wrong'));
            }
          }, (right) {
            if (right != null && right.containsKey('error')) {
              hasError = true;
              emit(UploadVoucherImageErrorState(errorMessage: right['error']));
            } else {
              filePath = UploadMediaModel.fromJson(right).data?.fileName ?? "";
              uploadedFilePath = UploadMediaModel.fromJson(right).data?.fileName ?? "";
              emit(UploadVoucherImageDoneState(filePath: filePath));
            }
          });

          if (hasError || filePath.isEmpty) {
            return; // Do not proceed to second API call
          }
        } catch (e) {
          debugPrint('$e');
          emit(UploadVoucherImageErrorState(errorMessage: '$e'));
          return; // Do not proceed to second API call
        } }
      if (event.isUploadFromDetail == true) {
        // Proceed only if media upload was successful
        Map<String, dynamic> queryParameters = {
          "expense_id": event.expenseId,
          "voucher_photo": filePath,
        };

        try {
          Either<Failure, dynamic> response = await ApiBaseHelpers().post(
            Uri.parse(ApiConst.expensesUploadVoucher),
            ApiBaseHelpers.headers(),
            body: queryParameters,
          );

          response.fold(
                (left) {
              if (left is UnauthorizedFailure) {
                emit(UploadVoucherImageErrorState(errorMessage: left.errorMessage!));
              } else if (left is NoDataFailure) {
                emit(UploadVoucherImageErrorState(errorMessage: left.errorMessage));
              } else if (left is ServerFailure) {
                emit(UploadVoucherImageErrorState(errorMessage: 'Server Failure'));
              } else if (left is InvalidDataUnableToProcessFailure) {
                emit(UploadVoucherImageErrorState(
                    errorMessage: jsonDecode(left.errorMessage)['error']));
              } else {
                emit(UploadVoucherImageErrorState(errorMessage: 'Something went wrong'));
              }
            },
                (right) {
              if (right != null && right.containsKey('error')) {
                emit(UploadVoucherImageErrorState(errorMessage: right['error']));
              } else {
                final message = right['message'] ?? 'Operation completed successfully.';
                emit(UploadVoucherFromDetailDoneState(message: message));
              }
            },
          );
        } catch (e) {
          emit(UploadVoucherImageErrorState(errorMessage: "$e"));
        }
      }



    });




  }

  void updateExpenseInHistoryList()
  {

  }

  Future<Either<Failure, dynamic>> putApiFunction({required Map<String, dynamic> queryParameters,
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


