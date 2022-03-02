// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:freedomwall/core/error/exceptions.dart';
import 'package:freedomwall/features/post/data/models/comment_model.dart';
import 'package:freedomwall/features/post/domain/entities/comment.dart';
import 'package:freedomwall/features/post/data/datasources/constants.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class PostRemoteDataSource {
  Future<PostModel> getPostById(int postId);

  Future<List<PostModel>> getPosts({String? creator, String? title});

  Future<void> createPost(PostModel post);

  Future<Stream<List<Post>>> streamPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  final WebSocketChannel channel;
  BehaviorSubject? _postStreamController;

  PostRemoteDataSourceImpl({
    required this.channel,
    required this.client,
  });

  @override
  Future<void> createPost(PostModel post) {
    return http
        .post(Uri.parse(apiUrl + 'post/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(post.toJson))
        .then((result) => {
              if (result.statusCode != HttpStatus.created)
                throw (ServerException())
            })
        .onError((error, stackTrace) => throw (ServerException()));
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
      if (_postStreamController == null) {
        _postStreamController = BehaviorSubject<dynamic>.seeded(const []);
        _postStreamController!.addStream(channel.stream);
      }

      // broadcastStreaming allows stream-listener/ subscriber to cancel subscription and re-subscribe
      return _postStreamController!
          .asBroadcastStream()
          .asyncMap<List<PostModel>>((event) {
        log(event);
        List json = jsonDecode(event);

        log(json.last.keys.toString());

        return List<PostModel>.generate(
            json.length, (index) => PostModel.fromJson(json[index]));
      });
    } catch (e) {
      log(e.toString());
      throw (ServerException());
    }
  }
}
