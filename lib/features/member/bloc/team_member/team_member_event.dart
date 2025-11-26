part of 'team_member_bloc.dart';

abstract class TeamMemberEvent extends Equatable {
  const TeamMemberEvent();

  @override
  List<Object> get props => [];
}

class FetchTeamList extends TeamMemberEvent {
  final BuildContext mContext;
  const FetchTeamList({required this.mContext});
}

class OnSearchMemberEvent extends TeamMemberEvent {
  final BuildContext? mContext;
  final String? searchKey;
  const OnSearchMemberEvent({this.mContext,this.searchKey= ""});
}

class OnFilterUpdateEvent extends TeamMemberEvent {
  final List<String>? selectedFilter;
  final String? searchKey;
  final bool? isInit;
  const OnFilterUpdateEvent({this.selectedFilter,this.isInit = false,this.searchKey= ""});
}

class ResetTeamBlocEvent extends TeamMemberEvent {}

class StoreTeamViewIsListOrGridEvent extends TeamMemberEvent {
  final bool isGrid;
  const StoreTeamViewIsListOrGridEvent({required this.isGrid});
}