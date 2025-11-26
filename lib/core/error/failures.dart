import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

// class NoInterNet extends Failure {}

class NoDataFailure extends Failure {
  final String errorMessage;
  NoDataFailure({required this.errorMessage});
}

class ParsingFailure extends Failure {}

class UnauthorizedFailure extends Failure {
  final String? errorMessage;
  UnauthorizedFailure({this.errorMessage});
}

class InvalidDataUnableToProcessFailure extends Failure {
  final String errorMessage;
  InvalidDataUnableToProcessFailure({required this.errorMessage});
}

class TooManyAttemptFailure extends Failure {}