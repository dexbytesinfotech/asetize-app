import '../../../imports.dart';

abstract class MyVehicleListEvent {}

class MyVehicleEvent extends MyVehicleListEvent {
  TickerProvider? vsync;
  final BuildContext mContext;
  MyVehicleEvent({required this.mContext,  this.vsync});
}
class ResetMyVehicleBlocEvent extends MyVehicleListEvent {}

class DeleteMyVehicleEvent extends MyVehicleListEvent {
  final BuildContext? mContext;
  final int id;
  DeleteMyVehicleEvent({ required this.id, this.mContext});
}