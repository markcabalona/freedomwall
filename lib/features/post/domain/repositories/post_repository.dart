// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure,Stream<List<Post>>>> streamPosts();

  Future<Either<Failure, Post>> getPostById(int postId);

  Future<Either<Failure, List<Post>>> getPosts({String? creator, String? title});
  
  Future<Either<Failure, Post>> createPost(PostCreateModel post);
}
