part of 'create_post_bloc.dart';

abstract class CreatePostState {}

class UserPostInitialState extends CreatePostState {}

class CreatePostLoadingState extends CreatePostState {}

class PostMediaLoadingState extends CreatePostState {}

class PostMediaLoadingDoneState extends CreatePostState {}

class FetchedUserPostDataState extends CreatePostState {}

class CreatePostDoneState extends CreatePostState {
  FeedData? updatedFeedData;
  CreatePostDoneState({this.updatedFeedData});
}

class CreatePostAddedInDraftState extends CreatePostState {}

class PostContentEditDoneState extends CreatePostState {
  final CreateNewPostModel? createNewPostModel;
  PostContentEditDoneState({required this.createNewPostModel});
}

class PostContentEditingState extends CreatePostState {
  PostContentEditingState();
}

class CreatePostErrorState extends CreatePostState {
  String? errorMessage;
  CreatePostErrorState({this.errorMessage});
}

class AddMediaDoneState extends CreatePostState {
  List<String>? imagePath;
  AddMediaDoneState({this.imagePath});
}

class PostImageStoreDoneState extends CreatePostState {
  final List<String> imagePathList;
  PostImageStoreDoneState({required this.imagePathList});
}

class RemoveItemDoneState extends CreatePostState {
  List<Map<String, File>>? imageDataList;
  RemoveItemDoneState({this.imageDataList});
}
