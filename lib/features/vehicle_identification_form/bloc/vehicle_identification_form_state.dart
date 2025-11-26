import '../../../imports.dart';

abstract class VehicleFormState {}

class VehicleFormInitial extends VehicleFormState {}

class VehicleFormLoading extends VehicleFormState {}

class VehicleFormSuccess extends VehicleFormState {
  final String? message;
  VehicleFormSuccess({this.message});
}

class VehicleFormError extends VehicleFormState {
  final String error;

  VehicleFormError({required this.error});
}












