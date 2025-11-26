abstract class HomeState {}

class HomeInitialState extends HomeState {}

class VisitorLoadingState extends HomeState {}

class PreRegisterVisitorLoadingState extends HomeState {}

class UpcomingVisitorsListLoadingState extends HomeState {}

class DeleteUpComingVisitorLoadingState extends HomeState {}

class UpdatePreRegisterVisitorLoadingState extends HomeState {}

class DeleteUpComingVisitorDoneState extends HomeState {}
// class UpdatePreRegisterVisitorDoneState extends HomeState {}
class UpdatePreRegisterVisitorDoneState extends HomeState {
  final String message;
  UpdatePreRegisterVisitorDoneState({required this.message});
}

class DeleteUpComingVisitorErrorState extends HomeState {
  final String errorMessage;
  DeleteUpComingVisitorErrorState({required this.errorMessage});
}

class UpdatePreRegisterVisitorErrorState extends HomeState {
  final String errorMessage;
  UpdatePreRegisterVisitorErrorState({required this.errorMessage});
}

class UpcomingVisitorsListDoneState extends HomeState {}

class SubmitRequestForNOCLoadingState extends HomeState {}

class VisitorHistoryLoadingState extends HomeState {}
class CreatedNocPassLoadingState extends HomeState {}

class VisitorListDoneState extends HomeState {}


class CreatedNocPassDoneState extends HomeState {
  final String message;
  CreatedNocPassDoneState({required this.message});
}

// class PreRegisterVisitorDoneState extends HomeState {}

class PreRegisterVisitorDoneState extends HomeState {
  final int? data;
  PreRegisterVisitorDoneState({this.data});
}


class SubmitRequestForNOCDoneState extends HomeState {}

class VisitorListErrorState extends HomeState {
  final String errorMessage;
  VisitorListErrorState({required this.errorMessage});
}

class CreatedNocPassErrorState extends HomeState {
  final String errorMessage;
  CreatedNocPassErrorState({required this.errorMessage});
}

class UpcomingVisitorsListErrorState extends HomeState {
  final String errorMessage;
  UpcomingVisitorsListErrorState({required this.errorMessage});
}
class PreRegisterVisitorErrorState extends HomeState {
  final String errorMessage;
  PreRegisterVisitorErrorState({required this.errorMessage});
}


class SubmitRequestForNOCErrorState extends HomeState {
  final String errorMessage;
  SubmitRequestForNOCErrorState({required this.errorMessage});
}

class VisitorHistoryErrorState extends HomeState {
  final String errorMessage;
  VisitorHistoryErrorState({required this.errorMessage});
}

class VisitorCheckoutDoneState extends HomeState {
  final String status;
  VisitorCheckoutDoneState({required this.status});
}
class VisitorCheckoutLoadingState extends HomeState {}


class VisitorHistoryDoneState extends HomeState {}

class VisitorCheckoutErrorState extends HomeState {
  final String errorMessage;
  VisitorCheckoutErrorState({required this.errorMessage});
}
