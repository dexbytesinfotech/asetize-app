part of 'find_helper_bloc.dart';

abstract class FindHelperEvent {}

class FetchFindHelperDataEvent extends FindHelperEvent {
 final BuildContext mContext;
 FetchFindHelperDataEvent({required this.mContext});
}

class ResetFindHelperEvent extends FindHelperEvent {}


