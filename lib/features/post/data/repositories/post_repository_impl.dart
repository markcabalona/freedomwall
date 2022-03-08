import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/exceptions.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/features/post/data/datasources/post_remote_datasource.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Post>>> getPosts(
      {String? creator, String? title}) async {
    try {
      return Right(
          await remoteDataSource.getPosts(creator: creator, title: title));
    } on ServerException {
      return const Left(ServerFailure(message: "Server Failure"));
    }
  }

  @override
  Future<Either<Failure, Post>> getPostById(int postId) async {
    try {
      return Right(await remoteDataSource.getPostById(postId));
    } on ServerException {
      return Left(
        ServerFailure(message: "Post with ID: $postId not found."),
      );
    }
  }

  @override
  Future<Either<Failure, Post>> createPost(PostCreateModel post) async {
    try {
      return Right(await remoteDataSource.createPost(post));
    } on ServerException {
      return const Left(ServerFailure(message: "Server Failure"));
    }
  }

  @override
  Future<Either<Failure, Stream<List<Post>>>> streamPosts() async {
    try {
      return Right(await remoteDataSource.streamPosts());
    } on ServerException {
      return const Left(ServerFailure(message: "Server Failure"));
    }
  }


}
