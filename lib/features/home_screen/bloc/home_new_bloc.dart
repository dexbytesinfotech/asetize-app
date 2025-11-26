import 'package:asetize/core/network/api_base_helpers.dart';
import '../../../imports.dart';
import '../models/home_announcement_model.dart';
import '../models/notice_board.dart';
import '../models/total_dues_model.dart';
import 'home_new_event.dart';
import 'home_new_state.dart';

class HomeNewBloc extends Bloc<HomeNewEvent, HomeNewState> {

  List<Notice> notices = [];
  // List<HomeAnnouncementData> homeAnnouncementData = [];
  HomeAnnouncementData? homeAnnouncementData;

  DuesData? duesData;

  HomeNewBloc() : super(NoticeboardInitialState()) {
    on<OnHomeNoticeBoardEvent>(_onHomeNoticeBoardEvent);
    on<OnTotalDuesEvent>(_onTotalDuesEvent);
    on<ResetNoticeBoardEvent>((event, emit) {
      notices.clear();
      homeAnnouncementData = null;
      duesData=null;
      // emit(NoticeboardInitialState());
    });
    on<OnGetHomeAnnouncement>((event, emit) async {

      emit(HomeAnnouncementLoadingState());
      try {
        Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.homeData),
          ApiBaseHelpers.headers(),);
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            emit(HomeAnnouncementErrorState(errorMessage: 'Unauthorized Failure'));
          } else if (left is NoDataFailure) {
            emit(HomeAnnouncementErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else if (left is ServerFailure) {
            emit(HomeAnnouncementErrorState(errorMessage: 'Server Failure'));
          } else if (left is InvalidDataUnableToProcessFailure) {
            emit(HomeAnnouncementErrorState(
                errorMessage: jsonDecode(left.errorMessage)['error']));
          } else {
            emit(HomeAnnouncementErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          if (right != null && right.containsKey('error')) {
            String error = "${right['error']}";
            emit(HomeAnnouncementErrorState(errorMessage: error));
          } else {
            homeAnnouncementData = HomeAnnouncementModel.fromJson(right).data;

            emit(HomeAnnouncementDoneState());
          }
        });
      } catch (e) {
        emit(HomeAnnouncementErrorState(errorMessage: '$e'));
      }
    });
  }

  Future<void> _onHomeNoticeBoardEvent(
      OnHomeNoticeBoardEvent event, Emitter<HomeNewState>

      emit) async {
    emit(NoticeboardLoadingState());

    try {
      Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.noticeBoardContent), ApiBaseHelpers.headers());

      response.fold((left) {
        notices = [];
        if (left is UnauthorizedFailure) {
          emit(NoticeboardErrorState('Unauthorized Failure'));
        } else if (left is NoDataFailure) {
          emit(NoticeboardErrorState(left.errorMessage));
        } else if (left is ServerFailure) {
          emit(NoticeboardErrorState('Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(NoticeboardErrorState(left.errorMessage));
        } else {
          emit(NoticeboardErrorState('Something went wrong'));
        }
      }, (right) {
        try {
          notices = (right['data'] as List).map((json) => Notice.fromJson(json)).toList();
          emit(NoticeboardLoadedState());
        } catch (e) {
          notices = [];
          emit(NoticeboardErrorState("Error parsing noticeboard data"));
        }
      });
    } catch (e) {
      notices = [];
      emit(NoticeboardErrorState("Unexpected error while fetching noticeboard data"));
    }
  }


  
  Future<void> _onTotalDuesEvent(
      OnTotalDuesEvent event, Emitter<HomeNewState> emit) async {
    emit(OnTotalDuesLoadingState());
    try {
      Either<Failure, dynamic> response = await ApiBaseHelpers().get(
          Uri.parse(ApiConst.totalDues), ApiBaseHelpers.headers());

      response.fold((left) {
        if (left is UnauthorizedFailure) {
          emit(OnTotalDuesErrorState('Unauthorized Failure'));
        } else if (left is NoDataFailure) {
          emit(OnTotalDuesErrorState(left.errorMessage));
        } else if (left is ServerFailure) {
          emit(OnTotalDuesErrorState('Server Failure'));
        } else if (left is InvalidDataUnableToProcessFailure) {
          emit(OnTotalDuesErrorState(left.errorMessage));
        } else {
          emit(OnTotalDuesErrorState('Something went wrong'));
        }
      }, (right) {
        try {
          duesData = Dues.fromJson(right).data;
          emit(OnTotalDuesLoadedState());
         } catch (e) {
           emit(OnTotalDuesErrorState("Error parsing total dues data"));
         }
      });
    } catch (e) {
      emit(OnTotalDuesErrorState("Unexpected error while fetching total dues data"));
    }
  }
}
