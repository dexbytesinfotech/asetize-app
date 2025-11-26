import '../../../../imports.dart';

abstract class HouseBlockEvent {}

class FetchHouseBlockEvent extends HouseBlockEvent {
  final BuildContext mContext;
  FetchHouseBlockEvent({required this.mContext});
}

class ResetHouseBlockEvent extends HouseBlockEvent {}
