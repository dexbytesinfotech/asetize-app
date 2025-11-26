import '../../../imports.dart';

abstract class VehicleFormEvent {}

class SubmitVehicleFormEvent extends VehicleFormEvent {

  final int? userId;
  final int? houseId;
  final int? blockId;
  final int? isParkingAllotted;
  final String registrationNumber;
  final String ownerName;
  final String vehicleType;
  final String? make;
  final String? model;
  final String? colors;
  final BuildContext? mContext;

  SubmitVehicleFormEvent({
    this.userId,
    this.houseId,
    this.blockId,
    required this.isParkingAllotted,
    required this.registrationNumber,
    required this.ownerName,
    required this.vehicleType,
    this.make,
    this.model,
    this.colors,
    this.mContext,
  });
}


