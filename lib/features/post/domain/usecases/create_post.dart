import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class CreatePost implements UseCase<void, PostModel> {
  final PostRepository repository;

  CreatePost({required this.repository});

  @override
  Future<Either<Failure, void>> call(PostModel post) async {
    return await repository.createPost(post);
  }
}
