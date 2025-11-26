import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asetize/features/new_sign_up/models/guest_search_by_model.dart';

import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../models/guest_otp_resend_model.dart';
import '../models/guest_otp_verify_model.dart';
import '../models/guest_profile_model.dart';
import '../models/guest_search_by_model.dart';
import '../models/guest_signup_model.dart';
import '../models/guest_update_profile_model.dart';
import '../models/terms_and_conditions_model.dart';
import 'new_signup_event.dart';
import 'new_signup_state.dart';

class NewSignupBloc extends Bloc<NewSignupEvent, NewSignupState> {

  List<TermsAndConditionData> termsAndCondition = [];
  List<GuestSearchByData> guestSearchByData = [];
  GuestOtpResendData? guestOtpResendData;
  GuestOtpVerifyData? guestOtpVerifyData;
  UserResponseModel? userResponseModel;
  GuestUpdateProfileData? guestUpdateProfileData;
  ///
   List<Blocks> blocksData = [];
  List<String> blockName = [];
  List<String> houseNumber = [];
   List<Houses2>? housesData;
  NewSignupBloc() : super(SignupInitialState()) {
    // Handle OnSignupEvent

    on<ResetListEvent>((event,emit){
      blocksData = [];
       blockName = [];
       houseNumber = [];
       emit(ResetListEventDoneState());
    });

    on<OnSignupEvent>((event, emit) async {
      Map<String, dynamic> queryParameters = {
        "community_name": event.communityName,
        "registration_number": event.registrationNumber,
        "property_type": event.propertyType,
        "phone": event.phone,
        "owner_name": event.ownerName,
        "owner_email": event.ownerEmail,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.signUpApi),
          ApiBaseHelpers.headers(),
          body: queryParameters,
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(SignupErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(SignupErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(SignupErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(SignupErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(SignupErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          emit(SignupDoneState());
        });
      } catch (e) {
        emit(SignupErrorState(errorMessage: '$e'));
      }
    });

    // Handle OnTermsAndConditionEvent
    on<OnTermsAndConditionEvent>((event, emit) async {
      emit (SignupLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.parse(ApiConst.termsAndCondition + event.slug,),
            ApiBaseHelpers.headers(),);
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(TermsAndConditionErrorState(
                errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(TermsAndConditionErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(TermsAndConditionErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(TermsAndConditionErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(TermsAndConditionErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          termsAndCondition = TermsAndConditionModel.fromJson(right).data ?? [];
          emit(TermsAndConditionDoneState());
        });
      } catch (e) {
        emit(TermsAndConditionErrorState(errorMessage: '$e'));
      }
    });


    on<OnGuestLoginByEmail>((event, emit) async {
      emit(SignupLoadingState());

      Map<String, dynamic> queryParameters = {
        "email": event.guestEmail,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.guestEmailLogin),
          ApiBaseHelpers.guestHeaders(),
          body: queryParameters,
        );

        await response.fold((left) async { // Added async and await here
          if (left is UnauthorizedFailure) {
            emit(GuestSignupErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(GuestSignupErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GuestSignupErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GuestSignupErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GuestSignupErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          try {
            GuestSignupModel guestSignupModel = GuestSignupModel.fromJson(right);
            String? token;
            if (guestSignupModel.data != null) {
              token = guestSignupModel.data?.token;
              if (token != null) {
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // await prefs.setString('guest_token', token);
                // ApiBaseHelpers.saveTokenForProject = token.toString();
                // print( 'sghdfggfghhfghj saveTokenForCompleteProfile ${ApiBaseHelpers.saveTokenForProject}');
                print('Token saved successfully: $token');
              }
            }
            emit(GuestSignupDoneState(token: token!));
          } catch (e) {
            emit(GuestSignupErrorState(errorMessage: 'Error parsing response: $e'));
          }
        });

      } catch (e) {
        emit(GuestSignupErrorState(errorMessage: '$e'));
      }
    });

    on<OnVerifyOtpEvent>((event, emit) async {
      emit(SignupLoadingState());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      // await projectUtil.deviceInfo();
      // String deviceToken = await PrefUtils().readStr(WorkplaceNotificationConst.deviceTokenC);
      // String deviceId = await PrefUtils().readStr(WorkplaceNotificationConst.deviceIdC);
      // String deviceName = await PrefUtils().readStr(WorkplaceNotificationConst.deviceNameC);
      // String deviceVersion = await PrefUtils().readStr(WorkplaceNotificationConst.deviceOsVersionC);
      // String deviceModel = await PrefUtils().readStr(WorkplaceNotificationConst.deviceModelC);
      // String appVersion = await PrefUtils().readStr(WorkplaceNotificationConst.appVersionVersionC);
      // String deviceTypeName = Platform.isAndroid ? "android" : "ios";

      await projectUtil.deviceInfo();
      String fcmToken = await PrefUtils().readStr(WorkplaceNotificationConst.deviceTokenC);
      String deviceId = await PrefUtils().readStr(WorkplaceNotificationConst.deviceIdC);
      String deviceName = await PrefUtils().readStr(WorkplaceNotificationConst.deviceNameC);
      String deviceVersion = await PrefUtils().readStr(WorkplaceNotificationConst.deviceOsVersionC);
      String deviceType = Platform.isAndroid ? "android" : "ios";



      UserProfileBloc? newSignupBloc;
      if(event.mContext!=null) {
        newSignupBloc = BlocProvider.of<UserProfileBloc>(event.mContext!);
      }
      Map<String, dynamic> queryParameters = {
        "otp": event.otp,
        "deviceId": deviceId,
        "deviceName": deviceName,
        "fcmToken": fcmToken,
        "deviceVersion": deviceVersion,
        "deviceType": deviceType,
      };
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.guestOtpVerify),
          ApiBaseHelpers.guestOtpVerifyHeaders(token:event.token),
          body: queryParameters,
        );

        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(GuestOtpVeifyErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(GuestOtpVeifyErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GuestOtpVeifyErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GuestOtpVeifyErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GuestOtpVeifyErrorState(errorMessage: 'Something went wrong'));
          }
          
        }, (right) async {

          if (right.containsKey("error")) {
            emit(GuestOtpVeifyErrorState(errorMessage: right["error"]));
          }

          guestOtpVerifyData = GuestOtpVerifyModel.fromJson(right).data;
          bool isCompleteProfile = guestOtpVerifyData?.isCompleteProfile ?? false;
          String tokenForCompleteProfile = guestOtpVerifyData?.token ?? '';
          bool isCompanyIdSaved = false;

          if(guestOtpVerifyData!.companies != null && guestOtpVerifyData!.companies!.isNotEmpty && guestOtpVerifyData!.companies!.first.id!=null && guestOtpVerifyData!.companies!.first.id!>0){

            await prefs.setString('token_for_complete_profile', tokenForCompleteProfile);
            WorkplaceDataSourcesImpl.token = tokenForCompleteProfile;
            ApiBaseHelpers.setAccessToken = tokenForCompleteProfile;

            /// Call Profile API
            Either<Failure, dynamic> response = await ApiBaseHelpers().get(
              Uri.parse(ApiConst.userProfile),
              tokenForCompleteProfile.isEmpty?ApiBaseHelpers.guestProfileUpdateHeaders():ApiBaseHelpers.guestProfileUpdateHeaders(accessTokenStr: tokenForCompleteProfile),
            );

            await response.fold((left) async {
              if (left is UnauthorizedFailure) {
                emit(GuestOtpVeifyErrorState(errorMessage: 'Unauthorized Failure'));
              } else if (left is NoDataFailure) {
                emit(GuestOtpVeifyErrorState(
                    errorMessage: jsonDecode(left.errorMessage)['error']));
              } else if (left is ServerFailure) {
                emit(GuestOtpVeifyErrorState(errorMessage: 'Server Failure'));
              } else if (left is InvalidDataUnableToProcessFailure) {
                emit(GuestOtpVeifyErrorState(
                    errorMessage: jsonDecode(left.errorMessage)['error']));
              }
              else if (left is NetworkFailure) {
                emit(GuestOtpVeifyErrorState(errorMessage: 'NetworkFailure'));
              } else {
                emit(GuestOtpVeifyErrorState(errorMessage: 'Something went wrong'));
              }
            },
                    (right) async {
                  UserProfileBloc? newSignupBloc;
                  if (event.mContext != null) {
                    newSignupBloc = BlocProvider.of<UserProfileBloc>(event.mContext!);
                  }
                  userResponseModel =  UserResponseModel.fromJson(right);
                  if (userResponseModel == null || userResponseModel!.user == null) {
                    emit(GuestOtpVeifyErrorState(errorMessage: 'Profile Not Found'));
                    return;
                  }
                  bool isCompleteProfile = userResponseModel!.user!.name!=null && userResponseModel!.user!.name!.isNotEmpty?true:false;
                  String? newSelectedCompanyIdStr;
                  try {
                    if (userResponseModel!.user!.company != null) {
                      if (newSignupBloc != null) {
                        try
                        {
                          newSignupBloc.user = userResponseModel!.user!;
                        }
                        catch (e)
                        {
                          print(e);
                        }
                      }

                      /// Select Current unit
                      if (newSignupBloc!.user.houses != null &&
                          newSignupBloc.user.houses!.isNotEmpty) {
                        int selectedUnitId = await PrefUtils().readInt(WorkplaceNotificationConst.mySelectedUnitId);
                        if(selectedUnitId>0){
                          int index  = newSignupBloc.user.houses!.indexWhere((tempHouse)=>tempHouse.id==selectedUnitId);
                          if(index!=-1){
                            Houses? mHouses = newSignupBloc.user.houses![index];
                            newSignupBloc.add(OnChangeCurrentUnitEvent(selectedUnit: mHouses));
                          }
                          else {
                            newSignupBloc.add(OnChangeCurrentUnitEvent(selectedUnit: newSignupBloc.user.houses![0]));
                          }
                        }
                        else{
                          newSignupBloc.add(OnChangeCurrentUnitEvent(selectedUnit: newSignupBloc.user.houses![0]));
                        }
                      }
                      else
                      {
                        newSignupBloc.add(const OnChangeCurrentUnitEvent(selectedUnit: null));
                      }

                      newSelectedCompanyIdStr = userResponseModel!.user!.company!.id.toString();
                      WorkplaceDataSourcesImpl.selectedCompanySaveId = newSelectedCompanyIdStr;
                      ApiBaseHelpers.selectedCompanySaveId = newSelectedCompanyIdStr;
                      await PrefUtils().saveStr(WorkplaceNotificationConst.selectedCompanyId,newSelectedCompanyIdStr);
                      isCompanyIdSaved = true;
                    }
                    else {
                      newSelectedCompanyIdStr = "";
                      WorkplaceDataSourcesImpl.selectedCompanySaveId = "";
                      ApiBaseHelpers.selectedCompanySaveId = "";
                      await PrefUtils().saveStr(WorkplaceNotificationConst.selectedCompanyId,'0');
                    }
                    emit(GuestOtpVerifyDoneState(isCompleteProfile: isCompleteProfile, isCompanyIdSaved: isCompanyIdSaved));

                  } catch (e) {
                    print(e);
                    emit(GuestOtpVeifyErrorState(errorMessage: '$e'));
                  }
                });
          }
          else{
            try {
                        if (tokenForCompleteProfile.isNotEmpty) {
                          await prefs.setString('token_for_complete_profile', tokenForCompleteProfile);
                          WorkplaceDataSourcesImpl.token = tokenForCompleteProfile;
                          ApiBaseHelpers.setAccessToken = tokenForCompleteProfile;
                          emit(GuestOtpVerifyDoneState(isCompleteProfile: isCompleteProfile, isCompanyIdSaved: isCompanyIdSaved));
                        }
                        else {
                          emit(GuestOtpVeifyErrorState(errorMessage: 'Token not found'));
                        }
                      }
                      catch (e) {
                        print(e);
                      }
          }

        });
      } catch (e) {
        // emit(GuestOtpVeifyErrorState(errorMessage: '$e'));
      }
    });



    on<OnGuestResendOtpEvent>((event, emit) async {
      emit (SignupLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.guestOtpResend),
          ApiBaseHelpers.guestOtpVerifyHeaders(token:event.token),
        );
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(GuestResendOtpErrorState(
                errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(GuestResendOtpErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GuestResendOtpErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GuestResendOtpErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GuestResendOtpErrorState(
                errorMessage: 'Something went wrong'));
          }
        }, (right) {
          // guestOtpResendData = GuestOtpResendModel.fromJson(right).data ;
          emit(GuestResendOtpDoneState());
        });
      } catch (e) {
        emit(GuestResendOtpErrorState(errorMessage: '$e'));
      }
    });


    on<OnGuestProfileUpdateEvent>((event, emit) async {
      emit(SignupLoadingState());
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> queryParameters = {
        "first_name": event.firstName,
        "last_name": event.lastName,
        "phone": event.phone,
        "email": event.guestEmail,
      };

      // try {
        // Await the API response to ensure emit is called only after completion
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.guestUpdateProfile),
          ApiBaseHelpers.guestProfileUpdateHeaders(),
          body: queryParameters,
        );

        // Handle response with await on the operations inside the fold
        await response.fold(
              (left) async {
            if (left is UnauthorizedFailure) {
              emit(GuestProfileUpdateErrorState(errorMessage: left.errorMessage!));
            } else if (left is NoDataFailure) {
              emit(GuestProfileUpdateErrorState(
                  errorMessage: jsonDecode(left.errorMessage)['error']));
            } else if (left is ServerFailure) {
              emit(GuestProfileUpdateErrorState(errorMessage: 'Server Failure'));
            } else if (left is InvalidDataUnableToProcessFailure) {
              emit(GuestProfileUpdateErrorState(
                  errorMessage: jsonDecode(left.errorMessage)['error']));
            } else {
              emit(GuestProfileUpdateErrorState(errorMessage: 'Something went wrong'));
            }
          },
              (right) async {
                if (right.containsKey("error")) {
                  emit(GuestProfileUpdateErrorState(errorMessage: right['error']));
                } else {
                  guestUpdateProfileData = GuestUpdateProfileModel.fromJson(right).data;
                  bool isCompanyIdSaved = false;
                  if(guestUpdateProfileData!.companies != null && guestUpdateProfileData!.companies!.isNotEmpty && guestUpdateProfileData!.companies!.first.id!=null && guestUpdateProfileData!.companies!.first.id!>0){
                    int selectedCompanyId = guestUpdateProfileData!.companies!.first.id!;
                    WorkplaceDataSourcesImpl.selectedCompanySaveId = selectedCompanyId.toString();
                    ApiBaseHelpers.selectedCompanySaveId = selectedCompanyId.toString();
                    isCompanyIdSaved = await prefs.setInt('selected_company_id', selectedCompanyId);
                  }
                  // Ensure emit is called after all async operations have completed
                  emit(GuestProfileUpdateDoneState( companyIdSaved: isCompanyIdSaved));
                }

          },
        );
      // } catch (e) {
      //   emit(GuestProfileUpdateErrorState(errorMessage: '$e'));
      // }
    });

    on<OnSearchByCompanyEvent>((event, emit) async {
      emit(SignupLoadingState());

      Map<String, dynamic> queryParameters = {
        "keyword": event.keyword,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.guestSearchByCompany),
          ApiBaseHelpers.guestProfileUpdateHeaders(),
          body: queryParameters,
        );

        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(GuestSearchByCompanyErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(GuestSearchByCompanyErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GuestSearchByCompanyErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GuestSearchByCompanyErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(GuestSearchByCompanyErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {

          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(GuestSearchByCompanyErrorState(errorMessage: error));
          } else {
            guestSearchByData = GuestSearchByModel.fromJson(right).data ?? [];
            if (guestSearchByData.isNotEmpty) {
              if (guestSearchByData.first.blocks != null || guestSearchByData.first.blocks?.isNotEmpty == true) {
                blocksData = [];
                blocksData = guestSearchByData.first.blocks ?? [];  /// we use this
                for (var block in blocksData) {
                  if (block.blockName != null) {
                    blockName.add(block.blockName!);
                  }
                }
              }
            }
            emit(GuestSearchByCompanyDoneState());
          }
        });
      } catch (e) {
        emit(GuestSearchByCompanyErrorState(errorMessage: '$e'));
      }
    });

    on<FindHouseNumberEvent>((event, emit){
      List<Blocks> blocksData = guestSearchByData.first.blocks ?? [];
      String selectedBlockName = event.blockName;
      for (var block in blocksData) {
        if (block.blockName == selectedBlockName) {
          if (block.houses != null) {
            housesData = block.houses; /// we use this
            for (var house in block.houses!) {
              houseNumber.add(house.houseNumber ?? '');
            }
            break;
          }
        }
      }
      emit(FindHouseNumberDoneState());
    });

    on<OnGuestCompanyJoinEvent>((event, emit) async {
      emit(SignupLoadingState());

      Map<String, dynamic> queryParameters = {
        "company_id": event.companyId,
        "block_id": event.blockId,
        "house_id": event.houseId,
        "role": event.role,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.guestCompanyJoin),
          ApiBaseHelpers.guestProfileUpdateHeaders(),
          body: queryParameters,
        );

        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(GuestCompanyJoinErrorState(errorMessage: left.errorMessage!));
          }
          else if (left is NoDataFailure) {
            emit(GuestCompanyJoinErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          }
          else if (left is ServerFailure) {
            emit(GuestCompanyJoinErrorState(errorMessage: 'Server Failure'));
          }
          else if (left is InvalidDataUnableToProcessFailure) {
            emit(GuestCompanyJoinErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          }
          else {
            emit(GuestCompanyJoinErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          // guestSearchByData = GuestSearchByModel.fromJson(right).data ?? [];
          emit(GuestCompanyJoinDoneState());
        });
      }
      catch (e) {
        emit(GuestCompanyJoinErrorState(errorMessage: '$e'));
      }
    });

    on<OnGetProfileBackgroundEvent>((event, emit) async {
      emit(GuestProfileBackgroundLoadingState());
      try {
        final String? appApiToken = event.appApiToken;

        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.userProfile),
          appApiToken==null?ApiBaseHelpers.guestProfileUpdateHeaders():ApiBaseHelpers.guestProfileUpdateHeaders(accessTokenStr: appApiToken),
        );

        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(GuestProfileBackgroundErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(GuestProfileBackgroundErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(GuestProfileBackgroundErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(GuestProfileBackgroundErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          }
          else if (left is NetworkFailure) {
            emit(GuestProfileBackgroundErrorState(errorMessage: 'NetworkFailure'));
          } else {
            emit(GuestProfileBackgroundErrorState(errorMessage: 'Something went wrong'));
          }
        },
        (right) async {
          UserProfileBloc? newSignupBloc;
          if (event.mContext != null) {
            newSignupBloc = BlocProvider.of<UserProfileBloc>(event.mContext!);
          }
          userResponseModel =  UserResponseModel.fromJson(right);
          if (userResponseModel == null || userResponseModel!.user == null) {
            emit(GuestProfileBackgroundErrorState(errorMessage: 'Profile Not Found'));
            return;
          }
          bool isCompleteProfile = userResponseModel!.user!.name!=null && userResponseModel!.user!.name!.isNotEmpty?true:false;
          String? newSelectedCompanyIdStr;
          bool? isApprovalPending = true;
          try {
            if (userResponseModel!.user!.company != null) {
              if (newSignupBloc != null) {
                try
                {
                  newSignupBloc.user = userResponseModel!.user!;
                }
                catch (e)
                {
                  print(e);
                }
              }

              /// Select Current unit
              if (newSignupBloc!.user.houses != null &&
                  newSignupBloc.user.houses!.isNotEmpty) {
                int selectedUnitId = await PrefUtils().readInt(WorkplaceNotificationConst.mySelectedUnitId);
                if(selectedUnitId>0){
                  int index  = newSignupBloc.user.houses!.indexWhere((tempHouse)=>tempHouse.id==selectedUnitId);
                  if(index!=-1){
                    Houses? mHouses = newSignupBloc.user.houses![index];
                    newSignupBloc.add(OnChangeCurrentUnitEvent(selectedUnit: mHouses));
                  }
                  else {
                    newSignupBloc.add(OnChangeCurrentUnitEvent(selectedUnit: newSignupBloc.user.houses![0]));
                  }
                }
                else{
                  newSignupBloc.add(OnChangeCurrentUnitEvent(selectedUnit: newSignupBloc.user.houses![0]));
                }
              }
              else
              {
                newSignupBloc.add(const OnChangeCurrentUnitEvent(selectedUnit: null));
              }

              newSelectedCompanyIdStr = userResponseModel!.user!.company!.id.toString();
              WorkplaceDataSourcesImpl.selectedCompanySaveId = newSelectedCompanyIdStr;
              ApiBaseHelpers.selectedCompanySaveId = newSelectedCompanyIdStr;
              await PrefUtils().saveStr(WorkplaceNotificationConst.selectedCompanyId,newSelectedCompanyIdStr);

            }
            else {
              newSelectedCompanyIdStr = "";
              WorkplaceDataSourcesImpl.selectedCompanySaveId = "";
              ApiBaseHelpers.selectedCompanySaveId = "";
              await PrefUtils().saveStr(WorkplaceNotificationConst.selectedCompanyId,'0');
            }

            emit(GuestProfileBackgroundDoneState(
              isCompleteProfile: isCompleteProfile,
              selectedCompanyId: newSelectedCompanyIdStr,
              isApprovalPending: isApprovalPending,
            ));

          } catch (e) {
            print(e);
            emit(GuestProfileBackgroundErrorState(errorMessage: '$e'));
          }
        });
      } catch (e) {
        emit(GuestProfileBackgroundErrorState(errorMessage: '$e'));
      }
    });


    on<LoginUsingMobileEvent>((event, emit) async {
      emit(SignupLoadingState());

      Map<String, dynamic> queryParameters = {
        "mobile": event.mobileNumber,
        "country_code": event.countryCode,
      };

      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().post(
          Uri.parse(ApiConst.loginByMobile),
          ApiBaseHelpers.guestHeaders(),
          body: queryParameters,
        );
        await response.fold((left) async {
          if (left is UnauthorizedFailure) {
            emit(LoginUsingMobileErrorState(errorMessage: left.errorMessage!));
          } else if (left is NoDataFailure) {
            emit(LoginUsingMobileErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(LoginUsingMobileErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(LoginUsingMobileErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(LoginUsingMobileErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) async {
          try {
            GuestSignupModel guestSignupModel = GuestSignupModel.fromJson(right);
            String? token;
            if (guestSignupModel.data != null) {
              token = guestSignupModel.data?.token;
              if (token != null) {
                print('Token saved successfully: $token');
              }
            }
            emit(LoginUsingMobileDoneState(token: token!));
          } catch (e) {
            emit(LoginUsingMobileErrorState(errorMessage: 'Error parsing response: $e'));
          }
        });

      } catch (e) {
        emit(LoginUsingMobileErrorState(errorMessage: '$e'));
      }
    });



  }
}

