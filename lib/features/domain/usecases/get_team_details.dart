import 'package:asetize/imports.dart';

class GetTeamDetails implements UseCase<TeamDetailsModel, dynamic> {
  final Repository repository;

  GetTeamDetails(this.repository);

  @override
  Future<Either<Failure, TeamDetailsModel>> call(params) async {
    try {
      return repository.getTeamDetails();
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
