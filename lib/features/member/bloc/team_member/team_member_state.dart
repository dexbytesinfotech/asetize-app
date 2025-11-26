part of 'team_member_bloc.dart';

abstract class TeamMemberState extends Equatable {
  const TeamMemberState();

  @override
  List<Object> get props => [];
}

class TeamMemberInitial extends TeamMemberState {}

class TeamMemberLoadingState extends TeamMemberState {}

class FilterUpdatedDoneState extends TeamMemberState {}

class TeamMemberDataFetched extends TeamMemberState {}

class StoreTeamViewIsListOrGridState extends TeamMemberState {
  final bool isGrid;
  const StoreTeamViewIsListOrGridState({required this.isGrid});
}

class TeamMemberErrorState extends TeamMemberState {
  final String errorMessage;
  const TeamMemberErrorState({required this.errorMessage,});
}