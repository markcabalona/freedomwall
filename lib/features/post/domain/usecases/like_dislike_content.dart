import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/domain/entities/content.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class LikeDislikeContent implements UseCase<Content, CreateModel> {
  final PostRepository repository;

  LikeDislikeContent({required this.repository});

  @override
  Future<Either<Failure, Content>> call(CreateModel post) async {
    return await repository.createContent(post);
  }
}
