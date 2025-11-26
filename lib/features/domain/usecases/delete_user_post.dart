import '../../../imports.dart';

class DeleteUserPost extends UseCase<bool, DeleteUserPostParams> {
  final Repository repository;
  DeleteUserPost(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteUserPostParams params) async {
    try {
      return repository.deleteUserPost(deleteUserParams: params);
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

class DeleteUserPostParams extends Equatable {
  final int? postId;
  const DeleteUserPostParams({
    this.postId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
