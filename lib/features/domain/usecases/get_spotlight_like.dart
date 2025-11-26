import '../../../imports.dart';

class SpotlightLike implements UseCase<bool, SpotlightLikeParams> {
  final Repository repository;
  SpotlightLike(this.repository);

  @override
  Future<Either<Failure, bool>> call(
      SpotlightLikeParams spotlightLikeParams) async {
    try {
      return repository.spotlightLikeRequest(
          spotlightLikeParams: spotlightLikeParams);
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

class SpotlightLikeParams extends Equatable {
  final int? spotlightId;
  const SpotlightLikeParams({
    this.spotlightId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
