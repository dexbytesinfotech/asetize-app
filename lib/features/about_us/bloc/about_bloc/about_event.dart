import '../../../../imports.dart';

abstract class AboutEvent extends Equatable {
  const AboutEvent();
  @override
  List<Object> get props => [];
}

class FetchAboutDataEvent extends AboutEvent {
  final BuildContext mContext;
  const FetchAboutDataEvent({required this.mContext});
}
