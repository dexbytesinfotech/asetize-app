import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../model/assets_category_list_model.dart';
import '../model/assets_filters_model.dart';
import '../model/assets_history_model.dart';
import '../model/assets_list_model.dart';
import '../model/assets_location_list_model.dart';
import '../model/assets_member_list_model.dart';
import '../model/check_barcode_model.dart';
import '../model/vendor_list_model.dart';
import 'assets_management_event.dart';
import 'assets_management_state.dart';
import 'package:http/http.dart' as http;

class AssetsManagementBloc extends Bloc<AssetsManagementEvent, AssetsManagementState> {

  List<AssetsCategoryListData>? assetsCategoryListData;

  List<AssetsLocationListData> assetsLocationListData = [];
  List<AssetHistoryData> assetHistoryData = [];

  List<VendorListData>? vendorListData;

  AssetFilterData? assetFilterData;

  CheckBarcodeData? checkBarcodeData;

  List<AssetListData> activeAssetList = [];
  List<AssetListData> liabilityAssetList = [];

  List<AssetListData> myAssetListData = [];

  List<AssetListData> unassignedBarcodesAssetsList = [];

  AssetListData? assetDetailListData;

  List<AssetsMemberListData>? assetsMemberListData;

  List<Categories>? categories;

  List<Vendors>? vendors;
  // List<Statuses>? statuses;

  Map<String, dynamic>? statuses;

  bool isPaginateLoading = false;
  String nextPageUrl = '';
  int currentPage = 1;



  String nextPageUrlLiability = "";

  int currentPageLiability = 1;



  bool isPaginateLoadingForAssignBarcodeScreen = false;
  String nextPageUrlForAssignBarcodeScreen = '';
  int currentPageForAssignBarcodeScreen = 1;

  AssetsManagementBloc() : super(AssetsManagementInitialState()) {

    /// ====================== CATEGORY SECTION ======================
    on<OnGetAssetsCategoryList>((event, emit) async {
      emit(GetAssetsCategoryListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.assetsCategory),
          ApiBaseHelpers.headers(),
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetAssetsCategoryListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetAssetsCategoryListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetAssetsCategoryListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetAssetsCategoryListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetAssetsCategoryListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(GetAssetsCategoryListErrorState(errorMessage: "${right['error']}"));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            assetsCategoryListData = AssetsCategoryListModel.fromJson(right).data ?? [];
            emit(GetAssetsCategoryListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetAssetsCategoryListErrorState(errorMessage: '$e'));
      }
    });


