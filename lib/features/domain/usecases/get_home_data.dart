import 'package:asetize/imports.dart';

class GetHomeData implements UseCase<GetHomeDataModel, dynamic> {
  final Repository repository;

  GetHomeData(this.repository);

  @override
  Future<Either<Failure, GetHomeDataModel>> call(params) async {
    try {
      return repository.getHomeData();
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
