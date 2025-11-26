import '../../../../imports.dart';

abstract class WorkplaceNetworkState extends Equatable {
  const WorkplaceNetworkState();

  @override
  List<Object> get props => [];
}

class NetworkInitial extends WorkplaceNetworkState {}

class NetworkConnected extends WorkplaceNetworkState {}

class NetworkDisconnected extends WorkplaceNetworkState {}
