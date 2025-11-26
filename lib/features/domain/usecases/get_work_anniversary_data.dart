import '../../../imports.dart';

class GetWorkAnniversaryData
    implements UseCase<WorkAnniversaryDataModel, dynamic> {
  final Repository repository;

  GetWorkAnniversaryData(this.repository);

  @override
  Future<Either<Failure, WorkAnniversaryDataModel>> call(params) async {
    try {
      return repository.getWorkAnniversaryData();
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
