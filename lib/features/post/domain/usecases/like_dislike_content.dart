import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class LikeDislikeContent implements UseCase<void, PostActionsParams> {
  final PostRepository repository;

  LikeDislikeContent({required this.repository});

  @override
  Future<Either<Failure, void>> call(PostActionsParams action) async {
    return await repository.likeDislikeContent(action);
  }
}

class PostActionsParams {
  final ParamsAction action;
  final String postId;

  const PostActionsParams({
    required this.postId,
    required this.action,
  });
}

enum ParamsAction {
  like,
  unLike,
  dislike,
  unDislike,
}
