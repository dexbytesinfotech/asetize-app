
abstract class CommitteeMemberState {}

class CommitteeMemberInitial extends CommitteeMemberState {}

class CommitteeMemberLoading extends CommitteeMemberState {}

class CommitteeMemberLoaded extends CommitteeMemberState {
}

class CommitteeMemberError extends CommitteeMemberState {
  final String message;

  CommitteeMemberError(this.message);
}
