import '../../../imports.dart';

abstract class AddVehicleManagerEvent {}


class OnGetBlockListEvent extends AddVehicleManagerEvent {
  final BuildContext? mContext;
  OnGetBlockListEvent({required this.mContext});
}


class ResetMyFamilyEvent extends AddVehicleManagerEvent {}

class OnGetHouseDetailEvent extends AddVehicleManagerEvent {
  final BuildContext? mContext;
  final String? houseId;
  OnGetHouseDetailEvent({required this.mContext, required this.houseId});
}class OnGetMyFamilyList extends AddVehicleManagerEvent {
  final BuildContext? mContext;
  final String? houseId;
  OnGetMyFamilyList({required this.mContext, required this.houseId});
}

class OnSetPrimaryMemberEvent extends AddVehicleManagerEvent {
  final BuildContext? mContext;
  final int? houseMemberId;
  OnSetPrimaryMemberEvent({required this.mContext, required this.houseMemberId});
}
class OnEnableDisableContactEvent extends AddVehicleManagerEvent {
  final BuildContext mContext;
  final int? houseMemberId;
  final bool isDisableContact;
  final bool? itsMe;
  OnEnableDisableContactEvent({required this.mContext, required this.houseMemberId, required this.isDisableContact,this.itsMe = false});
}


class ResetBlockListEvent extends AddVehicleManagerEvent {}

class OnAddMemberByManagerEvent extends AddVehicleManagerEvent {
  final BuildContext? mContext;
  final String? houseId;
  final String? email;
  final String? firstName;
  final String? lastName;
  final int? phone;
  final int? countryCode;
  final String? role;
  final String? gender;
  final String? relationship;
  final int? isPrimaryMember;
  OnAddMemberByManagerEvent({required this.mContext, required this.houseId, this.email,
  required this.firstName,required this.lastName,
    required this.phone,
    this.gender,this.relationship,
    required this.countryCode,
    required this.role,
    this.isPrimaryMember});
}


class VerifyPhoneNumberEvent extends AddVehicleManagerEvent {
  final BuildContext? mContext;
  final int? phoneNumber;
  VerifyPhoneNumberEvent({required this.mContext,
    required this.phoneNumber,
});
}

class GetAllVehicleListEvent extends AddVehicleManagerEvent {
  final BuildContext? mContext;
  GetAllVehicleListEvent({required this.mContext});
}

class DeleteMemberEvent extends AddVehicleManagerEvent {
  final BuildContext? mContext;
  final String houseMemberId;
  DeleteMemberEvent({required this.mContext, required this.houseMemberId});
}

class OnReLoadUiEvent extends AddVehicleManagerEvent {
  final BuildContext? mContext;
  OnReLoadUiEvent({this.mContext});
}