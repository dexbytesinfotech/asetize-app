import 'package:asetize/imports.dart';

class GetFaqList implements UseCase<FaqModal, dynamic> {
  final Repository repository;

  GetFaqList(this.repository);

  @override
  Future<Either<Failure, FaqModal>> call(params) async {
    try {
      return repository.getFaq();
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
