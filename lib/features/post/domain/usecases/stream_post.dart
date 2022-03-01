import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class StreamPosts implements UseCase<Stream<List<Post>>, void> {
  final PostRepository repository;

  StreamPosts({required this.repository});

  @override
  Future<Either<Failure, Stream<List<Post>>>> call(_) async {
    return await repository.streamPosts();
  }
}

