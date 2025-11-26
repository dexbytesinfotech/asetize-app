import '../../../imports.dart';

class GetHolidayData implements UseCase<HolidayDataModel, dynamic> {
  final Repository repository;

  GetHolidayData(this.repository);

  @override
  Future<Either<Failure, HolidayDataModel>> call(params) async {
    try {
      return repository.getHolidayData();
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
