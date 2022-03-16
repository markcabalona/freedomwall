import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/domain/entities/content.dart';
import 'package:freedomwall/core/error/exceptions.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/data/datasources/post_remote_datasource.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/domain/entities/comment.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';
import 'package:freedomwall/features/post/domain/usecases/like_dislike_content.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Stream<Post>>> getPostById(int postId) async {
    try {
      return Right(await remoteDataSource.getPostById(postId));
    } on ServerException {
      return Left(
        ServerFailure(message: "Post with ID: $postId not found."),
      );
    }
  }

  @override
  Future<Either<Failure, Content>> createContent(CreateModel post) async {
    try {
      final content = remoteDataSource.createContent(post).then(
            (content) => content.fold(
              (post) => Post(
                id: post.id,
                creator: post.creator,
                title: post.title,
                content: post.content,
                comments: post.comments,
                likes: post.likes,
                dislikes: post.dislikes,
                dateCreated: post.dateCreated,
              ),
              (comment) => Comment(
                id: comment.id,
                postId: comment.postId,
                creator: comment.creator,
                content: comment.content,
                dateCreated: comment.dateCreated,
                likes: comment.likes,
                dislikes: comment.dislikes,
              ),
            ),
          );

      return Right(await content);
    } on ServerException {
      return const Left(ServerFailure(message: "Server Failure"));
    }
  }

  @override
  Future<Either<Failure, Stream<List<Post>>>> streamPosts(Params params) async {
    try {
      return Right(await remoteDataSource.streamPosts(params));
    } on ServerException {
      return const Left(ServerFailure(message: "Server Failure"));
    }
  }

  @override
  Future<Either<Failure, Post>> likeDislikeContent(
      PostActionsParams action) async {
    try {
      return Right(await remoteDataSource.likeDislikeContent(action));
    } on ServerException {
      return const Left(ServerFailure(message: "Server Failure"));
    }
  }
}
