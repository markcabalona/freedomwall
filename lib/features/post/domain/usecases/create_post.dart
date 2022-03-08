import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class CreatePost implements UseCase<Post, PostCreateModel> {
  final PostRepository repository;

  CreatePost({required this.repository});

  @override
  Future<Either<Failure, Post>> call(PostCreateModel post) async {
    return await repository.createPost(post);
  }
}
