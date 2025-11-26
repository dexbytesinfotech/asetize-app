abstract class HomeNewState {
  HomeNewState();
  List<Object> get props => [];
}

class NoticeboardInitialState extends HomeNewState {}

class NoticeboardLoadingState extends HomeNewState {}

class NoticeboardLoadedState extends HomeNewState {

  NoticeboardLoadedState();
}



class HomeAnnouncementLoadingState extends HomeNewState {
  HomeAnnouncementLoadingState();
}

class HomeAnnouncementErrorState extends HomeNewState {
  final String errorMessage;
  HomeAnnouncementErrorState({required this.errorMessage});
}


class HomeAnnouncementDoneState extends HomeNewState {
  HomeAnnouncementDoneState();
}



class NoticeboardErrorState extends HomeNewState {
  final String errorMessage;

  NoticeboardErrorState(this.errorMessage);
}

class OnTotalDuesInitialState extends HomeNewState {}

class OnTotalDuesLoadingState extends HomeNewState {}

class OnTotalDuesLoadedState extends HomeNewState {}

class OnTotalDuesErrorState extends HomeNewState {
  final String errorMessage;
  OnTotalDuesErrorState(this.errorMessage);
}
