import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/exceptions.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/data/datasources/firebase_datasource.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';
import 'package:freedomwall/features/post/domain/usecases/like_dislike_content.dart';

class PostRepositoryImpl implements PostRepository {
  final FirebaseDatasource remoteDataSource;

  PostRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Stream<Post>>> getPostById(String postId) async {
    try {
      return Right(await remoteDataSource.getPostById(postId));
    } on ServerException {
      return Left(
        ServerFailure(message: "Post with ID: $postId not found."),
      );
    }
  }

  @override
  Future<Either<Failure, void>> createContent(CreateModel post) async {
    try {
      final content = remoteDataSource.createContent(post);
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
  Future<Either<Failure, void>> likeDislikeContent(
      PostActionsParams action) async {
    try {
      return Right(await remoteDataSource.likeDislikeContent(action));
    } on ServerException {
      return const Left(ServerFailure(message: "Server Failure"));
    }
  }
}
