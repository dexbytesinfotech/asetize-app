import '../../../../imports.dart';

abstract class WorkplaceNetworkEvent extends Equatable {
  const WorkplaceNetworkEvent();
  @override
  List<Object> get props => [];
}

class NetworkUpdateEvent extends WorkplaceNetworkEvent {}

class NetworkLostEvent extends WorkplaceNetworkEvent {}
