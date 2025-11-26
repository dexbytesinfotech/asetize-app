import '../../../imports.dart';

class GetLeaveData implements UseCase<GetLeaveDataModel, LeaveParams> {
  final Repository repository;

  GetLeaveData(this.repository);
  @override
  Future<Either<Failure, GetLeaveDataModel>> call(LeaveParams params) async {
    try {
      return repository.getLeaveData(leaveParams: params);
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

class LeaveParams extends Equatable {
  final String? url;
  const LeaveParams({this.url});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
