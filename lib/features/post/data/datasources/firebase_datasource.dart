import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freedomwall/core/error/exceptions.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/data/datasources/post_remote_datasource.dart';
import 'package:freedomwall/features/post/domain/usecases/like_dislike_content.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/data/models/comment_model.dart';

class FirebaseDatasource implements PostRemoteDataSource {
  final _instance = FirebaseFirestore.instance;
  late final _postsRef = _instance.collection('posts');
  late final _commentsRef = _instance.collection('comments');

  @override
  Future<void> createContent(CreateModel post) async {
    try {
      if (post is CommentCreateModel) {
        _commentsRef.add(post.toJson
          ..addEntries({'post_ref': _postsRef.doc(post.postId)}.entries));

        final _postRef = _postsRef.doc(post.postId);
        final _post = await _postRef.get();
        _postRef.update({'commentCount': _post.data()!['commentCount'] + 1});
      } else {
        _postsRef.add(post.toJson..addEntries({'commentCount': 0}.entries));
      }
    } catch (e) {
      log(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<Stream<PostModel>> getPostById(String postId) async {
    try {
      final _postSnapshot = _postsRef.doc(postId).snapshots();
      return _postSnapshot.asyncMap((_post) async {
        final _comments = await _commentsRef
            .where('post_ref', isEqualTo: _post.reference)
            .get();

        final _commentList = _comments.docs
            .map((doc) => doc.data()..addEntries({'id': doc.id}.entries))
            .toList();

        return PostModel.fromJson(_post.data()!
          ..addEntries({'comments': _commentList, 'id': _post.id}.entries));
      });
    } catch (e) {
      log(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<void> likeDislikeContent(PostActionsParams params) async {
    try {
      final _postRef = _postsRef.doc(params.postId);
      final _post = await _postRef.get();
      switch (params.action) {
        case ParamsAction.like:
          _postRef.update({'likes': _post.data()!['likes'] + 1});
          break;
        case ParamsAction.unLike:
          _postRef.update({'likes': _post.data()!['likes'] - 1});
          break;
        case ParamsAction.dislike:
          _postRef.update({'dislikes': _post.data()!['dislikes'] + 1});
          break;
        case ParamsAction.unDislike:
          _postRef.update({'dislikes': _post.data()!['dislikes'] - 1});
          break;
        default:
          break;
      }
      return;
    } catch (e) {
      log(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<Stream<List<Post>>> streamPosts(Params params) async {
    try {
      final _postSnapshot = _postsRef
          .where(
            'title',
            isGreaterThanOrEqualTo: params.title,
            isLessThan: params.title != null
                ? params.title!.substring(0, params.title!.length - 1) +
                    String.fromCharCode(
                        params.title!.codeUnitAt(params.title!.length - 1) + 1)
                : null,
          )
          .where(
            'creator',
            isGreaterThanOrEqualTo: params.creator,
            isLessThan: params.creator != null
                ? params.creator!.substring(0, params.creator!.length - 1) +
                    String.fromCharCode(
                        params.creator!.codeUnitAt(params.creator!.length - 1) +
                            1)
                : null,
          )
          // .orderBy('date_created', descending: true)
          .snapshots();

      final entries = _postSnapshot
          .asyncMap<List<Future<Map<String, dynamic>>>>((snapshot) =>
              snapshot.docs.map((doc) async {
                final _commentList = await _commentsRef
                    .where('post_ref', isEqualTo: doc.reference)
                    .orderBy('date_created')
                    .get();

                List<Map<String, dynamic>> comments = _commentList.docs
                    .map((_comment) => _comment.data()
                      ..addEntries({'id': _comment.id}.entries))
                    .toList();

                return doc.data()
                  ..addEntries({'comments': comments, 'id': doc.id}.entries);
              }).toList());

      return entries.asyncMap((snap) async {
        List<Post> _posts = [];
        for (var item in snap) {
          final _post = await item.then((value) => PostModel.fromJson(value));
          _posts.add(_post);
        }
        return _posts;
      });
    } catch (e) {
      log(e.toString());
      throw (ServerException());
    }
  }
}
