import '../../../imports.dart';

class GetBirthdayData implements UseCase<BirthdayDataModel, dynamic> {
  final Repository repository;

  GetBirthdayData(this.repository);

  @override
  Future<Either<Failure, BirthdayDataModel>> call(params) async {
    try {
      return repository.getBirthdayData();
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
