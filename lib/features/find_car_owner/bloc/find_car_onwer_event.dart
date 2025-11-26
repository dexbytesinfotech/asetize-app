// vehicle_infomation_event.dart
import '../../../imports.dart';

abstract class VehicleInfomationEvent {}

class SearchVehicleEvent extends VehicleInfomationEvent {
  final String registrationNumber;
  final BuildContext? mContext;
  SearchVehicleEvent(this.registrationNumber, this.mContext);
}
