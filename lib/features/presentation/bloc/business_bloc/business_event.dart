part of 'business_bloc.dart';

abstract class BusinessEvent extends Equatable {
  const BusinessEvent();

  @override
  List<Object> get props => [];
}

class FetchBusinessList extends BusinessEvent {
  final BuildContext mContext;
  const FetchBusinessList({required this.mContext});
}

class ResetBusinessBlocEvent extends BusinessEvent {}

class StoreBusinessViewIsListOrGridEvent extends BusinessEvent {
  final bool isGrid;
  const StoreBusinessViewIsListOrGridEvent({required this.isGrid});
}