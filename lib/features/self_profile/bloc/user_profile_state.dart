part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileFetching extends UserProfileState {
  final BuildContext? mContext;
  const UserProfileFetching({required this.mContext});
}

class UserProfileFetched extends UserProfileState {
  final String? displayMessage;
  const UserProfileFetched({this.displayMessage});
}
class UserProfileError extends UserProfileState {
  final String? displayMessage;
  const UserProfileError({this.displayMessage});
}

class DeleteUserState extends UserProfileState {}


class CompanyChangeBackgroundLoadingState extends UserProfileState {}
class CompanyChangeBackgroundDoneState extends UserProfileState {
  final int? companyId;
  final int? houseId;
  final String? companyName;
  const CompanyChangeBackgroundDoneState({this.companyId,this.companyName,this.houseId});
}

class DeleteUserErrorState extends UserProfileState {
  final String errorMessage;
  const DeleteUserErrorState({required this.errorMessage});
}

class CancelState extends UserProfileState {}

class ContactShowStatusChangeLoadingState extends UserProfileState {}
class ContactShowStatusChangeDoneState extends UserProfileState {}
class ContactShowStatusChangeErrorState extends UserProfileState {
  final String? errorMessage;
  const ContactShowStatusChangeErrorState({required this.errorMessage});
}

class UpdateNotificationState extends UserProfileState {}
class NotificationLoadingState extends UserProfileState {}

class UpdateNotificationErrorState extends UserProfileState {
  final String? errorMessage;
  const UpdateNotificationErrorState({required this.errorMessage});
}
class UpdateProfilePhotoErrorState extends UserProfileState {
  final String errorMessage;
  const UpdateProfilePhotoErrorState({required this.errorMessage});
}

class ChangePasswordState extends UserProfileState {}
class ChangePasswordErrorState extends UserProfileState {
  final String? errorMessage;
  const ChangePasswordErrorState({required this.errorMessage});
}

class UploadMediaState extends UserProfileState {}

class UploadMediaErrorState extends UserProfileState {
  final String? errorMessage;
  const UploadMediaErrorState({required this.errorMessage});
}

class StoreMediaState extends UserProfileState {}

class UpdateNotificationCountDoneState extends UserProfileState {}

class UpdateCountOnNotificationGenerateDoneState extends UserProfileState {}
