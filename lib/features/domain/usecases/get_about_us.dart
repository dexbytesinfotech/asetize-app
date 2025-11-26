import 'package:asetize/imports.dart';

class GetAboutUs implements UseCase<AboutUsModal, dynamic> {
  final Repository repository;

  GetAboutUs(this.repository);

  @override
  Future<Either<Failure, AboutUsModal>> call(params) async {
    try {
      return repository.getAboutUs();
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
