import 'package:asetize/imports.dart';

class GetTeamLeave implements UseCase<GetLeaveDataModel, dynamic> {
  final Repository repository;

  GetTeamLeave(this.repository);

  @override
  Future<Either<Failure, GetLeaveDataModel>> call(params) async {
    try {
      return repository.getTeamLeaves();
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
