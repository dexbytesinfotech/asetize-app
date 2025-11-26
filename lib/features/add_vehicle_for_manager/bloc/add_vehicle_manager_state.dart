
abstract class AddVehicleManagerState {}

class AddVehicleManagerInitialState extends AddVehicleManagerState {}

class AddVehicleManagerLoadingState extends AddVehicleManagerState {}

class SetPrimaryMemberLoadingState extends AddVehicleManagerState {}
class EnableDisableContactLoadingState extends AddVehicleManagerState {}

class AddVehicleManagerErrorState extends AddVehicleManagerState {
  final String errorMessage;
  AddVehicleManagerErrorState({required this.errorMessage,});
}

class SetPrimaryMemberErrorState extends AddVehicleManagerState {
  final String errorMessage;
  SetPrimaryMemberErrorState({required this.errorMessage,});}


class EnableDisableContactErrorState extends AddVehicleManagerState {
  final String errorMessage;
  EnableDisableContactErrorState({required this.errorMessage,});}

  class OnGetHouseDetailErrorState extends AddVehicleManagerState {
  final String errorMessage;
  OnGetHouseDetailErrorState({required this.errorMessage,});
}

class AddMemberByManagerErrorState extends AddVehicleManagerState {
  final String errorMessage;
  AddMemberByManagerErrorState({required this.errorMessage,});
}

class AddVehicleManagerDoneState extends AddVehicleManagerState {}

class OnGetHouseDetailDoneState extends AddVehicleManagerState {}

class OnSetPrimaryMemberDoneState extends AddVehicleManagerState {}

class EnableDisableContactDoneState extends AddVehicleManagerState {
  final bool isDisableContact;
  EnableDisableContactDoneState({required this.isDisableContact,});

}

class AddMemberByManagerDoneState extends AddVehicleManagerState {}

class VerifyPhoneNumberLoadingState extends AddVehicleManagerState {}

class VerifyPhoneNumberErrorState extends AddVehicleManagerState {
  final String errorMessage;
  VerifyPhoneNumberErrorState({required this.errorMessage,});
}

class VerifyPhoneNumberDoneState extends AddVehicleManagerState {
  final String? firstName;
  final String? lastName;
  VerifyPhoneNumberDoneState({
     this.firstName,
     this.lastName,
  });
}

class GetAllVehicleListErrorState extends AddVehicleManagerState {
  final String errorMessage;
  GetAllVehicleListErrorState({required this.errorMessage,});
}


class GetAllVehicleListDoneState extends AddVehicleManagerState {}

class DeleteMemberDoneState extends AddVehicleManagerState {}

class DeleteMemberErrorState extends AddVehicleManagerState {
  final String errorMessage;
  DeleteMemberErrorState({required this.errorMessage,});
}

class ReloadUiDoneState extends AddVehicleManagerState {}