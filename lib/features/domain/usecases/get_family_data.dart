import '../../../imports.dart';

class GetFamilyData extends UseCase<FamilyModel, dynamic> {
  final Repository repository;
  GetFamilyData(this.repository);

  @override
  Future<Either<Failure, FamilyModel>> call(params) async {
    try {
      return repository.getFamilyDataList();
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
