import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asetize/features/add_vehicle_for_manager/models/house_detail_model.dart';

import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../models/add_vehicle_for_manager_model.dart';
import '../models/vehicle_list_model.dart';
import 'add_vehicle_manager_event.dart';
import 'add_vehicle_manager_state.dart';


class AddVehicleManagerBloc extends Bloc<AddVehicleManagerEvent, AddVehicleManagerState> {

  AddVehicleForManagerData? addVehicleManagerData;
  HouseDetailData? memberListData;
  HouseDetailData? myFamilyListData;
  List<VehicleListData> vehicleListData  = [];
  List<Vehicles> vehicles = [];
  List<Members> members = [];

  AddVehicleManagerBloc() : super(AddVehicleManagerInitialState()) {

    on<ResetBlockListEvent>((event, emit) async {

      addVehicleManagerData= null;
        addVehicleManagerData= null;
        vehicles.clear();
        vehicleListData.clear();
        members.clear();
        memberListData=null;
      emit(AddVehicleManagerInitialState());
    });

    on<OnReLoadUiEvent>((event, emit) async {
      emit(ReloadUiDoneState());
    });




    on<OnGetBlockListEvent>((event, emit) async {
      emit (AddVehicleManagerLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.parse(ApiConst.addVehicleForManager),
            ApiBaseHelpers.headers());
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(AddVehicleManagerErrorState(
                errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(AddVehicleManagerErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AddVehicleManagerErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddVehicleManagerErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddVehicleManagerErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {

          addVehicleManagerData = AddVehicleForManager.fromJson(right).data ;
          emit(AddVehicleManagerDoneState());
        });
      } catch (e) {
        emit(AddVehicleManagerErrorState(errorMessage: '$e'));
      }
    });

    on<OnGetHouseDetailEvent>((event, emit) async {
      emit(AddVehicleManagerLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.getHouseDetail),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        await response.fold((left) async { // Added async and await here
          if (left is UnauthorizedFailure) {
            emit(AddVehicleManagerErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(AddVehicleManagerErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AddVehicleManagerErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddVehicleManagerErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddVehicleManagerErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {

          memberListData = MembersListModel.fromJson(right).data ;
          vehicles =  MembersListModel.fromJson(right).data?.vehicles ?? [];
          members =  MembersListModel.fromJson(right).data?.members ?? [];
          emit(OnGetHouseDetailDoneState());
        });

      } catch (e) {
        emit(AddVehicleManagerErrorState(errorMessage: '$e'));
      }
    });



    on<OnGetMyFamilyList>((event, emit) async {
      emit(AddVehicleManagerLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.getHouseDetail),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        await response.fold((left) async { // Added async and await here
          if (left is UnauthorizedFailure) {
            emit(AddVehicleManagerErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(AddVehicleManagerErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AddVehicleManagerErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddVehicleManagerErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddVehicleManagerErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {

          myFamilyListData = MembersListModel.fromJson(right).data ;
          vehicles =  MembersListModel.fromJson(right).data?.vehicles ?? [];
          members =  MembersListModel.fromJson(right).data?.members ?? [];

          emit(OnGetHouseDetailDoneState());
        });

      } catch (e) {
        emit(AddVehicleManagerErrorState(errorMessage: '$e'));
      }
    });



    on<OnSetPrimaryMemberEvent>((event, emit) async {
      emit(SetPrimaryMemberLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_member_id": event.houseMemberId,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.setPrimaryMember),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        await response.fold((left) async { // Added async and await here
          if (left is UnauthorizedFailure) {
            emit(SetPrimaryMemberErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(SetPrimaryMemberErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(SetPrimaryMemberErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SetPrimaryMemberErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(SetPrimaryMemberErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {

          // memberListData = MembersListModel.fromJson(right).data ;
          // vehicles =  MembersListModel.fromJson(right).data?.vehicles ?? [];
          // members =  MembersListModel.fromJson(right).data?.members ?? [];
          emit(OnSetPrimaryMemberDoneState());
        });

      } catch (e) {
        emit(SetPrimaryMemberErrorState(errorMessage: '$e'));
      }
    });



    on<OnEnableDisableContactEvent>((event, emit) async {
      emit(EnableDisableContactLoadingState());

      Map<String, dynamic> queryParameters = {
        "house_member_id": event.houseMemberId,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.enableDisableContact),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        await response.fold((left) async { // Added async and await here
          if (left is UnauthorizedFailure) {
            emit(EnableDisableContactErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(EnableDisableContactErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(EnableDisableContactErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(EnableDisableContactErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(EnableDisableContactErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          if (right.containsKey("error")) {
            emit(EnableDisableContactErrorState(errorMessage:right["error"]));
          } else {
            /// Setting
            if(event.itsMe! == true){
              BlocProvider.of<UserProfileBloc>(MainAppBloc.getDashboardContext).selfContactDisplayStatus = !event.isDisableContact;
            }

            emit(EnableDisableContactDoneState(isDisableContact: event.isDisableContact));
          }
        });

      } catch (e) {
        emit(EnableDisableContactErrorState(errorMessage: '$e'));
      }
    });


    on<OnAddMemberByManagerEvent>((event, emit) async {
      emit(AddVehicleManagerLoadingState());
      Map<String, dynamic> queryParameters = {
        "house_id": event.houseId,
        "email":event.email,
        "first_name":event.firstName,
        "gender":event.gender,
        "relationship":event.relationship,
        "last_name":event.lastName,
        "phone":event.phone,
        "country_code":event.countryCode,
        "role":event.role,
        "is_primery_memeber":event.isPrimaryMember,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.addMemberByManager),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        await response.fold((left) async { // Added async and await here
          if (left is UnauthorizedFailure) {
            emit(AddMemberByManagerErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(AddMemberByManagerErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(AddMemberByManagerErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(AddMemberByManagerErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(AddMemberByManagerErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {

          // memberListData = MembersListModel.fromJson(right).data ;
          emit(AddMemberByManagerDoneState());


        });

      } catch (e) {
        emit(AddMemberByManagerErrorState(errorMessage: '$e'));
      }
    });

    on<VerifyPhoneNumberEvent>((event, emit) async {
      emit(VerifyPhoneNumberLoadingState());
      Map<String, dynamic> queryParameters = {
        "phone":event.phoneNumber,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.verifyPhoneNumber),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(VerifyPhoneNumberDoneState());
            // emit(VerifyPhoneNumberErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(VerifyPhoneNumberErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(VerifyPhoneNumberErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(VerifyPhoneNumberErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(VerifyPhoneNumberErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          try {
            // emit(VerifyPhoneNumberDoneState(firstName:right['data']['first_name'],lastName:right['data']['last_name']));
            final data = right['data'];
            if (data is Map && data.containsKey('first_name') && data.containsKey('last_name')) {
              emit(VerifyPhoneNumberDoneState(
                firstName: data['first_name'],
                lastName: data['last_name'],
              ));
            } else {
              emit(VerifyPhoneNumberDoneState(

              ));
            }
          } catch (e) {
            print(e);
          }
        });

      } catch (e) {
        emit(VerifyPhoneNumberErrorState(errorMessage: '$e'));
      }
    });

    on<GetAllVehicleListEvent>((event, emit) async {
      emit(AddVehicleManagerLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.allVehicleList),
          ApiBaseHelpers.headers(),
        );

        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(GetAllVehicleListErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(GetAllVehicleListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GetAllVehicleListErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GetAllVehicleListErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GetAllVehicleListErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          vehicleListData = VehicleListModel.fromJson(right).data ?? [];
          emit(GetAllVehicleListDoneState());
        });

      } catch (e) {
        emit(GetAllVehicleListErrorState(errorMessage: '$e'));
      }
    });


    on<DeleteMemberEvent>((event,emit) async {
      Map<String, dynamic> body = {
        "house_member_id":event.houseMemberId,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.deleteMember),
          ApiBaseHelpers.headers(),
          body: body,
        );
        response.fold(
              (left) {
            if (left is UnauthorizedFailure) {
              emit(DeleteMemberErrorState(errorMessage :left.errorMessage ?? ""));
            } else if (left is NoDataFailure) {
              emit(DeleteMemberErrorState(errorMessage : left.errorMessage));
            } else if (left is ServerFailure) {
              emit(DeleteMemberErrorState(errorMessage : 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(DeleteMemberErrorState(errorMessage :jsonDecode(left.errorMessage)['error']));
            } else {
              emit(DeleteMemberErrorState(errorMessage : 'Something went wrong'));
            }
          },
              (right) {

                if (right.containsKey("error")) {
                  emit(DeleteMemberErrorState(errorMessage:right["error"]));
                } else {
                  emit(DeleteMemberDoneState());
                }


          },
        );
      }
      catch (e) {
        print(e);
      }
    });

  }
}
