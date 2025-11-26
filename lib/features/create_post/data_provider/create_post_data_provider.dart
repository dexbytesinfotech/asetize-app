// import '../create_post.dart';
part of '../bloc/create_post_bloc.dart';

class CreatePostDataProvider {
  final List<CreateNewPostModel> _postListToCreate = [];
  CreateNewPostModel? currentDraftPostModel;

  CreatePostDataProvider();

  /// Add message in draft
  CreateNewPostModel contentUpdated(String content) {
    currentDraftPostModel ??= CreateNewPostModel();
    currentDraftPostModel!.content = content;
    return currentDraftPostModel!;
  }

  /// Add title in draft
  CreateNewPostModel titleUpdated(String title) {
    currentDraftPostModel ??= CreateNewPostModel();
    currentDraftPostModel!.title = title;
    return currentDraftPostModel!;
  }

  /// Add media in draft
  CreateNewPostModel mediaFileUpdated(String mediaFiles,
      {bool? remove = false}) {
    currentDraftPostModel ??= CreateNewPostModel();
    currentDraftPostModel!.localMediaFiles ??= [];

    if (remove == true) {
      int index = currentDraftPostModel!.localMediaFiles!
          .indexWhere((value) => value.mediaFilePath == mediaFiles);
      if (index > -1) {
        currentDraftPostModel!.localMediaFiles!.removeAt(index);
      }
    } else if (remove == false) {
      int index = currentDraftPostModel!.localMediaFiles!
          .indexWhere((value) => value.mediaFilePath == mediaFiles);
      if (index == -1) {
        currentDraftPostModel!.localMediaFiles!
            .add(LocalMediaFile(mediaFilePath: mediaFiles));
      }
    }
    return currentDraftPostModel!;
  }

  void clearCurrentPostDraftModel() => currentDraftPostModel = null;
  CreateNewPostModel? getCurrentPostDraftModel() => currentDraftPostModel;

  /// Add new post in list to create
  List<CreateNewPostModel> getPostListToCreate() => _postListToCreate;

  /// Add new post in list to create
  List<CreateNewPostModel> addNewPostToCreate(
      CreateNewPostModel createNewPostModel) {
    _postListToCreate.add(createNewPostModel);
    return _postListToCreate;
  }

  /// Update post in list to create
  List<CreateNewPostModel> updateNewPostToCreate(
      CreateNewPostModel createNewPostModel) {
    int index = _postListToCreate
        .indexWhere((postData) => postData.id == createNewPostModel.id);
    if (index > -1) {
      _postListToCreate[index] = createNewPostModel;
    }
    return _postListToCreate;
  }

  /// Updated uploaded medea
  CreateNewPostModel? mediaFileUrlUpdate(String local, String mediaUrl) {
    int index =
        _postListToCreate.indexWhere((postData) => postData.inProgress == true);
    if (index > -1) {
      CreateNewPostModel createNewPostModel = _postListToCreate[index];
      createNewPostModel.mediaFilesUrl ??= [];
      if (createNewPostModel.localMediaFiles != null &&
          createNewPostModel.localMediaFiles!.isNotEmpty) {
        int index = createNewPostModel.localMediaFiles!
            .indexWhere((postData) => postData.mediaFilePath == local);
        if (index > -1) {
          LocalMediaFile localMediaFile =
              createNewPostModel.localMediaFiles![index];
          localMediaFile.status = "uploaded";
          createNewPostModel.localMediaFiles![index] = localMediaFile;
        }
      }
      createNewPostModel.mediaFilesUrl!.add(mediaUrl);
      _postListToCreate[index] = createNewPostModel;
      return createNewPostModel;
    }
    return null;
  }

  /// Delete post after creation
  List<CreateNewPostModel> deletePostLocally(int? id) {
    int index = _postListToCreate.indexWhere((postData) => postData.id == id!);
    if (index != -1) {
      _postListToCreate.removeAt(index);
    }
    return _postListToCreate;
  }

}
