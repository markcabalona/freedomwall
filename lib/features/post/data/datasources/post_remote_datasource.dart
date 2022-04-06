import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cron/cron.dart';
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
  Future<Stream<PostModel>> getPostById(String postId);

  Future<void> createContent(CreateModel post);

  Future<Stream<List<Post>>> streamPosts(Params params);

  Future<void> likeDislikeContent(PostActionsParams params);

  Future<List<Tuple3<String, String, String>>> getAllTitlesAndCreators();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  final Cron _cron = Cron();
  final BehaviorSubject _specificPostStreamCtrl =
      BehaviorSubject<dynamic>.seeded(const []);
  WebSocketChannel? _postsWebsocket;
  WebSocketChannel? _specificPostWebsocket;

  PostRemoteDataSourceImpl({
    required this.client,
  }){
    _keepAlive();
  }

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
  Future<Stream<PostModel>> getPostById(String postId) async {
    try {
      await _postsWebsocket?.sink.close();
      await _specificPostWebsocket?.sink.close();

      _specificPostWebsocket =
          WebSocketChannel.connect(Uri.parse("${websocketUrl}ws/post/$postId"));
        _specificPostWebsocket!.sink.add("Fetch post");

      _specificPostStreamCtrl.addStream(_specificPostWebsocket!.stream);

      return _specificPostStreamCtrl.stream.asyncMap<PostModel>((event) {
        Map<String, dynamic> _json;
        try {
          _json = jsonDecode(event);
        } catch (e) {
          rethrow;
        }

        return PostModel.fromJson(_json);
      }).handleError((e) {
        log(e.toString());
      });
    } catch (e) {
      throw (ServerException());
    }
  }

  @override
  Future<Stream<List<PostModel>>> streamPosts(Params params) async {
    try {
      BehaviorSubject _streamCtrl = BehaviorSubject<dynamic>.seeded(const []);
      //always close last websocket connecton
      await _postsWebsocket?.sink.close();
      await _specificPostWebsocket?.sink.close();
      //open a new websocket connection
      _postsWebsocket = WebSocketChannel.connect(Uri.parse(
          "${websocketUrl}ws?creator=${params.creator ?? ""}&title=${params.title ?? ""}"));
      _postsWebsocket!.sink.add("Fetch posts");

      _streamCtrl.addStream(_postsWebsocket!.stream);

      return _streamCtrl.asyncMap<List<PostModel>>((event) {
        List json;
        try {
          json = jsonDecode(event);
        } catch (e) {
          rethrow;
        }

        final items = List<PostModel>.generate(
            json.length, (index) => PostModel.fromJson(json[index]));

        return items;
      }).handleError((error) {
        log(error.toString());
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
        var post = PostModel.fromJson(jsonDecode(result.body));
        log("Likes: ${post.likes} || Dislikes : ${post.dislikes}");
        return post;
      } else {
        throw (ServerException());
      }
    }).onError((error, stackTrace) => throw (ServerException()));
  }

  void _keepAlive(){
    log("Keeping websockets alive");
    _cron.schedule(Schedule.parse("*/30 * * * * *"), () {
      log("Packet sent");
      _postsWebsocket?.sink.add("keep-alive");
      _specificPostWebsocket?.sink.add("keep-alive");
    });
  }

  @override
  Future<List<Tuple3<String, String, String>>> getAllTitlesAndCreators() {
    // TODO: implement getAllTitlesAndCreators
    throw UnimplementedError();
  }
}
