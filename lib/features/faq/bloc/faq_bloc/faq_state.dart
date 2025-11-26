import 'package:asetize/imports.dart';

abstract class FaqState {
  FaqDataModel? faqDataModel;
  FaqState({this.faqDataModel});
  void updateModel({faqDataModel}) {
    this.faqDataModel = faqDataModel;
  }

  get getFaqModel => faqDataModel;
}

class FaqInitState extends FaqState {}

class FaqLoadingState extends FaqState {}

class FetchFaqDataState extends FaqState {}

class FaqInProgressState extends FaqState {
  Map? requestData;
  FaqInProgressState({this.requestData});
}

class FaqErrorState extends FaqState {
  final String errorMessage;
  FaqErrorState({required this.errorMessage});

}

class GetFaqDataDoneState extends FaqState {
  FaqDataModel? responseData;
  GetFaqDataDoneState({this.responseData}) : super();
  @override
  String toString() => ' }';
}
