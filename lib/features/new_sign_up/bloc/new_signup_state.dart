
abstract class NewSignupState {}

class SignupInitialState extends NewSignupState {}

class SignupLoadingState extends NewSignupState {}


class GuestProfileBackgroundLoadingState extends NewSignupState {}
class GuestProfileBackgroundErrorState extends NewSignupState {
  final String errorMessage;
  GuestProfileBackgroundErrorState({required this.errorMessage,});
}
class GuestProfileBackgroundDoneState extends NewSignupState {
final bool isCompleteProfile;
final String? selectedCompanyId;
final bool? isApprovalPending;
GuestProfileBackgroundDoneState({required this.isCompleteProfile,required this.selectedCompanyId,this.isApprovalPending = true});
}

class SignupErrorState extends NewSignupState {
  final String errorMessage;
  SignupErrorState({required this.errorMessage,});
}


class GuestSignupErrorState extends NewSignupState {
  final String errorMessage;
  GuestSignupErrorState({required this.errorMessage,});
}



class GuestResendOtpErrorState extends NewSignupState {
  final String errorMessage;
  GuestResendOtpErrorState({required this.errorMessage,});
}
class GuestOtpVeifyErrorState extends NewSignupState {
  final String errorMessage;
  GuestOtpVeifyErrorState({required this.errorMessage,});
}

class GuestProfileUpdateErrorState extends NewSignupState {
  final String errorMessage;
  GuestProfileUpdateErrorState({required this.errorMessage,});

}


class GuestSearchByCompanyErrorState extends NewSignupState {
  final String errorMessage;
  GuestSearchByCompanyErrorState({required this.errorMessage,});

}

class GuestCompanyJoinErrorState extends NewSignupState {
  final String errorMessage;
  GuestCompanyJoinErrorState({required this.errorMessage,});

}

class GuestProfileErrorState extends NewSignupState {
  final String errorMessage;
  GuestProfileErrorState({required this.errorMessage,});

}




class SignupDoneState extends NewSignupState {}

class GuestSignupDoneState extends NewSignupState {
  final String token;
  GuestSignupDoneState({required this.token});
}

class GuestOtpVerifyDoneState extends NewSignupState {
  final bool isCompleteProfile;
  final bool isCompanyIdSaved;
  GuestOtpVerifyDoneState({required this.isCompleteProfile,required this.isCompanyIdSaved,});
}

class GuestResendOtpDoneState extends NewSignupState {}


class TermsAndConditionErrorState extends NewSignupState {
  final String errorMessage;
  TermsAndConditionErrorState({required this.errorMessage,});
}

class TermsAndConditionDoneState extends NewSignupState {}

class GuestSearchByCompanyDoneState extends NewSignupState {}
class GuestCompanyJoinDoneState extends NewSignupState {}

class GuestProfileDoneState extends NewSignupState {
  final bool joinRequestStatus;
  GuestProfileDoneState({required this.joinRequestStatus,});
}

class GuestProfileUpdateDoneState extends NewSignupState {
  final bool companyIdSaved;
  GuestProfileUpdateDoneState({required this.companyIdSaved});
}

class FindHouseNumberDoneState extends NewSignupState {}
class ResetListEventDoneState extends NewSignupState {}

class LoginUsingMobileDoneState extends NewSignupState {
  final String token;
  LoginUsingMobileDoneState({required this.token});
}


class LoginUsingMobileErrorState extends NewSignupState {
  final String errorMessage;
  LoginUsingMobileErrorState({required this.errorMessage,});
}
