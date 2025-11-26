part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

// class FetchUserPostDataEvent extends CreatePostEvent{
//   BuildContext context;
//   FetchUserPostDataEvent({required this.context});
// }

class OnPostCreationEvent extends CreatePostEvent {
  final BuildContext context;
  OnPostCreationEvent({required this.context});
}

class OnPostContentEditEvent extends CreatePostEvent {
  final BuildContext context;
  final String? title;
  final String? content;
  final String? addMediaFiles;
  final String? removeMediaFiles;
  OnPostContentEditEvent(
      {required this.context,
      this.title,
      this.content,
      this.addMediaFiles,
      this.removeMediaFiles});
}

class OnGetDraftPostEvent extends CreatePostEvent {
  final BuildContext context;
  OnGetDraftPostEvent({required this.context});
}

class AddMediaEvent extends CreatePostEvent {
  final BuildContext? mContext;
  final List<String>? imageList;
  final List<Map<String, dynamic>>? imageMapList;
  AddMediaEvent({this.mContext, this.imageMapList, this.imageList});
}

class PostImageStoreEvent extends CreatePostEvent {
  final String? imagePath;
  final BuildContext? mContext;
  bool? callFromInit = false;
  PostImageStoreEvent({this.imagePath, this.mContext, this.callFromInit});
  @override
  String toString() => 'post image path { index: $imagePath }';
}

class RemoveImageFromList extends CreatePostEvent {
  final BuildContext? mContext;
  final int itemIndex;
  RemoveImageFromList({this.mContext, required this.itemIndex});
  @override
  String toString() => 'Remove image { index:}';
}
