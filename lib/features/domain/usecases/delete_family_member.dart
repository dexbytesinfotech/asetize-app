import '../../../imports.dart';

class DeleteFamilyMember extends UseCase<bool, FamilyParams> {
  final Repository repository;
  DeleteFamilyMember(this.repository);

  @override
  Future<Either<Failure, bool>> call(FamilyParams params) async {
    try {
      return repository.deleteFamilyMember(
        familyParams: params,
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

class FamilyParams {
  final int? familyId;
  const FamilyParams({this.familyId});
}
