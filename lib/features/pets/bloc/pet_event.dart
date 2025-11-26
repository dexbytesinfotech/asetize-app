import '../../../imports.dart';

abstract class PetEvent {}

class OnGetListOfPetsEvent extends PetEvent {
  final BuildContext? mContext;
  OnGetListOfPetsEvent({
    required this.mContext,
  });
}

class OnStorePetInformationEvent extends PetEvent {
  final BuildContext? mContext;
  final String? name;
  final String? dob;
  final String? type;
  final String? breed;
  final String? gender;
  final String? photo;
  OnStorePetInformationEvent({
    required this.mContext,
    this.name,
    this.dob,
    this.type,
    this.breed,
    this.gender,
    this.photo,
  });
}

class OnStorePetVaccinationDetailEvent extends PetEvent {
  final BuildContext? mContext;
  final int? vaccinated;
  final int? remindMe;
  final String? vaccinationDate;
  final String? nextVaccinationDate;
  final String? document;
  final String? documentFileName;
  final int petId;
  OnStorePetVaccinationDetailEvent(
      {required this.mContext,
      this.vaccinated,
      this.remindMe,
      this.vaccinationDate,
      this.nextVaccinationDate,
      this.document,
      this.documentFileName,
      required this.petId});
}

class OnDeletePetDetailEvent extends PetEvent {
  final BuildContext? mContext;
  final int? petId;
  OnDeletePetDetailEvent({required this.mContext, required this.petId});
}

class OnUpdatePetDetailEvent extends PetEvent {
  final BuildContext? mContext;
  final int? petId;
  final String? name;
  final String? dob;
  final String? type;
  final String? breed;
  final String? gender;
  final String? photo;
  final String? fileName;
  OnUpdatePetDetailEvent({
    required this.mContext,
    required this.petId,
    this.name,
    this.dob,
    this.type,
    this.breed,
    this.gender,
    this.photo, this.fileName = "",
  });
}
