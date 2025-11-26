import '../../../imports.dart';

class GetLeaveDetailById
    implements UseCase<GetLeaveDetailModel, LeaveDetailParams> {
  final Repository repository;

  GetLeaveDetailById(this.repository);

  @override
  Future<Either<Failure, GetLeaveDetailModel>> call(
      LeaveDetailParams params) async {
    try {
      return repository.getLeaveDetailById(leaveDetailParams: params);
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

class LeaveDetailParams {
  final int? postId;
  const LeaveDetailParams({
    this.postId,
  });

  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
