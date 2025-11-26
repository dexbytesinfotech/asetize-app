import '../../../imports.dart';

class PutMarkNotificationReadDisplay
    implements UseCase<bool, MarkNotificationReadDisplayParams> {
  final Repository repository;

  PutMarkNotificationReadDisplay(this.repository);

  @override
  Future<Either<Failure, bool>> call(
      MarkNotificationReadDisplayParams params) async {
    try {
      return repository.putMarkNotificationReadDisplay(
          markNotificationReadDisplayParams: params);
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

class MarkNotificationReadDisplayParams {
  int? messageID;
  MarkNotificationReadDisplayParams({this.messageID});
}
