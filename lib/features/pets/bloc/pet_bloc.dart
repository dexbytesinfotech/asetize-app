import 'package:asetize/features/pets/bloc/pet_event.dart';
import 'package:asetize/features/pets/bloc/pet_state.dart';
import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../models/pet_data_model.dart';
import '../models/pet_model.dart';
import 'package:http/http.dart' as http;


class PetBloc extends Bloc<PetEvent, PetState> {
  List<PetData> petList = [];
  PetBloc() : super(PetInitialState()) {

    on<OnGetListOfPetsEvent>((event, emit) async {
      emit(PetLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers()
            .get(Uri.parse(ApiConst.petApi), ApiBaseHelpers.headers());

        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(PetErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(PetErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(PetErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(PetErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(PetErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          petList = PetModel.fromJson(right).data ?? [];
          print(petList);
          emit(GetPetsListDoneState());
        });
      } catch (e) {
        emit(PetErrorState(errorMessage: '$e'));
      }
    });

    on<OnStorePetInformationEvent>((event, emit) async {
      String filePath = "";
      emit(StorePetInformationLoadingState());
      // Check if the photo is not empty or null
      if (event.photo?.isNotEmpty == true) {
        Map<String, dynamic> queryParameters = {
          "collection_name": '',
          "file_path": event.photo,
        };


        try {
          Either<Failure, dynamic> response = await postUploadMedia(
            queryParameters: queryParameters,
            headers: ApiBaseHelpers.headersMultipart(),
            apiUrl: ApiConst.updateProfilePhotos,
          );

          bool uploadError = false;

          response.fold((left) {
            // Handle Failure Cases
            if (left is UnauthorizedFailure) {
              emit(StorePetInformationErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(StorePetInformationErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(StorePetInformationErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(StorePetInformationErrorState(errorMessage: left.errorMessage));
            } else {
              emit(StorePetInformationErrorState(errorMessage: 'Something went wrong'));
            }
            uploadError = true;
          }, (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              print(error);
              emit(StorePetInformationErrorState(errorMessage: error));
              uploadError = true;
            } else {
              filePath = UploadMediaModel.fromJson(right).data?.fileName ?? " ";
              emit(StoreMediaDoneState());
            }
          });

          // Return if any error occurs while uploading media
          if (uploadError) {
            return;
          }

        } catch (e) {
          debugPrint('$e');
          return; // Exit if any exception occurs
        }
      }

      // Prepare query parameters for storing pet information
      Map<String, dynamic> queryParameters = {
        "name": event.name,
        "dob": event.dob,
        "type": event.type,
        "breed": event.breed,
        "gender": event.gender,
        "photo": filePath, // Updated with uploaded image path
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.petApi),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );

        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(StorePetInformationErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(StorePetInformationErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(StorePetInformationErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(StorePetInformationErrorState(
                  errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(StorePetInformationErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";

              emit(StorePetInformationErrorState(errorMessage: error));
            } else {
              int id = right['data']['id'];
              emit(StorePetInformationDoneState(petId: id));
            }
          },
        );
      } catch (e) {
        emit(StorePetInformationErrorState(errorMessage: "$e"));
      }
    });

    on<OnStorePetVaccinationDetailEvent>((event, emit) async {
      emit(StorePetVaccinationDetailLoadingState());
      String filePath = "";
      if (event.document?.isNotEmpty == true && event.document != null  && !event.document!.startsWith("http")) {
        Map<String, dynamic> queryParameters = {
          "collection_name": 'document',
          "file_path": event.document,
        };
        try {
          Either<Failure, dynamic> response = await postUploadMedia(
            queryParameters: queryParameters,
            headers: ApiBaseHelpers.headersMultipart(),
            apiUrl: ApiConst.updateProfilePhotos,
          );
          bool uploadError = false;
          response.fold((left) {
            if (left is UnauthorizedFailure) {
              emit(StorePetVaccinationDetailErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(StorePetVaccinationDetailErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(StorePetVaccinationDetailErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(StorePetVaccinationDetailErrorState(errorMessage: left.errorMessage));
            } else {
              emit(StorePetVaccinationDetailErrorState(errorMessage: 'Something went wrong'));
            }
             uploadError = true;
          }, (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              print(error);
              emit(StorePetVaccinationDetailErrorState(errorMessage: error));
              uploadError = true;
            } else {
              filePath = UploadMediaModel.fromJson(right).data?.fileName ?? " ";
              emit(StoreMediaDoneState());
            }
          });
          if (uploadError) {
            return;
          }
        } catch (e) {
          debugPrint('$e');
        }
      }
      else{
        filePath = event.documentFileName??"";
      }

      Map<String, dynamic> queryParameters = {
        "vaccinated": event.vaccinated,
        "vaccination_date": event.vaccinationDate,
        "next_vaccination_date": event.nextVaccinationDate,
        "document": filePath,
        "remind_me": event.remindMe,
      };
      // int id =event.petId;
      try{
        String apiUrl = "${ApiConst.petApi}/${event.petId}/vaccination";
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(apiUrl),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(StorePetVaccinationDetailErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(StorePetVaccinationDetailErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(StorePetVaccinationDetailErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(StorePetVaccinationDetailErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(StorePetVaccinationDetailErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
                if (right != null && right.containsKey('error')) {
                  String error = "${right['error']}";
                  emit(StorePetVaccinationDetailErrorState(errorMessage : error));
                }
                // if (right['data'] != null && right['data'].containsKey('error')) {
                //   String error = "${right['data']['error']}";
                //   emit(StorePetVaccinationDetailErrorState(errorMessage:error));
                // }
               else{
                  emit(StorePetVaccinationDetailDoneState());
                }

          },
        );
      }catch(e)
      {
        emit(StorePetVaccinationDetailErrorState(errorMessage: "$e"));
      }
    });

    on<OnDeletePetDetailEvent>((event, emit) async {
      emit(DeletePetDetailLoadingState());

      try{
        String apiUrl = "${ApiConst.petApi}/${event.petId}";
        Either<Failure, dynamic> response = await ApiBaseHelpers().delete(
          Uri.parse(apiUrl),
          ApiBaseHelpers.deleteHeaders(),
          {}
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(DeletePetDetailErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(DeletePetDetailErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(DeletePetDetailErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(DeletePetDetailErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(DeletePetDetailErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
            emit(DeletePetDetailDoneState());
          },
        );
      }catch(e)
      {
        emit(DeletePetDetailErrorState(errorMessage: "$e"));
      }
    });

    on<OnUpdatePetDetailEvent>((event, emit) async {
      emit(StorePetInformationLoadingState());

      String filePath = "";
      if (event.photo != null && event.photo?.isNotEmpty == true && !event.photo!.startsWith("http")) {
        Map<String, dynamic> queryParameters = {
          "collection_name": '',
          "file_path": event.photo,
        };
        emit(StorePetInformationLoadingState());
        try {
          Either<Failure, dynamic> response = await postUploadMedia(
            queryParameters: queryParameters,
            headers: ApiBaseHelpers.headersMultipart(),
            apiUrl: ApiConst.updateProfilePhotos,
          );
          bool uploadError = false;
          response.fold((left) {
            if (left is UnauthorizedFailure) {
              emit(StorePetInformationErrorState(errorMessage: 'Unauthorized Failure'));
            } else if (left is NoDataFailure) {
              emit(StorePetInformationErrorState(errorMessage: left.errorMessage));
            } else if (left is ServerFailure) {
              emit(StorePetInformationErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(StorePetInformationErrorState(errorMessage: left.errorMessage));
            } else {
              emit(StorePetInformationErrorState(errorMessage: 'Something went wrong'));
            }
            uploadError = true; // Mark error to prevent further API call
          }, (right) {
            if (right != null && right.containsKey('error')) {
              String error = "${right['error']}";
              emit(StorePetInformationErrorState(errorMessage : error));
              uploadError = true; // Mark error to prevent further API call
            }else{
              filePath = UploadMediaModel.fromJson(right).data?.fileName ?? " ";
              emit(StoreMediaDoneState());
            }
          });

          // Return if any error occurs while uploading media
          if (uploadError) {
            return;
          }
        } catch (e) {
          debugPrint('$e');
        }
      }
      else{
        filePath = event.fileName??"";
      }


      Map<String, dynamic> queryParameters = {
        "name": event.name,
        "dob": event.dob,
        "type": event.type,
        "breed": event.breed,
        "gender": event.gender,
        "photo": filePath,
      };
      try{
        String url = '${ApiConst.petApi}/${event.petId.toString()}';
        Either<Failure, dynamic> response = await ApiBaseHelpers().put(
          Uri.parse(url),
          ApiBaseHelpers.headers(),
          queryParameters,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(StorePetInformationErrorState(errorMessage:left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(StorePetInformationErrorState(errorMessage:left.errorMessage));
            } else if (left is ServerFailure) {
              emit(StorePetInformationErrorState(errorMessage:'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(StorePetInformationErrorState(errorMessage:jsonDecode(left.errorMessage)['error']));
            } else {
              emit(StorePetInformationErrorState(errorMessage:'Something went wrong'));
            }
          },
              (right) {
                if (right != null && right.containsKey('error')) {
                  String error = "${right['error']}";
                  emit(StorePetInformationErrorState(errorMessage : error));
                }
                else {
                  emit(UpdatePetDetailDoneState());
                }
          },
        );
      }catch(e)
      {
        emit(StorePetInformationErrorState(errorMessage: "$e"));
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

