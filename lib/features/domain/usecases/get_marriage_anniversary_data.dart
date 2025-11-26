import '../../../imports.dart';

class GetMarriageAnniversaryData
    implements UseCase<MarriageAnniversaryDataModel, dynamic> {
  final Repository repository;

  GetMarriageAnniversaryData(this.repository);

  @override
  Future<Either<Failure, MarriageAnniversaryDataModel>> call(params) async {
    try {
      return repository.getMarriageAnniversaryData();
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
