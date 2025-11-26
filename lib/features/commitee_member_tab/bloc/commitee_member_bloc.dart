import '../../../core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../models/commitee_member_model.dart';
import 'commitee_member_event.dart';
import 'commitee_member_state.dart';

class CommitteeMemberBloc extends Bloc<CommitteeMemberEvent, CommitteeMemberState> {

  List<CommitteeMembersList> committeeMemberList = [];

  CommitteeMemberBloc() : super(CommitteeMemberInitial()) {
    on<FetchCommitteeMembers>(_memberList);
  }

  Future<void> _memberList(
      FetchCommitteeMembers event, Emitter<CommitteeMemberState> emit) async {
    emit(CommitteeMemberLoading());
    try {
      Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.commiteeMembers),
          ApiBaseHelpers.headers());

      response.fold((left) {
        if (left is UnauthorizedFailure) {
          emit(CommitteeMemberError('Unauthorized Failure'));
        } else if (left is NoDataFailure) {
          emit(CommitteeMemberError(left.errorMessage));
        } else if (left is ServerFailure) {
          emit(CommitteeMemberError('Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(CommitteeMemberError(left.errorMessage));
        } else {
          emit(CommitteeMemberError('Something went wrong'));
        }
      }, (right) {
        try {
          // Extract the message
            committeeMemberList = CommitteeMember.fromJson(right).data ?? [];
            emit(CommitteeMemberLoaded());
        } catch (e) {
          emit(CommitteeMemberError('Error parsing response'));
        }
      });
    } catch (e) {
      emit(CommitteeMemberError("Error fetching Committee members"));
    }
  }


}