abstract class MyVehicleListState {}

class MyVehicleInitialState extends MyVehicleListState {}

class MyVehicleLoadingState extends MyVehicleListState {}

class MyVehicleLoadedState extends MyVehicleListState {

}class MyVehicleEmptyState extends MyVehicleListState {
}

class MyVehicleErrorState extends MyVehicleListState {
  final String errorMessage;

  MyVehicleErrorState(this.errorMessage);
}

class DeleteMyVehicleInitialState extends MyVehicleListState {}

class DeleteMyVehicleLoadingState extends MyVehicleListState {}

class DeleteMyVehicleLoadedState extends MyVehicleListState {
}

class DeleteMyVehicleErrorState extends MyVehicleListState {
  final String errorMessage;

  DeleteMyVehicleErrorState(this.errorMessage);
}
