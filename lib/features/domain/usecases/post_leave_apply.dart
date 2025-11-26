import '../../../imports.dart';

class PostLeaveApply implements UseCase<PostLeaveApplyModel, LeaveApplyParams> {
  final Repository repository;
  PostLeaveApply(this.repository);

  @override
  Future<Either<Failure, PostLeaveApplyModel>> call(
      LeaveApplyParams leaveApplyParams) async {
    try {
      return repository.postLeaveApply(leaveApplyParams: leaveApplyParams);
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

class LeaveApplyParams extends Equatable {
  final int? leaveTypeID;
  final String? reason;
  final String? duration;
  final String? startDate;
  final String? endDate;
  const LeaveApplyParams({
    this.leaveTypeID,
    this.reason,
    this.duration,
    this.startDate,
    this.endDate,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
