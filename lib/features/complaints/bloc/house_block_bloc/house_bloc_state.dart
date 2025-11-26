abstract class HouseBlockState {}

class HouseBlockInitialState extends HouseBlockState {}

class HouseBlockLoadingState extends HouseBlockState {}

class HouseBlockErrorState extends HouseBlockState {
  final String errorMessage;
  HouseBlockErrorState({required this.errorMessage});
}

class FetchedHouseBlockDoneState extends HouseBlockState {}


