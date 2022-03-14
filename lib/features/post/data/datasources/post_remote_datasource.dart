import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/exceptions.dart';
import 'package:freedomwall/features/post/data/models/comment_model.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/data/datasources/constants.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class PostRemoteDataSource {
  Future<PostModel> getPostById(int postId);

  Future<List<PostModel>> getPosts({String? creator, String? title});

  Future<Either<PostModel, CommentModel>> createContent(CreateModel post);

  Future<Stream<List<Post>>> streamPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  final WebSocketChannel channel;
  BehaviorSubject? _allPostStreamController;

  PostRemoteDataSourceImpl({
    required this.channel,
    required this.client,
  });

  @override
  Future<Either<PostModel, CommentModel>> createContent(CreateModel post) {
    String _endPoint = "postCreate/";

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
  Future<List<PostModel>> getPosts({String? creator, String? title}) {
    return client.get(
      Uri.parse(apiUrl + "post/?creator=${creator ?? ""}&title=${title ?? ""}"),
      headers: {"Content-Type": "application/json"},
    ).then((result) {
      if (result.statusCode == HttpStatus.ok) {
        List<dynamic> json = jsonDecode(result.body);
        return List<PostModel>.generate(
          json.length,
          (index) => PostModel.fromJson(json[index]),
        );
      } else {
        throw (ServerException());
      }
    }).onError((error, stackTrace) => throw (ServerException()));
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
  Future<Stream<List<PostModel>>> streamPosts() async {
    try {
      channel.sink.add("");
      if (_allPostStreamController == null) {
        _allPostStreamController = BehaviorSubject<dynamic>.seeded(const []);
        _allPostStreamController!.addStream(channel.stream);
      }

      return _allPostStreamController!.asyncMap<List<PostModel>>((event) {
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
}
