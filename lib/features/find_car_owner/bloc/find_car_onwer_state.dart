// vehicle_infomation_state.dart
abstract class VehicleInfomationState {}

class VehicleInfomationInitialState extends VehicleInfomationState {}

class VehicleInfomationLoadingState extends VehicleInfomationState {}

class VehicleInfomationLoadedState extends VehicleInfomationState {
}

class VehicleInfomationErrorState extends VehicleInfomationState {
  final String errorMessage;

  VehicleInfomationErrorState(this.errorMessage);
}
