import '../../../core/network/api_base_helpers.dart';
import '../../../core/util/app_navigator/app_navigator.dart';
import '../../../imports.dart';
import '../../data/models/post_create_post_model.dart';
import '../../domain/usecases/post_create_post.dart';
import '../../my_post/models/get_feed_data_model.dart';
import 'package:http/http.dart' as http;
import '../models/create_post_model.dart';
part 'create_post_event.dart';
part 'create_post_state.dart';

part '../data_provider/create_post_data_provider.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  UploadMedia postUploadMedia =
      UploadMedia(RepositoryImpl(WorkplaceDataSourcesImpl()));
  CreatePostUseCase createPost =
      CreatePostUseCase(RepositoryImpl(WorkplaceDataSourcesImpl()));

  CreatePostDataProvider createPostDataProvider;
  CreatePostBloc(this.createPostDataProvider) : super(UserPostInitialState()) {
    on<OnPostCreationEvent>((event, emit) async {
      CreatePostState currentState = state;
      if (createPostDataProvider.getPostListToCreate().isEmpty &&
          createPostDataProvider.getCurrentPostDraftModel() == null) {
        return;
      }
      if ((createPostDataProvider.getPostListToCreate().isEmpty &&
                  createPostDataProvider.getCurrentPostDraftModel() != null) &&
              state is! CreatePostLoadingState ||
          state is! PostMediaLoadingState ||
          state is UserPostInitialState) {
        emit(CreatePostLoadingState());
        CreateNewPostModel? createNewPostModelReq;
        if (createPostDataProvider.getPostListToCreate().isEmpty) {
          createNewPostModelReq =
              createPostDataProvider.getCurrentPostDraftModel();
          createPostDataProvider.clearCurrentPostDraftModel();
          createNewPostModelReq!.id = DateTime.now().millisecondsSinceEpoch;
          createNewPostModelReq.inProgress = true;
          createPostDataProvider.addNewPostToCreate(createNewPostModelReq);
        } else {
          createNewPostModelReq =
              createPostDataProvider.getPostListToCreate().first;
          createNewPostModelReq.id = DateTime.now().millisecondsSinceEpoch;
          createNewPostModelReq.inProgress = true;
          createPostDataProvider.updateNewPostToCreate(createNewPostModelReq);
        }

        /// Upload media file for post
        if (createNewPostModelReq.localMediaFiles != null &&
            createNewPostModelReq.localMediaFiles!.isNotEmpty) {
          List<LocalMediaFile>? localMediaFiles = [];
          localMediaFiles.addAll(createNewPostModelReq.localMediaFiles!);
          for (int i = 0; i < localMediaFiles.length; i++) {
            emit(PostMediaLoadingState());
            // Either<Failure, UploadMediaModel> response =
            //     await postUploadMedia.call(UploadMediaParams(
            //         collectionName: '',
            //         filePath: localMediaFiles[i].mediaFilePath!));

            Either<Failure, dynamic> response = await uploadMediaFunction(
                headers: ApiBaseHelpers.headersMultipart(),
                apiUrl: ApiConst.updateProfilePhotos,
                collectionName: '',
                filePath: localMediaFiles[i].mediaFilePath!);

            response.fold((left) {
              if (left is UnauthorizedFailure) {
                appNavigator.tokenExpireUserLogout(event.context);
              } else if (left is NoDataFailure) {
                emit(CreatePostErrorState(errorMessage: left.errorMessage));
              } else if (left is NetworkFailure) {
                emit(CreatePostErrorState(
                    errorMessage: 'Network not available'));
              } else if (left is NoDataFailure) {
                emit(CreatePostErrorState(errorMessage: left.errorMessage));
              } else if (left is ServerFailure) {
                emit(CreatePostErrorState(errorMessage: 'Server Failure'));
              } else if (left is InvalidDataUnableToProcessFailure) {
                emit(CreatePostErrorState(errorMessage: left.errorMessage));
              } else {
                emit(
                    CreatePostErrorState(errorMessage: 'Something went wrong'));
              }
            }, (right) async {
              if (right.containsKey("error")) {
                emit(CreatePostErrorState(errorMessage: right['error']));
              } else {
                // String image = right.data?.fileName ?? '';
                String image =
                    UploadMediaModel.fromJson(right).data?.fileName ?? '';
                if (image.isNotEmpty) {
                  createNewPostModelReq =
                      createPostDataProvider.mediaFileUrlUpdate(
                          localMediaFiles[i].mediaFilePath!, image);
                }
              }
            });
            emit(PostMediaLoadingDoneState());
          }
        }

        emit(CreatePostLoadingState());
        Either<Failure, CreatePostModel> response =
            await createPost.call(CreatePostParams(
          title: createNewPostModelReq!.title,
          content: createNewPostModelReq!.content,
          media: createNewPostModelReq!.mediaFilesUrl,
          status: createNewPostModelReq!.status,
        ));
        response.fold((left) {
          if (left is UnauthorizedFailure) {
            createNewPostModelReq!.error = "Something went wrong";
            createNewPostModelReq!.inProgress = false;
            createPostDataProvider
                .updateNewPostToCreate(createNewPostModelReq!);
            appNavigator.tokenExpireUserLogout(event.context);
            createPostDataProvider.deletePostLocally(createNewPostModelReq!.id);
          } else if (left is NetworkFailure) {
            createNewPostModelReq!.error = "Network not available";
            createNewPostModelReq!.inProgress = false;
            createPostDataProvider
                .updateNewPostToCreate(createNewPostModelReq!);
            createPostDataProvider.deletePostLocally(createNewPostModelReq!.id);
            emit(CreatePostErrorState(errorMessage: 'Network not available'));
          } else if (left is ServerFailure) {
            createNewPostModelReq!.error = "Server Failure";
            createNewPostModelReq!.inProgress = false;
            createPostDataProvider
                .updateNewPostToCreate(createNewPostModelReq!);
            createPostDataProvider.deletePostLocally(createNewPostModelReq!.id);
            emit(CreatePostErrorState(errorMessage: 'Server Failure'));
          } else if (left is NoDataFailure) {
            createNewPostModelReq!.error = left.errorMessage;
            createNewPostModelReq!.inProgress = false;
            createPostDataProvider
                .updateNewPostToCreate(createNewPostModelReq!);
            createPostDataProvider.deletePostLocally(createNewPostModelReq!.id);
            emit(CreatePostErrorState(errorMessage: left.errorMessage));
          } else if (left is InvalidDataUnableToProcessFailure) {
            createNewPostModelReq!.error = left.errorMessage;
            createNewPostModelReq!.inProgress = false;
            createPostDataProvider
                .updateNewPostToCreate(createNewPostModelReq!);
            createPostDataProvider.deletePostLocally(createNewPostModelReq!.id);
            emit(CreatePostErrorState(errorMessage: left.errorMessage));
          } else {
            createNewPostModelReq!.error = "Something went wrong";
            createNewPostModelReq!.inProgress = false;
            createPostDataProvider
                .updateNewPostToCreate(createNewPostModelReq!);
            createPostDataProvider.deletePostLocally(createNewPostModelReq!.id);
            emit(CreatePostErrorState(errorMessage: 'Something went wrong'));
          }
        }, (right) {
          FeedData? data = right.data;
          createPostDataProvider.deletePostLocally(createNewPostModelReq!.id);
          // BlocProvider.of<FeedBloc>(event.context).add(UpdateFeedDataEvent(updatedFeedData: data));
          emit(CreatePostDoneState(updatedFeedData: data));
        });
      } else {
        CreateNewPostModel? createNewPostModelReq =
            createPostDataProvider.getCurrentPostDraftModel();
        if (createNewPostModelReq != null) {
          createPostDataProvider.clearCurrentPostDraftModel();
          createNewPostModelReq.id = DateTime.now().millisecondsSinceEpoch;
          createNewPostModelReq.inProgress = false;
          createPostDataProvider.addNewPostToCreate(createNewPostModelReq);
          emit(CreatePostAddedInDraftState());
          emit(currentState);
        }
      }
    });

    on<OnPostContentEditEvent>((event, emit) async {
      CreatePostState currentState = state;
      emit(PostContentEditingState());
      if (event.title != null) {
        createPostDataProvider.titleUpdated(event.title!);
      }
      if (event.content != null) {
        createPostDataProvider.contentUpdated(event.content!);
      }
      if (event.addMediaFiles != null) {
        createPostDataProvider.mediaFileUpdated(event.addMediaFiles!);
      }
      if (event.removeMediaFiles != null) {
        // List<String>? localMediaFiles = createPostDataProvider.getCurrentPostDraftModel()!.localMediaFiles;
        // localMediaFiles!.remove(event.removeMediaFiles);
        createPostDataProvider.mediaFileUpdated(event.removeMediaFiles!,
            remove: true);
      }
      emit(PostContentEditDoneState(
          createNewPostModel:
              createPostDataProvider.getCurrentPostDraftModel()));

      if (currentState is! CreatePostDoneState) {
        emit(currentState);
      }
    });
  }

  Future<Either<Failure, dynamic>> uploadMediaFunction(
      {required Map<String, String> headers,
      required String apiUrl,
      required String filePath,
      required String collectionName}) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.headers.addAll(headers);
    try {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    } catch (e) {
      debugPrint('$e');
    }
    try {
      request.fields['collection_name'] = collectionName;
    } catch (e) {
      debugPrint('$e');
    }
    var rawResponse = await request.send();

    var response = await http.Response.fromStream(rawResponse);

    try {
      debugPrint('URL ======== $apiUrl STATUS = ${rawResponse.statusCode}');
      debugPrint('response=====${json.decode(response.body)}');
    } catch (e) {
      print(e);
    }

    if (response.statusCode == 200) {
      try {
        return Right(jsonDecode(response.body));
      } catch (e) {
       return Left(NoDataFailure(errorMessage: "$e"));
      }
    } else if (response.statusCode == 404) {
      return Left(
          NoDataFailure(errorMessage: jsonDecode(response.body)['error']));
    } else if (response.statusCode == 401) {
      return Left(UnauthorizedFailure());
    } else {
      return Left(ServerFailure());
    }
  }
}
