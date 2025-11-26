import 'package:either_dart/src/either.dart';
import 'package:equatable/equatable.dart';
import 'package:asetize/core/error/failures.dart';
import 'package:asetize/core/usecase/usecase.dart';

import '../../data/models/post_create_post_model.dart';
import '../repositories/repository.dart';

class CreatePostUseCase implements UseCase<CreatePostModel, CreatePostParams> {
  final Repository repository;
  CreatePostUseCase(this.repository);

  @override
  Future<Either<Failure, CreatePostModel>> call(CreatePostParams params) async {
    try {
      return repository.postCreate(params: params);
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

class CreatePostParams extends Equatable {
  final String? title;
  final String? content;
  final String? status;
  final List<String>? media;

  const CreatePostParams({this.title, this.content, this.status, this.media});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
