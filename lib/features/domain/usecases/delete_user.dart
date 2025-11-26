import 'package:asetize/imports.dart';

class DeleteUser implements UseCase<bool, dynamic> {
  final Repository repository;

  DeleteUser(this.repository);

  @override
  Future<Either<Failure, bool>> call(params) async {
    try {
      return repository.deleteUser();
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
