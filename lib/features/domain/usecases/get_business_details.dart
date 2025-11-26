import 'package:asetize/imports.dart';

import '../../data/models/business_detail_module.dart';

class GetBusinessDetails implements UseCase<BusinessDetailsModel, dynamic> {
  final Repository repository;

  GetBusinessDetails(this.repository);

  @override
  Future<Either<Failure, BusinessDetailsModel>> call(params) async {
    try {
      return repository.getBusinessDetails();
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
