part of 'find_helper_bloc.dart';

abstract class FindHelperState {}

class FindHelperLoadingState extends FindHelperState {}

class FindHelperInitialState extends FindHelperState {}

class FindHelperErrorState extends FindHelperState {
  String errorMessage;
  FindHelperErrorState({required this.errorMessage});
}

class FetchFindHelperDataDoneState extends FindHelperState {}
