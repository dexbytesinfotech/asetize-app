import '../../../imports.dart';

class PostLeaveStatusChange
    implements UseCase<PostLeaveApplyModel, LeaveStatusChangeParams> {
  final Repository repository;
  PostLeaveStatusChange(this.repository);

  @override
  Future<Either<Failure, PostLeaveApplyModel>> call(
      LeaveStatusChangeParams leaveStatusChangeParams) async {
    try {
      return repository.postLeaveStatusChange(
          leaveStatusChangeParams: leaveStatusChangeParams);
    } catch (e) {
      if (e is UnauthorizedFailure) {
        return Left(UnauthorizedFailure());
      }
      if (e is ServerFailure) {
        return Left(ServerFailure());
      }
      if (e is NetworkFailure) {
        return Left(NetworkFailure());
      }
      return Left(ServerFailure());
    }
  }
}

class LeaveStatusChangeParams extends Equatable {
  final int? leaveId;
  final String? status;
  const LeaveStatusChangeParams({
    this.leaveId,
    this.status,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
