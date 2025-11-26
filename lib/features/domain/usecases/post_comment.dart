import 'package:either_dart/src/either.dart';
import 'package:equatable/equatable.dart';
import 'package:asetize/core/error/failures.dart';
import 'package:asetize/core/usecase/usecase.dart';
import '../../data/models/post_comment_model.dart';
import '../repositories/repository.dart';

class PostCommentUseCase extends UseCase<PostCommentModel, PostCommentParams> {
  final Repository repository;
  PostCommentUseCase(this.repository);
  @override
  Future<Either<Failure, PostCommentModel>> call(
      PostCommentParams params) async {
    try {
      return repository.postComment(params: params);
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

class PostCommentParams extends Equatable {
  final int? postId;
  final String? commentText;

  const PostCommentParams({this.postId, this.commentText});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
