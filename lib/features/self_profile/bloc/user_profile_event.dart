part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileDetails extends UserProfileEvent {
  final BuildContext mContext;
  final bool? isCompanySwitched;
  const FetchProfileDetails({required this.mContext,this.isCompanySwitched = false});
}
class OnChangeCurrentUnitEvent extends UserProfileEvent {
  final Houses? selectedUnit;
  final String? houseId;
   const OnChangeCurrentUnitEvent({required this.selectedUnit,this.houseId,
  });
}

class ResetSelectedMyUnit extends UserProfileEvent {}

class OnCompanyChangInBackground extends UserProfileEvent {
  final BuildContext mContext;
  final int? companyId;
  final int? houseId;
  final String? companyName;
  const OnCompanyChangInBackground({required this.mContext,this.companyId,this.houseId,this.companyName});
}

class UserIsBlockedEvent extends UserProfileEvent {
  final BuildContext mContext;
  const UserIsBlockedEvent({required this.mContext});
}

class DeleteUserEvent extends UserProfileEvent {
  final BuildContext mContext;
  const DeleteUserEvent({required this.mContext});
}

class CancelEvent extends UserProfileEvent {
  final BuildContext mContext;
  const CancelEvent({required this.mContext});
}

class UpdateNotificationEvent extends UserProfileEvent {
  final bool? notifications;
  final BuildContext mContext;
  const UpdateNotificationEvent({this.notifications = true, required this.mContext});
}

class OnContactShowStatusChangeEvent extends UserProfileEvent {
  final bool? notifications;
  final BuildContext mContext;
  const OnContactShowStatusChangeEvent({this.notifications = true, required this.mContext});
}

class ChangePasswordEvent extends UserProfileEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  final BuildContext mContext;
  const ChangePasswordEvent(
      {required this.oldPassword,
      required this.newPassword,
      required this.confirmPassword,
      required this.mContext});
}

class UploadMediaEvent extends UserProfileEvent {
  final String imagePath;
  final String collectionName;
  final BuildContext mContext;
  const UploadMediaEvent({required this.imagePath, required this.mContext,this.collectionName = 'profile_photo'});
}

class StoreMediaEvent extends UserProfileEvent {
  final String? fileName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final BuildContext mContext;
  const StoreMediaEvent({ this.fileName, required this.mContext,this.firstName, this.lastName, this.email, });
}

class UpdateNotificationCountEvent extends UserProfileEvent {
}
class UpdateCountOnNotificationGenerateEvent extends UserProfileEvent {
}
