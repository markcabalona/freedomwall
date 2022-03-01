import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class GetPosts implements UseCase<List<Post>, Params> {
  final PostRepository repository;

  GetPosts({required this.repository});

  @override
  Future<Either<Failure, List<Post>>> call(Params params) async {
    return await repository.getPosts(
        creator: params.creator, title: params.title);
  }
}

class Params {
  final String? creator;
  final String? title;

  Params({this.creator, this.title});
}
