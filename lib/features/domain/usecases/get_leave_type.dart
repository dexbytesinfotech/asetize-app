import '../../../imports.dart';

class GetLeaveType implements UseCase<GetLeaveTypeModel, dynamic> {
  final Repository repository;

  GetLeaveType(this.repository);
  @override
  Future<Either<Failure, GetLeaveTypeModel>> call(params) async {
    try {
      return repository.getLeaveType();
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
