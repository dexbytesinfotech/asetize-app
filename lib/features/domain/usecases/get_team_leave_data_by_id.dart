import '../../../imports.dart';

class GetTeamLeaveDetailById
    implements UseCase<GetLeaveDetailModel, TeamLeaveDetailParams> {
  final Repository repository;

  GetTeamLeaveDetailById(this.repository);

  @override
  Future<Either<Failure, GetLeaveDetailModel>> call(
      TeamLeaveDetailParams params) async {
    try {
      return repository.getTeamLeaveDetailById(
        teamLeaveDetailParams: params,
      );
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

class TeamLeaveDetailParams {
  int? postId;
  TeamLeaveDetailParams({
    this.postId,
  });

  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
