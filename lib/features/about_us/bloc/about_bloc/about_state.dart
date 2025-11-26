abstract class AboutState {
  AboutState();
  List<Object> get props => [];
}
class AboutInitialState extends AboutState {}

class AboutLoadingState extends AboutState {}

class FetchedAboutDataState extends AboutState {}

class AboutErrorState extends AboutState {
  final String errorMessage;
  AboutErrorState({required this.errorMessage});
}