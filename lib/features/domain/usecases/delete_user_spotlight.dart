import '../../../imports.dart';

class DeleteUserSpotlight extends UseCase<bool, DeleteUserSpotlightParams> {
  final Repository repository;
  DeleteUserSpotlight(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteUserSpotlightParams params) async {
    try {
      return repository.deleteSpotlight(deleteUserSpotlightParams: params);
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

class DeleteUserSpotlightParams extends Equatable {
  final int? spotlightId;
  const DeleteUserSpotlightParams({
    this.spotlightId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
