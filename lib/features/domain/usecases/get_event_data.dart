import '../../../imports.dart';

class GetEventData implements UseCase<EventDataModel, dynamic> {
  final Repository repository;

  GetEventData(this.repository);

  @override
  Future<Either<Failure, EventDataModel>> call(params) async {
    try {
      return repository.getEventData();
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
