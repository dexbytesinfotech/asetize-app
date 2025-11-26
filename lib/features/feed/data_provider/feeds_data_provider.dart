part of '../bloc/feed_bloc.dart';

class FeedsDataProvider {
  List<FeedData>? _feedPostList;
  List<FeedData>? _myPostList;
  FeedData? _singlePostData;
  bool? _isPostPageEnded;

  FeedsDataProvider();

  List<FeedData> getFeedPostList() => _feedPostList ?? [];
  List<FeedData> setFeedList(List<FeedData>? list) {
    try {
      _feedPostList = _feedPostList ?? [];
      _feedPostList!.clear();
      _feedPostList!.addAll(list ?? []);
    } catch (e) {
      projectUtil.printP("$e");
    }
    return _feedPostList!;
  }

  List<FeedData> addFeedList(List<FeedData>? list) {
    _feedPostList = _feedPostList ?? [];
    _feedPostList!.addAll(list ?? []);
    return _feedPostList!;
  }

  List<FeedData> getMyPostList() => _myPostList ?? [];
  List<FeedData> setMyPostList(List<FeedData>? list) {
    try {
      _myPostList = _myPostList ?? [];
      _myPostList!.clear();
      _myPostList!.addAll(list ?? []);
    } catch (e) {
      projectUtil.printP("$e");
    }
    return _myPostList!;
  }

  List<FeedData> addMyPostList(List<FeedData>? list) {
    try {
      _myPostList = _myPostList ?? [];
      _myPostList!.addAll(list ?? []);
    } catch (e) {
      projectUtil.printP("$e");
    }
    return _myPostList!;
  }

  FeedData? getSelectedSinglePostData() {
    return _singlePostData;
  }

  FeedData? setSelectedSinglePostData(FeedData? feedData) =>
      _singlePostData = feedData;

  /// Common function
  ///
  /// Delete any Feed/MyPost from the feed list or my post list
  List<FeedData>? deleteFeedPost(int id) {
    try {
      if (_myPostList != null && _myPostList!.isNotEmpty) {
        final index = _myPostList!.indexWhere((user) => user.id == id);
        if (index > -1) {
          _myPostList!.removeAt(index);
        }
      }

      if (_feedPostList != null && _feedPostList!.isNotEmpty) {
        final index = _feedPostList!.indexWhere((user) => user.id == id);
        if (index > -1) {
          _feedPostList!.removeAt(index);
        }
      }
    } catch (e) {
      projectUtil.printP("$e");
    }
    return _myPostList;
  }

  /// Update Feed/MyPost list on comment
  FeedData? addComment({required Comments? commentData, required int postId}) {
    FeedData? currentFeed;
    try {
      /// Add Data in current post
      if (currentFeed == null) {
        currentFeed = getSelectedSinglePostData();
        currentFeed!.commentCount = currentFeed.commentCount! + 1;
        currentFeed.comments = currentFeed.comments ?? [];
        currentFeed.comments!.add(commentData!);
      }

      /// Updated Current selected feed/post
      if (getSelectedSinglePostData() != null) {
        setSelectedSinglePostData(currentFeed);
        print(currentFeed);
      }

      if (_feedPostList != null && _feedPostList!.isNotEmpty) {
        final index = _feedPostList!.indexWhere((data) => data.id == postId);
        if (index > -1) {
          currentFeed = _feedPostList![index];
          currentFeed.commentCount = currentFeed.commentCount! + 1;
          currentFeed.comments = currentFeed.comments ?? [];
          currentFeed.comments!.add(commentData!);
          _feedPostList![index] = currentFeed;
        }
      }

      if (_myPostList != null && _myPostList!.isNotEmpty) {
        final index = _myPostList!.indexWhere((data) => data.id == postId);
        if (index > -1) {
          if (currentFeed == null) {
            currentFeed = _myPostList![index];
            currentFeed.commentCount = currentFeed.commentCount! + 1;
            currentFeed.comments = currentFeed.comments ?? [];
            currentFeed.comments!.add(commentData!);
            _myPostList![index] = currentFeed;
          } else {
            _myPostList![index] = currentFeed;
          }
        }
      }

    } catch (e) {
      projectUtil.printP("$e");
    }
    return currentFeed;
  }

  /// Update Feed/MyPost list on comment
  FeedData? likeUnLike(
      {required bool? isLiked, required int postId, int? currentLikedCount}) {
    FeedData? currentFeed;
    try {
      if (_feedPostList != null && _feedPostList!.isNotEmpty) {
        final index = _feedPostList!.indexWhere((data) => data.id == postId);
        if (index > -1) {
          currentFeed = _feedPostList![index];
          currentFeed.isLike = isLiked;
          if (isLiked!) {
            currentFeed.likeCount = currentFeed.likeCount! + 1;
          } else {
            currentFeed.likeCount = currentFeed.likeCount! - 1;
          }
          _feedPostList![index] = currentFeed;
        }
      }

      if (_myPostList != null && _myPostList!.isNotEmpty) {
        final index = _myPostList!.indexWhere((data) => data.id == postId);
        if (index > -1) {
          if (currentFeed == null) {
            currentFeed = _myPostList![index];
            currentFeed.isLike = isLiked;
            if (isLiked!) {
              currentFeed.likeCount = currentFeed.likeCount! + 1;
            } else {
              currentFeed.likeCount = currentFeed.likeCount! - 1;
            }
            _myPostList![index] = currentFeed;
          } else {
            _myPostList![index] = currentFeed;
          }
        }
      }

      /// Add Data in current spotlight
      if (currentFeed == null) {
        currentFeed = getSelectedSinglePostData();
        currentFeed!.isLike = isLiked;
        if (isLiked!) {
          currentFeed.likeCount = currentFeed.likeCount! + 1;
        } else {
          currentFeed.likeCount = currentFeed.likeCount! - 1;
        }
      }

      /// Updated Current selected feed/post
      if (getSelectedSinglePostData() != null) {
        setSelectedSinglePostData(currentFeed);
      }
    } catch (e) {
      projectUtil.printP("$e");
    }
    return currentFeed;
  }

