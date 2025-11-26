import 'package:asetize/features/my_unit/models/monthly_summery.dart';

import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../../account_books/models/invoice_detail_model.dart';
import '../models/Invoice_model.dart';
import '../models/created_visitor_pass_detail_model.dart';
import '../models/how_to_pay_model.dart';
import '../models/invoice_detail_model.dart';
import '../models/invoice_statement_model.dart';
import '../models/invoice_summary_model.dart';
import '../models/invoice_transaction_model.dart';
import '../models/latest_invoice_model.dart';
import '../models/noc_applied_model.dart';
import '../models/noc_submitted_model.dart';
import '../models/payment_gateway_detail_model.dart';
import '../models/payment_model.dart';
import 'package:http/http.dart' as http;

import '../models/payment_receipt_model.dart';
import '../models/payments_detail_model.dart';
import '../models/payments_initiate_model.dart';
import '../pages/transaction_detail_screen.dart';
part 'my_unit_event.dart';
part 'my_unit_state.dart';

class MyUnitBloc extends Bloc<MyUnitEvent, MyUnitState> {
  List<InvoiceData> invoices = [];
  List<LatestInvoice> latestInvoices = [];
  List<PaymentData> paymentData = [];
  List<StatementData> statementData = [];
  List<StatementData> statementManagerData = [];
  List<InvoiceTransactionData> invoiceTransactionData = [];
  List<InvoiceTransactionData> invoiceManagerTransactionData = [];
  String? pdfUrl;
  MonthlySummeryData? monthlySummeryData;
  SummaryData? summaryData;
  SummaryData? summaryManagerData;
  CreatedVisitorPassDetailData? createdVisitorPassDetailData;
  NOCSubmittedData? nocSubmittedData;
  HowToPayData? howToPayData;
  NOCSubmittedData? getNocData;
  PaymentsInitiateData? paymentsInitiateData;
  PaymentGatewayDetailData? paymentGatewayDetailData;
  List<Payments> statementPayment = [];
  List<Invoices> statementInvoices = [];
  List<Payments> statementPaymentManager = [];
  List<Invoices> statementInvoicesForManager = [];
  List<NOCAppliedListData> nocAppliedListData = [];

  List<PaymentsDetailInvoices> paymentsDetailInvoicesData = [];

  Map<String, dynamic> transactionDetail = {};
  Map<String, dynamic> transactionManagerDetail = {};
  Map<String, dynamic> transactionPaymentDetail = {};

  MyUnitBloc() : super(MyUnitInitialState()) {
    on<ResetMyUnitEvent>((event, emit) async {
      statementData.clear();
      paymentData.clear();
      invoices.clear();
      latestInvoices.clear();
      summaryData = null;
      transactionDetail.clear();
      transactionDetail.clear();
      statementPayment.clear();
      statementInvoices.clear();
      emit(MyUnitInitialState());
    });

    on<ResetPaymentStateEvent>((event, emit) {
      emit(MyUnitInitialState());
    });

    on<OnReLoadMyUnitUiEvent>((event, emit) async {
      emit(ReloadUiDoneState());
    });

    on<FetchInvoicesEvent>(_fetchAllInvoices);

    on<FetchInvoiceSummaryEvent>((event, emit) async {
      emit(MyUnitLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.invoicesSummary),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(MyUnitErrorState2(left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(MyUnitErrorState2(left.errorMessage));
            } else if (left is ServerFailure) {
              emit(MyUnitErrorState2('Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(MyUnitErrorState2(jsonDecode(left.errorMessage)['error']));
            } else {
              emit(MyUnitErrorState2('Something went wrong'));
            }
          },
          (right) {
            try {
              summaryData = InvoiceSummaryModel.fromJson(right).data;
              emit(InvoiceSummaryDoneState());
            } catch (e) {
              emit(MyUnitErrorState2("$e"));
            }
          },
        );
      } catch (e) {
        emit(MyUnitErrorState2("$e"));
      }
    });

    on<FetchMonthlySummaryEvent>((event, emit) async {
      emit(MyMonthlySummeryLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
        "year": event.year,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.managerMonthlySummary),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
          (left) {
            monthlySummeryData = null;
            if (left is UnauthorizedFailure) {
              emit(MyMonthlySummeryErrorState(left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(MyMonthlySummeryErrorState(left.errorMessage));
            } else if (left is ServerFailure) {
              emit(MyMonthlySummeryErrorState('Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(MyMonthlySummeryErrorState(
                  jsonDecode(left.errorMessage)['error']));
            } else {
              emit(MyMonthlySummeryErrorState('Something went wrong'));
            }
          },
          (right) {
            try {
              monthlySummeryData = null;
              monthlySummeryData = MonthlySummeryModel.fromJson(right).data;
              emit(MyMonthlySummeryDoneState());
            } catch (e) {
              monthlySummeryData = null;
              emit(MyMonthlySummeryErrorState("$e"));
            }
          },
        );
      } catch (e) {
        monthlySummeryData = null;
        emit(MyMonthlySummeryErrorState("$e"));
      }
    });

    on<FetchInvoiceStatementEvent>((event, emit) async {
      emit(MyUnitLoadingState());
      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.invoicesStatement),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(MyUnitErrorState2(left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(MyUnitErrorState(left.errorMessage));
            } else if (left is ServerFailure) {
              emit(MyUnitErrorState('Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(MyUnitErrorState(jsonDecode(left.errorMessage)['error']));
            } else {
              emit(MyUnitErrorState('Something went wrong'));
            }
          },
          (right) {
            try {
              statementData = InvoiceStatementModel.fromJson(right).data ?? [];
              emit(InvoiceStatementDoneState());
            } catch (e) {
              emit(MyUnitErrorState("$e"));
            }
          },
        );
      } catch (e) {
        emit(MyUnitErrorState("$e"));
      }
    });

