import 'package:asetize/imports.dart';

class GetUserProfile implements UseCase<UserResponseModel, dynamic> {
  final Repository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserResponseModel>> call(params) async {
    try {
      return repository.getUserProfile(param:params);
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