    on<OnGetAssetsLocationList>((event, emit) async {
      emit(GetAssetsLocationListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.assetsLocations),
          ApiBaseHelpers.headers(),
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetAssetsLocationListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetAssetsLocationListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetAssetsLocationListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetAssetsLocationListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetAssetsLocationListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(GetAssetsLocationListErrorState(errorMessage: "${right['error']}"));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            assetsLocationListData = AssetLocationListModel.fromJson(right).data ?? [];
            emit(GetAssetsLocationListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetAssetsLocationListErrorState(errorMessage: '$e'));
      }
    });

    on<OnAddAssetCategoryEvent>((event, emit) async {
      emit(AddAssetCategoryLoadingState());
      Map<String, dynamic> queryParameters = {
        "title": event.title
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.addAssetCategory),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AddAssetCategoryErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(AddAssetCategoryErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(AddAssetCategoryErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddAssetCategoryErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddAssetCategoryErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(AddAssetCategoryErrorState(errorMessage: "${right['error']}"));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(AddAssetCategoryDoneState(message: message));
          }
        });
      } catch (e) {
        emit(AddAssetCategoryErrorState(errorMessage: "$e"));
      }
    });

    /// ====================== VENDOR SECTION ======================
    on<OnGetVendorList>((event, emit) async {
      emit(GetVendorListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.vendorList), // 👈 your vendor list API endpoint
          ApiBaseHelpers.headers(),
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetVendorListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetVendorListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetVendorListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetVendorListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetVendorListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(GetVendorListErrorState(errorMessage: "${right['error']}"));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            vendorListData = VendorListModel.fromJson(right).data ?? [];
            emit(GetVendorListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetVendorListErrorState(errorMessage: '$e'));
      }
    });

    on<OnAddVendorEvent>((event, emit) async {
      emit(AddVendorLoadingState());
      Map<String, dynamic> queryParameters = {
        "name": event.name
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.addVendor), // 👈 your vendor add API endpoint
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AddVendorErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(AddVendorErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(AddVendorErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddVendorErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddVendorErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(AddVendorErrorState(errorMessage: "${right['error']}"));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(AddVendorDoneState(message  : message));
          }
        });
      } catch (e) {
        emit(AddVendorErrorState(errorMessage: "$e"));
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


    on<OnAddAssetEvent>((event, emit) async {
      emit(AddAssetLoadingState());

      List<String> uploadedInvoiceFiles = [];

      // STEP 1: Upload invoice files if present
      if (event.invoiceFile != null && event.invoiceFile!.isNotEmpty) {
        for (int i = 0; i < event.invoiceFile!.length; i++) {
          // Optional: show upload progress
          // emit(InvoiceUploadingState(index: i));

          Either<Failure, dynamic> response = await postUploadMedia(
            queryParameters: {
              "collection_name": 'asset_invoices', // 👈 collection name for assets
              "file_path": event.invoiceFile![i],
            },
            headers: ApiBaseHelpers.headersMultipart(),
            apiUrl: ApiConst.updateProfilePhotos, // 👈 same media upload endpoint
          );

          bool hasError = false;

          response.fold((left) {
            hasError = true;
            if (left is UnauthorizedFailure) {
              emit(AddAssetErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NetworkFailure) {
              emit(AddAssetErrorState(errorMessage: 'Network not available'));
            } else if (left is ServerFailure) {
              emit(AddAssetErrorState(errorMessage: 'Server Failure'));
            } else if (left is NoDataFailure) {
              emit(AddAssetErrorState(errorMessage: left.errorMessage));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(AddAssetErrorState(errorMessage: left.errorMessage));
            } else {
              emit(AddAssetErrorState(errorMessage: 'Something went wrong'));
            }
          }, (right) {
            if (right != null && right.containsKey('error')) {
              hasError = true;
              emit(AddAssetErrorState(errorMessage: right['error']));
            } else {
              String fileName =
                  UploadMediaModel.fromJson(right).data?.fileName ?? '';
              if (fileName.isNotEmpty) {
                uploadedInvoiceFiles.add(fileName);
              }
            }
          });

          if (hasError) return; // stop if upload fails
        }
      }

      // STEP 2: Call Add Asset API after all uploads
      emit(AddAssetLoadingState());

      Map<String, dynamic> body = {
        "title": event.title,
        "asset_category_id": event.assetCategoryId,
        "vendor_id": event.vendorId,
        "registration_date": event.purChaseDate,
        "small_description": event.smallDescription,
        "description": event.longDescription,
        "expiry_months": event.expiryMonths,
        "warranty_months": event.warrantyMonths,
        "purchase_cost": event.purchaseCost,
        "model_number": event.modelNumber,
        "manufacture": event.manufacturer,
        "barcode": event.barcode,
        "location": event.assetLocation,
        "invoice_file": uploadedInvoiceFiles, // 👈 all uploaded invoice file names
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.addAsset),
          ApiBaseHelpers.headers(),
          body: body,
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AddAssetErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(AddAssetErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(AddAssetErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddAssetErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddAssetErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {

          if (right != null && right.containsKey('error')) {
            emit(AddAssetErrorState(errorMessage: "${right['error']}"));
          } else {
            print(activeAssetList);
            AssetListData assetListData = AssetListData.fromJson(right['data']);
            activeAssetList.insert(0, assetListData);
            final message = right['message'] ?? 'Asset added successfully.';
            emit(AddAssetDoneState(message: message));
          }
        });
      } catch (e) {
        emit(AddAssetErrorState(errorMessage: "$e"));
      }
    });


    on<OnGetAssetFilterList>((event, emit) async {
      emit(GetAssetFilterListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.assetFilterList), // 👈 Your API endpoint constant
          ApiBaseHelpers.headers(),
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetAssetFilterListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetAssetFilterListErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else if (left is ServerFailure) {
            emit(GetAssetFilterListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetAssetFilterListErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else {
            emit(GetAssetFilterListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(GetAssetFilterListErrorState(errorMessage: "${right['error']}"));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            assetFilterData = AssetFilterModel.fromJson(right).data;
            categories =  assetFilterData?.categories ?? [];
            vendors = assetFilterData?.vendors ?? [];
            statuses = assetFilterData?.statuses ?? {};

            emit(GetAssetFilterListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetAssetFilterListErrorState(errorMessage: '$e'));
      }
    });


    // on<OnGetAssetListEvent>((event, emit) async {
    //   emit(GetAssetListLoadingState());
    //
    //   /// ---------------------------
    //   /// CHECK: Fresh Reload
    //   /// ---------------------------
    //   final bool isFreshReload =
    //       event.isClearAssetList == true && event.nextPageKey == 1;
    //
    //   // Clear list ONLY if user requested
    //   if (event.isClearAssetList == true) {
    //     activeAssetList.clear();
    //   }
    //
    //   Map<String, String> queryParams = {
    //     if (event.assetCategoryId != null &&
    //         event.assetCategoryId.toString().isNotEmpty)
    //       "asset_category_id": event.assetCategoryId.toString(),
    //     if (event.vendorId != null && event.vendorId.toString().isNotEmpty)
    //       "vendor_id": event.vendorId.toString(),
    //     if (event.search != null && event.search.toString().isNotEmpty)
    //       "search": event.search.toString(),
    //     if (event.status != null && event.status.toString().isNotEmpty)
    //       "status": event.status.toString(),
    //     "page": event.nextPageKey.toString(),
    //   };
    //
    //   try {
    //     final uri = Uri.https(
    //       ApiConst.isProduction
    //           ? ApiConst.baseUrlNonProdHttpC
    //           : ApiConst.baseUrlNonHttpC,
    //       "api/assets",
    //       queryParams,
    //     );
    //
    //     print("🔗 Asset List API URL: ${uri.toString()}");
    //
    //     Either<Failure, dynamic> response =
    //     await ApiBaseHelpers().get(uri, ApiBaseHelpers.headers());
    //
    //     response.fold((left) {
    //       if (left is UnauthorizedFailure) {
    //         emit(GetAssetListErrorState(errorMessage: "Unauthorized Failure"));
    //       } else if (left is NoDataFailure) {
    //         emit(GetAssetListErrorState(
    //             errorMessage: jsonDecode(left.errorMessage)['error']));
    //       } else if (left is ServerFailure) {
    //         emit(GetAssetListErrorState(errorMessage: 'Server Failure'));
    //       } else if (left is InvalidDataUnableToProcessFailure) {
    //         emit(GetAssetListErrorState(
    //             errorMessage: jsonDecode(left.errorMessage)['error']));
    //       } else {
    //         emit(
    //             GetAssetListErrorState(errorMessage: 'Something went wrong.'));
    //       }
    //
    //
    //
    //       // else if (left is NoDataFailure ||
    //       //     left is InvalidDataUnableToProcessFailure) {
    //       //   // emit(GetAssetListErrorState(
    //       //   //     errorMessage: jsonDecode(left.meesss)['error']));
    //       // } else {
    //       //   emit(GetAssetListErrorState(errorMessage: "Something went wrong"));
    //       // }
    //     }, (right) {
    //       if (right != null && right.containsKey('error')) {
    //         emit(GetAssetListErrorState(errorMessage: right['error']));
    //         return;
    //       }
    //
    //       nextPageUrl =
    //           AssetListModel.fromJson(right).pagination?.nextPageApiUrl ?? '';
    //       currentPage =
    //           AssetListModel.fromJson(right).pagination?.currentPage ?? 1;
    //
    //       final newItems = AssetListModel.fromJson(right).data ?? [];
    //
    //       /// ---------------------------
    //       /// MAIN LOGIC (Fixed)
    //       /// ---------------------------
    //       for (final newItem in newItems) {
    //         final index = activeAssetList.indexWhere(
    //               (existingItem) => existingItem.id == newItem.id,
    //         );
    //
    //         // if (index >= 0) {
    //         //   // Update existing
    //         //   activeAssetList[index] = newItem;
    //         // } else {
    //         //   if (isFreshReload) {
    //         //     /// 🌟 Fresh page load → Add in BOTTOM
    //         //     activeAssetList.add(newItem);
    //         //   } else if (event.nextPageKey == 1) {
    //         //     /// 🌟 New item added/updated → Show at TOP
    //         //     activeAssetList.insert(0, newItem);
    //         //   } else {
    //         //     /// 🌟 Pagination page > 1 → Add bottom
    //         //     activeAssetList.add(newItem);
    //         //   }
    //         // }
    //       }
    //
    //       emit(GetAssetListDoneState(
    //           message: right['message'] ?? "Asset list fetched successfully."));
    //     });
    //   } catch (e) {
    //     emit(GetAssetListErrorState(errorMessage: '$e'));
    //   }
    // });


    on<OnGetAssetListEvent>((event, emit) async {
      emit(GetAssetListLoadingState());


      if (event.isClearAssetList==true){

        activeAssetList.clear();

      }


      // if (event.nextPageKey == 1) {
      //   // Clear only on first page
      //   activeAssetList.clear();
      //
      // }


      Map<String, String> queryParams = {
        if (event.assetCategoryId != null && event.assetCategoryId.toString().isNotEmpty)
          "asset_category_id": event.assetCategoryId.toString(),
        if (event.vendorId != null && event.vendorId.toString().isNotEmpty)
          "vendor_id": event.vendorId.toString(),
        if (event.search != null && event.search.toString().isNotEmpty)
          "search": event.search.toString(),
        if (event.status != null && event.status.toString().isNotEmpty)
          "status": event.status.toString(),
        "page": event.nextPageKey.toString(),
      };

      try {
        final uri = queryParams.isNotEmpty
            ? Uri.https(
          ApiConst.isProduction
              ? ApiConst.baseUrlNonProdHttpC
              : ApiConst.baseUrlNonHttpC,
          "api/assets",
          queryParams,
        )
            : Uri.https(
          ApiConst.isProduction
              ? ApiConst.baseUrlNonProdHttpC
              : ApiConst.baseUrlNonHttpC,
          "api/assets",
        );


        // ✅ Print full URL with parameters
        print("🔗 Asset List API URL: ${uri.toString()}");

        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          uri,
          ApiBaseHelpers.headers(),
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetAssetListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetAssetListErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else if (left is ServerFailure) {
            emit(GetAssetListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetAssetListErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else {
            emit(GetAssetListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(GetAssetListErrorState(errorMessage: "${right['error']}"));
          } else {

            nextPageUrl = AssetListModel.fromJson(right).pagination?.nextPageApiUrl ?? '';
            currentPage = AssetListModel.fromJson(right).pagination?.currentPage ?? 1;

            final newItems = AssetListModel.fromJson(right).data ?? [];

            for (final item in newItems) {
              if (!activeAssetList.any((existing) => existing.id == item.id)) {
                activeAssetList.add(item);
              }
            }



            final message = right['message'] ?? 'Asset list fetched successfully.';
            // assetListData = AssetListModel.fromJson(right).data ?? [];
            emit(GetAssetListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetAssetListErrorState(errorMessage: '$e'));
      }
    });



    on<OnGetMyLiabilityListEvent>((event, emit) async {
      emit(MyLiabilityListLoadingState());

      if (event.isClearAssetList==true){
        liabilityAssetList.clear();
      }


      // if (event.nextPageKey == 1) {
      //   // Clear only on first page
      //   liabilityAssetList.clear();
      //
      // }


      Map<String, String> queryParams = {
        if (event.assetCategoryId != null && event.assetCategoryId.toString().isNotEmpty)
          "asset_category_id": event.assetCategoryId.toString(),
        if (event.vendorId != null && event.vendorId.toString().isNotEmpty)
          "vendor_id": event.vendorId.toString(),
        if (event.search != null && event.search.toString().isNotEmpty)
          "search": event.search.toString(),
        if (event.status != null && event.status.toString().isNotEmpty)
          "status": event.status.toString(),
        "page": event.nextPageKey.toString(),
        "my_liability" : event.myLiability.toString()
      };

      try {
        final uri = queryParams.isNotEmpty
            ? Uri.https(
          ApiConst.isProduction
              ? ApiConst.baseUrlNonProdHttpC
              : ApiConst.baseUrlNonHttpC,
          "api/assets",
          queryParams,
        )
            : Uri.https(
          ApiConst.isProduction
              ? ApiConst.baseUrlNonProdHttpC
              : ApiConst.baseUrlNonHttpC,
          "api/assets",
        );


        // ✅ Print full URL with parameters
        print("🔗 Asset List API URL: ${uri.toString()}");

        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          uri,
          ApiBaseHelpers.headers(),
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(MyLiabilityListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(MyLiabilityListErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else if (left is ServerFailure) {
            emit(MyLiabilityListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(MyLiabilityListErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else {
            emit(MyLiabilityListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(MyLiabilityListErrorState(errorMessage: "${right['error']}"));
          } else {

            nextPageUrlLiability = AssetListModel.fromJson(right).pagination?.nextPageApiUrl ?? '';
            currentPageLiability = AssetListModel.fromJson(right).pagination?.currentPage ?? 1;

            final newItems = AssetListModel.fromJson(right).data ?? [];

            for (final item in newItems) {
              if (!liabilityAssetList.any((existing) => existing.id == item.id)) {
                liabilityAssetList.add(item);
              }
            }
            final message = right['message'] ?? 'Asset list fetched successfully.';
            // assetListData = AssetListModel.fromJson(right).data ?? [];
            emit(MyLiabilityListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(MyLiabilityListErrorState(errorMessage: '$e'));
      }
    });





    on<OnGetMyAssetListEvent>((event, emit) async {
      emit(GetMyAssetListLoadingState());


      // if (event.isClearAssetList==true){
      //
      //   myAssetListData.clear();
      //
      // }
      //
      //
      // if (event.nextPageKey == 1) {
      //   // Clear only on first page
      //   myAssetListData.clear();
      //
      // }


      Map<String, String> queryParams = {
        if (event.assetCategoryId != null && event.assetCategoryId.toString().isNotEmpty)
          "asset_category_id": event.assetCategoryId.toString(),
        if (event.vendorId != null && event.vendorId.toString().isNotEmpty)
          "vendor_id": event.vendorId.toString(),
        if (event.search != null && event.search.toString().isNotEmpty)
          "search": event.search.toString(),
        if (event.status != null && event.status.toString().isNotEmpty)
          "status": event.status.toString(),
        "page": event.nextPageKey.toString(),
      };

      try {
        final uri = queryParams.isNotEmpty
            ? Uri.https(
          ApiConst.isProduction
              ? ApiConst.baseUrlNonProdHttpC
              : ApiConst.baseUrlNonHttpC,
          "api/self/assets",
          queryParams,
        )
            : Uri.https(
          ApiConst.isProduction
              ? ApiConst.baseUrlNonProdHttpC
              : ApiConst.baseUrlNonHttpC,
          "api/self/assets",
        );


        // ✅ Print full URL with parameters
        print("🔗 Asset List API URL: ${uri.toString()}");

        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          uri,
          ApiBaseHelpers.headers(),
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetMyAssetListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetMyAssetListErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else if (left is ServerFailure) {
            emit(GetMyAssetListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetMyAssetListErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else {
            emit(GetMyAssetListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(GetMyAssetListErrorState(errorMessage: "${right['error']}"));
          } else {

            nextPageUrl = AssetListModel.fromJson(right).pagination?.nextPageApiUrl ?? '';
            currentPage = AssetListModel.fromJson(right).pagination?.currentPage ?? 1;

            final newItems = AssetListModel.fromJson(right).data ?? [];

            // for (final item in newItems) {
            //   if (!myAssetListData.any((existing) => existing.id == item.id)) {
            //     myAssetListData.add(item);
            //   }
            // }

            // ⭐ UPDATED LOGIC → Update item if exists, else add it
            for (final newItem in newItems) {
              final index = myAssetListData.indexWhere(
                      (existingItem) => existingItem.id == newItem.id);

              if (index >= 0) {
                // 🔄 Update the existing item
                myAssetListData[index] = newItem;
              } else {
                // ➕ Add new item if not found
                myAssetListData.add(newItem);
              }
            }










            final message = right['message'] ?? 'Asset list fetched successfully.';
            // activeAssetList = AssetListModel.fromJson(right).data ?? [];
            emit(GetMyAssetListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetMyAssetListErrorState(errorMessage: '$e'));
      }
    });




    on<OnGetAssetDetailListEvent>((event, emit) async {



      Map<String, dynamic> queryParameters = {
      };

      try {
        emit(GetAssetDetailListLoadingState());

        String url = '${ApiConst.getAssetDetailList}/${event.assetId}';
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          // body:  queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetAssetDetailListErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetAssetDetailListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetAssetDetailListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetAssetDetailListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetAssetDetailListErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetAssetDetailListErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            assetDetailListData = AssetListModel.fromJson(right).detailData;
            /// Updating data on current list index item
            int itemIndex = activeAssetList.indexWhere((item)=> item.id == assetDetailListData?.id);
            if(itemIndex!=-1){
              activeAssetList[itemIndex] = assetDetailListData!;
            }

            // assetDetailListData = AssetListModel.fromJson(right).detailData;

            emit(GetAssetDetailListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetAssetDetailListErrorState(errorMessage: '$e'));
      }
    });


    on<OnChangeAssetStatusEvent>((event, emit) async {
      emit(ChangeAssetStatusLoadingState());
      Map<String, dynamic> queryParameters = {
        "status": event.status,
        "user_id": event.userId
      };

      try {
        String url = '${ApiConst.assetStatusChange}/${event.assetId}/status';
        print(url);
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
            Uri.parse(url),
            ApiBaseHelpers.headers(),
            queryParameters
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(ChangeAssetStatusErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(ChangeAssetStatusErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(ChangeAssetStatusErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(ChangeAssetStatusErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(ChangeAssetStatusErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(ChangeAssetStatusErrorState(errorMessage : error));
            }
            else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(ChangeAssetStatusDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(ChangeAssetStatusErrorState(errorMessage: "$e"));
      }
    });


    on<OnUpdateAssetEvent>((event, emit) async {
      emit(UpdateAssetLoadingState());
      Map<String, dynamic> queryParameters = {
        "title": event.title,
        "asset_category_id": event.assetCategoryId,
        "vendor_id": event.vendorId,
        "registration_date": event.purChaseDate,
        "small_description": event.smallDescription,
        "description": event.longDescription,
        "expiry_months": event.expiryMonths,
        "warranty_months": event.warrantyMonths,
        "purchase_cost": event.purchaseCost,
        "model_number": event.modelNumber,
        "manufacturer": event.manufacturer,
      };


      try {
        String url = '${ApiConst.updateAsset}/${event.assetId}';
        print(url);
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
            Uri.parse(url),
            ApiBaseHelpers.headers(),
            queryParameters
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(UpdateAssetErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(UpdateAssetErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(UpdateAssetErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(UpdateAssetErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(UpdateAssetErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(UpdateAssetErrorState(errorMessage : error));
            }
            else {

              AssetListData assetListData = AssetListData.fromJson(right['data']);
              /// Updating data on current list index item
              int itemIndex = activeAssetList.indexWhere((item)=> item.id == assetListData.id);

              if(itemIndex!=-1){
                activeAssetList[itemIndex] = assetListData;
              }
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(UpdateAssetDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(UpdateAssetErrorState(errorMessage: "$e"));
      }
    });


    on<OnAssetMemberListEvent>((event, emit) async {
      emit(AssetMemberListLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.assetsMemberList),
          ApiBaseHelpers.headers(),
        );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AssetMemberListErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(AssetMemberListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AssetMemberListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AssetMemberListErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AssetMemberListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(AssetMemberListErrorState(errorMessage: "${right['error']}"));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';
            assetsMemberListData= AssetsMemberListModel.fromJson(right).data ?? [];

            emit(AssetMemberListDoneState(message: message));
          }
        });
      } catch (e) {
        emit(AssetMemberListErrorState(errorMessage: '$e'));
      }
    });


    // on<OnGetAssetListEvent>((event, emit) async {
    //   emit(GetAssetListLoadingState());
    //
    //   try {
    //     // Build query parameters based on filters
    //     Map<String, String> queryParams = {};
    //
    //     if (event.assetCategoryId != null) {
    //       queryParams['asset_category_id'] = event.assetCategoryId.toString();
    //     }
    //     if (event.vendorId != null) {
    //       queryParams['vendor_id'] = event.vendorId.toString();
    //     }
    //     if (event.search != null && event.search!.isNotEmpty) {
    //       queryParams['search'] = event.search!;
    //     }
    //
    //     // Build request URL with filters
    //     final uri = Uri.https(
    //       ApiConst.isProduction
    //           ? ApiConst.baseUrlNonProdHttpC
    //           : ApiConst.baseUrlNonHttpC,
    //       "api/assets",
    //       queryParams,
    //     );
    //
    //     // Call API
    //     Either<Failure, dynamic> response = await ApiBaseHelpers().get(
    //       uri,
    //       ApiBaseHelpers.headers(extraHeaders: {
    //         'X-Company-ID': 'YOUR_COMPANY_ID_HERE', // add dynamic company ID if needed
    //       }),
    //     );
    //
    //     // Handle response
    //     response.fold((left) {
    //       if (left is UnauthorizedFailure) {
    //         emit(GetAssetListErrorState(errorMessage: 'Unauthorized Failure'));
    //       } else if (left is NoDataFailure) {
    //         emit(GetAssetListErrorState(
    //           errorMessage: jsonDecode(left.errorMessage)['error'],
    //         ));
    //       } else if (left is ServerFailure) {
    //         emit(GetAssetListErrorState(errorMessage: 'Server Failure'));
    //       } else if (left is InvalidDataUnableToProcessFailure) {
    //         emit(GetAssetListErrorState(
    //           errorMessage: jsonDecode(left.errorMessage)['error'],
    //         ));
    //       } else {
    //         emit(GetAssetListErrorState(errorMessage: 'Something went wrong'));
    //       }
    //     }, (right) {
    //       if (right != null && right.containsKey('error')) {
    //         emit(GetAssetListErrorState(errorMessage: "${right['error']}"));
    //       } else {
    //         final message = right['message'] ?? 'Asset list fetched successfully.';
    //         activeAssetList = AssetListModel.fromJson(right).data ?? [];
    //         emit(GetAssetListDoneState(message: message));
    //       }
    //     });
    //   } catch (e) {
    //     emit(GetAssetListErrorState(errorMessage: '$e'));
    //   }
    // });

    on<OnCheckBarcodeEvent>((event, emit) async {

      Map<String, String> queryParams = {
        'barcode': event.barcode.toString()

      };
      emit(CheckBarcodeLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.https(ApiConst.isProduction ? ApiConst.baseUrlNonProdHttpC : ApiConst.baseUrlNonHttpC, "/api/barcode/check",
                queryParams),
            ApiBaseHelpers.headers());

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(CheckBarcodeErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(CheckBarcodeErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(CheckBarcodeErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(CheckBarcodeErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(CheckBarcodeErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            checkBarcodeData = null;
            String error = "${right['error']}";
            emit(CheckBarcodeErrorState(errorMessage: error));
          } else {
            checkBarcodeData = CheckBarcodeModel.fromJson(right).data;
            final message = right['message'] ?? 'Operation completed successfully.';
            emit(CheckBarcodeDoneState(
                message: message, barcode:
               checkBarcodeData?.barcode ?? '',
                isAssign:checkBarcodeData?.data?.isAssigned ?? false ,
                assetId: checkBarcodeData?.data?.productId


            ));
          }
        });
      } catch (e) {
        emit(CheckBarcodeErrorState(errorMessage: '$e'));
      }
    });


    on<OnGetUnassignedBarcodesAssetsList>((event, emit) async {
      emit(GetUnassignedBarcodesAssetsLoadingState());


      if (event.isClearAssetList==true){
        unassignedBarcodesAssetsList.clear();

      }
      if (event.nextPageKeyForAssignBarcode == 1) {
        // Clear only on first page
        activeAssetList.clear();

      }


      Map<String, String> queryParams = {
        if (event.assetCategoryId != null && event.assetCategoryId.toString().isNotEmpty)
          "asset_category_id": event.assetCategoryId.toString(),
        if (event.vendorId != null && event.vendorId.toString().isNotEmpty)
          "vendor_id": event.vendorId.toString(),
        if (event.search != null && event.search.toString().isNotEmpty)
          "search": event.search.toString(),
        if (event.status != null && event.status.toString().isNotEmpty)
          "status": event.status.toString(),
          "page": event.nextPageKeyForAssignBarcode.toString()
      };
      try {
        final uri = queryParams.isNotEmpty
            ? Uri.https(
          ApiConst.isProduction
              ? ApiConst.baseUrlNonProdHttpC
              : ApiConst.baseUrlNonHttpC,
          "api/barcodes/unassigned-assets",
          queryParams,
        )
            : Uri.https(
          ApiConst.isProduction
              ? ApiConst.baseUrlNonProdHttpC
              : ApiConst.baseUrlNonHttpC,
          "api/barcodes/unassigned-assets",
        );

        // ✅ Print full URL with parameters
        print("🔗 Asset List API URL: ${uri.toString()}");

        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          uri,
          ApiBaseHelpers.headers(),
        );
        // Either<Failure, dynamic> response = await ApiBaseHelpers().get(
        //   Uri.parse(ApiConst.unassignedBarcodesAssets), // 👈 Your API endpoint constant
        //   ApiBaseHelpers.headers(),
        //
        // );

        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetUnassignedBarcodesAssetsErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetUnassignedBarcodesAssetsErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else if (left is ServerFailure) {
            emit(GetUnassignedBarcodesAssetsErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetUnassignedBarcodesAssetsErrorState(
              errorMessage: jsonDecode(left.errorMessage)['error'],
            ));
          } else {
            emit(GetUnassignedBarcodesAssetsErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(GetUnassignedBarcodesAssetsErrorState(errorMessage: "${right['error']}"));
          } else {

            nextPageUrlForAssignBarcodeScreen = AssetListModel.fromJson(right).pagination?.nextPageApiUrl ?? '';
            currentPageForAssignBarcodeScreen = AssetListModel.fromJson(right).pagination?.currentPage ?? 1;

            final newItems = AssetListModel.fromJson(right).data ?? [];

            for (final item in newItems) {
              if (!unassignedBarcodesAssetsList.any((existing) => existing.id == item.id)) {
                unassignedBarcodesAssetsList.add(item);
              }
            }
            final message = right['message'] ?? 'Operation completed successfully.';
            // unassignedBarcodesAssetsList = AssetListModel.fromJson(right).data ?? [];
            emit(GetUnassignedBarcodesAssetsDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetUnassignedBarcodesAssetsErrorState(errorMessage: '$e'));
      }
    });



    on<OnAssignBarcodeToAsset>((event, emit) async {
      emit(AssignBarcodeToAssetLoadingState());
      Map<String, dynamic> queryParameters = {
        "barcode": event.barcode,
        "product_id": event.productId
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.assignedBarcodesToAssets),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AssignBarcodeToAssetErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(AssignBarcodeToAssetErrorState(errorMessage: left.errorMessage));
          } else if (left is ServerFailure) {
            emit(AssignBarcodeToAssetErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AssignBarcodeToAssetErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AssignBarcodeToAssetErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            emit(AssignBarcodeToAssetErrorState(errorMessage: "${right['error']}"));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';




            emit(AssignBarcodeToAssetDoneState(message: message));
          }
        });
      } catch (e) {
        emit(AssignBarcodeToAssetErrorState(errorMessage: "$e"));
      }
    });




    on<OnAssetConfirmationEvent>((event, emit) async {
      emit(AssetConfirmationLoadingState());
      Map<String, dynamic> queryParameters = {
        "status": event.status,
        "is_good_condition": event.isGoodCondition?.toLowerCase()
      };

      try {
        String url = '${ApiConst.assetConfirmation}/${event.assetId}/status/assinee';
        print(url);
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
            Uri.parse(url),
            ApiBaseHelpers.headers(),
            queryParameters
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(AssetConfirmationErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(AssetConfirmationErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(AssetConfirmationErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(AssetConfirmationErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(AssetConfirmationErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(AssetConfirmationErrorState(errorMessage : error));
            }
            else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(AssetConfirmationDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(AssetConfirmationErrorState(errorMessage: "$e"));
      }
    });



    on<OnSendAssetAcceptReminderEvent>((event, emit) async {
      emit(SendAssetAcceptReminderLoadingState());
      Map<String, dynamic> queryParameters = {
        "id": event.assetId,
      };
      try {
        String url = '${ApiConst.assetAcceptRemainder}/${event.assetId}/send-reminder';
        print(url);
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
            Uri.parse(url),
            ApiBaseHelpers.headers(),
           body:  queryParameters
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(SendAssetAcceptReminderErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(SendAssetAcceptReminderErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(SendAssetAcceptReminderErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(SendAssetAcceptReminderErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(SendAssetAcceptReminderErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(SendAssetAcceptReminderErrorState(errorMessage : error));
            }
            else {
              final message =
                  right['message'] ?? 'Operation completed successfully.';
              emit(SendAssetAcceptReminderDoneState(message: message));
            }
          },
        );
      } catch (e) {
        emit(SendAssetAcceptReminderErrorState(errorMessage: "$e"));
      }
    });

    on<OnGetAssetHistoryEvent>((event, emit) async {


      Map<String, dynamic> queryParameters = {
      };

      try {
        // emit(GetAssetHistoryLoadingState());

        String url = '${ApiConst.assetHistory}/${event.assetId}/history';
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          // body:  queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GetAssetHistoryErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GetAssetHistoryErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetAssetHistoryErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetAssetHistoryErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetAssetHistoryErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GetAssetHistoryErrorState(errorMessage: error));
          } else {
            final message = right['message'] ?? 'Operation completed successfully.';

            assetHistoryData = AssetHistoryModel.fromJson(right).data ?? [];

            emit(GetAssetHistoryDoneState(message: message));
          }
        });
      } catch (e) {
        emit(GetAssetHistoryErrorState(errorMessage: '$e'));
      }
    });


  }
}
