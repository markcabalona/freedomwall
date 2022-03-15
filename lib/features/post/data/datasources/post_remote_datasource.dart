import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/exceptions.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/data/models/comment_model.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/data/datasources/constants.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/usecases/like_dislike_content.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class PostRemoteDataSource {
  Future<PostModel> getPostById(int postId);

  Future<Either<PostModel, CommentModel>> createContent(CreateModel post);

  Future<Stream<List<Post>>> streamPosts(Params params);

  Future<PostModel> likeDislikeContent(PostActionsParams params);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  // final WebSocketChannel channel;
  BehaviorSubject? _allPostStreamCtrl;
  WebSocketChannel? _filteredPostWebsocket;

  PostRemoteDataSourceImpl({
    // required this.channel,
    required this.client,
  });

  @override
  Future<Either<PostModel, CommentModel>> createContent(CreateModel post) {
    String _endPoint = "post/";

    if (post is CommentCreateModel) {
      _endPoint += "${post.postId}/comment";
    }
    final json = http
        .post(Uri.parse(apiUrl + _endPoint),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(post.toJson))
        .then((result) {
      return result;
    }).onError((error, stackTrace) => throw (ServerException()));

    return json.then((_json) {
      if (_json.statusCode == HttpStatus.created) {
        if (post is CommentCreateModel) {
          return Right(CommentModel.fromJson(jsonDecode(_json.body)));
        } else {
          return Left(PostModel.fromJson(jsonDecode(_json.body)));
        }
      } else {
        throw (ServerException());
      }
    });
  }

  @override
  Future<PostModel> getPostById(int postId) {
    return client.get(
      Uri.parse(apiUrl + "post/$postId/"),
      headers: {"Content-Type": "application/json"},
    ).then((result) {
      if (result.statusCode == HttpStatus.ok) {
        return PostModel.fromJson(jsonDecode(result.body));
      } else {
        throw (ServerException());
      }
    }).onError((error, stackTrace) => throw (ServerException()));
  }

  @override
  Future<Stream<List<PostModel>>> streamPosts(Params params) async {
    try {
      // Open only one connection for all posts
      if (_allPostStreamCtrl == null) {
        final allPostsWebsocket =
            WebSocketChannel.connect(Uri.parse("ws://localhost:8000/ws"));
        allPostsWebsocket.sink.add("fetch all posts");
        _allPostStreamCtrl = BehaviorSubject<dynamic>.seeded(const []);
        _allPostStreamCtrl!.addStream(allPostsWebsocket.stream);
      }

      // _streamCtrl.stream will be returned from this function
      BehaviorSubject _streamCtrl = _allPostStreamCtrl!;

      // always close last filtered websocket connection
      if (_filteredPostWebsocket != null) {
        _filteredPostWebsocket!.sink.close();
        _filteredPostWebsocket = null;
      }

      // open websocket connection for filtered posts
      if (params.creator != null || params.title != null) {
        _filteredPostWebsocket = WebSocketChannel.connect(Uri.parse(
            "ws://localhost:8000/ws?creator=${params.creator ?? ""}&title=${params.title ?? ""}"));
        _filteredPostWebsocket!.sink.add("fetch filtered posts");
        BehaviorSubject _filteredPostStreamCtrl =
            BehaviorSubject<dynamic>.seeded(const []);
        _filteredPostStreamCtrl.addStream(_filteredPostWebsocket!.stream);

        // _streamCtrl.stream will be returned
        _streamCtrl = _filteredPostStreamCtrl;
      }

      return _streamCtrl.asyncMap<List<PostModel>>((event) {
        List json = jsonDecode(event);
        final items = List<PostModel>.generate(
            json.length, (index) => PostModel.fromJson(json[index]));

        return items;
      }).handleError((e) {
        log(e.toString());
      });
    } catch (e) {
      log(e.toString());
      throw (ServerException());
    }
  }

  @override
  Future<PostModel> likeDislikeContent(PostActionsParams params) {
    String _endPoint = "post/${params.postId}?action=";
    switch (params.action) {
      case ParamsAction.like:
        _endPoint += "likes%2B%2B";
        break;
      case ParamsAction.unLike:
        _endPoint += "likes--";
        break;
      case ParamsAction.dislike:
        _endPoint += "dislikes%2B%2B";
        break;
      case ParamsAction.unDislike:
        _endPoint += "dislikes--";
        break;
      default:
    }
    return http.put(
      Uri.parse(apiUrl + _endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((result) {
      if (result.statusCode == HttpStatus.accepted) {
        var _ = PostModel.fromJson(jsonDecode(result.body));
        log("Likes: ${_.likes} || Dislikes : ${_.dislikes}");
        return _;
      } else {
        throw (ServerException());
      }
    }).onError((error, stackTrace) => throw (ServerException()));
  }
}
