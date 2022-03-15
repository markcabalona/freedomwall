import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/domain/entities/content.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/usecases/like_dislike_content.dart';

abstract class PostRepository {
  Future<Either<Failure, Stream<List<Post>>>> streamPosts();

  Future<Either<Failure, Post>> getPostById(int postId);

  Future<Either<Failure, List<Post>>> getPosts(
      {String? creator, String? title});

  Future<Either<Failure, Content>> createContent(CreateModel post);

  Future<Either<Failure, Post>> likeDislikeContent(PostActionsParams action);
}
