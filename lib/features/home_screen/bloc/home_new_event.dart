import '../../../imports.dart';

abstract class HomeNewEvent extends Equatable {
  const HomeNewEvent();
  @override
  List<Object> get props => [];
}

class OnHomeNoticeBoardEvent extends HomeNewEvent {}

class OnTotalDuesEvent extends HomeNewEvent {}

class OnGetHomeAnnouncement extends HomeNewEvent {}

class ResetNoticeBoardEvent extends HomeNewEvent {}