  /// Update Feed/MyPost list on delete comment
  FeedData? deleteComment({required int? commentId, required int postId}) {
    FeedData? currentFeed;
    try {
      if (_feedPostList != null && _feedPostList!.isNotEmpty) {
        final index = _feedPostList!.indexWhere((data) => data.id == postId);
        if (index > -1) {
          currentFeed = _feedPostList![index];
          currentFeed.comments = currentFeed.comments ?? [];
          final commentIndex = currentFeed.comments!
              .indexWhere((data) => data.commentId == commentId);
          if (commentIndex > -1) {
            currentFeed.comments!.removeAt(commentIndex);
          }
          currentFeed.commentCount = currentFeed.commentCount! - 1;
          _feedPostList![index] = currentFeed;
        }
      }
      if (_myPostList != null && _myPostList!.isNotEmpty) {
        final index = _myPostList!.indexWhere((data) => data.id == postId);
        if (index > -1) {
          if (currentFeed == null) {
            currentFeed = _myPostList![index];
            currentFeed.comments = currentFeed.comments ?? [];
            final commentIndex = currentFeed.comments!
                .indexWhere((data) => data.commentId == commentId);
            if (commentIndex > -1) {
              currentFeed.comments!.removeAt(commentIndex);
            }
            currentFeed.commentCount = currentFeed.commentCount! - 1;
            _myPostList![index] = currentFeed;
          } else {
            _myPostList![index] = currentFeed;
          }
        }
      }

      /// Add Data in current spotlight
      if (currentFeed == null) {
        currentFeed = getSelectedSinglePostData();
        currentFeed!.comments = currentFeed.comments ?? [];
        final commentIndex = currentFeed.comments!
            .indexWhere((data) => data.commentId == commentId);
        if (commentIndex > -1) {
          currentFeed.comments!.removeAt(commentIndex);
        }
        currentFeed.commentCount = currentFeed.commentCount! - 1;
      }

      /// Updated Current selected feed/post
      if (getSelectedSinglePostData() != null) {
        setSelectedSinglePostData(currentFeed);
      }
    } catch (e) {
      projectUtil.printP("$e");
    }

    return currentFeed;
  }

  /// Update Feed/MyPost list on comment
  FeedData? insetSingleFeedPostOnCreate(
      {required FeedData? currentFeed, int? index = 0, bool? clean=false}) {
    try {
      _feedPostList = _feedPostList ?? [];
      _myPostList = _myPostList ?? [];
      if (clean == true){
        _feedPostList = _feedPostList ?? [];
        _myPostList = _myPostList ?? [];
      }

      _myPostList!.insert(index!, currentFeed!);
      _feedPostList!.insert(index, currentFeed);
    } catch (e) {
      projectUtil.printP("$e");
    }

    return currentFeed;
  }

  /// Update Feed/MyPost list on comment
  FeedData? insetSingleFeedPostBackground(
      {required FeedData? currentFeed, int? index = 0, bool isSelf = false}) {
    try {
      _feedPostList = _feedPostList ?? [];
      _myPostList = _myPostList ?? [];
      if (isSelf) {
        _myPostList!.insert(index!, currentFeed!);
        _feedPostList!.insert(index, currentFeed);
      } else {
        _feedPostList!.insert(index!, currentFeed!);
      }
    } catch (e) {
      projectUtil.printP("$e");
    }
    return currentFeed;
  }

  /// We are updating Feed and PMy Post data list in case post details and current feed data miss mach
  FeedData? updateListOnSingleFeedPostDetails(
      {required FeedData? currentFeed}) {
    try {
      _feedPostList = _feedPostList ?? [];
      _myPostList = _myPostList ?? [];
      final index =
          _feedPostList!.indexWhere((data) => data.id == currentFeed!.id);
      if (index > -1) {
        _feedPostList![index] = currentFeed!;
      }

      final indexOfPost =
          _myPostList!.indexWhere((data) => data.id == currentFeed!.id);
      if (indexOfPost > -1) {
        _myPostList![indexOfPost] = currentFeed!;
      }
    } catch (e) {
      projectUtil.printP("$e");
    }
    return currentFeed;
  }

  set setPostPageEnded(bool value) {
    _isPostPageEnded = value;
  }

  bool get getPostPageEnded => _isPostPageEnded ?? false;
}
