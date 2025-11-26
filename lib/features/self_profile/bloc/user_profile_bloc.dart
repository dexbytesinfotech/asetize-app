import 'package:asetize/imports.dart';
import '../../../core/network/api_base_helpers.dart';
import '../../../core/util/app_navigator/app_navigator.dart';
import '../../../core/util/app_permission.dart';
import '../../domain/usecases/post_new_profile_update.dart';
import '../../new_sign_up/pages/new_login_with_email_screen.dart';
part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserResponseModel userResponseModel = UserResponseModel();
  User user = User();
  bool notification = true;
  bool selfContactDisplayStatus = false;
  String? selectProfilePhoto;
  String? userName;
  Houses? selectedUnit;
  List<Houses>? profileHouses;
  bool? isInvoicePreview;
  String? invoicePreviewMessage;
  int? selectedUnitHouseMemberId;

  GetUserProfile getUserProfile =
      GetUserProfile(RepositoryImpl(WorkplaceDataSourcesImpl()));

  DeleteUser deleteUser =
      DeleteUser(RepositoryImpl(WorkplaceDataSourcesImpl()));
  ///Update global notification
  PostProfileUpdate postProfileUpdate =
      PostProfileUpdate(RepositoryImpl(WorkplaceDataSourcesImpl()));
  ///Update profile photo
  NewProfileUpdate newProfileUpdate =
  NewProfileUpdate(RepositoryImpl(WorkplaceDataSourcesImpl()));
  PostChangePassword postChangePassword =
      PostChangePassword(RepositoryImpl(WorkplaceDataSourcesImpl()));
  UploadMedia uploadMedia =
      UploadMedia(RepositoryImpl(WorkplaceDataSourcesImpl()));

  UserProfileBloc() : super(UserProfileInitial()) {

    on<UserProfileEvent>((event, emit) async {
      // TODO: implement event handler
      await PrefUtils()
          .readBool(WorkplaceNotificationConst.globalNotificationC)
          .then((value) => notification = value);
    });


    on<OnCompanyChangInBackground>((event, emit) async {
      // TODO: implement event handler
      emit(CompanyChangeBackgroundLoadingState());
      try {
        emit(CompanyChangeBackgroundDoneState(companyName: event.companyName,companyId: event.companyId));
      } catch (e) {
        print(e);
      }
    });

    on<FetchProfileDetails>((event, emit) async {
      emit(UserProfileFetching(mContext: event.mContext));

      bool? isCompanySwitched = event.isCompanySwitched;

      // Fetch user profile
      Either<Failure, UserResponseModel> response = await getUserProfile.call({
        "isCompanySwitched": isCompanySwitched
      });

      await response.fold((left) async {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        } else {
          emit(const UserProfileError(displayMessage: 'Your account has been disabled, Please contact to administrator'));
        }
      }, (right) async {
        if (right.user != null) {
          user = right.user!;
          notification = user.globalNotifications ?? true;
          selfContactDisplayStatus = user.isPublicContact ?? false;
          PrefUtils().saveBool(WorkplaceNotificationConst.globalNotificationC,
              right.user?.globalNotifications ?? true);
          // Save profile image
          if (right.user!.profilePhoto != null) {
            await PrefUtils().saveStr(
                WorkplaceNotificationConst.userProfileImageC,
                right.user!.profilePhoto);
          }

          await PrefUtils().saveStr(WorkplaceNotificationConst.userDob, right.user!.dob);
          await PrefUtils().saveInt(
              WorkplaceNotificationConst.notificationUnreadCountC,
              right.user!.notificationCount ?? 0);

          // Read and set profile photo
          selectProfilePhoto = await PrefUtils().readStr(WorkplaceNotificationConst.userProfileImageC);

          if (right.user?.houses != null) {
            profileHouses = right.user?.houses;
          }

          // Save companies data
          List<Companies> companies = right.user?.companies ?? [];
          List<Map<String, dynamic>> companiesList = companies.map((company) {
            return {
              'id': company.id,
              'name': company.name,
              'role_name': company.roleName
            };
          }).toList();

          // Store user details
          userName = right.user!.name ?? "";
          List<String> permissions = right.user?.permissions ?? [];
          AppPermission.instance.setPermissions = permissions;

          // Handle selected unit logic
          if (right.user?.houses != null && right.user!.houses!.isNotEmpty) {
            int selectedUnitId = await PrefUtils().readInt(WorkplaceNotificationConst.mySelectedUnitId);
            if (selectedUnitId > 0) {
              int index = right.user!.houses!.indexWhere((tempHouse) => tempHouse.id == selectedUnitId);
              Houses? selectedUnit = (index != -1) ? right.user!.houses![index] : right.user!.houses!.first;
              add(OnChangeCurrentUnitEvent(selectedUnit: selectedUnit));
            }
          }

          emit(UserProfileFetched(
              displayMessage: right.user!.displayMessage ?? "You are most welcome"));
        } else {
          emit(const UserProfileError(displayMessage: 'UserProfileError'));
        }
      });
    });


    on<DeleteUserEvent>((event, emit) async {
      emit(UserProfileLoading());
      Either<Failure, bool> response = await deleteUser.call('');
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        } else {
          emit(
              const DeleteUserErrorState(errorMessage: 'Something went wrong'));
        }
      }, (right) {
        if (right) {
          PrefUtils().clearAll();
          PrefUtils()
              .saveBool(WorkplaceNotificationConst.isUserLoggedInC, false);
          emit(DeleteUserState());
        } else {
          emit(
              const DeleteUserErrorState(errorMessage: 'Something went wrong'));
        }
        });
    });

    on<CancelEvent>((event, emit) {
      emit(CancelState());
    });

    on<UpdateNotificationEvent>((event, emit) async {
      emit(NotificationLoadingState());
      final value = await postProfileUpdate
          .call(ProfileUpdateParams(
        globalNotifications: event.notifications! ? 1 : 0
      ));
      value.fold((left) {
        notification = event.notifications!;
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        } else if (left is NoDataFailure) {
          emit(UpdateNotificationErrorState(
              errorMessage: left.errorMessage));
        } else if (left is NetworkFailure) {
          emit(const UpdateNotificationErrorState(
              errorMessage: 'Network Failure'));
        } else if (left is ServerFailure) {
          emit(const UpdateNotificationErrorState(
              errorMessage: 'Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(UpdateNotificationErrorState(
              errorMessage: left.errorMessage));
        } else {
          emit(const UpdateNotificationErrorState(
              errorMessage: 'Something went wrong'));
        }
      },
              (right) {
            notification = (right.user?.globalNotifications ?? event.notifications!);
            PrefUtils().saveBool(WorkplaceNotificationConst.globalNotificationC,
                right.user?.globalNotifications ?? event.notifications!);
            emit(UpdateNotificationState());
          });
    });


    on<OnContactShowStatusChangeEvent>((event, emit) async {
      emit(ContactShowStatusChangeLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
            Uri.parse(ApiConst.contactShowStatusUpdate),
            ApiBaseHelpers.headers());

        response.fold((left) {
                notification = event.notifications!;
                if (left is UnauthorizedFailure) {
                  appNavigator.tokenExpireUserLogout(event.mContext);
                } else if (left is NoDataFailure) {
                  emit(ContactShowStatusChangeErrorState(
                      errorMessage: left.errorMessage));
                } else if (left is NetworkFailure) {
                  emit(const ContactShowStatusChangeErrorState(
                      errorMessage: 'Network Failure'));
                } else if (left is ServerFailure) {
                  emit(const ContactShowStatusChangeErrorState(
                      errorMessage: 'Server Failure'));
                } else if (left is InvalidDataUnableToProcessFailure) {
                  emit(ContactShowStatusChangeErrorState(
                      errorMessage: left.errorMessage));
                } else {
                  emit(const ContactShowStatusChangeErrorState(
                      errorMessage: 'Something went wrong'));
                }
              },(right) {
          if(right.containsKey("data") && right["data"]!=null){
            selfContactDisplayStatus = right["data"]["is_public_contact"]??selfContactDisplayStatus;
            // PrefUtils().saveBool(WorkplaceNotificationConst.globalNotificationC,
            //     right.user?.globalNotifications ?? event.notifications!);
            emit(ContactShowStatusChangeDoneState());
          }
          else{
            emit(ContactShowStatusChangeErrorState(
                errorMessage: "${ right["message"]}"));
          }

                  });
      }
      catch (e) {
        print(e);
        emit(const ContactShowStatusChangeErrorState(
            errorMessage: 'Something went wrong'));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(UserProfileLoading());
      Either<Failure, dynamic> response = await postChangePassword.call(
          ChangePasswordParams(
              oldPassword: event.oldPassword,
              newPassword: event.newPassword,
              confirmPassword: event.confirmPassword));
      response.fold((left) {
        if (left is NoDataFailure) {
          emit(ChangePasswordErrorState(errorMessage: left.errorMessage));
        } else if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        } else if (left is NetworkFailure) {
          emit(const ChangePasswordErrorState(
              errorMessage: 'Network not available'));
        } else if (left is NoDataFailure) {
          emit(ChangePasswordErrorState(errorMessage: left.errorMessage));
        } else if (left is ServerFailure) {
          emit(const ChangePasswordErrorState(errorMessage: 'Server Failure'));
        } else {
          emit(const ChangePasswordErrorState(
              errorMessage: 'Something went wrong'));
        }
      }, (right) {
        emit(ChangePasswordState());
      });
    });

    on<StoreMediaEvent>((event, emit) async {
      // TODO: implement event handler
     emit(UserProfileLoading());
     var value = await newProfileUpdate
          .call(NewProfileUpdateParams(profilePhoto: event.fileName ,firstName: event.firstName, lateName: event.lastName,));

      value.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        } else if (left is NoDataFailure) {
          emit(UpdateProfilePhotoErrorState(
              errorMessage: left.errorMessage));
        } else if (left is NetworkFailure) {
          emit(const UpdateProfilePhotoErrorState(
              errorMessage: 'Network Failure'));
        } else if (left is ServerFailure) {
          emit(const UpdateProfilePhotoErrorState(
              errorMessage: 'Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(UpdateProfilePhotoErrorState(
              errorMessage: left.errorMessage));
        } else {
          emit(const UpdateProfilePhotoErrorState(errorMessage: 'Image not changed'));
        }
      },(right) {

        add(FetchProfileDetails(mContext: event.mContext));
        emit(StoreMediaState());
      });
    });

    on<UploadMediaEvent>((event, emit) async {
      emit(UserProfileInitial());
      emit(UserProfileLoading());
      Either<Failure, UploadMediaModel> response = await uploadMedia.call(
          UploadMediaParams(
              filePath: event.imagePath, collectionName: 'profile_photo'));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        } else if (left is NoDataFailure) {
          emit(UploadMediaErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
        } else if (left is ServerFailure) {
          emit(const UploadMediaErrorState(errorMessage: 'Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(UploadMediaErrorState(errorMessage: jsonDecode(left.errorMessage)['error']));
        } else {
          emit(const UploadMediaErrorState(errorMessage: 'Something went wrong'));
        }
      }, (right) async {
        String fileName = right.data!.fileName ?? "";
        if (fileName.isNotEmpty) {
          add(StoreMediaEvent(fileName: fileName, mContext: event.mContext));
        }
        emit(UploadMediaState());
      });
      emit(const UserProfileFetched());
    });

    on<ResetSelectedMyUnit>((event, emit) async {
      // selectedUnit = null;
      emit(UserProfileInitial());

    });

    on<UserIsBlockedEvent>((event, emit) {
      PrefUtils().clearAll();
      Navigator.of(MainAppBloc.dashboardContext!).pushAndRemoveUntil(
          SlideLeftRoute(widget: const NewLoginWithEmail()),
          (Route<dynamic> route) => false);
    });

    on<UpdateNotificationCountEvent>((event, emit) {
      user.notificationCount = 0;
      emit(UpdateNotificationCountDoneState());
    });
    on<UpdateCountOnNotificationGenerateEvent>((event, emit) {
      user.notificationCount = (user.notificationCount)! + 1;
      emit(UpdateCountOnNotificationGenerateDoneState());
    });

    on<OnChangeCurrentUnitEvent>((event, emit) async {
      selectedUnit = event.selectedUnit;
      selectedUnitHouseMemberId =  event.selectedUnit?.houseMemberId;
      isInvoicePreview = event.selectedUnit?.isInvoicePreview;
      invoicePreviewMessage = event.selectedUnit?.invoicePreviewMessage;
      /// If any unit selected then we will store it
      if(selectedUnit!=null){
        PrefUtils().saveInt(WorkplaceNotificationConst.mySelectedUnitId,selectedUnit!.id);
        PrefUtils().saveBool(WorkplaceNotificationConst.isInvoicePreview,selectedUnit!.isInvoicePreview );
        PrefUtils().saveStr(WorkplaceNotificationConst.invoicePreviewMessage,selectedUnit!.invoicePreviewMessage );
      }
      // else if(selectedUnit == null)
      //   {
      //     /// After cancel request change selected unit of index 0
      //     if (profileHouses?.isNotEmpty == true ) {
      //       PrefUtils().saveInt(WorkplaceNotificationConst.mySelectedUnitId,profileHouses?[0].id);
      //       PrefUtils().saveBool(WorkplaceNotificationConst.isInvoicePreview,profileHouses?[0].isInvoicePreview );
      //       PrefUtils().saveStr(WorkplaceNotificationConst.invoicePreviewMessage,profileHouses?[0].invoicePreviewMessage );
      //     }
      //   }
      /// If selected unit nul then we are considering it as a non selected
      else{
        PrefUtils().saveInt(WorkplaceNotificationConst.mySelectedUnitId,0);
      }
    });
  }
  void clearData() {
    userResponseModel = UserResponseModel();
    user = User();
    notification = true;
    selfContactDisplayStatus = false;
    selectProfilePhoto = null;
    userName = null;
    selectedUnit = null;
    profileHouses = null;
    isInvoicePreview = null;
    invoicePreviewMessage = null;
    selectedUnitHouseMemberId = null;
  }

}
