import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class GetPostById implements UseCase<Post, int> {
  final PostRepository repository;

  GetPostById({required this.repository});

  @override
  Future<Either<Failure, Post>> call(int postId) async {
    return await repository.getPostById(postId);
  }
}
