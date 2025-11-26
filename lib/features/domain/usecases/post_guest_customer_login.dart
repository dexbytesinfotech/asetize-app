import 'package:either_dart/src/either.dart';
import 'package:asetize/core/error/failures.dart';
import 'package:asetize/core/usecase/usecase.dart';
import '../../sign_up/models/post_sign_up_model.dart';
import '../repositories/repository.dart';

class PostGuestCustomerLogin implements UseCase<SignUpModel, GuestCustomerLoginParams> {
  final Repository repository;
  PostGuestCustomerLogin(this.repository);

  @override
  Future<Either<Failure, SignUpModel>> call(
      GuestCustomerLoginParams params) async {
    try {
      return repository.postGuestCustomerLogin(params: params);
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


class GuestCustomerLoginParams{
  String? email;
  String? name;
  GuestCustomerLoginParams({ this.email ,this.name});
}