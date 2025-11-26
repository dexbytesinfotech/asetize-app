part of 'business_bloc.dart';

abstract class BusinessState extends Equatable {
  const BusinessState();

  @override
  List<Object> get props => [];
}

class BusinessInitial extends BusinessState {}

class BusinessLoadingState extends BusinessState {}

class BusinessDataFetched extends BusinessState {}

class StoreBusinessViewIsListOrGridState extends BusinessState {
  final bool isGrid;
  const StoreBusinessViewIsListOrGridState({required this.isGrid});
}
