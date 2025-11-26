import '../../../imports.dart';

class PutMarkNotificationRead
    implements UseCase<bool, MarkNotificationReadParams> {
  final Repository repository;

  PutMarkNotificationRead(this.repository);

  @override
  Future<Either<Failure, bool>> call(MarkNotificationReadParams params) async {
    try {
      return repository.putMarkNotificationRead(
          markNotificationReadParams: params);
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

class MarkNotificationReadParams {
  int? messageID;
  MarkNotificationReadParams({this.messageID});
}
