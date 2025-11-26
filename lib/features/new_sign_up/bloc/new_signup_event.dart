import '../../../imports.dart';

abstract class NewSignupEvent {}

class OnSignupEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final String communityName;
  final String registrationNumber;
  final String propertyType;
  final String phone;
  final String ownerName;
  final String ownerEmail;

  OnSignupEvent({this.mContext, required this.communityName,
    required this.registrationNumber, required this.propertyType,required this.phone, required this.ownerName, required this.ownerEmail});
}


class OnTermsAndConditionEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final String slug;

  OnTermsAndConditionEvent({required this.mContext, required this.slug});

}

// class OnGuestGetProfileEvent extends NewSignupEvent {
//   final BuildContext? mContext;
//   OnGuestGetProfileEvent({required this.mContext,});
// }


class OnGetProfileBackgroundEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final String? appApiToken;
  final String? selectedCompanyId;
  OnGetProfileBackgroundEvent({this.mContext,this.appApiToken,required this.selectedCompanyId});
}



class OnGuestLoginByEmail extends NewSignupEvent {
  final BuildContext? mContext;
  final String guestEmail;
  OnGuestLoginByEmail({required this.mContext, required this.guestEmail});

}

class OnVerifyOtpEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final String otp;
  final String token;
  final int? deviceId;
  final String? deviceName;
  final int? fcmToken;
  final int? deviceVersion;
  final String? deviceType;
  OnVerifyOtpEvent(this.token,{
    this.mContext,
    required this.otp,
    this.deviceId,
    this.deviceName,
    this.fcmToken,
    this.deviceVersion,
    this.deviceType,
  });

}


class OnGuestResendOtpEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final String token;
  OnGuestResendOtpEvent({required this.mContext, required this.token, });

}
class OnSearchByCompanyEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final String? keyword;
  OnSearchByCompanyEvent({required this.mContext,required this.keyword, });

}

class OnGuestProfileUpdateEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? guestEmail;
  OnGuestProfileUpdateEvent({required this.mContext,required this.firstName,required this.lastName, this.phone,this.guestEmail});

}

class OnGuestCompanyJoinEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final int? companyId;
  final int? blockId;
  final int? houseId;
  final String? role;
  OnGuestCompanyJoinEvent({required this.mContext,required this.companyId,required this.blockId,required this.houseId,required this.role,});

}


class FindHouseNumberEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final String blockName;
  FindHouseNumberEvent( {required this.mContext,required this.blockName, });

}


class ResetListEvent extends NewSignupEvent {}

class LoginUsingMobileEvent extends NewSignupEvent {
  final BuildContext? mContext;
  final String mobileNumber;
  final String countryCode;
  LoginUsingMobileEvent({required this.mContext, required this.mobileNumber, required this.countryCode});

}