import '../../../imports.dart';

abstract class CommitteeMemberEvent {}

class FetchCommitteeMembers extends CommitteeMemberEvent {
  final BuildContext mContext;

  FetchCommitteeMembers({required this.mContext});
}