    on<FetchInvoiceHistoryDetailEvent>((event, emit) async {
      //Clear the list before adding the data
      transactionDetail = {};
      statementPayment = [];
      statementInvoices = [];

      ComeFromForDetails comeFrom = event.comeFrom;
      late Either<Failure, dynamic> response;
      Map<String, dynamic> queryParameters = {};

      try {
        if (comeFrom == ComeFromForDetails.unitPayment) {
          emit(MyUnitLoadingState());
          response = await putApiFunction(
            headers: ApiBaseHelpers.headersPut(),
            apiUrl: "${ApiConst.invoiceTransaction}/${event.houseId}",
            queryParameters: {},
          );
        }

        /// For all another
        else if (comeFrom == ComeFromForDetails.unitStatement) {
          emit(MyUnitLoadingState());
          queryParameters = {
            "table": event.tableName,
          };
          response = await putApiFunction(
            queryParameters: queryParameters,
            headers: ApiBaseHelpers.headersPut(),
            apiUrl: "${ApiConst.invoiceHistoryDetail}/${event.id}/table",
          );
        } else if (comeFrom == ComeFromForDetails.managerUnitPayment) {
          emit(MyUnitLoadingState());
          // queryParameters = {
          //   "house_id": event.houseId,
          // };
          // response = await ApiBaseHelpers().post(
          //   Uri.parse(ApiConst.paymentsManagerDetail),
          //   ApiBaseHelpers.headers(),
          //   body: queryParameters,
          // );

          response = await putApiFunction(
            headers: ApiBaseHelpers.headersPut(),
            apiUrl: "${ApiConst.paymentsManagerDetail}/${event.houseId}",
            queryParameters: {},
          );
        }

        /// For all another
        else if (comeFrom == ComeFromForDetails.managerUnitStatement) {
          emit(MyUnitLoadingState());
          queryParameters = {
            "table": event.tableName,
          };
          response = await putApiFunction(
            queryParameters: queryParameters,
            headers: ApiBaseHelpers.headersPut(),
            apiUrl: "${ApiConst.invoicesManagerDetail}/${event.id}/table",
          );
        }

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(MyUnitErrorState2(left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(MyUnitErrorState(left.errorMessage));
          } else if (left is ServerFailure) {
            emit(MyUnitErrorState('Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(MyUnitErrorState(jsonDecode(left.errorMessage)['error']));
          } else {
            emit(MyUnitErrorState('Something went wrong'));
          }
        }, (right) {
          transactionDetail = right['data'];
          if (right['data'].containsKey("payments")) {
            statementPayment =
                InvoiceNewDetail.fromJson(right).data?.payments ?? [];
          } else if (right['data'].containsKey("invoices")) {
            statementInvoices =
                InvoiceNewDetail.fromJson(right).data?.invoices ?? [];
          }
          emit(FetchInvoiceHistoryDetailDoneState());
        });
      } catch (e) {
        emit(MyUnitErrorState('$e'));
      }
    });

    on<FetchInvoiceTransactionEvent>((event, emit) async {
      emit(MyUnitLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.invoiceTransaction),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(MyUnitErrorState2(left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(MyUnitErrorState2(left.errorMessage));
            } else if (left is ServerFailure) {
              emit(MyUnitErrorState2('Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(MyUnitErrorState2(jsonDecode(left.errorMessage)['error']));
            } else {
              emit(MyUnitErrorState2('Something went wrong'));
            }
          },
          (right) {
            try {
              invoiceTransactionData =
                  InvoiceTransactionModel.fromJson(right).data ?? [];
              emit(InvoiceTransactionDoneState());
            } catch (e) {
              emit(MyUnitErrorState2("$e"));
            }
          },
        );
      } catch (e) {
        emit(MyUnitErrorState2("$e"));
      }
    });

    ///Manager Invoice
    on<FetchManagerInvoiceSummaryEvent>((event, emit) async {
      emit(MyUnitLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.invoicesManagerSummary),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(MyUnitInvoiceManagerErrorState(left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(MyUnitInvoiceManagerErrorState(left.errorMessage));
            } else if (left is ServerFailure) {
              emit(MyUnitInvoiceManagerErrorState('Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(MyUnitInvoiceManagerErrorState(
                  jsonDecode(left.errorMessage)['error']));
            } else {
              emit(MyUnitInvoiceManagerErrorState('Something went wrong'));
            }
          },
          (right) {
            try {
              summaryManagerData = InvoiceSummaryModel.fromJson(right).data;
              emit(InvoiceManagerSummaryDoneState());
            } catch (e) {
              emit(MyUnitInvoiceManagerErrorState("$e"));
            }
          },
        );
      } catch (e) {
        emit(MyUnitInvoiceManagerErrorState("$e"));
      }
    });

    on<FetchManagerInvoiceStatementEvent>((event, emit) async {
      emit(MyUnitLoadingState());
      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.invoicesManagerStatement),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(MyUnitInvoiceManagerErrorState(left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(MyUnitInvoiceManagerErrorState(left.errorMessage));
            } else if (left is ServerFailure) {
              emit(MyUnitInvoiceManagerErrorState('Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(MyUnitInvoiceManagerErrorState(
                  jsonDecode(left.errorMessage)['error']));
            } else {
              emit(MyUnitInvoiceManagerErrorState('Something went wrong'));
            }
          },
          (right) {
            try {
              statementManagerData =
                  InvoiceStatementModel.fromJson(right).data ?? [];
              emit(InvoiceManagerStatementDoneState());
            } catch (e) {
              emit(MyUnitInvoiceManagerErrorState("$e"));
            }
          },
        );
      } catch (e) {
        emit(MyUnitInvoiceManagerErrorState("$e"));
      }
    });

    on<OnDeleteRequestForNOCEvent>((event, emit) async {
      emit(DeleteRequestForNOCLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(ApiConst.deleteNocRequest + event.id.toString()),
          ApiBaseHelpers.headers(),
          null,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(DeleteRequestForNOCErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(DeleteRequestForNOCErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(DeleteRequestForNOCErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(DeleteRequestForNOCErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(DeleteRequestForNOCErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(DeleteRequestForNOCErrorState(errorMessage : error));
            }
            else {
              final message = right['message'] ?? 'Operation completed successfully.';
              emit(DeleteRequestForNOCDoneState(message: message));
              // emit(DeleteRequestForNOCDoneState());
            }
          },
        );
      } catch (e) {
        emit(DeleteRequestForNOCErrorState(errorMessage: "$e"));
      }
    });

    on<FetchManagerInvoiceHistoryDetailEvent>((event, emit) async {
      Map<String, dynamic> queryParameters = {
        "table": event.tableName,
      };
      emit(MyUnitLoadingState());
      try {
        Either<Failure, dynamic> response = await putApiFunction(
          queryParameters: queryParameters,
          headers: ApiBaseHelpers.headersPut(),
          apiUrl: "${ApiConst.invoicesManagerDetail}/${event.id}/table",
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(MyUnitInvoiceManagerErrorState(left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(MyUnitInvoiceManagerErrorState(left.errorMessage));
          } else if (left is ServerFailure) {
            emit(MyUnitInvoiceManagerErrorState('Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(MyUnitInvoiceManagerErrorState(
                jsonDecode(left.errorMessage)['error']));
          } else {
            emit(MyUnitInvoiceManagerErrorState('Something went wrong'));
          }
        }, (right) {
          transactionManagerDetail = right['data'];
          if (right['data'].containsKey("payments")) {
            statementPaymentManager =
                InvoiceNewDetail.fromJson(right).data?.payments ?? [];
          }
          if (right['data'].containsKey("invoices")) {
            statementInvoicesForManager =
                InvoiceNewDetail.fromJson(right).data?.invoices ?? [];
          }

          emit(FetchManagerInvoiceHistoryDetailDoneState());
        });
      } catch (e) {
        emit(MyUnitInvoiceManagerErrorState('$e'));
      }
    });

    on<FetchInvoiceManagerTransactionEvent>((event, emit) async {
      emit(MyUnitLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.invoiceManagerTransaction),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(MyUnitErrorState2(left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(MyUnitErrorState2(left.errorMessage));
            } else if (left is ServerFailure) {
              emit(MyUnitErrorState2('Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(MyUnitErrorState2(jsonDecode(left.errorMessage)['error']));
            } else {
              emit(MyUnitErrorState2('Something went wrong'));
            }
          },
          (right) {
            try {
              invoiceManagerTransactionData =
                  InvoiceTransactionModel.fromJson(right).data ?? [];
              emit(InvoiceManagerTransactionDoneState());
            } catch (e) {
              emit(MyUnitErrorState2("$e"));
            }
          },
        );
      } catch (e) {
        emit(MyUnitErrorState2("$e"));
      }
    });

    ///Payment receipt
    on<FetchPaymentReceiptEvent>((event, emit) async {
      emit(MyUnitPdfLoadingState());

      Map<String, dynamic> queryParameters = {
        "payment_id": event.paymentId,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.paymentReceipt),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(MyUnitErrorState2(left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(MyUnitErrorState2(left.errorMessage));
            } else if (left is ServerFailure) {
              emit(MyUnitErrorState2('Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(MyUnitErrorState2(jsonDecode(left.errorMessage)['error']));
            } else {
              emit(MyUnitErrorState2('Something went wrong'));
            }
          },
          (right) {
            try {
              pdfUrl = PaymentReceiptModel.fromJson(right).pdfUrl ?? '';
              emit(PaymentReceiptDoneState());
            } catch (e) {
              emit(MyUnitErrorState2("$e"));
            }
          },
        );
      } catch (e) {
        emit(MyUnitErrorState2("$e"));
      }
    });

    on<FetchInvoiceTransactionDetailEvent>((event, emit) async {
      emit(MyUnitLoadingState());
      try {
        Either<Failure, dynamic> response = await putApiFunction(
          headers: ApiBaseHelpers.headersPut(),
          apiUrl: "${ApiConst.invoiceTransaction}/${event.houseId}",
          queryParameters: {},
        ); //https://api-community.dexbytes.in/api/invoices/transactions/3
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(MyUnitErrorState2(left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(MyUnitErrorState(left.errorMessage));
          } else if (left is ServerFailure) {
            emit(MyUnitErrorState('Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(MyUnitErrorState(jsonDecode(left.errorMessage)['error']));
          } else {
            emit(MyUnitErrorState('Something went wrong'));
          }
        }, (right) {
          // print(right.data);
          try {
            transactionPaymentDetail = right['data'];
            if (right['data'].containsKey("invoices")) {
              paymentsDetailInvoicesData =
                  PaymentDetailModel.fromJson(right).data?.invoices ?? [];
            }
          } catch (e) {
            print(e);
          }
          emit(FetchInvoiceTransactionDetailDoneState());
        });
      } catch (e) {
        emit(MyUnitErrorState('$e'));
      }
    });
    on<OnUpdateRequestForNOCEvent>((event, emit) async {
      emit(UpdateRequestForNOCLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
        "reason": event.reason,
        "remark": event.remark,
        'first_name': event.firstName,
        'last_name': event.lastName,
        'address': event.address,
        'phone': event.phoneNumber,
        "broker_id": event.brokerId,
        'is_completed_police_verification': event.isCompletedPoliceVerification
      };
      try {
        String url = '${ApiConst.updateNoc}/${event.id.toString()}';
        print(url);
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );
        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(UpdateRequestForNOCErrorState(
                  errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(UpdateRequestForNOCErrorState(
                  errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(UpdateRequestForNOCErrorState(
                  errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(UpdateRequestForNOCErrorState(
                  errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(UpdateRequestForNOCErrorState(
                  errorMessage: 'Something went wrong'));
            }
          },
          (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(UpdateRequestForNOCErrorState(errorMessage: error));
            } else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(UpdateRequestForNOCDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(UpdateRequestForNOCErrorState(errorMessage: "$e"));
      }
    });

    on<OnSubmitRequestForNOCEvent>((event, emit) async {
      emit(SubmitRequestForNOCLoadingState());
      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
        "reason": event.reason,
        "remark": event.remark,
        'first_name': event.firstName,
        'last_name': event.lastName,
        'address': event.address,
        'phone': event.phoneNumber,
        "broker_id": event.brokerId,
        'is_completed_police_verification': event.isCompletedPoliceVerification
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.nocSubmit),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(SubmitRequestForNOCErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(SubmitRequestForNOCErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(SubmitRequestForNOCErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SubmitRequestForNOCErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(SubmitRequestForNOCErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(SubmitRequestForNOCErrorState(errorMessage: error));
          } else {
            getNocData = NOCSubmittedModel.fromJson(right).data;
            int? requestedNocId = getNocData?.id;
            emit(SubmitRequestForNOCDoneState(requestedNocId: requestedNocId));
          }
        });
      } catch (e) {
        emit(SubmitRequestForNOCErrorState(errorMessage: '$e'));
      }
    });

    on<OnPaymentsInitiateEvent>((event, emit) async {
      emit(PaymentsInitiateLoadingState());
      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
        "amount": event.amount,
        "gateway_amount": event.gatewayAmount,
        "gst_amount": event.gstAmount,
        "total_amount": event.totalAmount,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.paymentsInitiate),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(PaymentsInitiateErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(PaymentsInitiateErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(PaymentsInitiateErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(PaymentsInitiateErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(PaymentsInitiateErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(PaymentsInitiateErrorState(errorMessage: error));
          } else {
            paymentsInitiateData = PaymentsInitiateModel.fromJson(right).data;
            final message =
                right['message'] ?? 'Operation completed successfully.';
            emit(PaymentsInitiateDoneState(
              message: message,
              paymentAttemptId: paymentsInitiateData?.paymentAttemptId ?? 0,
              houseId: paymentsInitiateData?.houseId ?? 0,
              houseName: paymentsInitiateData?.houseName ?? "",
              totalAmount: paymentsInitiateData?.totalAmount ?? "",
            ));
            await PrefUtils().saveInt(
                WorkplaceNotificationConst.paymentAttemptId,
                paymentsInitiateData?.paymentAttemptId);
          }
        });
      } catch (e) {
        emit(PaymentsInitiateErrorState(errorMessage: '$e'));
      }
    });


    on<OnPaymentGatewayDetailEvent>((event, emit) async {
      emit(PaymentGatewayDetailLoadingState());
      Map<String, dynamic> queryParameters = {
        "gateway_name": event.gatewayName
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.paymentGatewayDetail),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(PaymentGatewayDetailErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(PaymentGatewayDetailErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(PaymentGatewayDetailErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(PaymentGatewayDetailErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(PaymentGatewayDetailErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(PaymentGatewayDetailErrorState(errorMessage: error));
          } else {
            paymentGatewayDetailData = OnPaymentGatewayDetailModel.fromJson(right).data;
            final message =
                right['message'] ?? 'Operation completed successfully.';
            emit(PaymentGatewayDetailDoneState(
              message: message,
            ));
          }
        });
      } catch (e) {
        emit(PaymentGatewayDetailErrorState(errorMessage: '$e'));
      }
    });

    on<OnPaymentCancelEvent>((event, emit) async {
      emit(PaymentCancelLoadingState());

      Map<String, dynamic> queryParameters = {
        // 'id': event.id,
        'response_message': event.responseMessage,
      };

      try {
        String url = '${ApiConst.paymentCancel}/${event.id}/cancel';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );

        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(PaymentCancelErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(PaymentCancelErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(PaymentCancelErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(PaymentCancelErrorState(
                  errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(PaymentCancelErrorState(
                  errorMessage: 'Something went wrong'));
            }
          },
          (right) async {
            if (right != null && right.containsKey('error')) {
              emit(PaymentCancelErrorState(errorMessage: right['error']));
            } else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(PaymentCancelDoneState(message: message));
              await PrefUtils()
                  .remove(WorkplaceNotificationConst.paymentAttemptId);
              int? clearedValue = await PrefUtils()
                  .readInt(WorkplaceNotificationConst.paymentAttemptId);
              print('Value after clearing: $clearedValue');
            }
          },
        );
      } catch (e) {
        emit(PaymentCancelErrorState(errorMessage: "$e"));
      }
    });

    on<OnPaymentSuccessEvent>((event, emit) async {
      emit(PaymentSuccessLoadingState());

      Map<String, dynamic> queryParameters = {
        // 'id': event.id,
        'gateway_transaction_id': event.gatewayTransactionId,
        "response_message": event.responseMessage,
      };

      try {
        String url = '${ApiConst.paymentSuccess}/${event.id}/success';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );

        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(PaymentSuccessErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(PaymentSuccessErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(PaymentSuccessErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(PaymentSuccessErrorState(
                  errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(PaymentSuccessErrorState(
                  errorMessage: 'Something went wrong'));
            }
          },
          (right) async {
            if (right != null && right.containsKey('error')) {
              emit(PaymentSuccessErrorState(errorMessage: right['error']));
            } else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(PaymentSuccessDoneState(message: message));
              await PrefUtils()
                  .remove(WorkplaceNotificationConst.paymentAttemptId);
              int? clearedValue = await PrefUtils()
                  .readInt(WorkplaceNotificationConst.paymentAttemptId);
              print('Value after clearing: $clearedValue');
            }
          },
        );
      } catch (e) {
        emit(PaymentSuccessErrorState(errorMessage: "$e"));
      }
    });

    on<OnCheckStatusOfNOCSubmissionEvent>((event, emit) async {
      // Map<String, String> queryParams = {
      //   'id': event.id.toString()
      //
      // };
      emit(CheckStatusOfNOCSubmissionLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(
              ApiConst.isProduction
                  ? ApiConst.baseUrlNonProdHttpC
                  : ApiConst.baseUrlNonHttpC,
              "/api/nocs/check/${event.houseId}",
            ),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(CheckStatusOfNOCSubmissionErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(CheckStatusOfNOCSubmissionErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(CheckStatusOfNOCSubmissionErrorState(
                errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(CheckStatusOfNOCSubmissionErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(CheckStatusOfNOCSubmissionErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(CheckStatusOfNOCSubmissionErrorState(errorMessage: error));
          } else {
            nocSubmittedData = NOCSubmittedModel.fromJson(right).data;
            emit(CheckStatusOfNOCSubmissionDoneState());
          }
        });
      } catch (e) {
        emit(CheckStatusOfNOCSubmissionErrorState(errorMessage: '$e'));
      }
    });

    on<OnGetNOCAppliedListEvent>((event, emit) async {
      // Map<String, String> queryParams = {
      //   'id': event.id.toString()
      //
      // };

      emit(NOCAppliedListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(
              ApiConst.isProduction
                  ? ApiConst.baseUrlNonProdHttpC
                  : ApiConst.baseUrlNonHttpC,
              "/api/nocs/house/${event.houseId}",
            ),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(
                NOCAppliedListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(NOCAppliedListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(NOCAppliedListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(NOCAppliedListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(
                NOCAppliedListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(NOCAppliedListErrorState(errorMessage: error));
          } else {
            nocAppliedListData = NOCAppliedListModel.fromJson(right).data ?? [];
            emit(NOCAppliedListDoneState());
          }
        });
      } catch (e) {
        emit(NOCAppliedListErrorState(errorMessage: '$e'));
      }
    });

    on<OnNocPaymentReceiptSubmitEvent>((event, emit) async {
      String filePath = "";
      if (event.filePath.isNotEmpty == true) {
        Map<String, dynamic> queryParameters = {
          "collection_name": 'photo',
          "file_path": event.filePath,
        };
        emit(OnNocPaymentReceiptLoadingState());
        try {
          Either<Failure, dynamic> response = await postUploadMedia(
            queryParameters: queryParameters,
            headers: ApiBaseHelpers.headersMultipart(),
            apiUrl: ApiConst.updateProfilePhotos,
          );

          response.fold((left) {
            if (left is UnauthorizedFailure) {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: 'Something went wrong'));
            }
            return;
          }, (right) {
            if (right != null && right.containsKey('error')) {
              emit(OnNocPaymentReceiptErrorState(errorMessage: right['error']));
            } else {
              filePath = UploadMediaModel.fromJson(right).data?.fileName ?? " ";
            }

            // emit(getImagePathDoneState());
          });
        } catch (e) {
          debugPrint('$e');
          emit(OnNocPaymentReceiptErrorState(errorMessage: '$e'));
          return;
        }
      }
      Map<String, dynamic> queryParameters = {
        "file_path": filePath,
      };

      try {
        String url = '${ApiConst.nocListUpdate}/${event.id}/receipt';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );
        response.fold(
          (left) {
            if (left is UnauthorizedFailure) {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(OnNocPaymentReceiptErrorState(
                  errorMessage: 'Something went wrong'));
            }
          },
          (right) {
            if (right != null && right.containsKey('error')) {
              emit(OnNocPaymentReceiptErrorState(errorMessage: right['error']));
            } else {
              emit(OnNocPaymentReceiptDoneState());
            }
          },
        );
      } catch (e) {
        emit(OnNocPaymentReceiptErrorState(errorMessage: "$e"));
      }
    });


    on<OnGetCreatedVisitorPassDetailEvent>((event, emit) async {
      emit(CreatedVisitorPassDetailLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(ApiConst.isProduction ? ApiConst.baseUrlNonProdHttpC : ApiConst.baseUrlNonHttpC, "/api/pre/visitor-entries/${event.visitorEntryId}",),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(CreatedVisitorPassDetailErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(CreatedVisitorPassDetailErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(CreatedVisitorPassDetailErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(CreatedVisitorPassDetailErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(CreatedVisitorPassDetailErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(CreatedVisitorPassDetailErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            createdVisitorPassDetailData = CreatedVisitorPassDetailModel.fromJson(right).data;

            emit(CreatedVisitorPassDetailDoneState(message: message));
          }
        });
      } catch (e) {
        emit(CreatedVisitorPassDetailErrorState(errorMessage: '$e'));
      }
    });


    on<OnCancelVisitorPassEvent>((event, emit) async {
      emit(CancelVisitorPassLoadingState());

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(ApiConst.deleteUpcomingVisitor + event.id.toString()),
          ApiBaseHelpers.headers(),
          null,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(CancelVisitorPassErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(CancelVisitorPassErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(CancelVisitorPassErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(CancelVisitorPassErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(CancelVisitorPassErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(CancelVisitorPassErrorState(errorMessage : error));
            }
            else {
              emit(CancelVisitorPassDoneState(message: ''));
            }
          },
        );
      } catch (e) {
        emit(CancelVisitorPassErrorState(errorMessage: "$e"));
      }
    });

    on<OnHowToPayGetListEvent>((event, emit) async {
      emit(HowToPayGetListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.howToPayList),
          ApiBaseHelpers.headers(),);
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(HowToPayGetListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(HowToPayGetListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(HowToPayGetListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(HowToPayGetListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(HowToPayGetListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(HowToPayGetListErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            howToPayData = HowToPayModel.fromJson(right).data;
            emit(HowToPayGetListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(HowToPayGetListErrorState(errorMessage: '$e'));
      }
    });



  }

  Future<void> _fetchAllInvoices(
      FetchInvoicesEvent event, Emitter<MyUnitState> emit) async {
    LoadingWidget2.startLoadingWidget(event.mContext!);
    emit(MyUnitLoadingState());

    Map<String, dynamic> queryParameters = {
      "house_id": event.houseId,
    };

    try {
      var invoiceResponse = ApiBaseHelpers().post(
        Uri.parse(ApiConst.myUnitInvoices),
        ApiBaseHelpers.headers(),
        body: queryParameters,
      );

      var latestInvoiceResponse = ApiBaseHelpers().post(
        Uri.parse(ApiConst.myUnitLatestInvoices),
        ApiBaseHelpers.headers(),
        body: queryParameters,
      );

      var paymentResponse = ApiBaseHelpers().post(
        Uri.parse(ApiConst.myUnitPayment),
        ApiBaseHelpers.headers(),
        body: queryParameters,
      );

      final responses = await Future.wait(
          [invoiceResponse, latestInvoiceResponse, paymentResponse]);

      // Process the first response (invoices)
      responses[0].fold(
        (left) {
          if (left is UnauthorizedFailure) {
            emit(MyUnitErrorState2(left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(MyUnitErrorState(left.errorMessage));
          } else if (left is ServerFailure) {
            emit(MyUnitErrorState('Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(MyUnitErrorState(jsonDecode(left.errorMessage)['error']));
          } else {
            emit(MyUnitErrorState('Something went wrong'));
          }
        },
        (data) {
          try {
            if (data['data'] is List) {
              invoices = (data['data'] as List)
                  .map((json) => InvoiceData.fromJson(json))
                  .toList();
              print(invoices);
            } else {
              print("Unexpected format in invoices response: ${data['data']}");
              emit(MyUnitErrorState("Invalid format for invoices data"));
            }
          } catch (e) {
            emit(MyUnitErrorState("Error processing invoices data"));
          }
        },
      );

      // Process the second response (latest invoice)
      responses[1].fold(
        (left) {
          if (left is UnauthorizedFailure) {
            emit(MyUnitErrorState2(left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(MyUnitErrorState(left.errorMessage));
          } else if (left is ServerFailure) {
            emit(MyUnitErrorState('Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(MyUnitErrorState(jsonDecode(left.errorMessage)['error']));
          } else {
            emit(MyUnitErrorState('Something went wrong'));
          }
        },
        (data) {
          try {
            if (data['data'] is Map) {
              latestInvoices = [LatestInvoice.fromJson(data['data'])];
            } else {
              print(
                  "Unexpected format in latest invoices response: ${data['data']}");
              emit(MyUnitErrorState("Invalid format for latest invoices data"));
            }
          } catch (e) {
            emit(MyUnitErrorState("Error processing latest invoice data"));
          }
        },
      );

      // Process the third response (payment)
      responses[2].fold(
        (left) {
          if (left is UnauthorizedFailure) {
            emit(MyUnitErrorState2(left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(MyUnitErrorState(left.errorMessage));
          } else if (left is ServerFailure) {
            emit(MyUnitErrorState('Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(MyUnitErrorState(jsonDecode(left.errorMessage)['error']));
          } else {
            emit(MyUnitErrorState('Something went wrong'));
          }
        },
        (data) {
          try {
            if (data['data'] is List) {
              paymentData = (data['data'] as List)
                  .map((json) => PaymentData.fromJson(json))
                  .toList();
            } else {
              print(
                  "Unexpected format in latest invoices response: ${data['data']}");
              emit(MyUnitErrorState("Invalid format for latest invoices data"));
            }
          } catch (e) {
            emit(MyUnitErrorState("Error processing latest invoice data"));
          }
        },
      );

      LoadingWidget2.endLoadingWidget(event.mContext!);
      emit(MyUnitLoadedState(selectedUnit: event.selectedUnit));
    } catch (e) {
      emit(MyUnitErrorState("An error occurred while fetching invoices"));
    }
  }

  Future<Either<Failure, dynamic>> putApiFunction(
      {required Map<String, dynamic> queryParameters,
      required Map<String, String> headers,
      required String apiUrl}) async {
    http.Response response = await http.put(Uri.parse(apiUrl),
        headers: headers, body: queryParameters);

    if (response.statusCode == 200) {
      return Right(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return Left(
          NoDataFailure(errorMessage: jsonDecode(response.body)['error']));
    } else if (response.statusCode == 401) {
      return Left(UnauthorizedFailure());
    } else {
      return Left(ServerFailure());
    }
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

  void clearData() {
    invoices.clear();
    latestInvoices.clear();
    paymentData.clear();
    statementData.clear();
    statementManagerData.clear();
    invoiceTransactionData.clear();
    invoiceManagerTransactionData.clear();
    pdfUrl = null;
    monthlySummeryData = null;
    summaryData = null;
    summaryManagerData = null;
    createdVisitorPassDetailData = null;
    nocSubmittedData = null;
    getNocData = null;
    paymentsInitiateData = null;
    paymentGatewayDetailData = null;
    statementPayment.clear();
    statementInvoices.clear();
    statementPaymentManager.clear();
    statementInvoicesForManager.clear();
    nocAppliedListData = [];
    paymentsDetailInvoicesData.clear();
    transactionDetail.clear();
    transactionManagerDetail.clear();
    transactionPaymentDetail.clear();
  }

}
