import '../../../imports.dart';

abstract class PetState {}

class PetInitialState extends PetState {}

class PetLoadingState extends PetState {}

class PetErrorState extends PetState {
  final String errorMessage;
  PetErrorState({required this.errorMessage,});
}

class GetPetsListDoneState extends PetState {}

class StoreMediaDoneState extends PetState {}

class StorePetInformationDoneState extends PetState {
  int? petId;
  StorePetInformationDoneState({this.petId});
}

class StorePetInformationLoadingState extends PetState {}

class StorePetInformationErrorState extends PetState {
  final String errorMessage;
  StorePetInformationErrorState({required this.errorMessage,});
}

class StorePetVaccinationDetailDoneState extends PetState {}

class StorePetVaccinationDetailLoadingState extends PetState {}

class StorePetVaccinationDetailErrorState extends PetState {
  final String errorMessage;
  StorePetVaccinationDetailErrorState({required this.errorMessage,});
}

class DeletePetDetailDoneState extends PetState {}

class DeletePetDetailLoadingState extends PetState {}

class DeletePetDetailErrorState extends PetState {
  final String errorMessage;
  DeletePetDetailErrorState({required this.errorMessage,});
}

class UpdatePetDetailDoneState extends PetState {}

// class UpdatePetDetailLoadingState extends PetState {}
//
// class UpdateDetailErrorState extends PetState {
//   final String errorMessage;
//   UpdateDetailErrorState({required this.errorMessage,});
// }
