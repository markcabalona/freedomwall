import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class LikeDislikeContent implements UseCase<Post, PostActionsParams> {
  final PostRepository repository;

  LikeDislikeContent({required this.repository});

  @override
  Future<Either<Failure, Post>> call(PostActionsParams action) async {
    return await repository.likeDislikeContent(action);
  }
}

class PostActionsParams {
  final ParamsAction action;
  final int postId;

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
